From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Jul 2017 17:03:32 -0700
Message-Id: <1500422614-94821-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 0/2] x86: Implement fast refcount overflow protection
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This series implements a fast refcount overflow protection for x86, which is
needed to provide coverage for the several refcount-overflow use-after-free
flaws the kernel has seen over the last many years. For example, here are
two from 2016:

http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/

http://cyseclabs.com/page?n=02012016

Patch 1 provides support for adding additional assembly to the GEN_*_RMWcc
macros, and patch 2 does the real work. (I left Josh's Reviewed-by since
the exception handler code has remained the same.)

Here is patch 2's full commit log:


This implements refcount_t overflow protection on x86 without a noticeable
performance impact, though without the fuller checking of REFCOUNT_FULL.
This is done by duplicating the existing atomic_t refcount implementation
but with normally a single instruction added to detect if the refcount
has gone negative (i.e. wrapped past INT_MAX or below zero). When
detected, the handler saturates the refcount_t to INT_MIN / 2. With this
overflow protection, the erroneous reference release that would follow
a wrap back to zero is blocked from happening, avoiding the class of
refcount-over-increment use-after-free vulnerabilities entirely.

Only the overflow case of refcounting can be perfectly protected, since it
can be detected and stopped before the reference is freed and left to be
abused by an attacker. This implementation also notices some of the "dec
to 0 without test", and "below 0" cases. However, these only indicate that
a use-after-free may have already happened. Such notifications are likely
avoidable by an attacker that has already exploited a use-after-free
vulnerability, but it's better to have them than allow such conditions to
remain universally silent.

On first overflow detection, the refcount value is reset to INT_MIN / 2
(which serves as a saturation value), the offending process is killed,
and a report and stack trace are produced. When operations detect only
negative value results (such as changing an already saturated value),
saturation still happens but no notification is performed (since the
value was already saturated).

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

This protection is a modified version of the x86 PAX_REFCOUNT defense
from the last public patch of PaX/grsecurity, based on my understanding of
the code. Changes or omissions from the original code are mine and don't
reflect the original grsecurity/PaX code. Thanks to PaX Team for various
suggestions for improvement.


Thanks!

-Kees

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
