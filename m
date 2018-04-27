Date: Fri, 27 Apr 2018 11:52:05 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCHv3 04/11] arm64: Don't trap host pointer auth use to EL2
Message-ID: <20180427095205.GJ13249@C02W217FHV2R.local>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-5-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417183735.56985-5-mark.rutland@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, marc.zyngier@arm.com, catalin.marinas@arm.com, awallis@codeaurora.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ramana.radhakrishnan@arm.com, kvmarm@lists.cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 17, 2018 at 07:37:28PM +0100, Mark Rutland wrote:
> To allow EL0 (and/or EL1) to use pointer authentication functionality,
> we must ensure that pointer authentication instructions and accesses to
> pointer authentication keys are not trapped to EL2.
> 
> This patch ensures that HCR_EL2 is configured appropriately when the
> kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
> ensuring that EL1 can access keys and permit EL0 use of instructions.
> For VHE kernels host EL0 (TGE && E2H) is unaffected by these settings,
> and it doesn't matter how we configure HCR_EL2.{API,APK}, so we don't
> bother setting them.
> 
> This does not enable support for KVM guests, since KVM manages HCR_EL2
> itself when running VMs.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu

FWIW: Acked-by: Christoffer Dall <christoffer.dall@arm.com>

> ---
>  arch/arm64/include/asm/kvm_arm.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 89b3dda7e3cb..4d57e1e58323 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -23,6 +23,8 @@
>  #include <asm/types.h>
>  
>  /* Hyp Configuration Register (HCR) bits */
> +#define HCR_API		(UL(1) << 41)
> +#define HCR_APK		(UL(1) << 40)
>  #define HCR_TEA		(UL(1) << 37)
>  #define HCR_TERR	(UL(1) << 36)
>  #define HCR_TLOR	(UL(1) << 35)
> @@ -86,7 +88,7 @@
>  			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
>  			 HCR_FMO | HCR_IMO)
>  #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
> -#define HCR_HOST_NVHE_FLAGS (HCR_RW)
> +#define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>  
>  /* TCR_EL2 Registers bits */
> -- 
> 2.11.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
