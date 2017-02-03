Message-Id: <20170203132737.566324209@infradead.org>
Date: Fri, 03 Feb 2017 14:26:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
References: <20170203132558.474916683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-try_atomic.patch
Subject: [kernel-hardening] [PATCH 4/5] atomic: Introduce atomic_try_cmpxchg()
To: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Add a new cmpxchg interface:

  bool try_cmpxchg(u{8,16,32,64} *ptr, u{8,16,32,64} *val, u{8,16,32,64} new);

Where the boolean returns the result of the compare; and thus if the
exchange happened; and in case of failure, the new value of *ptr is
returned in *val.

This allows simplification/improvement of loops like:

	for (;;) {
		new = val $op $imm;
		old = cmpxchg(ptr, val, new);
		if (old == val)
			break;
		val = old;
	}

into:

	for (;;) {
		new = val $op $imm;
		if (try_cmpxchg(ptr, &val, new))
			break;
	}

while also generating better code (GCC6 and onwards).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -186,6 +186,12 @@ static __always_inline int atomic_cmpxch
 	return cmpxchg(&v->counter, old, new);
 }
 
+#define atomic_try_cmpxchg atomic_try_cmpxchg
+static __always_inline bool atomic_try_cmpxchg(atomic_t *v, int *old, int new)
+{
+	return try_cmpxchg(&v->counter, old, new);
+}
+
 static inline int atomic_xchg(atomic_t *v, int new)
 {
 	return xchg(&v->counter, new);
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -153,6 +153,75 @@ extern void __add_wrong_size(void)
 #define cmpxchg_local(ptr, old, new)					\
 	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
 
+
+#define __raw_try_cmpxchg(_ptr, _pold, _new, size, lock)		\
+({									\
+	bool success;							\
+	__typeof__(_ptr) _old = (_pold);				\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	switch (size) {							\
+	case __X86_CASE_B:						\
+	{								\
+		volatile u8 *__ptr = (volatile u8 *)(_ptr);		\
+		asm volatile(lock "cmpxchgb %[new], %[ptr]"		\
+			     CC_SET(z)					\
+			     : CC_OUT(z) (success),			\
+			       [ptr] "+m" (*__ptr),			\
+			       [old] "+a" (__old)			\
+			     : [new] "q" (__new)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_W:						\
+	{								\
+		volatile u16 *__ptr = (volatile u16 *)(_ptr);		\
+		asm volatile(lock "cmpxchgw %[new], %[ptr]"		\
+			     CC_SET(z)					\
+			     : CC_OUT(z) (success),			\
+			       [ptr] "+m" (*__ptr),			\
+			       [old] "+a" (__old)			\
+			     : [new] "r" (__new)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_L:						\
+	{								\
+		volatile u32 *__ptr = (volatile u32 *)(_ptr);		\
+		asm volatile(lock "cmpxchgl %[new], %[ptr]"		\
+			     CC_SET(z)					\
+			     : CC_OUT(z) (success),			\
+			       [ptr] "+m" (*__ptr),			\
+			       [old] "+a" (__old)			\
+			     : [new] "r" (__new)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	case __X86_CASE_Q:						\
+	{								\
+		volatile u64 *__ptr = (volatile u64 *)(_ptr);		\
+		asm volatile(lock "cmpxchgq %[new], %[ptr]"		\
+			     CC_SET(z)					\
+			     : CC_OUT(z) (success),			\
+			       [ptr] "+m" (*__ptr),			\
+			       [old] "+a" (__old)			\
+			     : [new] "r" (__new)			\
+			     : "memory");				\
+		break;							\
+	}								\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	*_old = __old;							\
+	success;							\
+})
+
+#define __try_cmpxchg(ptr, pold, new, size)				\
+	__raw_try_cmpxchg((ptr), (pold), (new), (size), LOCK_PREFIX)
+
+#define try_cmpxchg(ptr, pold, new)					\
+	__try_cmpxchg((ptr), (pold), (new), sizeof(*(ptr)))
+
 /*
  * xadd() adds "inc" to "*ptr" and atomically returns the previous
  * value of "*ptr".
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -423,6 +423,28 @@
 #endif
 #endif /* atomic_cmpxchg_relaxed */
 
+#ifndef atomic_try_cmpxchg
+
+#define __atomic_try_cmpxchg(type, _p, _po, _n)				\
+({									\
+	typeof(_po) __po = (_po);					\
+	typeof(*(_po)) __o = *__po;					\
+	bool success = (atomic_cmpxchg##type((_p), __o, (_n)) == __o);	\
+	*__po = __o;							\
+	success;							\
+})
+
+#define atomic_try_cmpxchg(_p, _po, _n)		__atomic_try_cmpxchg(, _p, _po, _n)
+#define atomic_try_cmpxchg_relaxed(_p, _po, _n)	__atomic_try_cmpxchg(_relaxed, _p, _po, _n)
+#define atomic_try_cmpxchg_acquire(_p, _po, _n)	__atomic_try_cmpxchg(_acquire, _p, _po, _n)
+#define atomic_try_cmpxchg_release(_p, _po, _n)	__atomic_try_cmpxchg(_release, _p, _po, _n)
+
+#else /* atomic_try_cmpxchg */
+#define atomic_try_cmpxchg_relaxed	atomic_try_cmpxchg
+#define atomic_try_cmpxchg_acquire	atomic_try_cmpxchg
+#define atomic_try_cmpxchg_release	atomic_try_cmpxchg
+#endif /* atomic_try_cmpxchg */
+
 /* cmpxchg_relaxed */
 #ifndef cmpxchg_relaxed
 #define  cmpxchg_relaxed		cmpxchg
