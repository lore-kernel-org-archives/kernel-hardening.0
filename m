Date: Wed, 20 Feb 2019 19:48:59 +0100
From: Solar Designer <solar@openwall.com>
Subject: Re: [PATCH v2] x86/asm: Pin sensitive CR4 bits
Message-ID: <20190220184859.GA6429@openwall.com>
References: <20190220180934.GA46255@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220180934.GA46255@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jann Horn <jannh@google.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 10:09:34AM -0800, Kees Cook wrote:
> +extern volatile unsigned long cr4_pin;
> +
>  static inline void native_write_cr4(unsigned long val)
>  {
> +again:
> +	val |= cr4_pin;
>  	asm volatile("mov %0,%%cr4": : "r" (val), "m" (__force_order));
> +	/*
> +	 * If the MOV above was used directly as a ROP gadget we can
> +	 * notice the lack of pinned bits in "val" and start the function
> +	 * from the beginning to gain the cr4_pin bits for sure.
> +	 */
> +	if (WARN_ONCE((val & cr4_pin) != cr4_pin, "cr4 bypass attempt?!\n"))
> +		goto again;
>  }

I think "goto again" is too mild a response given that it occurs after a
successful write of a non-pinned value to CR4.  I think it'd allow some
exploits to eventually win the race: make their desired use of whatever
functionality SMEP, etc. would have prevented - which may be just a few
instructions they need to run - before the CR4 value is reverted after
"goto again".  I think it's one of those cases where a kernel panic
would be more appropriate.

Also, WARN_ONCE possibly introduces a delay sufficient to realistically
win this race on the first try.  If we choose to warn, we should do it
after having reverted the CR4 value, not before.

Alexander
