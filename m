Subject: Re: [PATCH v3 2/3] security: Move stackleak config to
 Kconfig.hardening
References: <20190423194925.32151-1-keescook@chromium.org>
 <20190423194925.32151-3-keescook@chromium.org>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <84ed0a4b-b1e5-ae86-56c1-40a212734667@linux.com>
Date: Wed, 24 Apr 2019 18:25:45 +0300
MIME-Version: 1.0
In-Reply-To: <20190423194925.32151-3-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Alexander Potapenko <glider@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 23.04.2019 22:49, Kees Cook wrote:
> This moves the stackleak plugin options to Kconfig.hardening's memory
> initialization menu.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Hello Kees,

I see the changes in STACKLEAK help, looks good to me.
For this patch -
  Reviewed-by: Alexander Popov <alex.popov@linux.com>


By the way, for your information, GCC_PLUGIN_STRUCTLEAK help is now unreachable
from 'make menuconfig'.

Best regards,
Alexander


> ---
>  scripts/gcc-plugins/Kconfig | 51 ---------------------------------
>  security/Kconfig.hardening  | 57 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+), 51 deletions(-)
> 
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index 352f03878a1e..80220ed26a35 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -108,57 +108,6 @@ config GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
>  	  in structures.  This reduces the performance hit of RANDSTRUCT
>  	  at the cost of weakened randomization.
>  
> -config GCC_PLUGIN_STACKLEAK
> -	bool "Erase the kernel stack before returning from syscalls"
> -	depends on GCC_PLUGINS
> -	depends on HAVE_ARCH_STACKLEAK
> -	help
> -	  This option makes the kernel erase the kernel stack before
> -	  returning from system calls. That reduces the information which
> -	  kernel stack leak bugs can reveal and blocks some uninitialized
> -	  stack variable attacks.
> -
> -	  The tradeoff is the performance impact: on a single CPU system kernel
> -	  compilation sees a 1% slowdown, other systems and workloads may vary
> -	  and you are advised to test this feature on your expected workload
> -	  before deploying it.
> -
> -	  This plugin was ported from grsecurity/PaX. More information at:
> -	   * https://grsecurity.net/
> -	   * https://pax.grsecurity.net/
> -
> -config STACKLEAK_TRACK_MIN_SIZE
> -	int "Minimum stack frame size of functions tracked by STACKLEAK"
> -	default 100
> -	range 0 4096
> -	depends on GCC_PLUGIN_STACKLEAK
> -	help
> -	  The STACKLEAK gcc plugin instruments the kernel code for tracking
> -	  the lowest border of the kernel stack (and for some other purposes).
> -	  It inserts the stackleak_track_stack() call for the functions with
> -	  a stack frame size greater than or equal to this parameter.
> -	  If unsure, leave the default value 100.
> -
> -config STACKLEAK_METRICS
> -	bool "Show STACKLEAK metrics in the /proc file system"
> -	depends on GCC_PLUGIN_STACKLEAK
> -	depends on PROC_FS
> -	help
> -	  If this is set, STACKLEAK metrics for every task are available in
> -	  the /proc file system. In particular, /proc/<pid>/stack_depth
> -	  shows the maximum kernel stack consumption for the current and
> -	  previous syscalls. Although this information is not precise, it
> -	  can be useful for estimating the STACKLEAK performance impact for
> -	  your workloads.
> -
> -config STACKLEAK_RUNTIME_DISABLE
> -	bool "Allow runtime disabling of kernel stack erasing"
> -	depends on GCC_PLUGIN_STACKLEAK
> -	help
> -	  This option provides 'stack_erasing' sysctl, which can be used in
> -	  runtime to control kernel stack erasing for kernels built with
> -	  CONFIG_GCC_PLUGIN_STACKLEAK.
> -
>  config GCC_PLUGIN_ARM_SSP_PER_TASK
>  	bool
>  	depends on GCC_PLUGINS && ARM
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 19881341f1c2..a96d4a43ca65 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -88,6 +88,63 @@ config GCC_PLUGIN_STRUCTLEAK_VERBOSE
>  	  initialized. Since not all existing initializers are detected
>  	  by the plugin, this can produce false positive warnings.
>  
> +config GCC_PLUGIN_STACKLEAK
> +	bool "Poison kernel stack before returning from syscalls"
> +	depends on GCC_PLUGINS
> +	depends on HAVE_ARCH_STACKLEAK
> +	help
> +	  This option makes the kernel erase the kernel stack before
> +	  returning from system calls. This has the effect of leaving
> +	  the stack initialized to the poison value, which both reduces
> +	  the lifetime of any sensitive stack contents and reduces
> +	  potential for uninitialized stack variable exploits or information
> +	  exposures (it does not cover functions reaching the same stack
> +	  depth as prior functions during the same syscall). This blocks
> +	  most uninitialized stack variable attacks, with the performance
> +	  impact being driven by the depth of the stack usage, rather than
> +	  the function calling complexity.
> +
> +	  The performance impact on a single CPU system kernel compilation
> +	  sees a 1% slowdown, other systems and workloads may vary and you
> +	  are advised to test this feature on your expected workload before
> +	  deploying it.
> +
> +	  This plugin was ported from grsecurity/PaX. More information at:
> +	   * https://grsecurity.net/
> +	   * https://pax.grsecurity.net/
> +
> +config STACKLEAK_TRACK_MIN_SIZE
> +	int "Minimum stack frame size of functions tracked by STACKLEAK"
> +	default 100
> +	range 0 4096
> +	depends on GCC_PLUGIN_STACKLEAK
> +	help
> +	  The STACKLEAK gcc plugin instruments the kernel code for tracking
> +	  the lowest border of the kernel stack (and for some other purposes).
> +	  It inserts the stackleak_track_stack() call for the functions with
> +	  a stack frame size greater than or equal to this parameter.
> +	  If unsure, leave the default value 100.
> +
> +config STACKLEAK_METRICS
> +	bool "Show STACKLEAK metrics in the /proc file system"
> +	depends on GCC_PLUGIN_STACKLEAK
> +	depends on PROC_FS
> +	help
> +	  If this is set, STACKLEAK metrics for every task are available in
> +	  the /proc file system. In particular, /proc/<pid>/stack_depth
> +	  shows the maximum kernel stack consumption for the current and
> +	  previous syscalls. Although this information is not precise, it
> +	  can be useful for estimating the STACKLEAK performance impact for
> +	  your workloads.
> +
> +config STACKLEAK_RUNTIME_DISABLE
> +	bool "Allow runtime disabling of kernel stack erasing"
> +	depends on GCC_PLUGIN_STACKLEAK
> +	help
> +	  This option provides 'stack_erasing' sysctl, which can be used in
> +	  runtime to control kernel stack erasing for kernels built with
> +	  CONFIG_GCC_PLUGIN_STACKLEAK.
> +
>  endmenu
>  
>  endmenu
> 
