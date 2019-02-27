Date: Wed, 27 Feb 2019 11:44:07 +0100
From: Solar Designer <solar@openwall.com>
Subject: Re: [PATCH 1/3] x86/asm: Pin sensitive CR0 bits
Message-ID: <20190227104407.GA18804@openwall.com>
References: <20190226233647.28547-1-keescook@chromium.org> <20190226233647.28547-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226233647.28547-2-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 26, 2019 at 03:36:45PM -0800, Kees Cook wrote:
>  static inline void native_write_cr0(unsigned long val)
>  {
> -	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
> +	bool warn = false;
> +
> +again:
> +	val |= X86_CR0_WP;
> +	/*
> +	 * In order to have the compiler not optimize away the check
> +	 * in the WARN_ONCE(), mark "val" as being also an output ("+r")

This comment is now slightly out of date: the check is no longer "in the
WARN_ONCE()".  Ditto about the comment for CR4.

> +	 * by this asm() block so it will perform an explicit check, as
> +	 * if it were "volatile".
> +	 */
> +	asm volatile("mov %0,%%cr0": "+r" (val) : "m" (__force_order) : );
> +	/*
> +	 * If the MOV above was used directly as a ROP gadget we can
> +	 * notice the lack of pinned bits in "val" and start the function
> +	 * from the beginning to gain the WP bit for sure. And do it
> +	 * without first taking the exception for a WARN().
> +	 */
> +	if ((val & X86_CR0_WP) != X86_CR0_WP) {
> +		warn = true;
> +		goto again;
> +	}
> +	WARN_ONCE(warn, "Attempt to unpin X86_CR0_WP, cr0 bypass attack?!\n");
>  }

Alexander
