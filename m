Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 17 Oct 2016 13:47:21 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161017124721.GF29095@leverpostej>
References: <1476311522-15381-1-git-send-email-labbott@redhat.com>
 <1476311522-15381-5-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476311522-15381-5-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv2 4/4] arm64: dump: Add checking for writable and
 exectuable pages
To: Laura Abbott <labbott@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 12, 2016 at 03:32:02PM -0700, Laura Abbott wrote:
> +config DEBUG_WX
> +	bool "Warn on W+X mappings at boot"
> +	select ARM64_PTDUMP_CORE
> +	---help---
> +	  Generate a warning if any W+X mappings are found at boot.
> +
> +	  This is useful for discovering cases where the kernel is leaving
> +	  W+X mappings after applying NX, as such mappings are a security risk.
> +	  This check also includes UXN, which should be set on all kernel
> +	  mappings.
> +
> +	  Look for a message in dmesg output like this:
> +
> +	    arm64/mm: Checked W+X mappings: passed, no W+X pages found.
> +
> +	  or like this, if the check failed:
> +
> +	    arm64/mm: Checked W+X mappings: FAILED, <N> W+X pages found.
> +
> +	  Note that even if the check fails, your kernel is possibly
> +	  still fine, as W+X mappings are not a security hole in
> +	  themselves, what they do is that they make the exploitation
> +	  of other unfixed kernel bugs easier.
> +
> +	  There is no runtime or memory usage effect of this option
> +	  once the kernel has booted up - it's a one time check.
> +
> +	  If in doubt, say "Y".
> +
> +

Trivial nit: for consistency with the rest of the file, there should
only be one line space between options.

>  config DEBUG_SET_MODULE_RONX
>  	bool "Set loadable kernel module data as NX and text as RO"
>  	depends on MODULES
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index 8fc0957..6afd847 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -42,5 +42,13 @@ static inline int ptdump_debugfs_register(struct ptdump_info *info,
>  	return 0;
>  }
>  #endif
> +void ptdump_check_wx(void);
> +#endif /* CONFIG_ARM64_PTDUMP_CORE */

... ah, here's the missing #endif from patch 1.

Assuming that gets sorted out, this looks good to me, and works on juno,
so FWIW:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>

[...]

> +static void note_prot_uxn(struct pg_state *st, unsigned long addr)
> +{
> +	if (!st->check_wx)
> +		return;
> +
> +	if ((st->current_prot & PTE_UXN) == PTE_UXN)
> +		return;
> +
> +	WARN_ONCE(1, "arm64/mm: Found non-UXN mapping at address %p/%pS\n",
> +		  (void *)st->start_address, (void *)st->start_address);
> +
> +	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
> +}

As a future thought (I've scope-creeped this enough with the UXN check),
there are some other checks that we could add, like verifying the AP
bits don't allow user data access. That might be worth considering, with
DEBUG_WX becoming a more general kernel page table sanity check.

Thanks,
Mark.
