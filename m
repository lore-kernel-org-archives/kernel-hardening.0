Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 13 May 2016 01:59:43 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160513015943.e1c00a1d71f50b3a521656d7@gmail.com>
In-Reply-To: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v8 4/4] Add sancov plugin
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

The sancov gcc plugin inserts a __sanitizer_cov_trace_pc() call
at the start of basic blocks.

This plugin is a helper plugin for the kcov feature. It supports
all gcc versions with plugin support (from gcc-4.5 on).
It is based on the gcc commit "Add fuzzing coverage support" by Dmitry Vyukov
(https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296).

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 Makefile                            |  12 +--
 arch/Kconfig                        |   9 +++
 arch/x86/purgatory/Makefile         |   2 +
 lib/Kconfig.debug                   |   2 +
 scripts/Makefile.gcc-plugins        |  19 +++++
 scripts/gcc-plugins/Makefile        |   6 ++
 scripts/gcc-plugins/sancov_plugin.c | 144 ++++++++++++++++++++++++++++++++++++
 7 files changed, 184 insertions(+), 10 deletions(-)
 create mode 100644 scripts/gcc-plugins/sancov_plugin.c

diff --git a/Makefile b/Makefile
index 972d845..2eed43f 100644
--- a/Makefile
+++ b/Makefile
@@ -369,7 +369,7 @@ LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage -fno-tree-loop-im -Wno-maybe-uninitialized
-CFLAGS_KCOV	= -fsanitize-coverage=trace-pc
+CFLAGS_KCOV	:= $(call cc-option,-fsanitize-coverage=trace-pc,)
 
 
 # Use USERINCLUDE when you must reference the UAPI directories only.
@@ -422,7 +422,7 @@ export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
 export KBUILD_ARFLAGS
 
-export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN
+export PLUGINCC GCC_PLUGINS_CFLAGS SANCOV_PLUGIN GCC_PLUGIN
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
@@ -693,14 +693,6 @@ endif
 endif
 KBUILD_CFLAGS += $(stackp-flag)
 
-ifdef CONFIG_KCOV
-  ifeq ($(call cc-option, $(CFLAGS_KCOV)),)
-    $(warning Cannot use CONFIG_KCOV: \
-             -fsanitize-coverage=trace-pc is not supported by compiler)
-    CFLAGS_KCOV =
-  endif
-endif
-
 ifeq ($(cc-name),clang)
 KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
 KBUILD_CPPFLAGS += $(call cc-option,-Wno-unknown-warning-option,)
diff --git a/arch/Kconfig b/arch/Kconfig
index 74f0d63..5feadad 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -384,6 +384,15 @@ config GCC_PLUGIN_CYC_COMPLEXITY
 	  N = the number of nodes
 	  P = the number of connected components (exit nodes).
 
+config GCC_PLUGIN_SANCOV
+	bool
+	depends on GCC_PLUGINS
+	help
+	  This plugin inserts a __sanitizer_cov_trace_pc() call at the start of
+	  basic blocks. It supports all gcc versions with plugin support (from
+	  gcc-4.5 on). It is based on the commit "Add fuzzing coverage support"
+	  by Dmitry Vyukov <dvyukov@google.com>.
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 12734a9..ac58c16 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -8,6 +8,8 @@ PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
 targets += purgatory.ro
 
+KCOV_INSTRUMENT := n
+
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
 # sure how to relocate those. Like kexec-tools, use custom flags.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5d57177..a377fd7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -712,6 +712,8 @@ config KCOV
 	bool "Code coverage for fuzzing"
 	depends on ARCH_HAS_KCOV
 	select DEBUG_FS
+	select GCC_PLUGINS
+	select GCC_PLUGIN_SANCOV
 	help
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index bf0eaf1..372c73a 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -2,7 +2,23 @@ ifdef CONFIG_GCC_PLUGINS
   __PLUGINCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))
   PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
 
+  SANCOV_PLUGIN := -fplugin=$(objtree)/scripts/gcc-plugins/sancov_plugin.so
+
   gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)	+= cyc_complexity_plugin.so
+
+  ifdef CONFIG_GCC_PLUGIN_SANCOV
+    ifeq ($(CFLAGS_KCOV),)
+      # It is needed because of the gcc-plugin.sh and gcc version checks.
+      gcc-plugin-$(CONFIG_GCC_PLUGIN_SANCOV)           += sancov_plugin.so
+
+      ifneq ($(PLUGINCC),)
+        CFLAGS_KCOV := $(SANCOV_PLUGIN)
+      else
+        $(error Cannot use CONFIG_KCOV: -fsanitize-coverage=trace-pc is not supported by compiler)
+      endif
+    endif
+  endif
+
   GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y))
 
   ifeq ($(PLUGINCC),)
@@ -14,6 +30,9 @@ ifdef CONFIG_GCC_PLUGINS
         $(error error, your gcc version does not support plugins, you should upgrade it to gcc 4.5 at least)
       endif
     endif
+  else
+    # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
+    GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
   endif
 
   KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index c60ba4b..88c8ec4 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -14,8 +14,14 @@ endif
 
 export GCCPLUGINS_DIR HOSTLIBS
 
+ifneq ($(CFLAGS_KCOV), $(SANCOV_PLUGIN))
+  GCC_PLUGIN := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGIN))
+endif
+
 $(HOSTLIBS)-y := $(GCC_PLUGIN)
 always := $($(HOSTLIBS)-y)
 
 cyc_complexity_plugin-objs := cyc_complexity_plugin.o
+sancov_plugin-objs := sancov_plugin.o
+
 clean-files += *.so
diff --git a/scripts/gcc-plugins/sancov_plugin.c b/scripts/gcc-plugins/sancov_plugin.c
new file mode 100644
index 0000000..aedd611
--- /dev/null
+++ b/scripts/gcc-plugins/sancov_plugin.c
@@ -0,0 +1,144 @@
+/*
+ * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
+ * Licensed under the GPL v2, or (at your option) v3
+ *
+ * Homepage:
+ * https://github.com/ephox-gcc-plugins/sancov
+ *
+ * This plugin inserts a __sanitizer_cov_trace_pc() call at the start of basic blocks.
+ * It supports all gcc versions with plugin support (from gcc-4.5 on).
+ * It is based on the commit "Add fuzzing coverage support" by Dmitry Vyukov <dvyukov@google.com>.
+ *
+ * You can read about it more here:
+ *  https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296
+ *  http://lwn.net/Articles/674854/
+ *  https://github.com/google/syzkaller
+ *  https://lwn.net/Articles/677764/
+ *
+ * Usage:
+ * make run
+ */
+
+#include "gcc-common.h"
+
+int plugin_is_GPL_compatible;
+
+tree sancov_fndecl;
+
+static struct plugin_info sancov_plugin_info = {
+	.version	= "20160402",
+	.help		= "sancov plugin\n",
+};
+
+static unsigned int sancov_execute(void)
+{
+	basic_block bb;
+
+	/* Remove this line when this plugin and kcov will be in the kernel.
+	if (!strcmp(DECL_NAME_POINTER(current_function_decl), DECL_NAME_POINTER(sancov_fndecl)))
+		return 0;
+	*/
+
+	FOR_EACH_BB_FN(bb, cfun) {
+		const_gimple stmt;
+		gcall *gcall;
+		gimple_stmt_iterator gsi = gsi_after_labels(bb);
+
+		if (gsi_end_p(gsi))
+			continue;
+
+		stmt = gsi_stmt(gsi);
+		gcall = as_a_gcall(gimple_build_call(sancov_fndecl, 0));
+		gimple_set_location(gcall, gimple_location(stmt));
+		gsi_insert_before(&gsi, gcall, GSI_SAME_STMT);
+	}
+	return 0;
+}
+
+#define PASS_NAME sancov
+
+#define NO_GATE
+#define TODO_FLAGS_FINISH TODO_dump_func | TODO_verify_stmts | TODO_update_ssa_no_phi | TODO_verify_flow
+
+#include "gcc-generate-gimple-pass.h"
+
+static void sancov_start_unit(void __unused *gcc_data, void __unused *user_data)
+{
+	tree leaf_attr, nothrow_attr;
+	tree BT_FN_VOID = build_function_type_list(void_type_node, NULL_TREE);
+
+	sancov_fndecl = build_fn_decl("__sanitizer_cov_trace_pc", BT_FN_VOID);
+
+	DECL_ASSEMBLER_NAME(sancov_fndecl);
+	TREE_PUBLIC(sancov_fndecl) = 1;
+	DECL_EXTERNAL(sancov_fndecl) = 1;
+	DECL_ARTIFICIAL(sancov_fndecl) = 1;
+	DECL_PRESERVE_P(sancov_fndecl) = 1;
+	DECL_UNINLINABLE(sancov_fndecl) = 1;
+	TREE_USED(sancov_fndecl) = 1;
+
+	nothrow_attr = tree_cons(get_identifier("nothrow"), NULL, NULL);
+	decl_attributes(&sancov_fndecl, nothrow_attr, 0);
+	gcc_assert(TREE_NOTHROW(sancov_fndecl));
+#if BUILDING_GCC_VERSION > 4005
+	leaf_attr = tree_cons(get_identifier("leaf"), NULL, NULL);
+	decl_attributes(&sancov_fndecl, leaf_attr, 0);
+#endif
+}
+
+int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
+{
+	int i;
+	struct register_pass_info sancov_plugin_pass_info;
+	const char * const plugin_name = plugin_info->base_name;
+	const int argc = plugin_info->argc;
+	const struct plugin_argument * const argv = plugin_info->argv;
+	bool enable = true;
+
+	static const struct ggc_root_tab gt_ggc_r_gt_sancov[] = {
+		{
+			.base = &sancov_fndecl,
+			.nelt = 1,
+			.stride = sizeof(sancov_fndecl),
+			.cb = &gt_ggc_mx_tree_node,
+			.pchw = &gt_pch_nx_tree_node
+		},
+		LAST_GGC_ROOT_TAB
+	};
+
+	/* BBs can be split afterwards?? */
+	sancov_plugin_pass_info.pass				= make_sancov_pass();
+#if BUILDING_GCC_VERSION >= 4009
+	sancov_plugin_pass_info.reference_pass_name		= "asan";
+#else
+	sancov_plugin_pass_info.reference_pass_name		= "nrv";
+#endif
+	sancov_plugin_pass_info.ref_pass_instance_number	= 0;
+	sancov_plugin_pass_info.pos_op				= PASS_POS_INSERT_BEFORE;
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	for (i = 0; i < argc; ++i) {
+		if (!strcmp(argv[i].key, "no-sancov")) {
+			enable = false;
+			continue;
+		}
+		error(G_("unkown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL, &sancov_plugin_info);
+
+	if (!enable)
+		return 0;
+
+#if BUILDING_GCC_VERSION < 6000
+	register_callback(plugin_name, PLUGIN_START_UNIT, &sancov_start_unit, NULL);
+	register_callback(plugin_name, PLUGIN_REGISTER_GGC_ROOTS, NULL, (void *)&gt_ggc_r_gt_sancov);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &sancov_plugin_pass_info);
+#endif
+
+	return 0;
+}
-- 
2.8.1
