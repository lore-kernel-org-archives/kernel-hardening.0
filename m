Reply-To: kernel-hardening@lists.openwall.com
From: william.c.roberts@intel.com
Date: Wed,  5 Oct 2016 14:04:46 -0400
Message-Id: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] [PATCH] printk: introduce kptr_restrict level 3
To: kernel-hardening@lists.openwall.com
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, William Roberts <william.c.roberts@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: William Roberts <william.c.roberts@intel.com>

Some out-of-tree modules do not use %pK and just use %p, as it's
the common C paradigm for printing pointers. Because of this,
kptr_restrict has no affect on the output and thus, no way to
contain the kernel address leak.

Introduce kptr_restrict level 3 that causes the kernel to
treat %p as if it was %pK and thus always prints zeros.

Sample Output:
kptr_restrict == 2:
p: 00000000604369f4
pK: 0000000000000000

kptr_restrict == 3:
p: 0000000000000000
pK: 0000000000000000

Signed-off-by: William Roberts <william.c.roberts@intel.com>
---
 Documentation/sysctl/kernel.txt |   3 ++
 kernel/sysctl.c                 |   3 +-
 lib/vsprintf.c                  | 107 ++++++++++++++++++++++++----------------
 3 files changed, 69 insertions(+), 44 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index ffab8b5..bca72a0 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -393,6 +393,9 @@ values to unprivileged users is a concern.
 When kptr_restrict is set to (2), kernel pointers printed using
 %pK will be replaced with 0's regardless of privileges.
 
+When kptr_restrict is set to (3), kernel pointers printed using
+%p and %pK will be replaced with 0's regardless of privileges.
+
 ==============================================================
 
 kstack_depth_to_print: (X86 only)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a377bfa..0d4e4af 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -128,6 +128,7 @@ static unsigned long one_ul = 1;
 static int one_hundred = 100;
 static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
+static int three = 3;
 static int ten_thousand = 10000;
 #endif
 #ifdef CONFIG_PERF_EVENTS
@@ -847,7 +848,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 #endif
 	{
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0967771..371cfab 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1472,6 +1472,56 @@ char *flags_string(char *buf, char *end, void *flags_ptr, const char *fmt)
 
 int kptr_restrict __read_mostly;
 
+static inline void *cleanse_pointer(void *ptr, struct printf_spec spec,
+	char *buf, char *end, int default_width)
+{
+	switch (kptr_restrict) {
+	case 0:
+		/* Always print %p values */
+		break;
+	case 1: {
+		const struct cred *cred;
+
+		/*
+		 * kptr_restrict==1 cannot be used in IRQ context
+		 * because its test for CAP_SYSLOG would be meaningless.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi()) {
+			if (spec.field_width == -1)
+				spec.field_width = default_width;
+			return string(buf, end, "pK-error", spec);
+		}
+
+		/*
+		 * Only print the real pointer value if the current
+		 * process has CAP_SYSLOG and is running with the
+		 * same credentials it started with. This is because
+		 * access to files is checked at open() time, but %p
+		 * checks permission at read() time. We don't want to
+		 * leak pointer values if a binary opens a file using
+		 * %pK and then elevates privileges before reading it.
+		 */
+		cred = current_cred();
+		if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+		    !uid_eq(cred->euid, cred->uid) ||
+		    !gid_eq(cred->egid, cred->gid))
+			ptr = NULL;
+		break;
+	}
+	case 2: /* restrict only %pK */
+	case 3: /* restrict all non-extensioned %p and %pK */
+	default:
+		ptr = NULL;
+	break;
+	}
+	return ptr;
+}
+
+static inline int kptr_restrict_always_cleanse(void)
+{
+	return kptr_restrict == 3;
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1569,6 +1619,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: That for kptr_restrict set to 3, %p and %pK have the same
+ * meaning.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1576,7 +1629,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 {
 	const int default_width = 2 * sizeof(void *);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && !kptr_restrict_always_cleanse()) {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1657,48 +1710,6 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			va_end(va);
 			return buf;
 		}
-	case 'K':
-		switch (kptr_restrict) {
-		case 0:
-			/* Always print %pK values */
-			break;
-		case 1: {
-			const struct cred *cred;
-
-			/*
-			 * kptr_restrict==1 cannot be used in IRQ context
-			 * because its test for CAP_SYSLOG would be meaningless.
-			 */
-			if (in_irq() || in_serving_softirq() || in_nmi()) {
-				if (spec.field_width == -1)
-					spec.field_width = default_width;
-				return string(buf, end, "pK-error", spec);
-			}
-
-			/*
-			 * Only print the real pointer value if the current
-			 * process has CAP_SYSLOG and is running with the
-			 * same credentials it started with. This is because
-			 * access to files is checked at open() time, but %pK
-			 * checks permission at read() time. We don't want to
-			 * leak pointer values if a binary opens a file using
-			 * %pK and then elevates privileges before reading it.
-			 */
-			cred = current_cred();
-			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
-			    !uid_eq(cred->euid, cred->uid) ||
-			    !gid_eq(cred->egid, cred->gid))
-				ptr = NULL;
-			break;
-		}
-		case 2:
-		default:
-			/* Always print 0's for %pK */
-			ptr = NULL;
-			break;
-		}
-		break;
-
 	case 'N':
 		return netdev_bits(buf, end, ptr, fmt);
 	case 'a':
@@ -1718,6 +1729,16 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 
 	case 'G':
 		return flags_string(buf, end, ptr, fmt);
+	default:
+		/*
+		 * plain %p, no extension, check if we should always cleanse and
+		 * treat like %pK.
+		 */
+		if (!kptr_restrict_always_cleanse())
+			break;
+	case 'K':
+		/* always check whether or not to cleanse kernel addresses */
+		ptr = cleanse_pointer(ptr, spec, buf, end, default_width);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-- 
1.9.1
