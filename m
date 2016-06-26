Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 26 Jun 2016 17:38:20 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160626173820.13ad67e14e7a29a6563fe129@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH] Add support for complex gcc plugins that don't fit in a
 single file
To: keescook@chromium.org
Cc: mmarek@suse.com, linux-kbuild@vger.kernel.org, kernel-hardening@lists.openwall.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>


Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 scripts/Makefile.gcc-plugins | 3 ++-
 scripts/gcc-plugins/Makefile | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 61fc4bb..1f922df 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -27,7 +27,7 @@ ifdef CONFIG_GCC_PLUGINS
 
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
-  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
+  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
 
   ifneq ($(PLUGINCC),)
     # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
@@ -36,6 +36,7 @@ ifdef CONFIG_GCC_PLUGINS
 
   KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
   GCC_PLUGIN := $(gcc-plugin-y)
+  GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
 endif
 
 # If plugins aren't supported, abort the build before hard-to-read compiler
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index 898449d..94fa139 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -12,14 +12,17 @@ else
   export HOST_EXTRACXXFLAGS
 endif
 
-export GCCPLUGINS_DIR HOSTLIBS
-
 ifneq ($(CFLAGS_KCOV), $(SANCOV_PLUGIN))
   GCC_PLUGIN := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGIN))
 endif
 
-$(HOSTLIBS)-y := $(GCC_PLUGIN)
+export HOSTLIBS
+
+$(HOSTLIBS)-y := $(foreach p,$(GCC_PLUGIN),$(if $(findstring /,$(p)),,$(p)))
 always := $($(HOSTLIBS)-y)
 $(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
 
+subdir-y := $(GCC_PLUGIN_SUBDIR)
+subdir-  += $(GCC_PLUGIN_SUBDIR)
+
 clean-files += *.so
-- 
2.8.1
