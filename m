Date: Wed, 15 Feb 2017 16:07:50 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170216000750.GA124760@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2] usercopy: Add tests for all get_user() sizes
To: linux-kernel@vger.kernel.org
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Geert Uytterhoeven <geert@linux-m68k.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The existing test was only exercising native unsigned long size
get_user(). For completeness, we should check all sizes. But we
must skip some 32-bit architectures that don't implement a 64-bit
get_user().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_user_copy.c | 88 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 13 deletions(-)

diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
index 73ff7a628e3a..4a79f2c1cd6e 100644
--- a/lib/test_user_copy.c
+++ b/lib/test_user_copy.c
@@ -25,6 +25,22 @@
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 
+/*
+ * Several 32-bit architectures support 64-bit {get,put}_user() calls.
+ * As there doesn't appear to be anything that can safely determine
+ * their capability at compile-time, we just have to opt-out certain archs.
+ */
+#if BITS_PER_LONG == 64 || (!defined(CONFIG_AVR32)  &&		\
+			    !defined(CONFIG_BLACKFIN) &&	\
+			    !defined(CONFIG_M32R) &&		\
+			    !defined(CONFIG_M68K) &&		\
+			    !defined(CONFIG_MICROBLAZE) &&	\
+			    !defined(CONFIG_MN10300) &&		\
+			    !defined(CONFIG_NIOS2) &&		\
+			    !defined(CONFIG_SUPERH))
+# define TEST_U64
+#endif
+
 #define test(condition, msg)		\
 ({					\
 	int cond = (condition);		\
@@ -40,7 +56,12 @@ static int __init test_user_copy_init(void)
 	char __user *usermem;
 	char *bad_usermem;
 	unsigned long user_addr;
-	unsigned long value = 0x5A;
+	u8 val_u8;
+	u16 val_u16;
+	u32 val_u32;
+#ifdef TEST_U64
+	u64 val_u64;
+#endif
 
 	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
 	if (!kmem)
@@ -61,14 +82,39 @@ static int __init test_user_copy_init(void)
 	/*
 	 * Legitimate usage: none of these copies should fail.
 	 */
-	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
-		    "legitimate copy_from_user failed");
+	memset(kmem, 0x3a, PAGE_SIZE * 2);
 	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
 		    "legitimate copy_to_user failed");
-	ret |= test(get_user(value, (unsigned long __user *)usermem),
-		    "legitimate get_user failed");
-	ret |= test(put_user(value, (unsigned long __user *)usermem),
-		    "legitimate put_user failed");
+	memset(kmem, 0x0, PAGE_SIZE);
+	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
+		    "legitimate copy_from_user failed");
+	ret |= test(memcmp(kmem, kmem + PAGE_SIZE, PAGE_SIZE),
+		    "legitimate usercopy failed to copy data");
+
+#define test_legit(size, check)						  \
+	do {								  \
+		val_##size = check;					  \
+		ret |= test(put_user(val_##size, (size __user *)usermem), \
+		    "legitimate put_user (" #size ") failed");		  \
+		val_##size = 0;						  \
+		ret |= test(get_user(val_##size, (size __user *)usermem), \
+		    "legitimate get_user (" #size ") failed");		  \
+		ret |= test(val_##size != check,			  \
+		    "legitimate get_user (" #size ") failed to do copy"); \
+		if (val_##size != check) {				  \
+			pr_info("0x%llx != 0x%llx\n",			  \
+				(unsigned long long)val_##size,		  \
+				(unsigned long long)check);		  \
+		}							  \
+	} while (0)
+
+	test_legit(u8,  0x5a);
+	test_legit(u16, 0x5a5b);
+	test_legit(u32, 0x5a5b5c5d);
+#ifdef TEST_U64
+	test_legit(u64, 0x5a5b5c5d6a6b6c6d);
+#endif
+#undef test_legit
 
 	/*
 	 * Invalid usage: none of these copies should succeed.
@@ -105,12 +151,28 @@ static int __init test_user_copy_init(void)
 				  PAGE_SIZE),
 		    "illegal reversed copy_to_user passed");
 
-	value = 0x5a;
-	ret |= test(!get_user(value, (unsigned long __user *)kmem),
-		    "illegal get_user passed");
-	ret |= test(value != 0, "zeroing failure for illegal get_user");
-	ret |= test(!put_user(value, (unsigned long __user *)kmem),
-		    "illegal put_user passed");
+#define test_illegal(size, check)					    \
+	do {								    \
+		val_##size = (check);					    \
+		ret |= test(!get_user(val_##size, (size __user *)kmem),	    \
+		    "illegal get_user (" #size ") passed");		    \
+		ret |= test(val_##size != (size)0,			    \
+		    "zeroing failure for illegal get_user (" #size ")");    \
+		if (val_##size != (size)0) {				    \
+			pr_info("0x%llx != 0\n",			    \
+				(unsigned long long)val_##size);	    \
+		}							    \
+		ret |= test(!put_user(val_##size, (size __user *)kmem),	    \
+		    "illegal put_user (" #size ") passed");		    \
+	} while (0)
+
+	test_illegal(u8,  0x5a);
+	test_illegal(u16, 0x5a5b);
+	test_illegal(u32, 0x5a5b5c5d);
+#ifdef TEST_U64
+	test_illegal(u64, 0x5a5b5c5d6a6b6c6d);
+#endif
+#undef test_illegal
 
 	vm_munmap(user_addr, PAGE_SIZE * 2);
 	kfree(kmem);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
