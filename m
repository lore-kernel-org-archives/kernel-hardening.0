Date: Mon, 13 Feb 2017 17:58:15 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170213175815.GB16636@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-2-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486844586-26135-2-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 1/5] arm: kvm: move kvm_vgic_global_state out of .text
 section
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, Suzuki.Poulose@arm.com, james.morse@arm.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2017 at 08:23:02PM +0000, Ard Biesheuvel wrote:
> The kvm_vgic_global_state struct contains a static key which is
> written to by jump_label_init() at boot time. So in preparation of
> making .text regions truly (well, almost truly) read-only, mark
> kvm_vgic_global_state __ro_after_init so it moves to the .rodata
> section instead.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

With this applied I can boot Juno happily and launch working VMs.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  virt/kvm/arm/vgic/vgic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 6440b56ec90e..2f373455ed4e 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -29,7 +29,9 @@
>  #define DEBUG_SPINLOCK_BUG_ON(p)
>  #endif
>  
> -struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif = STATIC_KEY_FALSE_INIT,};
> +struct vgic_global kvm_vgic_global_state __ro_after_init = {
> +	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
> +};
>  
>  /*
>   * Locking order is always:
> -- 
> 2.7.4
> 
