From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable types
Date: Tue, 12 Feb 2019 10:04:40 -0800
Message-Id: <20190212180441.15340-2-keescook@chromium.org>
In-Reply-To: <20190212180441.15340-1-keescook@chromium.org>
References: <20190212180441.15340-1-keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adjusts structleak to also work with non-struct types when they
are passed by reference, since those variables may leak just like
anything else. This is exposed via an improved set of Kconfig options.
(This does mean structleak is slightly misnamed now.)

Building with CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL should give the
kernel complete initialization coverage of all stack variables passed
by reference, including padding (see lib/test_stackinit.c).

Using CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE to count added initializations
under defconfig:

	..._BYREF:      5945 added initializations
	..._BYREF_ALL: 16606 added initializations

There is virtually no change to text+data size (both have less than 0.05%
growth):

   text    data     bss     dec     hex filename
19502103        5051456 1917000 26470559        193e89f vmlinux.stock
19513412        5051456 1908808 26473676        193f4cc vmlinux.byref
19516974        5047360 1900616 26464950        193d2b6 vmlinux.byref_all

The measured performance difference is in the noise for hackbench and
kernel build benchmarks:

Stock:

	5x hackbench -g 20 -l 1000
	Mean:   10.649s
	Std Dev: 0.339

	5x kernel build (4-way parallel)
	Mean:  261.98s
	Std Dev: 1.53

CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF:

	5x hackbench -g 20 -l 1000
	Mean:   10.540s
	Std Dev: 0.233

	5x kernel build (4-way parallel)
	Mean:  260.52s
	Std Dev: 1.31

CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL:

	5x hackbench -g 20 -l 1000
	Mean:   10.320
	Std Dev: 0.413

	5x kernel build (4-way parallel)
	Mean:  260.10
	Std Dev: 0.86

This does not yet solve missing padding initialization for structures
on the stack that are never passed by reference (which should be a tiny
minority). Hopefully this will be more easily addressed by upstream
compiler fixes after clarifying the C11 padding initialization
specification.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/Makefile.gcc-plugins            |  2 +
 scripts/gcc-plugins/Kconfig             | 58 ++++++++++++++++++++-----
 scripts/gcc-plugins/structleak_plugin.c | 36 ++++++++++-----
 3 files changed, 74 insertions(+), 22 deletions(-)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 35042d96cf5d..5f7df50cfe7a 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -15,6 +15,8 @@ gcc-plugin-$(CONFIG_GCC_PLUGIN_SANCOV)		+= sancov_plugin.so
 gcc-plugin-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= structleak_plugin.so
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	\
 		+= -fplugin-arg-structleak_plugin-verbose
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF)		\
+		+= -fplugin-arg-structleak_plugin-byref
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	\
 		+= -fplugin-arg-structleak_plugin-byref-all
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)		\
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index d45f7f36b859..d0cc92e48f6f 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -67,27 +67,63 @@ config GCC_PLUGIN_LATENT_ENTROPY
 	   * https://pax.grsecurity.net/
 
 config GCC_PLUGIN_STRUCTLEAK
-	bool "Force initialization of variables containing userspace addresses"
+	bool "Zero initialize stack variables"
 	# Currently STRUCTLEAK inserts initialization out of live scope of
 	# variables from KASAN point of view. This leads to KASAN false
 	# positive reports. Prohibit this combination for now.
 	depends on !KASAN_EXTRA
 	help
-	  This plugin zero-initializes any structures containing a
-	  __user attribute. This can prevent some classes of information
-	  exposures.
-
-	  This plugin was ported from grsecurity/PaX. More information at:
+	  While the kernel is built with warnings enabled for any missed
+	  stack variable initializations, this warning is silenced for
+	  anything passed by reference to another function, under the
+	  occasionally misguided assumption that the function will do
+	  the initialization. As this regularly leads to exploitable
+	  flaws, this plugin is available to identify and zero-initialize
+	  such variables, depending on the chosen level of coverage.
+
+	  This plugin was originally ported from grsecurity/PaX. More
+	  information at:
 	   * https://grsecurity.net/
 	   * https://pax.grsecurity.net/
 
-config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
-	bool "Force initialize all struct type variables passed by reference"
+choice
+	prompt "Coverage"
 	depends on GCC_PLUGIN_STRUCTLEAK
-	depends on !COMPILE_TEST
+	default GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
 	help
-	  Zero initialize any struct type local variable that may be passed by
-	  reference without having been initialized.
+	  This chooses the level of coverage over classes of potentially
+	  uninitialized variables. The selected class will be
+	  zero-initialized before use.
+
+	config GCC_PLUGIN_STRUCTLEAK_USER
+		bool "structs marked for userspace"
+		help
+		  Zero-initialize any structures on the stack containing
+		  a __user attribute. This can prevent some classes of
+		  uninitialized stack variable exploits and information
+		  exposures, like CVE-2013-2141:
+		  https://git.kernel.org/linus/b9e146d8eb3b9eca
+
+	config GCC_PLUGIN_STRUCTLEAK_BYREF
+		bool "structs passed by reference"
+		help
+		  Zero-initialize any structures on the stack that may
+		  be passed by reference and had not already been
+		  explicitly initialized. This can prevent most classes
+		  of uninitialized stack variable exploits and information
+		  exposures, like CVE-2017-1000410:
+		  https://git.kernel.org/linus/06e7e776ca4d3654
+
+	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
+		bool "anything passed by reference"
+		help
+		  Zero-initialize any stack variables that may be passed
+		  by reference and had not already been explicitly
+		  initialized. This is intended to eliminate all classes
+		  of uninitialized stack variable exploits and information
+		  exposures.
+
+endchoice
 
 config GCC_PLUGIN_STRUCTLEAK_VERBOSE
 	bool "Report forcefully initialized variables"
diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
index 10292f791e99..e89be8f5c859 100644
--- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -16,6 +16,7 @@
  * Options:
  * -fplugin-arg-structleak_plugin-disable
  * -fplugin-arg-structleak_plugin-verbose
+ * -fplugin-arg-structleak_plugin-byref
  * -fplugin-arg-structleak_plugin-byref-all
  *
  * Usage:
@@ -26,7 +27,6 @@
  * $ gcc -fplugin=./structleak_plugin.so test.c -O2
  *
  * TODO: eliminate redundant initializers
- *       increase type coverage
  */
 
 #include "gcc-common.h"
@@ -37,13 +37,18 @@
 __visible int plugin_is_GPL_compatible;
 
 static struct plugin_info structleak_plugin_info = {
-	.version	= "201607271510vanilla",
+	.version	= "20190125vanilla",
 	.help		= "disable\tdo not activate plugin\n"
-			   "verbose\tprint all initialized variables\n",
+			  "byref\tinit structs passed by reference\n"
+			  "byref-all\tinit anything passed by reference\n"
+			  "verbose\tprint all initialized variables\n",
 };
 
+#define BYREF_STRUCT	1
+#define BYREF_ALL	2
+
 static bool verbose;
-static bool byref_all;
+static int byref;
 
 static tree handle_user_attribute(tree *node, tree name, tree args, int flags, bool *no_add_attrs)
 {
@@ -118,6 +123,7 @@ static void initialize(tree var)
 	gimple_stmt_iterator gsi;
 	tree initializer;
 	gimple init_stmt;
+	tree type;
 
 	/* this is the original entry bb before the forced split */
 	bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
@@ -148,11 +154,15 @@ static void initialize(tree var)
 	if (verbose)
 		inform(DECL_SOURCE_LOCATION(var),
 			"%s variable will be forcibly initialized",
-			(byref_all && TREE_ADDRESSABLE(var)) ? "byref"
-							     : "userspace");
+			(byref && TREE_ADDRESSABLE(var)) ? "byref"
+							 : "userspace");
 
 	/* build the initializer expression */
-	initializer = build_constructor(TREE_TYPE(var), NULL);
+	type = TREE_TYPE(var);
+	if (AGGREGATE_TYPE_P(type))
+		initializer = build_constructor(type, NULL);
+	else
+		initializer = fold_convert(type, integer_zero_node);
 
 	/* build the initializer stmt */
 	init_stmt = gimple_build_assign(var, initializer);
@@ -184,13 +194,13 @@ static unsigned int structleak_execute(void)
 		if (!auto_var_in_fn_p(var, current_function_decl))
 			continue;
 
-		/* only care about structure types */
-		if (TREE_CODE(type) != RECORD_TYPE && TREE_CODE(type) != UNION_TYPE)
+		/* only care about structure types unless byref-all */
+		if (byref != BYREF_ALL && TREE_CODE(type) != RECORD_TYPE && TREE_CODE(type) != UNION_TYPE)
 			continue;
 
 		/* if the type is of interest, examine the variable */
 		if (TYPE_USERSPACE(type) ||
-		    (byref_all && TREE_ADDRESSABLE(var)))
+		    (byref && TREE_ADDRESSABLE(var)))
 			initialize(var);
 	}
 
@@ -232,8 +242,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gc
 			verbose = true;
 			continue;
 		}
+		if (!strcmp(argv[i].key, "byref")) {
+			byref = BYREF_STRUCT;
+			continue;
+		}
 		if (!strcmp(argv[i].key, "byref-all")) {
-			byref_all = true;
+			byref = BYREF_ALL;
 			continue;
 		}
 		error(G_("unknown option '-fplugin-arg-%s-%s'"), plugin_name, argv[i].key);
-- 
2.17.1
