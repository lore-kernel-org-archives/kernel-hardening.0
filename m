Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160307000531.d43ae7df74bfa5e9e9e29087@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000531.d43ae7df74bfa5e9e9e29087@gmail.com>
Date: Fri, 11 Mar 2016 15:26:39 +0900
Message-ID: <CAK7LNARmTT2ixjwXWBZJOF+E79NAsRP3fTcfM3Fk9hf1zvFNVA@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 3/5] Add Cyclomatic complexity GCC plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,


2016-03-07 8:05 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> Add a very simple plugin to demonstrate the GCC plugin infrastructure. This GCC
> plugin computes the cyclomatic complexity of each function.
>
> The complexity M of a function's control flow graph is defined as:
>  M = E - N + 2P
> where
>  E = the number of edges
>  N = the number of nodes
>  P = the number of connected components (exit nodes).
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  arch/Kconfig                      | 12 +++++++
>  scripts/Makefile.gcc-plugins      |  6 +++-
>  tools/gcc/Makefile                |  4 +++
>  tools/gcc/cyc_complexity_plugin.c | 73 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 94 insertions(+), 1 deletion(-)
>  create mode 100644 tools/gcc/cyc_complexity_plugin.c
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index e090642..59bde9b 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -370,6 +370,18 @@ menuconfig GCC_PLUGINS
>           GCC plugins are loadable modules that provide extra features to the
>           compiler. They are useful for runtime instrumentation and static analysis.
>
> +config GCC_PLUGIN_CYC_COMPLEXITY
> +       bool "Compute the cyclomatic complexity of a function"
> +       depends on GCC_PLUGINS
> +       help
> +         The complexity M of a function's control flow graph is defined as:
> +          M = E - N + 2P
> +         where
> +
> +         E = the number of edges
> +         N = the number of nodes
> +         P = the number of connected components (exit nodes).
> +
>  config HAVE_CC_STACKPROTECTOR
>         bool
>         help
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 7c85bf2..dd7b56d 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -5,7 +5,11 @@ else
>  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
>  endif
>  ifneq ($(PLUGINCC),)
> -export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
> +ifdef CONFIG_GCC_PLUGIN_CYC_COMPLEXITY
> +GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS := -fplugin=$(objtree)/tools/gcc/cyc_complexity_plugin.so
> +endif
> +GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS)
> +export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY


Do you need to export "GCC_PLUGIN_CYC_COMPLEXITY"?
I do not see any reference to it.

If we expect more and more plugins in the future,
is it better to do like this?

gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)  += cyc_complexity_plugin.so
gcc-plugin-$(CONFIG_GCC_PLUGIN_SANCOV)          += sancov_plugin.so
gcc-plugin-$(CONFIG_GCC_PLUGIN_FOO)             += foo_plugin.so


GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/tools/gcc/,
$(gcc-plugin-y))








-- 
Best Regards
Masahiro Yamada
