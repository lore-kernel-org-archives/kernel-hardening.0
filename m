Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 12 Mar 2018 03:03:34 +0000
Message-ID: <lsq.1520823814.957643617@decadent.org.uk>
Subject: [PATCH 3.2 102/104] x86/uaccess: Use __uaccess_begin_nospec() and
 uaccess_try_nospec
In-Reply-To: <lsq.1520823814.606620518@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

3.2.101-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 304ec1b050310548db33063e567123fae8fd0301 upstream.

Quoting Linus:

    I do think that it would be a good idea to very expressly document
    the fact that it's not that the user access itself is unsafe. I do
    agree that things like "get_user()" want to be protected, but not
    because of any direct bugs or problems with get_user() and friends,
    but simply because get_user() is an excellent source of a pointer
    that is obviously controlled from a potentially attacking user
    space. So it's a prime candidate for then finding _subsequent_
    accesses that can then be used to perturb the cache.

__uaccess_begin_nospec() covers __get_user() and copy_from_iter() where the
limit check is far away from the user pointer de-reference. In those cases
a barrier_nospec() prevents speculation with a potential pointer to
privileged memory. uaccess_try_nospec covers get_user_try.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727416953.33451.10508284228526170604.stgit@dwillia2-desk3.amr.corp.intel.com
[bwh: Backported to 3.2:
 - There's no SMAP support, so use barrier_nospec() directly instead of
   __uaccess_begin_nospec()
 - Convert several more functions to use barrier_nospec(), that are just
   wrappers in mainline
 - There's no 'case 8' in __copy_to_user_inatomic()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -423,6 +423,7 @@ do {									\
 ({									\
 	int __gu_err;							\
 	unsigned long __gu_val;						\
+	barrier_nospec();					\
 	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
@@ -529,7 +530,7 @@ struct __large_struct { unsigned long bu
  *	get_user_ex(...);
  * } get_user_catch(err)
  */
-#define get_user_try		uaccess_try
+#define get_user_try		uaccess_try_nospec
 #define get_user_catch(err)	uaccess_catch(err)
 
 #define get_user_ex(x, ptr)	do {					\
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -48,14 +48,17 @@ __copy_to_user_inatomic(void __user *to,
 
 		switch (n) {
 		case 1:
+			barrier_nospec();
 			__put_user_size(*(u8 *)from, (u8 __user *)to,
 					1, ret, 1);
 			return ret;
 		case 2:
+			barrier_nospec();
 			__put_user_size(*(u16 *)from, (u16 __user *)to,
 					2, ret, 2);
 			return ret;
 		case 4:
+			barrier_nospec();
 			__put_user_size(*(u32 *)from, (u32 __user *)to,
 					4, ret, 4);
 			return ret;
@@ -98,12 +101,15 @@ __copy_from_user_inatomic(void *to, cons
 
 		switch (n) {
 		case 1:
+			barrier_nospec();
 			__get_user_size(*(u8 *)to, from, 1, ret, 1);
 			return ret;
 		case 2:
+			barrier_nospec();
 			__get_user_size(*(u16 *)to, from, 2, ret, 2);
 			return ret;
 		case 4:
+			barrier_nospec();
 			__get_user_size(*(u32 *)to, from, 4, ret, 4);
 			return ret;
 		}
@@ -142,12 +148,15 @@ __copy_from_user(void *to, const void __
 
 		switch (n) {
 		case 1:
+			barrier_nospec();
 			__get_user_size(*(u8 *)to, from, 1, ret, 1);
 			return ret;
 		case 2:
+			barrier_nospec();
 			__get_user_size(*(u16 *)to, from, 2, ret, 2);
 			return ret;
 		case 4:
+			barrier_nospec();
 			__get_user_size(*(u32 *)to, from, 4, ret, 4);
 			return ret;
 		}
@@ -164,12 +173,15 @@ static __always_inline unsigned long __c
 
 		switch (n) {
 		case 1:
+			barrier_nospec();
 			__get_user_size(*(u8 *)to, from, 1, ret, 1);
 			return ret;
 		case 2:
+			barrier_nospec();
 			__get_user_size(*(u16 *)to, from, 2, ret, 2);
 			return ret;
 		case 4:
+			barrier_nospec();
 			__get_user_size(*(u32 *)to, from, 4, ret, 4);
 			return ret;
 		}
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -75,19 +75,28 @@ int __copy_from_user_nocheck(void *dst,
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
-	case 1:__get_user_asm(*(u8 *)dst, (u8 __user *)src,
+	case 1:
+		barrier_nospec();
+		__get_user_asm(*(u8 *)dst, (u8 __user *)src,
 			      ret, "b", "b", "=q", 1);
 		return ret;
-	case 2:__get_user_asm(*(u16 *)dst, (u16 __user *)src,
+	case 2:
+		barrier_nospec();
+		__get_user_asm(*(u16 *)dst, (u16 __user *)src,
 			      ret, "w", "w", "=r", 2);
 		return ret;
-	case 4:__get_user_asm(*(u32 *)dst, (u32 __user *)src,
+	case 4:
+		barrier_nospec();
+		__get_user_asm(*(u32 *)dst, (u32 __user *)src,
 			      ret, "l", "k", "=r", 4);
 		return ret;
-	case 8:__get_user_asm(*(u64 *)dst, (u64 __user *)src,
+	case 8:
+		barrier_nospec();
+		__get_user_asm(*(u64 *)dst, (u64 __user *)src,
 			      ret, "q", "", "=r", 8);
 		return ret;
 	case 10:
+		barrier_nospec();
 		__get_user_asm(*(u64 *)dst, (u64 __user *)src,
 			       ret, "q", "", "=r", 10);
 		if (unlikely(ret))
@@ -97,6 +106,7 @@ int __copy_from_user_nocheck(void *dst,
 			       ret, "w", "w", "=r", 2);
 		return ret;
 	case 16:
+		barrier_nospec();
 		__get_user_asm(*(u64 *)dst, (u64 __user *)src,
 			       ret, "q", "", "=r", 16);
 		if (unlikely(ret))
@@ -179,6 +189,7 @@ int __copy_in_user(void __user *dst, con
 	switch (size) {
 	case 1: {
 		u8 tmp;
+		barrier_nospec();
 		__get_user_asm(tmp, (u8 __user *)src,
 			       ret, "b", "b", "=q", 1);
 		if (likely(!ret))
@@ -188,6 +199,7 @@ int __copy_in_user(void __user *dst, con
 	}
 	case 2: {
 		u16 tmp;
+		barrier_nospec();
 		__get_user_asm(tmp, (u16 __user *)src,
 			       ret, "w", "w", "=r", 2);
 		if (likely(!ret))
@@ -198,6 +210,7 @@ int __copy_in_user(void __user *dst, con
 
 	case 4: {
 		u32 tmp;
+		barrier_nospec();
 		__get_user_asm(tmp, (u32 __user *)src,
 			       ret, "l", "k", "=r", 4);
 		if (likely(!ret))
@@ -207,6 +220,7 @@ int __copy_in_user(void __user *dst, con
 	}
 	case 8: {
 		u64 tmp;
+		barrier_nospec();
 		__get_user_asm(tmp, (u64 __user *)src,
 			       ret, "q", "", "=r", 8);
 		if (likely(!ret))
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -774,6 +774,7 @@ survive:
 		return n;
 	}
 #endif
+	barrier_nospec();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
@@ -785,6 +786,7 @@ EXPORT_SYMBOL(__copy_to_user_ll);
 unsigned long __copy_from_user_ll(void *to, const void __user *from,
 					unsigned long n)
 {
+	barrier_nospec();
 	if (movsl_is_ok(to, from, n))
 		__copy_user_zeroing(to, from, n);
 	else
@@ -796,6 +798,7 @@ EXPORT_SYMBOL(__copy_from_user_ll);
 unsigned long __copy_from_user_ll_nozero(void *to, const void __user *from,
 					 unsigned long n)
 {
+	barrier_nospec();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
@@ -808,6 +811,7 @@ EXPORT_SYMBOL(__copy_from_user_ll_nozero
 unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 					unsigned long n)
 {
+	barrier_nospec();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if (n > 64 && cpu_has_xmm2)
 		n = __copy_user_zeroing_intel_nocache(to, from, n);
@@ -823,6 +827,7 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocach
 unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
 					unsigned long n)
 {
+	barrier_nospec();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if (n > 64 && cpu_has_xmm2)
 		n = __copy_user_intel_nocache(to, from, n);
