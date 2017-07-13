Date: Thu, 13 Jul 2017 11:35:23 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170713103522.GC3966@e103592.cambridge.arm.com>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
 <20170712144424.19528-11-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712144424.19528-11-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [RFC PATCH 10/10] arm64: kernel: add support for virtually
 mapped stacks
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 12, 2017 at 03:44:23PM +0100, Ard Biesheuvel wrote:
> Add code that checks whether an exception taken from EL1 was caused
> by a faulting stack access before proceeding to save the interrupted
> context to the stack.
> 
> This involves checking whether the faulting address coincides with the
> guard page below the task stack of 'current'. This uses tpidrro_el0 and
> sp_el0 as scratch registers, so we can free up a couple of general
> purpose registers for use in the code that performs this check. If it
> turns out we are dealing with a stack overflow, switch to a special
> per-CPU overflow stack so we can at least call panic().
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/thread_info.h |  2 +
>  arch/arm64/kernel/entry.S            | 49 ++++++++++++++++++++
>  arch/arm64/mm/fault.c                |  9 ++++
>  4 files changed, 61 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b52db8bb1270..50caf63099c8 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -73,6 +73,7 @@ config ARM64
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> +	select HAVE_ARCH_VMAP_STACK
>  	select HAVE_ARM_SMCCC
>  	select HAVE_EBPF_JIT
>  	select HAVE_C_RECORDMCOUNT
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 46c3b93cf865..1c3e0a3bf87a 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -32,6 +32,8 @@
>  #define THREAD_SIZE		16384
>  #define THREAD_START_SP		(THREAD_SIZE - 16)
>  
> +#define OVERFLOW_STACK_SIZE	1024
> +

How was this number chosen?

Kernel stack overflow is not going to get routinely tested -- after all
it should only get exercised when things go horribly wrong.

So, if the panic code (or compiler-generated stack frames) become
bloated enough, we will silently overrun this limit.

Maybe it doesn't matter if we trash a load of unrelated percpu data when
we panic.


>  #ifndef __ASSEMBLY__
>  
>  struct task_struct;
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 2ba3185b1c78..4c3e82d6e2f2 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -392,6 +392,20 @@ ENDPROC(el1_error_invalid)
>   */
>  	.align	6
>  el1_sync:
> +#ifdef CONFIG_VMAP_STACK
> +	/*
> +	 * When taking an exception from EL1, we need to check whether it is
> +	 * caused by a faulting out-of-bounds access to the virtually mapped
> +	 * stack before we can attempt to preserve the interrupted context.
> +	 */
> +	msr	tpidrro_el0, x0			// stash x0
> +	mrs	x0, far_el1			// get faulting address
> +	tbnz	x0, #63, .Lcheck_stack_ovf	// check if not user address
> +
> +.Lcheck_stack_resume:
> +	mrs	x0, tpidrro_el0			// restore x0
> +#endif
> +

Unless I'm missing something, this leaves tpidrr0_el0 trashed (and
containing kernel data that userspace can subsequently read).

This could be solved by moving the tpidrro_el0 load out of context
switch and into ret_to_user.

[...]

Cheers
---Dave
