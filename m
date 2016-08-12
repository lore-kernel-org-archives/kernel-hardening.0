Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Aug 2016 16:27:40 +0100
Message-Id: <1471015666-23125-2-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH 1/7] arm64: Factor out PAN enabling/disabling into separate uaccess_* macros
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch moves the directly coded alternatives for turning PAN on/off
into separate uaccess_{enable,disable} macros or functions. The asm
macros take a few arguments which will be used in subsequent patches.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h   | 20 ++++++++++++++++++++
 arch/arm64/include/asm/futex.h       | 14 +++++++-------
 arch/arm64/include/asm/uaccess.h     | 27 +++++++++++++++++++--------
 arch/arm64/kernel/armv8_deprecated.c | 10 +++++-----
 arch/arm64/lib/clear_user.S          |  7 ++-----
 arch/arm64/lib/copy_from_user.S      |  7 ++-----
 arch/arm64/lib/copy_in_user.S        |  7 ++-----
 arch/arm64/lib/copy_to_user.S        |  7 ++-----
 8 files changed, 59 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d5025c69ca81..bbed373f4ab7 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -23,6 +23,7 @@
 #ifndef __ASM_ASSEMBLER_H
 #define __ASM_ASSEMBLER_H
 
+#include <asm/alternative.h>
 #include <asm/asm-offsets.h>
 #include <asm/cpufeature.h>
 #include <asm/page.h>
@@ -350,4 +351,23 @@ alternative_endif
 	movk	\reg, :abs_g0_nc:\val
 	.endm
 
+/*
+ * User access enabling/disabling macros.
+ */
+	.macro	uaccess_disable, tmp1
+alternative_if_not ARM64_ALT_PAN_NOT_UAO
+	nop
+alternative_else
+	SET_PSTATE_PAN(1)
+alternative_endif
+	.endm
+
+	.macro	uaccess_enable, tmp1, tmp2, flags, errata = 0
+alternative_if_not ARM64_ALT_PAN_NOT_UAO
+	nop
+alternative_else
+	SET_PSTATE_PAN(0)
+alternative_endif
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index f2585cdd32c2..7e5f236093be 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -27,9 +27,9 @@
 #include <asm/sysreg.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
+do {									\
+	uaccess_enable(ARM64_HAS_PAN);					\
 	asm volatile(							\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,		\
-		    CONFIG_ARM64_PAN)					\
 "	prfm	pstl1strm, %2\n"					\
 "1:	ldxr	%w1, %2\n"						\
 	insn "\n"							\
@@ -44,11 +44,11 @@
 "	.popsection\n"							\
 	_ASM_EXTABLE(1b, 4b)						\
 	_ASM_EXTABLE(2b, 4b)						\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
-		    CONFIG_ARM64_PAN)					\
 	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
 	: "r" (oparg), "Ir" (-EFAULT)					\
-	: "memory")
+	: "memory");							\
+	uaccess_disable(ARM64_HAS_PAN);					\
+} while (0)
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
@@ -118,8 +118,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	uaccess_enable(ARM64_HAS_PAN);
 	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
-ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	prfm	pstl1strm, %2\n"
 "1:	ldxr	%w1, %2\n"
 "	sub	%w3, %w1, %w4\n"
@@ -134,10 +134,10 @@ ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	.popsection\n"
 	_ASM_EXTABLE(1b, 4b)
 	_ASM_EXTABLE(2b, 4b)
-ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
 	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
 	: "memory");
+	uaccess_disable(ARM64_HAS_PAN);
 
 	*uval = val;
 	return ret;
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 5e834d10b291..f04869630207 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -112,6 +112,21 @@ static inline void set_fs(mm_segment_t fs)
 	"	.popsection\n"
 
 /*
+ * User access enabling/disabling.
+ */
+#define uaccess_disable(alt)						\
+do {									\
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,			\
+			CONFIG_ARM64_PAN));				\
+} while (0)
+
+#define uaccess_enable(alt)						\
+do {									\
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,			\
+			CONFIG_ARM64_PAN));				\
+} while (0)
+
+/*
  * The "__xxx" versions of the user access functions do not verify the address
  * space - it must have been done previously with a separate "access_ok()"
  * call.
@@ -138,8 +153,7 @@ static inline void set_fs(mm_segment_t fs)
 do {									\
 	unsigned long __gu_val;						\
 	__chk_user_ptr(ptr);						\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
+	uaccess_enable(ARM64_ALT_PAN_NOT_UAO);				\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__get_user_asm("ldrb", "ldtrb", "%w", __gu_val, (ptr),  \
@@ -160,9 +174,8 @@ do {									\
 	default:							\
 		BUILD_BUG();						\
 	}								\
+	uaccess_disable(ARM64_ALT_PAN_NOT_UAO);				\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
 } while (0)
 
 #define __get_user(x, ptr)						\
@@ -207,8 +220,7 @@ do {									\
 do {									\
 	__typeof__(*(ptr)) __pu_val = (x);				\
 	__chk_user_ptr(ptr);						\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
+	uaccess_enable(ARM64_ALT_PAN_NOT_UAO);				\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__put_user_asm("strb", "sttrb", "%w", __pu_val, (ptr),	\
@@ -229,8 +241,7 @@ do {									\
 	default:							\
 		BUILD_BUG();						\
 	}								\
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_ALT_PAN_NOT_UAO,\
-			CONFIG_ARM64_PAN));				\
+	uaccess_disable(ARM64_ALT_PAN_NOT_UAO);				\
 } while (0)
 
 #define __put_user(x, ptr)						\
diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index 42ffdb54e162..3aaf2fafbc8a 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -281,9 +281,9 @@ static void __init register_insn_emulation_sysctl(struct ctl_table *table)
  * Error-checking SWP macros implemented using ldxr{b}/stxr{b}
  */
 #define __user_swpX_asm(data, addr, res, temp, B)		\
+do {								\
+	uaccess_enable(ARM64_HAS_PAN);				\
 	__asm__ __volatile__(					\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,	\
-		    CONFIG_ARM64_PAN)				\
 	"0:	ldxr"B"		%w2, [%3]\n"			\
 	"1:	stxr"B"		%w0, %w1, [%3]\n"		\
 	"	cbz		%w0, 2f\n"			\
@@ -299,11 +299,11 @@ static void __init register_insn_emulation_sysctl(struct ctl_table *table)
 	"	.popsection"					\
 	_ASM_EXTABLE(0b, 4b)					\
 	_ASM_EXTABLE(1b, 4b)					\
-	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,	\
-		CONFIG_ARM64_PAN)				\
 	: "=&r" (res), "+r" (data), "=&r" (temp)		\
 	: "r" (addr), "i" (-EAGAIN), "i" (-EFAULT)		\
-	: "memory")
+	: "memory");						\
+	uaccess_disable(ARM64_HAS_PAN);				\
+} while (0)
 
 #define __user_swp_asm(data, addr, res, temp) \
 	__user_swpX_asm(data, addr, res, temp, "")
diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index 5d1cad3ce6d6..10d7501a5ce1 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -17,7 +17,6 @@
  */
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
 #include <asm/assembler.h>
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
@@ -33,8 +32,7 @@
  * Alignment fixed up by hardware.
  */
 ENTRY(__clear_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable x2, x3, x4
 	mov	x2, x1			// save the size for fixup return
 	subs	x1, x1, #8
 	b.mi	2f
@@ -54,8 +52,7 @@ uao_user_alternative 9f, strh, sttrh, wzr, x0, 2
 	b.mi	5f
 uao_user_alternative 9f, strb, sttrb, wzr, x0, 0
 5:	mov	x0, #0
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable x2
 	ret
 ENDPROC(__clear_user)
 
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 0b90497d4424..0ba4147fdff8 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -16,7 +16,6 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
 #include <asm/assembler.h>
 #include <asm/cache.h>
 #include <asm/cpufeature.h>
@@ -67,12 +66,10 @@
 
 end	.req	x5
 ENTRY(__arch_copy_from_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable x3, x4, x6
 	add	end, x0, x2
 #include "copy_template.S"
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable x3
 	mov	x0, #0				// Nothing to copy
 	ret
 ENDPROC(__arch_copy_from_user)
diff --git a/arch/arm64/lib/copy_in_user.S b/arch/arm64/lib/copy_in_user.S
index f7292dd08c84..ecbdaf6aacb8 100644
--- a/arch/arm64/lib/copy_in_user.S
+++ b/arch/arm64/lib/copy_in_user.S
@@ -18,7 +18,6 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
 #include <asm/assembler.h>
 #include <asm/cache.h>
 #include <asm/cpufeature.h>
@@ -68,12 +67,10 @@
 
 end	.req	x5
 ENTRY(__copy_in_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable x3, x4, x6
 	add	end, x0, x2
 #include "copy_template.S"
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable x3
 	mov	x0, #0
 	ret
 ENDPROC(__copy_in_user)
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 7a7efe255034..5ae01cbbf333 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -16,7 +16,6 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
 #include <asm/assembler.h>
 #include <asm/cache.h>
 #include <asm/cpufeature.h>
@@ -66,12 +65,10 @@
 
 end	.req	x5
 ENTRY(__arch_copy_to_user)
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_enable x3, x4, x6
 	add	end, x0, x2
 #include "copy_template.S"
-ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_ALT_PAN_NOT_UAO, \
-	    CONFIG_ARM64_PAN)
+	uaccess_disable x3
 	mov	x0, #0
 	ret
 ENDPROC(__arch_copy_to_user)
