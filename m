Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160422202454.b346331b5c1640ca31167a82@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202454.b346331b5c1640ca31167a82@gmail.com>
Date: Mon, 2 May 2016 14:09:55 +0900
Message-ID: <CAK7LNASxXirCzAQvj3Lz_0NC2k_yrLmYC+obzd=d9ZED6Xq6Sg@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 4/6] Add Cyclomatic complexity GCC plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,


2016-04-23 3:24 GMT+09:00 Emese Revfy <re.emese@gmail.com>:

> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index e6d66e2..282d63a 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -2,6 +2,8 @@ ifdef CONFIG_GCC_PLUGINS
>    __PLUGINCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))
>    PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
>
> +  gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)       += cyc_complexity_plugin.so
> +
>    GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y))
>
>    ifeq ($(PLUGINCC),)
> diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
> index b2d64af..31c72bf 100644
> --- a/scripts/gcc-plugins/Makefile
> +++ b/scripts/gcc-plugins/Makefile
> @@ -12,4 +12,8 @@ endif
>
>  export GCCPLUGINS_DIR HOSTLIBS
>
> +$(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) := cyc_complexity_plugin.so


I noticed we need to add the same string into "gcc-plugin-y" and "$(HOSTLIBS)-y"


Maybe can we do like this?

$(HOSTLIBS)-y := $(gcc-plugin-y)



>  always := $($(HOSTLIBS)-y)
> +
> +cyc_complexity_plugin-objs := cyc_complexity_plugin.o










-- 
Best Regards
Masahiro Yamada
