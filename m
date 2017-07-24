From: Kees Cook <keescook@chromium.org>
Date: Sun, 23 Jul 2017 17:20:17 -0700
Message-Id: <1500855620-73004-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 0/3] x86: Implement fast refcount overflow protection
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This series implements a fast refcount overflow protection for x86,
which is needed to provide coverage for the several refcount-overflow
use-after-free flaws the kernel has seen over the last many years.

Patch 1 provides support for adding additional assembly to the GEN_*_RMWcc
macros, patch 2 adds a new ASM_UNREACHABLE suggested by Josh, and patch 3
does the real work. (I left Josh's Reviewed-by since the exception handler
code has remained the same.)

Patch 3's full commit log:


This implements refcount_t overflow protection on x86 without a noticeable
performance impact, though without the fuller checking of REFCOUNT_FULL.
This is done by duplicating the existing atomic_t refcount implementation
but with normally a single instruction added to detect if the refcount
has gone negative (e.g. wrapped past INT_MAX or below zero). When detected,
the handler saturates the refcount_t to INT_MIN / 2. With this overflow
protection, the erroneous reference release that would follow a wrap back
to zero is blocked from happening, avoiding the class of refcount-overflow
use-after-free vulnerabilities entirely.

Only the overflow case of refcounting can be perfectly protected, since
it can be detected and stopped before the reference is freed and left to
abused by an attacker. There isn't a way to block early decrements,
and while REFCOUNT_FULL stops increment-from-zero cases (which would
be the state _after_ an early decrement and stops potential double-free
conditions), this fast implementation does not, since it would require
the more expensive cmpxchg loops. Since the overflow case is much more
common (e.g. missing a "put" during an error path), this protection
provides real-world protection. For example, the two public refcount
overflow use-after-free exploits published in 2016 would have been
rendered unexploitable:

http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/

http://cyseclabs.com/page?n=02012016

This implementation does, however, notice an unchecked decement to zero
(i.e. caller used refcount_dec() instead of refcount_dec_and_test() and it
resulted in a zero). Decrements under zero are noticed (since they will
have resulted in a negative value), though this only indicates that a
use-after-free may have already happened. Such notifications are likely
avoidable by an attacker that has already exploited a use-after-free
vulnerability, but it's better to have them reported than allow such
conditions to remain universally silent.

On first overflow detection, the refcount value is reset to INT_MIN / 2
(which serves as a saturation value) and a report and stack trace are
produced. When operations detect only negative value results (such as
changing an already saturated value), saturation still happens but no
notification is performed (since the value was already saturated).

On the matter of races, since the entire range beyond INT_MAX but before
0 is negative, every operation at INT_MIN / 2 will trap, leaving no
overflow-only race condition.

As for performance, this implementation adds a single "js" instruction
to the regular execution flow of a copy of the standard atomic_t refcount
operations. (The non-"and_test" refcount_dec() function, which is uncommon
in regular refcount design patterns, has an additional "jz" instruction
to detect reaching exactly zero.) Since this is a forward jump, it is by
default the non-predicted path, which will be reinforced by dynamic branch
prediction. The result is this protection having virtually no measurable
change in performance over standard atomic_t operations. The error path,
located in .text.unlikely, saves the refcount location and then uses UD0
to fire a refcount exception handler, which resets the refcount, handles
reporting, and returns to regular execution. This keeps the changes to
.text size minimal, avoiding return jumps and open-coded calls to the
error reporting routine.

Example assembly comparison:

refcount_inc before
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)

refcount_inc after
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)
ffffffff8154614d:       0f 88 80 d5 17 00       js     ffffffff816c36d3
...
.text.unlikely:
ffffffff816c36d3:       48 8d 4d f4             lea    -0xc(%rbp),%rcx
ffffffff816c36d7:       0f ff                   (bad)

These are the cycle counts comparing a loop of refcount_inc() from 1
to INT_MAX and back down to 0 (via refcount_dec_and_test()), between
unprotected refcount_t (atomic_t), fully protected REFCOUNT_FULL
(refcount_t-full), and this overflow-protected refcount (refcount_t-fast):

2147483646 refcount_inc()s and 2147483647 refcount_dec_and_test()s:
			cycles	protections
atomic_t	   82249267387	none
refcount_t-fast    82211446892	overflow, untested dec-to-zero
refcount_t-full   144814735193	overflow, untested dec-to-zero, inc-from-zero
    
This code is a modified version of the x86 PAX_REFCOUNT atomic_t
overflow defense from the last public patch of PaX/grsecurity, based
on my understanding of the code. Changes or omissions from the original
code are mine and don't reflect the original grsecurity/PaX code. Thanks
to PaX Team for various suggestions for improvement for repurposing this
code to be a refcount-only protection.
    

Thanks!

-Kees

v7:
- add unreachable annotation; josh
- improve inc/add_not_zero code
- drop process killing (either we catch it or we don't)
- refactor error report into WARN

v6:
- use single saturation value (INT_MIN / 2)
- detect refcount_dec() to zero and saturate

v5:
- add unchecked atomic_t implementation when !CONFIG_REFCOUNT_FULL
- use "leal" again, as in v3 for more flexible reset handling
- provide better underflow detection, with saturation

v4:
- switch to js from jns to gain static branch prediction benefits
- use .text.unlikely for js target, effectively making handler __cold
- use UD0 with refcount exception handler instead of int 0x81
- Kconfig defaults on when arch has support

v3:
- drop named text sections until we need to distinguish sizes/directions
- reset value immediately instead of passing back to handler
- drop needless export; josh

v2:
- fix instruction pointer decrement bug; thejh
- switch to js; pax-team
- improve commit log
