From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 20/23] gcc-plugins: always build plugins with C++
Date: Sat, 17 Feb 2018 03:38:48 +0900
Message-Id: <1518806331-7101-21-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
References: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Ulf Magnusson <ulfalizer@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Michal Marek <michal.lkml@markovi.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

If the target compiler is GCC 4.8 or newer, plugins are compiled with
HOSTCXX.  Otherwise, gcc-plugin.sh will select HOSTCC or HOSTCXX.

To simpily things, let's decide GCC 4.8 is the requirement for GCC
pulgins.  With this, plugins are always built with HOSTCXX.  This is a
feature of advanced users, so this requirement whould not be not a big
issue.

Add 'depends on GCC_VERSION >= 40800' to GCC_PLUGINS, and remove the
code that was needed to build plugins with HOSTCC.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 arch/Kconfig                 |  1 +
 scripts/Makefile.gcc-plugins | 11 +++--------
 scripts/gcc-plugin.sh        | 38 +++-----------------------------------
 scripts/gcc-plugins/Makefile | 15 ++++-----------
 4 files changed, 11 insertions(+), 54 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9b7a628..9bd4e1f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -410,6 +410,7 @@ config HAVE_GCC_PLUGINS
 menuconfig GCC_PLUGINS
 	bool "GCC plugins"
 	depends on HAVE_GCC_PLUGINS
+	depends on GCC_VERSION >= 40800
 	depends on !COMPILE_TEST
 	help
 	  GCC plugins are loadable modules that provide extra features to the
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index b2a95af..b0f9108 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 ifdef CONFIG_GCC_PLUGINS
-  __PLUGINCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))
-  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
+  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh $(HOSTCXX) $(CC))
 
   SANCOV_PLUGIN := -fplugin=$(objtree)/scripts/gcc-plugins/sancov_plugin.so
 
@@ -65,12 +64,8 @@ ifdef CONFIG_GCC_PLUGINS
 	  @echo "Cannot use CONFIG_GCC_PLUGINS: plugin support on gcc <= 5.1 is buggy on powerpc, please upgrade to gcc 5.2 or newer" >&2 && exit 1
         endif
       endif
-      ifeq ($(call cc-ifversion, -ge, 0405, y), y)
-	$(Q)$(srctree)/scripts/gcc-plugin.sh --show-error "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)" || true
-	@echo "Cannot use CONFIG_GCC_PLUGINS: your gcc installation does not support plugins, perhaps the necessary headers are missing?" >&2 && exit 1
-      else
-	@echo "Cannot use CONFIG_GCC_PLUGINS: your gcc version does not support plugins, you should upgrade it to at least gcc 4.5" >&2 && exit 1
-      endif
+      $(Q)$(srctree)/scripts/gcc-plugin.sh --show-error $(HOSTCXX) $(CC) || true
+      @echo "Cannot use CONFIG_GCC_PLUGINS: your gcc installation does not support plugins, perhaps the necessary headers are missing?" >&2 && exit 1
     endif
   endif
 endif
diff --git a/scripts/gcc-plugin.sh b/scripts/gcc-plugin.sh
index d3caefe..0edbdae 100755
--- a/scripts/gcc-plugin.sh
+++ b/scripts/gcc-plugin.sh
@@ -8,42 +8,10 @@ if [ "$1" = "--show-error" ] ; then
 	shift || true
 fi
 
-gccplugins_dir=$($3 -print-file-name=plugin)
-plugincc=$($1 -E -x c++ - -o /dev/null -I"${srctree}"/gcc-plugins -I"${gccplugins_dir}"/include 2>&1 <<EOF
-#include "gcc-common.h"
-#if BUILDING_GCC_VERSION >= 4008 || defined(ENABLE_BUILD_WITH_CXX)
-#warning $2 CXX
-#else
-#warning $1 CC
-#endif
-EOF
-)
-
-if [ $? -ne 0 ]
-then
-	if [ -n "$SHOW_ERROR" ] ; then
-		echo "${plugincc}" >&2
-	fi
-	exit 1
-fi
-
-case "$plugincc" in
-	*"$1 CC"*)
-		echo "$1"
-		exit 0
-		;;
-
-	*"$2 CXX"*)
-		# the c++ compiler needs another test, see below
-		;;
-
-	*)
-		exit 1
-		;;
-esac
+gccplugins_dir=$($2 -print-file-name=plugin)
 
 # we need a c++ compiler that supports the designated initializer GNU extension
-plugincc=$($2 -c -x c++ -std=gnu++98 - -fsyntax-only -I"${srctree}"/gcc-plugins -I"${gccplugins_dir}"/include 2>&1 <<EOF
+plugincc=$($1 -c -x c++ -std=gnu++98 - -fsyntax-only -I"${srctree}"/gcc-plugins -I"${gccplugins_dir}"/include 2>&1 <<EOF
 #include "gcc-common.h"
 class test {
 public:
@@ -56,7 +24,7 @@ EOF
 
 if [ $? -eq 0 ]
 then
-	echo "$2"
+	echo "$1"
 	exit 0
 fi
 
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index e2ff425..47d5f69 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -1,17 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 GCC_PLUGINS_DIR := $(shell $(CC) -print-file-name=plugin)
 
-ifeq ($(PLUGINCC),$(HOSTCC))
-  HOSTLIBS := hostlibs
-  HOST_EXTRACFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu99 -ggdb
-  export HOST_EXTRACFLAGS
-else
-  HOSTLIBS := hostcxxlibs
-  HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti
-  HOST_EXTRACXXFLAGS += -fno-exceptions -fasynchronous-unwind-tables -ggdb
-  HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable
-  export HOST_EXTRACXXFLAGS
-endif
+HOSTLIBS := hostcxxlibs
+HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti
+HOST_EXTRACXXFLAGS += -fno-exceptions -fasynchronous-unwind-tables -ggdb
+HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable
 
 ifneq ($(CFLAGS_KCOV), $(SANCOV_PLUGIN))
   GCC_PLUGIN := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGIN))
-- 
2.7.4
