Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 20 Jul 2017 11:11:06 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170720091106.kigtr6zy7pjgk2s6@gmail.com>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500422614-94821-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v6 0/2] x86: Implement fast refcount overflow protection
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> This implements refcount_t overflow protection on x86 without a noticeable
> performance impact, though without the fuller checking of REFCOUNT_FULL.
> This is done by duplicating the existing atomic_t refcount implementation
> but with normally a single instruction added to detect if the refcount
> has gone negative (i.e. wrapped past INT_MAX or below zero). When
> detected, the handler saturates the refcount_t to INT_MIN / 2. With this
> overflow protection, the erroneous reference release that would follow
> a wrap back to zero is blocked from happening, avoiding the class of
> refcount-over-increment use-after-free vulnerabilities entirely.
> 
> Only the overflow case of refcounting can be perfectly protected, since it
> can be detected and stopped before the reference is freed and left to be
> abused by an attacker. This implementation also notices some of the "dec
> to 0 without test", and "below 0" cases. However, these only indicate that
> a use-after-free may have already happened. Such notifications are likely
> avoidable by an attacker that has already exploited a use-after-free
> vulnerability, but it's better to have them than allow such conditions to
> remain universally silent.
> 
> On first overflow detection, the refcount value is reset to INT_MIN / 2
> (which serves as a saturation value), the offending process is killed,
> and a report and stack trace are produced. When operations detect only
> negative value results (such as changing an already saturated value),
> saturation still happens but no notification is performed (since the
> value was already saturated).
> 
> On the matter of races, since the entire range beyond INT_MAX but before
> 0 is negative, every operation at INT_MIN / 2 will trap, leaving no
> overflow-only race condition.
> 
> As for performance, this implementation adds a single "js" instruction
> to the regular execution flow of a copy of the standard atomic_t refcount
> operations. (The non-"and_test" refcount_dec() function, which is uncommon
> in regular refcount design patterns, has an additional "jz" instruction
> to detect reaching exactly zero.) Since this is a forward jump, it is by
> default the non-predicted path, which will be reinforced by dynamic branch
> prediction. The result is this protection having virtually no measurable
> change in performance over standard atomic_t operations. The error path,
> located in .text.unlikely, saves the refcount location and then uses UD0
> to fire a refcount exception handler, which resets the refcount, handles
> reporting, and returns to regular execution. This keeps the changes to
> .text size minimal, avoiding return jumps and open-coded calls to the
> error reporting routine.

Pretty nice!

Could you please also create a tabulated quick-comparison of the three variants, 
of all key properties, about behavior, feature and tradeoff differences?

Something like:

				!ARCH_HAS_REFCOUNT	ARCH_HAS_REFCOUNT=y	REFCOUNT_FULL=y

avg fast path instructions:	5			3			10
behavior on overflow:		unsafe, silent		safe,   verbose		safe,   verbose
behavior on underflow:		unsafe, silent		unsafe, verbose		unsafe, verbose
...

etc. - note that this table is just a quick mockup with wild guesses. (Please add 
more comparisons of other aspects as well.)

Such a comparison would make it easier for arch, subsystem and distribution 
maintainers to decide on which variant to use/enable.

Thanks,

	Ingo
