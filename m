Date: Thu, 21 Feb 2019 09:33:07 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2] x86/asm: Pin sensitive CR4 bits
Message-ID: <20190221173307.GB7019@linux.intel.com>
References: <20190220180934.GA46255@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220180934.GA46255@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jann Horn <jannh@google.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 10:09:34AM -0800, Kees Cook wrote:
> Several recent exploits have used direct calls to the native_write_cr4()
> function to disable SMEP and SMAP before then continuing their exploits
> using userspace memory access. This pins bits of cr4 so that they cannot
> be changed through a common function. This is not intended to be general
> ROP protection (which would require CFI to defend against properly), but
> rather a way to avoid trivial direct function calling (or CFI bypassing
> via a matching function prototype) as seen in:
> 
> https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html
> (https://github.com/xairy/kernel-exploits/tree/master/CVE-2017-7308)
> 
> The goals of this change:
>  - pin specific bits (SMEP, SMAP, and UMIP) when writing cr4.
>  - avoid setting the bits too early (they must become pinned only after
>    first being used).
>  - pinning mask needs to be read-only during normal runtime.
>  - pinning needs to be rechecked after set to avoid jumps into the middle
>    of the function.
> 
> Using __ro_after_init on the mask is done so it can't be first disabled
> with a malicious write. And since it becomes read-only, we must avoid
> writing to it later (hence the check for bits already having been set
> instead of unconditionally writing to the mask).
> 
> The use of volatile is done to force the compiler to perform a full reload
> of the mask after setting cr4 (to protect against just jumping into the
> function past where the masking happens; we must check that the mask was
> applied after we do the set). Due to how this function can be built by the
> compiler (especially due to the removal of frame pointers), jumping into
> the middle of the function frequently doesn't require stack manipulation
> to construct a stack frame (there may only a retq without pops, which is
> sufficient for use with exploits like timer overwrites mentioned above).
> 
> For example, without the recheck, the function may appear as:
> 
>    native_write_cr4:
>       mov [pin], %rbx
>       or  %rbx, %rdi
>    1: mov %rdi, %cr4
>       retq
> 
> The masking "or" could be trivially bypassed by just calling to label "1"
> instead of "native_write_cr4". (CFI will force calls to only be able to
> call into native_write_cr4, but CFI and CET are uncommon currently.)
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2: fix think-o in cr4_pin recheck (Jann Horn)
> ---
>  arch/x86/include/asm/special_insns.h | 11 +++++++++++
>  arch/x86/kernel/cpu/common.c         | 12 +++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
> index 43c029cdc3fe..4c26004ed5d4 100644
> --- a/arch/x86/include/asm/special_insns.h
> +++ b/arch/x86/include/asm/special_insns.h
> @@ -72,9 +72,20 @@ static inline unsigned long native_read_cr4(void)
>  	return val;
>  }
>  
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

Printing what bits diverged would be helpful in the unlikely event that the
WARN_ONCE triggers.  "cr4 bypass attempt" is probably only meaningful to
people that are already familiar with the code, e.g.:

	if (WARN_ONCE((val & cr4_pin) != cr4_pin,
	    "Attempt to unpin cr4 bits: %lx, cr4 bypass attack?!", ~val & cr4_pin))


> +		goto again;
>  }
>  
>  #ifdef CONFIG_X86_64
