Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 22 Feb 2016 20:14:47 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160222201447.9d08927b39abeafa9dc7f57f@gmail.com>
In-Reply-To: <20160222201335.449323716ca4d929f92424d5@gmail.com>
References: <20160222201335.449323716ca4d929f92424d5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 1/3] GCC plugin infrastructure
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk
List-ID: <kernel-hardening.lists.openwall.com>

This patch allows to build the whole kernel with GCC plugins. It was ported from
grsecurity/PaX. The infrastructure supports building out-of-tree modules and
building in a separate directory. Cross-compilation is supported too but
currently only the x86 architecture enables plugins.

The directory of the gcc plugins is tools/gcc. You can use a file or a directory
there. The plugins compile with these options:
 * -fno-rtti: gcc is compiled with this option so the plugins must use it too
 * -fno-exceptions: this is inherited from gcc too
 * -fasynchronous-unwind-tables: this is inherited from gcc too
 * -ggdb: it is useful for debugging a plugin (better backtrace on internal
    errors)
 * -Wno-narrowing: to suppress warnings from gcc headers (ipa-utils.h)
 * -Wno-unused-variable: to suppress warnings from gcc headers (gcc_version
    variable, plugin-version.h)

The infrastructure introduces a new Makefile target called gcc-plugins. It
supports all gcc versions from 4.5 to 6.0. The scripts/gcc-plugin.sh script
chooses the proper host compiler (gcc-4.7 can be built by either gcc or g++).
This script also checks the availability of the included headers in
tools/gcc/gcc-common.h.

The gcc-common.h header contains frequently included headers for GCC plugins
and it has a compatibility layer for the supported gcc versions.

The gcc-generate-*-pass.h headers automatically generate the registration
structures for GIMPLE, SIMPLE_IPA, IPA and RTL passes.

Note that 'make clean' keeps the *.so files (only the distclean or mrproper
targets clean all) because they are needed for out-of-tree modules.
---
 Documentation/dontdiff                   |   1 +
 Makefile                                 |  41 +-
 arch/Kconfig                             |  11 +
 arch/x86/Kconfig                         |   1 +
 init/Makefile                            |   3 +
 scripts/Makefile.build                   |   2 +-
 scripts/Makefile.clean                   |   3 +-
 scripts/Makefile.gcc-plugins             |  26 +
 scripts/Makefile.host                    |  69 ++-
 scripts/gcc-plugin.sh                    |  51 ++
 scripts/link-vmlinux.sh                  |   2 +-
 scripts/package/builddeb                 |   1 +
 tools/gcc/Makefile                       |  17 +
 tools/gcc/gcc-common.h                   | 794 +++++++++++++++++++++++++++++++
 tools/gcc/gcc-generate-gimple-pass.h     | 172 +++++++
 tools/gcc/gcc-generate-ipa-pass.h        | 286 +++++++++++
 tools/gcc/gcc-generate-rtl-pass.h        | 172 +++++++
 tools/gcc/gcc-generate-simple_ipa-pass.h | 172 +++++++
 18 files changed, 1809 insertions(+), 15 deletions(-)
 create mode 100644 scripts/Makefile.gcc-plugins
 create mode 100644 scripts/gcc-plugin.sh
 create mode 100644 tools/gcc/Makefile
 create mode 100644 tools/gcc/gcc-common.h
 create mode 100644 tools/gcc/gcc-generate-gimple-pass.h
 create mode 100644 tools/gcc/gcc-generate-ipa-pass.h
 create mode 100644 tools/gcc/gcc-generate-rtl-pass.h
 create mode 100644 tools/gcc/gcc-generate-simple_ipa-pass.h

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 8ea834f..5385cba 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -3,6 +3,7 @@
 *.bc
 *.bin
 *.bz2
+*.c.[012]*.*
 *.cis
 *.cpio
 *.csp
diff --git a/Makefile b/Makefile
index 667630b..837a9e1 100644
--- a/Makefile
+++ b/Makefile
@@ -435,8 +435,8 @@ export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn \
 # Rules shared between *config targets and build targets
 
 # Basic helpers built in scripts/
-PHONY += scripts_basic
-scripts_basic:
+PHONY += scripts_basic gcc-plugins
+scripts_basic: gcc-plugins
 	$(Q)$(MAKE) $(build)=scripts/basic
 	$(Q)rm -f .tmp_quiet_recordmcount
 
@@ -623,6 +623,8 @@ endif
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
 
+include scripts/Makefile.gcc-plugins
+
 ifdef CONFIG_READABLE_ASM
 # Disable optimizations that make assembler listings hard to read.
 # reorder blocks reorders the control in the function
@@ -946,6 +948,8 @@ endif
 
 # The actual objects are generated when descending,
 # make sure no implicit rule kicks in
+$(filter-out $(init-y),$(vmlinux-deps)): KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+$(filter-out $(init-y),$(vmlinux-deps)): KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
 $(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
 
 # Handle descending into subdirectories listed in $(vmlinux-dirs)
@@ -955,7 +959,7 @@ $(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
 # Error messages still appears in the original language
 
 PHONY += $(vmlinux-dirs)
-$(vmlinux-dirs): prepare scripts
+$(vmlinux-dirs): gcc-plugins prepare scripts
 	$(Q)$(MAKE) $(build)=$@
 
 define filechk_kernel.release
@@ -998,10 +1002,13 @@ prepare1: prepare2 $(version_h) include/generated/utsrelease.h \
 
 archprepare: archheaders archscripts prepare1 scripts_basic
 
+prepare0: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+prepare0: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
 
 # All the preparing..
+prepare: KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS))
 prepare: prepare0
 
 # Generate some files
@@ -1112,6 +1119,8 @@ all: modules
 # using awk while concatenating to the final file.
 
 PHONY += modules
+modules: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+modules: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
 	@$(kecho) '  Building modules, stage 2.';
@@ -1127,7 +1136,7 @@ modules.builtin: $(vmlinux-dirs:%=%/modules.builtin)
 
 # Target to prepare building external modules
 PHONY += modules_prepare
-modules_prepare: prepare scripts
+modules_prepare: gcc-plugins prepare scripts
 
 # Target to install modules
 PHONY += modules_install
@@ -1232,7 +1241,7 @@ distclean: mrproper
 	@find $(srctree) $(RCS_FIND_IGNORE) \
 		\( -name '*.orig' -o -name '*.rej' -o -name '*~' \
 		-o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
-		-o -name '.*.rej' -o -name '*%'  -o -name 'core' \) \
+		-o -name '.*.rej' -o -name '*.so' -o -name '*%' -o -name 'core' \) \
 		-type f -print | xargs rm -f
 
 
@@ -1399,6 +1408,8 @@ PHONY += $(module-dirs) modules
 $(module-dirs): crmodverdir $(objtree)/Module.symvers
 	$(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
 
+modules: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+modules: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
 modules: $(module-dirs)
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
@@ -1540,17 +1551,21 @@ else
         target-dir = $(if $(KBUILD_EXTMOD),$(dir $<),$(dir $@))
 endif
 
-%.s: %.c prepare scripts FORCE
+%.s: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+%.s: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
+%.s: %.c gcc-plugins prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.i: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
-%.o: %.c prepare scripts FORCE
+%.o: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+%.o: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
+%.o: %.c gcc-plugins prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.lst: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
-%.s: %.S prepare scripts FORCE
+%.s: %.S gcc-plugins prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
-%.o: %.S prepare scripts FORCE
+%.o: %.S gcc-plugins prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.symtypes: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
@@ -1562,11 +1577,15 @@ endif
 	$(build)=$(build-dir)
 # Make sure the latest headers are built for Documentation
 Documentation/: headers_install
-%/: prepare scripts FORCE
+%/: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+%/: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
+%/: gcc-plugins prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)
-%.ko: prepare scripts FORCE
+%.ko: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
+%.ko: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
+%.ko: gcc-plugins prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
 	$(build)=$(build-dir) $(@:.ko=.o)
diff --git a/arch/Kconfig b/arch/Kconfig
index 155e6cd..4570600 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -357,6 +357,17 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+menu "GCC plugins"
+
+config HAVE_GCC_PLUGINS
+	bool
+	help
+	  An arch should select this symbol if it supports building with
+	  gcc plugins.
+
+
+endmenu # "GCC plugins"
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 993aca4..a7d1e90 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -157,6 +157,7 @@ config X86
 	select VIRT_TO_BUS
 	select X86_DEV_DMA_OPS			if X86_64
 	select X86_FEATURE_NAMES		if PROC_FS
+	select HAVE_GCC_PLUGINS
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..6da2dc7 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -2,6 +2,9 @@
 # Makefile for the linux kernel.
 #
 
+ccflags-y := $(GCC_PLUGINS_CFLAGS)
+asflags-y := $(GCC_PLUGINS_AFLAGS)
+
 obj-y                          := main.o version.o mounts.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 2c47f9c..9d46008 100644
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
 
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
new file mode 100644
index 0000000..fa0a631
--- /dev/null
+++ b/scripts/Makefile.gcc-plugins
@@ -0,0 +1,26 @@
+ifeq ($(call cc-ifversion, -ge, 0408, y), y)
+PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCXX)" "$(HOSTCXX)" "$(CC)")
+else
+PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
+endif
+ifneq ($(PLUGINCC),)
+export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
+ifeq ($(KBUILD_EXTMOD),)
+gcc-plugins:
+	$(Q)$(MAKE) $(build)=tools/gcc
+else
+gcc-plugins: ;
+endif
+else
+gcc-plugins:
+ifeq ($(call cc-ifversion, -ge, 0405, y), y)
+	$(warning warning, your gcc installation does not support plugins, perhaps the necessary headers are missing?)
+ifeq ($(call cc-ifversion, -ge, 0408, y), y)
+	$(CONFIG_SHELL) -x $(srctree)/scripts/gcc-plugin.sh "$(HOSTCXX)" "$(HOSTCXX)" "$(CC)"
+else
+	$(CONFIG_SHELL) -x $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)"
+endif
+else
+	$(warning warning, your gcc version does not support plugins, you should upgrade it to gcc 4.5 at least)
+endif
+endif
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
diff --git a/scripts/gcc-plugin.sh b/scripts/gcc-plugin.sh
new file mode 100644
index 0000000..eaa4fce
--- /dev/null
+++ b/scripts/gcc-plugin.sh
@@ -0,0 +1,51 @@
+#!/bin/sh
+srctree=$(dirname "$0")
+gccplugins_dir=$($3 -print-file-name=plugin)
+plugincc=$($1 -E -x c++ - -o /dev/null -I"${srctree}"/../tools/gcc -I"${gccplugins_dir}"/include 2>&1 <<EOF
+#include "gcc-common.h"
+#if BUILDING_GCC_VERSION >= 4008 || defined(ENABLE_BUILD_WITH_CXX)
+#warning $2 CXX
+#else
+#warning $1 CC
+#endif
+EOF
+)
+
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+case "$plugincc" in
+	*"$1 CC"*)
+		echo "$1"
+		exit 0
+		;;
+
+	*"$2 CXX"*)
+		# the c++ compiler needs another test, see below
+		;;
+
+	*)
+		exit 1
+		;;
+esac
+
+# we need a c++ compiler that supports the designated initializer GNU extension
+plugincc=$($2 -c -x c++ -std=gnu++98 - -fsyntax-only -I"${srctree}"/../tools/gcc -I"${gccplugins_dir}"/include 2>&1 <<EOF
+#include "gcc-common.h"
+class test {
+public:
+	int test;
+} test = {
+	.test = 1
+};
+EOF
+)
+
+if [ $? -eq 0 ]
+then
+	echo "$2"
+	exit 0
+fi
+exit 1
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 49d61ad..69ee2cf 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -184,7 +184,7 @@ else
 fi;
 
 # final build of init/
-${MAKE} -f "${srctree}/scripts/Makefile.build" obj=init
+${MAKE} -f "${srctree}/scripts/Makefile.build" obj=init GCC_PLUGINS_CFLAGS="${GCC_PLUGINS_CFLAGS}" GCC_PLUGINS_AFLAGS="${GCC_PLUGINS_AFLAGS}"
 
 kallsymso=""
 kallsyms_vmlinux=""
diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 6c3b038..54e0b5e 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -326,6 +326,7 @@ fi
 (cd $srctree; find arch/$SRCARCH -name module.lds -o -name Kbuild.platforms -o -name Platform) >> "$objtree/debian/hdrsrcfiles"
 (cd $srctree; find $(find arch/$SRCARCH -name include -o -name scripts -type d) -type f) >> "$objtree/debian/hdrsrcfiles"
 (cd $objtree; find arch/$SRCARCH/include Module.symvers include scripts -type f) >> "$objtree/debian/hdrobjfiles"
+(cd $objtree; find tools/gcc -name \*.so -o -name gcc-common.h) >> "$objtree/debian/hdrobjfiles"
 destdir=$kernel_headers_dir/usr/src/linux-headers-$version
 mkdir -p "$destdir"
 (cd $srctree; tar -c -f - -T -) < "$objtree/debian/hdrsrcfiles" | (cd $destdir; tar -xf -)
diff --git a/tools/gcc/Makefile b/tools/gcc/Makefile
new file mode 100644
index 0000000..10c8b30
--- /dev/null
+++ b/tools/gcc/Makefile
@@ -0,0 +1,17 @@
+GCC_PLUGINS_DIR := $(shell $(CC) -print-file-name=plugin)
+
+ifeq ($(PLUGINCC),$(HOSTCC))
+HOSTLIBS := hostlibs
+HOST_EXTRACFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu99 -ggdb
+export HOST_EXTRACFLAGS
+else
+HOSTLIBS := hostcxxlibs
+HOST_EXTRACXXFLAGS += -I$(GCC_PLUGINS_DIR)/include -I$(src) -std=gnu++98 -fno-rtti -fno-exceptions -fasynchronous-unwind-tables -ggdb -Wno-narrowing -Wno-unused-variable
+export HOST_EXTRACXXFLAGS
+endif
+
+export GCCPLUGINS_DIR HOSTLIBS
+
+always := $($(HOSTLIBS)-y)
+
+cyc_complexity_plugin-objs := cyc_complexity_plugin.o
diff --git a/tools/gcc/gcc-common.h b/tools/gcc/gcc-common.h
new file mode 100644
index 0000000..355bb1a
--- /dev/null
+++ b/tools/gcc/gcc-common.h
@@ -0,0 +1,794 @@
+#ifndef GCC_COMMON_H_INCLUDED
+#define GCC_COMMON_H_INCLUDED
+
+#include "bversion.h"
+#if BUILDING_GCC_VERSION >= 6000
+#include "gcc-plugin.h"
+#else
+#include "plugin.h"
+#endif
+#include "plugin-version.h"
+#include "config.h"
+#include "system.h"
+#include "coretypes.h"
+#include "tm.h"
+#include "line-map.h"
+#include "input.h"
+#include "tree.h"
+
+#include "tree-inline.h"
+#include "version.h"
+#include "rtl.h"
+#include "tm_p.h"
+#include "flags.h"
+#include "hard-reg-set.h"
+#include "output.h"
+#include "except.h"
+#include "function.h"
+#include "toplev.h"
+#include "basic-block.h"
+#include "intl.h"
+#include "ggc.h"
+#include "timevar.h"
+
+#include "params.h"
+
+#if BUILDING_GCC_VERSION <= 4009
+#include "pointer-set.h"
+#else
+#include "hash-map.h"
+#endif
+
+#include "emit-rtl.h"
+#include "debug.h"
+#include "target.h"
+#include "langhooks.h"
+#include "cfgloop.h"
+#include "cgraph.h"
+#include "opts.h"
+
+#if BUILDING_GCC_VERSION == 4005
+#include <sys/mman.h>
+#endif
+
+#if BUILDING_GCC_VERSION >= 4007
+#include "tree-pretty-print.h"
+#include "gimple-pretty-print.h"
+#endif
+
+#if BUILDING_GCC_VERSION >= 4006
+#include "c-family/c-common.h"
+#else
+#include "c-common.h"
+#endif
+
+#if BUILDING_GCC_VERSION <= 4008
+#include "tree-flow.h"
+#else
+#include "tree-cfgcleanup.h"
+#include "tree-ssa-operands.h"
+#include "tree-into-ssa.h"
+#endif
+
+#if BUILDING_GCC_VERSION >= 4008
+#include "is-a.h"
+#endif
+
+#include "diagnostic.h"
+#include "tree-dump.h"
+#include "tree-pass.h"
+#include "predict.h"
+#include "ipa-utils.h"
+
+#if BUILDING_GCC_VERSION >= 4009
+#include "attribs.h"
+#include "varasm.h"
+#include "stor-layout.h"
+#include "internal-fn.h"
+#include "gimple-expr.h"
+#include "gimple-fold.h"
+#include "context.h"
+#include "tree-ssa-alias.h"
+#include "tree-ssa.h"
+#include "stringpool.h"
+#include "tree-ssanames.h"
+#include "print-tree.h"
+#include "tree-eh.h"
+#include "stmt.h"
+#include "gimplify.h"
+#endif
+
+#include "gimple.h"
+
+#if BUILDING_GCC_VERSION >= 4009
+#include "tree-ssa-operands.h"
+#include "tree-phinodes.h"
+#include "tree-cfg.h"
+#include "gimple-iterator.h"
+#include "gimple-ssa.h"
+#include "ssa-iterators.h"
+#endif
+
+#if BUILDING_GCC_VERSION >= 4007
+#else
+#endif
+#if BUILDING_GCC_VERSION >= 5000
+#include "builtins.h"
+#endif
+
+//#include "expr.h" where are you...
+extern rtx emit_move_insn(rtx x, rtx y);
+
+// missing from basic_block.h...
+extern void debug_dominance_info(enum cdi_direction dir);
+extern void debug_dominance_tree(enum cdi_direction dir, basic_block root);
+
+#if BUILDING_GCC_VERSION == 4006
+extern void debug_gimple_stmt(gimple);
+extern void debug_gimple_seq(gimple_seq);
+extern void print_gimple_seq(FILE *, gimple_seq, int, int);
+extern void print_gimple_stmt(FILE *, gimple, int, int);
+extern void print_gimple_expr(FILE *, gimple, int, int);
+extern void dump_gimple_stmt(pretty_printer *, gimple, int, int);
+#endif
+
+#ifdef __cplusplus
+static inline void debug_tree(const_tree t)
+{
+	debug_tree(CONST_CAST_TREE(t));
+}
+
+static inline void debug_gimple_stmt(const_gimple s)
+{
+	debug_gimple_stmt(CONST_CAST_GIMPLE(s));
+}
+#else
+#define debug_tree(t) debug_tree(CONST_CAST_TREE(t))
+#define debug_gimple_stmt(s) debug_gimple_stmt(CONST_CAST_GIMPLE(s))
+#endif
+
+#define __unused __attribute__((__unused__))
+
+#define DECL_NAME_POINTER(node) IDENTIFIER_POINTER(DECL_NAME(node))
+#define DECL_NAME_LENGTH(node) IDENTIFIER_LENGTH(DECL_NAME(node))
+#define TYPE_NAME_POINTER(node) IDENTIFIER_POINTER(TYPE_NAME(node))
+#define TYPE_NAME_LENGTH(node) IDENTIFIER_LENGTH(TYPE_NAME(node))
+
+// should come from c-tree.h if only it were installed for gcc 4.5...
+#define C_TYPE_FIELDS_READONLY(TYPE) TREE_LANG_FLAG_1(TYPE)
+
+#if BUILDING_GCC_VERSION == 4005
+#define FOR_EACH_LOCAL_DECL(FUN, I, D) for (tree vars = (FUN)->local_decls, (I) = 0; vars && ((D) = TREE_VALUE(vars)); vars = TREE_CHAIN(vars), (I)++)
+#define DECL_CHAIN(NODE) (TREE_CHAIN(DECL_MINIMAL_CHECK(NODE)))
+#define FOR_EACH_VEC_ELT(T, V, I, P) for (I = 0; VEC_iterate(T, (V), (I), (P)); ++(I))
+#define TODO_rebuild_cgraph_edges 0
+#define SCOPE_FILE_SCOPE_P(EXP) (!(EXP))
+
+#ifndef O_BINARY
+#define O_BINARY 0
+#endif
+
+typedef struct varpool_node *varpool_node_ptr;
+
+static inline bool gimple_call_builtin_p(gimple stmt, enum built_in_function code)
+{
+	tree fndecl;
+
+	if (!is_gimple_call(stmt))
+		return false;
+	fndecl = gimple_call_fndecl(stmt);
+	if (!fndecl || DECL_BUILT_IN_CLASS(fndecl) != BUILT_IN_NORMAL)
+		return false;
+	return DECL_FUNCTION_CODE(fndecl) == code;
+}
+
+static inline bool is_simple_builtin(tree decl)
+{
+	if (decl && DECL_BUILT_IN_CLASS(decl) != BUILT_IN_NORMAL)
+		return false;
+
+	switch (DECL_FUNCTION_CODE(decl)) {
+	/* Builtins that expand to constants. */
+	case BUILT_IN_CONSTANT_P:
+	case BUILT_IN_EXPECT:
+	case BUILT_IN_OBJECT_SIZE:
+	case BUILT_IN_UNREACHABLE:
+	/* Simple register moves or loads from stack. */
+	case BUILT_IN_RETURN_ADDRESS:
+	case BUILT_IN_EXTRACT_RETURN_ADDR:
+	case BUILT_IN_FROB_RETURN_ADDR:
+	case BUILT_IN_RETURN:
+	case BUILT_IN_AGGREGATE_INCOMING_ADDRESS:
+	case BUILT_IN_FRAME_ADDRESS:
+	case BUILT_IN_VA_END:
+	case BUILT_IN_STACK_SAVE:
+	case BUILT_IN_STACK_RESTORE:
+	/* Exception state returns or moves registers around. */
+	case BUILT_IN_EH_FILTER:
+	case BUILT_IN_EH_POINTER:
+	case BUILT_IN_EH_COPY_VALUES:
+	return true;
+
+	default:
+	return false;
+	}
+}
+
+static inline void add_local_decl(struct function *fun, tree d)
+{
+	gcc_assert(TREE_CODE(d) == VAR_DECL);
+	fun->local_decls = tree_cons(NULL_TREE, d, fun->local_decls);
+}
+#endif
+
+#if BUILDING_GCC_VERSION <= 4006
+#define ANY_RETURN_P(rtx) (GET_CODE(rtx) == RETURN)
+#define C_DECL_REGISTER(EXP) DECL_LANG_FLAG_4(EXP)
+#define EDGE_PRESERVE 0ULL
+#define HOST_WIDE_INT_PRINT_HEX_PURE "%" HOST_WIDE_INT_PRINT "x"
+#define flag_fat_lto_objects true
+
+#define get_random_seed(noinit) ({						\
+	unsigned HOST_WIDE_INT seed;						\
+	sscanf(get_random_seed(noinit), "%" HOST_WIDE_INT_PRINT "x", &seed);	\
+	seed * seed; })
+
+#define int_const_binop(code, arg1, arg2) int_const_binop((code), (arg1), (arg2), 0)
+
+static inline bool gimple_clobber_p(gimple s __unused)
+{
+	return false;
+}
+
+static inline bool gimple_asm_clobbers_memory_p(const_gimple stmt)
+{
+	unsigned i;
+
+	for (i = 0; i < gimple_asm_nclobbers(stmt); i++) {
+		tree op = gimple_asm_clobber_op(stmt, i);
+		if (!strcmp(TREE_STRING_POINTER(TREE_VALUE(op)), "memory"))
+			return true;
+	}
+
+	return false;
+}
+
+static inline tree builtin_decl_implicit(enum built_in_function fncode)
+{
+	return implicit_built_in_decls[fncode];
+}
+
+static inline int ipa_reverse_postorder(struct cgraph_node **order)
+{
+	return cgraph_postorder(order);
+}
+
+static inline struct cgraph_node *cgraph_get_create_node(tree decl)
+{
+	struct cgraph_node *node = cgraph_get_node(decl);
+
+	return node ? node : cgraph_node(decl);
+}
+
+static inline bool cgraph_function_with_gimple_body_p(struct cgraph_node *node)
+{
+	return node->analyzed && !node->thunk.thunk_p && !node->alias;
+}
+
+static inline struct cgraph_node *cgraph_first_function_with_gimple_body(void)
+{
+	struct cgraph_node *node;
+
+	for (node = cgraph_nodes; node; node = node->next)
+		if (cgraph_function_with_gimple_body_p(node))
+			return node;
+	return NULL;
+}
+
+static inline struct cgraph_node *cgraph_next_function_with_gimple_body(struct cgraph_node *node)
+{
+	for (node = node->next; node; node = node->next)
+		if (cgraph_function_with_gimple_body_p(node))
+			return node;
+	return NULL;
+}
+
+#define FOR_EACH_FUNCTION_WITH_GIMPLE_BODY(node) \
+	for ((node) = cgraph_first_function_with_gimple_body(); (node); \
+		(node) = cgraph_next_function_with_gimple_body(node))
+
+static inline void varpool_add_new_variable(tree decl)
+{
+	varpool_finalize_decl(decl);
+}
+#endif
+
+#if BUILDING_GCC_VERSION <= 4007
+#define FOR_EACH_FUNCTION(node) for (node = cgraph_nodes; node; node = node->next)
+#define FOR_EACH_VARIABLE(node) for (node = varpool_nodes; node; node = node->next)
+#define PROP_loops 0
+#define NODE_SYMBOL(node) (node)
+#define NODE_DECL(node) (node)->decl
+#define INSN_LOCATION(INSN) RTL_LOCATION(INSN)
+
+static inline int bb_loop_depth(const_basic_block bb)
+{
+	return bb->loop_father ? loop_depth(bb->loop_father) : 0;
+}
+
+static inline bool gimple_store_p(gimple gs)
+{
+	tree lhs = gimple_get_lhs(gs);
+	return lhs && !is_gimple_reg(lhs);
+}
+#endif
+
+#if BUILDING_GCC_VERSION == 4007 || BUILDING_GCC_VERSION == 4008
+static inline struct cgraph_node *cgraph_alias_target(struct cgraph_node *n)
+{
+	return cgraph_alias_aliased_node(n);
+}
+#endif
+
+#if BUILDING_GCC_VERSION >= 4007 && BUILDING_GCC_VERSION <= 4009
+#define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
+	cgraph_create_edge((caller), (callee), (call_stmt), (count), (freq))
+#define cgraph_create_edge_including_clones(caller, callee, old_call_stmt, call_stmt, count, freq, nest, reason) \
+	cgraph_create_edge_including_clones((caller), (callee), (old_call_stmt), (call_stmt), (count), (freq), (reason))
+#endif
+
+#if BUILDING_GCC_VERSION <= 4008
+#define ENTRY_BLOCK_PTR_FOR_FN(FN)	ENTRY_BLOCK_PTR_FOR_FUNCTION(FN)
+#define EXIT_BLOCK_PTR_FOR_FN(FN)	EXIT_BLOCK_PTR_FOR_FUNCTION(FN)
+#define basic_block_info_for_fn(FN)	((FN)->cfg->x_basic_block_info)
+#define n_basic_blocks_for_fn(FN)	((FN)->cfg->x_n_basic_blocks)
+#define n_edges_for_fn(FN)		((FN)->cfg->x_n_edges)
+#define last_basic_block_for_fn(FN)	((FN)->cfg->x_last_basic_block)
+#define label_to_block_map_for_fn(FN)	((FN)->cfg->x_label_to_block_map)
+#define profile_status_for_fn(FN)	((FN)->cfg->x_profile_status)
+#define BASIC_BLOCK_FOR_FN(FN, N)	BASIC_BLOCK_FOR_FUNCTION((FN), (N))
+#define NODE_IMPLICIT_ALIAS(node)	(node)->same_body_alias
+#define VAR_P(NODE)			(TREE_CODE(NODE) == VAR_DECL)
+
+static inline bool tree_fits_shwi_p(const_tree t)
+{
+	if (t == NULL_TREE || TREE_CODE(t) != INTEGER_CST)
+		return false;
+
+	if (TREE_INT_CST_HIGH(t) == 0 && (HOST_WIDE_INT)TREE_INT_CST_LOW(t) >= 0)
+		return true;
+
+	if (TREE_INT_CST_HIGH(t) == -1 && (HOST_WIDE_INT)TREE_INT_CST_LOW(t) < 0 && !TYPE_UNSIGNED(TREE_TYPE(t)))
+		return true;
+
+	return false;
+}
+
+static inline bool tree_fits_uhwi_p(const_tree t)
+{
+	if (t == NULL_TREE || TREE_CODE(t) != INTEGER_CST)
+		return false;
+
+	return TREE_INT_CST_HIGH(t) == 0;
+}
+
+static inline HOST_WIDE_INT tree_to_shwi(const_tree t)
+{
+	gcc_assert(tree_fits_shwi_p(t));
+	return TREE_INT_CST_LOW(t);
+}
+
+static inline unsigned HOST_WIDE_INT tree_to_uhwi(const_tree t)
+{
+	gcc_assert(tree_fits_uhwi_p(t));
+	return TREE_INT_CST_LOW(t);
+}
+
+static inline const char *get_tree_code_name(enum tree_code code)
+{
+	gcc_assert(code < MAX_TREE_CODES);
+	return tree_code_name[code];
+}
+
+#define ipa_remove_stmt_references(cnode, stmt)
+
+typedef union gimple_statement_d gasm;
+typedef union gimple_statement_d gassign;
+typedef union gimple_statement_d gcall;
+typedef union gimple_statement_d gcond;
+typedef union gimple_statement_d gdebug;
+typedef union gimple_statement_d gphi;
+typedef union gimple_statement_d greturn;
+
+static inline gasm *as_a_gasm(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gasm *as_a_const_gasm(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gassign *as_a_gassign(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gassign *as_a_const_gassign(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gcall *as_a_gcall(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gcall *as_a_const_gcall(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gcond *as_a_gcond(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gcond *as_a_const_gcond(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gdebug *as_a_gdebug(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gdebug *as_a_const_gdebug(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gphi *as_a_gphi(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gphi *as_a_const_gphi(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline greturn *as_a_greturn(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const greturn *as_a_const_greturn(const_gimple stmt)
+{
+	return stmt;
+}
+#endif
+
+#if BUILDING_GCC_VERSION == 4008
+#define NODE_SYMBOL(node) (&(node)->symbol)
+#define NODE_DECL(node) (node)->symbol.decl
+#endif
+
+#if BUILDING_GCC_VERSION >= 4008
+#define add_referenced_var(var)
+#define mark_sym_for_renaming(var)
+#define varpool_mark_needed_node(node)
+#define create_var_ann(var)
+#define TODO_dump_func 0
+#define TODO_dump_cgraph 0
+#endif
+
+#if BUILDING_GCC_VERSION <= 4009
+#define TODO_verify_il 0
+#define AVAIL_INTERPOSABLE AVAIL_OVERWRITABLE
+
+#define section_name_prefix LTO_SECTION_NAME_PREFIX
+#define fatal_error(loc, gmsgid, ...) fatal_error((gmsgid), __VA_ARGS__)
+
+typedef struct rtx_def rtx_insn;
+
+static inline void set_decl_section_name(tree node, const char *value)
+{
+	DECL_SECTION_NAME(node) = build_string(strlen(value) + 1, value);
+}
+#endif
+
+#if BUILDING_GCC_VERSION == 4009
+typedef struct gimple_statement_asm gasm;
+typedef struct gimple_statement_base gassign;
+typedef struct gimple_statement_call gcall;
+typedef struct gimple_statement_base gcond;
+typedef struct gimple_statement_base gdebug;
+typedef struct gimple_statement_phi gphi;
+typedef struct gimple_statement_base greturn;
+
+static inline gasm *as_a_gasm(gimple stmt)
+{
+	return as_a<gasm>(stmt);
+}
+
+static inline const gasm *as_a_const_gasm(const_gimple stmt)
+{
+	return as_a<const gasm>(stmt);
+}
+
+static inline gassign *as_a_gassign(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gassign *as_a_const_gassign(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gcall *as_a_gcall(gimple stmt)
+{
+	return as_a<gcall>(stmt);
+}
+
+static inline const gcall *as_a_const_gcall(const_gimple stmt)
+{
+	return as_a<const gcall>(stmt);
+}
+
+static inline gcond *as_a_gcond(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gcond *as_a_const_gcond(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gdebug *as_a_gdebug(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const gdebug *as_a_const_gdebug(const_gimple stmt)
+{
+	return stmt;
+}
+
+static inline gphi *as_a_gphi(gimple stmt)
+{
+	return as_a<gphi>(stmt);
+}
+
+static inline const gphi *as_a_const_gphi(const_gimple stmt)
+{
+	return as_a<const gphi>(stmt);
+}
+
+static inline greturn *as_a_greturn(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const greturn *as_a_const_greturn(const_gimple stmt)
+{
+	return stmt;
+}
+#endif
+
+#if BUILDING_GCC_VERSION >= 4009
+#define TODO_ggc_collect 0
+#define NODE_SYMBOL(node) (node)
+#define NODE_DECL(node) (node)->decl
+#define cgraph_node_name(node) (node)->name()
+#define NODE_IMPLICIT_ALIAS(node) (node)->cpp_implicit_alias
+#endif
+
+#if BUILDING_GCC_VERSION >= 5000 && BUILDING_GCC_VERSION < 6000
+// gimple related
+template <>
+template <>
+inline bool is_a_helper<const gassign *>::test(const_gimple gs)
+{
+	return gs->code == GIMPLE_ASSIGN;
+}
+#endif
+
+#if BUILDING_GCC_VERSION >= 5000
+#define TODO_verify_ssa TODO_verify_il
+#define TODO_verify_flow TODO_verify_il
+#define TODO_verify_stmts TODO_verify_il
+#define TODO_verify_rtl_sharing TODO_verify_il
+
+#define INSN_DELETED_P(insn) (insn)->deleted()
+
+// symtab/cgraph related
+#define debug_cgraph_node(node) (node)->debug()
+#define cgraph_get_node(decl) cgraph_node::get(decl)
+#define cgraph_get_create_node(decl) cgraph_node::get_create(decl)
+#define cgraph_n_nodes symtab->cgraph_count
+#define cgraph_max_uid symtab->cgraph_max_uid
+#define varpool_get_node(decl) varpool_node::get(decl)
+
+#define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
+	(caller)->create_edge((callee), (call_stmt), (count), (freq))
+#define cgraph_create_edge_including_clones(caller, callee, old_call_stmt, call_stmt, count, freq, nest, reason) \
+	(caller)->create_edge_including_clones((callee), (old_call_stmt), (call_stmt), (count), (freq), (reason))
+
+typedef struct cgraph_node *cgraph_node_ptr;
+typedef struct cgraph_edge *cgraph_edge_p;
+typedef struct varpool_node *varpool_node_ptr;
+
+static inline void change_decl_assembler_name(tree decl, tree name)
+{
+	symtab->change_decl_assembler_name(decl, name);
+}
+
+static inline void varpool_finalize_decl(tree decl)
+{
+	varpool_node::finalize_decl(decl);
+}
+
+static inline void varpool_add_new_variable(tree decl)
+{
+	varpool_node::add(decl);
+}
+
+static inline unsigned int rebuild_cgraph_edges(void)
+{
+	return cgraph_edge::rebuild_edges();
+}
+
+static inline cgraph_node_ptr cgraph_function_node(cgraph_node_ptr node, enum availability *availability)
+{
+	return node->function_symbol(availability);
+}
+
+static inline cgraph_node_ptr cgraph_function_or_thunk_node(cgraph_node_ptr node, enum availability *availability = NULL)
+{
+	return node->ultimate_alias_target(availability);
+}
+
+static inline bool cgraph_only_called_directly_p(cgraph_node_ptr node)
+{
+	return node->only_called_directly_p();
+}
+
+static inline enum availability cgraph_function_body_availability(cgraph_node_ptr node)
+{
+	return node->get_availability();
+}
+
+static inline cgraph_node_ptr cgraph_alias_target(cgraph_node_ptr node)
+{
+	return node->get_alias_target();
+}
+
+static inline struct cgraph_node_hook_list *cgraph_add_function_insertion_hook(cgraph_node_hook hook, void *data)
+{
+	return symtab->add_cgraph_insertion_hook(hook, data);
+}
+
+static inline void cgraph_remove_function_insertion_hook(struct cgraph_node_hook_list *entry)
+{
+	symtab->remove_cgraph_insertion_hook(entry);
+}
+
+static inline struct cgraph_node_hook_list *cgraph_add_node_removal_hook(cgraph_node_hook hook, void *data)
+{
+	return symtab->add_cgraph_removal_hook(hook, data);
+}
+
+static inline void cgraph_remove_node_removal_hook(struct cgraph_node_hook_list *entry)
+{
+	symtab->remove_cgraph_removal_hook(entry);
+}
+
+static inline struct cgraph_2node_hook_list *cgraph_add_node_duplication_hook(cgraph_2node_hook hook, void *data)
+{
+	return symtab->add_cgraph_duplication_hook(hook, data);
+}
+
+static inline void cgraph_remove_node_duplication_hook(struct cgraph_2node_hook_list *entry)
+{
+	symtab->remove_cgraph_duplication_hook(entry);
+}
+
+#if BUILDING_GCC_VERSION >= 6000
+typedef gimple *gimple_ptr;
+typedef const gimple *const_gimple;
+#define gimple gimple_ptr
+#endif
+
+// gimple related
+static inline gimple gimple_build_assign_with_ops(enum tree_code subcode, tree lhs, tree op1, tree op2 MEM_STAT_DECL)
+{
+	return gimple_build_assign(lhs, subcode, op1, op2 PASS_MEM_STAT);
+}
+
+template <>
+template <>
+inline bool is_a_helper<const greturn *>::test(const_gimple gs)
+{
+	return gs->code == GIMPLE_RETURN;
+}
+
+static inline gasm *as_a_gasm(gimple stmt)
+{
+	return as_a<gasm *>(stmt);
+}
+
+static inline const gasm *as_a_const_gasm(const_gimple stmt)
+{
+	return as_a<const gasm *>(stmt);
+}
+
+static inline gassign *as_a_gassign(gimple stmt)
+{
+	return as_a<gassign *>(stmt);
+}
+
+static inline const gassign *as_a_const_gassign(const_gimple stmt)
+{
+	return as_a<const gassign *>(stmt);
+}
+
+static inline gcall *as_a_gcall(gimple stmt)
+{
+	return as_a<gcall *>(stmt);
+}
+
+static inline const gcall *as_a_const_gcall(const_gimple stmt)
+{
+	return as_a<const gcall *>(stmt);
+}
+
+static inline gphi *as_a_gphi(gimple stmt)
+{
+	return as_a<gphi *>(stmt);
+}
+
+static inline const gphi *as_a_const_gphi(const_gimple stmt)
+{
+	return as_a<const gphi *>(stmt);
+}
+
+static inline greturn *as_a_greturn(gimple stmt)
+{
+	return as_a<greturn *>(stmt);
+}
+
+static inline const greturn *as_a_const_greturn(const_gimple stmt)
+{
+	return as_a<const greturn *>(stmt);
+}
+
+// IPA/LTO related
+#define ipa_ref_list_referring_iterate(L,I,P) (L)->referring.iterate((I), &(P))
+#define ipa_ref_list_reference_iterate(L,I,P) (L)->reference.iterate((I), &(P))
+
+static inline cgraph_node_ptr ipa_ref_referring_node(struct ipa_ref *ref)
+{
+	return dyn_cast<cgraph_node_ptr>(ref->referring);
+}
+
+static inline void ipa_remove_stmt_references(symtab_node *referring_node, gimple stmt)
+{
+	referring_node->remove_stmt_references(stmt);
+}
+#endif
+
+#if BUILDING_GCC_VERSION < 6000
+#define get_inner_reference(exp, pbitsize, pbitpos, poffset, pmode, punsignedp, preversep, pvolatilep, keep_aligning) get_inner_reference(exp, pbitsize, pbitpos, poffset, pmode, punsignedp, pvolatilep, keep_aligning)
+#define gen_rtx_set(ARG0, ARG1) gen_rtx_SET(VOIDmode, (ARG0), (ARG1))
+#endif
+
+#if BUILDING_GCC_VERSION >= 6000
+#define gen_rtx_set(ARG0, ARG1) gen_rtx_SET((ARG0), (ARG1))
+#endif
+
+#endif
diff --git a/tools/gcc/gcc-generate-gimple-pass.h b/tools/gcc/gcc-generate-gimple-pass.h
new file mode 100644
index 0000000..1abbd0f
--- /dev/null
+++ b/tools/gcc/gcc-generate-gimple-pass.h
@@ -0,0 +1,172 @@
+/*
+ * Generator for GIMPLE pass related boilerplate code/data
+ *
+ * Supports gcc 4.5-6
+ *
+ * Usage:
+ *
+ * 1. before inclusion define PASS_NAME
+ * 2. before inclusion define NO_* for unimplemented callbacks
+ *    NO_GATE
+ *    NO_EXECUTE
+ * 3. before inclusion define PROPERTIES_* and TODO_FLAGS_* to override the default 0 values
+ * 4. for convenience, all the above will be undefined after inclusion!
+ * 5. the only exported name is make_PASS_NAME_pass() to register with gcc
+ */
+
+#ifndef PASS_NAME
+#error at least PASS_NAME must be defined
+#else
+#define __GCC_PLUGIN_STRINGIFY(n)	#n
+#define _GCC_PLUGIN_STRINGIFY(n)	__GCC_PLUGIN_STRINGIFY(n)
+#define _GCC_PLUGIN_CONCAT2(x,y)	x ## y
+#define _GCC_PLUGIN_CONCAT3(x,y,z)	x ## y ## z
+
+#define __PASS_NAME_PASS_DATA(n)	_GCC_PLUGIN_CONCAT2(n,_pass_data)
+#define _PASS_NAME_PASS_DATA		__PASS_NAME_PASS_DATA(PASS_NAME)
+
+#define __PASS_NAME_PASS(n)		_GCC_PLUGIN_CONCAT2(n,_pass)
+#define _PASS_NAME_PASS			__PASS_NAME_PASS(PASS_NAME)
+
+#define _PASS_NAME_NAME			_GCC_PLUGIN_STRINGIFY(PASS_NAME)
+
+#define __MAKE_PASS_NAME_PASS(n)	_GCC_PLUGIN_CONCAT3(make_,n,_pass)
+#define _MAKE_PASS_NAME_PASS		__MAKE_PASS_NAME_PASS(PASS_NAME)
+
+#ifdef NO_GATE
+#define _GATE NULL
+#define _HAS_GATE false
+#else
+#define __GATE(n)			_GCC_PLUGIN_CONCAT2(n,_gate)
+#define _GATE				__GATE(PASS_NAME)
+#define _HAS_GATE true
+#endif
+
+#ifdef NO_EXECUTE
+#define _EXECUTE NULL
+#define _HAS_EXECUTE false
+#else
+#define __EXECUTE(n)			_GCC_PLUGIN_CONCAT2(n,_execute)
+#define _EXECUTE			__EXECUTE(PASS_NAME)
+#define _HAS_EXECUTE true
+#endif
+
+#ifndef PROPERTIES_REQUIRED
+#define PROPERTIES_REQUIRED 0
+#endif
+
+#ifndef PROPERTIES_PROVIDED
+#define PROPERTIES_PROVIDED 0
+#endif
+
+#ifndef PROPERTIES_DESTROYED
+#define PROPERTIES_DESTROYED 0
+#endif
+
+#ifndef TODO_FLAGS_START
+#define TODO_FLAGS_START 0
+#endif
+
+#ifndef TODO_FLAGS_FINISH
+#define TODO_FLAGS_FINISH 0
+#endif
+
+#if BUILDING_GCC_VERSION >= 4009
+namespace {
+static const pass_data _PASS_NAME_PASS_DATA = {
+#else
+static struct gimple_opt_pass _PASS_NAME_PASS = {
+	.pass = {
+#endif
+		.type			= GIMPLE_PASS,
+		.name			= _PASS_NAME_NAME,
+#if BUILDING_GCC_VERSION >= 4008
+		.optinfo_flags		= OPTGROUP_NONE,
+#endif
+#if BUILDING_GCC_VERSION >= 5000
+#elif BUILDING_GCC_VERSION == 4009
+		.has_gate		= _HAS_GATE,
+		.has_execute		= _HAS_EXECUTE,
+#else
+		.gate			= _GATE,
+		.execute		= _EXECUTE,
+		.sub			= NULL,
+		.next			= NULL,
+		.static_pass_number	= 0,
+#endif
+		.tv_id			= TV_NONE,
+		.properties_required	= PROPERTIES_REQUIRED,
+		.properties_provided	= PROPERTIES_PROVIDED,
+		.properties_destroyed	= PROPERTIES_DESTROYED,
+		.todo_flags_start	= TODO_FLAGS_START,
+		.todo_flags_finish	= TODO_FLAGS_FINISH,
+#if BUILDING_GCC_VERSION < 4009
+	}
+#endif
+};
+
+#if BUILDING_GCC_VERSION >= 4009
+class _PASS_NAME_PASS : public gimple_opt_pass {
+public:
+	_PASS_NAME_PASS() : gimple_opt_pass(_PASS_NAME_PASS_DATA, g) {}
+
+#ifndef NO_GATE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual bool gate(function *) { return _GATE(); }
+#else
+	bool gate() { return _GATE(); }
+#endif
+#endif
+
+#ifndef NO_EXECUTE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual unsigned int execute(function *) { return _EXECUTE(); }
+#else
+	unsigned int execute() { return _EXECUTE(); }
+#endif
+#endif
+};
+}
+
+opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return new _PASS_NAME_PASS();
+}
+#else
+struct opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return &_PASS_NAME_PASS.pass;
+}
+#endif
+
+// clean up user provided defines
+#undef PASS_NAME
+#undef NO_GATE
+#undef NO_EXECUTE
+
+#undef PROPERTIES_DESTROYED
+#undef PROPERTIES_PROVIDED
+#undef PROPERTIES_REQUIRED
+#undef TODO_FLAGS_FINISH
+#undef TODO_FLAGS_START
+
+// clean up generated defines
+#undef _EXECUTE
+#undef __EXECUTE
+#undef _GATE
+#undef __GATE
+#undef _GCC_PLUGIN_CONCAT2
+#undef _GCC_PLUGIN_CONCAT3
+#undef _GCC_PLUGIN_STRINGIFY
+#undef __GCC_PLUGIN_STRINGIFY
+#undef _HAS_EXECUTE
+#undef _HAS_GATE
+#undef _MAKE_PASS_NAME_PASS
+#undef __MAKE_PASS_NAME_PASS
+#undef _PASS_NAME_NAME
+#undef _PASS_NAME_PASS
+#undef __PASS_NAME_PASS
+#undef _PASS_NAME_PASS_DATA
+#undef __PASS_NAME_PASS_DATA
+
+#endif // PASS_NAME
diff --git a/tools/gcc/gcc-generate-ipa-pass.h b/tools/gcc/gcc-generate-ipa-pass.h
new file mode 100644
index 0000000..5eba6a0
--- /dev/null
+++ b/tools/gcc/gcc-generate-ipa-pass.h
@@ -0,0 +1,286 @@
+/*
+ * Generator for IPA pass related boilerplate code/data
+ *
+ * Supports gcc 4.5-6
+ *
+ * Usage:
+ *
+ * 1. before inclusion define PASS_NAME
+ * 2. before inclusion define NO_* for unimplemented callbacks
+ *    NO_GENERATE_SUMMARY
+ *    NO_READ_SUMMARY
+ *    NO_WRITE_SUMMARY
+ *    NO_READ_OPTIMIZATION_SUMMARY
+ *    NO_WRITE_OPTIMIZATION_SUMMARY
+ *    NO_STMT_FIXUP
+ *    NO_FUNCTION_TRANSFORM
+ *    NO_VARIABLE_TRANSFORM
+ *    NO_GATE
+ *    NO_EXECUTE
+ * 3. before inclusion define PROPERTIES_* and *TODO_FLAGS_* to override the default 0 values
+ * 4. for convenience, all the above will be undefined after inclusion!
+ * 5. the only exported name is make_PASS_NAME_pass() to register with gcc
+ */
+
+#ifndef PASS_NAME
+#error at least PASS_NAME must be defined
+#else
+#define __GCC_PLUGIN_STRINGIFY(n)	#n
+#define _GCC_PLUGIN_STRINGIFY(n)	__GCC_PLUGIN_STRINGIFY(n)
+#define _GCC_PLUGIN_CONCAT2(x,y)	x ## y
+#define _GCC_PLUGIN_CONCAT3(x,y,z)	x ## y ## z
+
+#define __PASS_NAME_PASS_DATA(n)	_GCC_PLUGIN_CONCAT2(n,_pass_data)
+#define _PASS_NAME_PASS_DATA		__PASS_NAME_PASS_DATA(PASS_NAME)
+
+#define __PASS_NAME_PASS(n)		_GCC_PLUGIN_CONCAT2(n,_pass)
+#define _PASS_NAME_PASS			__PASS_NAME_PASS(PASS_NAME)
+
+#define _PASS_NAME_NAME			_GCC_PLUGIN_STRINGIFY(PASS_NAME)
+
+#define __MAKE_PASS_NAME_PASS(n)	_GCC_PLUGIN_CONCAT3(make_,n,_pass)
+#define _MAKE_PASS_NAME_PASS		__MAKE_PASS_NAME_PASS(PASS_NAME)
+
+#ifdef NO_GENERATE_SUMMARY
+#define _GENERATE_SUMMARY NULL
+#else
+#define __GENERATE_SUMMARY(n)		_GCC_PLUGIN_CONCAT2(n,_generate_summary)
+#define _GENERATE_SUMMARY		__GENERATE_SUMMARY(PASS_NAME)
+#endif
+
+#ifdef NO_READ_SUMMARY
+#define _READ_SUMMARY NULL
+#else
+#define __READ_SUMMARY(n)		_GCC_PLUGIN_CONCAT2(n,_read_summary)
+#define _READ_SUMMARY			__READ_SUMMARY(PASS_NAME)
+#endif
+
+#ifdef NO_WRITE_SUMMARY
+#define _WRITE_SUMMARY NULL
+#else
+#define __WRITE_SUMMARY(n)		_GCC_PLUGIN_CONCAT2(n,_write_summary)
+#define _WRITE_SUMMARY			__WRITE_SUMMARY(PASS_NAME)
+#endif
+
+#ifdef NO_READ_OPTIMIZATION_SUMMARY
+#define _READ_OPTIMIZATION_SUMMARY NULL
+#else
+#define __READ_OPTIMIZATION_SUMMARY(n)	_GCC_PLUGIN_CONCAT2(n,_read_optimization_summary)
+#define _READ_OPTIMIZATION_SUMMARY	__READ_OPTIMIZATION_SUMMARY(PASS_NAME)
+#endif
+
+#ifdef NO_WRITE_OPTIMIZATION_SUMMARY
+#define _WRITE_OPTIMIZATION_SUMMARY NULL
+#else
+#define __WRITE_OPTIMIZATION_SUMMARY(n)	_GCC_PLUGIN_CONCAT2(n,_write_optimization_summary)
+#define _WRITE_OPTIMIZATION_SUMMARY	__WRITE_OPTIMIZATION_SUMMARY(PASS_NAME)
+#endif
+
+#ifdef NO_STMT_FIXUP
+#define _STMT_FIXUP NULL
+#else
+#define __STMT_FIXUP(n)			_GCC_PLUGIN_CONCAT2(n,_stmt_fixup)
+#define _STMT_FIXUP			__STMT_FIXUP(PASS_NAME)
+#endif
+
+#ifdef NO_FUNCTION_TRANSFORM
+#define _FUNCTION_TRANSFORM NULL
+#else
+#define __FUNCTION_TRANSFORM(n)		_GCC_PLUGIN_CONCAT2(n,_function_transform)
+#define _FUNCTION_TRANSFORM		__FUNCTION_TRANSFORM(PASS_NAME)
+#endif
+
+#ifdef NO_VARIABLE_TRANSFORM
+#define _VARIABLE_TRANSFORM NULL
+#else
+#define __VARIABLE_TRANSFORM(n)		_GCC_PLUGIN_CONCAT2(n,_variable_transform)
+#define _VARIABLE_TRANSFORM		__VARIABLE_TRANSFORM(PASS_NAME)
+#endif
+
+#ifdef NO_GATE
+#define _GATE NULL
+#define _HAS_GATE false
+#else
+#define __GATE(n)			_GCC_PLUGIN_CONCAT2(n,_gate)
+#define _GATE				__GATE(PASS_NAME)
+#define _HAS_GATE true
+#endif
+
+#ifdef NO_EXECUTE
+#define _EXECUTE NULL
+#define _HAS_EXECUTE false
+#else
+#define __EXECUTE(n)			_GCC_PLUGIN_CONCAT2(n,_execute)
+#define _EXECUTE			__EXECUTE(PASS_NAME)
+#define _HAS_EXECUTE true
+#endif
+
+#ifndef PROPERTIES_REQUIRED
+#define PROPERTIES_REQUIRED 0
+#endif
+
+#ifndef PROPERTIES_PROVIDED
+#define PROPERTIES_PROVIDED 0
+#endif
+
+#ifndef PROPERTIES_DESTROYED
+#define PROPERTIES_DESTROYED 0
+#endif
+
+#ifndef TODO_FLAGS_START
+#define TODO_FLAGS_START 0
+#endif
+
+#ifndef TODO_FLAGS_FINISH
+#define TODO_FLAGS_FINISH 0
+#endif
+
+#ifndef FUNCTION_TRANSFORM_TODO_FLAGS_START
+#define FUNCTION_TRANSFORM_TODO_FLAGS_START 0
+#endif
+
+#if BUILDING_GCC_VERSION >= 4009
+namespace {
+static const pass_data _PASS_NAME_PASS_DATA = {
+#else
+static struct ipa_opt_pass_d _PASS_NAME_PASS = {
+	.pass = {
+#endif
+		.type			= IPA_PASS,
+		.name			= _PASS_NAME_NAME,
+#if BUILDING_GCC_VERSION >= 4008
+		.optinfo_flags		= OPTGROUP_NONE,
+#endif
+#if BUILDING_GCC_VERSION >= 5000
+#elif BUILDING_GCC_VERSION == 4009
+		.has_gate		= _HAS_GATE,
+		.has_execute		= _HAS_EXECUTE,
+#else
+		.gate			= _GATE,
+		.execute		= _EXECUTE,
+		.sub			= NULL,
+		.next			= NULL,
+		.static_pass_number	= 0,
+#endif
+		.tv_id			= TV_NONE,
+		.properties_required	= PROPERTIES_REQUIRED,
+		.properties_provided	= PROPERTIES_PROVIDED,
+		.properties_destroyed	= PROPERTIES_DESTROYED,
+		.todo_flags_start	= TODO_FLAGS_START,
+		.todo_flags_finish	= TODO_FLAGS_FINISH,
+#if BUILDING_GCC_VERSION < 4009
+	},
+	.generate_summary		= _GENERATE_SUMMARY,
+	.write_summary			= _WRITE_SUMMARY,
+	.read_summary			= _READ_SUMMARY,
+#if BUILDING_GCC_VERSION >= 4006
+	.write_optimization_summary	= _WRITE_OPTIMIZATION_SUMMARY,
+	.read_optimization_summary	= _READ_OPTIMIZATION_SUMMARY,
+#endif
+	.stmt_fixup			= _STMT_FIXUP,
+	.function_transform_todo_flags_start	= FUNCTION_TRANSFORM_TODO_FLAGS_START,
+	.function_transform		= _FUNCTION_TRANSFORM,
+	.variable_transform		= _VARIABLE_TRANSFORM,
+#endif
+};
+
+#if BUILDING_GCC_VERSION >= 4009
+class _PASS_NAME_PASS : public ipa_opt_pass_d {
+public:
+	_PASS_NAME_PASS() : ipa_opt_pass_d(_PASS_NAME_PASS_DATA,
+			 g,
+			 _GENERATE_SUMMARY,
+			 _WRITE_SUMMARY,
+			 _READ_SUMMARY,
+			 _WRITE_OPTIMIZATION_SUMMARY,
+			 _READ_OPTIMIZATION_SUMMARY,
+			 _STMT_FIXUP,
+			 0,
+			 _FUNCTION_TRANSFORM,
+			 _VARIABLE_TRANSFORM) {}
+
+#ifndef NO_GATE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual bool gate(function *) { return _GATE(); }
+#else
+	bool gate() { return _GATE(); }
+#endif
+#endif
+
+#ifndef NO_EXECUTE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual unsigned int execute(function *) { return _EXECUTE(); }
+#else
+	unsigned int execute() { return _EXECUTE(); }
+#endif
+#endif
+};
+}
+
+opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return new _PASS_NAME_PASS();
+}
+#else
+struct opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return &_PASS_NAME_PASS.pass;
+}
+#endif
+
+// clean up user provided defines
+#undef PASS_NAME
+#undef NO_GENERATE_SUMMARY
+#undef NO_WRITE_SUMMARY
+#undef NO_READ_SUMMARY
+#undef NO_WRITE_OPTIMIZATION_SUMMARY
+#undef NO_READ_OPTIMIZATION_SUMMARY
+#undef NO_STMT_FIXUP
+#undef NO_FUNCTION_TRANSFORM
+#undef NO_VARIABLE_TRANSFORM
+#undef NO_GATE
+#undef NO_EXECUTE
+
+#undef FUNCTION_TRANSFORM_TODO_FLAGS_START
+#undef PROPERTIES_DESTROYED
+#undef PROPERTIES_PROVIDED
+#undef PROPERTIES_REQUIRED
+#undef TODO_FLAGS_FINISH
+#undef TODO_FLAGS_START
+
+// clean up generated defines
+#undef _EXECUTE
+#undef __EXECUTE
+#undef _FUNCTION_TRANSFORM
+#undef __FUNCTION_TRANSFORM
+#undef _GATE
+#undef __GATE
+#undef _GCC_PLUGIN_CONCAT2
+#undef _GCC_PLUGIN_CONCAT3
+#undef _GCC_PLUGIN_STRINGIFY
+#undef __GCC_PLUGIN_STRINGIFY
+#undef _GENERATE_SUMMARY
+#undef __GENERATE_SUMMARY
+#undef _HAS_EXECUTE
+#undef _HAS_GATE
+#undef _MAKE_PASS_NAME_PASS
+#undef __MAKE_PASS_NAME_PASS
+#undef _PASS_NAME_NAME
+#undef _PASS_NAME_PASS
+#undef __PASS_NAME_PASS
+#undef _PASS_NAME_PASS_DATA
+#undef __PASS_NAME_PASS_DATA
+#undef _READ_OPTIMIZATION_SUMMARY
+#undef __READ_OPTIMIZATION_SUMMARY
+#undef _READ_SUMMARY
+#undef __READ_SUMMARY
+#undef _STMT_FIXUP
+#undef __STMT_FIXUP
+#undef _VARIABLE_TRANSFORM
+#undef __VARIABLE_TRANSFORM
+#undef _WRITE_OPTIMIZATION_SUMMARY
+#undef __WRITE_OPTIMIZATION_SUMMARY
+#undef _WRITE_SUMMARY
+#undef __WRITE_SUMMARY
+
+#endif // PASS_NAME
diff --git a/tools/gcc/gcc-generate-rtl-pass.h b/tools/gcc/gcc-generate-rtl-pass.h
new file mode 100644
index 0000000..c5cc187
--- /dev/null
+++ b/tools/gcc/gcc-generate-rtl-pass.h
@@ -0,0 +1,172 @@
+/*
+ * Generator for RTL pass related boilerplate code/data
+ *
+ * Supports gcc 4.5-6
+ *
+ * Usage:
+ *
+ * 1. before inclusion define PASS_NAME
+ * 2. before inclusion define NO_* for unimplemented callbacks
+ *    NO_GATE
+ *    NO_EXECUTE
+ * 3. before inclusion define PROPERTIES_* and TODO_FLAGS_* to override the default 0 values
+ * 4. for convenience, all the above will be undefined after inclusion!
+ * 5. the only exported name is make_PASS_NAME_pass() to register with gcc
+ */
+
+#ifndef PASS_NAME
+#error at least PASS_NAME must be defined
+#else
+#define __GCC_PLUGIN_STRINGIFY(n)	#n
+#define _GCC_PLUGIN_STRINGIFY(n)	__GCC_PLUGIN_STRINGIFY(n)
+#define _GCC_PLUGIN_CONCAT2(x,y)	x ## y
+#define _GCC_PLUGIN_CONCAT3(x,y,z)	x ## y ## z
+
+#define __PASS_NAME_PASS_DATA(n)	_GCC_PLUGIN_CONCAT2(n,_pass_data)
+#define _PASS_NAME_PASS_DATA		__PASS_NAME_PASS_DATA(PASS_NAME)
+
+#define __PASS_NAME_PASS(n)		_GCC_PLUGIN_CONCAT2(n,_pass)
+#define _PASS_NAME_PASS			__PASS_NAME_PASS(PASS_NAME)
+
+#define _PASS_NAME_NAME			_GCC_PLUGIN_STRINGIFY(PASS_NAME)
+
+#define __MAKE_PASS_NAME_PASS(n)	_GCC_PLUGIN_CONCAT3(make_,n,_pass)
+#define _MAKE_PASS_NAME_PASS		__MAKE_PASS_NAME_PASS(PASS_NAME)
+
+#ifdef NO_GATE
+#define _GATE NULL
+#define _HAS_GATE false
+#else
+#define __GATE(n)			_GCC_PLUGIN_CONCAT2(n,_gate)
+#define _GATE				__GATE(PASS_NAME)
+#define _HAS_GATE true
+#endif
+
+#ifdef NO_EXECUTE
+#define _EXECUTE NULL
+#define _HAS_EXECUTE false
+#else
+#define __EXECUTE(n)			_GCC_PLUGIN_CONCAT2(n,_execute)
+#define _EXECUTE			__EXECUTE(PASS_NAME)
+#define _HAS_EXECUTE true
+#endif
+
+#ifndef PROPERTIES_REQUIRED
+#define PROPERTIES_REQUIRED 0
+#endif
+
+#ifndef PROPERTIES_PROVIDED
+#define PROPERTIES_PROVIDED 0
+#endif
+
+#ifndef PROPERTIES_DESTROYED
+#define PROPERTIES_DESTROYED 0
+#endif
+
+#ifndef TODO_FLAGS_START
+#define TODO_FLAGS_START 0
+#endif
+
+#ifndef TODO_FLAGS_FINISH
+#define TODO_FLAGS_FINISH 0
+#endif
+
+#if BUILDING_GCC_VERSION >= 4009
+namespace {
+static const pass_data _PASS_NAME_PASS_DATA = {
+#else
+static struct rtl_opt_pass _PASS_NAME_PASS = {
+	.pass = {
+#endif
+		.type			= RTL_PASS,
+		.name			= _PASS_NAME_NAME,
+#if BUILDING_GCC_VERSION >= 4008
+		.optinfo_flags		= OPTGROUP_NONE,
+#endif
+#if BUILDING_GCC_VERSION >= 5000
+#elif BUILDING_GCC_VERSION == 4009
+		.has_gate		= _HAS_GATE,
+		.has_execute		= _HAS_EXECUTE,
+#else
+		.gate			= _GATE,
+		.execute		= _EXECUTE,
+		.sub			= NULL,
+		.next			= NULL,
+		.static_pass_number	= 0,
+#endif
+		.tv_id			= TV_NONE,
+		.properties_required	= PROPERTIES_REQUIRED,
+		.properties_provided	= PROPERTIES_PROVIDED,
+		.properties_destroyed	= PROPERTIES_DESTROYED,
+		.todo_flags_start	= TODO_FLAGS_START,
+		.todo_flags_finish	= TODO_FLAGS_FINISH,
+#if BUILDING_GCC_VERSION < 4009
+	}
+#endif
+};
+
+#if BUILDING_GCC_VERSION >= 4009
+class _PASS_NAME_PASS : public rtl_opt_pass {
+public:
+	_PASS_NAME_PASS() : rtl_opt_pass(_PASS_NAME_PASS_DATA, g) {}
+
+#ifndef NO_GATE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual bool gate(function *) { return _GATE(); }
+#else
+	bool gate() { return _GATE(); }
+#endif
+#endif
+
+#ifndef NO_EXECUTE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual unsigned int execute(function *) { return _EXECUTE(); }
+#else
+	unsigned int execute() { return _EXECUTE(); }
+#endif
+#endif
+};
+}
+
+opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return new _PASS_NAME_PASS();
+}
+#else
+struct opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return &_PASS_NAME_PASS.pass;
+}
+#endif
+
+// clean up user provided defines
+#undef PASS_NAME
+#undef NO_GATE
+#undef NO_EXECUTE
+
+#undef PROPERTIES_DESTROYED
+#undef PROPERTIES_PROVIDED
+#undef PROPERTIES_REQUIRED
+#undef TODO_FLAGS_FINISH
+#undef TODO_FLAGS_START
+
+// clean up generated defines
+#undef _EXECUTE
+#undef __EXECUTE
+#undef _GATE
+#undef __GATE
+#undef _GCC_PLUGIN_CONCAT2
+#undef _GCC_PLUGIN_CONCAT3
+#undef _GCC_PLUGIN_STRINGIFY
+#undef __GCC_PLUGIN_STRINGIFY
+#undef _HAS_EXECUTE
+#undef _HAS_GATE
+#undef _MAKE_PASS_NAME_PASS
+#undef __MAKE_PASS_NAME_PASS
+#undef _PASS_NAME_NAME
+#undef _PASS_NAME_PASS
+#undef __PASS_NAME_PASS
+#undef _PASS_NAME_PASS_DATA
+#undef __PASS_NAME_PASS_DATA
+
+#endif // PASS_NAME
diff --git a/tools/gcc/gcc-generate-simple_ipa-pass.h b/tools/gcc/gcc-generate-simple_ipa-pass.h
new file mode 100644
index 0000000..9291ee7
--- /dev/null
+++ b/tools/gcc/gcc-generate-simple_ipa-pass.h
@@ -0,0 +1,172 @@
+/*
+ * Generator for SIMPLE_IPA pass related boilerplate code/data
+ *
+ * Supports gcc 4.5-6
+ *
+ * Usage:
+ *
+ * 1. before inclusion define PASS_NAME
+ * 2. before inclusion define NO_* for unimplemented callbacks
+ *    NO_GATE
+ *    NO_EXECUTE
+ * 3. before inclusion define PROPERTIES_* and TODO_FLAGS_* to override the default 0 values
+ * 4. for convenience, all the above will be undefined after inclusion!
+ * 5. the only exported name is make_PASS_NAME_pass() to register with gcc
+ */
+
+#ifndef PASS_NAME
+#error at least PASS_NAME must be defined
+#else
+#define __GCC_PLUGIN_STRINGIFY(n)	#n
+#define _GCC_PLUGIN_STRINGIFY(n)	__GCC_PLUGIN_STRINGIFY(n)
+#define _GCC_PLUGIN_CONCAT2(x,y)	x ## y
+#define _GCC_PLUGIN_CONCAT3(x,y,z)	x ## y ## z
+
+#define __PASS_NAME_PASS_DATA(n)	_GCC_PLUGIN_CONCAT2(n,_pass_data)
+#define _PASS_NAME_PASS_DATA		__PASS_NAME_PASS_DATA(PASS_NAME)
+
+#define __PASS_NAME_PASS(n)		_GCC_PLUGIN_CONCAT2(n,_pass)
+#define _PASS_NAME_PASS			__PASS_NAME_PASS(PASS_NAME)
+
+#define _PASS_NAME_NAME			_GCC_PLUGIN_STRINGIFY(PASS_NAME)
+
+#define __MAKE_PASS_NAME_PASS(n)	_GCC_PLUGIN_CONCAT3(make_,n,_pass)
+#define _MAKE_PASS_NAME_PASS		__MAKE_PASS_NAME_PASS(PASS_NAME)
+
+#ifdef NO_GATE
+#define _GATE NULL
+#define _HAS_GATE false
+#else
+#define __GATE(n)			_GCC_PLUGIN_CONCAT2(n,_gate)
+#define _GATE				__GATE(PASS_NAME)
+#define _HAS_GATE true
+#endif
+
+#ifdef NO_EXECUTE
+#define _EXECUTE NULL
+#define _HAS_EXECUTE false
+#else
+#define __EXECUTE(n)			_GCC_PLUGIN_CONCAT2(n,_execute)
+#define _EXECUTE			__EXECUTE(PASS_NAME)
+#define _HAS_EXECUTE true
+#endif
+
+#ifndef PROPERTIES_REQUIRED
+#define PROPERTIES_REQUIRED 0
+#endif
+
+#ifndef PROPERTIES_PROVIDED
+#define PROPERTIES_PROVIDED 0
+#endif
+
+#ifndef PROPERTIES_DESTROYED
+#define PROPERTIES_DESTROYED 0
+#endif
+
+#ifndef TODO_FLAGS_START
+#define TODO_FLAGS_START 0
+#endif
+
+#ifndef TODO_FLAGS_FINISH
+#define TODO_FLAGS_FINISH 0
+#endif
+
+#if BUILDING_GCC_VERSION >= 4009
+namespace {
+static const pass_data _PASS_NAME_PASS_DATA = {
+#else
+static struct simple_ipa_opt_pass _PASS_NAME_PASS = {
+	.pass = {
+#endif
+		.type			= SIMPLE_IPA_PASS,
+		.name			= _PASS_NAME_NAME,
+#if BUILDING_GCC_VERSION >= 4008
+		.optinfo_flags		= OPTGROUP_NONE,
+#endif
+#if BUILDING_GCC_VERSION >= 5000
+#elif BUILDING_GCC_VERSION == 4009
+		.has_gate		= _HAS_GATE,
+		.has_execute		= _HAS_EXECUTE,
+#else
+		.gate			= _GATE,
+		.execute		= _EXECUTE,
+		.sub			= NULL,
+		.next			= NULL,
+		.static_pass_number	= 0,
+#endif
+		.tv_id			= TV_NONE,
+		.properties_required	= PROPERTIES_REQUIRED,
+		.properties_provided	= PROPERTIES_PROVIDED,
+		.properties_destroyed	= PROPERTIES_DESTROYED,
+		.todo_flags_start	= TODO_FLAGS_START,
+		.todo_flags_finish	= TODO_FLAGS_FINISH,
+#if BUILDING_GCC_VERSION < 4009
+	}
+#endif
+};
+
+#if BUILDING_GCC_VERSION >= 4009
+class _PASS_NAME_PASS : public simple_ipa_opt_pass {
+public:
+	_PASS_NAME_PASS() : simple_ipa_opt_pass(_PASS_NAME_PASS_DATA, g) {}
+
+#ifndef NO_GATE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual bool gate(function *) { return _GATE(); }
+#else
+	bool gate() { return _GATE(); }
+#endif
+#endif
+
+#ifndef NO_EXECUTE
+#if BUILDING_GCC_VERSION >= 5000
+	virtual unsigned int execute(function *) { return _EXECUTE(); }
+#else
+	unsigned int execute() { return _EXECUTE(); }
+#endif
+#endif
+};
+}
+
+opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return new _PASS_NAME_PASS();
+}
+#else
+struct opt_pass *_MAKE_PASS_NAME_PASS(void)
+{
+	return &_PASS_NAME_PASS.pass;
+}
+#endif
+
+// clean up user provided defines
+#undef PASS_NAME
+#undef NO_GATE
+#undef NO_EXECUTE
+
+#undef PROPERTIES_DESTROYED
+#undef PROPERTIES_PROVIDED
+#undef PROPERTIES_REQUIRED
+#undef TODO_FLAGS_FINISH
+#undef TODO_FLAGS_START
+
+// clean up generated defines
+#undef _EXECUTE
+#undef __EXECUTE
+#undef _GATE
+#undef __GATE
+#undef _GCC_PLUGIN_CONCAT2
+#undef _GCC_PLUGIN_CONCAT3
+#undef _GCC_PLUGIN_STRINGIFY
+#undef __GCC_PLUGIN_STRINGIFY
+#undef _HAS_EXECUTE
+#undef _HAS_GATE
+#undef _MAKE_PASS_NAME_PASS
+#undef __MAKE_PASS_NAME_PASS
+#undef _PASS_NAME_NAME
+#undef _PASS_NAME_PASS
+#undef __PASS_NAME_PASS
+#undef _PASS_NAME_PASS_DATA
+#undef __PASS_NAME_PASS_DATA
+
+#endif // PASS_NAME
-- 
2.4.1
