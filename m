From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] gcc-plugins: remove unused GCC_PLUGIN_SUBDIR
Date: Tue,  3 Jul 2018 09:39:12 +0900
Message-Id: <1530578352-18613-1-git-send-email-yamada.masahiro@socionext.com>
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>, linux-kbuild@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

GCC_PLUGIN_SUBDIR has never been used.  If you really need this in
the future, please re-add it then.

For now, the code is unused. Remove.

'export HOSTLIBS' is not necessary either.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 scripts/Makefile.gcc-plugins | 3 +--
 scripts/gcc-plugins/Makefile | 5 -----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index c961b9a..f9942d9 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -19,7 +19,7 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE)	+= -fplugin-arg-ra
 
 GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
-export GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
+export GCC_PLUGINS_CFLAGS GCC_PLUGIN
 export DISABLE_LATENT_ENTROPY_PLUGIN
 
 # sancov_plugin.so can be only in CFLAGS_KCOV because avoid duplication.
@@ -27,7 +27,6 @@ GCC_PLUGINS_CFLAGS := $(filter-out %/sancov_plugin.so, $(GCC_PLUGINS_CFLAGS))
 
 KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
 GCC_PLUGIN := $(gcc-plugin-y)
-GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
 
 # Actually do the build, if requested.
 PHONY += gcc-plugins
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index 3262546..aa0d0ec 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -14,8 +14,6 @@ else
   export HOST_EXTRACXXFLAGS
 endif
 
-export HOSTLIBS
-
 $(obj)/randomize_layout_plugin.o: $(objtree)/$(obj)/randomize_layout_seed.h
 quiet_cmd_create_randomize_layout_seed = GENSEED $@
 cmd_create_randomize_layout_seed = \
@@ -29,7 +27,4 @@ always := $($(HOSTLIBS)-y)
 
 $(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
 
-subdir-y := $(GCC_PLUGIN_SUBDIR)
-subdir-  += $(GCC_PLUGIN_SUBDIR)
-
 clean-files += *.so
-- 
2.7.4
