Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160307000427.c82f18670568e1e656fc9532@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000427.c82f18670568e1e656fc9532@gmail.com>
Date: Fri, 11 Mar 2016 15:25:19 +0900
Message-ID: <CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,

I am not familiar with GCC plugins.

Comments from the view of Kbuild.


2016-03-07 8:04 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> This patch allows to build the whole kernel with GCC plugins. It was ported from
> grsecurity/PaX. The infrastructure supports building out-of-tree modules and
> building in a separate directory. Cross-compilation is supported too but
> currently only the x86 architecture enables plugins.
>
> The directory of the gcc plugins is tools/gcc. You can use a file or a directory


Maybe scripts/gcc-plugins/ is better than tools/gcc ?

In the directory "scripts/", we have several tools used during
building the kernel image.
We have some optional programs in the directory "tools/", which are not used
for building the kernel image itself.

Please correct me if I am wrong.



You sprinkle "gcc-plugins" target in the top Makefile, which I do not like.

Can you descend into scripts/gcc-plugins from scripts/Makefile?


 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
 subdir-$(CONFIG_GDB_SCRIPTS) += gdb
+subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins


This is how other host tools do, I think.





>
> +ccflags-y := $(GCC_PLUGINS_CFLAGS)
> +asflags-y := $(GCC_PLUGINS_AFLAGS)
> +
>  obj-y                          := main.o version.o mounts.o
>  ifneq ($(CONFIG_BLK_DEV_INITRD),y)
>  obj-y                          += noinitramfs.o
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> new file mode 100644
> index 0000000..7c85bf2
> --- /dev/null
> +++ b/scripts/Makefile.gcc-plugins
> @@ -0,0 +1,28 @@
> +ifdef CONFIG_GCC_PLUGINS
> +ifeq ($(call cc-ifversion, -ge, 0408, y), y)
> +PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCXX)" "$(HOSTCXX)" "$(CC)")
> +else
> +PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
> +endif

The difference is only the first argument.

Can you make it as follows?

__HOSTCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))

PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh
"$(__HOSTCC)" "$(HOSTCXX)" "$(CC)")


I did not come up with a good name for __HOSTCC.
Feel free to replace it with a better one.





> +ifneq ($(PLUGINCC),)
> +export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
> +ifeq ($(KBUILD_EXTMOD),)
> +gcc-plugins:
> +       $(Q)$(MAKE) $(build)=tools/gcc
> +else
> +gcc-plugins: ;
> +endif
> +else
> +gcc-plugins:
> +ifeq ($(call cc-ifversion, -ge, 0405, y), y)
> +       $(warning warning, your gcc installation does not support plugins, perhaps the necessary headers are missing?)
> +ifeq ($(call cc-ifversion, -ge, 0408, y), y)
> +       $(CONFIG_SHELL) -x $(srctree)/scripts/gcc-plugin.sh "$(HOSTCXX)" "$(HOSTCXX)" "$(CC)"
> +else
> +       $(CONFIG_SHELL) -x $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)"
> +endif
> +else
> +       $(warning warning, your gcc version does not support plugins, you should upgrade it to gcc 4.5 at least)
> +endif
> +endif
> +endif


These ifdef's are really unreadable.
I wondered if it could be a bit simpler.
At least, the deepest one can be resolved with the "__HOSTCC" set above.




> diff --git a/scripts/gcc-plugin.sh b/scripts/gcc-plugin.sh
> new file mode 100644
> index 0000000..eaa4fce
> --- /dev/null
> +++ b/scripts/gcc-plugin.sh
> @@ -0,0 +1,51 @@
> +#!/bin/sh
> +srctree=$(dirname "$0")
> +gccplugins_dir=$($3 -print-file-name=plugin)
> +plugincc=$($1 -E -x c++ - -o /dev/null -I"${srctree}"/../tools/gcc -I"${gccplugins_dir}"/include 2>&1 <<EOF
> +#include "gcc-common.h"


Maybe <gcc-common.h> because it is not located at the same directory?



> diff --git a/tools/gcc/gcc-common.h b/tools/gcc/gcc-common.h
> new file mode 100644
> index 0000000..172850b
> --- /dev/null
> +++ b/tools/gcc/gcc-common.h
> @@ -0,0 +1,830 @@
> +#ifndef GCC_COMMON_H_INCLUDED
> +#define GCC_COMMON_H_INCLUDED
> +
> +#include "bversion.h"
> +#if BUILDING_GCC_VERSION >= 6000
> +#include "gcc-plugin.h"
> +#else
> +#include "plugin.h"
> +#endif
> +#include "plugin-version.h"
> +#include "config.h"
> +#include "system.h"
> +#include "coretypes.h"
> +#include "tm.h"
> +#include "line-map.h"
> +#include "input.h"
> +#include "tree.h"
> +
> +#include "tree-inline.h"
> +#include "version.h"
> +#include "rtl.h"
> +#include "tm_p.h"
> +#include "flags.h"
> +#include "hard-reg-set.h"
> +#include "output.h"
> +#include "except.h"
> +#include "function.h"
> +#include "toplev.h"
> +#include "basic-block.h"
> +#include "intl.h"
> +#include "ggc.h"
> +#include "timevar.h"
> +
> +#include "params.h"
> +
> +#if BUILDING_GCC_VERSION <= 4009
> +#include "pointer-set.h"
> +#else
> +#include "hash-map.h"
> +#endif
> +
> +#include "emit-rtl.h"
> +#include "debug.h"
> +#include "target.h"
> +#include "langhooks.h"
> +#include "cfgloop.h"
> +#include "cgraph.h"
> +#include "opts.h"

All of these are included by "...", not <...>.


As mentioned above, I want you to use "..." style
when you need to use relative path from the source.

I do not see most of them in tools/gcc/.




-- 
Best Regards
Masahiro Yamada
