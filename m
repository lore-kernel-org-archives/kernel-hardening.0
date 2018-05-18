Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 18 May 2018 08:53:49 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v12 2/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
Message-ID: <20180518065349.GA10080@gmail.com>
References: <1526488097-20611-1-git-send-email-alex.popov@linux.com>
 <1526488097-20611-3-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526488097-20611-3-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Alexander Popov <alex.popov@linux.com> wrote:

> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -329,8 +329,22 @@ For 32-bit we have the following conventions - kernel is built with
>  
>  #endif
>  
> +.macro ERASE_KSTACK_NOCLOBBER
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	PUSH_AND_CLEAR_REGS
> +	call erase_kstack
> +	POP_REGS
> +#endif
> +.endm
> +
>  #endif /* CONFIG_X86_64 */
>  
> +.macro ERASE_KSTACK
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	call erase_kstack
> +#endif
> +.endm

Please use a well-organized, common, visually easy to ignore namespace.

For example:

	STACKLEAK_ERASE_NOCLOBBER

> @@ -298,6 +300,7 @@ ENTRY(ret_from_fork)
>  	/* When we fork, we trace the syscall return in the child, too. */
>  	movl    %esp, %eax
>  	call    syscall_return_slowpath
> +	ERASE_KSTACK

Ditto:

	STACKLEAK_ERASE

etc.

> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -32,6 +32,7 @@ struct vm86;
>  #include <linux/err.h>
>  #include <linux/irqflags.h>
>  #include <linux/mem_encrypt.h>
> +#include <linux/stackleak.h>

>  	mm_segment_t		addr_limit;
>  
> +	struct lowest_stack	lowest_stack;

This too should be something more organized and more opaque, like:

	struct stackleak_info	stackleak_info;

And the field name should not be a meaningless 'val', but 'lowest_stack'.

I.e. "p->stackleak_info.lowest_stack", which is so much more informative ...

> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -136,6 +136,11 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
>  	p->thread.sp0 = (unsigned long) (childregs+1);
>  	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	p->thread.lowest_stack.val = (unsigned long)end_of_stack(p) +
> +						sizeof(unsigned long);
> +#endif

This should use an inline helper:

	stackleak_task_init(p);

> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	p->thread.lowest_stack.val = (unsigned long)end_of_stack(p) +
> +						sizeof(unsigned long);
> +#endif

Beyond the lower visual impact this duplication will be removed by the inline 
helper as well.

> +++ b/kernel/stackleak.c
> @@ -0,0 +1,72 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This code fills the used part of the kernel stack with a poison value
> + * before returning to the userspace. It's a part of the STACKLEAK feature
> + * ported from grsecurity/PaX.
> + *
> + * Author: Alexander Popov <alex.popov@linux.com>
> + *
> + * STACKLEAK reduces the information which kernel stack leak bugs can
> + * reveal and blocks some uninitialized stack variable attacks. Moreover,
> + * STACKLEAK blocks stack depth overflow caused by alloca (aka Stack Clash
> + * attack).
> + */

s/alloca
 /alloca()

> +#include <linux/bug.h>
> +#include <linux/sched.h>
> +#include <linux/stackleak.h>
> +#include <asm/linkage.h>

Yeah, so since processor.h includes stackleak.h I strongly doubt the stackleak.h 
inclusion is necessary here. Please review every header inclusion line and remove 
the unnecessary ones.

> +
> +asmlinkage void erase_kstack(void)

This too should be in the stackleak_*() namespace.

> +{
> +	/*
> +	 * It would be nice not to have p and boundary on the stack.
> +	 * Setting the register specifier for them is the best we can do.
> +	 */
> +	register unsigned long p = current->thread.lowest_stack.val;
> +	register unsigned long boundary = p & ~(THREAD_SIZE - 1);

Does the 'register' keyword actually have any effect on the generated code?

> +	unsigned long poison = 0;
> +	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
> +							sizeof(unsigned long);

Please don't break lines in such an ugly fashion!

Also, 'poison' is a very weird name for something that looks like an index.

Plus since it's bound by "check_depth" is the 'unsigned long' justified,
or could it be 32-bit?

> +
> +	/*
> +	 * Let's search for the poison value in the stack.
> +	 * Start from the lowest_stack and go to the bottom.
> +	 */
> +	while (p > boundary && poison <= check_depth) {
> +		if (*(unsigned long *)p == STACKLEAK_POISON)
> +			poison++;
> +		else
> +			poison = 0;
> +
> +		p -= sizeof(unsigned long);
> +	}

This comment would be so much easier to read if the initialization was done right 
before the first use, i.e.:

	/*
	 * Let's search for the poison value in the stack.
	 * Start from the lowest_stack and go to the bottom:
	 */

	p = current->thread.lowest_stack.val;
	boundary = p & ~(THREAD_SIZE - 1);

	while (p > boundary && poison <= check_depth) {
		if (*(unsigned long *)p == STACKLEAK_POISON)
			poison++;
		else
			poison = 0;
	...

> +
> +	/*
> +	 * One long int at the bottom of the thread stack is reserved and
> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
> +	 */
> +	if (p == boundary)
> +		p += sizeof(unsigned long);

Please put types into quotes where it's ambigous. I first read this sentence as 
"One long ..." and went "wtf". It's a totally unnecessary disruption of the 
reading flow.

> +	/*
> +	 * So let's write the poison value to the kernel stack.
> +	 * Start from the address in p and move up till the new boundary.
> +	 * We assume that the stack pointer doesn't change when we write poison.
> +	 */

Here too 'p' is easier to read.

But 'p' is a very weird name: in the kernel it's usually some sort of process 
pointer. Please rename it to something more descriptive, such as "kstack_ptr" or 
so.

> +	if (on_thread_stack())
> +		boundary = current_stack_pointer;
> +	else
> +		boundary = current_top_of_stack();
> +
> +	BUG_ON(boundary - p >= THREAD_SIZE);

Please make this:

	if ( WARN_ON_ONCE())
		return;

... or so, so that if this code is buggy we get actual useful user reports, not 
just "my machine froze, help!"...

> +	/* Reset the lowest_stack value for the next syscall */
> +	current->thread.lowest_stack.val = current_top_of_stack() - 256;

Magic, unexplained '256' literal.

Thanks,

	Ingo
