From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 22/23] gcc-plugins: test GCC plugin support in Kconfig
Date: Sat, 17 Feb 2018 03:38:50 +0900
Message-Id: <1518806331-7101-23-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Ulf Magnusson <ulfalizer@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Michal Marek <michal.lkml@markovi.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Run scripts/gcc-plugin.sh from Kconfig.  Users can enable GCC_PLUGINS
only when it is supported.

I dropped 'depends on GCC_VERSION >= 40800'.  I guess gcc-plugin.sh
will not pass with GCC 4.7 or older.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 arch/Kconfig                 |  6 +++-
 scripts/Makefile.gcc-plugins | 82 ++++++++++++++++----------------------------
 scripts/gcc-plugin.sh        |  1 -
 3 files changed, 34 insertions(+), 55 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9bd4e1f..d567bd1 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -407,10 +407,14 @@ config HAVE_GCC_PLUGINS
 	  An arch should select this symbol if it supports building with
 	  GCC plugins.
 
+config CC_HAS_GCC_PLUGINS
+	bool
+	default $(shell $srctree/scripts/gcc-plugin.sh $HOSTCXX $CC)
+
 menuconfig GCC_PLUGINS
 	bool "GCC plugins"
 	depends on HAVE_GCC_PLUGINS
-	depends on GCC_VERSION >= 40800
+	depends on CC_HAS_GCC_PLUGINS
 	depends on !COMPILE_TEST
 	help
 	  GCC plugins are loadable modules that provide extra features to the
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 25da4c0..19d0d5b 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -1,71 +1,47 @@
 # SPDX-License-Identifier: GPL-2.0
-ifdef CONFIG_GCC_PLUGINS
-  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh $(HOSTCXX) $(CC))
-
-  SANCOV_PLUGIN := -fplugin=$(objtree)/scripts/gcc-plugins/sancov_plugin.so
+SANCOV_PLUGIN := -fplugin=$(objtree)/scripts/gcc-plugins/sancov_plugin.so
 
-  gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)	+= cyc_complexity_plugin.so
+gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)	+= cyc_complexity_plugin.so
 
-  gcc-plugin-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= latent_entropy_plugin.so
-  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= -DLATENT_ENTROPY_PLUGIN
-  ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
-    DISABLE_LATENT_ENTROPY_PLUGIN			+= -fplugin-arg-latent_entropy_plugin-disable
-  endif
+gcc-plugin-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= latent_entropy_plugin.so
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= -DLATENT_ENTROPY_PLUGIN
+ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
+  DISABLE_LATENT_ENTROPY_PLUGIN			+= -fplugin-arg-latent_entropy_plugin-disable
+endif
 
-  ifdef CONFIG_GCC_PLUGIN_SANCOV
-    ifeq ($(CFLAGS_KCOV),)
-      # It is needed because of the gcc-plugin.sh and gcc version checks.
-      gcc-plugin-$(CONFIG_GCC_PLUGIN_SANCOV)           += sancov_plugin.so
+ifdef CONFIG_GCC_PLUGIN_SANCOV
+  ifeq ($(CFLAGS_KCOV),)
+    # It is needed because of the gcc-plugin.sh and gcc version checks.
+    gcc-plugin-$(CONFIG_GCC_PLUGIN_SANCOV)           += sancov_plugin.so
 
-      ifneq ($(PLUGINCC),)
-        CFLAGS_KCOV := $(SANCOV_PLUGIN)
-      else
-        $(warning warning: cannot use CONFIG_KCOV: -fsanitize-coverage=trace-pc is not supported by compiler)
-      endif
-    endif
+    CFLAGS_KCOV := $(SANCOV_PLUGIN)
   endif
+endif
 
-  gcc-plugin-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= structleak_plugin.so
-  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	+= -fplugin-arg-structleak_plugin-verbose
-  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	+= -fplugin-arg-structleak_plugin-byref-all
-  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= -DSTRUCTLEAK_PLUGIN
-
-  gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= randomize_layout_plugin.so
-  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= -DRANDSTRUCT_PLUGIN
-  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE)	+= -fplugin-arg-randomize_layout_plugin-performance-mode
+gcc-plugin-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= structleak_plugin.so
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	+= -fplugin-arg-structleak_plugin-verbose
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	+= -fplugin-arg-structleak_plugin-byref-all
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= -DSTRUCTLEAK_PLUGIN
 
-  GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
+gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= randomize_layout_plugin.so
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)	+= -DRANDSTRUCT_PLUGIN
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE)	+= -fplugin-arg-randomize_layout_plugin-performance-mode
 
-  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
-  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
+GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
-  ifneq ($(PLUGINCC),)
-    # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
-    GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
-  endif
+export GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
+export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
 
-  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
-  GCC_PLUGIN := $(gcc-plugin-y)
-  GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
-endif
+# SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
+GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
 
-# If plugins aren't supported, abort the build before hard-to-read compiler
-# errors start getting spewed by the main build.
-PHONY += gcc-plugins-check
-gcc-plugins-check: FORCE
-ifdef CONFIG_GCC_PLUGINS
-  ifeq ($(PLUGINCC),)
-    ifneq ($(GCC_PLUGINS_CFLAGS),)
-      $(Q)$(srctree)/scripts/gcc-plugin.sh --show-error $(HOSTCXX) $(CC) || true
-      @echo "Cannot use CONFIG_GCC_PLUGINS: your gcc installation does not support plugins, perhaps the necessary headers are missing?" >&2 && exit 1
-    endif
-  endif
-endif
-	@:
+KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+GCC_PLUGIN := $(gcc-plugin-y)
+GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
 
 # Actually do the build, if requested.
 PHONY += gcc-plugins
-gcc-plugins: scripts_basic gcc-plugins-check
+gcc-plugins: scripts_basic
 ifdef CONFIG_GCC_PLUGINS
 	$(Q)$(MAKE) $(build)=scripts/gcc-plugins
 endif
diff --git a/scripts/gcc-plugin.sh b/scripts/gcc-plugin.sh
index 0edbdae..b18c69c 100755
--- a/scripts/gcc-plugin.sh
+++ b/scripts/gcc-plugin.sh
@@ -24,7 +24,6 @@ EOF
 
 if [ $? -eq 0 ]
 then
-	echo "$1"
 	exit 0
 fi
 
-- 
2.7.4
