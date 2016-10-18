Reply-To: kernel-hardening@lists.openwall.com
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 18 Oct 2016 16:59:21 +0200
Message-Id: <1476802761-24340-3-git-send-email-colin@cvidal.org>
In-Reply-To: <1476802761-24340-1-git-send-email-colin@cvidal.org>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
Subject: [kernel-hardening] [RFC 2/2] arm: implementation for HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
Cc: Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds arm-specific code in order to support HARDENED_ATOMIC
feature. When overflow is detected in atomic_t, atomic64_t or
atomic_long_t, an exception is raised and call
hardened_atomic_overflow.

Signed-off-by: Colin Vidal <colin@cvidal.org>
---
 arch/arm/Kconfig              |   1 +
 arch/arm/include/asm/atomic.h | 434 +++++++++++++++++++++++++++++-------------
 arch/arm/mm/fault.c           |  15 ++
 3 files changed, 320 insertions(+), 130 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b5d529f..fcf4a64 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -36,6 +36,7 @@ config ARM
 	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_HARDENED_USERCOPY
+	select HAVE_ARCH_HARDENED_ATOMIC
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 66d0e21..fdaee17 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -17,18 +17,52 @@
 #include <linux/irqflags.h>
 #include <asm/barrier.h>
 #include <asm/cmpxchg.h>
+#include <linux/bug.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_HARDENED_ATOMIC
+#define HARDENED_ATOMIC_INSN "bkpt 0xf103"
+#define _ASM_EXTABLE(from, to)			\
+	".pushsection __ex_table,\"a\"\n"	\
+	".align 3\n"				\
+	".long "#from","#to"\n"			\
+	".popsection"
+#define __OVERFLOW_POST				\
+	"bvc 3f\n"				\
+	"2: "HARDENED_ATOMIC_INSN"\n"		\
+	"3:\n"
+#define __OVERFLOW_POST_RETURN			\
+	"bvc 3f\n"				\
+	"mov %0,%1\n"				\
+	"2: "HARDENED_ATOMIC_INSN"\n"		\
+	"3:\n"
+#define __OVERFLOW_EXTABLE			\
+	"4:\n"					\
+	_ASM_EXTABLE(2b, 4b)
+#else
+#define __OVERFLOW_POST
+#define __OVERFLOW_POST_RETURN
+#define __OVERFLOW_EXTABLE
+#endif
+
 /*
  * On ARM, ordinary assignment (str instruction) doesn't clear the local
  * strex/ldrex monitor on some implementations. The reason we can use it for
  * atomic_set() is the clrex or dummy strex done on every exception return.
  */
 #define atomic_read(v)	READ_ONCE((v)->counter)
+static inline int atomic_read_wrap(const atomic_wrap_t *v)
+{
+	return atomic_read(v);
+}
 #define atomic_set(v,i)	WRITE_ONCE(((v)->counter), (i))
+static inline void atomic_set_wrap(atomic_wrap_t *v, int i)
+{
+	atomic_set(v, i);
+}
 
 #if __LINUX_ARM_ARCH__ >= 6
 
@@ -38,38 +72,46 @@
  * to ensure that the update happens.
  */
 
-#define ATOMIC_OP(op, c_op, asm_op)					\
-static inline void atomic_##op(int i, atomic_t *v)			\
+#define __ATOMIC_OP(op, suffix, c_op, asm_op, post_op, extable)		\
+static inline void atomic_##op##suffix(int i, atomic##suffix##_t *v)	\
 {									\
 	unsigned long tmp;						\
 	int result;							\
 									\
 	prefetchw(&v->counter);						\
-	__asm__ __volatile__("@ atomic_" #op "\n"			\
+	__asm__ __volatile__("@ atomic_" #op #suffix "\n"		\
 "1:	ldrex	%0, [%3]\n"						\
 "	" #asm_op "	%0, %0, %4\n"					\
+        post_op                 					\
 "	strex	%1, %0, [%3]\n"						\
 "	teq	%1, #0\n"						\
-"	bne	1b"							\
+"	bne	1b\n"							\
+        extable                 					\
 	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
 	: "r" (&v->counter), "Ir" (i)					\
 	: "cc");							\
 }									\
 
-#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
-static inline int atomic_##op##_return_relaxed(int i, atomic_t *v)	\
+#define ATOMIC_OP(op, c_op, asm_op)		                        \
+	__ATOMIC_OP(op, _wrap, c_op, asm_op, , )			\
+	__ATOMIC_OP(op, , c_op, asm_op##s, __OVERFLOW_POST, __OVERFLOW_EXTABLE)
+
+#define __ATOMIC_OP_RETURN(op, suffix, c_op, asm_op, post_op, extable)	\
+static inline int atomic_##op##_return##suffix##_relaxed(int i, atomic##suffix##_t *v) \
 {									\
 	unsigned long tmp;						\
 	int result;							\
 									\
 	prefetchw(&v->counter);						\
 									\
-	__asm__ __volatile__("@ atomic_" #op "_return\n"		\
+	__asm__ __volatile__("@ atomic_" #op "_return" #suffix "\n"	\
 "1:	ldrex	%0, [%3]\n"						\
 "	" #asm_op "	%0, %0, %4\n"					\
+        post_op                 					\
 "	strex	%1, %0, [%3]\n"						\
 "	teq	%1, #0\n"						\
-"	bne	1b"							\
+"	bne	1b\n"							\
+        extable                 					\
 	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
 	: "r" (&v->counter), "Ir" (i)					\
 	: "cc");							\
@@ -77,6 +119,11 @@ static inline int atomic_##op##_return_relaxed(int i, atomic_t *v)	\
 	return result;							\
 }
 
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)	                        \
+	__ATOMIC_OP_RETURN(op, _wrap, c_op, asm_op, , )			\
+	__ATOMIC_OP_RETURN(op, , c_op, asm_op##s,			\
+			   __OVERFLOW_POST_RETURN, __OVERFLOW_EXTABLE)
+
 #define ATOMIC_FETCH_OP(op, c_op, asm_op)				\
 static inline int atomic_fetch_##op##_relaxed(int i, atomic_t *v)	\
 {									\
@@ -108,26 +155,34 @@ static inline int atomic_fetch_##op##_relaxed(int i, atomic_t *v)	\
 #define atomic_fetch_or_relaxed		atomic_fetch_or_relaxed
 #define atomic_fetch_xor_relaxed	atomic_fetch_xor_relaxed
 
-static inline int atomic_cmpxchg_relaxed(atomic_t *ptr, int old, int new)
-{
-	int oldval;
-	unsigned long res;
-
-	prefetchw(&ptr->counter);
-
-	do {
-		__asm__ __volatile__("@ atomic_cmpxchg\n"
-		"ldrex	%1, [%3]\n"
-		"mov	%0, #0\n"
-		"teq	%1, %4\n"
-		"strexeq %0, %5, [%3]\n"
-		    : "=&r" (res), "=&r" (oldval), "+Qo" (ptr->counter)
-		    : "r" (&ptr->counter), "Ir" (old), "r" (new)
-		    : "cc");
-	} while (res);
-
-	return oldval;
+#define __ATOMIC_CMPXCHG_RELAXED(suffix)			       	\
+static inline int atomic_cmpxchg##suffix##_relaxed(atomic##suffix##_t *ptr, \
+						   int old, int new)	\
+{									\
+	int oldval;                                                     \
+	unsigned long res;                                              \
+									\
+	prefetchw(&ptr->counter);					\
+									\
+	do {								\
+	        __asm__ __volatile__("@ atomic_cmpxchg" #suffix "\n"	\
+		"ldrex	%1, [%3]\n"					\
+		"mov	%0, #0\n"					\
+		"teq	%1, %4\n"					\
+		"strexeq %0, %5, [%3]\n"				\
+		    : "=&r" (res), "=&r" (oldval), "+Qo" (ptr->counter) \
+		    : "r" (&ptr->counter), "Ir" (old), "r" (new)        \
+		    : "cc");                                            \
+	} while (res);							\
+									\
+	return oldval;							\
 }
+
+__ATOMIC_CMPXCHG_RELAXED()
+__ATOMIC_CMPXCHG_RELAXED(_wrap)
+
+#undef __ATOMIC_CMPXCHG_RELAXED
+
 #define atomic_cmpxchg_relaxed		atomic_cmpxchg_relaxed
 
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
@@ -141,12 +196,21 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	__asm__ __volatile__ ("@ atomic_add_unless\n"
 "1:	ldrex	%0, [%4]\n"
 "	teq	%0, %5\n"
-"	beq	2f\n"
-"	add	%1, %0, %6\n"
+"	beq	4f\n"
+"	adds	%1, %0, %6\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+"       bvc 3f\n"
+"2:     "HARDENED_ATOMIC_INSN"\n"
+"3:\n"
+#endif
 "	strex	%2, %1, [%4]\n"
 "	teq	%2, #0\n"
 "	bne	1b\n"
-"2:"
+"4:"
+#ifdef CONFIG_HARDENED_ATOMIC
+        _ASM_EXTABLE(2b, 4b)
+#endif
 	: "=&r" (oldval), "=&r" (newval), "=&r" (tmp), "+Qo" (v->counter)
 	: "r" (&v->counter), "r" (u), "r" (a)
 	: "cc");
@@ -163,8 +227,8 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #error SMP not supported on pre-ARMv6 CPUs
 #endif
 
-#define ATOMIC_OP(op, c_op, asm_op)					\
-static inline void atomic_##op(int i, atomic_t *v)			\
+#define __ATOMIC_OP(op, suffix, c_op, asm_op)				\
+static inline void atomic_##op##suffix(int i, atomic##suffix##_t *v)	\
 {									\
 	unsigned long flags;						\
 									\
@@ -173,8 +237,12 @@ static inline void atomic_##op(int i, atomic_t *v)			\
 	raw_local_irq_restore(flags);					\
 }									\
 
-#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
-static inline int atomic_##op##_return(int i, atomic_t *v)		\
+#define ATOMIC_OP(op, c_op, asm_op)		                        \
+	__ATOMIC_OP(op, _wrap, c_op, asm_op)				\
+	__ATOMIC_OP(op, , c_op, asm_op)
+
+#define __ATOMIC_OP_RETURN(op, suffix, c_op, asm_op)			\
+static inline int atomic_##op##_return##suffix(int i, atomic##suffix##_t *v) \
 {									\
 	unsigned long flags;						\
 	int val;							\
@@ -187,6 +255,10 @@ static inline int atomic_##op##_return(int i, atomic_t *v)		\
 	return val;							\
 }
 
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)	                        \
+	__ATOMIC_OP_RETURN(op, wrap, c_op, asm_op)			\
+	__ATOMIC_OP_RETURN(op, , c_op, asm_op)
+
 #define ATOMIC_FETCH_OP(op, c_op, asm_op)				\
 static inline int atomic_fetch_##op(int i, atomic_t *v)			\
 {									\
@@ -215,6 +287,11 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return ret;
 }
 
+static inline int atomic_cmpxchg_wrap(atomic_wrap_t *v, int old, int new)
+{
+	return atomic_cmpxchg((atomic_t *)v, old, new);
+}
+
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int c, old;
@@ -227,6 +304,11 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #endif /* __LINUX_ARM_ARCH__ */
 
+static inline int __atomic_add_unless_wrap(atomic_wrap_t *v, int a, int u)
+{
+	return __atomic_add_unless((atomic_t *)v, a, u);
+}
+
 #define ATOMIC_OPS(op, c_op, asm_op)					\
 	ATOMIC_OP(op, c_op, asm_op)					\
 	ATOMIC_OP_RETURN(op, c_op, asm_op)				\
@@ -250,18 +332,30 @@ ATOMIC_OPS(xor, ^=, eor)
 #undef ATOMIC_OPS
 #undef ATOMIC_FETCH_OP
 #undef ATOMIC_OP_RETURN
+#undef __ATOMIC_OP_RETURN
 #undef ATOMIC_OP
+#undef __ATOMIC_OP
 
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
+#define atomic_xchg_wrap(v, new) atomic_xchg(v, new)
 #define atomic_inc(v)		atomic_add(1, v)
+static inline void atomic_inc_wrap(atomic_wrap_t *v)
+{
+	atomic_add_wrap(1, v);
+}
 #define atomic_dec(v)		atomic_sub(1, v)
+static inline void atomic_dec_wrap(atomic_wrap_t *v)
+{
+	atomic_sub_wrap(1, v);
+}
 
 #define atomic_inc_and_test(v)	(atomic_add_return(1, v) == 0)
 #define atomic_dec_and_test(v)	(atomic_sub_return(1, v) == 0)
 #define atomic_inc_return_relaxed(v)    (atomic_add_return_relaxed(1, v))
+#define atomic_inc_return_wrap_relaxed(v) (atomic_add_return_wrap_relaxed(1, v))
 #define atomic_dec_return_relaxed(v)    (atomic_sub_return_relaxed(1, v))
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
+#define atomic_sub_and_test_wrap(i, v) (atomic_sub_return_wrap(i, v) == 0)
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
@@ -270,62 +364,81 @@ typedef struct {
 	long long counter;
 } atomic64_t;
 
+#ifdef CONFIG_HARDENED_ATOMIC
+typedef struct {
+	long long counter;
+} atomic64_wrap_t;
+#else
+typedef atomic64_t atomic64_wrap_t;
+#endif
+
 #define ATOMIC64_INIT(i) { (i) }
 
-#ifdef CONFIG_ARM_LPAE
-static inline long long atomic64_read(const atomic64_t *v)
-{
-	long long result;
+#define __ATOMIC64_READ(suffix, asm_op)					\
+static inline long long						        \
+atomic64_read##suffix(const atomic64##suffix##_t *v)			\
+{						                        \
+	long long result;                                               \
+									\
+	__asm__ __volatile__("@ atomic64_read" #suffix "\n"		\
+"	" #asm_op " %0, %H0, [%1]"					        \
+	: "=&r" (result)						\
+	: "r" (&v->counter), "Qo" (v->counter)	                        \
+	);         							\
+									\
+	return result;							\
+}
 
-	__asm__ __volatile__("@ atomic64_read\n"
-"	ldrd	%0, %H0, [%1]"
-	: "=&r" (result)
-	: "r" (&v->counter), "Qo" (v->counter)
-	);
+#ifdef CONFIG_ARM_LPAE
+__ATOMIC64_READ(, ldrd)
+__ATOMIC64_READ(wrap, ldrd)
 
-	return result;
+#define __ATOMIC64_SET(suffix)					        \
+static inline void atomic64_set##suffix(atomic64##suffix##_t *v, long long i) \
+{									\
+        __asm__ __volatile__("@ atomic64_set" #suffix "\n"		\
+"	strd	%2, %H2, [%1]"					        \
+	: "=Qo" (v->counter)						\
+	: "r" (&v->counter), "r" (i)		                        \
+	);							        \
 }
 
-static inline void atomic64_set(atomic64_t *v, long long i)
-{
-	__asm__ __volatile__("@ atomic64_set\n"
-"	strd	%2, %H2, [%1]"
-	: "=Qo" (v->counter)
-	: "r" (&v->counter), "r" (i)
-	);
-}
-#else
-static inline long long atomic64_read(const atomic64_t *v)
-{
-	long long result;
+__ATOMIC64_SET()
+__ATOMIC64_SET(_wrap)
 
-	__asm__ __volatile__("@ atomic64_read\n"
-"	ldrexd	%0, %H0, [%1]"
-	: "=&r" (result)
-	: "r" (&v->counter), "Qo" (v->counter)
-	);
+#undef __ATOMIC64
 
-	return result;
+#else
+__ATOMIC64_READ(, ldrexd)
+__ATOMIC64_READ(_wrap, ldrexd)
+
+#define __ATOMIC64_SET(suffix)					        \
+static inline void atomic64_set##suffix(atomic64##suffix##_t *v, long long i) \
+{									\
+	long long tmp;                                                  \
+									\
+	prefetchw(&v->counter);						\
+	__asm__ __volatile__("@ atomic64_set" #suffix"\n"               \
+"1:	ldrexd	%0, %H0, [%2]\n"                                        \
+"	strexd	%0, %3, %H3, [%2]\n"                                    \
+"	teq	%0, #0\n"                                               \
+"	bne	1b"                                                     \
+	: "=&r" (tmp), "=Qo" (v->counter)				\
+	: "r" (&v->counter), "r" (i)		                        \
+	: "cc");                                                        \
 }
 
-static inline void atomic64_set(atomic64_t *v, long long i)
-{
-	long long tmp;
+__ATOMIC64_SET()
+__ATOMIC64_SET(_wrap)
+
+#undef __ATOMIC64_SET
 
-	prefetchw(&v->counter);
-	__asm__ __volatile__("@ atomic64_set\n"
-"1:	ldrexd	%0, %H0, [%2]\n"
-"	strexd	%0, %3, %H3, [%2]\n"
-"	teq	%0, #0\n"
-"	bne	1b"
-	: "=&r" (tmp), "=Qo" (v->counter)
-	: "r" (&v->counter), "r" (i)
-	: "cc");
-}
 #endif
 
-#define ATOMIC64_OP(op, op1, op2)					\
-static inline void atomic64_##op(long long i, atomic64_t *v)		\
+#undef __ATOMIC64_READ
+
+#define __ATOMIC64_OP(op, suffix, op1, op2, post_op, extable)		\
+static inline void atomic64_##op##suffix(long long i, atomic64##suffix##_t *v) \
 {									\
 	long long result;						\
 	unsigned long tmp;						\
@@ -335,17 +448,31 @@ static inline void atomic64_##op(long long i, atomic64_t *v)		\
 "1:	ldrexd	%0, %H0, [%3]\n"					\
 "	" #op1 " %Q0, %Q0, %Q4\n"					\
 "	" #op2 " %R0, %R0, %R4\n"					\
+        post_op					                        \
 "	strexd	%1, %0, %H0, [%3]\n"					\
 "	teq	%1, #0\n"						\
-"	bne	1b"							\
+"	bne	1b\n"							\
+	extable                                                         \
 	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
 	: "r" (&v->counter), "r" (i)					\
 	: "cc");							\
-}									\
+}
 
-#define ATOMIC64_OP_RETURN(op, op1, op2)				\
+#define ATOMIC64_OP(op, op1, op2)		                        \
+	__ATOMIC64_OP(op, _wrap, op1, op2, , )				\
+	__ATOMIC64_OP(op, , op1, op2##s, __OVERFLOW_POST, __OVERFLOW_EXTABLE)
+
+#undef __OVERFLOW_POST_RETURN
+#define __OVERFLOW_POST_RETURN			\
+	"bvc 3f\n"				\
+	"mov %0, %1\n"				\
+	"mov %H0, %H1\n"			\
+	"2: "HARDENED_ATOMIC_INSN"\n"		\
+	"3:\n"
+
+#define __ATOMIC64_OP_RETURN(op, suffix, op1, op2, post_op, extable)	\
 static inline long long							\
-atomic64_##op##_return_relaxed(long long i, atomic64_t *v)		\
+atomic64_##op##_return##suffix##_relaxed(long long i, atomic64##suffix##_t *v) \
 {									\
 	long long result;						\
 	unsigned long tmp;						\
@@ -356,9 +483,11 @@ atomic64_##op##_return_relaxed(long long i, atomic64_t *v)		\
 "1:	ldrexd	%0, %H0, [%3]\n"					\
 "	" #op1 " %Q0, %Q0, %Q4\n"					\
 "	" #op2 " %R0, %R0, %R4\n"					\
+	post_op                                                         \
 "	strexd	%1, %0, %H0, [%3]\n"					\
 "	teq	%1, #0\n"						\
-"	bne	1b"							\
+"	bne	1b\n"							\
+	extable                                                         \
 	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
 	: "r" (&v->counter), "r" (i)					\
 	: "cc");							\
@@ -366,6 +495,11 @@ atomic64_##op##_return_relaxed(long long i, atomic64_t *v)		\
 	return result;							\
 }
 
+#define ATOMIC64_OP_RETURN(op, op1, op2)	                        \
+	__ATOMIC64_OP_RETURN(op, _wrap, op1, op2, , )			\
+	__ATOMIC64_OP_RETURN(op, , op1, op2##s, __OVERFLOW_POST_RETURN, \
+			     __OVERFLOW_EXTABLE)
+
 #define ATOMIC64_FETCH_OP(op, op1, op2)					\
 static inline long long							\
 atomic64_fetch_##op##_relaxed(long long i, atomic64_t *v)		\
@@ -422,70 +556,98 @@ ATOMIC64_OPS(xor, eor, eor)
 #undef ATOMIC64_OPS
 #undef ATOMIC64_FETCH_OP
 #undef ATOMIC64_OP_RETURN
+#undef __ATOMIC64_OP_RETURN
 #undef ATOMIC64_OP
-
-static inline long long
-atomic64_cmpxchg_relaxed(atomic64_t *ptr, long long old, long long new)
-{
-	long long oldval;
-	unsigned long res;
-
-	prefetchw(&ptr->counter);
-
-	do {
-		__asm__ __volatile__("@ atomic64_cmpxchg\n"
-		"ldrexd		%1, %H1, [%3]\n"
-		"mov		%0, #0\n"
-		"teq		%1, %4\n"
-		"teqeq		%H1, %H4\n"
-		"strexdeq	%0, %5, %H5, [%3]"
-		: "=&r" (res), "=&r" (oldval), "+Qo" (ptr->counter)
-		: "r" (&ptr->counter), "r" (old), "r" (new)
-		: "cc");
-	} while (res);
-
-	return oldval;
+#undef __ATOMIC64_OP
+#undef __OVERFLOW_EXTABLE
+#undef __OVERFLOW_POST_RETURN
+#undef __OVERFLOW_RETURN
+
+#define __ATOMIC64_CMPXCHG_RELAXED(suffix)	                        \
+static inline long long	atomic64_cmpxchg##suffix##_relaxed(             \
+	atomic64##suffix##_t *ptr, long long old, long long new)	\
+{									\
+	long long oldval;                                               \
+	unsigned long res;						\
+									\
+	prefetchw(&ptr->counter);					\
+									\
+	do {								\
+		__asm__ __volatile__("@ atomic64_cmpxchg" #suffix "\n"  \
+		"ldrexd		%1, %H1, [%3]\n"			\
+		"mov		%0, #0\n"				\
+		"teq		%1, %4\n"				\
+		"teqeq		%H1, %H4\n"				\
+		"strexdeq	%0, %5, %H5, [%3]"			\
+		: "=&r" (res), "=&r" (oldval), "+Qo" (ptr->counter)     \
+		: "r" (&ptr->counter), "r" (old), "r" (new)             \
+		: "cc");                                                \
+	} while (res);							\
+									\
+	return oldval;							\
 }
-#define atomic64_cmpxchg_relaxed	atomic64_cmpxchg_relaxed
 
-static inline long long atomic64_xchg_relaxed(atomic64_t *ptr, long long new)
-{
-	long long result;
-	unsigned long tmp;
-
-	prefetchw(&ptr->counter);
+__ATOMIC64_CMPXCHG_RELAXED()
+__ATOMIC64_CMPXCHG_RELAXED(_wrap)
+#define atomic64_cmpxchg_relaxed	atomic64_cmpxchg_relaxed
 
-	__asm__ __volatile__("@ atomic64_xchg\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	strexd	%1, %4, %H4, [%3]\n"
-"	teq	%1, #0\n"
-"	bne	1b"
-	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)
-	: "r" (&ptr->counter), "r" (new)
-	: "cc");
+#undef __ATOMIC64_CMPXCHG_RELAXED
 
-	return result;
+#define __ATOMIC64_XCHG_RELAXED(suffix)					\
+static inline long long atomic64_xchg##suffix##_relaxed(                \
+	atomic64##suffix##_t *ptr, long long new)			\
+{									\
+	long long result;                                               \
+	unsigned long tmp;						\
+									\
+	prefetchw(&ptr->counter);					\
+									\
+	__asm__ __volatile__("@ atomic64_xchg" #suffix "\n"		\
+"1:	ldrexd	%0, %H0, [%3]\n"                                        \
+"	strexd	%1, %4, %H4, [%3]\n"                                    \
+"	teq	%1, #0\n"                                               \
+"	bne	1b"                                                     \
+	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)             \
+	: "r" (&ptr->counter), "r" (new)                                \
+	: "cc");                                                        \
+									\
+	return result;							\
 }
+
+__ATOMIC64_XCHG_RELAXED()
+__ATOMIC64_XCHG_RELAXED(_wrap)
 #define atomic64_xchg_relaxed		atomic64_xchg_relaxed
 
+#undef __ATOMIC64_XCHG_RELAXED
+
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long long result;
-	unsigned long tmp;
+	u64 tmp;
 
 	smp_mb();
 	prefetchw(&v->counter);
 
 	__asm__ __volatile__("@ atomic64_dec_if_positive\n"
-"1:	ldrexd	%0, %H0, [%3]\n"
-"	subs	%Q0, %Q0, #1\n"
-"	sbc	%R0, %R0, #0\n"
+"1:	ldrexd	%1, %H1, [%3]\n"
+"	subs	%Q0, %Q1, #1\n"
+"	sbcs	%R0, %R1, #0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+"	bvc	3f\n"
+"	mov	%Q0, %Q1\n"
+"	mov	%R0, %R1\n"
+"2:	"HARDENED_ATOMIC_INSN"\n"
+"3:\n"
+#endif
 "	teq	%R0, #0\n"
-"	bmi	2f\n"
+"	bmi	4f\n"
 "	strexd	%1, %0, %H0, [%3]\n"
 "	teq	%1, #0\n"
 "	bne	1b\n"
-"2:"
+"4:\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+       _ASM_EXTABLE(2b, 4b)
+#endif
 	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)
 	: "r" (&v->counter)
 	: "cc");
@@ -509,13 +671,21 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 "	teq	%0, %5\n"
 "	teqeq	%H0, %H5\n"
 "	moveq	%1, #0\n"
-"	beq	2f\n"
+"	beq	4f\n"
 "	adds	%Q0, %Q0, %Q6\n"
-"	adc	%R0, %R0, %R6\n"
+"	adcs	%R0, %R0, %R6\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+"       bvc     3f\n"
+"2:     "HARDENED_ATOMIC_INSN"\n"
+"3:\n"
+#endif
 "	strexd	%2, %0, %H0, [%4]\n"
 "	teq	%2, #0\n"
 "	bne	1b\n"
-"2:"
+"4:\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+       _ASM_EXTABLE(2b, 4b)
+#endif
 	: "=&r" (val), "+r" (ret), "=&r" (tmp), "+Qo" (v->counter)
 	: "r" (&v->counter), "r" (u), "r" (a)
 	: "cc");
@@ -529,6 +699,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 #define atomic64_inc(v)			atomic64_add(1LL, (v))
 #define atomic64_inc_return_relaxed(v)	atomic64_add_return_relaxed(1LL, (v))
+#define atomic64_inc_return_wrap_relaxed(v) atomic64_add_return_wrap_relaxed(1LL, v)
 #define atomic64_inc_and_test(v)	(atomic64_inc_return(v) == 0)
 #define atomic64_sub_and_test(a, v)	(atomic64_sub_return((a), (v)) == 0)
 #define atomic64_dec(v)			atomic64_sub(1LL, (v))
@@ -536,6 +707,9 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
 
+#define atomic64_inc_wrap(v) atomic64_add_wrap(1LL, v)
+#define atomic64_dec_wrap(v) atomic64_sub_wrap(1LL, v)
+
 #endif /* !CONFIG_GENERIC_ATOMIC64 */
 #endif
 #endif
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 3a2e678..ce8ee00 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -580,6 +580,21 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
 	const struct fsr_info *inf = ifsr_info + fsr_fs(ifsr);
 	struct siginfo info;
 
+#ifdef CONFIG_HARDENED_ATOMIC
+	if (fsr_fs(ifsr) == FAULT_CODE_DEBUG) {
+		unsigned long pc = instruction_pointer(regs);
+		unsigned int bkpt;
+
+		if (!probe_kernel_address((const unsigned int *)pc, bkpt) &&
+		    cpu_to_le32(bkpt) == 0xe12f1073) {
+			current->thread.error_code = ifsr;
+			current->thread.trap_no = 0;
+			hardened_atomic_overflow(regs);
+			fixup_exception(regs);
+			return;
+		}
+	}
+#endif
 	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
 		return;
 
-- 
2.7.4
