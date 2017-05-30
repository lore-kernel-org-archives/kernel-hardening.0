From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 May 2017 14:39:49 -0700
Message-Id: <1496180392-98718-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 0/3] Implement fast refcount overflow protection
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

A new patch has been added at the start of this series to make the default
refcount_t implementation just use an unchecked atomic_t implementation,
since many kernel subsystems want to be able to opt out of the full
validation, since it includes a small performance overhead. When enabling
CONFIG_REFCOUNT_FULL, the full validation is used.

The other two patches provide overflow protection on x86 without incurring
a performance penalty. The changelog for patch 3 is reproduced here for
details:

This protection is a modified version of the x86 PAX_REFCOUNT defense
from PaX/grsecurity. This speeds up the refcount_t API by duplicating
the existing atomic_t implementation with a single instruction added to
detect if the refcount has wrapped past INT_MAX (or below 0) resulting
in a negative value, where the handler then restores the refcount_t to
INT_MAX or saturates to INT_MIN / 2. With this overflow protection, the
use-after-free following a refcount_t wrap is blocked from happening,
avoiding the vulnerability entirely.

While this defense only perfectly protects the overflow case, as that
can be detected and stopped before the reference is freed and left to be
abused by an attacker, it also notices some of the "inc from 0" and "below
0" cases. However, these only indicate that a use-after-free has already
happened. Such notifications are likely avoidable by an attacker that has
already exploited a use-after-free vulnerability, but it's better to have
them than allow such conditions to remain universally silent.

On overflow detection (actually "negative value" detection), the refcount
value is reset to INT_MAX, the offending process is killed, and a report
and stack trace are generated. This allows the system to attempt to
keep operating. In the case of a below-zero decrement or other negative
value results, the refcount is saturated to INT_MIN / 2 to keep it from
reaching zero again. (For the INT_MAX reset, another option would be to
choose (INT_MAX - N) with some small N to provide some headroom for
legitimate users of the reference counter.)

On the matter of races, since the entire range beyond INT_MAX but before 0
is negative, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "js" instruction to
the regular execution flow of a copy of the regular atomic_t operations.
Since this is a forward jump, it is by default the non-predicted path,
which will be reinforced by dynamic branch prediction. The result is
this protection having no measurable change in performance over standard
atomic_t operations. The error path, located in .text.unlikely, saves
the refcount location and then uses UD0 to fire a refcount exception
handler, which resets the refcount, reports the error, marks the process
to be killed, and returns to regular execution. This keeps the changes to
.text size minimal, avoiding return jumps and open-coded calls to the
error reporting routine.
    
Assembly comparison:
    
atomic_inc
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)
    
refcount_inc
.text:
ffffffff81546149:       f0 ff 45 f4             lock incl -0xc(%rbp)
ffffffff8154614d:       0f 88 80 d5 17 00       js     ffffffff816c36d3
...
.text.unlikely:
ffffffff816c36d3:       48 8d 4d f4             lea    -0xc(%rbp),%rcx
ffffffff816c36d7:       0f ff                   (bad)

Thanks to PaX Team for various suggestions for improvement.


-Kees

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
- extract rmwcc macro helpers for better readability
- implemented checks in inc_not_zero interface
- adjusted reset values
