MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180718211013.14512-3-labbott@redhat.com>
References: <20180718211013.14512-1-labbott@redhat.com> <20180718211013.14512-3-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Jul 2018 19:20:23 -0700
Message-ID: <CAGXu5jLMVey1uZB-9BkWZuVQ44c5jE2KfKp_1vN-sy5Qh6BYpg@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: Clear the stack
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 18, 2018 at 2:10 PM, Laura Abbott <labbott@redhat.com> wrote:
>
> Implementation of stackleak based heavily on the x86 version
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> Since last time: Minor style cleanups. Re-wrote check_alloca to
> correctly handle all stack types. While doing that, I also realized
> current_top_of_stack was incorrect so I fixed that as well.

Can you drop the include/linux/stackleak.h change from this series?
I've included that in the v14 in linux-next already, so that these
patches can land entirely separately in the arm64 tree (which was the
request).

Otherwise, this looks great!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/Kconfig                    |  1 +
>  arch/arm64/include/asm/processor.h    | 17 ++++++++++++++
>  arch/arm64/kernel/entry.S             |  7 ++++++
>  arch/arm64/kernel/process.c           | 32 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/Makefile           |  3 ++-
>  drivers/firmware/efi/libstub/Makefile |  3 ++-
>  include/linux/stackleak.h             |  1 +
>  7 files changed, 62 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 42c090cf0292..216d36a49ab5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -96,6 +96,7 @@ config ARM64
>         select HAVE_ARCH_MMAP_RND_BITS
>         select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>         select HAVE_ARCH_SECCOMP_FILTER
> +       select HAVE_ARCH_STACKLEAK
>         select HAVE_ARCH_THREAD_STRUCT_WHITELIST
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_ARCH_TRANSPARENT_HUGEPAGE
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index a73ae1e49200..4f3062ee22c6 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -266,5 +266,22 @@ extern void __init minsigstksz_setup(void);
>  #define SVE_SET_VL(arg)        sve_set_current_vl(arg)
>  #define SVE_GET_VL()   sve_get_current_vl()
>
> +/*
> + * For CONFIG_STACKLEAK
> + *
> + * These need to be macros because otherwise we get stuck in a nightmare
> + * of header definitions for the use of task_stack_page.
> + */
> +
> +#define current_top_of_stack()         \
> +({                                     \
> +       unsigned long _low = 0;         \
> +       unsigned long _high = 0;        \
> +                                       \
> +       current_stack_type(current, current_stack_pointer, &_low, &_high); \
> +       _high;  \
> +})
> +#define on_thread_stack()      (on_task_stack(current, current_stack_pointer, NULL, NULL))
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ASM_PROCESSOR_H */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 28ad8799406f..67d12016063d 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -431,6 +431,11 @@ tsk        .req    x28             // current thread_info
>
>         .text
>
> +       .macro  stackleak_erase
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +       bl      stackleak_erase
> +#endif
> +       .endm
>  /*
>   * Exception vectors.
>   */
> @@ -910,6 +915,7 @@ ret_fast_syscall:
>         and     x2, x1, #_TIF_WORK_MASK
>         cbnz    x2, work_pending
>         enable_step_tsk x1, x2
> +       stackleak_erase
>         kernel_exit 0
>  ret_fast_syscall_trace:
>         enable_daif
> @@ -936,6 +942,7 @@ ret_to_user:
>         cbnz    x2, work_pending
>  finish_ret_to_user:
>         enable_step_tsk x1, x2
> +       stackleak_erase
>         kernel_exit 0
>  ENDPROC(ret_to_user)
>
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index e10bc363f533..904defa36689 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -493,3 +493,35 @@ void arch_setup_new_exec(void)
>  {
>         current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
>  }
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used stackleak_check_alloca(unsigned long size)
> +{
> +       unsigned long stack_left;
> +       enum stack_type type;
> +       unsigned long current_sp = current_stack_pointer;
> +       unsigned long low, high;
> +
> +       type = current_stack_type(current, current_sp, &low, &high);
> +       BUG_ON(type == STACK_TYPE_UNKNOWN);
> +
> +       stack_left = current_sp - low;
> +
> +       if (size >= stack_left) {
> +               /*
> +                * Kernel stack depth overflow is detected, let's report that.
> +                * If CONFIG_VMAP_STACK is enabled, we can safely use BUG().
> +                * If CONFIG_VMAP_STACK is disabled, BUG() handling can corrupt
> +                * the neighbour memory. CONFIG_SCHED_STACK_END_CHECK calls
> +                * panic() in a similar situation, so let's do the same if that
> +                * option is on. Otherwise just use BUG() and hope for the best.
> +                */
> +#if !defined(CONFIG_VMAP_STACK) && defined(CONFIG_SCHED_STACK_END_CHECK)
> +               panic("alloca() over the kernel stack boundary\n");
> +#else
> +               BUG();
> +#endif
> +       }
> +}
> +EXPORT_SYMBOL(stackleak_check_alloca);
> +#endif
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
> +               $(DISABLE_STACKLEAK_PLUGIN)
>
>  KVM=../../../../virt/kvm
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index a34e9290a699..25dd2a14560d 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -20,7 +20,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)  += -I$(srctree)/scripts/dtc/libfdt
>  KBUILD_CFLAGS                  := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>                                    -D__NO_FORTIFY \
>                                    $(call cc-option,-ffreestanding) \
> -                                  $(call cc-option,-fno-stack-protector)
> +                                  $(call cc-option,-fno-stack-protector) \
> +                                  $(DISABLE_STACKLEAK_PLUGIN)
>
>  GCOV_PROFILE                   := n
>  KASAN_SANITIZE                 := n
> diff --git a/include/linux/stackleak.h b/include/linux/stackleak.h
> index b911b973d328..08420ec6b7c3 100644
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
> --
> 2.17.1
>



-- 
Kees Cook
Pixel Security
