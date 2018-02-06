Date: Tue, 6 Feb 2018 13:39:06 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCHv2 05/12] arm64: Don't trap host pointer auth use to EL2
Message-ID: <20180206123906.GZ21802@cbox>
References: <20171127163806.31435-1-mark.rutland@arm.com>
 <20171127163806.31435-6-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127163806.31435-6-mark.rutland@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On Mon, Nov 27, 2017 at 04:37:59PM +0000, Mark Rutland wrote:
> To allow EL0 (and/or EL1) to use pointer authentication functionality,
> we must ensure that pointer authentication instructions and accesses to
> pointer authentication keys are not trapped to EL2 (where we will not be
> able to handle them).

...on non-VHE systems, presumably?

> 
> This patch ensures that HCR_EL2 is configured appropriately when the
> kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
> ensuring that EL1 can access keys and permit EL0 use of instructions.
> For VHE kernels, EL2 access is controlled by EL3, and we need not set
> anything.


for VHE kernels host EL0 (TGE && E2H) is unaffected by these settings,
and it doesn't matter how we configure HCR_EL2.{API,APK}.

(Because you do actually set these bits when the features are present if
I read the code correctly).


> 
> This does not enable support for KVM guests, since KVM manages HCR_EL2
> itself.

        (...when running VMs.)


Besides the nits:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_arm.h |  2 ++
>  arch/arm64/kernel/head.S         | 19 +++++++++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 7f069ff37f06..62854d5d1d3b 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -23,6 +23,8 @@
>  #include <asm/types.h>
>  
>  /* Hyp Configuration Register (HCR) bits */
> +#define HCR_API		(UL(1) << 41)
> +#define HCR_APK		(UL(1) << 40)
>  #define HCR_E2H		(UL(1) << 34)
>  #define HCR_ID		(UL(1) << 33)
>  #define HCR_CD		(UL(1) << 32)
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 67e86a0f57ac..06a96e9af26b 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -415,10 +415,25 @@ CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
>  
>  	/* Hyp configuration. */
>  	mov	x0, #HCR_RW			// 64-bit EL1
> -	cbz	x2, set_hcr
> +	cbz	x2, 1f
>  	orr	x0, x0, #HCR_TGE		// Enable Host Extensions
>  	orr	x0, x0, #HCR_E2H
> -set_hcr:
> +1:
> +#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
> +	/*
> +	 * Disable pointer authentication traps to EL2. The HCR_EL2.{APK,API}
> +	 * bits exist iff at least one authentication mechanism is implemented.
> +	 */
> +	mrs	x1, id_aa64isar1_el1
> +	mov_q	x3, ((0xf << ID_AA64ISAR1_GPI_SHIFT) | \
> +		     (0xf << ID_AA64ISAR1_GPA_SHIFT) | \
> +		     (0xf << ID_AA64ISAR1_API_SHIFT) | \
> +		     (0xf << ID_AA64ISAR1_APA_SHIFT))
> +	and	x1, x1, x3
> +	cbz	x1, 1f
> +	orr	x0, x0, #(HCR_APK | HCR_API)
> +1:
> +#endif
>  	msr	hcr_el2, x0
>  	isb
>  
> -- 
> 2.11.0
> 
