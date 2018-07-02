Subject: Re: [PATCH] arm64: Clear the stack
References: <20180629190553.7282-1-labbott@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <9733d929-3c6a-40e1-6110-8f79975323d3@linux.com>
Date: Mon, 2 Jul 2018 16:02:01 +0300
MIME-Version: 1.0
In-Reply-To: <20180629190553.7282-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello Laura,

Thanks for your work!
Please see my comments below.

On 29.06.2018 22:05, Laura Abbott wrote:
> Implementation of stackleak based heavily on the x86 version
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> Changes since last time:
> - Minor name change in entry.S
> - Converted to use the generic interfaces so there's minimal additions.
> - Added the fast syscall path.
> - Addition of on_thread_stack and current_top_of_stack
> - Disable stackleak on hyp per suggestion
> - Added a define for check_alloca. I'm still not sure about keeping it
>   since the x86 version got reworked?
> 
> I've mostly kept this as one patch with a minimal commit text. I can
> split it up and elaborate more before final merging.
> ---
>  arch/arm64/Kconfig                    |  1 +
>  arch/arm64/include/asm/processor.h    |  9 +++++++++
>  arch/arm64/kernel/entry.S             |  7 +++++++
>  arch/arm64/kernel/process.c           | 16 ++++++++++++++++
>  arch/arm64/kvm/hyp/Makefile           |  3 ++-
>  drivers/firmware/efi/libstub/Makefile |  3 ++-
>  include/linux/stackleak.h             |  1 +
>  scripts/Makefile.gcc-plugins          |  5 ++++-
>  8 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index eb2cf4938f6d..b0221db95dc9 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -92,6 +92,7 @@ config ARM64
>  	select HAVE_ARCH_MMAP_RND_BITS
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>  	select HAVE_ARCH_SECCOMP_FILTER
> +	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 767598932549..73914fd7e142 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -248,5 +248,14 @@ void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused);
>  #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
>  #define SVE_GET_VL()	sve_get_current_vl()
>  
> +/*
> + * For stackleak

May I ask you to call it STACKLEAK here and in other places for easier grep?

> + *
> + * These need to be macros because otherwise we get stuck in a nightmare
> + * of header definitions for the use of task_stack_page.
> + */
> +#define current_top_of_stack()	(task_stack_page(current) + THREAD_SIZE)
> +#define on_thread_stack()	(on_task_stack(current, current_stack_pointer))
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ASM_PROCESSOR_H */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index ec2ee720e33e..31c9da7d401e 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
>  
>  	.text
>  
> +	.macro	stackleak_erase

Could you rename the macro to STACKLEAK_ERASE for similarity with x86?

> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	bl	stackleak_erase_kstack
> +#endif
> +	.endm
>  /*
>   * Exception vectors.
>   */
> @@ -880,6 +885,7 @@ ret_fast_syscall:
>  	and	x2, x1, #_TIF_WORK_MASK
>  	cbnz	x2, work_pending
>  	enable_step_tsk x1, x2
> +	stackleak_erase
>  	kernel_exit 0
>  ret_fast_syscall_trace:
>  	enable_daif
> @@ -906,6 +912,7 @@ ret_to_user:
>  	cbnz	x2, work_pending
>  finish_ret_to_user:
>  	enable_step_tsk x1, x2
> +	stackleak_erase
>  	kernel_exit 0
>  ENDPROC(ret_to_user)
>  
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index f08a2ed9db0d..9f0f135f8b66 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -493,3 +493,19 @@ void arch_setup_new_exec(void)
>  {
>  	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
>  }
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +#define MIN_STACK_LEFT	256
> +
> +void __used stackleak_check_alloca(unsigned long size)
> +{
> +	unsigned long sp, stack_left;
> +
> +	sp = current_stack_pointer;
> +
> +	stack_left = sp & (THREAD_SIZE - 1);
> +	BUG_ON(stack_left < MIN_STACK_LEFT ||
> +		size >= stack_left - MIN_STACK_LEFT);
> +}
> +EXPORT_SYMBOL(stackleak_check_alloca);
> +#endif

This code should be updated.
You may remember the troubles I had with MIN_STACK_LEFT:
http://openwall.com/lists/kernel-hardening/2018/05/11/12
Please see that thread where Mark Rutland and I worked out the solution.

By the way, different stacks on x86_64 have different sizes. Is it false for arm64?

> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 4313f7475333..2fabc2dc1966 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -3,7 +3,8 @@
>  # Makefile for Kernel-based Virtual Machine module, HYP part
>  #
>  
> -ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING
> +ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
> +		$(DISABLE_STACKLEAK_PLUGIN)
>  
>  KVM=../../../../virt/kvm
>  
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index a34e9290a699..25dd2a14560d 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
>  KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>  				   -D__NO_FORTIFY \
>  				   $(call cc-option,-ffreestanding) \
> -				   $(call cc-option,-fno-stack-protector)
> +				   $(call cc-option,-fno-stack-protector) \
> +				   $(DISABLE_STACKLEAK_PLUGIN)
>  
>  GCOV_PROFILE			:= n
>  KASAN_SANITIZE			:= n
> diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
> index e2da99b3a191..00d62b302efb 100644
> --- a/include/linux/stackleak.h
> +++ b/include/linux/stackleak.h
> @@ -5,6 +5,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/task_stack.h>
>  
> +#include <asm/stacktrace.h>
>  /*
>   * Check that the poison value points to the unused hole in the
>   * virtual memory map for your platform.
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index a535742a1c06..972ce4ca7f6a 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -37,11 +37,14 @@ ifdef CONFIG_GCC_PLUGINS
>  
>    gcc-plugin-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= stackleak_plugin.so
>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK)	+= -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-min-size=$(CONFIG_STACKLEAK_TRACK_MIN_SIZE)
> +  ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +    DISABLE_STACKLEAK_PLUGIN		+= -fplugin-arg-stackleak_plugin-disable
> +  endif
>  
>    GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
>  
>    export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
> -  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
> +  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN DISABLE_STACKLEAK_PLUGIN
>  
>    ifneq ($(PLUGINCC),)
>      # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
> 
