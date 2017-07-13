MIME-Version: 1.0
In-Reply-To: <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com> <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 13 Jul 2017 07:58:50 +0100
Message-ID: <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and detect out-of-bounds SP
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, akashi.takahiro@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On 12 July 2017 at 23:33, Mark Rutland <mark.rutland@arm.com> wrote:
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> ---
>  arch/arm64/Kconfig        |  1 +
>  arch/arm64/kernel/entry.S | 43 +++++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/traps.c | 21 +++++++++++++++++++++
>  3 files changed, 65 insertions(+)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b2024db..5cbd961 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1,5 +1,6 @@
>  config ARM64
>         def_bool y
> +       select HAVE_ARCH_VMAP_STACK
>         select ACPI_CCA_REQUIRED if ACPI
>         select ACPI_GENERIC_GSI if ACPI
>         select ACPI_GTDT if ACPI
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 7c8b164..e0fdb65 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -396,11 +396,54 @@ el1_error_invalid:
>         inv_entry 1, BAD_ERROR
>  ENDPROC(el1_error_invalid)
>
> +#ifdef CONFIG_VMAP_STACK
> +.macro detect_bad_stack
> +       msr     sp_el0, x0
> +       get_thread_info x0
> +       ldr     x0, [x0, #TSK_TI_CUR_STK]
> +       sub     x0, sp, x0
> +       and     x0, x0, #~(THREAD_SIZE - 1)
> +       cbnz    x0, __bad_stack
> +       mrs     x0, sp_el0

The typical prologue looks like

stp x29, x30, [sp, #-xxx]!
stp x27, x28, [sp, #xxx]
...
mov x29, sp

which means that in most cases where we do run off the stack, sp will
still be pointing into it when the exception is taken. This means we
will fault recursively in the handler before having had the chance to
accurately record the exception context.

Given that the max displacement of a store instruction is 512 bytes,
and that the frame size we are about to stash exceeds that, should we
already consider it a stack fault if sp is within 512 bytes (or
S_FRAME_SIZE) of the base of the stack?

> +.endm
> +
> +__bad_stack:
> +       /*
> +        * Stash the bad SP, and free up another GPR. We no longer care about
> +        * EL0 state, since this thread cannot recover.
> +        */
> +       mov     x0, sp
> +       msr     tpidrro_el0, x0
> +       msr     tpidr_el0, x1
> +
> +       /* Move to the emergency stack */
> +       adr_this_cpu    x0, bad_stack, x1
> +       mov     x1, #THREAD_START_SP
> +       add     sp, x0, x1
> +
> +       /* Restore GPRs and log them to pt_regs */
> +       mrs     x0, sp_el0
> +       mrs     x1, tpidr_el0
> +       kernel_entry 1
> +
> +       /* restore the bad SP to pt_regs */
> +       mrs     x1, tpidrro_el0
> +       str     x1, [sp, #S_SP]
> +
> +       /* Time to die */
> +       mov     x0, sp
> +       b       handle_bad_stack
> +#else
> +.macro detect_bad_stack
> +.endm
> +#endif
> +
>  /*
>   * EL1 mode handlers.
>   */
>         .align  6
>  el1_sync:
> +       detect_bad_stack
>         kernel_entry 1
>         mrs     x1, esr_el1                     // read the syndrome register
>         lsr     x24, x1, #ESR_ELx_EC_SHIFT      // exception class
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 0805b44..84b00e3 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -683,6 +683,27 @@ asmlinkage void bad_el0_sync(struct pt_regs *regs, int reason, unsigned int esr)
>         force_sig_info(info.si_signo, &info, current);
>  }
>
> +#ifdef CONFIG_VMAP_STACK
> +DEFINE_PER_CPU(unsigned long [IRQ_STACK_SIZE/sizeof(long)], bad_stack) __aligned(16);
> +

Surely, we don't need a 16 KB or 64 KB stack here?

> +asmlinkage void handle_bad_stack(struct pt_regs *regs)
> +{
> +       unsigned long tsk_stk = (unsigned long)current->stack;
> +       unsigned long irq_stk = (unsigned long)per_cpu(irq_stack, smp_processor_id());
> +
> +       console_verbose();
> +       pr_emerg("Stack out-of-bounds!\n"
> +                "\tsp: 0x%016lx\n"
> +                "\ttsk stack: [0x%016lx..0x%016lx]\n"
> +                "\tirq stack: [0x%016lx..0x%016lx]\n",
> +                kernel_stack_pointer(regs),
> +                tsk_stk, tsk_stk + THREAD_SIZE,
> +                irq_stk, irq_stk + THREAD_SIZE);
> +       show_regs(regs);
> +       panic("stack out-of-bounds");
> +}
> +#endif
> +
>  void __pte_error(const char *file, int line, unsigned long val)
>  {
>         pr_err("%s:%d: bad pte %016lx.\n", file, line, val);
> --
> 1.9.1
>
