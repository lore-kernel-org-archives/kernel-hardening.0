From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:47 +1100
Message-Id: <1506816410-10230-4-git-send-email-me@tobin.cc>
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 3/6] lib: vsprintf: physical address kernel pointer filtering options
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add the kptr_restrict setting of 4 which results in %pa and
%p[rR] values being cleansed.

Address types printed with %pa are replaced by zeros. Resources printed
with %p[rR] have the starting address replaced by zeros, resource size
is still shown.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/sysctl/kernel.txt |  5 +++++
 kernel/sysctl.c                 |  3 +--
 lib/vsprintf.c                  | 31 +++++++++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 7ee183af..b6d45bc 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -398,6 +398,11 @@ When kptr_restrict is set to (3), kernel pointers printed using
 %p and %pK will be replaced with 0's regardless of privileges,
 however kernel pointers printed using %pP will continue to be printed.
 
+When kptr_restrict is set to (4), kernel pointers printed with
+%p, %pK, %pa, and %p[rR] will be replaced with 0's regardless of
+privileges. Kernel pointers printed using %pP will continue to be
+printed.
+
 ==============================================================
 
 l2cr: (PPC only)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 37ba637..f777b32 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -129,7 +129,6 @@ static unsigned long one_ul = 1;
 static int one_hundred = 100;
 static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
-static int three = 3;
 static int ten_thousand = 10000;
 #endif
 #ifdef CONFIG_PERF_EVENTS
@@ -852,7 +851,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
-		.extra2		= &three,
+		.extra2		= &four,
 	},
 #endif
 	{
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index e6eace0..0271223 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -406,6 +406,22 @@ static inline int kptr_restrict_cleanse_kernel_pointers(void)
 	return kptr_restrict >= 3;
 }
 
+/*
+ * return non-zero if we should cleanse pointers for %pa* specifiers.
+ */
+static inline int kptr_restrict_cleanse_addresses(void)
+{
+	return kptr_restrict >= 4;
+}
+
+/*
+ * return non-zero if we should cleanse pointers for %p[rR] specifiers.
+ */
+static inline int kptr_restrict_cleanse_resources(void)
+{
+	return kptr_restrict >= 4;
+}
+
 static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
@@ -758,6 +774,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 
 	char *p = sym, *pend = sym + sizeof(sym);
 	int decode = (fmt[0] == 'R') ? 1 : 0;
+	int cleanse = kptr_restrict_cleanse_resources();
 	const struct printf_spec *specp;
 
 	*p++ = '[';
@@ -785,10 +802,11 @@ char *resource_string(char *buf, char *end, struct resource *res,
 		p = string(p, pend, "size ", str_spec);
 		p = number(p, pend, resource_size(res), *specp);
 	} else {
-		p = number(p, pend, res->start, *specp);
+		p = number(p, pend, cleanse ? 0UL : res->start, *specp);
 		if (res->start != res->end) {
 			*p++ = '-';
-			p = number(p, pend, res->end, *specp);
+			p = number(p, pend, cleanse ?
+				res->end - res->start : res->end, *specp);
 		}
 	}
 	if (decode) {
@@ -1391,6 +1409,9 @@ char *address_val(char *buf, char *end, const void *addr, const char *fmt)
 		break;
 	}
 
+	if (kptr_restrict_cleanse_addresses())
+		num = 0UL;
+
 	return special_hex_number(buf, end, num, size);
 }
 
@@ -1714,6 +1735,12 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
  * pointer to the real address.
  *
  * Note: That for kptr_restrict set to 3, %p and %pK have the same meaning.
+ *
+ * Note: That for kptr_restrict set to 4, %pa will null out the physical
+ * address.
+ *
+ * Note: That for kptr_restrict set to 4, %p[rR] will null out the memory
+ * address.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
-- 
2.7.4
