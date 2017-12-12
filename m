Date: Tue, 12 Dec 2017 03:09:12 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
Message-ID: <20171212000912.GA10256@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512516827-29797-3-git-send-email-alex.popov@linux.com>
Subject: Re: [kernel-hardening] [PATCH RFC v6 2/6] gcc-plugins: Add STACKLEAK
 plugin for tracking the kernel stack
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, KeesCook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 06, 2017 at 02:33:43AM +0300, Alexander Popov wrote:
> The STACKLEAK feature erases the kernel stack before returning from
> syscalls. That reduces the information which kernel stack leak bugs can
> reveal and blocks some uninitialized stack variable attacks. Moreover,
> STACKLEAK provides runtime checks for kernel stack overflow detection.
> 
> This commit introduces the STACKLEAK gcc plugin. It is needed for:
>  - tracking the lowest border of the kernel stack, which is important
>     for the code erasing the used part of the kernel stack at the end
>     of syscalls (comes in a separate commit);
>  - checking that alloca calls don't cause stack overflow.
> 
> So this plugin instruments the kernel code inserting:
>  - the check_alloca() call before alloca and the track_stack() call
>     after it;
>  - the track_stack() call for the functions with a stack frame size
>     greater than or equal to CONFIG_STACKLEAK_TRACK_MIN_SIZE.
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
> ---
>  arch/Kconfig                           |  15 ++
>  arch/x86/kernel/dumpstack.c            |  15 ++
>  fs/exec.c                              |  25 ++
>  scripts/Makefile.gcc-plugins           |   3 +
>  scripts/gcc-plugins/stackleak_plugin.c | 470 +++++++++++++++++++++++++++++++++
>  5 files changed, 528 insertions(+)
>  create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 721fdae..ba8e67b 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -528,6 +528,8 @@ config GCC_PLUGIN_STACKLEAK
>  	bool "Erase the kernel stack before returning from syscalls"
>  	depends on GCC_PLUGINS
>  	depends on HAVE_ARCH_STACKLEAK
> +	imply VMAP_STACK
> +	imply SCHED_STACK_END_CHECK
>  	help
>  	  This option makes the kernel erase the kernel stack before it
>  	  returns from a system call. That reduces the information which
> @@ -544,6 +546,19 @@ config GCC_PLUGIN_STACKLEAK
>  	   * https://grsecurity.net/
>  	   * https://pax.grsecurity.net/
>  
> +config STACKLEAK_TRACK_MIN_SIZE
> +	int "Minimum stack frame size of functions tracked by STACKLEAK"
> +	default 100
> +	range 0 4096
> +	depends on GCC_PLUGIN_STACKLEAK
> +	help
> +	  The STACKLEAK gcc plugin instruments the kernel code for tracking
> +	  the lowest border of the kernel stack (and for some other purposes).
> +	  It inserts the track_stack() call for the functions with a stack
> +	  frame size greater than or equal to this parameter. Be careful with
> +	  this setting, don't break the poison search in erase_kstack.
> +	  If unsure, leave the default value 100.
> +

I don't think the warning is scaring enough.  As erase_kstack (both 64-bit
and 32-bit versions) checks for 128 consequent bytes of STACKLEAK_POISON,
it would be a bad idea to raise STACKLEAK_TRACK_MIN_SIZE to a value higher
than 120.  Perhaps there has to be a consistency check that
STACKLEAK_TRACK_MIN_SIZE does not break assumptions made in erase_kstack.

>  config HAVE_CC_STACKPROTECTOR
>  	bool
>  	help
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index f13b4c0..5a9b6cc 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -315,3 +315,18 @@ static int __init code_bytes_setup(char *s)
>  	return 1;
>  }
>  __setup("code_bytes=", code_bytes_setup);
> +
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +void __used check_alloca(unsigned long size)
> +{
> +	unsigned long sp = (unsigned long)&sp;
> +	struct stack_info stack_info = {0};
> +	unsigned long visit_mask = 0;
> +	unsigned long stack_left;
> +
> +	BUG_ON(get_stack_info(&sp, current, &stack_info, &visit_mask));
> +	stack_left = sp - (unsigned long)stack_info.begin;
> +	BUG_ON(stack_left < 256 || size >= stack_left - 256);
> +}
> +EXPORT_SYMBOL(check_alloca);
> +#endif

I think some rationale has to be given why 256 was chosen as the minimal
size of stack space left after alloca.


-- 
ldv
