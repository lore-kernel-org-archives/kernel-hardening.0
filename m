Date: Fri, 5 May 2017 21:06:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040656.GB32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040641.GA32707@kroah.com>
Subject: [kernel-hardening] [RFC 1/6] lib: vsprintf: additional kernel pointer filtering options
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dave Weinstein <olorin@google.com>

Add the kptr_restrict setting of 3 which results in both
%p and %pK values being replaced by zeros.

Add an additional %pP value inspired by the Grsecurity
option which explicitly whitelists pointers for output.

This patch is based on work by William Roberts
<william.c.roberts@intel.com>

Cc: William Roberts <william.c.roberts@intel.com>
Cc: Chris Fries <cfries@google.com>
Signed-off-by: Dave Weinstein <olorin@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/printk-formats.txt |  5 +++
 Documentation/sysctl/kernel.txt  |  3 ++
 kernel/sysctl.c                  |  3 +-
 lib/vsprintf.c                   | 81 ++++++++++++++++++++++++++--------------
 4 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 5962949944fd..8994c65aa3b0 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -64,6 +64,11 @@ Kernel Pointers:
 	users. The behaviour of %pK depends on the kptr_restrict sysctl - see
 	Documentation/sysctl/kernel.txt for more details.
 
+	%pP     0x01234567 or 0x0123456789abcdef
+
+	For printing kernel pointers which should always be shown, even to
+	unprivileged users.
+
 Struct Resources:
 
 	%pr	[mem 0x60000000-0x6fffffff flags 0x2200] or
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index bac23c198360..c9f5da409868 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -392,6 +392,9 @@ values to unprivileged users is a concern.
 When kptr_restrict is set to (2), kernel pointers printed using
 %pK will be replaced with 0's regardless of privileges.
 
+When kptr_restrict is set to (3), kernel pointers printed using
+%p and %pK will be replaced with 0's regardless of privileges.
+
 ==============================================================
 
 l2cr: (PPC only)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8c8714fcb53c..1bfdd262c66a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -129,6 +129,7 @@ static unsigned long one_ul = 1;
 static int one_hundred = 100;
 static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
+static int three = 3;
 static int ten_thousand = 10000;
 #endif
 #ifdef CONFIG_PERF_EVENTS
@@ -830,7 +831,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 #endif
 	{
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e3bf4e0f10b5..f4e11dade1ab 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -395,6 +395,16 @@ struct printf_spec {
 #define FIELD_WIDTH_MAX ((1 << 23) - 1)
 #define PRECISION_MAX ((1 << 15) - 1)
 
+int kptr_restrict __read_mostly;
+
+/*
+ * Always cleanse %p and %pK specifiers
+ */
+static inline int kptr_restrict_always_cleanse_pointers(void)
+{
+	return kptr_restrict >= 3;
+}
+
 static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
@@ -1470,8 +1480,6 @@ char *flags_string(char *buf, char *end, void *flags_ptr, const char *fmt)
 	return format_flags(buf, end, flags, names);
 }
 
-int kptr_restrict __read_mostly;
-
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1540,6 +1548,7 @@ int kptr_restrict __read_mostly;
  *       Do not use this feature without some mechanism to verify the
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
+ * - 'P' For a kernel pointer that should be shown to all users
  * - 'NF' For a netdev_features_t
  * - 'h[CDN]' For a variable-length buffer, it prints it as a hex string with
  *            a certain separator (' ' by default):
@@ -1569,6 +1578,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: That for kptr_restrict set to 3, %p and %pK have the same
+ * meaning.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1576,7 +1588,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 {
 	const int default_width = 2 * sizeof(void *);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && !kptr_restrict_always_cleanse_pointers()) {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1657,10 +1669,43 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			va_end(va);
 			return buf;
 		}
+	case 'N':
+		return netdev_bits(buf, end, ptr, fmt);
+	case 'a':
+		return address_val(buf, end, ptr, fmt);
+	case 'd':
+		return dentry_name(buf, end, ptr, spec, fmt);
+	case 'C':
+		return clock(buf, end, ptr, spec, fmt);
+	case 'D':
+		return dentry_name(buf, end,
+				   ((const struct file *)ptr)->f_path.dentry,
+				   spec, fmt);
+#ifdef CONFIG_BLOCK
+	case 'g':
+		return bdev_name(buf, end, ptr, spec, fmt);
+#endif
+
+	case 'G':
+		return flags_string(buf, end, ptr, fmt);
+	case 'P':
+		/*
+		 * an explicitly whitelisted kernel pointer should never be
+		 * cleansed
+		 */
+		break;
+	default:
+		/*
+		 * plain %p, no extension, check if we should always cleanse and
+		 * treat like %pK.
+		 */
+		if (!kptr_restrict_always_cleanse_pointers())
+			break;
+		/* fallthrough */
 	case 'K':
 		switch (kptr_restrict) {
 		case 0:
-			/* Always print %pK values */
+			/* Always print %p values */
 			break;
 		case 1: {
 			const struct cred *cred;
@@ -1679,7 +1724,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			 * Only print the real pointer value if the current
 			 * process has CAP_SYSLOG and is running with the
 			 * same credentials it started with. This is because
-			 * access to files is checked at open() time, but %pK
+			 * access to files is checked at open() time, but %p
 			 * checks permission at read() time. We don't want to
 			 * leak pointer values if a binary opens a file using
 			 * %pK and then elevates privileges before reading it.
@@ -1691,33 +1736,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 				ptr = NULL;
 			break;
 		}
-		case 2:
+		case 2: /* restrict only %pK */
+		case 3: /* restrict all non-extensioned %p and %pK */
 		default:
-			/* Always print 0's for %pK */
 			ptr = NULL;
 			break;
 		}
 		break;
-
-	case 'N':
-		return netdev_bits(buf, end, ptr, fmt);
-	case 'a':
-		return address_val(buf, end, ptr, fmt);
-	case 'd':
-		return dentry_name(buf, end, ptr, spec, fmt);
-	case 'C':
-		return clock(buf, end, ptr, spec, fmt);
-	case 'D':
-		return dentry_name(buf, end,
-				   ((const struct file *)ptr)->f_path.dentry,
-				   spec, fmt);
-#ifdef CONFIG_BLOCK
-	case 'g':
-		return bdev_name(buf, end, ptr, spec, fmt);
-#endif
-
-	case 'G':
-		return flags_string(buf, end, ptr, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1726,7 +1751,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	return number(buf, end, (unsigned long long) ptr, spec);
 }
 
 /*
-- 
2.12.2
