Subject: Re: [PATCH 1/1] Add an option to build kernel with -finit-local-vars
References: <20180227111532.1144-1-ppandit@redhat.com>
 <20180227111532.1144-2-ppandit@redhat.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <14a4ef2b-1a32-2781-80db-ee850e25f318@redhat.com>
Date: Tue, 27 Feb 2018 11:22:57 -0800
MIME-Version: 1.0
In-Reply-To: <20180227111532.1144-2-ppandit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: P J P <ppandit@redhat.com>, kernel-hardening@lists.openwall.com
Cc: Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/27/2018 03:15 AM, P J P wrote:
> From: P J P <pjp@fedoraproject.org>
> 
> Add a configuration option to build kernel with -finit-local-vars
> compiler option.[*] It'll zero initialize the automatic kernel
> function variables, thus helping to reduce kernel information
> leakage issues.
> 

I think this would make the existing structleak plugin
(scripts/gcc-plugins/structleak_plugin.c) obsolete. This isn't
a bad thing but we'd need to figure out a deprecation strategy.

> [*] https://gcc.gnu.org/ml/gcc-patches/2014-06/msg00615.html
> 
> Signed-off-by: P J P <pjp@fedoraproject.org>
> ---
>   Makefile          | 4 ++++
>   lib/Kconfig.debug | 8 ++++++++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 659a7780aeb3..7b25a77470ca 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -781,6 +781,10 @@ KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
>   		   $(call cc-option,-fno-var-tracking)
>   endif
>   
> +ifdef CONFIG_FINIT_LOCAL_VARS
> +KBUILD_CFLAGS  += $(call cc-option, -finit-local-vars)
> +endif
> +
>   ifdef CONFIG_FUNCTION_TRACER
>   ifndef CC_FLAGS_FTRACE
>   CC_FLAGS_FTRACE := -pg
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 64155e310a9f..8da18d145c5b 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -206,6 +206,14 @@ config ENABLE_WARN_DEPRECATED
>   	  Disable this to suppress the "warning: 'foo' is deprecated
>   	  (declared at kernel/power/somefile.c:1234)" messages.
>   
> +config FINIT_LOCAL_VARS
> +       bool "Enable -finit-local-vars"
> +       default n
> +       help
> +         Enable the -finit-local-vars compiler option during the kernel build.
> +         It'll zero initialise the automatic kernel function variables, thus
> +         helping to reduce kernel information leakage issues.
> +

A few words about the expected runtime/kernel size impact would be helpful.

Thanks,
Laura

>   config ENABLE_MUST_CHECK
>   	bool "Enable __must_check logic"
>   	default y
> 
