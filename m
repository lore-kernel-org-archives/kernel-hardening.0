Date: Tue, 25 Apr 2017 12:23:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170425102337.ocdi2v7ivue7x7cc@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421220939.GA65363@beast>
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, davem@davemloft.net, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
> +static __always_inline void refcount_inc(refcount_t *r)
> +{
> +	asm volatile(LOCK_PREFIX "incl %0\n\t"
> +		REFCOUNT_CHECK_OVERFLOW(4)
> +		: [counter] "+m" (r->refs.counter)
> +		: : "cc", "cx");
> +}
> +
> +static __always_inline void refcount_dec(refcount_t *r)
> +{
> +	asm volatile(LOCK_PREFIX "decl %0\n\t"
> +		REFCOUNT_CHECK_UNDERFLOW(4)
> +		: [counter] "+m" (r->refs.counter)
> +		: : "cc", "cx");
> +}

> +dotraplinkage void do_refcount_error(struct pt_regs *regs, long error_code)
> +{
> +	const char *str = NULL;
> +
> +	BUG_ON(!(regs->flags & X86_EFLAGS_OF));
> +
> +#define range_check(size, direction, type, value) \
> +	if ((unsigned long)__##size##_##direction##_start <= regs->ip && \
> +	    regs->ip < (unsigned long)__##size##_##direction##_end) { \
> +		*(type *)regs->cx = value; \
> +		str = #size " " #direction; \
> +	}
> +
> +	range_check(refcount,   overflow,  int, INT_MAX)
> +	range_check(refcount,   underflow, int, INT_MIN)
> +
> +#undef range_check
> +
> +	BUG_ON(!str);
> +	do_error_trap(regs, error_code, (char *)str, X86_REFCOUNT_VECTOR,
> +		      SIGILL);
> +}
> +#endif


So what avoids this:

	CPU0				CPU1


	lock inc %[val]; # 0x7fffffff
	jo  2f
1:	...

					lock dec %[val]; # 0x80000000
					jo  2f
				1:	...




2:	mov $0x7fffffff, %[val]
	jmp 1b

				2:	mov $0x80000000, %[val]
					jmp 1b




	~~~~//~~~~


	lock inc %val; #0x80000000
	....

	lock inc %val; 0xffffffff
	lock inc %val; 0x00000000
