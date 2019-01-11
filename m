From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 2/2] kbuild: simplify GCC plugin build rules
Date: Fri, 11 Jan 2019 18:18:47 +0900
Message-Id: <1547198328-26359-2-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1547198328-26359-1-git-send-email-yamada.masahiro@socionext.com>
References: <1547198328-26359-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>
List-ID: <kernel-hardening.lists.openwall.com>

GCC-plugin is the only user of the shared library build rules in
scripts/Makefile.host. Hence, those rules do not need to be treewide
available.

The build rules in scripts/Makefile.host are written in a too generic
way. I guess the main reason is because commit 24403874316a ("Shared
library support") revived the code ripped off by commit 62e2210798ed
("kbuild: drop shared library support from Makefile.host").

Currently, every plugin is built from a single C file. So, all we need
is a pattern rule to create %.so from %.c.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

I want Acked-by from GCC plugin folks,
so this series can go into kbuild tree.


 scripts/Makefile.build       |  2 +-
 scripts/Makefile.clean       |  4 +---
 scripts/Makefile.host        | 49 +-------------------------------------------
 scripts/gcc-plugins/Makefile | 28 ++++++++++++++-----------
 4 files changed, 19 insertions(+), 64 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index fd03d60..d71a4ed 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -44,7 +44,7 @@ include $(kbuild-file)
 include scripts/Makefile.lib
 
 # Do not include host rules unless needed
-ifneq ($(hostprogs-y)$(hostprogs-m)$(hostlibs-y)$(hostlibs-m)$(hostcxxlibs-y)$(hostcxxlibs-m),)
+ifneq ($(hostprogs-y)$(hostprogs-m),)
 include scripts/Makefile.host
 endif
 
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 0b80e320..032160a 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -38,9 +38,7 @@ subdir-ymn	:= $(addprefix $(obj)/,$(subdir-ymn))
 
 __clean-files	:= $(extra-y) $(extra-m) $(extra-)       \
 		   $(always) $(targets) $(clean-files)   \
-		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-) \
-		   $(hostlibs-y) $(hostlibs-m) $(hostlibs-) \
-		   $(hostcxxlibs-y) $(hostcxxlibs-m)
+		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-)
 
 __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
 
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index f2e15de..0486180 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -22,8 +22,6 @@
 # They are linked as C++ code to the executable qconf
 
 __hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
-host-cshlib := $(sort $(hostlibs-y) $(hostlibs-m))
-host-cxxshlib := $(sort $(hostcxxlibs-y) $(hostcxxlibs-m))
 
 # C code
 # Executables compiled from a single .c file
@@ -45,19 +43,11 @@ host-cxxmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))
 # C++ Object (.o) files compiled from .cc files
 host-cxxobjs	:= $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))
 
-# Object (.o) files used by the shared libaries
-host-cshobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))
-host-cxxshobjs	:= $(sort $(foreach m,$(host-cxxshlib),$($(m:.so=-objs))))
-
 host-csingle	:= $(addprefix $(obj)/,$(host-csingle))
 host-cmulti	:= $(addprefix $(obj)/,$(host-cmulti))
 host-cobjs	:= $(addprefix $(obj)/,$(host-cobjs))
 host-cxxmulti	:= $(addprefix $(obj)/,$(host-cxxmulti))
 host-cxxobjs	:= $(addprefix $(obj)/,$(host-cxxobjs))
-host-cshlib	:= $(addprefix $(obj)/,$(host-cshlib))
-host-cxxshlib	:= $(addprefix $(obj)/,$(host-cxxshlib))
-host-cshobjs	:= $(addprefix $(obj)/,$(host-cshobjs))
-host-cxxshobjs	:= $(addprefix $(obj)/,$(host-cxxshobjs))
 
 #####
 # Handle options to gcc. Support building with separate output directory
@@ -126,42 +116,5 @@ quiet_cmd_host-cxxobjs	= HOSTCXX $@
 $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
 	$(call if_changed_dep,host-cxxobjs)
 
-# Compile .c file, create position independent .o file
-# host-cshobjs -> .o
-quiet_cmd_host-cshobjs	= HOSTCC  -fPIC $@
-      cmd_host-cshobjs	= $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
-$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
-	$(call if_changed_dep,host-cshobjs)
-
-# Compile .c file, create position independent .o file
-# Note that plugin capable gcc versions can be either C or C++ based
-# therefore plugin source files have to be compilable in both C and C++ mode.
-# This is why a C++ compiler is invoked on a .c file.
-# host-cxxshobjs -> .o
-quiet_cmd_host-cxxshobjs	= HOSTCXX -fPIC $@
-      cmd_host-cxxshobjs	= $(HOSTCXX) $(hostcxx_flags) -fPIC -c -o $@ $<
-$(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
-	$(call if_changed_dep,host-cxxshobjs)
-
-# Link a shared library, based on position independent .o files
-# *.o -> .so shared library (host-cshlib)
-quiet_cmd_host-cshlib	= HOSTLLD -shared $@
-      cmd_host-cshlib	= $(HOSTCC) $(hostld_flags) -shared -o $@ \
-			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
-			  $(hostld_libs)
-$(host-cshlib): FORCE
-	$(call if_changed,host-cshlib)
-$(call multi_depend, $(host-cshlib), .so, -objs)
-
-# Link a shared library, based on position independent .o files
-# *.o -> .so shared library (host-cxxshlib)
-quiet_cmd_host-cxxshlib	= HOSTLLD -shared $@
-      cmd_host-cxxshlib	= $(HOSTCXX) $(hostld_flags) -shared -o $@ \
-			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
-			  $(hostld_libs)
-$(host-cxxshlib): FORCE
-	$(call if_changed,host-cxxshlib)
-$(call multi_depend, $(host-cxxshlib), .so, -objs)
-
 targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
-	   $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) $(host-cxxshlib) $(host-cxxshobjs)
+	   $(host-cxxmulti) $(host-cxxobjs)
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index aa0d0ec..a09404d 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -3,18 +3,17 @@ PLUGINCC := $(CONFIG_PLUGIN_HOSTCC:"%"=%)
 GCC_PLUGINS_DIR := $(shell $(CC) -print-file-name=plugin)
 
 ifeq ($(PLUGINCC),$(HOSTCC))
-  HOSTLIBS := hostlibs
-  HOST_EXTRACFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu99 -ggdb
-  export HOST_EXTRACFLAGS
+  quiet_cmd_plugin = HOSTCC  $@
+  pluginc_flags = $(hostc_flags) -std=gnu99
 else
-  HOSTLIBS := hostcxxlibs
-  HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti
-  HOST_EXTRACXXFLAGS += -fno-exceptions -fasynchronous-unwind-tables -ggdb
-  HOST_EXTRACXXFLAGS += -Wno-narrowing -Wno-unused-variable
-  export HOST_EXTRACXXFLAGS
+  quiet_cmd_plugin = HOSTCXX $@
+  pluginc_flags = $(hostcxx_flags) -std=gnu++98 -fno-rtti -fno-exceptions \
+	-fasynchronous-unwind-tables -Wno-narrowing -Wno-unused-variable
 endif
 
-$(obj)/randomize_layout_plugin.o: $(objtree)/$(obj)/randomize_layout_seed.h
+pluginc_flags += -I$(GCC_PLUGINS_DIR)/include -I$(src) -ggdb -fPIC
+
+$(obj)/randomize_layout_plugin.so: $(objtree)/$(obj)/randomize_layout_seed.h
 quiet_cmd_create_randomize_layout_seed = GENSEED $@
 cmd_create_randomize_layout_seed = \
   $(CONFIG_SHELL) $(srctree)/$(src)/gen-random-seed.sh $@ $(objtree)/include/generated/randomize_layout_hash.h
@@ -22,9 +21,14 @@ $(objtree)/$(obj)/randomize_layout_seed.h: FORCE
 	$(call if_changed,create_randomize_layout_seed)
 targets = randomize_layout_seed.h randomize_layout_hash.h
 
-$(HOSTLIBS)-y := $(foreach p,$(GCC_PLUGIN),$(if $(findstring /,$(p)),,$(p)))
-always := $($(HOSTLIBS)-y)
+extra-y := $(GCC_PLUGIN)
+
+cmd_plugin = $(PLUGINCC) $(pluginc_flags) -shared $(hostld_flags) \
+	     -o $@ $< $(hostld_libs)
+
+$(obj)/%.so: $(src)/%.c FORCE
+	$(call if_changed_dep,plugin)
 
-$(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
+hostprogs-y += dummy_to_include_scripts/Makefile.host
 
 clean-files += *.so
-- 
2.7.4
