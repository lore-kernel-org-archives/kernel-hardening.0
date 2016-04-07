Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 7 Apr 2016 23:11:43 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160407231143.0482c1a67c1d98cc3ccdfad8@gmail.com>
In-Reply-To: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v6 1/6] Shared library support
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

Infrastructure for building independent shared library targets.
This effectively also reverts commit 62e2210798ed38928ab24841e8b4878a
(Masahiro Yamada, kbuild: drop shared library support from Makefile.host).

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 Documentation/kbuild/makefiles.txt | 39 ++++++++++++++++-----
 scripts/Makefile.build             |  2 +-
 scripts/Makefile.clean             |  3 +-
 scripts/Makefile.host              | 70 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 103 insertions(+), 11 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 13f888a..250729b 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -23,10 +23,11 @@ This document describes the Linux kernel Makefiles.
 	=== 4 Host Program support
 	   --- 4.1 Simple Host Program
 	   --- 4.2 Composite Host Programs
-	   --- 4.3 Using C++ for host programs
-	   --- 4.4 Controlling compiler options for host programs
-	   --- 4.5 When host programs are actually built
-	   --- 4.6 Using hostprogs-$(CONFIG_FOO)
+	   --- 4.3 Defining shared libraries
+	   --- 4.4 Using C++ for host programs
+	   --- 4.5 Controlling compiler options for host programs
+	   --- 4.6 When host programs are actually built
+	   --- 4.7 Using hostprogs-$(CONFIG_FOO)
 
 	=== 5 Kbuild clean infrastructure
 
@@ -643,7 +644,29 @@ Both possibilities are described in the following.
 	Finally, the two .o files are linked to the executable, lxdialog.
 	Note: The syntax <executable>-y is not permitted for host-programs.
 
---- 4.3 Using C++ for host programs
+--- 4.3 Defining shared libraries
+
+	Objects with extension .so are considered shared libraries, and
+	will be compiled as position independent objects.
+	Kbuild provides support for shared libraries, but the usage
+	shall be restricted.
+	In the following example the libkconfig.so shared library is used
+	to link the executable conf.
+
+	Example:
+		#scripts/kconfig/Makefile
+		hostprogs-y     := conf
+		conf-objs       := conf.o libkconfig.so
+		libkconfig-objs := expr.o type.o
+
+	Shared libraries always require a corresponding -objs line, and
+	in the example above the shared library libkconfig is composed by
+	the two objects expr.o and type.o.
+	expr.o and type.o will be built as position independent code and
+	linked as a shared library libkconfig.so. C++ is not supported for
+	shared libraries.
+
+--- 4.4 Using C++ for host programs
 
 	kbuild offers support for host programs written in C++. This was
 	introduced solely to support kconfig, and is not recommended
@@ -666,7 +689,7 @@ Both possibilities are described in the following.
 		qconf-cxxobjs := qconf.o
 		qconf-objs    := check.o
 
---- 4.4 Controlling compiler options for host programs
+--- 4.5 Controlling compiler options for host programs
 
 	When compiling host programs, it is possible to set specific flags.
 	The programs will always be compiled utilising $(HOSTCC) passed
@@ -694,7 +717,7 @@ Both possibilities are described in the following.
 	When linking qconf, it will be passed the extra option
 	"-L$(QTDIR)/lib".
 
---- 4.5 When host programs are actually built
+--- 4.6 When host programs are actually built
 
 	Kbuild will only build host-programs when they are referenced
 	as a prerequisite.
@@ -725,7 +748,7 @@ Both possibilities are described in the following.
 	This will tell kbuild to build lxdialog even if not referenced in
 	any rule.
 
---- 4.6 Using hostprogs-$(CONFIG_FOO)
+--- 4.7 Using hostprogs-$(CONFIG_FOO)
 
 	A typical pattern in a Kbuild file looks like this:
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index e1bc190..b2ce235 100644
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
index 133edfa..3439bd8 100644
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
@@ -42,6 +60,18 @@ host-cxxmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))
 # C++ Object (.o) files compiled from .cc files
 host-cxxobjs	:= $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))
 
+# Shared libaries (only .c supported)
+# Shared libraries (.so) - all .so files referenced in "xxx-objs"
+host-cshlib	:= $(sort $(filter %.so, $(__hostlibs)))
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
@@ -56,6 +86,10 @@ host-cmulti	:= $(addprefix $(obj)/,$(host-cmulti))
 host-cobjs	:= $(addprefix $(obj)/,$(host-cobjs))
 host-cxxmulti	:= $(addprefix $(obj)/,$(host-cxxmulti))
 host-cxxobjs	:= $(addprefix $(obj)/,$(host-cxxobjs))
+host-cshlib	:= $(addprefix $(obj)/,$(host-cshlib))
+host-cxxshlib	:= $(addprefix $(obj)/,$(host-cxxshlib))
+host-cshobjs	:= $(addprefix $(obj)/,$(host-cshobjs))
+host-cxxshobjs	:= $(addprefix $(obj)/,$(host-cxxshobjs))
 host-objdirs    := $(addprefix $(obj)/,$(host-objdirs))
 
 obj-dirs += $(host-objdirs)
@@ -124,5 +158,39 @@ quiet_cmd_host-cxxobjs	= HOSTCXX $@
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
+$(host-cshlib): FORCE
+	$(call if_changed,host-cshlib)
+$(call multi_depend, $(host-cshlib), .so, -objs -cshobjs)
+
+# Link a shared library, based on position independent .o files
+# *.o -> .so shared library (host-cxxshlib)
+quiet_cmd_host-cxxshlib	= HOSTLLD -shared $@
+      cmd_host-cxxshlib	= $(HOSTCXX) $(HOSTLDFLAGS) -shared -o $@ \
+			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
+			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
+$(host-cxxshlib): FORCE
+	$(call if_changed,host-cxxshlib)
+$(call multi_depend, $(host-cxxshlib), .so, -objs -cxxshobjs)
+
 targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
-	   $(host-cxxmulti) $(host-cxxobjs)
+	   $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) $(host-cxxshlib) $(host-cxxshobjs)
-- 
2.4.1
