Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160327230913.bbbd9951fddca197b9b13b23@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000427.c82f18670568e1e656fc9532@gmail.com>
	<CAK7LNASCOaEi46+b7Obt0D6GtiBmCfwBEkdbYSnpBDzzQOXpvA@mail.gmail.com>
	<20160324010749.f7e547e1df12b4944c5fa490@gmail.com>
	<CAK7LNATK-r09tJ5K8u8vRdRR0dXywAJ=LbbhaigZkfMm3UUPmA@mail.gmail.com>
	<20160327230913.bbbd9951fddca197b9b13b23@gmail.com>
Date: Sat, 2 Apr 2016 13:32:40 +0900
Message-ID: <CAK7LNAQqF=+y9H54aFsmvfFT5q3x2S_fsiDwjekV0oFdgDBpXQ@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,

Sorry for my late reply.


> Thanks for the patch. I tested it and there is a problem when I run a parallel make.
> The plugins are compiled later than needed (e.g., scripts/mod/empty.o). There is a lot of important
> code under scripts/mod which may need the plugins.

Ah, I missed that.


> If the plugins were compiled when the "scripts_basic"
> target runs it would be good but unfortunately the config symbol CONFIG_GCC_PLUGINS doesn't seem to be defined yet.
> Could you please help me solve this problem?


How about this?

It should apply on commit 0b005b886bde6c4b9134d01f830d88d464911a65
of your tree.



diff --git a/Makefile b/Makefile
index 1c7a379..d3518e0 100644
--- a/Makefile
+++ b/Makefile
@@ -550,7 +550,7 @@ ifeq ($(KBUILD_EXTMOD),)
 # in parallel
 PHONY += scripts
 scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
-        asm-generic
+        asm-generic gcc-plugins
        $(Q)$(MAKE) $(build)=$(@)

 # Objects we will link into vmlinux / subdirs we need to visit
@@ -625,6 +625,13 @@ endif
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS  += $(call cc-option,--param=allow-store-data-races=0)

+PHONY += gcc-plugins
+gcc-plugins: scripts_basic
+ifdef CONFIG_GCC_PLUGINS
+       $(Q)$(MAKE) $(build)=scripts/gcc-plugins
+endif
+       @:
+
 include scripts/Makefile.gcc-plugins

 ifdef CONFIG_READABLE_ASM
@@ -1008,7 +1015,7 @@ archprepare: archheaders archscripts prepare1
scripts_basic

 prepare0: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
 prepare0: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
-prepare0: archprepare FORCE
+prepare0: archprepare gcc-plugins FORCE
        $(Q)$(MAKE) $(build)=.

 # All the preparing..
diff --git a/scripts/Makefile b/scripts/Makefile
index 0ba652c..1d80897 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -45,7 +45,6 @@ subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
 subdir-$(CONFIG_GDB_SCRIPTS) += gdb
-subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins

 # Let clean descend into subdirs
-subdir-        += basic kconfig package
+subdir-        += basic kconfig package gcc-plugins





-- 
Best Regards
Masahiro Yamada
