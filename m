Date: Wed, 15 Feb 2017 12:05:57 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170215200557.GA37325@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] ARM: uaccess: consistently check object sizes
To: Russell King <linux@armlinux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Al Viro <viro@zeniv.linux.org.uk>, Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

In commit 76624175dcae ("arm64: uaccess: consistently check object sizes"),
the object size checks are moved outside the access_ok() so that bad
destinations are detected before hitting the "memset(dest, 0, size)" in the
copy_from_user() failure path.

This makes the same change for arm, with attention given to possibly
extracting the uaccess routines into a common header file for all
architectures in the future.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/uaccess.h | 44 ++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 1f59ea051bab..b7e0125c0bbf 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -478,11 +478,10 @@ extern unsigned long __must_check
 arm_copy_from_user(void *to, const void __user *from, unsigned long n);
 
 static inline unsigned long __must_check
-__copy_from_user(void *to, const void __user *from, unsigned long n)
+__arch_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	unsigned int __ua_flags;
 
-	check_object_size(to, n, false);
 	__ua_flags = uaccess_save_and_enable();
 	n = arm_copy_from_user(to, from, n);
 	uaccess_restore(__ua_flags);
@@ -495,18 +494,15 @@ extern unsigned long __must_check
 __copy_to_user_std(void __user *to, const void *from, unsigned long n);
 
 static inline unsigned long __must_check
-__copy_to_user(void __user *to, const void *from, unsigned long n)
+__arch_copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 #ifndef CONFIG_UACCESS_WITH_MEMCPY
 	unsigned int __ua_flags;
-
-	check_object_size(from, n, true);
 	__ua_flags = uaccess_save_and_enable();
 	n = arm_copy_to_user(to, from, n);
 	uaccess_restore(__ua_flags);
 	return n;
 #else
-	check_object_size(from, n, true);
 	return arm_copy_to_user(to, from, n);
 #endif
 }
@@ -526,25 +522,49 @@ __clear_user(void __user *addr, unsigned long n)
 }
 
 #else
-#define __copy_from_user(to, from, n)	(memcpy(to, (void __force *)from, n), 0)
-#define __copy_to_user(to, from, n)	(memcpy((void __force *)to, from, n), 0)
+#define __arch_copy_from_user(to, from, n)	\
+					(memcpy(to, (void __force *)from, n), 0)
+#define __arch_copy_to_user(to, from, n)	\
+					(memcpy((void __force *)to, from, n), 0)
 #define __clear_user(addr, n)		(memset((void __force *)addr, 0, n), 0)
 #endif
 
-static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
+static inline unsigned long __must_check
+__copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	check_object_size(to, n, false);
+	return __arch_copy_from_user(to, from, n);
+}
+
+static inline unsigned long __must_check
+copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long res = n;
+
+	check_object_size(to, n, false);
+
 	if (likely(access_ok(VERIFY_READ, from, n)))
-		res = __copy_from_user(to, from, n);
+		res = __arch_copy_from_user(to, from, n);
 	if (unlikely(res))
 		memset(to + (n - res), 0, res);
 	return res;
 }
 
-static inline unsigned long __must_check copy_to_user(void __user *to, const void *from, unsigned long n)
+static inline unsigned long __must_check
+__copy_to_user(void __user *to, const void *from, unsigned long n)
 {
+	check_object_size(from, n, true);
+
+	return __arch_copy_to_user(to, from, n);
+}
+
+static inline unsigned long __must_check
+copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	check_object_size(from, n, true);
+
 	if (access_ok(VERIFY_WRITE, to, n))
-		n = __copy_to_user(to, from, n);
+		n = __arch_copy_to_user(to, from, n);
 	return n;
 }
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
