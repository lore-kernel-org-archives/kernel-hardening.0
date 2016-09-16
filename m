Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Sep 2016 12:33:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160916113325.GB21702@leverpostej>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <1473788797-10879-6-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473788797-10879-6-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v3 5/7] arm64: Handle faults caused by inadvertent user
 access with PAN enabled
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 13, 2016 at 06:46:35PM +0100, Catalin Marinas wrote:
> When TTBR0_EL1 is set to the reserved page, an erroneous kernel access
> to user space would generate a translation fault. This patch adds the
> checks for the software-set PSR_PAN_BIT to emulate a permission fault
> and report it accordingly.

Why do we need to treat this case as a permission fault? It looks like a
fault that wasn't a deliberate uaccess (which thus doesn't have a fixup
handler) should have do_page_fault call __do_kernel_fault, where we
should die().

Is this just for more consistent reporting of erroneous accesses to user
memory? Or does this fix some other issue?

> This patch also updates the description of the synchronous external
> aborts on translation table walks.

This sounds fine, though it might be better as a separate/preparatory
patch.

> -static inline bool is_permission_fault(unsigned int esr)
> +static inline bool is_permission_fault(unsigned int esr, struct pt_regs *regs)
>  {
>  	unsigned int ec       = ESR_ELx_EC(esr);
>  	unsigned int fsc_type = esr & ESR_ELx_FSC_TYPE;
>  
> -	return (ec == ESR_ELx_EC_DABT_CUR && fsc_type == ESR_ELx_FSC_PERM) ||
> -	       (ec == ESR_ELx_EC_IABT_CUR && fsc_type == ESR_ELx_FSC_PERM);
> +	if (ec != ESR_ELx_EC_DABT_CUR && ec != ESR_ELx_EC_IABT_CUR)
> +		return false;
> +
> +	if (system_uses_ttbr0_pan())
> +		return fsc_type == ESR_ELx_FSC_FAULT &&
> +			(regs->pstate & PSR_PAN_BIT);
> +	else
> +		return fsc_type == ESR_ELx_FSC_PERM;
>  }


Since the entry code will clear the PAN bit in the SPSR when we see the
reserved ASID, faults in EFI runtime services will still be correctly
reported, though that's somewhat subtle (and it took me a while to
convince myself that was the case).

Also, I think that faults elsewhere may be misreported, e.g. in cold
entry to kernel paths (idle, hotplug) where we have a global mapping in
TTBR0, and it looks like we're using the reserved ASID.

I'm not immediately sure how to distinguish those cases.

Thanks,
Mark.
