References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486747005-15973-2-git-send-email-ard.biesheuvel@linaro.org>
From: Marc Zyngier <marc.zyngier@arm.com>
Message-ID: <d578fb88-0af1-9161-fb6c-cc524a3ec7ea@arm.com>
Date: Fri, 10 Feb 2017 17:26:52 +0000
MIME-Version: 1.0
In-Reply-To: <1486747005-15973-2-git-send-email-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/4] arm: kvm: move kvm_vgic_global_state out of .text
 section
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, kernel-hardening@lists.openwall.com, andre.przywara@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 10/02/17 17:16, Ard Biesheuvel wrote:
> The kvm_vgic_global_state struct contains a static key which is
> written to by jump_label_init() at boot time. So in preparation of
> making .text regions truly (well, almost truly) read-only, mark
> kvm_vgic_global_state __ro_after_init so it moves to the .rodata
> section instead.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
> 

I guess that's a nice way to find out if someone is playing with this
structure (which indeed shouldn't change once KVM has initialized).

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
