Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Apr 2016 20:24:54 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160422202454.b346331b5c1640ca31167a82@gmail.com>
In-Reply-To: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v7 4/6] Add Cyclomatic complexity GCC plugin
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

Add a very simple plugin to demonstrate the GCC plugin infrastructure. This GCC
plugin computes the cyclomatic complexity of each function.

The complexity M of a function's control flow graph is defined as:
M = E - N + 2P
where
E = the number of edges
N = the number of nodes
P = the number of connected components (exit nodes).

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/Kconfig                                | 12 +++++
 scripts/Makefile.gcc-plugins                |  2 +
 scripts/gcc-plugins/Makefile                |  4 ++
 scripts/gcc-plugins/cyc_complexity_plugin.c | 73 +++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)
 create mode 100644 scripts/gcc-plugins/cyc_complexity_plugin.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 7c12571..ddf29b4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -366,6 +366,18 @@ menuconfig GCC_PLUGINS
 	  GCC plugins are loadable modules that provide extra features to the
 	  compiler. They are useful for runtime instrumentation and static analysis.
 
+config GCC_PLUGIN_CYC_COMPLEXITY
+	bool "Compute the cyclomatic complexity of a function"
+	depends on GCC_PLUGINS
+	help
+	  The complexity M of a function's control flow graph is defined as:
+	   M = E - N + 2P
+	  where
+
+	  E = the number of edges
+	  N = the number of nodes
+	  P = the number of connected components (exit nodes).
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index e6d66e2..282d63a 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -2,6 +2,8 @@ ifdef CONFIG_GCC_PLUGINS
   __PLUGINCC := $(call cc-ifversion, -ge, 0408, $(HOSTCXX), $(HOSTCC))
   PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(__PLUGINCC)" "$(HOSTCXX)" "$(CC)")
 
+  gcc-plugin-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY)	+= cyc_complexity_plugin.so
+
   GCC_PLUGINS_CFLAGS := $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y))
 
   ifeq ($(PLUGINCC),)
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index b2d64af..31c72bf 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -12,4 +12,8 @@ endif
 
 export GCCPLUGINS_DIR HOSTLIBS
 
+$(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) := cyc_complexity_plugin.so
+
 always := $($(HOSTLIBS)-y)
+
+cyc_complexity_plugin-objs := cyc_complexity_plugin.o
diff --git a/scripts/gcc-plugins/cyc_complexity_plugin.c b/scripts/gcc-plugins/cyc_complexity_plugin.c
new file mode 100644
index 0000000..34df974
--- /dev/null
+++ b/scripts/gcc-plugins/cyc_complexity_plugin.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
+ * Licensed under the GPL v2, or (at your option) v3
+ *
+ * Homepage:
+ * https://github.com/ephox-gcc-plugins/cyclomatic_complexity
+ *
+ * http://en.wikipedia.org/wiki/Cyclomatic_complexity
+ * The complexity M is then defined as:
+ * M = E - N + 2P
+ * where
+ *
+ *  E = the number of edges of the graph
+ *  N = the number of nodes of the graph
+ *  P = the number of connected components (exit nodes).
+ *
+ * Usage (4.5 - 5):
+ * $ make clean; make run
+ */
+
+#include "gcc-common.h"
+
+int plugin_is_GPL_compatible;
+
+static struct plugin_info cyc_complexity_plugin_info = {
+	.version	= "20160225",
+	.help		= "Cyclomatic Complexity\n",
+};
+
+static unsigned int cyc_complexity_execute(void)
+{
+	int complexity;
+	expanded_location xloc;
+
+	/* M = E - N + 2P */
+	complexity = n_edges_for_fn(cfun) - n_basic_blocks_for_fn(cfun) + 2;
+
+	xloc = expand_location(DECL_SOURCE_LOCATION(current_function_decl));
+	fprintf(stderr, "Cyclomatic Complexity %d %s:%s\n", complexity,
+		xloc.file, DECL_NAME_POINTER(current_function_decl));
+
+	return 0;
+}
+
+#define PASS_NAME cyc_complexity
+
+#define NO_GATE
+#define TODO_FLAGS_FINISH TODO_dump_func
+
+#include "gcc-generate-gimple-pass.h"
+
+int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
+{
+	const char * const plugin_name = plugin_info->base_name;
+	struct register_pass_info cyc_complexity_pass_info;
+
+	cyc_complexity_pass_info.pass				= make_cyc_complexity_pass();
+	cyc_complexity_pass_info.reference_pass_name		= "ssa";
+	cyc_complexity_pass_info.ref_pass_instance_number	= 1;
+	cyc_complexity_pass_info.pos_op				= PASS_POS_INSERT_AFTER;
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL,
+				&cyc_complexity_plugin_info);
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
+				&cyc_complexity_pass_info);
+
+	return 0;
+}
-- 
2.4.1
