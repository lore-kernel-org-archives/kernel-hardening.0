From: Kees Cook <keescook@chromium.org>
Date: Mon,  8 May 2017 12:32:50 -0700
Message-Id: <1494271972-140319-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 0/2] x86/refcount: Implement fast refcount overflow protection
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This protection is a modified version of the x86 PAX_REFCOUNT
implementation from PaX/grsecurity, prior to the use of named text
sections. This speeds up the refcount_t API by duplicating the existing
atomic_t implementation with a single instruction added to detect if the
refcount has wrapped past INT_MAX (or below 0) resulting in a signed
value. With this overflow protection, the use-after-free following a
refcount_t wrap is blocked from happening, avoiding the vulnerability
entirely.

While this defense only perfectly protects the overflow case, as that
can be detected and stopped before the reference is freed and left to be
abused by an attacker, it also notices some of the "inc from 0" and "below
0" cases. However, these only indicate that a use-after-free has already
happened. Such notifications are likely avoidable by an attacker that has
already exploited a use-after-free vulnerability, but it's better to have
them than allow such conditions to remain silent.

On overflow detection (actually "negative value" detection), the refcount
value is reset to INT_MAX, the offending process is killed, and a report
is generated. This allows the system to attempt to keep operating. Another
option, though not done in this patch, would be to reset the counter to
(INT_MIN / 2) to trap all future refcount inc or dec actions, but this
would result in even legitimate uses getting blocked. Yet another option
would be to choose (INT_MAX - N) with some small N to provide some
headroom for legitimate users of the reference counter.

On the matter of races, since the entire range beyond INT_MAX but before 0
is signed, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "jns" instruction to
the regular execution flow of a copy of the regular atomic_t operations,
making this comparable to the existing atomic_t operations. The reporting
routine uses an interupt vector to trap to return back to C to do the
heavy lifting, to help keep the change in .text size minimal.

Various differences from PaX:
- based on earlier implementation prior to named text sections
- applied only to refcount_t, not atomic_t
- rebased to -next
- reorganized refcount error handler
- uses "jns" instead of "jno" to trap all negative results instead of
  just under/overflow transitions

-Kees

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
