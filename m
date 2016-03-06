Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Mar 2016 00:07:30 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160307000730.5f5b379d0e88b97fc0112c8e@gmail.com>
In-Reply-To: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 5/5] Add sancov plugin
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The sancov gcc plugin inserts a __sanitizer_cov_trace_pc() call
at the start of basic blocks.

This plugin is a helper plugin for the kcov feature. It supports
all gcc versions with plugin support (from gcc-4.5 on).
It is based on the gcc commit "Add fuzzing coverage support" by Dmitry Vyukov
(https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296).

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/Kconfig                 |   9 +++
 scripts/Makefile.gcc-plugins |   7 ++-
 tools/gcc/Makefile           |   2 +
 tools/gcc/sancov_plugin.c    | 133 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+), 2 deletions(-)
 create mode 100644 tools/gcc/sancov_plugin.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 32583b7..30632fa 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -384,6 +384,15 @@ config GCC_PLUGIN_CYC_COMPLEXITY
 	  N = the number of nodes
 	  P = the number of connected components (exit nodes).
 
+config GCC_PLUGIN_SANCOV
+	bool "Helper plugin for the kcov feature"
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
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index dd7b56d..dc11503 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -8,8 +8,11 @@ ifneq ($(PLUGINCC),)
 ifdef CONFIG_GCC_PLUGIN_CYC_COMPLEXITY
 GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS := -fplugin=$(objtree)/tools/gcc/cyc_complexity_plugin.so
 endif
-GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS)
-export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY
+ifdef CONFIG_GCC_PLUGIN_SANCOV
+GCC_PLUGIN_SANCOV_CFLAGS := -fplugin=$(objtree)/tools/gcc/sancov_plugin.so
+endif
+GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS) $(GCC_PLUGIN_SANCOV_CFLAGS)
+export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY GCC_PLUGIN_SANCOV
 ifeq ($(KBUILD_EXTMOD),)
 gcc-plugins:
 	$(Q)$(MAKE) $(build)=tools/gcc
diff --git a/tools/gcc/Makefile b/tools/gcc/Makefile
index 31c72bf..97a923f 100644
--- a/tools/gcc/Makefile
+++ b/tools/gcc/Makefile
@@ -13,7 +13,9 @@ endif
 export GCCPLUGINS_DIR HOSTLIBS
 
 $(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) := cyc_complexity_plugin.so
+$(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_SANCOV) += sancov_plugin.so
 
 always := $($(HOSTLIBS)-y)
 
 cyc_complexity_plugin-objs := cyc_complexity_plugin.o
+sancov_plugin-objs := sancov_plugin.o
diff --git a/tools/gcc/sancov_plugin.c b/tools/gcc/sancov_plugin.c
new file mode 100644
index 0000000..5a9179b
--- /dev/null
+++ b/tools/gcc/sancov_plugin.c
@@ -0,0 +1,133 @@
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
+	.version	= "20160305",
+	.help		= "sancov plugin\n",
+};
+
+static unsigned int sancov_execute(void)
+{
+	basic_block bb;
+
+	/* Remove this line when this plugin and kcov will be in the kernel. */
+	if (!strcmp(DECL_NAME_POINTER(current_function_decl), DECL_NAME_POINTER(sancov_fndecl)))
+		return 0;
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
+	nothrow_attr = tree_cons(get_identifier("nothrow"), NULL, NULL);
+	decl_attributes(&sancov_fndecl, nothrow_attr, 0);
+	gcc_assert(TREE_NOTHROW(sancov_fndecl));
+	leaf_attr = tree_cons(get_identifier("leaf"), NULL, NULL);
+	decl_attributes(&sancov_fndecl, leaf_attr, 0);
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
2.4.1
