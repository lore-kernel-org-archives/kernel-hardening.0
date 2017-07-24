Sender: Hans Liljestrand <ishkamiel@gmail.com>
From: Hans Liljestrand <liljestrandh@gmail.com>
Date: Mon, 24 Jul 2017 16:38:21 +0300
Message-Id: <20170724133824.27223-3-LiljestrandH@gmail.com>
In-Reply-To: <20170724133824.27223-1-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
Subject: [kernel-hardening] [RFC PATCH 2/5] gcc-plugins: adds MPXK gcc plugin
To: kernel-hardening@lists.openwall.com
Cc: elena.reshetova@intel.com, dave.hansen@intel.com, keescook@chromium.org, hpa@zytor.com, Hans Liljestrand <LiljestrandH@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Adds a gcc-plugin that modifies vanilla GCC MPX instrumentation for
in-kernel use. Also adds MPXK_CFLAGS Makefile variable that can be used to
selectively enable MPXK for specific kernel objects. This plugin is not
enabled kernel-wide and must be explicitly enabled in the appropriate
Makefile.

The purpose of the plugin is to replace BNDSTX+BNDLDX bound storage with
our own mpxk_load_bounds function and to replace memory mainpulating
function with corresponding wrapper function. The plugin accomplishes
this via the following tasks:

- It adds MPXK-wrappers functions for memory altering functions, e.g.
  kmalloc, memcpy, etc. This is needed both to check bounds for input
  argument pointers and properly set bounds for returned pointers. This
  is done by the mpxk_wrappers compiler pass. (This could potentially
  be done, for better performance, by direct instrumentation at the call
  site.)

- Replace BNDLDX calls with mpxk_load_bounds function calls. This
  includes two separate cases: free-standing loads handled by the
  mpxk_bnd_store pass, and loads in function prologues that are handled
  by the mpxk_cfun_args pass. These are needed for situation where the
  compile time instrumentation cannot determine a way to statically
  propagate the bounds via the stack or registers.

- The final mpxk_pass_sweeper removes any remaining BNDLDX/BNDSTX calls.

Signed-off-by: Hans Liljestrand <LiljestrandH@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 scripts/Makefile.gcc-plugins              |  17 +++
 scripts/gcc-plugins/Makefile              |   6 ++
 scripts/gcc-plugins/mpxk.c                | 171 ++++++++++++++++++++++++++++++
 scripts/gcc-plugins/mpxk.h                |  60 +++++++++++
 scripts/gcc-plugins/mpxk_builtins.c       | 102 ++++++++++++++++++
 scripts/gcc-plugins/mpxk_builtins.def     |  41 +++++++
 scripts/gcc-plugins/mpxk_pass_bnd_store.c | 147 +++++++++++++++++++++++++
 scripts/gcc-plugins/mpxk_pass_cfun_args.c |  98 +++++++++++++++++
 scripts/gcc-plugins/mpxk_pass_sweeper.c   | 107 +++++++++++++++++++
 scripts/gcc-plugins/mpxk_pass_wrappers.c  | 128 ++++++++++++++++++++++
 10 files changed, 877 insertions(+)
 create mode 100644 scripts/gcc-plugins/mpxk.c
 create mode 100644 scripts/gcc-plugins/mpxk.h
 create mode 100644 scripts/gcc-plugins/mpxk_builtins.c
 create mode 100644 scripts/gcc-plugins/mpxk_builtins.def
 create mode 100644 scripts/gcc-plugins/mpxk_pass_bnd_store.c
 create mode 100644 scripts/gcc-plugins/mpxk_pass_cfun_args.c
 create mode 100644 scripts/gcc-plugins/mpxk_pass_sweeper.c
 create mode 100644 scripts/gcc-plugins/mpxk_pass_wrappers.c

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 82335533620e..696aa8fb6097 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -29,7 +29,24 @@ ifdef CONFIG_GCC_PLUGINS
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE)	+= -fplugin-arg-structleak_plugin-verbose
   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)	+= -DSTRUCTLEAK_PLUGIN
 
+  ifdef CONFIG_X86_INTEL_MPX_KERNEL
+    MPXK_PLUGIN := -fplugin=$(objtree)/scripts/gcc-plugins/mpxk.so
+    gcc-plugin-$(CONFIG_X86_INTEL_MPX_KERNEL)		+= mpxk.so
+
+    MPXK_CFLAGS := -mmpx -fcheck-pointer-bounds $(MPXK_PLUGIN)
+    MPXK_CFLAGS += -fno-chkp-store-bounds
+    MPXK_CFLAGS += -fno-chkp-use-wrappers
+
+    MPXK_LIB_CFLAGS := $(MPXK_CFLAGS)
+    MPXK_LIB_CFLAGS += -fno-chkp-narrow-bounds
+    MPXK_LIB_CFLAGS += -fno-chkp-check-read
+    MPXK_LIB_CFLAGS += -fno-chkp-check-write
+
+    export MPXK_PLUGIN MPXK_LIB_CFLAGS MPXK_CFLAGS
+  endif
+
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
+  GCC_PLUGINS_CFLAGS := $(filter-out $(MPXK_PLUGIN), $(GCC_PLUGINS_CFLAGS))
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
   export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index 8b29dc17c73c..b1aeef2c6ecb 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -23,6 +23,12 @@ always := $($(HOSTLIBS)-y)
 
 $(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
 
+mpxk-objs					+= mpxk_builtins.o
+mpxk-objs					+= mpxk_pass_wrappers.o
+mpxk-objs					+= mpxk_pass_bnd_store.o
+mpxk-objs					+= mpxk_pass_cfun_args.o
+mpxk-objs					+= mpxk_pass_sweeper.o
+
 subdir-y := $(GCC_PLUGIN_SUBDIR)
 subdir-  += $(GCC_PLUGIN_SUBDIR)
 
diff --git a/scripts/gcc-plugins/mpxk.c b/scripts/gcc-plugins/mpxk.c
new file mode 100644
index 000000000000..096f63c74c77
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk.c
@@ -0,0 +1,171 @@
+/*
+ * scripts/gcc-plugins/mpxk.c
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+#include "mpxk.h"
+#include <tree-chkp.h>
+#include <ipa-chkp.h>
+
+static void mpxk_plugin_finish(void *gcc_data, void *user_data);
+static tree get_load_fndecl(void);
+
+struct mpxk_bound_store_stats mpxk_stats = {
+	.dropped_ldx = 0,
+	.dropped_stx = 0,
+	.dropped_stx_brute = 0,
+	.wrappers_added = 0,
+	.sweep_ldx = 0,
+	.cfun_ldx = 0,
+	.sweep_stx = 0
+};
+
+#ifndef __visible
+#define __visible
+#endif
+__visible int plugin_is_GPL_compatible;
+
+static struct plugin_info mpxk_plugin_info = {
+	.version	= "20170308",
+	.help		= "MPX support for kernel space\n"
+};
+
+__visible int plugin_init(
+		struct plugin_name_args *plugin_info,
+		struct plugin_gcc_version *version)
+{
+	const char * const plugin_name = plugin_info->base_name;
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	/* First run some sanity checks... */
+	mpxk_builitins_sanity_check();
+
+	/* Register some generic plugin callbacks */
+	register_callback(plugin_name, PLUGIN_INFO, NULL, &mpxk_plugin_info);
+	register_callback(plugin_name, PLUGIN_FINISH,
+			  &mpxk_plugin_finish, NULL);
+
+	/* Insert the specialized MPXK passes */
+
+	/* Replace wrappables with mpxk_wrappers. */
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
+			  get_mpxk_wrappers_pass_info());
+
+	/* Remove bndldx/bndstx calls.*/
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
+			  get_mpxk_bnd_store_pass_info());
+
+	/* Handle incoming bounds arguments. */
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
+			  get_mpxk_cfun_args_pass_info());
+
+	/* Brute force removal of all BNDSTX/BNDLDX instructions */
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
+			  get_mpxk_sweeper_pass_info());
+
+
+	return 0;
+}
+
+/**
+ * mpxk_plugin_finish - display some debug data on plugin finish.
+ */
+static void mpxk_plugin_finish(void *gcc_data, void *user_data)
+{
+	(void) gcc_data;
+	(void) user_data;
+
+#ifdef MPXK_DEBUG
+	expanded_location loc = expand_location(input_location);
+
+	fprintf(stderr,
+		"SUMMARY:bndstx[%d+%d=>%d],bndldx[%d+%d=>%d],wraps[%d](%s)\n",
+		mpxk_stats.dropped_stx, mpxk_stats.dropped_stx_brute,
+		mpxk_stats.sweep_stx, mpxk_stats.dropped_ldx,
+		mpxk_stats.cfun_ldx, mpxk_stats.sweep_ldx,
+		mpxk_stats.wrappers_added, loc.file);
+#endif
+}
+
+bool skip_execute(const char *attr)
+{
+	if (attr != NULL && lookup_attribute(attr,
+				DECL_ATTRIBUTES(cfun->decl)) != NULL)
+		return true;
+	return false;
+}
+
+/**
+ * insert_mpxk_bound_load - insert all to the MPXK bound function and bndret.
+ * @gsi: The gimple_stmt_iterator for the insert location.
+ * @pointer: The pointer based on which the bounds are loaded.
+ * @bounds: The bounds variable for storing the loaded bounds.
+ *
+ * This inserts two GIMPLE statements, a gcall to the bounds load function and
+ * a subsequent bndret to store the bounds. The iterator is left on the latter
+ * bndret stmt.
+ */
+void insert_mpxk_bound_load(
+		gimple_stmt_iterator *gsi, tree pointer, tree bounds)
+{
+	tree load_fndecl, tmp_ptr;
+	gcall *load_call;
+
+	/* Prepare mpxk load_bounds call => tmp_ptr = load_call(pointer) */
+	load_fndecl = get_load_fndecl();
+	load_call = gimple_build_call(load_fndecl, 1, pointer);
+
+	/* We need the returned pointer for the latter bndret call */
+	tmp_ptr = create_tmp_var(ptr_type_node, "tmp_ptr");
+	gimple_call_set_lhs(load_call, tmp_ptr);
+
+	/* Set chkp instrumentation stuff */
+	gimple_call_set_with_bounds(load_call, true);
+	gimple_set_plf(load_call, GF_PLF_1, false);
+
+	/* Some error checking */
+	gcc_assert((load_call->subcode & GF_CALL_INTERNAL) == 0);
+	gcc_assert((load_call->subcode & GF_CALL_WITH_BOUNDS) != 0);
+
+	gsi_insert_before(gsi, load_call, GSI_NEW_STMT);
+	chkp_insert_retbnd_call(bounds, tmp_ptr, gsi);
+
+	chkp_set_bounds(pointer, bounds);
+	gimple_call_with_bounds_p(load_call);
+
+	update_stmt(load_call);
+}
+
+/**
+ * get_load_fndecl - Return fndecl for the MPXK bounds load function
+ */
+static tree get_load_fndecl(void)
+{
+	tree parm_type_list, fntype, fndecl;
+
+	parm_type_list = build_tree_list_stat(NULL_TREE, ptr_type_node);
+
+	fntype = build_function_type(ptr_type_node, parm_type_list);
+	fntype = chkp_copy_function_type_adding_bounds(fntype);
+
+	fndecl = build_decl(UNKNOWN_LOCATION, FUNCTION_DECL,
+			get_identifier(MPXK_LOAD_BOUNDS_FN_NAME), fntype);
+
+	DECL_EXTERNAL(fndecl) = 1;
+
+	DECL_RESULT(fndecl) = build_decl(UNKNOWN_LOCATION, RESULT_DECL,
+			NULL_TREE, ptr_type_node);
+
+	DECL_ATTRIBUTES(fndecl) = tree_cons(get_identifier("bnd_legacy"),
+			NULL, DECL_ATTRIBUTES(fndecl));
+
+	TREE_PUBLIC(DECL_RESULT(fndecl)) = 1;
+
+	return fndecl;
+}
diff --git a/scripts/gcc-plugins/mpxk.h b/scripts/gcc-plugins/mpxk.h
new file mode 100644
index 000000000000..b39004f49e09
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk.h
@@ -0,0 +1,60 @@
+/*
+ * mpxk.h - MPXK plugin main header
+ *
+ * Copyright (C) 2017 Hans Liljestrand <LiljestrandH@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ */
+#ifndef PLUGIN_MPX_PLUGIN_H
+#define PLUGIN_MPX_PLUGIN_H
+
+#include "gcc-common.h"
+
+#define BND_LEGACY "bnd_legacy"
+
+#define MPXK_BND_REGS 4
+#define MPXK_LOAD_BOUNDS_FN_NAME "mpxk_load_bounds"
+#define MPXK_WRAPPER_PREFIX "mpxk_wrapper_"
+
+/* #define MPXK_DEBUG */
+
+struct mpxk_bound_store_stats {
+	int dropped_ldx;
+	int dropped_stx;
+	int dropped_stx_brute;
+	int wrappers_added;
+	int sweep_ldx;
+	int cfun_ldx;
+	int sweep_stx;
+};
+
+/* Store some shared stats on current unit. */
+extern struct mpxk_bound_store_stats mpxk_stats;
+
+/* defined in mpxk.c */
+bool skip_execute(const char *attr);
+void insert_mpxk_bound_load(
+		gimple_stmt_iterator *gsi, tree pointer, tree bounds);
+
+/* passes are defined in the mpxk_pass*.c files */
+struct register_pass_info *get_mpxk_wrappers_pass_info(void);
+struct register_pass_info *get_mpxk_bnd_store_pass_info(void);
+struct register_pass_info *get_mpxk_cfun_args_pass_info(void);
+struct register_pass_info *get_mpxk_sweeper_pass_info(void);
+
+/* mpxk_builtins.c */
+void mpxk_builitins_sanity_check(void);
+bool mpxk_is_wrappable(const char *name);
+bool mpxk_is_wrapper(const char *name);
+const char *mpxk_get_wrapper_name(const char *name);
+
+#ifdef MPXK_DEBUG
+#define dsay_print(m, ...) fprintf(stderr, "%s (%s): " m "\n",	  \
+			DECL_NAME_POINTER(current_function_decl), \
+			__func__,  __VA_ARGS__)
+#define dsay(...) dsay_print(__VA_ARGS__)
+#else
+#define dsay(...)
+#endif /* MPXK_DEBUG */
+
+#endif /* PLUGIN_MPX_PLUGIN_H */
diff --git a/scripts/gcc-plugins/mpxk_builtins.c b/scripts/gcc-plugins/mpxk_builtins.c
new file mode 100644
index 000000000000..3e9bdc3cfd87
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk_builtins.c
@@ -0,0 +1,102 @@
+/*
+ * scripts/gcc-plugins/mpxk_builtins.c
+ *
+ * Defines various helper functions for identifying interesting functions
+ * and converting names for wrapper functions.
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+#include "mpxk.h"
+
+static int wrapper_i(const char *name);
+static int builtin_i(const char *name);
+
+struct mpxk_builtin {
+	const bool is_wrapper;
+	const bool is_loader;
+	const char *name;
+};
+
+static const struct mpxk_builtin mpxk_fndecls[] = {
+#define MPXK_BUILTIN_DEF(r, x, ...) \
+	{ .is_wrapper = 0, .is_loader = 1, .name = #x },
+#define MPXK_WRAPPER_DEF(r, x, ...) \
+	{ .is_wrapper = 1, .is_loader = 0, .name = MPXK_WRAPPER_PREFIX #x },
+#include "mpxk_builtins.def"
+#undef MPXK_WRAPPER_DEF
+#undef MPXK_BUILTIN_DEF
+};
+
+bool mpxk_is_wrapper(const char *name)
+{
+	gcc_assert(name != NULL);
+	return (bool) (wrapper_i(name) >= 0);
+}
+
+const char *mpxk_get_wrapper_name(const char *name)
+{
+	gcc_assert(name != NULL);
+
+	char wr_name[strlen(MPXK_WRAPPER_PREFIX) + strlen(name) + 1];
+
+	sprintf(wr_name, "%s%s", MPXK_WRAPPER_PREFIX, name);
+
+	const int i = wrapper_i(wr_name);
+
+	if (i >= 0)
+		return mpxk_fndecls[i].name;
+
+	return NULL;
+}
+
+bool mpxk_is_wrappable(const char *name)
+{
+	gcc_assert(name != NULL);
+	return (bool) (mpxk_get_wrapper_name(name) != NULL);
+}
+
+static int builtin_i(const char *name)
+{
+	gcc_assert(name != NULL);
+
+	for (int i = 0; i < ARRAY_SIZE(mpxk_fndecls); i++) {
+		gcc_assert(mpxk_fndecls[i].name != NULL);
+
+		if (strcmp(mpxk_fndecls[i].name, name) == 0)
+			return i;
+	}
+
+	return -1;
+}
+
+static int wrapper_i(const char *name)
+{
+	gcc_assert(name != NULL);
+	const int i = builtin_i(name);
+
+	return (i == -1 ? -1 : (mpxk_fndecls[i].is_wrapper ? i : -1));
+}
+
+void mpxk_builitins_sanity_check(void)
+{
+	(void) gcc_version;
+
+	gcc_assert(strcmp(MPXK_WRAPPER_PREFIX "kmalloc",
+			  mpxk_get_wrapper_name("kmalloc")) == 0);
+
+	gcc_assert(builtin_i(MPXK_LOAD_BOUNDS_FN_NAME) >= 0);
+	gcc_assert(builtin_i("mpxk_wrapper_kmalloc") >= 0);
+	gcc_assert(mpxk_is_wrapper("mpxk_wrapper_kmalloc"));
+	gcc_assert(mpxk_is_wrapper(MPXK_WRAPPER_PREFIX "kmalloc"));
+	gcc_assert(mpxk_is_wrappable("kmalloc"));
+
+	gcc_assert(!mpxk_is_wrapper(MPXK_LOAD_BOUNDS_FN_NAME));
+	gcc_assert(builtin_i("kmalloc") < 0);
+	gcc_assert(!mpxk_is_wrapper("kmalloc"));
+	gcc_assert(builtin_i("mpxk_wrapper_not_good_at_all") < 0);
+	gcc_assert(!mpxk_is_wrapper("mpxk_wrapper_not_good_at_all"));
+	gcc_assert(!mpxk_is_wrapper("_" MPXK_WRAPPER_PREFIX "kmalloc"));
+	gcc_assert(!mpxk_is_wrappable(MPXK_WRAPPER_PREFIX "kmalloc"));
+}
diff --git a/scripts/gcc-plugins/mpxk_builtins.def b/scripts/gcc-plugins/mpxk_builtins.def
new file mode 100644
index 000000000000..69c8f0d67ca7
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk_builtins.def
@@ -0,0 +1,41 @@
+/*
+ * scripts/gcc-plugins/mpxk_builtins.def - MPXK wrapper definitions
+ *
+ * Keep these centralized here so they are easy to pull into both the
+ * gcc-plugin and into the actual in-kernel function implementations.
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+
+MPXK_BUILTIN_DEF(void *, mpxk_load_bounds, void *p)
+
+MPXK_WRAPPER_DEF(void *, kmalloc, size_t s, gfp_t f)
+MPXK_WRAPPER_DEF(void *, krealloc, void *p, size_t s, gfp_t f)
+
+MPXK_WRAPPER_DEF(void *, memmove, void *d, const void *s, size_t c)
+MPXK_WRAPPER_DEF(void *, memcpy, void *d, const void *s, size_t c)
+MPXK_WRAPPER_DEF(void *, __memcpy, void *d, const void *s, size_t c)
+MPXK_WRAPPER_DEF(void *, __inline_memcpy, void *d, const void *s, size_t c)
+
+MPXK_WRAPPER_DEF(void *, memset, void *s, int c, size_t l)
+MPXK_WRAPPER_DEF(char *, strcat, char *d, const char *s)
+MPXK_WRAPPER_DEF(char *, strncat, char *d, const char *s, size_t c)
+MPXK_WRAPPER_DEF(char *, strcpy, char *d, const char *s)
+MPXK_WRAPPER_DEF(char *, strncpy, char *d, const char *s, size_t c)
+MPXK_WRAPPER_DEF(size_t, strlen, const char *s)
+MPXK_WRAPPER_DEF(size_t, strnlen, const char *s, size_t c)
+
+/* libmpx wrappers that MPXK doesn't provide
+__mpx_wrapper_malloc; - malloc in linux/decompress/mm.h only for pre-boot
+__mpx_wrapper_mmap; - N/A
+__mpx_wrapper_realloc; - N/A
+__mpx_wrapper_calloc; - N/A
+__mpx_wrapper_bzero; - N/A
+__mpx_wrapper_mempcpy; - N/A
+__mpx_wrapper_stpcpy; - N/A
+__mpx_wrapper_stpncpy; - N/A
+*/
+
+// vim: ft=cpp
diff --git a/scripts/gcc-plugins/mpxk_pass_bnd_store.c b/scripts/gcc-plugins/mpxk_pass_bnd_store.c
new file mode 100644
index 000000000000..8bd6aa500973
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk_pass_bnd_store.c
@@ -0,0 +1,147 @@
+/*
+ * scripts/gcc-plugins/mpxk.c - Handle basic bndstx/bndldx cases.
+ *
+ * This GIMPLE, post chkp, pass removes any encountered bndstx and bndldx
+ * calls. The bndldx calls are replaces with calls to the MPXK bound load
+ * function. Note that this only catches statements added during the chkp
+ * GIMPLE passes, and does not handle stores and loads due to function
+ * arguments (and potentially other cases).
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+#include "mpxk.h"
+
+#include <ipa-chkp.h>
+#include <tree-chkp.h>
+
+static unsigned int mpxk_bnd_store_execute(void);
+
+static void handle_ldx(gimple_stmt_iterator *gsi, gcall *call);
+static void handle_stx(gimple_stmt_iterator *gsi, gcall *call);
+
+#define PASS_NAME mpxk_bnd_store
+#define NO_GATE
+#include "gcc-generate-gimple-pass.h"
+
+static struct register_pass_info pass_info_mpxk_bnd_store = {
+	.pass				= make_mpxk_bnd_store_pass(),
+	.reference_pass_name		= "optimized",
+	.ref_pass_instance_number	= 1,
+	.pos_op				= PASS_POS_INSERT_BEFORE
+};
+
+struct register_pass_info *get_mpxk_bnd_store_pass_info(void)
+{
+	(void) gcc_version;
+	return &pass_info_mpxk_bnd_store;
+}
+
+static unsigned int mpxk_bnd_store_execute(void)
+{
+	basic_block bb, next;
+	gimple stmt;
+	gimple_stmt_iterator iter;
+	gcall *call;
+	tree fndecl;
+
+	if (skip_execute(BND_LEGACY))
+		return 0;
+
+	const char *name = DECL_NAME_POINTER(cfun->decl);
+
+	bb = ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb;
+	do {
+		next = bb->next_bb;
+		for (iter = gsi_start_bb(bb); !gsi_end_p(iter); ) {
+			stmt = gsi_stmt(iter);
+
+			switch (gimple_code(stmt)) {
+			case GIMPLE_CALL:
+				call = as_a<gcall *>(gsi_stmt(iter));
+				fndecl = gimple_call_fndecl(call);
+
+				/* Wrapper functions shouldn't end up here! */
+				gcc_assert(!mpxk_is_wrapper(name));
+
+				if (!fndecl)
+					break;
+
+				if (!strcmp(DECL_NAME_POINTER(fndecl),
+					    "__builtin_ia32_bndstx"))
+					handle_stx(&iter, call);
+				else if (!strcmp(DECL_NAME_POINTER(fndecl),
+						 "__builtin_ia32_bndldx"))
+					handle_ldx(&iter, call);
+
+				break;
+			default:
+				break;
+			}
+
+			gsi_next(&iter);
+		}
+		bb = next;
+	} while (bb);
+
+	return 0;
+}
+
+/**
+ * handle_stx - Remove bndstx statement at iterator.
+ * @gsi - Statement iterator.
+ * @call - The call to remove.
+ */
+static void handle_stx(gimple_stmt_iterator *gsi, gcall *call)
+{
+	dsay("removed bndstx call in at %s:%d\n",
+			gimple_filename(call), gimple_lineno(call));
+	gcc_assert(!strcmp(DECL_NAME_POINTER(gimple_call_fndecl(call)),
+				"__builtin_ia32_bndstx"));
+
+	/* Remove stmt and update iterator so next item is correct */
+	gsi_remove(gsi, true);
+	gsi_prev(gsi);
+
+	unlink_stmt_vdef(call);
+
+	mpxk_stats.dropped_stx++;
+}
+
+/**
+ * handle_ldx - Remove bndldx and replace it with MPXK bound load
+ * @gsi - Statement iterator.
+ * @call - The call to remove.
+ *
+ * We want to remove:
+ *    bounds = bndldx(orig_ptr)
+ * And insert:
+ *    tmp_ptr = load_bounds(orig_ptr)
+ *    bounds = bndret(tmp_ptr)
+ */
+static void handle_ldx(gimple_stmt_iterator *gsi, gcall *call)
+{
+	tree orig_ptr, bounds;
+
+	dsay("replaced bndldx call in at %s:%d",
+			gimple_filename(call), gimple_lineno(call));
+	gcc_assert(!strcmp(DECL_NAME_POINTER(gimple_call_fndecl(call)),
+				"__builtin_ia32_bndldx"));
+
+	/* Store what we need from the bndldx_call */
+	orig_ptr = gimple_call_arg(call, 1);
+	bounds = gimple_call_lhs(call);
+
+	/* Remove the bndldx call, which moves iterator to next stmt. */
+	gsi_remove(gsi, true);
+	unlink_stmt_vdef(call);
+
+	/* Now insert our own load bounds function */
+	insert_mpxk_bound_load(gsi, orig_ptr, bounds);
+
+	/* Make sure iterator points to last statement we worked on */
+	gsi_prev(gsi);
+
+	mpxk_stats.dropped_ldx++;
+}
diff --git a/scripts/gcc-plugins/mpxk_pass_cfun_args.c b/scripts/gcc-plugins/mpxk_pass_cfun_args.c
new file mode 100644
index 000000000000..4e14082114a2
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk_pass_cfun_args.c
@@ -0,0 +1,98 @@
+/*
+ * scripts/gcc-plugins/mpxk_pass_cfun_args.c - MPXK pass for cfun arguments
+ *
+ * Simple pass that only checks the current function (cfun) arguments for
+ * pointer bound counts that exceed the available bndreg count. Such bounds
+ * are then manually initialized at function start using the MPXK bound
+ * load function.
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+#include "mpxk.h"
+
+#include <ipa-chkp.h>
+#include <tree-chkp.h>
+
+static unsigned int mpxk_cfun_args_execute(void);
+
+#define PASS_NAME mpxk_cfun_args
+#define NO_GATE
+#include "gcc-generate-gimple-pass.h"
+
+static struct register_pass_info pass_info_mpxk_cfun_args = {
+	.pass				= make_mpxk_cfun_args_pass(),
+	.reference_pass_name		= "optimized",
+	.ref_pass_instance_number	= 1,
+	.pos_op				= PASS_POS_INSERT_BEFORE
+};
+
+struct register_pass_info *get_mpxk_cfun_args_pass_info(void)
+{
+	(void) gcc_version;
+	return &pass_info_mpxk_cfun_args;
+}
+
+static unsigned int mpxk_cfun_args_execute(void)
+{
+	int bound_count = 0;
+	int arg_count = 0;
+	basic_block bb = ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb;
+	gimple_stmt_iterator iter = gsi_start_bb(bb);
+	tree list = DECL_ARGUMENTS(cfun->decl);
+	tree prev = NULL;
+
+	if (skip_execute(BND_LEGACY))
+		return 0;
+
+	if (list == NULL || list_length(list) == 0)
+		return 0;
+
+	tree *p;
+
+	for (p = &list; *p; ) {
+		tree l = *p;
+
+		/* Keep count of the encountered bounds args */
+		if (TREE_TYPE(l) == pointer_bounds_type_node) {
+			bound_count++;
+
+			iter = gsi_start_bb(bb);
+
+			/* Replace BNDLDX loaded bounds with mpxk_load_bounds.
+			 *
+			 * This happens in two scenarios:
+			 * - There are more bounds than available registers (>4)
+			 * - The bounds are for arguments beyond the sixth
+			 *   argument, this is *feature* seems to be related to
+			 *   how non-bound arguments are treated (i.e. 6 args
+			 *   are passed via regs before using the stack for
+			 *   arguments).
+			 */
+			if (bound_count > MPXK_BND_REGS || arg_count > 6) {
+				dsay("resetting bound argument #%d (ptr > #6)",
+						bound_count);
+				gcc_assert(prev != NULL);
+				insert_mpxk_bound_load(&iter, prev, l);
+			}
+
+			p = &TREE_CHAIN(l);
+		} else {
+			dsay("skipping non-bound argument #%d", arg_count);
+			prev = l;
+			arg_count++;
+			p = &TREE_CHAIN(l);
+		}
+
+		/* The previous arg is needed if we need a MPXK load. */
+		*p = TREE_CHAIN(l);
+	}
+
+	bound_count = (bound_count <= MPXK_BND_REGS ? 0 :
+			(bound_count - MPXK_BND_REGS));
+
+	mpxk_stats.cfun_ldx += bound_count;
+	dsay("replaced %d bound args with mpkx_load_bounds", bound_count);
+	return 0;
+}
diff --git a/scripts/gcc-plugins/mpxk_pass_sweeper.c b/scripts/gcc-plugins/mpxk_pass_sweeper.c
new file mode 100644
index 000000000000..40b4cc6af072
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk_pass_sweeper.c
@@ -0,0 +1,107 @@
+/*
+ * scripts/gcc-plugins/mpxk_pass_sweeper.c - removes BND{STX,LDX}
+ *
+ * Brute force RTL pass that removes all BNDSTX/BNDLDX instructions.
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+#include "mpxk.h"
+#include <rtl.h>
+#include <print-rtl.h>
+
+static unsigned int mpxk_sweeper_execute(void);
+static bool contains_unspec(rtx pattern, const int code);
+
+#define PASS_NAME mpxk_sweeper
+#define NO_GATE
+#include "gcc-generate-rtl-pass.h"
+
+static struct register_pass_info pass_info_mpxk_sweeper = {
+	.pass				= make_mpxk_sweeper_pass(),
+	.reference_pass_name		= "final",
+	.ref_pass_instance_number	= 1,
+	.pos_op				= PASS_POS_INSERT_BEFORE
+};
+
+struct register_pass_info *get_mpxk_sweeper_pass_info(void)
+{
+	(void) gcc_version;
+	return &pass_info_mpxk_sweeper;
+}
+
+static unsigned int mpxk_sweeper_execute(void)
+{
+	expanded_location loc;
+	basic_block bb, next;
+	rtx_insn *insn;
+	rtx r;
+	int found = 0;
+
+	if (skip_execute(NULL))
+		return 0;
+
+	loc = expand_location(DECL_SOURCE_LOCATION(current_function_decl));
+
+	bb = ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb;
+	do {
+		next = bb->next_bb;
+		for (insn = BB_HEAD(bb);
+				insn != BB_END(bb);
+				insn = NEXT_INSN(insn)) {
+			r = PATTERN(insn);
+			if (INSN_LOCATION(insn) != UNKNOWN_LOCATION)
+				loc = insn_location(insn);
+
+			if (r != NULL) {
+				if (contains_unspec(r, UNSPEC_BNDSTX)) {
+					dsay("removed bndstx at %s:%d",
+							loc.file, loc.line);
+					delete_insn(insn);
+					mpxk_stats.sweep_stx++;
+					found++;
+				}
+				if (contains_unspec(r, UNSPEC_BNDLDX) ||
+				    contains_unspec(r, UNSPEC_BNDLDX_ADDR)) {
+					dsay("removed bndldx at %s:%d",
+							loc.file, loc.line);
+					delete_insn(insn);
+					mpxk_stats.sweep_ldx++;
+					found++;
+				}
+			}
+		}
+		bb = next;
+	} while (bb);
+
+	loc = expand_location(DECL_SOURCE_LOCATION(current_function_decl));
+	return 0;
+}
+
+static bool contains_unspec(rtx r, const int code)
+{
+	int i;
+
+	gcc_assert(r != NULL);
+
+	if (GET_CODE(r) == UNSPEC || GET_CODE(r) == UNSPEC_VOLATILE) {
+		if (XINT(r, 1) == code)
+			return true;
+	} else if (GET_CODE(r) == PARALLEL || GET_CODE(r) == SEQUENCE) {
+		for (i = 0; i < XVECLEN(r, 0); i++) {
+			if (contains_unspec(XVECEXP(r, 0, i), code))
+				return true;
+		}
+	} else if (GET_CODE(r) == UNSPEC || GET_CODE(r) == UNSPEC_VOLATILE) {
+		if (XINT(r, 1) == code)
+			return true;
+	} else if (GET_CODE(r) == SET) {
+		if (contains_unspec(SET_SRC(r), code))
+			return true;
+		if (contains_unspec(SET_DEST(r), code))
+			return true;
+	}
+
+	return false;
+}
diff --git a/scripts/gcc-plugins/mpxk_pass_wrappers.c b/scripts/gcc-plugins/mpxk_pass_wrappers.c
new file mode 100644
index 000000000000..ed9f02557c34
--- /dev/null
+++ b/scripts/gcc-plugins/mpxk_pass_wrappers.c
@@ -0,0 +1,128 @@
+/*
+ * scripts/gcc-plugins/mpxk_pass_wrappers.c - insert mpxk wrappers
+ *
+ * A pre-chkp pass that inserts MPXK wrappers for covered memory altering
+ * functions such as kmalloc & friends.
+ *
+ * Copyright (C) 2017 Aalto University
+ *
+ * This file is released under the GPLv2.
+ */
+#include "mpxk.h"
+#include <ipa-chkp.h>
+
+static unsigned int mpxk_wrappers_execute(void);
+static void mpxk_wrappers_gimple_call(gimple_stmt_iterator *gsi);
+
+#define PASS_NAME mpxk_wrappers
+#define NO_GATE
+#include "gcc-generate-gimple-pass.h"
+
+struct register_pass_info pass_info_mpxk_wrappers = {
+	.pass				= make_mpxk_wrappers_pass(),
+	.reference_pass_name		= "cfg",
+	.ref_pass_instance_number	= 1,
+	.pos_op				= PASS_POS_INSERT_AFTER
+};
+
+struct register_pass_info *get_mpxk_wrappers_pass_info(void)
+{
+	(void) gcc_version;
+	return &pass_info_mpxk_wrappers;
+}
+
+static unsigned int mpxk_wrappers_execute(void)
+{
+	tree fndecl;
+	basic_block bb, next;
+	gimple_stmt_iterator iter;
+	gimple stmt;
+
+	if (skip_execute(BND_LEGACY))
+		return 0;
+
+	/* Do not modify wrapper functions */
+	if (mpxk_is_wrapper(DECL_NAME_POINTER(cfun->decl)))
+		return 0;
+
+	bb = ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb;
+	do {
+		next = bb->next_bb;
+		for (iter = gsi_start_bb(bb); !gsi_end_p(iter); ) {
+			stmt = gsi_stmt(iter);
+
+			if (gimple_code(stmt) == GIMPLE_CALL) {
+				fndecl = gimple_call_fndecl(
+						as_a<gcall *>(stmt));
+
+				if (fndecl && mpxk_is_wrappable(
+						DECL_NAME_POINTER(fndecl))) {
+					dsay("inserting wrapper for %s",
+					     DECL_NAME_POINTER(fndecl));
+					mpxk_wrappers_gimple_call(&iter);
+				}
+			}
+
+			gsi_next(&iter);
+		}
+		bb = next;
+	} while (bb);
+
+	return 0;
+}
+
+/**
+ * mpxk_wrappers_gimple_call - Replace wrappables with wrappers.
+ * @param gsi
+ *
+ * Based on gcc/tree-chkp.c ~ chkp_add_bounds_to_call_stmt
+ */
+static void mpxk_wrappers_gimple_call(gimple_stmt_iterator *gsi)
+{
+	tree arg, type, new_decl, fndecl;
+	const char *new_name, *name;
+	gcall *call;
+
+	/* Get the current data */
+	call = as_a<gcall *>(gsi_stmt(*gsi));
+	fndecl = gimple_call_fndecl(call);
+	name = DECL_NAME_POINTER(fndecl);
+
+	/* Create data for new call */
+	new_decl = copy_node(fndecl);
+	new_name = mpxk_get_wrapper_name(name);
+	gcc_assert(new_name != NULL);
+
+	/* Set visibility. TODO: do we need this? */
+	DECL_VISIBILITY(new_decl) = VISIBILITY_DEFAULT;
+
+	/* Set wrapper name */
+	DECL_NAME(new_decl) = get_identifier(new_name);
+	SET_DECL_ASSEMBLER_NAME(new_decl, get_identifier(new_name));
+
+	/* Copy function arguments */
+	DECL_ARGUMENTS(new_decl) = copy_list(DECL_ARGUMENTS(fndecl));
+	for (arg = DECL_ARGUMENTS(new_decl); arg; arg = DECL_CHAIN(arg))
+		DECL_CONTEXT(arg) = new_decl;
+
+	/* Copy and modify function attributes */
+	DECL_ATTRIBUTES(new_decl) = remove_attribute("always_inline",
+			copy_list(DECL_ATTRIBUTES(fndecl)));
+
+	/* Mark the funciton external */
+	DECL_EXTERNAL(new_decl) = 1;
+
+	gimple_call_set_fndecl(call, new_decl);
+
+	/* TODO: Double check if manual fntype bounds add is needed. */
+	type = gimple_call_fntype(call);
+	type = chkp_copy_function_type_adding_bounds(type);
+	gimple_call_set_fntype(call, type);
+
+	update_stmt(call);
+
+	mpxk_stats.wrappers_added++;
+
+	dsay("inserted %s at %s:%d\n",
+			new_name, gimple_filename(call), gimple_lineno(call));
+}
-- 
2.11.0
