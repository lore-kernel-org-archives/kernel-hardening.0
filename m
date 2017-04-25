From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Apr 2017 15:56:35 -0700
Message-Id: <1493160997-126108-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 0/2] x86, refcount: Implement fast refcount overflow
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This protection is a modified version of the x86 PAX_REFCOUNT
implementation from PaX/grsecurity. This speeds up the refcount_t API by
duplicating the existing atomic_t implementation with a single instruction
added to detect if the refcount has wrapped past INT_MAX (or below 0)
resulting in a signed value.

Note that this protection is only meaningful for the overflow case,
as that can be detected and stopped before the reference is freed and
left to be abused by an attacker. Catching the "inc from 0" case is
nice to have, but only indicates that a use-after-free has already
happened. Such notifications are likely avoidable by an attacker that
has already exploited a use-after-free vulnerability. With this overflow
protection, the use-after-free cannot happen in the first place, avoiding
the vulnerability entirely.

On overflow detection (actually "signed value" detection), the offending
process is killed, a report is generated, and the refcount value is reset
to INT_MAX. This allows the system to attempt to keep operating. Another
option, not done in this patch, would be to reset the counter to (INT_MIN
/ 2) to trap all future refcount inc or dec actions. Yet another option
would be to choose (INT_MAX - N) with some small N to provide some
headroom for legitimate users of the reference counter.

On the matter of races, since the entire range beyond INT_MAX but before 0
is signed, every inc will trap, leaving no overflow-only race condition.

As for performance, this implementation adds a single "js" instruction to
a copy of the regular atomic_t operations, making this comparable to the
existing atomic_t operations. The detection routine uses a combination of an
alternative section exception handler and trap to return back to C for
handling the error condition with minimal increase in text size.

Various differences from PaX:
- applied only to refcount_t, not atomic_t
- rebased to -next
- reorganized refcount error handler and section declaration locations
- uses "js" instead of "jo" to trap all signed results instead of just
  under/overflow transitions

v2:
- fix instruction pointer decrement bug; thejh
- switch to js; pax-team
- improve commit log
- extract rmwcc macro helpers for better readability
- implemented checks in inc_not_zero interface
- adjusted reset values

-Kees
