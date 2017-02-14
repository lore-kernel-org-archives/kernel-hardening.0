Date: Tue, 14 Feb 2017 12:40:39 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170214204039.GA125586@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] usercopy: Add tests for all get_user() sizes
To: linux-kernel@vger.kernel.org
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The existing test was only exercising native unsigned long size
get_user(). For completeness, we should check all sizes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_user_copy.c | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
index ac3a60ba9331..49569125b7c5 100644
--- a/lib/test_user_copy.c
+++ b/lib/test_user_copy.c
@@ -40,8 +40,11 @@ static int __init test_user_copy_init(void)
 	char __user *usermem;
 	char *bad_usermem;
 	unsigned long user_addr;
-	unsigned long value = 0x5A;
 	char *zerokmem;
+	u8 val_u8;
+	u16 val_u16;
+	u32 val_u32;
+	u64 val_u64;
 
 	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
 	if (!kmem)
@@ -72,10 +75,20 @@ static int __init test_user_copy_init(void)
 		    "legitimate copy_from_user failed");
 	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
 		    "legitimate copy_to_user failed");
-	ret |= test(get_user(value, (unsigned long __user *)usermem),
-		    "legitimate get_user failed");
-	ret |= test(put_user(value, (unsigned long __user *)usermem),
-		    "legitimate put_user failed");
+
+#define test_legit(size)						  \
+	do {								  \
+		ret |= test(get_user(val_##size, (size __user *)usermem), \
+		    "legitimate get_user (" #size ") failed");		  \
+		ret |= test(put_user(val_##size, (size __user *)usermem), \
+		    "legitimate put_user (" #size ") failed");		  \
+	} while (0)
+
+	test_legit(u8);
+	test_legit(u16);
+	test_legit(u32);
+	test_legit(u64);
+#undef test_legit
 
 	/*
 	 * Invalid usage: none of these copies should succeed.
@@ -112,12 +125,22 @@ static int __init test_user_copy_init(void)
 				  PAGE_SIZE),
 		    "illegal reversed copy_to_user passed");
 
-	value = 0x5A;
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
+		ret |= test(!put_user(val_##size, (size __user *)kmem),	    \
+		    "illegal put_user (" #size ") passed");		    \
+	} while (0)
+
+	test_illegal(u8,  0x5a);
+	test_illegal(u16, 0x5a5b);
+	test_illegal(u32, 0x5a5b5c5d);
+	test_illegal(u64, 0x5a5b5c5d6a6b6c6d);
+#undef test_illegal
 
 	vm_munmap(user_addr, PAGE_SIZE * 2);
 out_zerokmem:
-- 
2.7.4


-- 
Kees Cook
Pixel Security
