Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 28 Oct 2016 18:27:10 +0100
Message-Id: <1477675636-3957-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
References: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v4 2/8] arm64: Factor out PAN enabling/disabling into separate uaccess_* macros
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Sami Tolvanen <samitolvanen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch moves the directly coded alternatives for turning PAN on/off
into separate uaccess_{enable,disable} macros or functions. The asm
macros take a few arguments which will be used in subsequent patches.

Note that any (unlikely) access that the compiler might generate between
uaccess_enable() and uaccess_disable(), other than those explicitly
specified by the user access code, will not be protected by PAN.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/futex.h       | 17 ++++----
 arch/arm64/include/asm/uaccess.h     | 79 +++++++++++++++++++++++++++++++-----
 arch/arm64/kernel/armv8_deprecated.c | 11 +++--
 arch/arm64/lib/clear_user.S          | 11 ++---
 arch/arm64/lib/copy_from_user.S      | 11 ++---
 arch/arm64/lib/copy_in_user.S        | 11 ++---
 arch/arm64/lib/copy_to_user.S        | 11 ++---
 7 files changed, 93 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index f2585cdd32c2..85c4a8981d47 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -21,15 +21,12 @@
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 
-#include <asm/alternative.h>
-#include <asm/cpufeature.h>
 #include <asm/errno.h>
-#include <asm/sysreg.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
+do {									\
+	uaccess_enable();						\
 	asm volatile(							\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,		\
-		    CONFIG_ARM64_PAN)					\
 "	prfm	pstl1strm, %2\n"					\
 "1:	ldxr	%w1, %2\n"						\
 	insn "\n"							\
@@ -44,11 +41,11 @@
 "	.popsection\n"							\
 	_ASM_EXTABLE(1b, 4b)						\
 	_ASM_EXTABLE(2b, 4b)						\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
-		    CONFIG_ARM64_PAN)					\
 	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
 	: "r" (oparg), "Ir" (-EFAULT)					\
-	: "memory")
+	: "memory");							\
+	uaccess_disable();						\
+} while (0)
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
@@ -118,8 +115,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	uaccess_enable();
 	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
-ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	prfm	pstl1strm, %2\n"
 "1:	ldxr	%w1, %2\n"
 "	sub	%w3, %w1, %w4\n"
@@ -134,10 +131,10 @@ ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	.popsection\n"
 	_ASM_EXTABLE(1b, 4b)
 	_ASM_EXTABLE(2b, 4b)
-ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
 	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
 	: "memory");
+	uaccess_disable();
 
 	*uval = val;
 	return ret;
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 55d0adbf6509..154659509afb 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -18,6 +18,11 @@
 #ifndef __ASM_UACCESS_H
 #define __ASM_UACCESS_H
 
+#include <asm/alternative.h>
+#include <asm/sysreg.h>
+
+#ifndef __ASSEMBLY__
+
 /*
  * User space memory access functions
  */
@@ -26,10 +31,8 @@
 #include <linux/string.h>
 #include <linux/thread_info.h>
 
-#include <asm/alternative.h>
 #include <asm/cpufeature.h>
 #include <asm/ptrace.h>
-#include <asm/sysreg.h>
 #include <asm/errno.h>
 #include <asm/memory.h>
 #include <asm/compiler.h>
@@ -120,6 +123,44 @@ static inline void set_fs(mm_segment_t fs)
 	"	.popsection\n"
 
 /*
+ * User access enabling/disabling.
+ */
+#define __uaccess_disable(alt)						\
+do {									\
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,			\
+			CONFIG_ARM64_PAN));				\
+} while (0)
+
+#define __uaccess_enable(alt)						\
+do {									\
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,			\
+			CONFIG_ARM64_PAN));				\
+} while (0)
+
+static inline void uaccess_disable(void)
+{
+	__uaccess_disable(ARM64_HAS_PAN);
+}
+
+static inline void uaccess_enable(void)
+{
+	__uaccess_enable(ARM64_HAS_PAN);
+}
+
+/*
+ * These functions are no-ops when UAO is present.
+ */
+static inline void uaccess_disable_not_uao(void)
+{
+	__uaccess_disable(ARM64_ALT_PAN_NOT_UAO);
+}
+
+static inline void uaccess_enable_not_uao(void)
+{
+	__uaccess_enable(ARM64_ALT_PAN_NOT_UAO);
+}
+
+/*
  * The "__xxx" versions of the user access functions do not verify the address
  * space - it must have been done previously with a separate "access_ok()"
  * call.
@@ -146,8 +187,7 @@ static inline void set_fs(mm_segment_t fs)
 do {									\
 	unsigned long __gu_val;						\
 	__chk_user_ptr(ptr);						\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
+	uaccess_enable_not_uao();					\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__get_user_asm("ldrb", "ldtrb", "%w", __gu_val, (ptr),  \
@@ -168,9 +208,8 @@ do {									\
 	default:							\
 		BUILD_BUG();						\
 	}								\
+	uaccess_disable_not_uao();					\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
 } while (0)
 
 #define __get_user(x, ptr)						\
@@ -215,8 +254,7 @@ do {									\
 do {									\
 	__typeof__(*(ptr)) __pu_val = (x);				\
 	__chk_user_ptr(ptr);						\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
+	uaccess_enable_not_uao();					\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__put_user_asm("strb", "sttrb", "%w", __pu_val, (ptr),	\
@@ -237,8 +275,7 @@ do {									\
 	default:							\
 		BUILD_BUG();						\
 	}								\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
+	uaccess_disable_not_uao();					\
 } while (0)
 
 #define __put_user(x, ptr)						\
@@ -331,4 +368,26 @@ extern long strncpy_from_user(char *dest, const char __user *src, long count);
 extern __must_check long strlen_user(const char __user *str);
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+#else	/* __ASSEMBLY__ */
+
+#include <asm/assembler.h>
+
+/*
+ * User access enabling/disabling macros. These are no-ops when UAO is
+ * present.
+ */
+	.macro	uaccess_disable_not_uao, tmp1
+alternative_if ARM64_ALT_PAN_NOT_UAO
+	SET_PSTATE_PAN(1)
+alternative_else_nop_endif
+	.endm
+
+	.macro	uaccess_enable_not_uao, tmp1, tmp2
+alternative_if ARM64_ALT_PAN_NOT_UAO
+	SET_PSTATE_PAN(0)
+alternative_else_nop_endif
+	.endm
+
+#endif	/* __ASSEMBLY__ */
+
 #endif /* __ASM_UACCESS_H */
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index b0988bb1bf64..bdb35b92003e 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 
-#include <asm/alternative.h>
 #include <asm/cpufeature.h>
 #include <asm/insn.h>
 #include <asm/opcodes.h>
@@ -285,10 +284,10 @@ static void __init register_insn_emulation_sysctl(struct ctl_table *table)
 #define __SWP_LL_SC_LOOPS	4
 
 #define __user_swpX_asm(data, addr, res, temp, temp2, B)	\
+do {								\
+	uaccess_enable();					\
 	__asm__ __volatile__(					\
 	"	mov		%w3, %w7\n"			\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,	\
-		    CONFIG_ARM64_PAN)				\
 	"0:	ldxr"B"		%w2, [%4]\n"			\
 	"1:	stxr"B"		%w0, %w1, [%4]\n"		\
 	"	cbz		%w0, 2f\n"			\
@@ -306,12 +305,12 @@ static void __init register_insn_emulation_sysctl(struct ctl_table *table)
 	"	.popsection"					\
 	_ASM_EXTABLE(0b, 4b)					\
 	_ASM_EXTABLE(1b, 4b)					\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,	\
-		CONFIG_ARM64_PAN)				\
 	: "=&r" (res), "+r" (data), "=&r" (temp), "=&r" (temp2)	\
 	: "r" (addr), "i" (-EAGAIN), "i" (-EFAULT),		\
 	  "i" (__SWP_LL_SC_LOOPS)				\
-	: "memory")
+	: "memory");						\
+	uaccess_disable();					\
+} while (0)
 
 #define __user_swp_asm(data, addr, res, temp, temp2) \
 	__user_swpX_asm(data, addr, res, temp, temp2, "")
diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index 5d1cad3ce6d6..d7150e30438a 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -17,10 +17,7 @@
  */
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
-#include <asm/assembler.h>
-#include <asm/cpufeature.h>
-#include <asm/sysreg.h>
+#include <asm/uaccess.h>
 
 	.text
 
@@ -33,8 +30,7 @@
  * Alignment fixed up by hardware.
  */
 ENTRY(__clear_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable_not_uao x2, x3
 	mov	x2, x1			// save the size for fixup return
 	subs	x1, x1, #8
 	b.mi	2f
@@ -54,8 +50,7 @@ uao_user_alternative 9f, strh, sttrh, wzr, x0, 2
 	b.mi	5f
 uao_user_alternative 9f, strb, sttrb, wzr, x0, 0
 5:	mov	x0, #0
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable_not_uao x2
 	ret
 ENDPROC(__clear_user)
 
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 4fd67ea03bb0..cfe13396085b 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -16,11 +16,8 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
-#include <asm/assembler.h>
 #include <asm/cache.h>
-#include <asm/cpufeature.h>
-#include <asm/sysreg.h>
+#include <asm/uaccess.h>
 
 /*
  * Copy from user space to a kernel buffer (alignment handled by the hardware)
@@ -67,12 +64,10 @@
 
 end	.req	x5
 ENTRY(__arch_copy_from_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable_not_uao x3, x4
 	add	end, x0, x2
 #include "copy_template.S"
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable_not_uao x3
 	mov	x0, #0				// Nothing to copy
 	ret
 ENDPROC(__arch_copy_from_user)
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index f7292dd08c84..718b1c4e2f85 100644
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -18,11 +18,8 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
-#include <asm/assembler.h>
 #include <asm/cache.h>
-#include <asm/cpufeature.h>
-#include <asm/sysreg.h>
+#include <asm/uaccess.h>
 
 /*
  * Copy from user space to user space (alignment handled by the hardware)
@@ -68,12 +65,10 @@
 
 end	.req	x5
 ENTRY(__copy_in_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable_not_uao x3, x4
 	add	end, x0, x2
 #include "copy_template.S"
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable_not_uao x3
 	mov	x0, #0
 	ret
 ENDPROC(__copy_in_user)
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 7a7efe255034..e99e31c9acac 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -16,11 +16,8 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
-#include <asm/assembler.h>
 #include <asm/cache.h>
-#include <asm/cpufeature.h>
-#include <asm/sysreg.h>
+#include <asm/uaccess.h>
 
 /*
  * Copy to user space from a kernel buffer (alignment handled by the hardware)
@@ -66,12 +63,10 @@
 
 end	.req	x5
 ENTRY(__arch_copy_to_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable_not_uao x3, x4
 	add	end, x0, x2
 #include "copy_template.S"
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable_not_uao x3
 	mov	x0, #0
 	ret
 ENDPROC(__arch_copy_to_user)
