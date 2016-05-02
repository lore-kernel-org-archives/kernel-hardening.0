Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160422202248.f3a31c6956a9135e9bdc0205@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202248.f3a31c6956a9135e9bdc0205@gmail.com>
Date: Mon, 2 May 2016 14:07:35 +0900
Message-ID: <CAK7LNATV=DfFwqSvwMHk0RnammN=-Nx8UjAqJV5F+8BmRTtW0g@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 2/6] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,


2016-04-23 3:22 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> This patch allows to build the whole kernel with GCC plugins. It was ported from
> grsecurity/PaX. The infrastructure supports building out-of-tree modules and
> building in a separate directory. Cross-compilation is supported too but
> currently only the x86 architecture enables plugins.

Only x86 architecture *at this point*,
but you will add ARM support right after this commit.

Squash 2/6 and 3/6 together and rephrase this comment?

(Instead, you may mention that the ARM portion was tested by David.)


> The directory of the gcc plugins is tools/gcc.

scripts/gcc-plugins.



> diff --git a/MAINTAINERS b/MAINTAINERS
> index e12a27c..de91d6c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4777,6 +4777,14 @@ L:       linux-scsi@vger.kernel.org
>  S:     Odd Fixes (e.g., new signatures)
>  F:     drivers/scsi/fdomain.*
>
> +GCC PLUGINS
> +M:     Kees Cook <keescook@chromium.org>
> +R:     Emese Revfy <re.emese@gmail.com>
> +L:     kernel-hardening@lists.openwall.com
> +S:     Maintained
> +F:     scripts/gcc-plugins/
> +F:     Documentation/gcc-plugins.txt
> +

scripts/gcc-plugin.sh should be also maintained by you guys.

Add an entry for that,
or move the gcc-plugin.sh script into scripts/gcc-plugins/





> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> index 253b72e..f912316 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -75,7 +75,7 @@ CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
>         -fno-omit-frame-pointer -foptimize-sibling-calls \
>         -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
>
> -$(vobjs): KBUILD_CFLAGS += $(CFL)
> +$(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
>
>  #
>  # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
> @@ -145,6 +145,7 @@ KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
>  KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
>  KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
>  KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
> +KBUILD_CFLAGS_32 := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS_32))
>  KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
>  KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector)
>  KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)


Looks like gcc-plugins should be omitted only for this directory.
Please tell me why.
I am not familiar with x86 architecture, so this is not clear to me.





> diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
> new file mode 100644
> index 0000000..b2d64af
> --- /dev/null
> +++ b/scripts/gcc-plugins/Makefile
> @@ -0,0 +1,15 @@
> +GCC_PLUGINS_DIR := $(shell $(CC) -print-file-name=plugin)
> +
> +ifeq ($(PLUGINCC),$(HOSTCC))
> +HOSTLIBS := hostlibs
> +HOST_EXTRACFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu99 -ggdb
> +export HOST_EXTRACFLAGS
> +else
> +HOSTLIBS := hostcxxlibs
> +HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti -fno-exceptions -fasynchronous-unwind-tables -ggdb -Wno-narrowing -Wno-unused-variable


This line is too long.

Please split into multiple lines.







-- 
Best Regards
Masahiro Yamada
