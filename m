From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 10:40:56 +1100
Message-Id: <1511826058-2563-4-git-send-email-me@tobin.cc>
In-Reply-To: <1511826058-2563-1-git-send-email-me@tobin.cc>
References: <1511826058-2563-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 3/5] vsprintf: add specifier %px, unique identifier
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The typical in tree method for obtaining a unique identifier when
printing kernel objects (structs) is to use the address of the struct
i.e the pointer. This potentially leaks sensitive information to user
space because it reveals information about the kernel layout in
memory. We can get a unique identifier based on an address by hashing
the address first before printing.

Add printk specifier %px which hashes the address before printing.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 lib/test_printf.c     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c        | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/checkpatch.pl |  2 +-
 3 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/lib/test_printf.c b/lib/test_printf.c
index 563f10e6876a..8da57205f1ea 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -462,10 +462,84 @@ flags(void)
 	kfree(cmp_buffer);
 }
 
+#define HASHED_BUF_SIZE 64	/* leave some space so we don't oops */
+
+#if BITS_PER_LONG == 64
+
+#define PTR ((void *)0xffff0123456789ab)
+#define PTR_STR "ffff0123456789ab"
+#define ZEROS "00000000"	/* hex 32 zero bits */
+
+static int __init
+hashed_format(void)
+{
+	char buf[HASHED_BUF_SIZE];
+	int nchars;
+
+	nchars = snprintf(buf, HASHED_BUF_SIZE, "%px", PTR);
+
+	if (nchars != PTR_WIDTH || strncmp(buf, ZEROS, strlen(ZEROS)) != 0)
+		return -1;
+
+	return 0;
+}
+
+#else
+
+#define PTR ((void *)0x456789ab)
+#define PTR_STR "456789ab"
+
+static int __init
+hashed_format(void)
+{
+	/* Format is implicitly tested for 32 bit machines by hashed_hash() */
+	return 0;
+}
+
+#endif	/* BITS_PER_LONG == 64 */
+
+static int __init
+hashed_hash(void)
+{
+	char buf[HASHED_BUF_SIZE];
+	int nchars;
+
+	nchars = snprintf(buf, HASHED_BUF_SIZE, "%px", PTR);
+
+	if (nchars != PTR_WIDTH || strncmp(buf, PTR_STR, PTR_WIDTH) == 0)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * We can't use test() to test %px because we don't know what output to expect
+ * after an address is hashed.
+ */
+static void __init
+hashed(void)
+{
+	int err;
+
+	err = hashed_hash();
+	if (err) {
+		pr_warn("specifier px does not appear to be hashed\n");
+		failed_tests++;
+		return;
+	}
+
+	err = hashed_format();
+	if (err) {
+		pr_warn("hashed output from px has unexpected format\n");
+		failed_tests++;
+	}
+}
+
 static void __init
 test_pointer(void)
 {
 	plain();
+	hashed();
 	symbol_ptr();
 	kernel_ptr();
 	struct_resource();
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 360731f81dd3..3b0de95c3498 100644
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
@@ -1644,6 +1646,73 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
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
+	if (!ret) {
+		return 0;
+	} else if (ret == -EALREADY) {
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
+	const int default_width = 2 * sizeof(ptr);
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
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1868,6 +1937,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		case 'F':
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
+	case 'x':
+		return ptr_to_id(buf, end, ptr, spec);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 95cda3ecc66b..040aa79e1d9d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5753,7 +5753,7 @@ sub process {
 		        for (my $count = $linenr; $count <= $lc; $count++) {
 				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
 				$fmt =~ s/%%//g;
-				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNO]).)/) {
+				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNOx]).)/) {
 					$bad_extension = $1;
 					last;
 				}
-- 
2.7.4
