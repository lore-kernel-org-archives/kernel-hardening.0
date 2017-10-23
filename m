Date: Mon, 23 Oct 2017 15:17:30 +0200
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20171023131730.2r5imit2hzpxq2vg@docker>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <1508631773-2502-2-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508631773-2502-2-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] Re: [PATCH RFC v5 1/5] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 22, 2017 at 03:22:49AM +0300, Alexander Popov wrote:
> The STACKLEAK feature erases the kernel stack before returning from
> syscalls. That reduces the information which kernel stack leak bugs can
> reveal and blocks some uninitialized stack variable attacks. Moreover,
> STACKLEAK provides runtime checks for kernel stack overflow detection.
> 
> This commit introduces the architecture-specific code filling the used
> part of the kernel stack with a poison value before returning to the
> userspace. Full STACKLEAK feature also contains the gcc plugin which
> comes in a separate commit.
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
>  arch/Kconfig                     | 27 ++++++++++++
>  arch/x86/Kconfig                 |  1 +
>  arch/x86/entry/common.c          | 17 +++++--
>  arch/x86/entry/entry_32.S        | 69 +++++++++++++++++++++++++++++
>  arch/x86/entry/entry_64.S        | 95 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/entry/entry_64_compat.S |  8 ++++
>  arch/x86/include/asm/processor.h |  4 ++
>  arch/x86/kernel/asm-offsets.c    |  9 ++++
>  arch/x86/kernel/process_32.c     |  5 +++
>  arch/x86/kernel/process_64.c     |  5 +++
>  include/linux/compiler.h         |  4 ++
>  11 files changed, 241 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index d789a89..e9ec94c 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -386,6 +386,13 @@ config SECCOMP_FILTER
>  
>  	  See Documentation/prctl/seccomp_filter.txt for details.
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
> @@ -516,6 +523,26 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
>  	  in structures.  This reduces the performance hit of RANDSTRUCT
>  	  at the cost of weakened randomization.
>  
> +config GCC_PLUGIN_STACKLEAK
> +	bool "Erase the kernel stack before returning from syscalls"
> +	depends on GCC_PLUGINS
> +	depends on HAVE_ARCH_STACKLEAK
> +	help
> +	  This option makes the kernel erase the kernel stack before it
> +	  returns from a system call. That reduces the information which
> +	  kernel stack leak bugs can reveal and blocks some uninitialized
> +	  stack variable attacks. This option also provides runtime checks
> +	  for kernel stack overflow detection.
> +
> +	  The tradeoff is the performance impact: on a single CPU system kernel
> +	  compilation sees a 1% slowdown, other systems and workloads may vary
> +	  and you are advised to test this feature on your expected workload
> +	  before deploying it.
> +
> +	  This plugin was ported from grsecurity/PaX. More information at:
> +	   * https://grsecurity.net/
> +	   * https://pax.grsecurity.net/
> +
>  config HAVE_CC_STACKPROTECTOR
>  	bool
>  	help
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 971feac..b7da58f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -114,6 +114,7 @@ config X86
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
>  	select HAVE_ARCH_COMPAT_MMAP_BASES	if MMU && COMPAT
>  	select HAVE_ARCH_SECCOMP_FILTER
> +	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 03505ff..075487e 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -45,6 +45,12 @@ __visible inline void enter_from_user_mode(void)
>  static inline void enter_from_user_mode(void) {}
>  #endif
>  
> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +asmlinkage void erase_kstack(void);
> +#else
> +static void erase_kstack(void) {}
> +#endif
> +
>  static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
>  {
>  #ifdef CONFIG_X86_64
> @@ -81,8 +87,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
>  		emulated = true;
>  
>  	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
> -	    tracehook_report_syscall_entry(regs))
> +	    tracehook_report_syscall_entry(regs)) {
> +		erase_kstack();
>  		return -1L;
> +	}
>  
>  	if (emulated)
>  		return -1L;
> @@ -116,9 +124,11 @@ static long syscall_trace_enter(struct pt_regs *regs)
>  			sd.args[5] = regs->bp;
>  		}
>  
> -		ret = __secure_computing(&sd);
> -		if (ret == -1)
> +		ret = secure_computing(&sd);

Is there any reason to switch this from the __ version? This basically
adds an additional check on the TIF_SECCOMP flag, but I'm not sure
that's intentional with this patch.

Cheers,

Tycho
