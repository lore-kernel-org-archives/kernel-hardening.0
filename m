Date: Wed, 18 Apr 2018 15:19:26 +0200
From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCHv3 03/11] arm64/kvm: hide ptrauth from guests
Message-ID: <20180418131926.pbjlbcjspg7azq2j@kamzik.brq.redhat.com>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-4-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417183735.56985-4-mark.rutland@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, cdall@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 17, 2018 at 07:37:27PM +0100, Mark Rutland wrote:
> In subsequent patches we're going to expose ptrauth to the host kernel
> and userspace, but things are a bit trickier for guest kernels. For the
> time being, let's hide ptrauth from KVM guests.
> 
> Regardless of how well-behaved the guest kernel is, guest userspace
> could attempt to use ptrauth instructions, triggering a trap to EL2,
> resulting in noise from kvm_handle_unknown_ec(). So let's write up a
> handler for the PAC trap, which silently injects an UNDEF into the
> guest, as if the feature were really missing.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/kvm/handle_exit.c | 18 ++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c    |  9 +++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index e5e741bfffe1..5114ad691eae 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -173,6 +173,23 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 1;
>  }
>  
> +/*
> + * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
> + * a NOP), or guest EL1 access to a ptrauth register.
> + */
> +static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	/*
> +	 * We don't currently suport ptrauth in a guest, and we mask the ID
> +	 * registers to prevent well-behaved guests from trying to make use of
> +	 * it.
> +	 *
> +	 * Inject an UNDEF, as if the feature really isn't present.
> +	 */
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -195,6 +212,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
>  	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
> +	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
>  };
>  
>  static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 806b0b126a64..eee399c35e84 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1000,6 +1000,15 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  				    task_pid_nr(current));
>  
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> +	} else if (id == SYS_ID_AA64ISAR1_EL1) {
> +		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> +					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> +					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> +					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> +		if (val & ptrauth_mask)
> +			pr_err_once("kvm [%i]: ptrauth unsupported for guests, suppressing\n",
> +					task_pid_nr(current));

Marc just changed the equivalent SVE pr_err_once() to kvm_debug().
So we probably want to do the same here.

> +		val &= ~ptrauth_mask;
>  	} else if (id == SYS_ID_AA64MMFR1_EL1) {
>  		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
>  			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
> -- 
> 2.11.0
>

Otherwise
 
Reviewed-by: Andrew Jones <drjones@redhat.com>
