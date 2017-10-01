From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:45 +1100
Message-Id: <1506816410-10230-2-git-send-email-me@tobin.cc>
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 1/6] lib: vsprintf: additional kernel pointer filtering options
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add the kptr_restrict setting of 3 which results in both
%p and %pK values being replaced by zeros.

Add an additional %pP value inspired by the Grsecurity
option which explicitly whitelists pointers for output.

Amend scripts/checkpatch.pl to handle %pP.

This patch is based on work by William Roberts
<william.c.roberts@intel.com>

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/printk-formats.txt |  8 +++++
 Documentation/sysctl/kernel.txt  |  4 +++
 kernel/sysctl.c                  |  3 +-
 lib/vsprintf.c                   | 78 ++++++++++++++++++++++++++--------------
 scripts/checkpatch.pl            |  2 +-
 5 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 361789d..16c9abc 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -97,6 +97,14 @@ For printing kernel pointers which should be hidden from unprivileged
 users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
 Documentation/sysctl/kernel.txt for more details.
 
+::
+
+        %pP     0x01234567 or 0x0123456789abcdef
+
+For printing kernel pointers which should always be shown, even to
+unprivileged users.
+
+
 Struct Resources
 ================
 
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 694968c..7ee183af 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -394,6 +394,10 @@ values to unprivileged users is a concern.
 When kptr_restrict is set to (2), kernel pointers printed using
 %pK will be replaced with 0's regardless of privileges.
 
+When kptr_restrict is set to (3), kernel pointers printed using
+%p and %pK will be replaced with 0's regardless of privileges,
+however kernel pointers printed using %pP will continue to be printed.
+
 ==============================================================
 
 l2cr: (PPC only)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6648fbb..37ba637 100644
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
@@ -851,7 +852,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
-		.extra2		= &two,
+		.extra2		= &three,
 	},
 #endif
 	{
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385..e6eace0 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -396,6 +396,16 @@ struct printf_spec {
 #define FIELD_WIDTH_MAX ((1 << 23) - 1)
 #define PRECISION_MAX ((1 << 15) - 1)
 
+int kptr_restrict __read_mostly;
+
+/*
+ * return non-zero if we should cleanse pointers for %p and %pK specifiers.
+ */
+static inline int kptr_restrict_cleanse_kernel_pointers(void)
+{
+	return kptr_restrict >= 3;
+}
+
 static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
@@ -1591,8 +1601,6 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
-int kptr_restrict __read_mostly;
-
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1664,6 +1672,7 @@ int kptr_restrict __read_mostly;
  *       Do not use this feature without some mechanism to verify the
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
+ * - 'P' For a kernel pointer that should be shown to all users
  * - 'NF' For a netdev_features_t
  * - 'h[CDN]' For a variable-length buffer, it prints it as a hex string with
  *            a certain separator (' ' by default):
@@ -1703,6 +1712,8 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: That for kptr_restrict set to 3, %p and %pK have the same meaning.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1710,7 +1721,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 {
 	const int default_width = 2 * sizeof(void *);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && !kptr_restrict_cleanse_kernel_pointers()) {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1791,6 +1802,31 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
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
+		 * An explicitly whitelisted kernel pointer should never be
+		 * cleansed
+		 */
+		break;
 	case 'K':
 		switch (kptr_restrict) {
 		case 0:
@@ -1825,39 +1861,27 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 				ptr = NULL;
 			break;
 		}
-		case 2:
+		case 2: /* cleanse %pK for kptr_restrict >= 2 */
 		default:
-			/* Always print 0's for %pK */
 			ptr = NULL;
 			break;
 		}
-		break;
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
+		break; /* case 'K' */
 	case 'O':
 		switch (fmt[1]) {
 		case 'F':
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
+		/* fall through */
+	default:
+		/*
+		 * Plain pointers (%p) are always cleansed in higher restriction
+		 * levels.
+		 */
+		if (kptr_restrict >= 3)
+			ptr = NULL;
 	}
+
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
 		spec.field_width = default_width;
@@ -1865,7 +1889,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	return number(buf, end, (unsigned long long) ptr, spec);
 }
 
 /*
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dd2c262..eabc56c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5762,7 +5762,7 @@ sub process {
 		        for (my $count = $linenr; $count <= $lc; $count++) {
 				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
 				$fmt =~ s/%%//g;
-				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNO]).)/) {
+				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNOP]).)/) {
 					$bad_extension = $1;
 					last;
 				}
-- 
2.7.4
