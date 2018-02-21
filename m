Date: Wed, 21 Feb 2018 14:24:43 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC v8 1/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
Message-ID: <20180221132443.GA9989@pd.tnic>
References: <1518804657-24905-1-git-send-email-alex.popov@linux.com>
 <1518804657-24905-2-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1518804657-24905-2-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 16, 2018 at 09:10:52PM +0300, Alexander Popov wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 63bf349..62748bd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -119,6 +119,7 @@ config X86
>  	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> +	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> index 16c2c02..4a7365a 100644
> --- a/arch/x86/entry/entry_32.S
> +++ b/arch/x86/entry/entry_32.S
> @@ -77,6 +77,90 @@
>  #endif
>  .endm
>  
> +.macro erase_kstack
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	call erase_kstack

Hmm, why do we need a macro *and* a function of the same name? Why not do

	call erase_kstack

everywhere we need to?

And then do

ENTRY(erase_kstack)
#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
	...

to tone down the ifdeffery.

> +#endif
> +.endm
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +ENTRY(erase_kstack)
> +	pushl	%edi
> +	pushl	%ecx
> +	pushl	%eax
> +	pushl	%ebp
> +
> +	movl	PER_CPU_VAR(current_task), %ebp
> +	mov	TASK_lowest_stack(%ebp), %edi

So instead of TASK_lowest_stack and adding all the ifdeffery around, why
not do this computation:

	(unsigned long)task_stack_page(p) + 2 * sizeof(unsigned long);

in asm?

You only need task->stack as an offset variable. And other code might
need it too, anyway so you could just as well use it instead of adding
another var to thread_struct.

/me reads further.

Ah. So this lowest_stack thing changes at the end:

	"Set the lowest_stack value to the top_of_stack - 256"

Why?

So that magic needs more explanation for slow people like me.

> +	mov	$STACKLEAK_POISON, %eax
> +	std
> +
> +	/*
> +	 * Let's search for the poison value in the stack.
> +	 * Start from the lowest_stack and go to the bottom (see std above).

Let's write insns capitalized: "see STD above".

...

> +	/*
> +	 * Check that some further qwords contain poison. If so, the part
> +	 * of the stack below the address in %rdi is likely to be poisoned.
> +	 * Otherwise we need to search deeper.
> +	 */
> +	mov	$STACKLEAK_POISON_CHECK_DEPTH / 8, %ecx
> +	repe	scasq
> +	jecxz	2f	/* Poison the upper part of the stack */
> +	jne	1b	/* Search deeper */
> +
> +2:

You could name that label

.Lpoison

and make the code more readable:

	jb	.Lpoison

and so on.

> +	/*
> +	 * Two qwords at the bottom of the thread stack are reserved and
> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
> +	 */
> +	or	$2 * 8, %rdi
> +
> +	/*
> +	 * Check whether we are on the thread stack to prepare the counter
> +	 * for stack poisoning.
> +	 */
> +	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rcx
> +	sub	%rsp, %rcx
> +	cmp	$THREAD_SIZE_asm, %rcx
> +	jb	3f
> +
> +	/*
> +	 * We are not on the thread stack, so we can write poison between
> +	 * the address in %rdi and the stack top.
> +	 */
> +	mov	PER_CPU_VAR(cpu_current_top_of_stack), %rcx
> +	sub	%rdi, %rcx
> +	jmp	4f
> +
> +3:
> +	/*
> +	 * We are on the thread stack, so we can write poison between the
> +	 * address in %rdi and the address in %rsp (not included, used memory).
> +	 */
> +	mov	%rsp, %rcx
> +	sub	%rdi, %rcx
> +
> +4:
> +	/* Check that the counter value is sane */
> +	cmp	$THREAD_SIZE_asm, %rcx
> +	jb	5f
> +	ud2
> +
> +5:
> +	/*
> +	 * So let's write the poison value to the kernel stack. Start from the
> +	 * address in %rdi and move up (see cld).
> +	 */
> +	cld
> +	shr	$3, %ecx
> +	rep	stosq

Hohumm, that's >2K loops per syscall here and stack is

0xffffc90000008010:     0xffffffffffff4111      0xffffffffffff4111
0xffffc90000008020:     0xffffffffffff4111      0xffffffffffff4111
0xffffc90000008030:     0xffffffffffff4111      0xffffffffffff4111
0xffffc90000008040:     0xffffffffffff4111      0xffffffffffff4111
0xffffc90000008050:     0xffffffffffff4111      0xffffffffffff4111
0xffffc90000008060:     0xffffffffffff4111      0xffffffffffff4111
...

> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index 9eb448c..6dc55f6 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -281,6 +281,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
>  	p->thread.sp = (unsigned long) fork_frame;
>  	p->thread.io_bitmap_ptr = NULL;
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
> +						2 * sizeof(unsigned long);
> +#endif
> +
>  	savesegment(gs, p->thread.gsindex);
>  	p->thread.gsbase = p->thread.gsindex ? 0 : me->thread.gsbase;
>  	savesegment(fs, p->thread.fsindex);
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index e835fc0..fe04f60 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -337,4 +337,10 @@ unsigned long read_word_at_a_time(const void *addr)
>  	compiletime_assert(__native_word(t),				\
>  		"Need native word sized stores/loads for atomicity.")
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +/* Poison value points to the unused hole in the virtual memory map */

There are a bunch of those there now. Please document it in
Documentation/x86/x86_64/mm.txt

> +# define STACKLEAK_POISON -0xBEEF
> +# define STACKLEAK_POISON_CHECK_DEPTH 128
> +#endif
> +
>  #endif /* __LINUX_COMPILER_H */
> -- 
> 2.7.4
> 

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
