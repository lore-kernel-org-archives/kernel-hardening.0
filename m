Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Wed, 26 Oct 2016 07:29:58 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
References: <20161025204303.GA36052@beast>
In-Reply-To: <20161025204303.GA36052@beast>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC v2 PATCH 13.1/13] lkdtm: add tests for atomic
 over-/underflow
To: Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
Cc: David Windsor <dwindsor@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Thank you Kees! I applied the commit to our hardened_atomic_on_next branch =
and it will be included into the next rfc.=20

-----Original Message-----
From: Kees Cook [mailto:keescook@chromium.org]=20
Sent: Tuesday, October 25, 2016 11:43 PM
To: Hans Liljestrand <ishkamiel@gmail.com>
Cc: Reshetova, Elena <elena.reshetova@intel.com>; David Windsor <dwindsor@g=
mail.com>; kernel-hardening@lists.openwall.com
Subject: [RFC v2 PATCH 13.1/13] lkdtm: add tests for atomic over-/underflow

This adds additional tests for the remaining atomic functions. Since the bu=
lk of the logic is identical, the functions are generated with macros.
Based on work by Hans Liljestrand.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is a replacement for the 13/13 patch, using macros more extensively an=
d also ignores return values to avoid "calculated but unused" warnings.
---
 drivers/misc/lkdtm.h      | 24 +++++++++++++--
 drivers/misc/lkdtm_bugs.c | 74 ++++++++++++++++++++++++++++++++-----------=
----
 drivers/misc/lkdtm_core.c | 24 +++++++++++++--
 3 files changed, 95 insertions(+), 27 deletions(-)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h index fdf954c2107f=
..62a29b9cd767 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -19,8 +19,28 @@ void lkdtm_SOFTLOCKUP(void);  void lkdtm_HARDLOCKUP(void=
);  void lkdtm_SPINLOCKUP(void);  void lkdtm_HUNG_TASK(void); -void lkdtm_A=
TOMIC_UNDERFLOW(void); -void lkdtm_ATOMIC_OVERFLOW(void);
+void lkdtm_OVERFLOW_atomic_inc(void);
+void lkdtm_OVERFLOW_atomic_inc_return(void);
+void lkdtm_OVERFLOW_atomic_inc_and_test(void);
+void lkdtm_OVERFLOW_atomic_add(void);
+void lkdtm_OVERFLOW_atomic_add_return(void);
+void lkdtm_OVERFLOW_atomic_add_unless(void);
+void lkdtm_OVERFLOW_atomic_long_inc(void);
+void lkdtm_OVERFLOW_atomic_long_inc_return(void);
+void lkdtm_OVERFLOW_atomic_long_inc_and_test(void);
+void lkdtm_OVERFLOW_atomic_long_add(void);
+void lkdtm_OVERFLOW_atomic_long_add_return(void);
+void lkdtm_OVERFLOW_atomic_long_add_unless(void);
+void lkdtm_UNDERFLOW_atomic_dec(void);
+void lkdtm_UNDERFLOW_atomic_dec_return(void);
+void lkdtm_UNDERFLOW_atomic_sub(void);
+void lkdtm_UNDERFLOW_atomic_sub_return(void);
+void lkdtm_UNDERFLOW_atomic_sub_and_test(void);
+void lkdtm_UNDERFLOW_atomic_long_dec(void);
+void lkdtm_UNDERFLOW_atomic_long_dec_return(void);
+void lkdtm_UNDERFLOW_atomic_long_sub(void);
+void lkdtm_UNDERFLOW_atomic_long_sub_return(void);
+void lkdtm_UNDERFLOW_atomic_long_sub_and_test(void);
=20
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c index 18=
2ae1894b32..2473bd275a87 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -123,26 +123,54 @@ void lkdtm_HUNG_TASK(void)
 	schedule();
 }
=20
-void lkdtm_ATOMIC_UNDERFLOW(void)
-{
-	atomic_t under =3D ATOMIC_INIT(INT_MIN);
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
-	atomic_t over =3D ATOMIC_INIT(INT_MAX);
-
-	pr_info("attempting good atomic decrement\n");
-	atomic_dec(&over);
-	atomic_inc(&over);
-
-	pr_info("attempting bad atomic overflow\n");
-	atomic_inc(&over);
-}
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
+#define ATOMIC_ANY(name, atomic_type, init_func, start, safe_func,	\
+		   test_func_proto, testfunc)				\
+void lkdtm_##name##_##testfunc(void)					\
+{									\
+	atomic_type atomic =3D init_func(start);				\
+									\
+	pr_info("attempting good " #testfunc "\n");			\
+	safe_func(&atomic);						\
+	test_func_proto(testfunc, &atomic);				\
+									\
+	pr_info("attempting bad " #testfunc "\n");			\
+	test_func_proto(testfunc, &atomic);				\
+}
+
+/* Declare underflow test functions for atomic_t and atomic_long_t types. =
*/
+#define LKDTM_ATOMIC_UNDERFLOW(operation, test_func_proto)		\
+	ATOMIC_ANY(UNDERFLOW, atomic_t, ATOMIC_INIT, INT_MIN,		\
+		   atomic_inc, test_func_proto, atomic_##operation)	\
+	ATOMIC_ANY(UNDERFLOW, atomic_long_t, ATOMIC_LONG_INIT,		\
+		   LONG_MIN, atomic_long_inc, test_func_proto,		\
+		   atomic_long_##operation)
+
+/* Declare overflow test functions for atomic_t and atomic_long_t types. *=
/
+#define LKDTM_ATOMIC_OVERFLOW(operation, test_func_proto)		\
+	ATOMIC_ANY(OVERFLOW, atomic_t, ATOMIC_INIT, INT_MAX,		\
+		   atomic_dec, test_func_proto, atomic_##operation)	\
+	ATOMIC_ANY(OVERFLOW, atomic_long_t, ATOMIC_LONG_INIT,		\
+		   LONG_MAX, atomic_long_dec, test_func_proto,		\
+		   atomic_long_##operation)
+
+LKDTM_ATOMIC_UNDERFLOW(dec,		ATOMIC_ARG_X)
+LKDTM_ATOMIC_UNDERFLOW(dec_return,	ATOMIC_RET_ARG_X)
+LKDTM_ATOMIC_UNDERFLOW(sub,		ATOMIC_ARG_1_X)
+LKDTM_ATOMIC_UNDERFLOW(sub_return,	ATOMIC_RET_ARG_1_X)
+LKDTM_ATOMIC_UNDERFLOW(sub_and_test,	ATOMIC_RET_ARG_1_X)
+LKDTM_ATOMIC_OVERFLOW(inc,		ATOMIC_ARG_X)
+LKDTM_ATOMIC_OVERFLOW(inc_return,	ATOMIC_RET_ARG_X)
+LKDTM_ATOMIC_OVERFLOW(add,		ATOMIC_ARG_1_X)
+LKDTM_ATOMIC_OVERFLOW(add_return,	ATOMIC_RET_ARG_1_X)
+LKDTM_ATOMIC_OVERFLOW(add_unless,	ATOMIC_RET_ARG_X_1_0)
+LKDTM_ATOMIC_OVERFLOW(inc_and_test,	ATOMIC_RET_ARG_X)
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c index f9=
154b8d67f6..05b097f02ce4 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -218,8 +218,28 @@ struct crashtype crashtypes[] =3D {
 	CRASHTYPE(WRITE_RO),
 	CRASHTYPE(WRITE_RO_AFTER_INIT),
 	CRASHTYPE(WRITE_KERN),
-	CRASHTYPE(ATOMIC_UNDERFLOW),
-	CRASHTYPE(ATOMIC_OVERFLOW),
+	CRASHTYPE(OVERFLOW_atomic_inc),
+	CRASHTYPE(OVERFLOW_atomic_inc_return),
+	CRASHTYPE(OVERFLOW_atomic_inc_and_test),
+	CRASHTYPE(OVERFLOW_atomic_add),
+	CRASHTYPE(OVERFLOW_atomic_add_return),
+	CRASHTYPE(OVERFLOW_atomic_add_unless),
+	CRASHTYPE(OVERFLOW_atomic_long_inc),
+	CRASHTYPE(OVERFLOW_atomic_long_inc_return),
+	CRASHTYPE(OVERFLOW_atomic_long_inc_and_test),
+	CRASHTYPE(OVERFLOW_atomic_long_add),
+	CRASHTYPE(OVERFLOW_atomic_long_add_return),
+	CRASHTYPE(OVERFLOW_atomic_long_add_unless),
+	CRASHTYPE(UNDERFLOW_atomic_dec),
+	CRASHTYPE(UNDERFLOW_atomic_dec_return),
+	CRASHTYPE(UNDERFLOW_atomic_sub),
+	CRASHTYPE(UNDERFLOW_atomic_sub_return),
+	CRASHTYPE(UNDERFLOW_atomic_sub_and_test),
+	CRASHTYPE(UNDERFLOW_atomic_long_dec),
+	CRASHTYPE(UNDERFLOW_atomic_long_dec_return),
+	CRASHTYPE(UNDERFLOW_atomic_long_sub),
+	CRASHTYPE(UNDERFLOW_atomic_long_sub_return),
+	CRASHTYPE(UNDERFLOW_atomic_long_sub_and_test),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_TO),
 	CRASHTYPE(USERCOPY_HEAP_SIZE_FROM),
 	CRASHTYPE(USERCOPY_HEAP_FLAG_TO),
--
2.7.4


--=20
Kees Cook
Nexus Security
