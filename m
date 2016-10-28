Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 11:33:21 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20161028183321.GA41484@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [RFC v2 PATCH 13.2/13] lkdtm: add tests for atomic over-/underflow
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dwindsor@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds additional tests for the remaining atomic functions. Since the
bulk of the logic is identical, the functions are generated with macros.
Also adds debugfs entries for the manipulated atomic values, so that the
saturation values can be validated after a test is executed.

Based on work by Hans Liljestrand and AKASHI Takahiro.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Here's an updated version that does everything with macros and adds
Takahiro's debugfs idea.
---
 drivers/misc/lkdtm.h      |  44 ++++++++++++++--
 drivers/misc/lkdtm_bugs.c | 128 +++++++++++++++++++++++++++++++++++-----------
 drivers/misc/lkdtm_core.c |  20 +++++---
 3 files changed, 152 insertions(+), 40 deletions(-)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index fdf954c2107f..4eba6135394c 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -3,10 +3,49 @@
 
 #define pr_fmt(fmt) "lkdtm: " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 
+/*
+ * Handle the various atomic function prototypes (potentially ignoring
+ * return values).
+ */
+#define ATOMIC_ARG_X(func, x)		func(x)
+#define ATOMIC_ARG_1_X(func, x)		func(1, x)
+#define ATOMIC_RET_ARG_X(func, x)	if (func(x)) ;
+#define ATOMIC_RET_ARG_1_X(func, x)	if (func(1, x)) ;
+#define ATOMIC_RET_ARG_X_1_0(func, x)	if (func(x, 1, 0)) ;
+
+/* The list of all tested atomic operations. */
+#define LKDTM_ATOMIC_OPERATIONS(macro)					\
+	macro(UNDERFLOW, dec,		ATOMIC_ARG_X)			\
+	macro(UNDERFLOW, dec_return,	ATOMIC_RET_ARG_X)		\
+	macro(UNDERFLOW, sub,		ATOMIC_ARG_1_X)			\
+	macro(UNDERFLOW, sub_return,	ATOMIC_RET_ARG_1_X)		\
+	macro(UNDERFLOW, sub_and_test,	ATOMIC_RET_ARG_1_X)		\
+	macro(OVERFLOW,  inc,		ATOMIC_ARG_X)			\
+	macro(OVERFLOW,  inc_return,	ATOMIC_RET_ARG_X)		\
+	macro(OVERFLOW,  add,		ATOMIC_ARG_1_X)			\
+	macro(OVERFLOW,  add_return,	ATOMIC_RET_ARG_1_X)		\
+	macro(OVERFLOW,  add_unless,	ATOMIC_RET_ARG_X_1_0)		\
+	macro(OVERFLOW,  inc_and_test,	ATOMIC_RET_ARG_X)
+
+/* The list of all tested atomic types. */
+#define LKDTM_ATOMIC_TYPES(macro, name, operation)			\
+	macro(name,	atomic,		operation)			\
+	macro(name,	atomic_long,	operation)			\
+	macro(name,	local,		operation)			\
+	macro(name,	atomic64,	operation)
+
+/* Generate function prototypes for all atomic operation/type combinations. */
+#define LKDTM_ATOMIC_FUNCDECL(name, atomic_type, operation)		\
+	void lkdtm_##name##_##atomic_type##_##operation(void);
+
+#define LKDTM_ATOMIC_FUNCDECLS(name, operation, ignored)		\
+	LKDTM_ATOMIC_TYPES(LKDTM_ATOMIC_FUNCDECL, name, operation)
+
 /* lkdtm_bugs.c */
-void __init lkdtm_bugs_init(int *recur_param);
+void __init lkdtm_bugs_init(int *recur_param, struct dentry *parent);
 void lkdtm_PANIC(void);
 void lkdtm_BUG(void);
 void lkdtm_WARNING(void);
@@ -19,8 +58,7 @@ void lkdtm_SOFTLOCKUP(void);
 void lkdtm_HARDLOCKUP(void);
 void lkdtm_SPINLOCKUP(void);
 void lkdtm_HUNG_TASK(void);
-void lkdtm_ATOMIC_UNDERFLOW(void);
-void lkdtm_ATOMIC_OVERFLOW(void);
+LKDTM_ATOMIC_OPERATIONS(LKDTM_ATOMIC_FUNCDECLS);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index 182ae1894b32..39cbd0effcf2 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -5,7 +5,9 @@
  * test source files.
  */
 #include "lkdtm.h"
+#include <linux/debugfs.h>
 #include <linux/sched.h>
+#include <asm/local.h>
 
 /*
  * Make sure our attempts to over run the kernel stack doesn't trigger
@@ -35,15 +37,6 @@ static int recursive_loop(int remaining)
 		return recursive_loop(remaining - 1);
 }
 
-/* If the depth is negative, use the default, otherwise keep parameter. */
-void __init lkdtm_bugs_init(int *recur_param)
-{
-	if (*recur_param < 0)
-		*recur_param = recur_count;
-	else
-		recur_count = *recur_param;
-}
-
 void lkdtm_PANIC(void)
 {
 	panic("dumptest");
@@ -123,26 +116,101 @@ void lkdtm_HUNG_TASK(void)
 	schedule();
 }
 
-void lkdtm_ATOMIC_UNDERFLOW(void)
-{
-	atomic_t under = ATOMIC_INIT(INT_MIN);
-
-	pr_info("attempting good atomic increment\n");
-	atomic_inc(&under);
-	atomic_dec(&under);
-
-	pr_info("attempting bad atomic underflow\n");
-	atomic_dec(&under);
-}
-
-void lkdtm_ATOMIC_OVERFLOW(void)
-{
-	atomic_t over = ATOMIC_INIT(INT_MAX);
-
-	pr_info("attempting good atomic decrement\n");
-	atomic_dec(&over);
-	atomic_inc(&over);
+#define GENERATE_LKDTM_ATOMIC_TYPE(ignore1, atomic_name, ignore2)	\
+									\
+static atomic_name##_t atomic_name##_var;				\
+									\
+static int debugfs_##atomic_name##_get(void *data, u64 *val)		\
+{									\
+	*val = atomic_name##_read((atomic_name##_t *)data);		\
+	return 0;							\
+}									\
+									\
+DEFINE_DEBUGFS_ATTRIBUTE(fops_##atomic_name,				\
+			 debugfs_##atomic_name##_get,			\
+			 NULL, "%lld\n");				\
+									\
+static struct dentry *debugfs_create_##atomic_name(const char *item,	\
+				umode_t mode,				\
+				struct dentry *parent,			\
+				atomic_name##_t *value)			\
+{									\
+	return debugfs_create_file_unsafe(item, mode, parent, value,	\
+					&fops_##atomic_name);		\
+}
+
+LKDTM_ATOMIC_TYPES(GENERATE_LKDTM_ATOMIC_TYPE, 0, 0)
+
+#define ATOMIC_TEST(name, atomic_name, init_func, start, safe_func,	\
+		    test_func_proto, testfunc)				\
+									\
+void lkdtm_##name##_##testfunc(void)					\
+{									\
+	atomic_name##_set(&atomic_name##_var, start);			\
+									\
+	pr_info("attempting good " #testfunc "\n");			\
+	safe_func(&atomic_name##_var);					\
+	test_func_proto(testfunc, &atomic_name##_var);			\
+									\
+	pr_info("attempting bad " #testfunc "\n");			\
+	test_func_proto(testfunc, &atomic_name##_var);			\
+}
+
+/* Declare underflow test functions for atomic_t and atomic_long_t types. */
+#define LKDTM_ATOMIC_UNDERFLOW(operation, test_func_proto)		\
+	ATOMIC_TEST(UNDERFLOW, atomic, ATOMIC_INIT, INT_MIN,		\
+		    atomic_inc, test_func_proto, atomic_##operation)	\
+	ATOMIC_TEST(UNDERFLOW, atomic_long, ATOMIC_LONG_INIT,		\
+		    LONG_MIN, atomic_long_inc, test_func_proto,		\
+		    atomic_long_##operation)				\
+	ATOMIC_TEST(UNDERFLOW, atomic64, ATOMIC64_INIT,			\
+		    S64_MIN, atomic64_inc, test_func_proto,		\
+		    atomic64_##operation)				\
+	ATOMIC_TEST(UNDERFLOW, local, LOCAL_INIT,			\
+		    LONG_MIN, local_inc, test_func_proto,		\
+		    local_##operation)
+
+/* Declare overflow test functions for atomic_t and atomic_long_t types. */
+#define LKDTM_ATOMIC_OVERFLOW(operation, test_func_proto)		\
+	ATOMIC_TEST(OVERFLOW, atomic, ATOMIC_INIT, INT_MAX,		\
+		    atomic_dec, test_func_proto, atomic_##operation)	\
+	ATOMIC_TEST(OVERFLOW, atomic_long, ATOMIC_LONG_INIT,		\
+		    LONG_MAX, atomic_long_dec, test_func_proto,		\
+		    atomic_long_##operation)				\
+	ATOMIC_TEST(OVERFLOW, atomic64, ATOMIC64_INIT,			\
+		    S64_MAX, atomic64_dec, test_func_proto,		\
+		    atomic64_##operation)				\
+	ATOMIC_TEST(OVERFLOW, local, LOCAL_INIT,			\
+		    LONG_MAX, local_dec, test_func_proto,		\
+		    local_##operation)
+
+#define GENERATE_LKDTM_ATOMIC_TEST(name, operation, test_func_proto)	\
+	LKDTM_ATOMIC_##name(operation, test_func_proto)
+
+LKDTM_ATOMIC_OPERATIONS(GENERATE_LKDTM_ATOMIC_TEST)
+
+#define GENERATE_LKDTM_ATOMIC_DEBUGFS(ignore1, atomic_name, ignore2)	\
+	de = debugfs_create_##atomic_name(#atomic_name, 0644,		\
+					  atomic_dir,			\
+					  &atomic_name##_var);		\
+	if (de == NULL)							\
+		pr_err("could not create " #atomic_name " in debugfs\n");
+
+void __init lkdtm_bugs_init(int *recur_param, struct dentry *parent)
+{
+	struct dentry *atomic_dir, *de;
+
+	/* If the depth is negative, use default, otherwise keep parameter. */
+	if (*recur_param < 0)
+		*recur_param = recur_count;
+	else
+		recur_count = *recur_param;
 
-	pr_info("attempting bad atomic overflow\n");
-	atomic_inc(&over);
+	/* Don't treat failures to create the atomic value tree as fatal. */
+	atomic_dir = debugfs_create_dir("atomic", parent);
+	if (atomic_dir) {
+		LKDTM_ATOMIC_TYPES(GENERATE_LKDTM_ATOMIC_DEBUGFS, 0, 0);
+	} else {
+		pr_err("creating atomic dir failed\n");
+	}
 }
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index f9154b8d67f6..defa1af01e52 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -189,6 +189,13 @@ struct crashtype {
 		.func = lkdtm_ ## _name,	\
 	}
 
+/* Generate crashtype entries for all atomic operation/type combinations. */
+#define CRASHTYPE_ATOMIC(name, atomic_name, operation)		\
+	CRASHTYPE(name##_##atomic_name##_##operation),		\
+
+#define CRASHTYPE_ATOMICS(name, operation, ignored)		\
+	LKDTM_ATOMIC_TYPES(CRASHTYPE_ATOMIC, name, operation)
+
 /* Define the possible types of crashes that can be triggered. */
 struct crashtype crashtypes[] = {
 	CRASHTYPE(PANIC),
@@ -218,8 +225,6 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(WRITE_RO),
 	CRASHTYPE(WRITE_RO_AFTER_INIT),
 	CRASHTYPE(WRITE_KERN),
-	CRASHTYPE(ATOMIC_UNDERFLOW),
-	CRASHTYPE(ATOMIC_OVERFLOW),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_TO),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_FROM),
 	CRASHTYPE(USERCOPY_HEAP_FLAG_TO),
@@ -228,6 +233,7 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_STACK_FRAME_FROM),
 	CRASHTYPE(USERCOPY_STACK_BEYOND),
 	CRASHTYPE(USERCOPY_KERNEL),
+	LKDTM_ATOMIC_OPERATIONS(CRASHTYPE_ATOMICS)
 };
 
 
@@ -481,11 +487,6 @@ static int __init lkdtm_module_init(void)
 	crash_count = cpoint_count;
 #endif
 
-	/* Handle test-specific initialization. */
-	lkdtm_bugs_init(&recur_count);
-	lkdtm_perms_init();
-	lkdtm_usercopy_init();
-
 	/* Register debugfs interface */
 	lkdtm_debugfs_root = debugfs_create_dir("provoke-crash", NULL);
 	if (!lkdtm_debugfs_root) {
@@ -493,6 +494,11 @@ static int __init lkdtm_module_init(void)
 		return -ENODEV;
 	}
 
+	/* Handle test-specific initialization. */
+	lkdtm_bugs_init(&recur_count, lkdtm_debugfs_root);
+	lkdtm_perms_init();
+	lkdtm_usercopy_init();
+
 	/* Install debugfs trigger files. */
 	for (i = 0; i < ARRAY_SIZE(crashpoints); i++) {
 		struct crashpoint *cur = &crashpoints[i];
-- 
2.7.4


-- 
Kees Cook
Nexus Security
