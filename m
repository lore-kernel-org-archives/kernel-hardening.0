Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 5 Jul 2018 10:12:37 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v13 (resend) 2/6] x86/entry: Add STACKLEAK erasing the
 kernel stack at the end of syscalls
Message-ID: <20180705081236.GB20903@gmail.com>
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
 <1529686717-16017-3-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529686717-16017-3-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Alexander Popov <alex.popov@linux.com> wrote:

> The STACKLEAK feature erases the kernel stack before returning from
> syscalls. That reduces the information which kernel stack leak bugs can
> reveal and blocks some uninitialized stack variable attacks. Moreover,
> STACKLEAK blocks kernel stack depth overflow caused by alloca (aka
> Stack Clash attack).
> 
> This commit introduces the code filling the used part of the kernel
> stack with a poison value before returning to the userspace. Full
> STACKLEAK feature also contains the gcc plugin which comes in a
> separate commit.
> 
> The STACKLEAK feature is ported from grsecurity/PaX. More information at:
>   https://grsecurity.net/
>   https://pax.grsecurity.net/
> 
> This code is modified from Brad Spengler/PaX Team's code in the last
> public patch of grsecurity/PaX based on our understanding of the code.
> Changes or omissions from the original code are ours and don't reflect
> the original grsecurity/PaX code.
> 
> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
>  Documentation/x86/x86_64/mm.txt  |  2 ++
>  arch/Kconfig                     | 27 +++++++++++++++++
>  arch/x86/Kconfig                 |  1 +
>  arch/x86/entry/calling.h         | 14 +++++++++
>  arch/x86/entry/entry_32.S        |  7 +++++
>  arch/x86/entry/entry_64.S        |  3 ++
>  arch/x86/entry/entry_64_compat.S |  5 ++++
>  include/linux/sched.h            |  4 +++
>  include/linux/stackleak.h        | 24 +++++++++++++++
>  kernel/Makefile                  |  4 +++
>  kernel/fork.c                    |  3 ++
>  kernel/stackleak.c               | 63 ++++++++++++++++++++++++++++++++++++++++
>  12 files changed, 157 insertions(+)
>  create mode 100644 include/linux/stackleak.h
>  create mode 100644 kernel/stackleak.c
> 
> diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
> index 5432a96..600bc2a 100644
> --- a/Documentation/x86/x86_64/mm.txt
> +++ b/Documentation/x86/x86_64/mm.txt
> @@ -24,6 +24,7 @@ ffffffffa0000000 - fffffffffeffffff (1520 MB) module mapping space
>  [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
>  ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
>  ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
> +STACKLEAK_POISON value in this last hole: ffffffffffff4111
>  
>  Virtual memory map with 5 level page tables:
>  
> @@ -50,6 +51,7 @@ ffffffffa0000000 - fffffffffeffffff (1520 MB) module mapping space
>  [fixmap start]   - ffffffffff5fffff kernel-internal fixmap range
>  ffffffffff600000 - ffffffffff600fff (=4 kB) legacy vsyscall ABI
>  ffffffffffe00000 - ffffffffffffffff (=2 MB) unused hole
> +STACKLEAK_POISON value in this last hole: ffffffffffff4111
>  
>  Architecture defines a 64-bit virtual address. Implementations can support
>  less. Currently supported are 48- and 57-bit virtual addresses. Bits 63
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 1aa5906..57817f0 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -414,6 +414,13 @@ config PLUGIN_HOSTCC
>  	  Host compiler used to build GCC plugins.  This can be $(HOSTCXX),
>  	  $(HOSTCC), or a null string if GCC plugin is unsupported.
>  
> +config HAVE_ARCH_STACKLEAK
> +	bool
> +	help
> +	  An architecture should select this if it has the code which
> +	  fills the used part of the kernel stack with the STACKLEAK_POISON
> +	  value before returning from system calls.
> +
>  config HAVE_GCC_PLUGINS
>  	bool
>  	help
> @@ -549,6 +556,26 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
>  	  in structures.  This reduces the performance hit of RANDSTRUCT
>  	  at the cost of weakened randomization.
>  
> +config GCC_PLUGIN_STACKLEAK
> +	bool "Erase the kernel stack before returning from syscalls"
> +	depends on GCC_PLUGINS
> +	depends on HAVE_ARCH_STACKLEAK
> +	help
> +	  This option makes the kernel erase the kernel stack before
> +	  returning from system calls. That reduces the information which
> +	  kernel stack leak bugs can reveal and blocks some uninitialized
> +	  stack variable attacks. This option also blocks kernel stack depth
> +	  overflow caused by alloca (aka Stack Clash attack).

Nit, please pick one of these variants to refer to library functions:

	  overflow caused by 'alloca' (aka Stack Clash attack).
	  overflow caused by alloca() (aka Stack Clash attack).

Like you correctly did later on in a C comment block:

> + * STACKLEAK blocks stack depth overflow caused by alloca() (aka Stack Clash
> + * attack).
> + */


> +	  The tradeoff is the performance impact: on a single CPU system kernel
> +	  compilation sees a 1% slowdown, other systems and workloads may vary
> +	  and you are advised to test this feature on your expected workload
> +	  before deploying it.

Is there a way to patch this out runtime? I.e. if a distro enabled it, is there an 
easy way to disable much of the overhead without rebooting the kernel?

> --- /dev/null
> +++ b/include/linux/stackleak.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_STACKLEAK_H
> +#define _LINUX_STACKLEAK_H
> +
> +#include <linux/sched.h>
> +#include <linux/sched/task_stack.h>
> +
> +/*
> + * Check that the poison value points to the unused hole in the
> + * virtual memory map for your platform.
> + */
> +#define STACKLEAK_POISON -0xBEEF
> +
> +#define STACKLEAK_POISON_CHECK_DEPTH 128
> +
> +static inline void stackleak_task_init(struct task_struct *task)
> +{
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +	task->lowest_stack = (unsigned long)end_of_stack(task) +
> +						sizeof(unsigned long);
> +#endif

Please don't break the line in such an ugly fashion - just keep the line long and 
ignore checkpatch, because the cure is worse than the disease.

> --- /dev/null
> +++ b/kernel/stackleak.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This code fills the used part of the kernel stack with a poison value
> + * before returning to the userspace. It's a part of the STACKLEAK feature
> + * ported from grsecurity/PaX.

s/returning to the userspace
 /returning to userspace

s/It's a part of the STACKLEAK feature
 /It's part of the STACKLEAK feature

> + * Author: Alexander Popov <alex.popov@linux.com>
> + *
> + * STACKLEAK reduces the information which kernel stack leak bugs can
> + * reveal and blocks some uninitialized stack variable attacks. Moreover,
> + * STACKLEAK blocks stack depth overflow caused by alloca() (aka Stack Clash
> + * attack).
> + */
> +
> +#include <linux/stackleak.h>
> +
> +asmlinkage void stackleak_erase_kstack(void)

s/stackleak_erase_kstack
 /stackleak_erase

?

> +{
> +	/* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
> +	unsigned long kstack_ptr = current->lowest_stack;
> +	unsigned long boundary = kstack_ptr & ~(THREAD_SIZE - 1);
> +	unsigned int poison_count = 0;
> +	const unsigned int check_depth =
> +			STACKLEAK_POISON_CHECK_DEPTH / sizeof(unsigned long);

ugly linebreak.

> +
> +	/* Search for the poison value in the kernel stack */
> +	while (kstack_ptr > boundary && poison_count <= check_depth) {
> +		if (*(unsigned long *)kstack_ptr == STACKLEAK_POISON)
> +			poison_count++;
> +		else
> +			poison_count = 0;
> +
> +		kstack_ptr -= sizeof(unsigned long);
> +	}
> +
> +	/*
> +	 * One 'long int' at the bottom of the thread stack is reserved and
> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).

Nit:

  s/CONFIG_SCHED_STACK_END_CHECK
   /CONFIG_SCHED_STACK_END_CHECK=y

> +	 */
> +	if (kstack_ptr == boundary)
> +		kstack_ptr += sizeof(unsigned long);
> +
> +	/*
> +	 * Now write the poison value to the kernel stack. Start from
> +	 * 'kstack_ptr' and move up till the new 'boundary'. We assume that
> +	 * the stack pointer doesn't change when we write poison.
> +	 */
> +	if (on_thread_stack())
> +		boundary = current_stack_pointer;
> +	else
> +		boundary = current_top_of_stack();
> +
> +	BUG_ON(boundary - kstack_ptr >= THREAD_SIZE);

Should never happen, right? If so then please make this:

	if (WARN_ON(boundary - kstack_ptr >= THREAD_SIZE))
		return;

or so, to make it non-fatal and to allow users to report it, should it trigger 
against all expectations.

> +
> +	while (kstack_ptr < boundary) {
> +		*(unsigned long *)kstack_ptr = STACKLEAK_POISON;
> +		kstack_ptr += sizeof(unsigned long);
> +	}
> +
> +	/* Reset the 'lowest_stack' value for the next syscall */
> +	current->lowest_stack = current_top_of_stack() - THREAD_SIZE / 64;
> +}

Nit, I'd write this as:

	current->lowest_stack = current_top_of_stack() - THREAD_SIZE/64;

to make it group better visually. (Again, ignore checkpatch if it complains, it's 
wrong.)

Overall I like the interface cleanups in v13, so if these nits are addressed and 
it becomes possible for (root users) to disable the checking then I suppose this 
is fine.

Thanks,

	Ingo
