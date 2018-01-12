From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:08 -0800
Message-ID: <151571802814.27429.12886210130791656117.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 08/19] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Since this is a major kernel interface that deals with user controlled
data, the '__uaccess_begin_nospec' mechanism will prevent speculative
execution past an 'access_ok' permission check. While speculative
execution past 'access_ok' is not enough to lead to a kernel memory
leak, it is a necessary precondition.

To be clear, '__uaccess_begin_nospec' and ASM_IFENCE are not addressing
any known issues with 'get_user' they are addressing a class of
potential problems that could be near 'get_user' usages. In other words,
these helpers are for hygiene not clinical fixes.

Note that '__copy_user_ll' is also called in the 'put_user' case, but
there is currently no indication that put_user in general deserves the
same hygiene as 'get_user'.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/uaccess.h    |    6 +++---
 arch/x86/include/asm/uaccess_32.h |    6 +++---
 arch/x86/include/asm/uaccess_64.h |   12 ++++++------
 arch/x86/lib/copy_user_64.S       |    3 +++
 arch/x86/lib/usercopy_32.c        |    8 ++++----
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index a31fd4fc6483..82c73f064e76 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -450,7 +450,7 @@ do {									\
 ({									\
 	int __gu_err;							\
 	__inttype(*(ptr)) __gu_val;					\
-	__uaccess_begin();						\
+	__uaccess_begin_nospec();					\
 	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
 	__uaccess_end();						\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
@@ -558,7 +558,7 @@ struct __large_struct { unsigned long buf[100]; };
  *	get_user_ex(...);
  * } get_user_catch(err)
  */
-#define get_user_try		uaccess_try
+#define get_user_try		uaccess_try_nospec
 #define get_user_catch(err)	uaccess_catch(err)
 
 #define get_user_ex(x, ptr)	do {					\
@@ -592,7 +592,7 @@ extern void __cmpxchg_wrong_size(void)
 	__typeof__(ptr) __uval = (uval);				\
 	__typeof__(*(ptr)) __old = (old);				\
 	__typeof__(*(ptr)) __new = (new);				\
-	__uaccess_begin();						\
+	__uaccess_begin_nospec();					\
 	switch (size) {							\
 	case 1:								\
 	{								\
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 72950401b223..ba2dc1930630 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -29,21 +29,21 @@ raw_copy_from_user(void *to, const void __user *from, unsigned long n)
 		switch (n) {
 		case 1:
 			ret = 0;
-			__uaccess_begin();
+			__uaccess_begin_nospec();
 			__get_user_asm_nozero(*(u8 *)to, from, ret,
 					      "b", "b", "=q", 1);
 			__uaccess_end();
 			return ret;
 		case 2:
 			ret = 0;
-			__uaccess_begin();
+			__uaccess_begin_nospec();
 			__get_user_asm_nozero(*(u16 *)to, from, ret,
 					      "w", "w", "=r", 2);
 			__uaccess_end();
 			return ret;
 		case 4:
 			ret = 0;
-			__uaccess_begin();
+			__uaccess_begin_nospec();
 			__get_user_asm_nozero(*(u32 *)to, from, ret,
 					      "l", "k", "=r", 4);
 			__uaccess_end();
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index f07ef3c575db..62546b3a398e 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -55,31 +55,31 @@ raw_copy_from_user(void *dst, const void __user *src, unsigned long size)
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
 	case 1:
-		__uaccess_begin();
+		__uaccess_begin_nospec();
 		__get_user_asm_nozero(*(u8 *)dst, (u8 __user *)src,
 			      ret, "b", "b", "=q", 1);
 		__uaccess_end();
 		return ret;
 	case 2:
-		__uaccess_begin();
+		__uaccess_begin_nospec();
 		__get_user_asm_nozero(*(u16 *)dst, (u16 __user *)src,
 			      ret, "w", "w", "=r", 2);
 		__uaccess_end();
 		return ret;
 	case 4:
-		__uaccess_begin();
+		__uaccess_begin_nospec();
 		__get_user_asm_nozero(*(u32 *)dst, (u32 __user *)src,
 			      ret, "l", "k", "=r", 4);
 		__uaccess_end();
 		return ret;
 	case 8:
-		__uaccess_begin();
+		__uaccess_begin_nospec();
 		__get_user_asm_nozero(*(u64 *)dst, (u64 __user *)src,
 			      ret, "q", "", "=r", 8);
 		__uaccess_end();
 		return ret;
 	case 10:
-		__uaccess_begin();
+		__uaccess_begin_nospec();
 		__get_user_asm_nozero(*(u64 *)dst, (u64 __user *)src,
 			       ret, "q", "", "=r", 10);
 		if (likely(!ret))
@@ -89,7 +89,7 @@ raw_copy_from_user(void *dst, const void __user *src, unsigned long size)
 		__uaccess_end();
 		return ret;
 	case 16:
-		__uaccess_begin();
+		__uaccess_begin_nospec();
 		__get_user_asm_nozero(*(u64 *)dst, (u64 __user *)src,
 			       ret, "q", "", "=r", 16);
 		if (likely(!ret))
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 020f75cc8cf6..2429ca38dee6 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -31,6 +31,7 @@
  */
 ENTRY(copy_user_generic_unrolled)
 	ASM_STAC
+	ASM_IFENCE
 	cmpl $8,%edx
 	jb 20f		/* less then 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -135,6 +136,7 @@ EXPORT_SYMBOL(copy_user_generic_unrolled)
  */
 ENTRY(copy_user_generic_string)
 	ASM_STAC
+	ASM_IFENCE
 	cmpl $8,%edx
 	jb 2f		/* less than 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -175,6 +177,7 @@ EXPORT_SYMBOL(copy_user_generic_string)
  */
 ENTRY(copy_user_enhanced_fast_string)
 	ASM_STAC
+	ASM_IFENCE
 	cmpl $64,%edx
 	jb .L_copy_short_string	/* less then 64 bytes, avoid the costly 'rep' */
 	movl %edx,%ecx
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 1b377f734e64..7add8ba06887 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -331,12 +331,12 @@ do {									\
 
 unsigned long __copy_user_ll(void *to, const void *from, unsigned long n)
 {
-	stac();
+	__uaccess_begin_nospec();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
 		n = __copy_user_intel(to, from, n);
-	clac();
+	__uaccess_end();
 	return n;
 }
 EXPORT_SYMBOL(__copy_user_ll);
@@ -344,7 +344,7 @@ EXPORT_SYMBOL(__copy_user_ll);
 unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
 					unsigned long n)
 {
-	stac();
+	__uaccess_begin_nospec();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if (n > 64 && static_cpu_has(X86_FEATURE_XMM2))
 		n = __copy_user_intel_nocache(to, from, n);
@@ -353,7 +353,7 @@ unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *fr
 #else
 	__copy_user(to, from, n);
 #endif
-	clac();
+	__uaccess_end();
 	return n;
 }
 EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
