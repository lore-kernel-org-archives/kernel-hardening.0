Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 10 Nov 2016 22:24:47 +0200
Message-Id: <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds x86-specific code in order to support
HARDENED_ATOMIC feature. When overflow is detected
in atomic_t or atomic_long_t types, the counter is
decremented back by one (to keep it at INT_MAX or
LONG_MAX) and issue is reported using BUG().
The side effect is that in both legitimate and
non-legitimate cases a counter cannot wrap.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 arch/x86/Kconfig                   |   1 +
 arch/x86/include/asm/atomic.h      | 315 +++++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/atomic64_32.h | 227 +++++++++++++++++++++++++-
 arch/x86/include/asm/atomic64_64.h | 219 +++++++++++++++++++++++++-
 arch/x86/include/asm/bitops.h      |   8 +-
 arch/x86/include/asm/cmpxchg.h     |  39 +++++
 arch/x86/include/asm/local.h       | 149 +++++++++++++++++-
 arch/x86/include/asm/preempt.h     |   2 +-
 arch/x86/include/asm/rmwcc.h       |  82 ++++++++--
 arch/x86/include/asm/rwsem.h       |  50 ++++++
 arch/x86/kernel/traps.c            |   4 +
 arch/x86/lib/atomic64_386_32.S     | 135 ++++++++++++++++
 arch/x86/lib/atomic64_cx8_32.S     |  78 ++++++++-
 13 files changed, 1260 insertions(+), 49 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bada636..1a68790 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -80,6 +80,7 @@ config X86
 	select HAVE_AOUT			if X86_32
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HARDENED_USERCOPY
+	select HAVE_ARCH_HARDENED_ATOMIC
 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN			if X86_64 && SPARSEMEM_VMEMMAP
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 14635c5..97d9156 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -27,6 +27,18 @@ static __always_inline int atomic_read(const atomic_t *v)
 }
 
 /**
+ * atomic_read_wrap - read atomic variable
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically reads the value of @v.
+ */
+static __always_inline int atomic_read_wrap(const atomic_wrap_t *v)
+{
+	return ACCESS_ONCE((v)->counter);
+}
+#define atomic_read_wrap atomic_read_wrap
+
+/**
  * atomic_set - set atomic variable
  * @v: pointer of type atomic_t
  * @i: required value
@@ -39,6 +51,19 @@ static __always_inline void atomic_set(atomic_t *v, int i)
 }
 
 /**
+ * atomic_set_wrap - set atomic variable
+ * @v: pointer of type atomic_wrap_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static __always_inline void atomic_set_wrap(atomic_wrap_t *v, int i)
+{
+	v->counter = i;
+}
+#define atomic_set_wrap atomic_set_wrap
+
+/**
  * atomic_add - add integer to atomic variable
  * @i: integer value to add
  * @v: pointer of type atomic_t
@@ -47,12 +72,35 @@ static __always_inline void atomic_set(atomic_t *v, int i)
  */
 static __always_inline void atomic_add(int i, atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "addl %1,%0"
+	asm volatile(LOCK_PREFIX "addl %1,%0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "subl %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     : "+m" (v->counter)
 		     : "ir" (i));
 }
 
 /**
+ * atomic_add_wrap - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically adds @i to @v.
+ */
+static __always_inline void atomic_add_wrap(int i, atomic_wrap_t *v)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0\n"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+#define atomic_add_wrap atomic_add_wrap
+
+/**
  * atomic_sub - subtract integer from atomic variable
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
@@ -61,12 +109,35 @@ static __always_inline void atomic_add(int i, atomic_t *v)
  */
 static __always_inline void atomic_sub(int i, atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "subl %1,%0"
+	asm volatile(LOCK_PREFIX "subl %1,%0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "addl %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     : "+m" (v->counter)
 		     : "ir" (i));
 }
 
 /**
+ * atomic_sub_wrap - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static __always_inline void atomic_sub_wrap(int i, atomic_wrap_t *v)
+{
+	asm volatile(LOCK_PREFIX "subl %1,%0\n"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+#define atomic_sub_wrap atomic_sub_wrap
+
+/**
  * atomic_sub_and_test - subtract value from variable and test result
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
@@ -77,10 +148,25 @@ static __always_inline void atomic_sub(int i, atomic_t *v)
  */
 static __always_inline bool atomic_sub_and_test(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, "er", i, "%0", e);
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", LOCK_PREFIX "addl", v->counter, "er", i, "%0", e);
 }
 
 /**
+ * atomic_sub_and_test_wrap - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static __always_inline bool atomic_sub_and_test_wrap(int i, atomic_wrap_t *v)
+{
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "subl", v->counter, "er", i, "%0", e);
+}
+#define atomic_sub_and_test_wrap atomic_sub_and_test_wrap
+
+/**
  * atomic_inc - increment atomic variable
  * @v: pointer of type atomic_t
  *
@@ -88,9 +174,30 @@ static __always_inline bool atomic_sub_and_test(int i, atomic_t *v)
  */
 static __always_inline void atomic_inc(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "incl %0"
+	asm volatile(LOCK_PREFIX "incl %0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "decl %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_inc_wrap - increment atomic variable
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically increments @v by 1.
+ */
+static __always_inline void atomic_inc_wrap(atomic_wrap_t *v)
+{
+	asm volatile(LOCK_PREFIX "incl %0\n"
 		     : "+m" (v->counter));
 }
+#define atomic_inc_wrap atomic_inc_wrap
 
 /**
  * atomic_dec - decrement atomic variable
@@ -100,11 +207,32 @@ static __always_inline void atomic_inc(atomic_t *v)
  */
 static __always_inline void atomic_dec(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "decl %0"
+	asm volatile(LOCK_PREFIX "decl %0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "incl %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     : "+m" (v->counter));
 }
 
 /**
+ * atomic_dec_wrap - decrement atomic variable
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static __always_inline void atomic_dec_wrap(atomic_wrap_t *v)
+{
+	asm volatile(LOCK_PREFIX "decl %0\n"
+		     : "+m" (v->counter));
+}
+#define atomic_dec_wrap atomic_dec_wrap
+
+/**
  * atomic_dec_and_test - decrement and test
  * @v: pointer of type atomic_t
  *
@@ -114,9 +242,15 @@ static __always_inline void atomic_dec(atomic_t *v)
  */
 static __always_inline bool atomic_dec_and_test(atomic_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", e);
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", LOCK_PREFIX "incl", v->counter, "%0", e);
 }
 
+static __always_inline bool atomic_dec_and_test_wrap(atomic_wrap_t *v)
+{
+	GEN_UNARY_RMWcc_wrap(LOCK_PREFIX "decl", v->counter, "%0", e);
+}
+#define atomic_dec_and_test_wrap atomic_dec_and_test_wrap
+
 /**
  * atomic_inc_and_test - increment and test
  * @v: pointer of type atomic_t
@@ -127,10 +261,24 @@ static __always_inline bool atomic_dec_and_test(atomic_t *v)
  */
 static __always_inline bool atomic_inc_and_test(atomic_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", v->counter, "%0", e);
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", LOCK_PREFIX "decl", v->counter, "%0", e);
 }
 
 /**
+ * atomic_inc_and_test_wrap - increment and test
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static __always_inline int atomic_inc_and_test_wrap(atomic_wrap_t *v)
+{
+	GEN_UNARY_RMWcc_wrap(LOCK_PREFIX "incl", v->counter, "%0", e);
+}
+#define atomic_inc_and_test_wrap atomic_inc_and_test_wrap
+
+/**
  * atomic_add_negative - add and test if negative
  * @i: integer value to add
  * @v: pointer of type atomic_t
@@ -141,9 +289,15 @@ static __always_inline bool atomic_inc_and_test(atomic_t *v)
  */
 static __always_inline bool atomic_add_negative(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, "er", i, "%0", s);
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", LOCK_PREFIX "subl", v->counter, "er", i, "%0", s);
 }
 
+static __always_inline bool atomic_add_negative_wrap(int i, atomic_wrap_t *v)
+{
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "addl", v->counter, "er", i, "%0", s);
+}
+#define atomic_add_negative_wrap atomic_add_negative_wrap
+
 /**
  * atomic_add_return - add integer and return
  * @i: integer value to add
@@ -153,8 +307,21 @@ static __always_inline bool atomic_add_negative(int i, atomic_t *v)
  */
 static __always_inline int atomic_add_return(int i, atomic_t *v)
 {
+	return i + xadd_check_overflow(&v->counter, i);
+}
+
+/**
+ * atomic_add_return_wrap - add integer and return
+ * @i: integer value to add
+ * @v: pointer of type atomic_wrap_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static __always_inline int atomic_add_return_wrap(int i, atomic_wrap_t *v)
+{
 	return i + xadd(&v->counter, i);
 }
+#define atomic_add_return_wrap atomic_add_return_wrap
 
 /**
  * atomic_sub_return - subtract integer and return
@@ -168,29 +335,70 @@ static __always_inline int atomic_sub_return(int i, atomic_t *v)
 	return atomic_add_return(-i, v);
 }
 
+static __always_inline int atomic_sub_return_wrap(int i, atomic_wrap_t *v)
+{
+	return atomic_add_return_wrap(-i, v);
+}
+#define atomic_sub_return_wrap atomic_sub_return_wrap
+
 #define atomic_inc_return(v)  (atomic_add_return(1, v))
+static __always_inline int atomic_inc_return_wrap(atomic_wrap_t *v)
+{
+	return atomic_add_return_wrap(1, v);
+}
+#define atomic_inc_return_wrap atomic_inc_return_wrap
+
 #define atomic_dec_return(v)  (atomic_sub_return(1, v))
+static __always_inline int atomic_dec_return_wrap(atomic_wrap_t *v)
+{
+	return atomic_sub_return_wrap(1, v);
+}
+#define atomic_dec_return_wrap atomic_dec_return_wrap
 
 static __always_inline int atomic_fetch_add(int i, atomic_t *v)
 {
+	return xadd_check_overflow(&v->counter, i);
+}
+
+static __always_inline int atomic_fetch_add_wrap(int i, atomic_wrap_t *v)
+{
 	return xadd(&v->counter, i);
 }
+#define atomic_fetch_add_wrap atomic_fetch_add_wrap
 
 static __always_inline int atomic_fetch_sub(int i, atomic_t *v)
 {
+	return xadd_check_overflow(&v->counter, -i);
+}
+
+static __always_inline int atomic_fetch_sub_wrap(int i, atomic_wrap_t *v)
+{
 	return xadd(&v->counter, -i);
 }
+#define atomic_fetch_sub_wrap atomic_fetch_sub_wrap
 
 static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	return cmpxchg(&v->counter, old, new);
 }
 
+static __always_inline int atomic_cmpxchg_wrap(atomic_wrap_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+#define atomic_cmpxchg_wrap atomic_cmpxchg_wrap
+
 static inline int atomic_xchg(atomic_t *v, int new)
 {
 	return xchg(&v->counter, new);
 }
 
+static inline int atomic_xchg_wrap(atomic_wrap_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
+#define atomic_xchg_wrap atomic_xchg_wrap
+
 #define ATOMIC_OP(op)							\
 static inline void atomic_##op(int i, atomic_t *v)			\
 {									\
@@ -236,12 +444,25 @@ ATOMIC_OPS(xor, ^)
  */
 static __always_inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-	int c, old;
+	int c, old, new;
 	c = atomic_read(v);
 	for (;;) {
 		if (unlikely(c == (u)))
 			break;
-		old = atomic_cmpxchg((v), c, c + (a));
+
+		asm volatile("addl %2,%0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+			     "jno 0f\n"
+			     "subl %2,%0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif
+
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
+		old = atomic_cmpxchg((v), c, new);
 		if (likely(old == c))
 			break;
 		c = old;
@@ -250,6 +471,80 @@ static __always_inline int __atomic_add_unless(atomic_t *v, int a, int u)
 }
 
 /**
+ * atomic_add_unless_wrap - add unless the number is already a given value
+ * @v: pointer of type atomic_wrap_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns the old value of @v.
+ */
+static __always_inline int atomic_add_unless_wrap(atomic_wrap_t *v,
+						    int a, int u)
+{
+	int c, old, new;
+	c = atomic_read_wrap(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+
+		asm volatile("addl %2,%0\n"
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
+		old = atomic_cmpxchg_wrap((v), c, new);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != u;
+}
+#define atomic_add_unless_wrap atomic_add_unless_wrap
+
+/**
++ * atomic_inc_not_zero_hint - increment if not null
++ * @v: pointer of type atomic_t
++ * @hint: probable value of the atomic before the increment
++ *
++ * This version of atomic_inc_not_zero() gives a hint of probable
++ * value of the atomic. This helps processor to not read the memory
++ * before doing the atomic read/modify/write cycle, lowering
++ * number of bus transactions on some arches.
++ *
++ * Returns: 0 if increment was not done, 1 otherwise.
++ */
+#define atomic_inc_not_zero_hint atomic_inc_not_zero_hint
+static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
+{
+	int val, c = hint, new;
+
+	/* sanity test, should be removed by compiler if hint is a constant */
+	if (!hint)
+		return __atomic_add_unless(v, 1, 0);
+
+	do {
+		asm volatile("incl %0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+			     "jno 0f\n"
+			     "decl %0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif
+
+			     : "=r" (new)
+			     : "0" (c));
+
+		val = atomic_cmpxchg((v), c, new);
+		if (val == c)
+			return 1;
+		c = val;
+	} while (c);
+
+	return 0;
+}
+
+/**
  * atomic_inc_short - increment of a short integer
  * @v: pointer to type int
  *
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 71d7705..a9281e8 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -11,6 +11,13 @@ typedef struct {
 	u64 __aligned(8) counter;
 } atomic64_t;
 
+#ifndef atomic64_wrap_t
+#define atomic64_wrap_t atomic64_wrap_t
+typedef struct {
+	u64 __aligned(8) counter;
+} atomic64_wrap_t;
+#endif
+
 #define ATOMIC64_INIT(val)	{ (val) }
 
 #define __ATOMIC64_DECL(sym) void atomic64_##sym(atomic64_t *, ...)
@@ -36,21 +43,31 @@ typedef struct {
 	ATOMIC64_DECL_ONE(sym##_386)
 
 ATOMIC64_DECL_ONE(add_386);
+ATOMIC64_DECL_ONE(add_wrap_386);
 ATOMIC64_DECL_ONE(sub_386);
+ATOMIC64_DECL_ONE(sub_wrap_386);
 ATOMIC64_DECL_ONE(inc_386);
+ATOMIC64_DECL_ONE(inc_wrap_386);
 ATOMIC64_DECL_ONE(dec_386);
+ATOMIC64_DECL_ONE(dec_wrap_386);
 #endif
 
 #define alternative_atomic64(f, out, in...) \
 	__alternative_atomic64(f, f, ASM_OUTPUT2(out), ## in)
 
 ATOMIC64_DECL(read);
+ATOMIC64_DECL(read_wrap);
 ATOMIC64_DECL(set);
+ATOMIC64_DECL(set_wrap);
 ATOMIC64_DECL(xchg);
 ATOMIC64_DECL(add_return);
+ATOMIC64_DECL(add_return_wrap);
 ATOMIC64_DECL(sub_return);
+ATOMIC64_DECL(sub_return_wrap);
 ATOMIC64_DECL(inc_return);
+ATOMIC64_DECL(inc_return_wrap);
 ATOMIC64_DECL(dec_return);
+ATOMIC64_DECL(dec_return_wrap);
 ATOMIC64_DECL(dec_if_positive);
 ATOMIC64_DECL(inc_not_zero);
 ATOMIC64_DECL(add_unless);
@@ -76,6 +93,22 @@ static inline long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n
 }
 
 /**
+ * atomic64_cmpxchg_wrap - cmpxchg atomic64 variable
+ * @p: pointer to type atomic64_wrap_t
+ * @o: expected value
+ * @n: new value
+ *
+ * Atomically sets @v to @n if it was equal to @o and returns
+ * the old value.
+ */
+
+static inline long long atomic64_cmpxchg_wrap(atomic64_wrap_t *v, long long o, long long n)
+{
+	return cmpxchg64(&v->counter, o, n);
+}
+#define atomic64_cmpxchg_wrap atomic64_cmpxchg_wrap
+
+/**
  * atomic64_xchg - xchg atomic64 variable
  * @v: pointer to type atomic64_t
  * @n: value to assign
@@ -95,6 +128,26 @@ static inline long long atomic64_xchg(atomic64_t *v, long long n)
 }
 
 /**
+ * atomic64_xchg_wrap - xchg atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ * @n: value to assign
+ *
+ * Atomically xchgs the value of @v to @n and returns
+ * the old value.
+ */
+static inline long long atomic64_xchg_wrap(atomic64_wrap_t *v, long long n)
+{
+	long long o;
+	unsigned high = (unsigned)(n >> 32);
+	unsigned low = (unsigned)n;
+	alternative_atomic64(xchg, "=&A" (o),
+			     "S" (v), "b" (low), "c" (high)
+			     : "memory");
+	return o;
+}
+#define atomic64_xchg_wrap atomic64_xchg_wrap
+
+/**
  * atomic64_set - set atomic64 variable
  * @v: pointer to type atomic64_t
  * @i: value to assign
@@ -111,6 +164,22 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 }
 
 /**
+ * atomic64_set_wrap - set atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ * @n: value to assign
+ *
+ * Atomically sets the value of @v to @n.
+ */
+static inline void atomic64_set_wrap(atomic64_wrap_t *v, long long i)
+{
+	unsigned high = (unsigned)(i >> 32);
+	unsigned low = (unsigned)i;
+	alternative_atomic64(set, /* no output */,
+			     "S" (v), "b" (low), "c" (high)
+			     : "eax", "edx", "memory");
+}
+
+/**
  * atomic64_read - read atomic64 variable
  * @v: pointer to type atomic64_t
  *
@@ -121,7 +190,20 @@ static inline long long atomic64_read(const atomic64_t *v)
 	long long r;
 	alternative_atomic64(read, "=&A" (r), "c" (v) : "memory");
 	return r;
- }
+}
+
+/**
+ * atomic64_read_wrap - read atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically reads the value of @v and returns it.
+ */
+static inline long long atomic64_read_wrap(const atomic64_wrap_t *v)
+{
+	long long r;
+	alternative_atomic64(read, "=&A" (r), "c" (v) : "memory");
+	return r;
+}
 
 /**
  * atomic64_add_return - add and return
@@ -138,6 +220,21 @@ static inline long long atomic64_add_return(long long i, atomic64_t *v)
 	return i;
 }
 
+/**
+ * atomic64_add_return_wrap - add and return
+ * @i: integer value to add
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically adds @i to @v and returns @i + *@v
+ */
+static inline long long atomic64_add_return_wrap(long long i, atomic64_wrap_t *v)
+{
+	alternative_atomic64(add_return_wrap,
+			     ASM_OUTPUT2("+A" (i), "+c" (v)),
+			     ASM_NO_INPUT_CLOBBER("memory"));
+	return i;
+}
+
 /*
  * Other variants with different arithmetic operators:
  */
@@ -149,6 +246,14 @@ static inline long long atomic64_sub_return(long long i, atomic64_t *v)
 	return i;
 }
 
+static inline long long atomic64_sub_return_wrap(long long i, atomic64_wrap_t *v)
+{
+	alternative_atomic64(sub_return_wrap,
+			     ASM_OUTPUT2("+A" (i), "+c" (v)),
+			     ASM_NO_INPUT_CLOBBER("memory"));
+	return i;
+}
+
 static inline long long atomic64_inc_return(atomic64_t *v)
 {
 	long long a;
@@ -157,6 +262,14 @@ static inline long long atomic64_inc_return(atomic64_t *v)
 	return a;
 }
 
+static inline long long atomic64_inc_return_wrap(atomic64_wrap_t *v)
+{
+	long long a;
+	alternative_atomic64(inc_return_wrap, "=&A" (a),
+			     "S" (v) : "memory", "ecx");
+	return a;
+}
+
 static inline long long atomic64_dec_return(atomic64_t *v)
 {
 	long long a;
@@ -165,6 +278,14 @@ static inline long long atomic64_dec_return(atomic64_t *v)
 	return a;
 }
 
+static inline long long atomic64_dec_return_wrap(atomic64_wrap_t *v)
+{
+	long long a;
+	alternative_atomic64(dec_return_wrap, "=&A" (a),
+			     "S" (v) : "memory", "ecx");
+	return a;
+}
+
 /**
  * atomic64_add - add integer to atomic64 variable
  * @i: integer value to add
@@ -179,6 +300,23 @@ static inline long long atomic64_add(long long i, atomic64_t *v)
 			       ASM_NO_INPUT_CLOBBER("memory"));
 	return i;
 }
+#define atomic64_add_wrap atomic64_add_wrap
+
+
+/**
+ * atomic64_add_wrap - add integer to atomic64 variable
+ * @i: integer value to add
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline long long atomic64_add_wrap(long long i, atomic64_wrap_t *v)
+{
+	__alternative_atomic64(add_wrap, add_return_wrap,
+			       ASM_OUTPUT2("+A" (i), "+c" (v)),
+			       ASM_NO_INPUT_CLOBBER("memory"));
+	return i;
+}
 
 /**
  * atomic64_sub - subtract the atomic64 variable
@@ -196,6 +334,22 @@ static inline long long atomic64_sub(long long i, atomic64_t *v)
 }
 
 /**
+ * atomic64_sub_wrap - subtract the atomic64 variable
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline long long atomic64_sub_wrap(long long i, atomic64_wrap_t *v)
+{
+	__alternative_atomic64(sub_wrap, sub_return_wrap,
+			       ASM_OUTPUT2("+A" (i), "+c" (v)),
+			       ASM_NO_INPUT_CLOBBER("memory"));
+	return i;
+}
+#define atomic64_sub_wrap atomic64_sub_wrap
+
+/**
  * atomic64_sub_and_test - subtract value from variable and test result
  * @i: integer value to subtract
  * @v: pointer to type atomic64_t
@@ -209,6 +363,13 @@ static inline int atomic64_sub_and_test(long long i, atomic64_t *v)
 	return atomic64_sub_return(i, v) == 0;
 }
 
+static inline int atomic64_sub_and_test_wrap(long long i, atomic64_wrap_t *v)
+{
+	return atomic64_sub_return_wrap(i, v) == 0;
+}
+#define atomic64_sub_and_test_wrap atomic64_sub_and_test_wrap
+
+
 /**
  * atomic64_inc - increment atomic64 variable
  * @v: pointer to type atomic64_t
@@ -222,6 +383,19 @@ static inline void atomic64_inc(atomic64_t *v)
 }
 
 /**
+ * atomic64_inc_wrap - increment atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic64_inc_wrap(atomic64_wrap_t *v)
+{
+	__alternative_atomic64(inc_wrap, inc_return_wrap, /* no output */,
+			       "S" (v) : "memory", "eax", "ecx", "edx");
+}
+#define atomic64_inc_wrap atomic64_inc_wrap
+
+/**
  * atomic64_dec - decrement atomic64 variable
  * @v: pointer to type atomic64_t
  *
@@ -234,6 +408,19 @@ static inline void atomic64_dec(atomic64_t *v)
 }
 
 /**
+ * atomic64_dec_wrap - decrement atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic64_dec_wrap(atomic64_wrap_t *v)
+{
+	__alternative_atomic64(dec_wrap, dec_return_wrap, /* no output */,
+			       "S" (v) : "memory", "eax", "ecx", "edx");
+}
+#define atomic64_dec_wrap atomic64_dec_wrap
+
+/**
  * atomic64_dec_and_test - decrement and test
  * @v: pointer to type atomic64_t
  *
@@ -246,6 +433,13 @@ static inline int atomic64_dec_and_test(atomic64_t *v)
 	return atomic64_dec_return(v) == 0;
 }
 
+static inline int atomic64_dec_and_test_wrap(atomic64_wrap_t *v)
+{
+	return atomic64_dec_return_wrap(v) == 0;
+}
+#define atomic64_dec_and_test_wrap atomic64_dec_and_test_wrap
+
+
 /**
  * atomic64_inc_and_test - increment and test
  * @v: pointer to type atomic64_t
@@ -259,6 +453,12 @@ static inline int atomic64_inc_and_test(atomic64_t *v)
 	return atomic64_inc_return(v) == 0;
 }
 
+static inline int atomic64_inc_and_test_wrap(atomic64_wrap_t *v)
+{
+	return atomic64_inc_return_wrap(v) == 0;
+}
+#define atomic64_inc_and_test_wrap atomic64_inc_and_test_wrap
+
 /**
  * atomic64_add_negative - add and test if negative
  * @i: integer value to add
@@ -273,6 +473,12 @@ static inline int atomic64_add_negative(long long i, atomic64_t *v)
 	return atomic64_add_return(i, v) < 0;
 }
 
+static inline int atomic64_add_negative_wrap(long long i, atomic64_wrap_t *v)
+{
+	return atomic64_add_return_wrap(i, v) < 0;
+}
+#define atomic64_add_negative_wrap atomic64_add_negative_wrap
+
 /**
  * atomic64_add_unless - add unless the number is a given value
  * @v: pointer of type atomic64_t
@@ -292,6 +498,25 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 	return (int)a;
 }
 
+/**
+ * atomic64_add_unless_wrap - add unless the number is a given value
+ * @v: pointer of type atomic64_wrap_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if the add was done, zero otherwise.
+ */
+static inline int atomic64_add_unless_wrap(atomic64_wrap_t *v, long long a, long long u)
+{
+	unsigned low = (unsigned)u;
+	unsigned high = (unsigned)(u >> 32);
+	alternative_atomic64(add_unless,
+			     ASM_OUTPUT2("+A" (a), "+c" (low), "+D" (high)),
+			     "S" (v) : "memory");
+	return (int)a;
+}
+#define atomic64_add_unless_wrap atomic64_add_unless_wrap
 
 static inline int atomic64_inc_not_zero(atomic64_t *v)
 {
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 89ed2f6..c218ead 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -5,6 +5,13 @@
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 
+#ifndef atomic64_wrap_t
+#define atomic64_wrap_t atomic64_wrap_t
+typedef struct {
+	long counter;
+} atomic64_wrap_t;
+#endif
+
 /* The 64-bit atomic type */
 
 #define ATOMIC64_INIT(i)	{ (i) }
@@ -22,6 +29,19 @@ static inline long atomic64_read(const atomic64_t *v)
 }
 
 /**
+ * atomic64_read_wrap - read atomic64 variable
+ * @v: pointer of type atomic64_wrap_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+static inline long atomic64_read_wrap(const atomic64_wrap_t *v)
+{
+	return ACCESS_ONCE((v)->counter);
+}
+#define atomic64_read_wrap atomic64_read_wrap
+
+/**
  * atomic64_set - set atomic64 variable
  * @v: pointer to type atomic64_t
  * @i: required value
@@ -34,6 +54,19 @@ static inline void atomic64_set(atomic64_t *v, long i)
 }
 
 /**
+ * atomic64_set_wrap - set atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic64_set_wrap(atomic64_wrap_t *v, long i)
+{
+	v->counter = i;
+}
+#define atomic64_set_wrap atomic64_set_wrap
+
+/**
  * atomic64_add - add integer to atomic64 variable
  * @i: integer value to add
  * @v: pointer to type atomic64_t
@@ -42,10 +75,33 @@ static inline void atomic64_set(atomic64_t *v, long i)
  */
 static __always_inline void atomic64_add(long i, atomic64_t *v)
 {
+	asm volatile(LOCK_PREFIX "addq %1,%0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "subq %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
+ * atomic64_add_wrap - add integer to atomic64 variable
+ * @i: integer value to add
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically adds @i to @v.
+ */
+static __always_inline void atomic64_add_wrap(long i, atomic64_wrap_t *v)
+{
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
 		     : "er" (i), "m" (v->counter));
 }
+#define atomic64_add_wrap atomic64_add_wrap
 
 /**
  * atomic64_sub - subtract the atomic64 variable
@@ -56,10 +112,31 @@ static __always_inline void atomic64_add(long i, atomic64_t *v)
  */
 static inline void atomic64_sub(long i, atomic64_t *v)
 {
+	asm volatile(LOCK_PREFIX "subq %1,%0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "addq %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
++ * atomic64_sub_wrap - subtract the atomic64 variable
++ * @i: integer value to subtract
++ * @v: pointer to type atomic64_wrap_t
++ *
++ * Atomically subtracts @i from @v.
++ */
+static inline void atomic64_sub_wrap(long i, atomic64_wrap_t *v)
+{
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=m" (v->counter)
 		     : "er" (i), "m" (v->counter));
 }
+#define atomic64_sub_wrap atomic64_sub_wrap
 
 /**
  * atomic64_sub_and_test - subtract value from variable and test result
@@ -72,10 +149,25 @@ static inline void atomic64_sub(long i, atomic64_t *v)
  */
 static inline bool atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, "er", i, "%0", e);
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", LOCK_PREFIX "addq", v->counter, "er", i, "%0", e);
 }
 
 /**
+ * atomic64_sub_and_test_wrap - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline bool atomic64_sub_and_test_wrap(long i, atomic64_wrap_t *v)
+{
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "subq", v->counter, "er", i, "%0", e);
+}
+#define atomic64_sub_and_test_wrap atomic64_sub_and_test_wrap
+
+/**
  * atomic64_inc - increment atomic64 variable
  * @v: pointer to type atomic64_t
  *
@@ -83,10 +175,31 @@ static inline bool atomic64_sub_and_test(long i, atomic64_t *v)
  */
 static __always_inline void atomic64_inc(atomic64_t *v)
 {
+	asm volatile(LOCK_PREFIX "incq %0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "decq %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_inc_wrap - increment atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically increments @v by 1.
+ */
+static __always_inline void atomic64_inc_wrap(atomic64_wrap_t *v)
+{
 	asm volatile(LOCK_PREFIX "incq %0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
+#define atomic64_inc_wrap atomic64_inc_wrap
 
 /**
  * atomic64_dec - decrement atomic64 variable
@@ -96,10 +209,31 @@ static __always_inline void atomic64_inc(atomic64_t *v)
  */
 static __always_inline void atomic64_dec(atomic64_t *v)
 {
+	asm volatile(LOCK_PREFIX "decq %0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX "incq %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_dec_wrap - decrement atomic64 variable
+ * @v: pointer to type atomic64_wrap_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static __always_inline void atomic64_dec_wrap(atomic64_wrap_t *v)
+{
 	asm volatile(LOCK_PREFIX "decq %0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
+#define atomic64_dec_wrap atomic64_dec_wrap
 
 /**
  * atomic64_dec_and_test - decrement and test
@@ -111,8 +245,14 @@ static __always_inline void atomic64_dec(atomic64_t *v)
  */
 static inline bool atomic64_dec_and_test(atomic64_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", v->counter, "%0", e);
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", LOCK_PREFIX "incq", v->counter, "%0", e);
+}
+
+static inline bool atomic64_dec_and_test_wrap(atomic64_wrap_t *v)
+{
+	GEN_UNARY_RMWcc_wrap(LOCK_PREFIX "decq", v->counter, "%0", e);
 }
+#define atomic64_dec_and_test_wrap atomic64_dec_and_test_wrap
 
 /**
  * atomic64_inc_and_test - increment and test
@@ -124,8 +264,14 @@ static inline bool atomic64_dec_and_test(atomic64_t *v)
  */
 static inline bool atomic64_inc_and_test(atomic64_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", v->counter, "%0", e);
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", LOCK_PREFIX "decq", v->counter, "%0", e);
+}
+
+static inline bool atomic64_inc_and_test_wrap(atomic64_wrap_t *v)
+{
+	GEN_UNARY_RMWcc_wrap(LOCK_PREFIX "incq", v->counter, "%0", e);
 }
+#define atomic64_inc_and_test_wrap atomic64_inc_and_test_wrap
 
 /**
  * atomic64_add_negative - add and test if negative
@@ -138,9 +284,15 @@ static inline bool atomic64_inc_and_test(atomic64_t *v)
  */
 static inline bool atomic64_add_negative(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, "er", i, "%0", s);
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", LOCK_PREFIX "subq", v->counter, "er", i, "%0", s);
 }
 
+static inline bool atomic64_add_negative_wrap(long i, atomic64_wrap_t *v)
+{
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "addq", v->counter, "er", i, "%0", s);
+}
+#define atomic64_add_negative_wrap atomic64_add_negative_wrap
+
 /**
  * atomic64_add_return - add and return
  * @i: integer value to add
@@ -150,14 +302,26 @@ static inline bool atomic64_add_negative(long i, atomic64_t *v)
  */
 static __always_inline long atomic64_add_return(long i, atomic64_t *v)
 {
+	return i + xadd_check_overflow(&v->counter, i);
+}
+
+static __always_inline long atomic64_add_return_wrap(long i, atomic64_wrap_t *v)
+{
 	return i + xadd(&v->counter, i);
 }
+#define atomic64_add_return_wrap atomic64_add_return_wrap
 
 static inline long atomic64_sub_return(long i, atomic64_t *v)
 {
 	return atomic64_add_return(-i, v);
 }
 
+static inline long atomic64_sub_return_wrap(long i, atomic64_wrap_t *v)
+{
+	return atomic64_add_return_wrap(-i, v);
+}
+#define atomic64_sub_return_wrap atomic64_sub_return_wrap
+
 static inline long atomic64_fetch_add(long i, atomic64_t *v)
 {
 	return xadd(&v->counter, i);
@@ -171,16 +335,31 @@ static inline long atomic64_fetch_sub(long i, atomic64_t *v)
 #define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
 #define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
 
+#define atomic64_inc_return_wrap(v)  (atomic64_add_return_wrap(1, (v)))
+#define atomic64_dec_return_wrap(v)  (atomic64_sub_return_wrap(1, (v)))
+
 static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
 {
 	return cmpxchg(&v->counter, old, new);
 }
 
+static inline long atomic64_cmpxchg_wrap(atomic64_wrap_t *v, long old, long new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+#define atomic64_cmpxchg_wrap atomic64_cmpxchg_wrap
+
 static inline long atomic64_xchg(atomic64_t *v, long new)
 {
 	return xchg(&v->counter, new);
 }
 
+static inline long atomic64_xchg_wrap(atomic64_wrap_t *v, long new)
+{
+	return xchg(&v->counter, new);
+}
+#define atomic64_xchg_wrap atomic64_xchg_wrap
+
 /**
  * atomic64_add_unless - add unless the number is a given value
  * @v: pointer of type atomic64_t
@@ -192,11 +371,21 @@ static inline long atomic64_xchg(atomic64_t *v, long new)
  */
 static inline bool atomic64_add_unless(atomic64_t *v, long a, long u)
 {
-	long c, old;
+	long c, old, new;
 	c = atomic64_read(v);
 	for (;;) {
 		if (unlikely(c == (u)))
 			break;
+		asm volatile("add %2,%0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+			     "jno 0f\n"
+			     "sub %2,%0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
 		old = atomic64_cmpxchg((v), c, c + (a));
 		if (likely(old == c))
 			break;
@@ -205,6 +394,26 @@ static inline bool atomic64_add_unless(atomic64_t *v, long a, long u)
 	return c != (u);
 }
 
+static inline bool atomic64_add_unless_wrap(atomic64_wrap_t *v, long a, long u)
+{
+	long c, old, new;
+	c = atomic64_read_wrap(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		asm volatile("add %2,%0\n"
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
+		old = atomic64_cmpxchg_wrap((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+#define atomic64_add_unless_wrap atomic64_add_unless_wrap
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /*
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 68557f52..e25eb0d 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -50,7 +50,7 @@
  * a mask operation on a byte.
  */
 #define IS_IMMEDIATE(nr)		(__builtin_constant_p(nr))
-#define CONST_MASK_ADDR(nr, addr)	BITOP_ADDR((void *)(addr) + ((nr)>>3))
+#define CONST_MASK_ADDR(nr, addr)	BITOP_ADDR((volatile void *)(addr) + ((nr)>>3))
 #define CONST_MASK(nr)			(1 << ((nr) & 7))
 
 /**
@@ -203,7 +203,7 @@ static __always_inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static __always_inline bool test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", c);
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", c);
 }
 
 /**
@@ -249,7 +249,7 @@ static __always_inline bool __test_and_set_bit(long nr, volatile unsigned long *
  */
 static __always_inline bool test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", c);
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", c);
 }
 
 /**
@@ -302,7 +302,7 @@ static __always_inline bool __test_and_change_bit(long nr, volatile unsigned lon
  */
 static __always_inline bool test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", c);
+	GEN_BINARY_RMWcc_wrap(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", c);
 }
 
 static __always_inline bool constant_test_bit(long nr, const volatile unsigned long *addr)
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 97848cd..456446fe 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -13,10 +13,14 @@ extern void __xchg_wrong_size(void)
 	__compiletime_error("Bad argument size for xchg");
 extern void __cmpxchg_wrong_size(void)
 	__compiletime_error("Bad argument size for cmpxchg");
+extern void __xadd_check_overflow_wrong_size(void)
+	__compiletime_error("Bad argument size for xadd_check_overflow");
 extern void __xadd_wrong_size(void)
 	__compiletime_error("Bad argument size for xadd");
 extern void __add_wrong_size(void)
 	__compiletime_error("Bad argument size for add");
+extern void __add_check_overflow_wrong_size(void)
+	__compiletime_error("Bad argument size for add_check_overflow");
 
 /*
  * Constants for operation sizes. On 32-bit, the 64-bit size it set to
@@ -68,6 +72,38 @@ extern void __add_wrong_size(void)
 		__ret;							\
 	})
 
+#ifdef CONFIG_HARDENED_ATOMIC
+#define __xchg_op_check_overflow(ptr, arg, op, lock)			\
+	({								\
+	        __typeof__ (*(ptr)) __ret = (arg);			\
+		switch (sizeof(*(ptr))) {				\
+		case __X86_CASE_L:					\
+			asm volatile (lock #op "l %0, %1\n"		\
+				      "jno 0f\n"			\
+				      "mov %0,%1\n"			\
+				      "int $4\n0:\n"			\
+				      _ASM_EXTABLE(0b, 0b)		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		case __X86_CASE_Q:					\
+			asm volatile (lock #op "q %q0, %1\n"		\
+				      "jno 0f\n"			\
+				      "mov %0,%1\n"			\
+				      "int $4\n0:\n"			\
+				      _ASM_EXTABLE(0b, 0b)		\
+				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : : "memory", "cc");		\
+			break;						\
+		default:						\
+			__ ## op ## _check_overflow_wrong_size();	\
+		}							\
+		__ret;							\
+	})
+#else
+#define __xchg_op_check_overflow(ptr, arg, op, lock) __xchg_op(ptr, arg, op, lock)
+#endif
+
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
  * Since this is generally used to protect other memory information, we
@@ -162,6 +198,9 @@ extern void __add_wrong_size(void)
 #define __xadd(ptr, inc, lock)	__xchg_op((ptr), (inc), xadd, lock)
 #define xadd(ptr, inc)		__xadd((ptr), (inc), LOCK_PREFIX)
 
+#define __xadd_check_overflow(ptr, inc, lock)	__xchg_op_check_overflow((ptr), (inc), xadd, lock)
+#define xadd_check_overflow(ptr, inc)		__xadd_check_overflow((ptr), (inc), LOCK_PREFIX)
+
 #define __cmpxchg_double(pfx, p1, p2, o1, o2, n1, n2)			\
 ({									\
 	bool __ret;							\
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index b6ab86c..4da1531 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -10,27 +10,69 @@ typedef struct {
 	atomic_long_t a;
 } local_t;
 
-#include <asm-generic/local_wrap.h>
+typedef struct {
+	atomic_long_wrap_t a;
+} local_wrap_t;
 
 #define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
 
 #define local_read(l)	atomic_long_read(&(l)->a)
+#define local_read_wrap(l)	atomic_long_read_wrap(&(l)->a)
 #define local_set(l, i)	atomic_long_set(&(l)->a, (i))
+#define local_set_wrap(l, i)	atomic_long_set_wrap(&(l)->a, (i))
 
 static inline void local_inc(local_t *l)
 {
+	asm volatile(_ASM_INC "%0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     _ASM_DEC "%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "+m" (l->a.counter));
+}
+
+static inline void local_inc_wrap(local_wrap_t *l)
+{
 	asm volatile(_ASM_INC "%0"
 		     : "+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
+	asm volatile(_ASM_DEC "%0\n"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     _ASM_INC "%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "+m" (l->a.counter));
+}
+
+static inline void local_dec_wrap(local_wrap_t *l)
+{
 	asm volatile(_ASM_DEC "%0"
 		     : "+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
+	asm volatile(_ASM_ADD "%1,%0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     _ASM_SUB "%1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "+m" (l->a.counter)
+		     : "ir" (i));
+}
+
+static inline void local_add_wrap(long i, local_wrap_t *l)
+{
 	asm volatile(_ASM_ADD "%1,%0"
 		     : "+m" (l->a.counter)
 		     : "ir" (i));
@@ -38,6 +80,19 @@ static inline void local_add(long i, local_t *l)
 
 static inline void local_sub(long i, local_t *l)
 {
+	asm volatile(_ASM_SUB "%1,%0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     _ASM_ADD "%1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "+m" (l->a.counter)
+		     : "ir" (i));
+}
+
+static inline void local_sub_wrap(long i, local_wrap_t *l)
+{
 	asm volatile(_ASM_SUB "%1,%0"
 		     : "+m" (l->a.counter)
 		     : "ir" (i));
@@ -54,7 +109,12 @@ static inline void local_sub(long i, local_t *l)
  */
 static inline bool local_sub_and_test(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, "er", i, "%0", e);
+	GEN_BINARY_RMWcc(_ASM_SUB, _ASM_ADD, l->a.counter, "er", i, "%0", e);
+}
+
+static inline bool local_sub_and_test_wrap(long i, local_wrap_t *l)
+{
+	GEN_BINARY_RMWcc_wrap(_ASM_SUB, l->a.counter, "er", i, "%0", e);
 }
 
 /**
@@ -67,7 +127,12 @@ static inline bool local_sub_and_test(long i, local_t *l)
  */
 static inline bool local_dec_and_test(local_t *l)
 {
-	GEN_UNARY_RMWcc(_ASM_DEC, l->a.counter, "%0", e);
+	GEN_UNARY_RMWcc(_ASM_DEC, _ASM_INC, l->a.counter, "%0", e);
+}
+
+static inline bool local_dec_and_test_wrap(local_wrap_t *l)
+{
+	GEN_UNARY_RMWcc_wrap(_ASM_DEC, l->a.counter, "%0", e);
 }
 
 /**
@@ -80,7 +145,12 @@ static inline bool local_dec_and_test(local_t *l)
  */
 static inline bool local_inc_and_test(local_t *l)
 {
-	GEN_UNARY_RMWcc(_ASM_INC, l->a.counter, "%0", e);
+	GEN_UNARY_RMWcc(_ASM_INC, _ASM_DEC, l->a.counter, "%0", e);
+}
+
+static inline bool local_inc_and_test_wrap(local_wrap_t *l)
+{
+	GEN_UNARY_RMWcc_wrap(_ASM_INC, l->a.counter, "%0", e);
 }
 
 /**
@@ -94,7 +164,12 @@ static inline bool local_inc_and_test(local_t *l)
  */
 static inline bool local_add_negative(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, "er", i, "%0", s);
+	GEN_BINARY_RMWcc(_ASM_ADD, _ASM_SUB, l->a.counter, "er", i, "%0", s);
+}
+
+static inline bool local_add_negative_wrap(long i, local_wrap_t *l)
+{
+	GEN_BINARY_RMWcc_wrap(_ASM_ADD, l->a.counter, "er", i, "%0", s);
 }
 
 /**
@@ -107,6 +182,28 @@ static inline bool local_add_negative(long i, local_t *l)
 static inline long local_add_return(long i, local_t *l)
 {
 	long __i = i;
+	asm volatile(_ASM_XADD "%0, %1\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     _ASM_MOV "%0,%1\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+		     : "+r" (i), "+m" (l->a.counter)
+		     : : "memory");
+	return i + __i;
+}
+
+/**
+ * local_add_return_wrap - add and return
+ * @i: integer value to add
+ * @l: pointer to type local_wrap_t
+ *
+ * Atomically adds @i to @l and returns @i + @l
+ */
+static inline long local_add_return_wrap(long i, local_wrap_t *l)
+{
+	long __i = i;
 	asm volatile(_ASM_XADD "%0, %1;"
 		     : "+r" (i), "+m" (l->a.counter)
 		     : : "memory");
@@ -118,11 +215,20 @@ static inline long local_sub_return(long i, local_t *l)
 	return local_add_return(-i, l);
 }
 
+static inline long local_sub_return_wrap(long i, local_wrap_t *l)
+{
+	return local_add_return_wrap(-i, l);
+}
+
 #define local_inc_return(l)  (local_add_return(1, l))
 #define local_dec_return(l)  (local_sub_return(1, l))
+#define local_inc_return_wrap(l)  (local_add_return_wrap(1, l))
+#define local_dec_return_wrap(l)  (local_sub_return_wrap(1, l))
 
 #define local_cmpxchg(l, o, n) \
 	(cmpxchg_local(&((l)->a.counter), (o), (n)))
+#define local_cmpxchg_wrap(l, o, n) \
+	(cmpxchg_local(&((l)->a.counter), (o), (n)))
 /* Always has a lock prefix */
 #define local_xchg(l, n) (xchg(&((l)->a.counter), (n)))
 
@@ -135,20 +241,47 @@ static inline long local_sub_return(long i, local_t *l)
  * Atomically adds @a to @l, so long as it was not @u.
  * Returns non-zero if @l was not @u, and zero otherwise.
  */
-#define local_add_unless(l, a, u)				\
+static inline long local_add_unless(local_t *l, long a, long u)
+{
+	long c, old, new;
+	c = local_read((l));
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+
+		asm volatile(_ASM_ADD "%2,%0\n"
+#ifdef CONFIG_HARDENED_ATOMIC
+			     "jno 0f\n"
+			     _ASM_SUB "%2,%0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif /* CONFIG_HARDENED_ATOMIC */
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
+		old = local_cmpxchg((l), c, new);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
+#define local_add_unless_wrap(l, a, u)				\
 ({								\
 	long c, old;						\
-	c = local_read((l));					\
+	c = local_read_wrap((l));				\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\
 			break;					\
-		old = local_cmpxchg((l), c, c + (a));		\
+		old = local_cmpxchg_wrap((l), c, c + (a));	\
 		if (likely(old == c))				\
 			break;					\
 		c = old;					\
 	}							\
 	c != (u);						\
 })
+
 #define local_inc_not_zero(l) local_add_unless((l), 1, 0)
 
 /* On x86_32, these are no better than the atomic variants.
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 17f2186..2fa0e84 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -81,7 +81,7 @@ static __always_inline void __preempt_count_sub(int val)
  */
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
-	GEN_UNARY_RMWcc("decl", __preempt_count, __percpu_arg(0), e);
+    GEN_UNARY_RMWcc("decl", "incl", __preempt_count, __percpu_arg(0), e);
 }
 
 /*
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 661dd30..0375d3f 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -5,28 +5,80 @@
 
 /* Use asm goto */
 
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
+#ifdef CONFIG_HARDENED_ATOMIC
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
 do {									\
-	asm_volatile_goto (fullop "; j" #cc " %l[cc_label]"		\
+	asm_volatile_goto (fullop					\
+			";jno 0f\n"					\
+			fullantiop					\
+			";int $4\n0:\n"					\
+			_ASM_EXTABLE(0b, 0b)				\
+			 ";j" #cc " %l[cc_label]"			\
 			: : "m" (var), ## __VA_ARGS__ 			\
 			: "memory" : cc_label);				\
 	return 0;							\
 cc_label:								\
 	return 1;							\
 } while (0)
+#else
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
+do {									\
+	asm_volatile_goto (fullop ";j" #cc " %l[cc_label]"		\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+#endif
 
-#define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
-	__GEN_RMWcc(op " " arg0, var, cc)
-
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
+#define __GEN_RMWcc_wrap(fullop, var, cc, ...)do {									\
+	asm_volatile_goto (fullop "; j" #cc " %l[cc_label]"		\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
 
+#define GEN_UNARY_RMWcc(op, antiop, var, arg0, cc) 			\
+	__GEN_RMWcc(op " " arg0, antiop " " arg0, var, cc)
+#define GEN_UNARY_RMWcc_wrap(op, var, arg0, cc) 			\
+	__GEN_RMWcc_wrap(op " " arg0, var, cc)
+#define GEN_BINARY_RMWcc(op, antiop, var, vcon, val, arg0, cc)		\
+	__GEN_RMWcc(op " %1, " arg0, antiop " %1, " arg0, var, cc, vcon (val))
+#define GEN_BINARY_RMWcc_wrap(op, var, vcon, val, arg0, cc)	\
+	__GEN_RMWcc_wrap(op " %1, " arg0, var, cc, vcon (val))
 #else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
 
 /* Use flags output or a set instruction */
 
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
+#ifdef CONFIG_HARDENED_ATOMIC
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
 do {									\
+	char c;								\
+	asm volatile (fullop 						\
+			";jno 0f\n"					\
+			fullantiop					\
+			";int $4\n0:\n"					\
+			_ASM_EXTABLE(0b, 0b)				\
+			";" CC_SET(cc)				\
+			: "+m" (var), CC_OUT(cc) (c)			\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+#else
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
+do {									\
+	char c;								\
+	asm volatile (fullop ";" CC_SET(cc)				\
+			: "+m" (var), CC_OUT(cc) (c)			\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+#endif
+
+#define __GEN_RMWcc_wrap(fullop, var, cc, ...)do {									\
 	bool c;								\
 	asm volatile (fullop ";" CC_SET(cc)				\
 			: "+m" (var), CC_OUT(cc) (c)			\
@@ -34,12 +86,14 @@ do {									\
 	return c;							\
 } while (0)
 
-#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
-	__GEN_RMWcc(op " " arg0, var, cc)
-
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
-
+#define GEN_UNARY_RMWcc(op, antiop, var, arg0, cc)			\
+	__GEN_RMWcc(op " " arg0, antiop " " arg0, var, cc)
+#define GEN_UNARY_RMWcc_wrap(op, var, arg0, cc)			\
+	__GEN_RMWcc_wrap(op " " arg0, var, cc)
+#define GEN_BINARY_RMWcc(op, antiop, var, vcon, val, arg0, cc)		\
+	__GEN_RMWcc(op " %2, " arg0, antiop " %2, " arg0, var, cc, vcon (val))
+#define GEN_BINARY_RMWcc_wrap(op, var, vcon, val, arg0, cc)	\
+	__GEN_RMWcc_wrap(op " %2, " arg0, var, cc, vcon (val))
 #endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
 
 #endif /* _ASM_X86_RMWcc */
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index a34e0d4..05e69df 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -64,6 +64,14 @@ static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
 		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX _ASM_DEC "(%1)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* adds 0x00000001 */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
@@ -85,6 +93,14 @@ static inline bool __down_read_trylock(struct rw_semaphore *sem)
 		     "1:\n\t"
 		     "  mov          %1,%2\n\t"
 		     "  add          %3,%2\n\t"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     "sub %3,%2\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     "  jle	     2f\n\t"
 		     LOCK_PREFIX "  cmpxchg  %2,%0\n\t"
 		     "  jnz	     1b\n\t"
@@ -99,6 +115,15 @@ static inline bool __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
+#ifdef CONFIG_HARDENED_ATOMIC
+#define ____down_write_undo \
+		     "jno 0f\n"\
+		     "mov %1,(%2)\n"\
+		     "int $4\n0:\n"\
+		     _ASM_EXTABLE(0b, 0b)
+#else
+#define ____down_write_undo
+#endif
 #define ____down_write(sem, slow_path)			\
 ({							\
 	long tmp;					\
@@ -107,6 +132,7 @@ static inline bool __down_read_trylock(struct rw_semaphore *sem)
 							\
 	asm volatile("# beginning down_write\n\t"	\
 		     LOCK_PREFIX "  xadd      %1,(%4)\n\t"	\
+		     ____down_write_undo		\
 		     /* adds 0xffff0001, returns the old value */ \
 		     "  test " __ASM_SEL(%w1,%k1) "," __ASM_SEL(%w1,%k1) "\n\t" \
 		     /* was the active mask 0 before? */\
@@ -168,6 +194,14 @@ static inline void __up_read(struct rw_semaphore *sem)
 	long tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     "mov %1,(%2)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n" /* expects old value in %edx */
@@ -186,6 +220,14 @@ static inline void __up_write(struct rw_semaphore *sem)
 	long tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     "mov %1,(%2)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* subtracts 0xffff0001, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n" /* expects old value in %edx */
@@ -203,6 +245,14 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
 		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
+
+#ifdef CONFIG_HARDENED_ATOMIC
+		     "jno 0f\n"
+		     LOCK_PREFIX _ASM_SUB "%2,(%1)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /*
 		      * transitions 0xZZZZ0001 -> 0xYYYY0001 (i386)
 		      *     0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 (x86_64)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index bd4e3d4..d67a914 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -191,6 +191,10 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 			tsk->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
 		}
+
+		if (trapnr == X86_TRAP_OF)
+			hardened_atomic_overflow(regs);
+
 		return 0;
 	}
 
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 9b0ca8f..0e8a888 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -45,6 +45,10 @@ BEGIN(read)
 	movl  (v), %eax
 	movl 4(v), %edx
 RET_ENDP
+BEGIN(read_wrap)
+	movl  (v), %eax
+	movl 4(v), %edx
+RET_ENDP
 #undef v
 
 #define v %esi
@@ -52,6 +56,10 @@ BEGIN(set)
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
 RET_ENDP
+BEGIN(set_wrap)
+	movl %ebx,  (v)
+	movl %ecx, 4(v)
+RET_ENDP
 #undef v
 
 #define v  %esi
@@ -67,6 +75,18 @@ RET_ENDP
 BEGIN(add)
 	addl %eax,  (v)
 	adcl %edx, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+	jno 0f
+	subl %eax,  (v)
+	sbbl %edx, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+RET_ENDP
+BEGIN(add_wrap)
+	addl %eax,  (v)
+	adcl %edx, 4(v)
 RET_ENDP
 #undef v
 
@@ -74,6 +94,20 @@ RET_ENDP
 BEGIN(add_return)
 	addl  (v), %eax
 	adcl 4(v), %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+	movl %eax,  (v)
+	movl %edx, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+2:
+#endif
+RET_ENDP
+BEGIN(add_return_wrap)
+	addl  (v), %eax
+	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -83,6 +117,18 @@ RET_ENDP
 BEGIN(sub)
 	subl %eax,  (v)
 	sbbl %edx, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+	jno 0f
+	addl %eax,  (v)
+	adcl %edx, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+RET_ENDP
+BEGIN(sub_wrap)
+	subl %eax,  (v)
+	sbbl %edx, 4(v)
 RET_ENDP
 #undef v
 
@@ -93,6 +139,23 @@ BEGIN(sub_return)
 	sbbl $0, %edx
 	addl  (v), %eax
 	adcl 4(v), %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+	movl %eax,  (v)
+	movl %edx, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+2:
+#endif
+RET_ENDP
+BEGIN(sub_return_wrap)
+	negl %edx
+	negl %eax
+	sbbl $0, %edx
+	addl  (v), %eax
+	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -102,6 +165,19 @@ RET_ENDP
 BEGIN(inc)
 	addl $1,  (v)
 	adcl $0, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+	jno 0f
+	subl $1,  (v)
+	sbbl $0, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+
+RET_ENDP
+BEGIN(inc_wrap)
+	addl $1,  (v)
+	adcl $0, 4(v)
 RET_ENDP
 #undef v
 
@@ -111,6 +187,22 @@ BEGIN(inc_return)
 	movl 4(v), %edx
 	addl $1, %eax
 	adcl $0, %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+	movl %eax,  (v)
+	movl %edx, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+2:
+#endif
+RET_ENDP
+BEGIN(inc_return_wrap)
+	movl  (v), %eax
+	movl 4(v), %edx
+	addl $1, %eax
+	adcl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -120,6 +212,18 @@ RET_ENDP
 BEGIN(dec)
 	subl $1,  (v)
 	sbbl $0, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+	jno 0f
+	addl $1,  (v)
+	adcl $0, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+RET_ENDP
+BEGIN(dec_wrap)
+	subl $1,  (v)
+	sbbl $0, 4(v)
 RET_ENDP
 #undef v
 
@@ -129,6 +233,22 @@ BEGIN(dec_return)
 	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+	movl %eax,  (v)
+	movl %edx, 4(v)
+#ifdef CONFIG_HARDENED_ATOMIC
+2:
+#endif
+RET_ENDP
+BEGIN(dec_return_wrap)
+	movl  (v), %eax
+	movl 4(v), %edx
+	subl $1, %eax
+	sbbl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -140,6 +260,11 @@ BEGIN(add_unless)
 	adcl %edx, %edi
 	addl  (v), %eax
 	adcl 4(v), %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
 	cmpl %eax, %ecx
 	je 3f
 1:
@@ -165,6 +290,11 @@ BEGIN(inc_not_zero)
 1:
 	addl $1, %eax
 	adcl $0, %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
 	movl %eax,  (v)
 	movl %edx, 4(v)
 	movl $1, %eax
@@ -183,6 +313,11 @@ BEGIN(dec_if_positive)
 	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 1f)
+#endif
 	js 1f
 	movl %eax,  (v)
 	movl %edx, 4(v)
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index db3ae854..5bd864e 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -22,9 +22,19 @@
 
 ENTRY(atomic64_read_cx8)
 	read64 %ecx
+	/* Pax has pax_force_retaddr here
+	 * do we want similar? If yes, changes
+	 * have to be made in more places below */
 	ret
 ENDPROC(atomic64_read_cx8)
 
+ENTRY(atomic64_read_wrap_cx8)
+	read64 %ecx
+/* do we want smth like the below line?
+ *	pax_force_retaddr */
+	ret
+ENDPROC(atomic64_read_wrap_cx8)
+
 ENTRY(atomic64_set_cx8)
 1:
 /* we don't need LOCK_PREFIX since aligned 64-bit writes
@@ -35,6 +45,17 @@ ENTRY(atomic64_set_cx8)
 	ret
 ENDPROC(atomic64_set_cx8)
 
+ENTRY(atomic64_set_wrap_cx8)
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes
+ * are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	/* pax_force_retaddr */
+	ret
+ENDPROC(atomic64_set_wrap_cx8)
+
 ENTRY(atomic64_xchg_cx8)
 1:
 	LOCK_PREFIX
@@ -44,8 +65,8 @@ ENTRY(atomic64_xchg_cx8)
 	ret
 ENDPROC(atomic64_xchg_cx8)
 
-.macro addsub_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
+.macro addsub_return func ins insc wrap=""
+ENTRY(atomic64_\func\()_return\wrap\()_cx8)
 	pushl %ebp
 	pushl %ebx
 	pushl %esi
@@ -61,6 +82,13 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %ecx
 	\ins\()l %esi, %ebx
 	\insc\()l %edi, %ecx
+#ifdef CONFIG_HARDENED_ATOMIC
+.ifb \wrap
+	into
+2:
+	_ASM_EXTABLE(2b, 3f)
+.endif
+#endif
 	LOCK_PREFIX
 	cmpxchg8b (%ebp)
 	jne 1b
@@ -68,19 +96,27 @@ ENTRY(atomic64_\func\()_return_cx8)
 10:
 	movl %ebx, %eax
 	movl %ecx, %edx
+
+.ifb \wrap
+#ifdef CONFIG_HARDENED_ATOMIC
+3:
+#endif
+.endif
 	popl %edi
 	popl %esi
 	popl %ebx
 	popl %ebp
 	ret
-ENDPROC(atomic64_\func\()_return_cx8)
+ENDPROC(atomic64_\func\()_return\wrap\()_cx8)
 .endm
 
 addsub_return add add adc
 addsub_return sub sub sbb
+addsub_return add add adc _wrap
+addsub_return sub sub sbb _wrap
 
-.macro incdec_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
+.macro incdec_return func ins insc wrap=""
+ENTRY(atomic64_\func\()_return\wrap\()_cx8)
 	pushl %ebx
 
 	read64 %esi
@@ -89,6 +125,13 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %ecx
 	\ins\()l $1, %ebx
 	\insc\()l $0, %ecx
+#ifdef CONFIG_HARDENED_ATOMIC
+.ifb \wrap
+	into
+2:
+	_ASM_EXTABLE(2b, 3f)
+.endif
+#endif
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -96,13 +139,21 @@ ENTRY(atomic64_\func\()_return_cx8)
 10:
 	movl %ebx, %eax
 	movl %ecx, %edx
+
+.ifb \wrap
+#ifdef CONFIG_HARDENED_ATOMIC
+3:
+#endif
+.endif
 	popl %ebx
 	ret
-ENDPROC(atomic64_\func\()_return_cx8)
+ENDPROC(atomic64_\func\()_return\wrap\()_cx8)
 .endm
 
 incdec_return inc add adc
 incdec_return dec sub sbb
+incdec_return inc add adc _wrap
+incdec_return dec sub sbb _wrap
 
 ENTRY(atomic64_dec_if_positive_cx8)
 	pushl %ebx
@@ -113,6 +164,11 @@ ENTRY(atomic64_dec_if_positive_cx8)
 	movl %edx, %ecx
 	subl $1, %ebx
 	sbb $0, %ecx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
 	js 2f
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
@@ -144,6 +200,11 @@ ENTRY(atomic64_add_unless_cx8)
 	movl %edx, %ecx
 	addl %ebp, %ebx
 	adcl %edi, %ecx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 3f)
+#endif
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -173,6 +234,11 @@ ENTRY(atomic64_inc_not_zero_cx8)
 	xorl %ecx, %ecx
 	addl $1, %ebx
 	adcl %edx, %ecx
+#ifdef CONFIG_HARDENED_ATOMIC
+	into
+1234:
+	_ASM_EXTABLE(1234b, 3f)
+#endif
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
-- 
2.7.4
