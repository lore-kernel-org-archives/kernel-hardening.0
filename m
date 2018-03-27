From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH v2 17/21] gcc-plugins: always build plugins with C++
Date: Tue, 27 Mar 2018 14:29:31 +0900
Message-Id: <1522128575-5326-18-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com>
References: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Ulf Magnusson <ulfalizer@gmail.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Nicolas Pitre <nico@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

If the target compiler is GCC 4.8 or newer, plugins are compiled with
HOSTCXX.  Otherwise, gcc-plugin.sh will select HOSTCC or HOSTCXX.

To simplify things, drop the HOSTCC support for plugins.  If you use
GCC plugins, the requirement for the target compiler is GCC 4.8 (or
older compiler with necessary features backported).  This is a feature
for advanced users, so this requirement would not be a big deal.
Currently, building plugins requires GCC 4.5, so this is not a big jump.

Remove the code that was needed to build plugins with HOSTCC as a
preparation for Kconfig migration.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

Changes in v2: None

 scripts/Makefile.gcc-plugins | 11 +++--------
 scripts/gcc-plugin.sh        | 38 +++-----------------------------------
 scripts/gcc-plugins/Makefile | 15 ++++-----------
 3 files changed, 10 insertions(+), 54 deletions(-)

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
