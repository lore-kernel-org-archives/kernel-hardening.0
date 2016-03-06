Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Mar 2016 00:03:29 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160307000329.a51b2b8f4fdb0e60344f0b20@gmail.com>
In-Reply-To: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 1/5] Shared library support
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Infrastructure for building independent shared library targets.
This effectively also reverts commit 62e2210798ed38928ab24841e8b4878a
(Masahiro Yamada, kbuild: drop shared library support from Makefile.host).

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 scripts/Makefile.build |  2 +-
 scripts/Makefile.clean |  3 ++-
 scripts/Makefile.host  | 69 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 130a452..bd2a31e 100644
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
index 55c96cb..e4e88ab 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -38,7 +38,8 @@ subdir-ymn	:= $(addprefix $(obj)/,$(subdir-ymn))
 __clean-files	:= $(extra-y) $(extra-m) $(extra-)       \
 		   $(always) $(targets) $(clean-files)   \
 		   $(host-progs)                         \
-		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-)
+		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-) \
+		   $(hostlibs-y) $(hostlibs-m) $(hostlibs-)
 
 __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
 
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 133edfa..4d180d9 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -20,7 +20,25 @@
 # Will compile qconf as a C++ program, and menu as a C program.
 # They are linked as C++ code to the executable qconf
 
+# hostprogs-y := conf
+# conf-objs  := conf.o libkconfig.so
+# libkconfig-objs := expr.o type.o
+# Will create a shared library named libkconfig.so that consists of
+# expr.o and type.o (they are both compiled as C code and the object files
+# are made as position independent code).
+# conf.c is compiled as a C program, and conf.o is linked together with
+# libkconfig.so as the executable conf.
+# Note: Shared libraries consisting of C++ files are not supported
+
+# hostcc-option
+# Usage: cflags-y += $(call hostcc-option,-march=winchip-c6,-march=i586)
+
+hostcc-option = $(call try-run,\
+	$(HOSTCC) $(HOSTCFLAGS) $(HOST_EXTRACFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
+
 __hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
+__hostlibs := $(sort $(hostlibs-y) $(hostlibs-m))
+__hostcxxlibs := $(sort $(hostcxxlibs-y) $(hostcxxlibs-m))
 
 # C code
 # Executables compiled from a single .c file
@@ -42,6 +60,19 @@ host-cxxmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))
 # C++ Object (.o) files compiled from .cc files
 host-cxxobjs	:= $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))
 
+# Shared libaries (only .c supported)
+# Shared libraries (.so) - all .so files referenced in "xxx-objs"
+host-cshlib	:= $(sort $(filter %.so, $(host-cobjs)))
+host-cshlib	+= $(sort $(filter %.so, $(__hostlibs)))
+host-cxxshlib	:= $(sort $(filter %.so, $(__hostcxxlibs)))
+# Remove .so files from "xxx-objs"
+host-cobjs	:= $(filter-out %.so,$(host-cobjs))
+host-cxxobjs	:= $(filter-out %.so,$(host-cxxobjs))
+
+# Object (.o) files used by the shared libaries
+host-cshobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))
+host-cxxshobjs	:= $(sort $(foreach m,$(host-cxxshlib),$($(m:.so=-objs))))
+
 # output directory for programs/.o files
 # hostprogs-y := tools/build may have been specified.
 # Retrieve also directory of .o files from prog-objs or prog-cxxobjs notation
@@ -56,6 +87,10 @@ host-cmulti	:= $(addprefix $(obj)/,$(host-cmulti))
 host-cobjs	:= $(addprefix $(obj)/,$(host-cobjs))
 host-cxxmulti	:= $(addprefix $(obj)/,$(host-cxxmulti))
 host-cxxobjs	:= $(addprefix $(obj)/,$(host-cxxobjs))
+host-cshlib	:= $(addprefix $(obj)/,$(host-cshlib))
+host-cxxshlib	:= $(addprefix $(obj)/,$(host-cxxshlib))
+host-cshobjs	:= $(addprefix $(obj)/,$(host-cshobjs))
+host-cxxshobjs	:= $(addprefix $(obj)/,$(host-cxxshobjs))
 host-objdirs    := $(addprefix $(obj)/,$(host-objdirs))
 
 obj-dirs += $(host-objdirs)
@@ -124,5 +159,37 @@ quiet_cmd_host-cxxobjs	= HOSTCXX $@
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
+$(host-cshlib): $(obj)/%: $(host-cshobjs) FORCE
+	$(call if_changed,host-cshlib)
+
+# Link a shared library, based on position independent .o files
+# *.o -> .so shared library (host-cxxshlib)
+quiet_cmd_host-cxxshlib	= HOSTLLD -shared $@
+      cmd_host-cxxshlib	= $(HOSTCXX) $(HOSTLDFLAGS) -shared -o $@ \
+			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
+			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
+$(host-cxxshlib): $(obj)/%: $(host-cxxshobjs) FORCE
+	$(call if_changed,host-cxxshlib)
+
 targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
-	   $(host-cxxmulti) $(host-cxxobjs)
+	   $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) $(host-cxxshlib) $(host-cxxshobjs)
-- 
2.4.1
