Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 13 May 2016 01:56:19 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160513015619.0a92762bf9167233a5990226@gmail.com>
In-Reply-To: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v8 1/4] Shared library support
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

Infrastructure for building independent shared library targets.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 scripts/Makefile.build |  2 +-
 scripts/Makefile.clean |  4 +++-
 scripts/Makefile.host  | 55 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0d1ca5b..11602e5 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -60,7 +60,7 @@ endif
 endif
 
 # Do not include host rules unless needed
-ifneq ($(hostprogs-y)$(hostprogs-m),)
+ifneq ($(hostprogs-y)$(hostprogs-m)$(hostlibs-y)$(hostlibs-m)$(hostcxxlibs-y)$(hostcxxlibs-m),)
 include scripts/Makefile.host
 endif
 
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 55c96cb..50616ea 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -38,7 +38,9 @@ subdir-ymn	:= $(addprefix $(obj)/,$(subdir-ymn))
 __clean-files	:= $(extra-y) $(extra-m) $(extra-)       \
 		   $(always) $(targets) $(clean-files)   \
 		   $(host-progs)                         \
-		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-)
+		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-) \
+		   $(hostlibs-y) $(hostlibs-m) $(hostlibs-) \
+		   $(hostcxxlibs-y) $(hostcxxlibs-m)
 
 __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
 
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 133edfa..45b5b1a 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -20,7 +20,15 @@
 # Will compile qconf as a C++ program, and menu as a C program.
 # They are linked as C++ code to the executable qconf
 
+# hostcc-option
+# Usage: cflags-y += $(call hostcc-option,-march=winchip-c6,-march=i586)
+
+hostcc-option = $(call try-run,\
+	$(HOSTCC) $(HOSTCFLAGS) $(HOST_EXTRACFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
+
 __hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
+host-cshlib := $(sort $(hostlibs-y) $(hostlibs-m))
+host-cxxshlib := $(sort $(hostcxxlibs-y) $(hostcxxlibs-m))
 
 # C code
 # Executables compiled from a single .c file
@@ -42,6 +50,10 @@ host-cxxmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))
 # C++ Object (.o) files compiled from .cc files
 host-cxxobjs	:= $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))
 
+# Object (.o) files used by the shared libaries
+host-cshobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))
+host-cxxshobjs	:= $(sort $(foreach m,$(host-cxxshlib),$($(m:.so=-objs))))
+
 # output directory for programs/.o files
 # hostprogs-y := tools/build may have been specified.
 # Retrieve also directory of .o files from prog-objs or prog-cxxobjs notation
@@ -56,6 +68,10 @@ host-cmulti	:= $(addprefix $(obj)/,$(host-cmulti))
 host-cobjs	:= $(addprefix $(obj)/,$(host-cobjs))
 host-cxxmulti	:= $(addprefix $(obj)/,$(host-cxxmulti))
 host-cxxobjs	:= $(addprefix $(obj)/,$(host-cxxobjs))
+host-cshlib	:= $(addprefix $(obj)/,$(host-cshlib))
+host-cxxshlib	:= $(addprefix $(obj)/,$(host-cxxshlib))
+host-cshobjs	:= $(addprefix $(obj)/,$(host-cshobjs))
+host-cxxshobjs	:= $(addprefix $(obj)/,$(host-cxxshobjs))
 host-objdirs    := $(addprefix $(obj)/,$(host-objdirs))
 
 obj-dirs += $(host-objdirs)
@@ -124,5 +140,42 @@ quiet_cmd_host-cxxobjs	= HOSTCXX $@
 $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
 	$(call if_changed_dep,host-cxxobjs)
 
+# Compile .c file, create position independent .o file
+# host-cshobjs -> .o
+quiet_cmd_host-cshobjs	= HOSTCC  -fPIC $@
+      cmd_host-cshobjs	= $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
+$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
+	$(call if_changed_dep,host-cshobjs)
+
+# Compile .c file, create position independent .o file
+# Note that plugin capable gcc versions can be either C or C++ based
+# therefore plugin source files have to be compilable in both C and C++ mode.
+# This is why a C++ compiler is invoked on a .c file.
+# host-cxxshobjs -> .o
+quiet_cmd_host-cxxshobjs	= HOSTCXX -fPIC $@
+      cmd_host-cxxshobjs	= $(HOSTCXX) $(hostcxx_flags) -fPIC -c -o $@ $<
+$(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
+	$(call if_changed_dep,host-cxxshobjs)
+
+# Link a shared library, based on position independent .o files
+# *.o -> .so shared library (host-cshlib)
+quiet_cmd_host-cshlib	= HOSTLLD -shared $@
+      cmd_host-cshlib	= $(HOSTCC) $(HOSTLDFLAGS) -shared -o $@ \
+			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
+			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
+$(host-cshlib): FORCE
+	$(call if_changed,host-cshlib)
+$(call multi_depend, $(host-cshlib), .so, -objs)
+
+# Link a shared library, based on position independent .o files
+# *.o -> .so shared library (host-cxxshlib)
+quiet_cmd_host-cxxshlib	= HOSTLLD -shared $@
+      cmd_host-cxxshlib	= $(HOSTCXX) $(HOSTLDFLAGS) -shared -o $@ \
+			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
+			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
+$(host-cxxshlib): FORCE
+	$(call if_changed,host-cxxshlib)
+$(call multi_depend, $(host-cxxshlib), .so, -objs)
+
 targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
-	   $(host-cxxmulti) $(host-cxxobjs)
+	   $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) $(host-cxxshlib) $(host-cxxshobjs)
-- 
2.8.1
