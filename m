From: Kees Cook <keescook@chromium.org>
Date: Tue,  9 May 2017 12:01:21 -0700
Message-Id: <1494356483-81678-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v4 0/2] x86/refcount: Implement fast refcount overflow protection
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This protection is a modified version of the x86 PAX_REFCOUNT defense
from PaX/grsecurity. This speeds up the refcount_t API by duplicating
the existing atomic_t implementation with a single instruction added to
detect if the refcount has wrapped past INT_MAX (or below 0) resulting
in a negative value, where the handler then restores the refcount_t to
INT_MAX. With this overflow protection, the use-after-free following a
refcount_t wrap is blocked from happening, avoiding the vulnerability
entirely.

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
keep operating. Another option, though not done in this patch, would be
to reset the counter to (INT_MIN / 2) to trap all future refcount inc
or dec actions, but this would result in even legitimate uses getting
blocked. Yet another option would be to choose (INT_MAX - N) with some
small N to provide some headroom for legitimate users of the reference
counter.

On the matter of races, since the entire range beyond INT_MAX but before 0
is negative, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "js" instruction to
the regular execution flow of a copy of the regular atomic_t operations.
Since this is a forward jump, it is by default the non-predicted path,
which will be reinforced by dynamic branch prediction. The result is this
protection having no measurable change in performance over standard
atomic_t operations. The error path, located in .text.unlikely, uses
UD0 to fire a refcount exception handler, which reports and returns to
regular execution. This keeps the changes to .text size minimal, avoiding
return jumps and open-coded calls to the error reporting routine.

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
ffffffff816c36d3:       c7 45 f4 ff ff ff 7f    movl   $0x7fffffff,-0xc(%rbp)   
ffffffff816c36da:       0f ff                   (bad)

Various differences from PaX:
- uses earlier value reset implementation in assembly
- uses UD0 and refcount exception handler instead of new int vector
- uses .text.unlikely instead of custom named text sections
- applied only to refcount_t, not atomic_t (single size, only overflow)
- reorganized refcount error handler
- uses "js" instead of "jo" to trap all negative results instead of
  just under/overflow transitions

-Kees

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
