Date: Mon, 14 Aug 2017 16:32:53 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20170814153253.GA22747@arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
 <1502130965-18710-15-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502130965-18710-15-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 14/14] arm64: add VMAP_STACK overflow detection
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Just some minor comments on this (after taking ages to realise you were
using tpidr_el0 as a temporary rather than tpidr_el1 and getting totally
confused!).

On Mon, Aug 07, 2017 at 07:36:05PM +0100, Mark Rutland wrote:
> This patch adds stack overflow detection to arm64, usable when vmap'd stacks
> are in use.
> 
> Overflow is detected in a small preamble executed for each exception entry,
> which checks whether there is enough space on the current stack for the general
> purpose registers to be saved. If there is not enough space, the overflow
> handler is invoked on a per-cpu overflow stack. This approach preserves the
> original exception information in ESR_EL1 (and where appropriate, FAR_EL1).
> 
> Task and IRQ stacks are aligned to double their size, enabling overflow to be
> detected with a single bit test. For example, a 16K stack is aligned to 32K,
> ensuring that bit 14 of the SP must be zero. On an overflow (or underflow),
> this bit is flipped. Thus, overflow (of less than the size of the stack) can be
> detected by testing whether this bit is set.
> 
> The overflow check is performed before any attempt is made to access the
> stack, avoiding recursive faults (and the loss of exception information
> these would entail). As logical operations cannot be performed on the SP
> directly, the SP is temporarily swapped with a general purpose register
> using arithmetic operations to enable the test to be performed.

[...]

> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index c5cd2c5..1a025b7 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -133,6 +133,8 @@
>  
>  #define IRQ_STACK_SIZE		THREAD_SIZE
>  
> +#define OVERFLOW_STACK_SIZE	SZ_4K
> +
>  /*
>   * Alignment of kernel segments (e.g. .text, .data).
>   */
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index 92ddb6d..ee19563 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -57,6 +57,22 @@ static inline bool on_task_stack(struct task_struct *tsk, unsigned long sp)
>  	return (low <= sp && sp < high);
>  }
>  
> +#ifdef CONFIG_VMAP_STACK
> +DECLARE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
> +
> +#define OVERFLOW_STACK_PTR() ((unsigned long)this_cpu_ptr(overflow_stack) + OVERFLOW_STACK_SIZE)
> +
> +static inline bool on_overflow_stack(unsigned long sp)
> +{
> +	unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);

Can you use raw_cpu_ptr here, like you do for the irq stack?

> +	unsigned long high = low + OVERFLOW_STACK_SIZE;
> +
> +	return (low <= sp && sp < high);
> +}
> +#else
> +static inline bool on_overflow_stack(unsigned long sp) { return false; }
> +#endif
> +
>  /*
>   * We can only safely access per-cpu stacks from current in a non-preemptible
>   * context.
> @@ -69,6 +85,8 @@ static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp
>  		return false;
>  	if (on_irq_stack(sp))
>  		return true;
> +	if (on_overflow_stack(sp))
> +		return true;

I find the "return false" clause in this function makes it fiddly to
read because it's really predicating all following conditionals on current
&& !preemptible, but I haven't got any better ideas :(

>  	return false;
>  }
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e5aa866..44a27c3 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -72,6 +72,37 @@
>  	.macro kernel_ventry	label
>  	.align 7
>  	sub	sp, sp, #S_FRAME_SIZE
> +#ifdef CONFIG_VMAP_STACK
> +	add	sp, sp, x0			// sp' = sp + x0
> +	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
> +	tbnz	x0, #THREAD_SHIFT, 0f
> +	sub	x0, sp, x0			// sp' - x0' = (sp + x0) - sp = x0
> +	sub	sp, sp, x0			// sp' - x0 = (sp + x0) - x0 = sp
> +	b	\label
> +
> +	/* Stash the original SP value in tpidr_el0 */
> +0:	msr	tpidr_el0, x0

The comment here is a bit confusing, since the sp has already been
decremented for the frame, as mention in a later comment.

> +
> +	/* Recover the original x0 value and stash it in tpidrro_el0 */
> +	sub	x0, sp, x0
> +	msr	tpidrro_el0, x0
> +
> +	/* Switch to the overflow stack */
> +	adr_this_cpu sp, overflow_stack + OVERFLOW_STACK_SIZE, x0
> +
> +	/*
> +	 * Check whether we were already on the overflow stack. This may happen
> +	 * after panic() re-enables interrupts.
> +	 */
> +	mrs	x0, tpidr_el0			// sp of interrupted context
> +	sub	x0, sp, x0			// delta with top of overflow stack
> +	tst	x0, #~(OVERFLOW_STACK_SIZE - 1)	// within range?
> +	b.ne	__bad_stack			// no? -> bad stack pointer
> +
> +	/* We were already on the overflow stack. Restore sp/x0 and carry on. */
> +	sub	sp, sp, x0
> +	mrs	x0, tpidrro_el0
> +#endif
>  	b	\label
>  	.endm
>  
> @@ -348,6 +379,34 @@ ENTRY(vectors)
>  #endif
>  END(vectors)
>  
> +#ifdef CONFIG_VMAP_STACK
> +	/*
> +	 * We detected an overflow in kernel_ventry, which switched to the
> +	 * overflow stack. Stash the exception regs, and head to our overflow
> +	 * handler.
> +	 */
> +__bad_stack:
> +	/* Restore the original x0 value */
> +	mrs	x0, tpidrro_el0
> +
> +	/*
> +	 * Store the original GPRs to the new stack. The orginial SP (minus

original

> +	 * S_FRAME_SIZE) was stashed in tpidr_el0 by kernel_ventry.
> +	 */
> +	sub	sp, sp, #S_FRAME_SIZE
> +	kernel_entry 1
> +	mrs	x0, tpidr_el0
> +	add	x0, x0, #S_FRAME_SIZE
> +	str	x0, [sp, #S_SP]
> +
> +	/* Stash the regs for handle_bad_stack */
> +	mov	x0, sp
> +
> +	/* Time to die */
> +	bl	handle_bad_stack
> +	ASM_BUG()

Why not just a b without the ASM_BUG?

Will
