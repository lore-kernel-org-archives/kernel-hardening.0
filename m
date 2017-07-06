From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  6 Jul 2017 11:13:17 +0100
Message-Id: <20170706101317.10382-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC/RFT PATCH] gcc-plugins: force initialize auto variables whose addresses are taken
To: kernel-hardening@lists.openwall.com
Cc: arnd@arndb.de, keescook@chromium.org, torvalds@linux-foundation.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

To prevent leaking stack contents in cases where it is not possible
for the compiler to figure out whether an automatic variable has been
initialized or not, add a plugin that forcibly initializes all automatic
variables of struct/union types if their address is taken at any point.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/Kconfig                               |   9 ++
 scripts/Makefile.gcc-plugins               |   3 +
 scripts/gcc-plugins/initautobyref_plugin.c | 159 ++++++++++++++++++++
 3 files changed, 171 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 6c00e5b00f8b..273b66749ad8 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -443,6 +443,15 @@ config GCC_PLUGIN_STRUCTLEAK_VERBOSE
 	  initialized. Since not all existing initializers are detected
 	  by the plugin, this can produce false positive warnings.
 
+config GCC_PLUGIN_INITAUTOBYREF
+	bool "Force initialization of auto variables that have their address taken"
+	depends on GCC_PLUGINS
+	help
+
+config GCC_PLUGIN_INITAUTOBYREF_VERBOSE
+	bool "Report uninitialized auto variables that have their address taken"
+	depends on GCC_PLUGIN_INITAUTOBYREF
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 82335533620e..90f30622f86d 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -29,6 +29,9 @@ ifdef CONFIG_GCC_PLUGINS
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	+= -fplugin-arg-structleak_plugin-verbose
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= -DSTRUCTLEAK_PLUGIN
 
+  gcc-plugin-$(CONFIG_GCC_PLUGIN_INITAUTOBYREF) += initautobyref_plugin.so
+  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_INITAUTOBYREF_VERBOSE)	+= -fplugin-arg-initautobyref_plugin-verbose
+
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
diff --git a/scripts/gcc-plugins/initautobyref_plugin.c b/scripts/gcc-plugins/initautobyref_plugin.c
new file mode 100644
index 000000000000..afc8b8f22056
--- /dev/null
+++ b/scripts/gcc-plugins/initautobyref_plugin.c
@@ -0,0 +1,159 @@
+/*
+ * Copyright 2013-2017 by PaX Team <pageexec@freemail.hu>
+ * Copyright 2017 by Ard Biesheuvel <ard.biesheuvel@linaro.org>
+ * Licensed under the GPL v2
+ *
+ * Note: the choice of the license means that the compilation process is
+ *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
+ *       but for the kernel it doesn't matter since it doesn't link against
+ *       any of the gcc libraries
+ *
+ * gcc plugin to forcibly initialize local variables that have their address
+ * taken, to prevent leaking data if the variable is never initialized (which
+ * may be difficult to decide for the compiler if the address is passed outside
+ * of the compilation unit)
+ *
+ * Options:
+ * -fplugin-arg-initautobyref_plugin-disable
+ * -fplugin-arg-initautobyref_plugin-verbose
+ */
+
+#include "gcc-common.h"
+
+__visible int plugin_is_GPL_compatible;
+
+static struct plugin_info initautobyref_plugin_info = {
+	.version	= "0.1",
+	.help		= "disable\tdo not activate plugin\n"
+			   "verbose\tprint all initialized variables\n",
+};
+
+static bool verbose;
+
+static void initialize(tree var)
+{
+	basic_block bb;
+	gimple_stmt_iterator gsi;
+	tree initializer;
+	gimple init_stmt;
+
+	/* this is the original entry bb before the forced split */
+	bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
+
+	/* first check if variable is already initialized, warn otherwise */
+	for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
+		gimple stmt = gsi_stmt(gsi);
+		tree rhs1;
+
+		/* we're looking for an assignment of a single rhs... */
+		if (!gimple_assign_single_p(stmt))
+			continue;
+		rhs1 = gimple_assign_rhs1(stmt);
+#if BUILDING_GCC_VERSION >= 4007
+		/* ... of a non-clobbering expression... */
+		if (TREE_CLOBBER_P(rhs1))
+			continue;
+#endif
+		/* ... to our variable... */
+		if (gimple_get_lhs(stmt) != var)
+			continue;
+		/* if it's an initializer then we're good */
+		if (TREE_CODE(rhs1) == CONSTRUCTOR)
+			return;
+	}
+
+	/* these aren't the 0days you're looking for */
+	if (verbose)
+		inform(DECL_SOURCE_LOCATION(var),
+			"auto variable will be forcibly initialized");
+
+	/* build the initializer expression */
+	initializer = build_constructor(TREE_TYPE(var), NULL);
+
+	/* build the initializer stmt */
+	init_stmt = gimple_build_assign(var, initializer);
+	gsi = gsi_after_labels(single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+	gsi_insert_before(&gsi, init_stmt, GSI_NEW_STMT);
+	update_stmt(init_stmt);
+}
+
+static unsigned int initautobyref_execute(void)
+{
+	basic_block bb;
+	unsigned int ret = 0;
+	tree var;
+	unsigned int i;
+
+	/* split the first bb where we can put the forced initializers */
+	gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+	bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
+	if (!single_pred_p(bb)) {
+		split_edge(single_succ_edge(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+		gcc_assert(single_succ_p(ENTRY_BLOCK_PTR_FOR_FN(cfun)));
+	}
+
+	/* enumerate all local variables and forcibly initialize our targets */
+	FOR_EACH_LOCAL_DECL(cfun, i, var) {
+		tree type = TREE_TYPE(var);
+
+		gcc_assert(DECL_P(var));
+		if (!auto_var_in_fn_p(var, current_function_decl))
+			continue;
+
+		/* only care about structure types */
+		if (TREE_CODE(type) != RECORD_TYPE && TREE_CODE(type) != UNION_TYPE)
+			continue;
+
+		/* initialize the variable if its address is taken */
+		if (TREE_ADDRESSABLE (var))
+			initialize(var);
+	}
+
+	return ret;
+}
+
+#define PASS_NAME initautobyref
+#define NO_GATE
+#define PROPERTIES_REQUIRED PROP_cfg
+#define TODO_FLAGS_FINISH TODO_verify_il | TODO_verify_ssa | TODO_verify_stmts | TODO_dump_func | TODO_remove_unused_locals | TODO_update_ssa | TODO_ggc_collect | TODO_verify_flow
+#include "gcc-generate-gimple-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
+{
+	int i;
+	const char * const plugin_name = plugin_info->base_name;
+	const int argc = plugin_info->argc;
+	const struct plugin_argument * const argv = plugin_info->argv;
+	bool enable = true;
+
+	PASS_INFO(initautobyref, "early_optimizations", 1, PASS_POS_INSERT_BEFORE);
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	if (strncmp(lang_hooks.name, "GNU C", 5) && !strncmp(lang_hooks.name, "GNU C+", 6)) {
+		inform(UNKNOWN_LOCATION, G_("%s supports C only, not %s"), plugin_name, lang_hooks.name);
+		enable = false;
+	}
+
+	for (i = 0; i < argc; ++i) {
+		if (!strcmp(argv[i].key, "disable")) {
+			enable = false;
+			continue;
+		}
+		if (!strcmp(argv[i].key, "verbose")) {
+			verbose = true;
+			continue;
+		}
+		error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL, &initautobyref_plugin_info);
+	if (enable) {
+		register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &initautobyref_pass_info);
+	}
+
+	return 0;
+}
-- 
2.9.3
