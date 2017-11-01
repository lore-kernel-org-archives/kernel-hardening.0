From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  1 Nov 2017 15:32:23 +1100
Message-Id: <1509510743-28429-3-git-send-email-me@tobin.cc>
In-Reply-To: <1509510743-28429-1-git-send-email-me@tobin.cc>
References: <1509510743-28429-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V10 2/2] printk: hash addresses printed with %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently there are many places in the kernel where addresses are being
printed using an unadorned %p. Kernel pointers should be printed using
%pK allowing some control via the kptr_restrict sysctl. Exposing addresses
gives attackers sensitive information about the kernel layout in memory.

We can reduce the attack surface by hashing all addresses printed with
%p. This will of course break some users, forcing code printing needed
addresses to be updated.

For what it's worth, usage of unadorned %p can be broken down as
follows (thanks to Joe Perches).

$ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
   1084 arch
     20 block
     10 crypto
     32 Documentation
   8121 drivers
   1221 fs
    143 include
    101 kernel
     69 lib
    100 mm
   1510 net
     40 samples
      7 scripts
     11 security
    166 sound
    152 tools
      2 virt

Add function ptr_to_id() to map an address to a 32 bit unique
identifier. Hash any unadorned usage of specifier %p and any malformed
specifiers.

Signed-off-by: Tobin C. Harding <me@tobin.cc>

---
 Documentation/printk-formats.txt |  17 +++-
 lib/test_printf.c                | 108 +++++++++++++++---------
 lib/vsprintf.c                   | 176 ++++++++++++++++++++++++++++-----------
 3 files changed, 213 insertions(+), 88 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 361789df51ec..ec7deb80d035 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -5,6 +5,9 @@ How to get printk format specifiers right
 :Author: Randy Dunlap <rdunlap@infradead.org>
 :Author: Andrew Murray <amurray@mpc-data.co.uk>
 
+Please do not print kernel addresses using %x. Exposing kernel addresses to
+user space leaks sensitive information that increases the attack surface of the
+kernel. In order to print pointers, please see 'Pointer Types' below.
 
 Integer types
 =============
@@ -45,6 +48,18 @@ return from vsnprintf.
 Raw pointer value SHOULD be printed with %p. The kernel supports
 the following extended format specifiers for pointer types:
 
+Pointer Types
+=============
+
+Pointers printed without a specifier extension (i.e unadorned %p) are hashed
+to give a unique identifier without leaking kernel addresses to user space.
+If you _really_ want to see the address please use %pK (see 'Kernel Pointers'
+below). On 64 bit machines the first 32 bits are zeroed.
+
+::
+
+	%p	abcdef12 or 00000000abcdef12
+
 Symbols/Function Pointers
 =========================
 
@@ -91,7 +106,7 @@ Kernel Pointers
 
 ::
 
-	%pK	0x01234567 or 0x0123456789abcdef
+	%pK	01234567 or 0123456789abcdef
 
 For printing kernel pointers which should be hidden from unprivileged
 users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
diff --git a/lib/test_printf.c b/lib/test_printf.c
index 563f10e6876a..71ebfa43ad05 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -24,24 +24,6 @@
 #define PAD_SIZE 16
 #define FILL_CHAR '$'
 
-#define PTR1 ((void*)0x01234567)
-#define PTR2 ((void*)(long)(int)0xfedcba98)
-
-#if BITS_PER_LONG == 64
-#define PTR1_ZEROES "000000000"
-#define PTR1_SPACES "         "
-#define PTR1_STR "1234567"
-#define PTR2_STR "fffffffffedcba98"
-#define PTR_WIDTH 16
-#else
-#define PTR1_ZEROES "0"
-#define PTR1_SPACES " "
-#define PTR1_STR "1234567"
-#define PTR2_STR "fedcba98"
-#define PTR_WIDTH 8
-#endif
-#define PTR_WIDTH_STR stringify(PTR_WIDTH)
-
 static unsigned total_tests __initdata;
 static unsigned failed_tests __initdata;
 static char *test_buffer __initdata;
@@ -217,30 +199,79 @@ test_string(void)
 	test("a  |   |   ", "%-3.s|%-3.0s|%-3.*s", "a", "b", 0, "c");
 }
 
+#define PLAIN_BUF_SIZE 64	/* leave some space so we don't oops */
+
+#if BITS_PER_LONG == 64
+
+#define PTR_WIDTH 16
+#define PTR ((void *)0xffff0123456789ab)
+#define PTR_STR "ffff0123456789ab"
+#define ZEROS "00000000"	/* hex 32 zero bits */
+
+static int __init
+plain_format(void)
+{
+	char buf[PLAIN_BUF_SIZE];
+	int nchars;
+
+	nchars = snprintf(buf, PLAIN_BUF_SIZE, "%p", PTR);
+
+	if (nchars != PTR_WIDTH || strncmp(buf, ZEROS, strlen(ZEROS)) != 0)
+		return -1;
+
+	return 0;
+}
+
+#else
+
+#define PTR_WIDTH 8
+#define PTR ((void *)0x456789ab)
+#define PTR_STR "456789ab"
+
+static int __init
+plain_format(void)
+{
+	/* Format is implicitly tested for 32 bit machines by plain_hash() */
+	return 0;
+}
+
+#endif	/* BITS_PER_LONG == 64 */
+
+static int __init
+plain_hash(void)
+{
+	char buf[PLAIN_BUF_SIZE];
+	int nchars;
+
+	nchars = snprintf(buf, PLAIN_BUF_SIZE, "%p", PTR);
+
+	if (nchars != PTR_WIDTH || strncmp(buf, PTR_STR, PTR_WIDTH) == 0)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * We can't use test() to test %p because we don't know what output to expect
+ * after an address is hashed.
+ */
 static void __init
 plain(void)
 {
-	test(PTR1_ZEROES PTR1_STR " " PTR2_STR, "%p %p", PTR1, PTR2);
-	/*
-	 * The field width is overloaded for some %p extensions to
-	 * pass another piece of information. For plain pointers, the
-	 * behaviour is slightly odd: One cannot pass either the 0
-	 * flag nor a precision to %p without gcc complaining, and if
-	 * one explicitly gives a field width, the number is no longer
-	 * zero-padded.
-	 */
-	test("|" PTR1_STR PTR1_SPACES "  |  " PTR1_SPACES PTR1_STR "|",
-	     "|%-*p|%*p|", PTR_WIDTH+2, PTR1, PTR_WIDTH+2, PTR1);
-	test("|" PTR2_STR "  |  " PTR2_STR "|",
-	     "|%-*p|%*p|", PTR_WIDTH+2, PTR2, PTR_WIDTH+2, PTR2);
+	int err;
 
-	/*
-	 * Unrecognized %p extensions are treated as plain %p, but the
-	 * alphanumeric suffix is ignored (that is, does not occur in
-	 * the output.)
-	 */
-	test("|"PTR1_ZEROES PTR1_STR"|", "|%p0y|", PTR1);
-	test("|"PTR2_STR"|", "|%p0y|", PTR2);
+	err = plain_hash();
+	if (err) {
+		pr_warn("plain 'p' does not appear to be hashed\n");
+		failed_tests++;
+		return;
+	}
+
+	err = plain_format();
+	if (err) {
+		pr_warn("hashing plain 'p' has unexpected format\n");
+		failed_tests++;
+	}
 }
 
 static void __init
@@ -251,6 +282,7 @@ symbol_ptr(void)
 static void __init
 kernel_ptr(void)
 {
+	/* We can't test this without access to kptr_restrict. */
 }
 
 static void __init
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385b9eb3..1cca8d8785e1 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -33,6 +33,8 @@
 #include <linux/uuid.h>
 #include <linux/of.h>
 #include <net/addrconf.h>
+#include <linux/siphash.h>
+#include <linux/compiler.h>
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
@@ -1343,6 +1345,59 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
+int kptr_restrict __read_mostly;
+
+static noinline_for_stack
+char *kernel_pointer(char *buf, char *end, const void *ptr,
+		     struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(void *);
+		spec.flags |= ZEROPAD;
+	}
+
+	switch (kptr_restrict) {
+	case 0:
+		/* Always print %pK values */
+		break;
+	case 1: {
+		const struct cred *cred;
+
+		/*
+		 * kptr_restrict==1 cannot be used in IRQ context
+		 * because its test for CAP_SYSLOG would be meaningless.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi())
+			return string(buf, end, "pK-error", spec);
+
+		/*
+		 * Only print the real pointer value if the current
+		 * process has CAP_SYSLOG and is running with the
+		 * same credentials it started with. This is because
+		 * access to files is checked at open() time, but %pK
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
+	case 2:
+	default:
+		/* Always print 0's for %pK */
+		ptr = NULL;
+		break;
+	}
+
+	return number(buf, end, (unsigned long)ptr, spec);
+}
+
 static noinline_for_stack
 char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
 {
@@ -1591,7 +1646,72 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
-int kptr_restrict __read_mostly;
+static bool have_filled_random_ptr_key __read_mostly;
+static siphash_key_t ptr_key __read_mostly;
+
+static void fill_random_ptr_key(struct random_ready_callback *unused)
+{
+	get_random_bytes(&ptr_key, sizeof(ptr_key));
+	/*
+	 * have_filled_random_ptr_key==true is dependent on get_random_bytes().
+	 * ptr_to_id() needs to see have_filled_random_ptr_key==true
+	 * after get_random_bytes() returns.
+	 */
+	smp_mb();
+	WRITE_ONCE(have_filled_random_ptr_key, true);
+}
+
+static struct random_ready_callback random_ready = {
+	.func = fill_random_ptr_key
+};
+
+static int __init initialize_ptr_random(void)
+{
+	int ret = add_random_ready_callback(&random_ready);
+
+	if (!ret)
+		return 0;
+	else if (ret == -EALREADY) {
+		fill_random_ptr_key(&random_ready);
+		return 0;
+	}
+
+	return ret;
+}
+early_initcall(initialize_ptr_random);
+
+/* Maps a pointer to a 32 bit unique identifier. */
+static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
+{
+	unsigned long hashval;
+	const int default_width = 2 * sizeof(void *);
+
+	if (unlikely(!have_filled_random_ptr_key)) {
+		spec.field_width = default_width;
+		/* string length must be less than default_width */
+		return string(buf, end, "(ptrval)", spec);
+	}
+
+#ifdef CONFIG_64BIT
+	hashval = (unsigned long)siphash_1u64((u64)ptr, &ptr_key);
+	/*
+	 * Mask off the first 32 bits, this makes explicit that we have
+	 * modified the address (and 32 bits is plenty for a unique ID).
+	 */
+	hashval = hashval & 0xffffffff;
+#else
+	hashval = (unsigned long)siphash_1u32((u32)ptr, &ptr_key);
+#endif
+
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = default_width;
+		spec.flags |= ZEROPAD;
+	}
+	spec.base = 16;
+
+	return number(buf, end, hashval, spec);
+}
 
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
@@ -1703,6 +1823,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: The default behaviour (unadorned %p) is to hash the address,
+ * rendering it useful as a unique identifier.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1792,47 +1915,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return buf;
 		}
 	case 'K':
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
+		return kernel_pointer(buf, end, ptr, spec);
 	case 'N':
 		return netdev_bits(buf, end, ptr, fmt);
 	case 'a':
@@ -1858,14 +1941,9 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
 	}
-	spec.flags |= SMALL;
-	if (spec.field_width == -1) {
-		spec.field_width = default_width;
-		spec.flags |= ZEROPAD;
-	}
-	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	/* default is to _not_ leak addresses, hash before printing */
+	return ptr_to_id(buf, end, ptr, spec);
 }
 
 /*
-- 
2.7.4
