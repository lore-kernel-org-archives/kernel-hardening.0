Date: Fri, 5 May 2017 21:07:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040720.GD32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040641.GA32707@kroah.com>
Subject: [kernel-hardening] [RFC 3/6] lib: vsprintf: physical address kernel pointer filtering
 options
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dave Weinstein <olorin@google.com>

Add the kptr_restrict setting of 4 which results in %pa and
%p[rR] values being replaced by zeros.

Cc: William Roberts <william.c.roberts@intel.com>
Cc: Chris Fries <cfries@google.com>
Signed-off-by: Dave Weinstein <olorin@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sysctl/kernel.txt |  8 +++++++-
 kernel/sysctl.c                 |  3 +--
 lib/vsprintf.c                  | 33 ++++++++++++++++++++++++++++++---
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index c9f5da409868..df069ec42e4a 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -393,7 +393,13 @@ When kptr_restrict is set to (2), kernel pointers printed using
 %pK will be replaced with 0's regardless of privileges.
 
 When kptr_restrict is set to (3), kernel pointers printed using
-%p and %pK will be replaced with 0's regardless of privileges.
+%p and %pK will be replaced with 0's regardless of privileges,
+however kernel pointers printed using %pP will continue to be printed.
+
+When kptr_restrict is set to (4), kernel pointers printed with
+%p, %pK, %pa, and %p[rR] will be replaced with 0's regardless of
+privileges. Kernel pointers printed using %pP will continue to be
+printed.
 
 ==============================================================
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1bfdd262c66a..acf7e6cb00b4 100644
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
@@ -831,7 +830,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
-		.extra2		= &three,
+		.extra2		= &four,
 	},
 #endif
 	{
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index f4e11dade1ab..75a49795fcae 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -405,6 +405,22 @@ static inline int kptr_restrict_always_cleanse_pointers(void)
 	return kptr_restrict >= 3;
 }
 
+/*
+ * Always cleanse physical addresses (%pa* specifiers)
+ */
+static inline int kptr_restrict_cleanse_addresses(void)
+{
+	return kptr_restrict >= 4;
+}
+
+/*
+ * Always cleanse resource addresses (%p[rR] specifiers)
+ */
+static inline int kptr_restrict_cleanse_resources(void)
+{
+	return kptr_restrict >= 4;
+}
+
 static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
@@ -757,6 +773,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 
 	char *p = sym, *pend = sym + sizeof(sym);
 	int decode = (fmt[0] == 'R') ? 1 : 0;
+	int cleanse = kptr_restrict_cleanse_resources();
 	const struct printf_spec *specp;
 
 	*p++ = '[';
@@ -784,10 +801,11 @@ char *resource_string(char *buf, char *end, struct resource *res,
 		p = string(p, pend, "size ", str_spec);
 		p = number(p, pend, resource_size(res), *specp);
 	} else {
-		p = number(p, pend, res->start, *specp);
+		p = number(p, pend, cleanse ? 0UL : res->start, *specp);
 		if (res->start != res->end) {
 			*p++ = '-';
-			p = number(p, pend, res->end, *specp);
+			p = number(p, pend, cleanse ?
+				   res->end - res->start : res->end, *specp);
 		}
 	}
 	if (decode) {
@@ -1390,7 +1408,9 @@ char *address_val(char *buf, char *end, const void *addr, const char *fmt)
 		break;
 	}
 
-	return special_hex_number(buf, end, num, size);
+	return special_hex_number(buf, end,
+		      kptr_restrict_cleanse_addresses() ? 0UL : num,
+		      size);
 }
 
 static noinline_for_stack
@@ -1581,6 +1601,12 @@ char *flags_string(char *buf, char *end, void *flags_ptr, const char *fmt)
  *
  * Note: That for kptr_restrict set to 3, %p and %pK have the same
  * meaning.
+ *
+ * Note: That for kptr_restrict set to 4, %pa will null out the physical
+ * address.
+ *
+ * Note: That for kptr_restrict set to 4, %p[rR] will null out the memory
+ * address.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1738,6 +1764,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		}
 		case 2: /* restrict only %pK */
 		case 3: /* restrict all non-extensioned %p and %pK */
+		case 4: /* restrict all non-extensioned %p, %pK, %pa*, %p[rR] */
 		default:
 			ptr = NULL;
 			break;
-- 
2.12.2
