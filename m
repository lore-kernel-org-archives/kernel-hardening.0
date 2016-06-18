Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Jun 2016 11:14:37 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160618181437.GA2633@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC][PATCH] gcc-plugins: abort builds cleanly when not supported
To: Emese Revfy <re.emese@gmail.com>
Cc: Michal Marek <mmarek@suse.com>, linux-kbuild@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When the compiler doesn't support gcc plugins (either due to missing
headers or too old a version), report the problem and abort the build
instead of emitting a warning and letting the build founder with arcane
compiler errors.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
I think this greatly improves the failure case when trying to use the
gcc plugin infrastructure. Emese, what do you think of this?
---
 Makefile                     |  7 -------
 scripts/Makefile.gcc-plugins | 34 +++++++++++++++++++++++++---------
 scripts/gcc-plugin.sh        | 14 ++++++++++++++
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index ab124a0e5e0d..5c61a7155d50 100644
--- a/Makefile
+++ b/Makefile
@@ -633,13 +633,6 @@ endif
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
 
-PHONY += gcc-plugins
-gcc-plugins: scripts_basic
-ifdef CONFIG_GCC_PLUGINS
-	$(Q)$(MAKE) $(build)=scripts/gcc-plugins
-endif
-	@:
-
 include scripts/Makefile.gcc-plugins
 
 ifdef CONFIG_READABLE_ASM
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index cd7902ccd119..61fc4bbe0c21 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -29,21 +29,37 @@ ifdef CONFIG_GCC_PLUGINS
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
 
+  ifneq ($(PLUGINCC),)
+    # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
+    GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
+  endif
+
+  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+  GCC_PLUGIN := $(gcc-plugin-y)
+endif
+
+# If plugins aren't supported, abort the build before hard-to-read compiler
+# errors start getting spewed by the main build.
+PHONY += gcc-plugins-check
+gcc-plugins-check: FORCE
+ifdef CONFIG_GCC_PLUGINS
   ifeq ($(PLUGINCC),)
     ifneq ($(GCC_PLUGINS_CFLAGS),)
       ifeq ($(call cc-ifversion, -ge, 0405, y), y)
-        PLUGINCC := $(shell $(CONFIG_SHELL) -x $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
-        $(warning warning: your gcc installation does not support plugins, perhaps the necessary headers are missing?)
+	$(Q)$(srctree)/scripts/gcc-plugin.sh --show-error "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)" || true
+	@echo "Cannot use CONFIG_GCC_PLUGINS: your gcc installation does not support plugins, perhaps the necessary headers are missing?" >&2 && exit 1
       else
-        $(warning warning: your gcc version does not support plugins, you should upgrade it to gcc 4.5 at least)
+	@echo "Cannot use CONFIG_GCC_PLUGINS: your gcc version does not support plugins, you should upgrade it to at least gcc 4.5" >&2 && exit 1
       endif
     endif
-  else
-    # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
-    GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
   endif
+endif
+	@:
 
-  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
-  GCC_PLUGIN := $(gcc-plugin-y)
-
+# Actually do the build, if requested.
+PHONY += gcc-plugins
+gcc-plugins: scripts_basic gcc-plugins-check
+ifdef CONFIG_GCC_PLUGINS
+	$(Q)$(MAKE) $(build)=scripts/gcc-plugins
 endif
+	@:
diff --git a/scripts/gcc-plugin.sh b/scripts/gcc-plugin.sh
index fb9207565471..b65224bfb847 100755
--- a/scripts/gcc-plugin.sh
+++ b/scripts/gcc-plugin.sh
@@ -1,5 +1,12 @@
 #!/bin/sh
 srctree=$(dirname "$0")
+
+SHOW_ERROR=
+if [ "$1" = "--show-error" ] ; then
+	SHOW_ERROR=1
+	shift || true
+fi
+
 gccplugins_dir=$($3 -print-file-name=plugin)
 plugincc=$($1 -E -x c++ - -o /dev/null -I"${srctree}"/gcc-plugins -I"${gccplugins_dir}"/include 2>&1 <<EOF
 #include "gcc-common.h"
@@ -13,6 +20,9 @@ EOF
 
 if [ $? -ne 0 ]
 then
+	if [ -n "$SHOW_ERROR" ] ; then
+		echo "${plugincc}" >&2
+	fi
 	exit 1
 fi
 
@@ -48,4 +58,8 @@ then
 	echo "$2"
 	exit 0
 fi
+
+if [ -n "$SHOW_ERROR" ] ; then
+	echo "${plugincc}" >&2
+fi
 exit 1
-- 
2.7.4


-- 
Kees Cook
Chrome OS & Brillo Security
