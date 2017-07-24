Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 24 Jul 2017 11:07:10 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170724090710.o66r5r2pwxgwor7t@gmail.com>
References: <1500855620-73004-1-git-send-email-keescook@chromium.org>
 <1500855620-73004-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500855620-73004-4-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v7 3/3] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> +config ARCH_HAS_REFCOUNT
> +     bool
> +     help
> +       An architecture selects this when it has implemented refcount_t
> +       using primitizes that provide a faster runtime at the expense
> +       of some full refcount state checks. The refcount overflow condition,
> +       however, must be retained. Catching overflows is the primary
> +       security concern for protecting against bugs in reference counts.

s/primitizes/primitives

also, the 'faster runtime' and the whole explanation reads a bit weird to me,
how about something like:

       An architecture selects this when it has implemented refcount_t
       using open coded assembly primitives that provide an optimized
       refcount_t implementation, possibly at the expense of some full
       refcount state checks of CONFIG_REFCOUNT_FULL=y.

       The refcount overflow check behavior, however, must be retained.
       Catching overflows is the primary security concern for protecting
       against bugs in reference counts.

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -55,6 +55,7 @@ config X86
>  	select ARCH_HAS_KCOV			if X86_64
>  	select ARCH_HAS_MMIO_FLUSH
>  	select ARCH_HAS_PMEM_API		if X86_64
> +	select ARCH_HAS_REFCOUNT
>  	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
>  	select ARCH_HAS_SET_MEMORY
>  	select ARCH_HAS_SG_CHAIN

Just wonderin, how was the 32-bit kernel tested?

> +/*
> + * Body of refcount error handling: in .text.unlikely, saved into CX the
> + * address of the refcount that has entered a bad state, and trigger an
> + * exception. Fixup address is back in regular execution flow in .text.

I had to read this 4 times to parse it (and even now I'm unsure whether I parsed 
it correctly) - could this explanation be transformed to simpler, more 
straightforward English?

> + */
> +#define _REFCOUNT_EXCEPTION				\
> +	".pushsection .text.unlikely\n"			\
> +	"111:\tlea %[counter], %%" _ASM_CX "\n"		\
> +	"112:\t" ASM_UD0 "\n"				\
> +	ASM_UNREACHABLE					\
> +	".popsection\n"					\
> +	"113:\n"					\
> +	_ASM_EXTABLE_REFCOUNT(112b, 113b)

Would it be technically possible to use named labels instead of these random 
numbered labels?

> +	/*
> +	 * This function has been called because either a negative refcount
> +	 * value was seen by any of the refcount functions, or a zero
> +	 * refcount value was seen by refcount_dec().
> +	 *
> +	 * If we crossed from INT_MAX to INT_MIN, the OF flag (result
> +	 * wrapped around) will be set. Additionally, seeing the refcount
> +	 * reach 0 will set the ZF flag. In each of these cases we want a
> +	 * report, since it's a boundary condition.

Small nit: 'ZF' stands for 'zero flag' - so we should either write 'zero flag' or 
'ZF' - 'ZF flag' is kind of redundant.

> +#else
> +static inline void refcount_error_report(struct pt_regs *regs,
> +					 const char *msg) { }

By now you should know that for x86 code you should not break lines in such an 
ugly fashion, right? :-)

Thanks,

	Ingo
