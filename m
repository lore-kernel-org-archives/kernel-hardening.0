Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Mar 2016 00:05:31 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160307000531.d43ae7df74bfa5e9e9e29087@gmail.com>
In-Reply-To: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 3/5] Add Cyclomatic complexity GCC plugin
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org
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
 arch/Kconfig                      | 12 +++++++
 scripts/Makefile.gcc-plugins      |  6 +++-
 tools/gcc/Makefile                |  4 +++
 tools/gcc/cyc_complexity_plugin.c | 73 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 tools/gcc/cyc_complexity_plugin.c

diff --git a/arch/Kconfig b/arch/Kconfig
index e090642..59bde9b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -370,6 +370,18 @@ menuconfig GCC_PLUGINS
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
index 7c85bf2..dd7b56d 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -5,7 +5,11 @@ else
 PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
 endif
 ifneq ($(PLUGINCC),)
-export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
+ifdef CONFIG_GCC_PLUGIN_CYC_COMPLEXITY
+GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS := -fplugin=$(objtree)/tools/gcc/cyc_complexity_plugin.so
+endif
+GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS)
+export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY
 ifeq ($(KBUILD_EXTMOD),)
 gcc-plugins:
 	$(Q)$(MAKE) $(build)=tools/gcc
diff --git a/tools/gcc/Makefile b/tools/gcc/Makefile
index b2d64af..31c72bf 100644
--- a/tools/gcc/Makefile
+++ b/tools/gcc/Makefile
@@ -12,4 +12,8 @@ endif
 
 export GCCPLUGINS_DIR HOSTLIBS
 
+$(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) := cyc_complexity_plugin.so
+
 always := $($(HOSTLIBS)-y)
+
+cyc_complexity_plugin-objs := cyc_complexity_plugin.o
diff --git a/tools/gcc/cyc_complexity_plugin.c b/tools/gcc/cyc_complexity_plugin.c
new file mode 100644
index 0000000..34df974
--- /dev/null
+++ b/tools/gcc/cyc_complexity_plugin.c
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
