MIME-Version: 1.0
In-Reply-To: <20170726170051.28328-2-thgarnie@google.com>
References: <20170726170051.28328-1-thgarnie@google.com> <20170726170051.28328-2-thgarnie@google.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 2 Aug 2017 07:10:52 -0700
Message-ID: <CAJcbSZHq3FLvfm+7jODmqOCYOGh2ZDF8A4ZnihvkdwbMA7GGRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 2/3] arm/syscalls: Optimize address limit check
To: Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>, Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 26, 2017 at 10:00 AM, Thomas Garnier <thgarnie@google.com> wrote:
> Disable the generic address limit check in favor of an architecture
> specific optimized implementation. The generic implementation using
> pending work flags did not work well with ARM and alignment faults.
>
> The address limit is checked on each syscall return path to user-mode
> path as well as the irq user-mode return function. If the address limit
> was changed, a function is called to stop the kernel with an explicit
> message.
>
> The address limit check has to be done before any pending work because
> they can reset the address limit. For example the lkdtm address limit
> check does not work because the signal to kill the process will reset
> the user-mode address limit.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---

Russel: What do you think about this patch set?

>  arch/arm/kernel/entry-common.S | 11 +++++++++++
>  arch/arm/kernel/signal.c       |  5 +++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 0b60adf4a5d9..99c908226065 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -12,6 +12,7 @@
>  #include <asm/unistd.h>
>  #include <asm/ftrace.h>
>  #include <asm/unwind.h>
> +#include <asm/memory.h>
>  #ifdef CONFIG_AEABI
>  #include <asm/unistd-oabi.h>
>  #endif
> @@ -48,10 +49,14 @@ ret_fast_syscall:
>   UNWIND(.fnstart       )
>   UNWIND(.cantunwind    )
>         disable_irq_notrace                     @ disable interrupts
> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
> +       cmp     r2, #TASK_SIZE
> +       blne    addr_limit_check_failed
>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>         bne     fast_work_pending
>
> +
>         /* perform architecture specific actions before user return */
>         arch_ret_to_user r1, lr
>
> @@ -74,6 +79,9 @@ ret_fast_syscall:
>   UNWIND(.cantunwind    )
>         str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
>         disable_irq_notrace                     @ disable interrupts
> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
> +       cmp     r2, #TASK_SIZE
> +       blne    addr_limit_check_failed
>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>         beq     no_work_pending
> @@ -106,6 +114,9 @@ ENTRY(ret_to_user)
>  ret_slow_syscall:
>         disable_irq_notrace                     @ disable interrupts
>  ENTRY(ret_to_user_from_irq)
> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
> +       cmp     r2, #TASK_SIZE
> +       blne    addr_limit_check_failed
>         ldr     r1, [tsk, #TI_FLAGS]
>         tst     r1, #_TIF_WORK_MASK
>         bne     slow_work_pending
> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> index 5814298ef0b7..5769c15cff89 100644
> --- a/arch/arm/kernel/signal.c
> +++ b/arch/arm/kernel/signal.c
> @@ -673,3 +673,8 @@ struct page *get_signal_page(void)
>
>         return page;
>  }
> +
> +asmlinkage void addr_limit_check_failed(void)
> +{
> +       panic("Incorrect address limit while returning to user-mode.");
> +}
> --
> 2.14.0.rc0.400.g1c36432dff-goog
>



-- 
Thomas
