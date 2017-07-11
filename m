Date: Tue, 11 Jul 2017 20:51:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170711195154.GA7124@leverpostej>
References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
 <1499724283-30719-3-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499724283-30719-3-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [RFC][PATCH 2/2] arm64: Clear the stack
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Alex Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Mon, Jul 10, 2017 at 03:04:43PM -0700, Laura Abbott wrote:
> Implementation of stackleak based heavily on the x86 version

Nice!

> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> The biggest points that need review here:
> - Is the extra offsetting (subtracting/adding from the stack) correct?

I think it's a little off; more on that below.

> - Where else do we need to clear the stack?

I guess we might need to clear (all of the remainder of) the stack after
invoking EFI runtime services -- those can run in task context, might
leave sensitive values on the stack, and they're uninstrumented. The
same would apply for x86.

I think we can ignore garbage left on the stack by idle/hotplug, since
that happens in the idle thread, so we shouldn't be doing uaccess
transfers on those stacks.

> - The assembly can almost certainly be optimized. I tried to keep the
>   behavior of the x86 'repe scasq' and the like where possible. I'm also a
>   terrible register allocator.

I tried to steer clear of code golf here, but I didn't entirely manage.

I also don't know x86 asm, so it's very possible I've just managed to
confuse myself.

> ---
>  arch/arm64/Kconfig                    |  1 +
>  arch/arm64/include/asm/processor.h    |  3 ++
>  arch/arm64/kernel/asm-offsets.c       |  3 ++
>  arch/arm64/kernel/entry.S             | 92 +++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/process.c           | 18 +++++++
>  drivers/firmware/efi/libstub/Makefile |  3 +-
>  scripts/Makefile.gcc-plugins          |  5 +-
>  7 files changed, 123 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 8addb85..0b65bfc 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -17,6 +17,7 @@ config ARM64
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_SET_MEMORY
>  	select ARCH_HAS_SG_CHAIN
> +	select ARCH_HAS_STACKLEAK
>  	select ARCH_HAS_STRICT_KERNEL_RWX
>  	select ARCH_HAS_STRICT_MODULE_RWX
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 64c9e78..76f2738 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -88,6 +88,9 @@ struct thread_struct {
>  	unsigned long		fault_address;	/* fault info */
>  	unsigned long		fault_code;	/* ESR_EL1 value */
>  	struct debug_info	debug;		/* debugging */
> +#ifdef CONFIG_STACKLEAK
> +	unsigned long           lowest_stack;
> +#endif
>  };
>  
>  #ifdef CONFIG_COMPAT
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index b3bb7ef..e0a5ae2 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -43,6 +43,9 @@ int main(void)
>    DEFINE(TSK_TI_TTBR0,		offsetof(struct task_struct, thread_info.ttbr0));
>  #endif
>    DEFINE(TSK_STACK,		offsetof(struct task_struct, stack));
> +#ifdef CONFIG_STACKLEAK
> +  DEFINE(TSK_TI_LOWEST_STACK,	offsetof(struct task_struct, thread.lowest_stack));
> +#endif
>    BLANK();
>    DEFINE(THREAD_CPU_CONTEXT,	offsetof(struct task_struct, thread.cpu_context));
>    BLANK();
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index b738880..e573633 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -744,6 +744,7 @@ ENDPROC(cpu_switch_to)
>   */
>  ret_fast_syscall:
>  	disable_irq				// disable interrupts
> +	bl	erase_kstack
>  	str	x0, [sp, #S_X0]			// returned x0
>  	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
>  	and	x2, x1, #_TIF_SYSCALL_WORK
> @@ -772,6 +773,7 @@ work_pending:
>   */
>  ret_to_user:
>  	disable_irq				// disable interrupts
> +	bl	erase_kstack
>  	ldr	x1, [tsk, #TSK_TI_FLAGS]
>  	and	x2, x1, #_TIF_WORK_MASK
>  	cbnz	x2, work_pending
> @@ -865,3 +867,93 @@ ENTRY(sys_rt_sigreturn_wrapper)
>  	mov	x0, sp
>  	b	sys_rt_sigreturn
>  ENDPROC(sys_rt_sigreturn_wrapper)
> +
> +#ifdef CONFIG_STACKLEAK
> +ENTRY(erase_kstack)
> +	/* save x0 for the fast path */
> +	mov	x10, x0
> +
> +	get_thread_info	x0
> +	ldr	x1, [x0, #TSK_TI_LOWEST_STACK]
> +
> +	/* get the number of bytes to check for lowest stack */
> +	mov	x3, x1
> +	and	x3, x3, #THREAD_SIZE - 1
> +	lsr	x3, x3, #3
> +
> +	/* now generate the start of the stack */
> +	mov	x4, sp
> +	movn	x2, #THREAD_SIZE - 1
> +	and	x1, x4, x2
> +
> +	mov	x2, #-0xBEEF	/* stack poison */
> +
> +	cmp     x3, #0
> +	b.eq    4f /* Found nothing, go poison */
> +
> +1:
> +	ldr     x4, [x1, x3, lsl #3]
> +	cmp     x4, x2  /* did we find the poison? */
> +	b.eq    2f /* yes we did, go check it */
> +
> +	sub     x3, x3, #1
> +	cmp     x3, #0
> +	b.eq    4f /* Found nothing, go poison */
> +	b       1b /* loop again */
> +
> +2:

IIUC, at this point, x1 was the start (lowest addr) of the stack, and x3
was the quadword index of the first poison on that stack.

The x86 asm implicitly held that [x1, x3, lsl #3] address in RDI, but we
don't have a copy...

> +	cmp     x3, #16
> +	b.ls    4f /* Go poison if there are less than 16 things left? */
> +
> +	mov     x3, #16

... and here we blat the index without saving it, meaning we always jump
to close to the start of the stack, which I don't think was intentional.

So then we fall though to the below...

> +3:
> +	ldr     x4, [x1, x3, lsl #3]
> +	cmp     x4, x2  /* did we find the poison? */
> +	b.ne    1b /* nope we have to check deeper */
> +
> +	sub     x3, x3, #1
> +	cmp     x3, #0
> +	b.eq    4f /* Found nothing, go poison */
> +	b       3b /* loop again */

... where we either:

* find 16 contiguous poison entries, leaving x3 == 0, or:

* we immediately find a non-poison value, and jump back to 1b. If there
  are 16 non-poison values, we're left with x3 == 0, otherwise we bail
  out and jump to 4f with x3 in the interval [0,15].

.... or I've completely confused myself, as suggested above.

We might not have x86's fancy string instructions, but we could do
something equally impenetrable:

	mov	x5, #0
1:
	cbz	x3, 4f
	ldr	x4, [x1, x3, lsl #3]
	cmp	x4, x2
	csinc	x5, xzr, x5, ne
	tbz	x5, #4, 4f		// found 16 poisons?
	sub	x3, x3, #1
	b	1b

That doesn't stop 16 slots early, so it can return any value of x3 all
the way down to zero.

> +
> +	/* The poison function */
> +4:
> +	/* Generate the address we found */
> +	add     x5, x1, x3, lsl #3
> +	orr     x5, x5, #16

Have you figured out what the forced 16 byte offset is for?

I've not managed to figure out why it's there, and it looks like
Alexander couldn't either, judging by his comments in the x86 asm.

> +
> +	mov	x4, sp
> +	/* subtrace the current pointer */
> +	sub     x8, x4, x5
> +
> +	/* subtract one more so we don't touch the current sp */
> +	sub	x8, x8, #1
> +
> +	/* sanity check */
> +	cmp     x8, #THREAD_SIZE
> +	b.lo    5f
> +999:
> +	b       999b
> +
> +5:
> +	lsr     x8, x8, #3
> +	mov     x3, x8
> +6:
> +	cmp     x3, #0
> +	b.eq    7f
> +
> +	str     x2, [x1, x3, lsl #3]
> +	sub     x3, x3, #1
> +	b	6b
> +
> +	/* Reset the lowest stack to the top of the stack */
> +7:
> +	ldr	x1, [x0, TSK_STACK]
> +	add	x1, x1, #THREAD_SIZE
> +	sub	x1, x1, #256
> +	str	x1, [x0, #TSK_TI_LOWEST_STACK]

I take it this is the offsetting you were querying?

I don't think it's quite right. Our stack looks like:

+---+ <- task_stack_page(p) + THREAD_SIZE
|   |
+---+ <- task_stack_page(p) + THREAD_START_SP
|   |
|   |
+---+ <- task_pt_regs(p)
|   |
|   |
|   |
~~~~~

~~~~~
|   |
|   |
|   |
+---+ <- task_stack_page(p)

At the point we return to userspace, sp == task_pt_regs(p).

Judging by a generated asm-offsets.h, sizeof(struct_pt_regs) is 304
bytes currently. THREAD_SIZE - THREAD_START_SP == 16.

We probably want to give that 16 a mnemonic (e.g FRAME_PADDING), and
have something like:

	ldr     x1, [x0, TSK_STACK]
	add	x1, x1, #THREAD_SIZE
	sub	x1, x1, #(S_FRAME_SIZE + FRAME_PADDING)
	str	x1, [x0, #TSK_TI_LOWEST_STACK]

> +
> +	mov	x0, x10
> +	ret
> +ENDPROC(erase_kstack)
> +#endif
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 659ae80..1b6cca2 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -293,6 +293,12 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>  	p->thread.cpu_context.sp = (unsigned long)childregs;
>  
> +#ifdef CONFIG_STACKLEAK
> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
> +					2 * sizeof(unsigned long);
> +#endif

I see this follows the x86 logic, but I don't see why it's necessary to
offset this end of the stack.

Do you have an idea as to what this is for?

> +
> +
>  	ptrace_hw_copy_thread(p);
>  
>  	return 0;
> @@ -417,3 +423,15 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
>  	else
>  		return randomize_page(mm->brk, SZ_1G);
>  }
> +
> +#ifdef CONFIG_STACKLEAK
> +void __used check_alloca(unsigned long size)
> +{
> +	unsigned long sp = (unsigned long)&sp, stack_left;

Nit: please use current_stack_pointer.

Thanks,
Mark.
