Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 00:56:32 -0500
Message-Id: <1450331796-10329-2-git-send-email-dave@progbits.org>
In-Reply-To: <1450331796-10329-1-git-send-email-dave@progbits.org>
References: <1450331796-10329-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH 1/5] x86: add PAX_REFCOUNT support
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Add overflow protection to atomic_t and create a new type atomic_unchecked_t
for users of atomic_t not using the type for reference counting.

Signed-off-by: David Windsor <dave@progbits.org>
---
 arch/x86/include/asm/atomic.h      | 263 ++++++++++++++++++++++++++++++++++---
 arch/x86/include/asm/atomic64_32.h | 100 ++++++++++++++
 arch/x86/include/asm/atomic64_64.h | 164 +++++++++++++++++++++--
 arch/x86/include/asm/bitops.h      |   6 +-
 arch/x86/include/asm/cmpxchg.h     |  39 ++++++
 arch/x86/include/asm/hw_irq.h      |   4 +-
 arch/x86/include/asm/local.h       | 106 +++++++++++++--
 arch/x86/include/asm/preempt.h     |   2 +-
 arch/x86/include/asm/rmwcc.h       |  84 ++++++++++--
 arch/x86/include/asm/rwsem.h       |  60 ++++++++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/io_apic.c     |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c   |  12 +-
 arch/x86/kernel/i8259.c            |   2 +-
 arch/x86/kernel/irq.c              |   8 +-
 arch/x86/kernel/kgdb.c             |   6 +-
 arch/x86/kernel/pvclock.c          |   8 +-
 arch/x86/kernel/tboot.c            |   8 +-
 arch/x86/kernel/traps.c            |   6 +
 arch/x86/lib/atomic64_386_32.S     | 164 +++++++++++++++++++++++
 arch/x86/lib/atomic64_cx8_32.S     |  94 ++++++++++++-
 arch/x86/mm/mmio-mod.c             |   4 +-
 fs/exec.c                          |  23 ++++
 23 files changed, 1081 insertions(+), 88 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index e916895..0a77aa0 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -28,6 +28,17 @@ static __always_inline int atomic_read(const atomic_t *v)
 }
 
 /**
+ * atomic_read_unchecked - read atomic variable
+ * @v: pointer of type atomic_unchecked_t
+ *
+ * Atomically reads the value of @v.
+ */
+static __always_inline int atomic_read_unchecked(const atomic_unchecked_t *v)
+{
+	return ACCESS_ONCE((v)->counter);
+}
+
+/**
  * atomic_set - set atomic variable
  * @v: pointer of type atomic_t
  * @i: required value
@@ -40,6 +51,18 @@ static __always_inline void atomic_set(atomic_t *v, int i)
 }
 
 /**
+ * atomic_set_unchecked - set atomic variable
+ * @v: pointer of type atomic_unchecked_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static __always_inline void atomic_set_unchecked(atomic_unchecked_t *v, int i)
+{
+	v->counter = i;
+}
+
+/**
  * atomic_add - add integer to atomic variable
  * @i: integer value to add
  * @v: pointer of type atomic_t
@@ -48,7 +71,29 @@ static __always_inline void atomic_set(atomic_t *v, int i)
  */
 static __always_inline void atomic_add(int i, atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "addl %1,%0"
+	asm volatile(LOCK_PREFIX "addl %1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX "subl %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_add_unchecked - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_unchecked_t
+ *
+ * Atomically adds @i to @v.
+ */
+static __always_inline void atomic_add_unchecked(int i, atomic_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0\n"
 		     : "+m" (v->counter)
 		     : "ir" (i));
 }
@@ -62,7 +107,29 @@ static __always_inline void atomic_add(int i, atomic_t *v)
  */
 static __always_inline void atomic_sub(int i, atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "subl %1,%0"
+	asm volatile(LOCK_PREFIX "subl %1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX "addl %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub_unchecked - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_unchecked_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static __always_inline void atomic_sub_unchecked(int i, atomic_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "subl %1,%0\n"
 		     : "+m" (v->counter)
 		     : "ir" (i));
 }
@@ -78,7 +145,7 @@ static __always_inline void atomic_sub(int i, atomic_t *v)
  */
 static __always_inline int atomic_sub_and_test(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, "er", i, "%0", "e");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", LOCK_PREFIX "addl",  v->counter, "er", i, "%0", "e");
 }
 
 /**
@@ -89,7 +156,27 @@ static __always_inline int atomic_sub_and_test(int i, atomic_t *v)
  */
 static __always_inline void atomic_inc(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "incl %0"
+	asm volatile(LOCK_PREFIX "incl %0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
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
+ * atomic_inc_unchecked - increment atomic variable
+ * @v: pointer of type atomic_unchecked_t
+ *
+ * Atomically increments @v by 1.
+ */
+static __always_inline void atomic_inc_unchecked(atomic_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "incl %0\n"
 		     : "+m" (v->counter));
 }
 
@@ -101,7 +188,27 @@ static __always_inline void atomic_inc(atomic_t *v)
  */
 static __always_inline void atomic_dec(atomic_t *v)
 {
-	asm volatile(LOCK_PREFIX "decl %0"
+	asm volatile(LOCK_PREFIX "decl %0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX "incl %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec_unchecked - decrement atomic variable
+ * @v: pointer of type atomic_unchecked_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static __always_inline void atomic_dec_unchecked(atomic_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "decl %0\n"
 		     : "+m" (v->counter));
 }
 
@@ -115,7 +222,7 @@ static __always_inline void atomic_dec(atomic_t *v)
  */
 static __always_inline int atomic_dec_and_test(atomic_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", "e");
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", LOCK_PREFIX "incl", v->counter, "%0", "e");
 }
 
 /**
@@ -128,7 +235,20 @@ static __always_inline int atomic_dec_and_test(atomic_t *v)
  */
 static __always_inline int atomic_inc_and_test(atomic_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", v->counter, "%0", "e");
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", LOCK_PREFIX "decl", v->counter, "%0", "e");
+}
+
+/**
+ * atomic_inc_and_test_unchecked - increment and test
+ * @v: pointer of type atomic_unchecked_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static __always_inline int atomic_inc_and_test_unchecked(atomic_unchecked_t *v)
+{
+	GEN_UNARY_RMWcc_unchecked(LOCK_PREFIX "incl", v->counter, "%0", "e");
 }
 
 /**
@@ -142,7 +262,7 @@ static __always_inline int atomic_inc_and_test(atomic_t *v)
  */
 static __always_inline int atomic_add_negative(int i, atomic_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, "er", i, "%0", "s");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", LOCK_PREFIX "subl", v->counter, "er", i, "%0", "s");
 }
 
 /**
@@ -154,6 +274,18 @@ static __always_inline int atomic_add_negative(int i, atomic_t *v)
  */
 static __always_inline int atomic_add_return(int i, atomic_t *v)
 {
+	return i + xadd_check_overflow(&v->counter, i);
+}
+
+/**
+ * atomic_add_return_unchecked - add integer and return
+ * @i: integer value to add
+ * @v: pointer of type atomi_uncheckedc_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static __always_inline int atomic_add_return_unchecked(int i, atomic_unchecked_t *v)
+{
 	return i + xadd(&v->counter, i);
 }
 
@@ -170,6 +302,10 @@ static __always_inline int atomic_sub_return(int i, atomic_t *v)
 }
 
 #define atomic_inc_return(v)  (atomic_add_return(1, v))
+static __always_inline int atomic_inc_return_unchecked(atomic_unchecked_t *v)
+{
+	return atomic_add_return_unchecked(1, v);
+}
 #define atomic_dec_return(v)  (atomic_sub_return(1, v))
 
 static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
@@ -177,11 +313,21 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return cmpxchg(&v->counter, old, new);
 }
 
+static __always_inline int atomic_cmpxchg_unchecked(atomic_unchecked_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
 static inline int atomic_xchg(atomic_t *v, int new)
 {
 	return xchg(&v->counter, new);
 }
 
+static inline int atomic_xchg_unchecked(atomic_unchecked_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
+
 /**
  * __atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
@@ -193,12 +339,25 @@ static inline int atomic_xchg(atomic_t *v, int new)
  */
 static __always_inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-	int c, old;
+	int c, old, new;
 	c = atomic_read(v);
 	for (;;) {
-		if (unlikely(c == (u)))
+		if (unlikely(c == u))
 			break;
-		old = atomic_cmpxchg((v), c, c + (a));
+
+		asm volatile("addl %2,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+			     "jno 0f\n"
+			     "subl %2,%0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif
+
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
+		old = atomic_cmpxchg(v, c, new);
 		if (likely(old == c))
 			break;
 		c = old;
@@ -207,6 +366,49 @@ static __always_inline int __atomic_add_unless(atomic_t *v, int a, int u)
 }
 
 /**
+ * atomic_inc_not_zero_hint - increment if not null
+ * @v: pointer of type atomic_t
+ * @hint: probable value of the atomic before the increment
+ *
+ * This version of atomic_inc_not_zero() gives a hint of probable
+ * value of the atomic. This helps processor to not read the memory
+ * before doing the atomic read/modify/write cycle, lowering
+ * number of bus transactions on some arches.
+ *
+ * Returns: 0 if increment was not done, 1 otherwise.
+ */
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
+#ifdef CONFIG_PAX_REFCOUNT
+			     "jno 0f\n"
+			     "decl %0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif
+
+			     : "=r" (new)
+			     : "0" (c));
+
+		val = atomic_cmpxchg(v, c, new);
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
@@ -220,14 +422,37 @@ static __always_inline short int atomic_inc_short(short int *v)
 }
 
 /* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
-
-#define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"			\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
-		     : "memory")
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "andl %1,%0"
+		     : "+m" (v->counter)
+		     : "r" (~(mask))
+		     : "memory");
+}
+
+static inline void atomic_clear_mask_unchecked(unsigned int mask, atomic_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "andl %1,%0"
+		     : "+m" (v->counter)
+		     : "r" (~(mask))
+		     : "memory");
+}
+
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "orl %1,%0"
+		     : "+m" (v->counter)
+		     : "r" (mask)
+		     : "memory");
+}
+
+static inline void atomic_set_mask_unchecked(unsigned int mask, atomic_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "orl %1,%0"
+		     : "+m" (v->counter)
+		     : "r" (mask)
+		     : "memory");
+}
 
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index b154de7..a4bc513 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -12,6 +12,14 @@ typedef struct {
 	u64 __aligned(8) counter;
 } atomic64_t;
 
+#ifdef CONFIG_PAX_REFCOUNT
+typedef struct {
+	u64 __aligned(8) counter;
+} atomic64_unchecked_t;
+#else
+typedef atomic64_t atomic64_unchecked_t;
+#endif
+
 #define ATOMIC64_INIT(val)	{ (val) }
 
 #define __ATOMIC64_DECL(sym) void atomic64_##sym(atomic64_t *, ...)
@@ -37,21 +45,31 @@ typedef struct {
 	ATOMIC64_DECL_ONE(sym##_386)
 
 ATOMIC64_DECL_ONE(add_386);
+ATOMIC64_DECL_ONE(add_unchecked_386);
 ATOMIC64_DECL_ONE(sub_386);
+ATOMIC64_DECL_ONE(sub_unchecked_386);
 ATOMIC64_DECL_ONE(inc_386);
+ATOMIC64_DECL_ONE(inc_unchecked_386);
 ATOMIC64_DECL_ONE(dec_386);
+ATOMIC64_DECL_ONE(dec_unchecked_386);
 #endif
 
 #define alternative_atomic64(f, out, in...) \
 	__alternative_atomic64(f, f, ASM_OUTPUT2(out), ## in)
 
 ATOMIC64_DECL(read);
+ATOMIC64_DECL(read_unchecked);
 ATOMIC64_DECL(set);
+ATOMIC64_DECL(set_unchecked);
 ATOMIC64_DECL(xchg);
 ATOMIC64_DECL(add_return);
+ATOMIC64_DECL(add_return_unchecked);
 ATOMIC64_DECL(sub_return);
+ATOMIC64_DECL(sub_return_unchecked);
 ATOMIC64_DECL(inc_return);
+ATOMIC64_DECL(inc_return_unchecked);
 ATOMIC64_DECL(dec_return);
+ATOMIC64_DECL(dec_return_unchecked);
 ATOMIC64_DECL(dec_if_positive);
 ATOMIC64_DECL(inc_not_zero);
 ATOMIC64_DECL(add_unless);
@@ -77,6 +95,21 @@ static inline long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n
 }
 
 /**
+ * atomic64_cmpxchg_unchecked - cmpxchg atomic64 variable
+ * @p: pointer to type atomic64_unchecked_t
+ * @o: expected value
+ * @n: new value
+ *
+ * Atomically sets @v to @n if it was equal to @o and returns
+ * the old value.
+ */
+
+static inline long long atomic64_cmpxchg_unchecked(atomic64_unchecked_t *v, long long o, long long n)
+{
+	return cmpxchg64(&v->counter, o, n);
+}
+
+/**
  * atomic64_xchg - xchg atomic64 variable
  * @v: pointer to type atomic64_t
  * @n: value to assign
@@ -112,6 +145,22 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 }
 
 /**
+ * atomic64_set_unchecked - set atomic64 variable
+ * @v: pointer to type atomic64_unchecked_t
+ * @n: value to assign
+ *
+ * Atomically sets the value of @v to @n.
+ */
+static inline void atomic64_set_unchecked(atomic64_unchecked_t *v, long long i)
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
@@ -125,6 +174,19 @@ static inline long long atomic64_read(const atomic64_t *v)
  }
 
 /**
+ * atomic64_read_unchecked - read atomic64 variable
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically reads the value of @v and returns it.
+ */
+static inline long long atomic64_read_unchecked(const atomic64_unchecked_t *v)
+{
+	long long r;
+	alternative_atomic64(read, "=&A" (r), "c" (v) : "memory");
+	return r;
+ }
+
+/**
  * atomic64_add_return - add and return
  * @i: integer value to add
  * @v: pointer to type atomic64_t
@@ -139,6 +201,21 @@ static inline long long atomic64_add_return(long long i, atomic64_t *v)
 	return i;
 }
 
+/**
+ * atomic64_add_return_unchecked - add and return
+ * @i: integer value to add
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically adds @i to @v and returns @i + *@v
+ */
+static inline long long atomic64_add_return_unchecked(long long i, atomic64_unchecked_t *v)
+{
+	alternative_atomic64(add_return_unchecked,
+			     ASM_OUTPUT2("+A" (i), "+c" (v)),
+			     ASM_NO_INPUT_CLOBBER("memory"));
+	return i;
+}
+
 /*
  * Other variants with different arithmetic operators:
  */
@@ -158,6 +235,14 @@ static inline long long atomic64_inc_return(atomic64_t *v)
 	return a;
 }
 
+static inline long long atomic64_inc_return_unchecked(atomic64_unchecked_t *v)
+{
+	long long a;
+	alternative_atomic64(inc_return_unchecked, "=&A" (a),
+			     "S" (v) : "memory", "ecx");
+	return a;
+}
+
 static inline long long atomic64_dec_return(atomic64_t *v)
 {
 	long long a;
@@ -182,6 +267,21 @@ static inline long long atomic64_add(long long i, atomic64_t *v)
 }
 
 /**
+ * atomic64_add_unchecked - add integer to atomic64 variable
+ * @i: integer value to add
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline long long atomic64_add_unchecked(long long i, atomic64_unchecked_t *v)
+{
+	__alternative_atomic64(add_unchecked, add_return_unchecked,
+			       ASM_OUTPUT2("+A" (i), "+c" (v)),
+			       ASM_NO_INPUT_CLOBBER("memory"));
+	return i;
+}
+
+/**
  * atomic64_sub - subtract the atomic64 variable
  * @i: integer value to subtract
  * @v: pointer to type atomic64_t
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index b965f9e..fc9be92 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -22,6 +22,18 @@ static inline long atomic64_read(const atomic64_t *v)
 }
 
 /**
+ * atomic64_read_unchecked - read atomic64 variable
+ * @v: pointer of type atomic64_unchecked_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+static inline long atomic64_read_unchecked(const atomic64_unchecked_t *v)
+{
+	return ACCESS_ONCE((v)->counter);
+}
+
+/**
  * atomic64_set - set atomic64 variable
  * @v: pointer to type atomic64_t
  * @i: required value
@@ -34,6 +46,18 @@ static inline void atomic64_set(atomic64_t *v, long i)
 }
 
 /**
+ * atomic64_set_unchecked - set atomic64 variable
+ * @v: pointer to type atomic64_unchecked_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic64_set_unchecked(atomic64_unchecked_t *v, long i)
+{
+	v->counter = i;
+}
+
+/**
  * atomic64_add - add integer to atomic64 variable
  * @i: integer value to add
  * @v: pointer to type atomic64_t
@@ -42,6 +66,28 @@ static inline void atomic64_set(atomic64_t *v, long i)
  */
 static __always_inline void atomic64_add(long i, atomic64_t *v)
 {
+	asm volatile(LOCK_PREFIX "addq %1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
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
+ * atomic64_add_unchecked - add integer to atomic64 variable
+ * @i: integer value to add
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically adds @i to @v.
+ */
+static __always_inline void atomic64_add_unchecked(long i, atomic64_unchecked_t *v)
+{
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
 		     : "er" (i), "m" (v->counter));
@@ -56,7 +102,29 @@ static __always_inline void atomic64_add(long i, atomic64_t *v)
  */
 static inline void atomic64_sub(long i, atomic64_t *v)
 {
-	asm volatile(LOCK_PREFIX "subq %1,%0"
+	asm volatile(LOCK_PREFIX "subq %1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX "addq %1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
+ * atomic64_sub_unchecked - subtract the atomic64 variable
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic64_sub_unchecked(long i, atomic64_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "subq %1,%0\n"
 		     : "=m" (v->counter)
 		     : "er" (i), "m" (v->counter));
 }
@@ -72,7 +140,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
  */
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, "er", i, "%0", "e");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", LOCK_PREFIX "addq", v->counter, "er", i, "%0", "e");
 }
 
 /**
@@ -83,6 +151,27 @@ static inline int atomic64_sub_and_test(long i, atomic64_t *v)
  */
 static __always_inline void atomic64_inc(atomic64_t *v)
 {
+	asm volatile(LOCK_PREFIX "incq %0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX "decq %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_inc_unchecked - increment atomic64 variable
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically increments @v by 1.
+ */
+static __always_inline void atomic64_inc_unchecked(atomic64_unchecked_t *v)
+{
 	asm volatile(LOCK_PREFIX "incq %0"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
@@ -96,7 +185,28 @@ static __always_inline void atomic64_inc(atomic64_t *v)
  */
 static __always_inline void atomic64_dec(atomic64_t *v)
 {
-	asm volatile(LOCK_PREFIX "decq %0"
+	asm volatile(LOCK_PREFIX "decq %0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX "incq %0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_dec_unchecked - decrement atomic64 variable
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static __always_inline void atomic64_dec_unchecked(atomic64_unchecked_t *v)
+{
+	asm volatile(LOCK_PREFIX "decq %0\n"
 		     : "=m" (v->counter)
 		     : "m" (v->counter));
 }
@@ -111,7 +221,7 @@ static __always_inline void atomic64_dec(atomic64_t *v)
  */
 static inline int atomic64_dec_and_test(atomic64_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", v->counter, "%0", "e");
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", LOCK_PREFIX "incq", v->counter, "%0", "e");
 }
 
 /**
@@ -124,7 +234,7 @@ static inline int atomic64_dec_and_test(atomic64_t *v)
  */
 static inline int atomic64_inc_and_test(atomic64_t *v)
 {
-	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", v->counter, "%0", "e");
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", LOCK_PREFIX "decq", v->counter, "%0", "e");
 }
 
 /**
@@ -138,7 +248,7 @@ static inline int atomic64_inc_and_test(atomic64_t *v)
  */
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, "er", i, "%0", "s");
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", LOCK_PREFIX "subq",  v->counter, "er", i, "%0", "s");
 }
 
 /**
@@ -150,6 +260,18 @@ static inline int atomic64_add_negative(long i, atomic64_t *v)
  */
 static __always_inline long atomic64_add_return(long i, atomic64_t *v)
 {
+	return i + xadd_check_overflow(&v->counter, i);
+}
+
+/**
+ * atomic64_add_return_unchecked - add and return
+ * @i: integer value to add
+ * @v: pointer to type atomic64_unchecked_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static __always_inline long atomic64_add_return_unchecked(long i, atomic64_unchecked_t *v)
+{
 	return i + xadd(&v->counter, i);
 }
 
@@ -159,6 +281,10 @@ static inline long atomic64_sub_return(long i, atomic64_t *v)
 }
 
 #define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
+static inline long atomic64_inc_return_unchecked(atomic64_unchecked_t *v)
+{
+	return atomic64_add_return_unchecked(1, v);
+}
 #define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
 
 static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
@@ -166,6 +292,11 @@ static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
 	return cmpxchg(&v->counter, old, new);
 }
 
+static inline long atomic64_cmpxchg_unchecked(atomic64_unchecked_t *v, long old, long new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
 static inline long atomic64_xchg(atomic64_t *v, long new)
 {
 	return xchg(&v->counter, new);
@@ -182,17 +313,30 @@ static inline long atomic64_xchg(atomic64_t *v, long new)
  */
 static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
-	long c, old;
+	long c, old, new;
 	c = atomic64_read(v);
 	for (;;) {
-		if (unlikely(c == (u)))
+		if (unlikely(c == u))
 			break;
-		old = atomic64_cmpxchg((v), c, c + (a));
+
+		asm volatile("add %2,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+			     "jno 0f\n"
+			     "sub %2,%0\n"
+			     "int $4\n0:\n"
+			     _ASM_EXTABLE(0b, 0b)
+#endif
+
+			     : "=r" (new)
+			     : "0" (c), "ir" (a));
+
+		old = atomic64_cmpxchg(v, c, new);
 		if (likely(old == c))
 			break;
 		c = old;
 	}
-	return c != (u);
+	return c != u;
 }
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index cfe3b95..69126a1 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -203,7 +203,7 @@ static inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", "c");
+	GEN_BINARY_RMWcc_unchecked(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", "c");
 }
 
 /**
@@ -249,7 +249,7 @@ static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", "c");
+	GEN_BINARY_RMWcc_unchecked(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", "c");
 }
 
 /**
@@ -302,7 +302,7 @@ static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", "c");
+	GEN_BINARY_RMWcc_unchecked(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", "c");
 }
 
 static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index ad19841..0784041 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -14,8 +14,12 @@ extern void __cmpxchg_wrong_size(void)
 	__compiletime_error("Bad argument size for cmpxchg");
 extern void __xadd_wrong_size(void)
 	__compiletime_error("Bad argument size for xadd");
+extern void __xadd_check_overflow_wrong_size(void)
+	__compiletime_error("Bad argument size for xadd_check_overflow");
 extern void __add_wrong_size(void)
 	__compiletime_error("Bad argument size for add");
+extern void __add_check_overflow_wrong_size(void)
+	__compiletime_error("Bad argument size for add_check_overflow");
 
 /*
  * Constants for operation sizes. On 32-bit, the 64-bit size it set to
@@ -67,6 +71,38 @@ extern void __add_wrong_size(void)
 		__ret;							\
 	})
 
+#ifdef CONFIG_PAX_REFCOUNT
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
@@ -165,6 +201,9 @@ extern void __add_wrong_size(void)
 #define xadd_sync(ptr, inc)	__xadd((ptr), (inc), "lock; ")
 #define xadd_local(ptr, inc)	__xadd((ptr), (inc), "")
 
+#define __xadd_check_overflow(ptr, inc, lock)	__xchg_op_check_overflow((ptr), (inc), xadd, lock)
+#define xadd_check_overflow(ptr, inc)		__xadd_check_overflow((ptr), (inc), LOCK_PREFIX)
+
 #define __add(ptr, inc, lock)						\
 	({								\
 	        __typeof__ (*(ptr)) __ret = (inc);			\
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 6615032..9c233be 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -158,8 +158,8 @@ static inline void unlock_vector_lock(void) {}
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
 /* Statistics */
-extern atomic_t irq_err_count;
-extern atomic_t irq_mis_count;
+extern atomic_unchecked_t irq_err_count;
+extern atomic_unchecked_t irq_mis_count;
 
 extern void elcr_set_level_irq(unsigned int irq);
 
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 4ad6560..75c7bdd 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -10,33 +10,97 @@ typedef struct {
 	atomic_long_t a;
 } local_t;
 
+typedef struct {
+	atomic_long_unchecked_t a;
+} local_unchecked_t;
+
 #define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
 
 #define local_read(l)	atomic_long_read(&(l)->a)
+#define local_read_unchecked(l)	atomic_long_read_unchecked(&(l)->a)
 #define local_set(l, i)	atomic_long_set(&(l)->a, (i))
+#define local_set_unchecked(l, i)	atomic_long_set_unchecked(&(l)->a, (i))
 
 static inline void local_inc(local_t *l)
 {
-	asm volatile(_ASM_INC "%0"
+	asm volatile(_ASM_INC "%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     _ASM_DEC "%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (l->a.counter));
+}
+
+static inline void local_inc_unchecked(local_unchecked_t *l)
+{
+	asm volatile(_ASM_INC "%0\n"
 		     : "+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
-	asm volatile(_ASM_DEC "%0"
+	asm volatile(_ASM_DEC "%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     _ASM_INC "%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (l->a.counter));
+}
+
+static inline void local_dec_unchecked(local_unchecked_t *l)
+{
+	asm volatile(_ASM_DEC "%0\n"
 		     : "+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
-	asm volatile(_ASM_ADD "%1,%0"
+	asm volatile(_ASM_ADD "%1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     _ASM_SUB "%1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (l->a.counter)
+		     : "ir" (i));
+}
+
+static inline void local_add_unchecked(long i, local_unchecked_t *l)
+{
+	asm volatile(_ASM_ADD "%1,%0\n"
 		     : "+m" (l->a.counter)
 		     : "ir" (i));
 }
 
 static inline void local_sub(long i, local_t *l)
 {
-	asm volatile(_ASM_SUB "%1,%0"
+	asm volatile(_ASM_SUB "%1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     _ASM_ADD "%1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+m" (l->a.counter)
+		     : "ir" (i));
+}
+
+static inline void local_sub_unchecked(long i, local_unchecked_t *l)
+{
+	asm volatile(_ASM_SUB "%1,%0\n"
 		     : "+m" (l->a.counter)
 		     : "ir" (i));
 }
@@ -52,7 +116,7 @@ static inline void local_sub(long i, local_t *l)
  */
 static inline int local_sub_and_test(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, "er", i, "%0", "e");
+	GEN_BINARY_RMWcc(_ASM_SUB, _ASM_ADD, l->a.counter, "er", i, "%0", "e");
 }
 
 /**
@@ -65,7 +129,7 @@ static inline int local_sub_and_test(long i, local_t *l)
  */
 static inline int local_dec_and_test(local_t *l)
 {
-	GEN_UNARY_RMWcc(_ASM_DEC, l->a.counter, "%0", "e");
+	GEN_UNARY_RMWcc(_ASM_DEC, _ASM_INC, l->a.counter, "%0", "e");
 }
 
 /**
@@ -78,7 +142,7 @@ static inline int local_dec_and_test(local_t *l)
  */
 static inline int local_inc_and_test(local_t *l)
 {
-	GEN_UNARY_RMWcc(_ASM_INC, l->a.counter, "%0", "e");
+	GEN_UNARY_RMWcc(_ASM_INC, _ASM_DEC, l->a.counter, "%0", "e");
 }
 
 /**
@@ -92,7 +156,7 @@ static inline int local_inc_and_test(local_t *l)
  */
 static inline int local_add_negative(long i, local_t *l)
 {
-	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, "er", i, "%0", "s");
+	GEN_BINARY_RMWcc(_ASM_ADD, _ASM_SUB, l->a.counter, "er", i, "%0", "s");
 }
 
 /**
@@ -105,6 +169,30 @@ static inline int local_add_negative(long i, local_t *l)
 static inline long local_add_return(long i, local_t *l)
 {
 	long __i = i;
+	asm volatile(_ASM_XADD "%0, %1\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     _ASM_MOV "%0,%1\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
+		     : "+r" (i), "+m" (l->a.counter)
+		     : : "memory");
+	return i + __i;
+}
+
+/**
+ * local_add_return_unchecked - add and return
+ * @i: integer value to add
+ * @l: pointer to type local_unchecked_t
+ *
+ * Atomically adds @i to @l and returns @i + @l
+ */
+static inline long local_add_return_unchecked(long i, local_unchecked_t *l)
+{
+	long __i = i;
 	asm volatile(_ASM_XADD "%0, %1;"
 		     : "+r" (i), "+m" (l->a.counter)
 		     : : "memory");
@@ -121,6 +209,8 @@ static inline long local_sub_return(long i, local_t *l)
 
 #define local_cmpxchg(l, o, n) \
 	(cmpxchg_local(&((l)->a.counter), (o), (n)))
+#define local_cmpxchg_unchecked(l, o, n) \
+	(cmpxchg_local(&((l)->a.counter), (o), (n)))
 /* Always has a lock prefix */
 #define local_xchg(l, n) (xchg(&((l)->a.counter), (n)))
 
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index b12f810..aedcc13 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -84,7 +84,7 @@ static __always_inline void __preempt_count_sub(int val)
  */
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
-	GEN_UNARY_RMWcc("decl", __preempt_count, __percpu_arg(0), "e");
+	GEN_UNARY_RMWcc("decl", "incl", __preempt_count, __percpu_arg(0), "e");
 }
 
 /*
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 8f7866a..e442f20 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -3,7 +3,34 @@
 
 #ifdef CC_HAVE_ASM_GOTO
 
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
+#ifdef CONFIG_PAX_REFCOUNT
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
+do {									\
+	asm_volatile_goto (fullop					\
+			";jno 0f\n"					\
+			fullantiop					\
+			";int $4\n0:\n"					\
+			_ASM_EXTABLE(0b, 0b)				\
+			 ";j" cc " %l[cc_label]"			\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+#else
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
+do {									\
+	asm_volatile_goto (fullop ";j" cc " %l[cc_label]"		\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+#endif
+
+#define __GEN_RMWcc_unchecked(fullop, var, cc, ...)			\
 do {									\
 	asm_volatile_goto (fullop "; j" cc " %l[cc_label]"		\
 			: : "m" (var), ## __VA_ARGS__ 			\
@@ -13,15 +40,46 @@ cc_label:								\
 	return 1;							\
 } while (0)
 
-#define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
-	__GEN_RMWcc(op " " arg0, var, cc)
+#define GEN_UNARY_RMWcc(op, antiop, var, arg0, cc) 			\
+	__GEN_RMWcc(op " " arg0, antiop " " arg0, var, cc)
+
+#define GEN_UNARY_RMWcc_unchecked(op, var, arg0, cc) 			\
+	__GEN_RMWcc_unchecked(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, antiop, var, vcon, val, arg0, cc)		\
+	__GEN_RMWcc(op " %1, " arg0, antiop " %1, " arg0, var, cc, vcon (val))
 
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
+#define GEN_BINARY_RMWcc_unchecked(op, var, vcon, val, arg0, cc)	\
+	__GEN_RMWcc_unchecked(op " %1, " arg0, var, cc, vcon (val))
 
 #else /* !CC_HAVE_ASM_GOTO */
 
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
+#ifdef CONFIG_PAX_REFCOUNT
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
+do {									\
+	char c;								\
+	asm volatile (fullop 						\
+			";jno 0f\n"					\
+			fullantiop					\
+			";int $4\n0:\n"					\
+			_ASM_EXTABLE(0b, 0b)				\
+			"; set" cc " %1"				\
+			: "+m" (var), "=qm" (c)				\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+#else
+#define __GEN_RMWcc(fullop, fullantiop, var, cc, ...)			\
+do {									\
+	char c;								\
+	asm volatile (fullop "; set" cc " %1"				\
+			: "+m" (var), "=qm" (c)				\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+#endif
+
+#define __GEN_RMWcc_unchecked(fullop, var, cc, ...)			\
 do {									\
 	char c;								\
 	asm volatile (fullop "; set" cc " %1"				\
@@ -30,11 +88,17 @@ do {									\
 	return c != 0;							\
 } while (0)
 
-#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
-	__GEN_RMWcc(op " " arg0, var, cc)
+#define GEN_UNARY_RMWcc(op, antiop, var, arg0, cc)			\
+	__GEN_RMWcc(op " " arg0, antiop " " arg0, var, cc)
+
+#define GEN_UNARY_RMWcc_unchecked(op, var, arg0, cc)			\
+	__GEN_RMWcc_unchecked(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, antiop, var, vcon, val, arg0, cc)		\
+	__GEN_RMWcc(op " %2, " arg0, antiop " %2, " arg0, var, cc, vcon (val))
 
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
+#define GEN_BINARY_RMWcc_unchecked(op, var, vcon, val, arg0, cc)	\
+	__GEN_RMWcc_unchecked(op " %2, " arg0, var, cc, vcon (val))
 
 #endif /* CC_HAVE_ASM_GOTO */
 
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index cad82c9..2e5c5c1 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -64,6 +64,14 @@ static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
 		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX _ASM_DEC "(%1)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* adds 0x00000001 */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
@@ -85,6 +93,14 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 		     "1:\n\t"
 		     "  mov          %1,%2\n\t"
 		     "  add          %3,%2\n\t"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     "sub %3,%2\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     "  jle	     2f\n\t"
 		     LOCK_PREFIX "  cmpxchg  %2,%0\n\t"
 		     "  jnz	     1b\n\t"
@@ -104,6 +120,14 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 	long tmp;
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     "mov %1,(%2)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* adds 0xffff0001, returns the old value */
 		     "  test " __ASM_SEL(%w1,%k1) "," __ASM_SEL(%w1,%k1) "\n\t"
 		     /* was the active mask 0 before? */
@@ -155,6 +179,14 @@ static inline void __up_read(struct rw_semaphore *sem)
 	long tmp;
 	asm volatile("# beginning __up_read\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     "mov %1,(%2)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n" /* expects old value in %edx */
@@ -173,6 +205,14 @@ static inline void __up_write(struct rw_semaphore *sem)
 	long tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     "mov %1,(%2)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /* subtracts 0xffff0001, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n" /* expects old value in %edx */
@@ -190,6 +230,14 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
 		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX _ASM_SUB "%2,(%1)\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     /*
 		      * transitions 0xZZZZ0001 -> 0xYYYY0001 (i386)
 		      *     0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 (x86_64)
@@ -208,7 +256,15 @@ static inline void __downgrade_write(struct rw_semaphore *sem)
  */
 static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
 {
-	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0"
+	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0\n"
+
+#ifdef CONFIG_PAX_REFCOUNT
+		     "jno 0f\n"
+		     LOCK_PREFIX _ASM_SUB "%1,%0\n"
+		     "int $4\n0:\n"
+		     _ASM_EXTABLE(0b, 0b)
+#endif
+
 		     : "+m" (sem->count)
 		     : "er" (delta));
 }
@@ -218,7 +274,7 @@ static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
  */
 static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	return delta + xadd(&sem->count, delta);
+	return delta + xadd_check_overflow(&sem->count, delta);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 307a498..60e3759 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1864,7 +1864,7 @@ static inline void __smp_error_interrupt(struct pt_regs *regs)
 		apic_write(APIC_ESR, 0);
 	v = apic_read(APIC_ESR);
 	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
+	atomic_inc_unchecked(&irq_err_count);
 
 	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x",
 		    smp_processor_id(), v);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 11b46d9..473648d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1682,7 +1682,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-atomic_t irq_mis_count;
+atomic_unchecked_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 static bool io_apic_level_ack_pending(struct mp_chip_data *data)
@@ -1821,7 +1821,7 @@ static void ioapic_ack_level(struct irq_data *irq_data)
 	 * at the cpu.
 	 */
 	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
+		atomic_inc_unchecked(&irq_mis_count);
 		eoi_ioapic_pin(cfg->vector, irq_data->chip_data);
 	}
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index df919ff..22f7362 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -292,10 +292,10 @@ static void print_mce(struct mce *m)
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
-static atomic_t mce_panicked;
+static atomic_unchecked_t mce_panicked;
 
 static int fake_panic;
-static atomic_t mce_fake_panicked;
+static atomic_unchecked_t mce_fake_panicked;
 
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
@@ -319,7 +319,7 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 		/*
 		 * Make sure only one CPU runs in machine check panic
 		 */
-		if (atomic_inc_return(&mce_panicked) > 1)
+		if (atomic_inc_return_unchecked(&mce_panicked) > 1)
 			wait_for_panic();
 		barrier();
 
@@ -327,7 +327,7 @@ static void mce_panic(const char *msg, struct mce *final, char *exp)
 		console_verbose();
 	} else {
 		/* Don't log too much for fake panic */
-		if (atomic_inc_return(&mce_fake_panicked) > 1)
+		if (atomic_inc_return_unchecked(&mce_fake_panicked) > 1)
 			return;
 	}
 	/* First print corrected ones that are still unlogged */
@@ -752,7 +752,7 @@ static int mce_timed_out(u64 *t, const char *msg)
 	 * might have been modified by someone else.
 	 */
 	rmb();
-	if (atomic_read(&mce_panicked))
+	if (atomic_read_unchecked(&mce_panicked))
 		wait_for_panic();
 	if (!mca_cfg.monarch_timeout)
 		goto out;
@@ -2555,7 +2555,7 @@ struct dentry *mce_get_debugfs_dir(void)
 static void mce_reset(void)
 {
 	cpu_missing = 0;
-	atomic_set(&mce_fake_panicked, 0);
+	atomic_set_unchecked(&mce_fake_panicked, 0);
 	atomic_set(&mce_executing, 0);
 	atomic_set(&mce_callin, 0);
 	atomic_set(&global_nwo, 0);
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 16cb827..989dbb2 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -208,7 +208,7 @@ spurious_8259A_irq:
 			       "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
-		atomic_inc(&irq_err_count);
+		atomic_inc_unchecked(&irq_err_count);
 		/*
 		 * Theoretically we do not have to handle this IRQ,
 		 * but in Linux this does not cause problems and is
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c7dfe1b..146f63c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -28,7 +28,7 @@ EXPORT_PER_CPU_SYMBOL(irq_stat);
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
-atomic_t irq_err_count;
+atomic_unchecked_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
 void (*x86_platform_ipi_callback)(void) = NULL;
@@ -144,9 +144,9 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
 	seq_puts(p, "  Hypervisor callback interrupts\n");
 #endif
-	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
+	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read_unchecked(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
-	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
+	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read_unchecked(&irq_mis_count));
 #endif
 #ifdef CONFIG_HAVE_KVM
 	seq_printf(p, "%*s: ", prec, "PIN");
@@ -198,7 +198,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 u64 arch_irq_stat(void)
 {
-	u64 sum = atomic_read(&irq_err_count);
+	u64 sum = atomic_read_unchecked(&irq_err_count);
 	return sum;
 }
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index d6178d9..cb20db8 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -475,12 +475,12 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 	case 'k':
 		/* clear the trace bit */
 		linux_regs->flags &= ~X86_EFLAGS_TF;
-		atomic_set(&kgdb_cpu_doing_single_step, -1);
+		atomic_set_unchecked(&kgdb_cpu_doing_single_step, -1);
 
 		/* set the trace bit if we're stepping */
 		if (remcomInBuffer[0] == 's') {
 			linux_regs->flags |= X86_EFLAGS_TF;
-			atomic_set(&kgdb_cpu_doing_single_step,
+			atomic_set_unchecked(&kgdb_cpu_doing_single_step,
 				   raw_smp_processor_id());
 		}
 
@@ -545,7 +545,7 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 
 	switch (cmd) {
 	case DIE_DEBUG:
-		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
+		if (atomic_read_unchecked(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
 				return single_step_cont(regs, args);
 			break;
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 2f355d2..e75ed0a 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -51,11 +51,11 @@ void pvclock_touch_watchdogs(void)
 	reset_hung_task_detector();
 }
 
-static atomic64_t last_value = ATOMIC64_INIT(0);
+static atomic64_unchecked_t last_value = ATOMIC64_INIT(0);
 
 void pvclock_resume(void)
 {
-	atomic64_set(&last_value, 0);
+	atomic64_set_unchecked(&last_value, 0);
 }
 
 u8 pvclock_read_flags(struct pvclock_vcpu_time_info *src)
@@ -105,11 +105,11 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 	 * updating at the same time, and one of them could be slightly behind,
 	 * making the assumption that last_value always go forward fail to hold.
 	 */
-	last = atomic64_read(&last_value);
+	last = atomic64_read_unchecked(&last_value);
 	do {
 		if (ret < last)
 			return last;
-		last = atomic64_cmpxchg(&last_value, last, ret);
+		last = atomic64_cmpxchg_unchecked(&last_value, last, ret);
 	} while (unlikely(last != ret));
 
 	return ret;
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 91a4496..d1a52ee 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -310,7 +310,7 @@ static int tboot_extended_sleep(u8 sleep_state, u32 val_a, u32 val_b)
 	return -ENODEV;
 }
 
-static atomic_t ap_wfs_count;
+static atomic_unchecked_t ap_wfs_count;
 
 static int tboot_wait_for_aps(int num_aps)
 {
@@ -334,9 +334,9 @@ static int tboot_cpu_callback(struct notifier_block *nfb, unsigned long action,
 {
 	switch (action) {
 	case CPU_DYING:
-		atomic_inc(&ap_wfs_count);
+		atomic_inc_unchecked(&ap_wfs_count);
 		if (num_online_cpus() == 1)
-			if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
+			if (tboot_wait_for_aps(atomic_read_unchecked(&ap_wfs_count)))
 				return NOTIFY_BAD;
 		break;
 	}
@@ -422,7 +422,7 @@ static __init int tboot_late_init(void)
 
 	tboot_create_trampoline();
 
-	atomic_set(&ap_wfs_count, 0);
+	atomic_set_unchecked(&ap_wfs_count, 0);
 	register_hotcpu_notifier(&tboot_cpu_notifier);
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f579192..4328936 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -213,6 +213,12 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 			tsk->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
 		}
+
+#ifdef CONFIG_PAX_REFCOUNT
+		if (trapnr == X86_TRAP_OF)
+			pax_report_refcount_overflow(regs);
+#endif
+
 		return 0;
 	}
 
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 9b0ca8f..bb4af41 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -45,6 +45,10 @@ BEGIN(read)
 	movl  (v), %eax
 	movl 4(v), %edx
 RET_ENDP
+BEGIN(read_unchecked)
+	movl  (v), %eax
+	movl 4(v), %edx
+RET_ENDP
 #undef v
 
 #define v %esi
@@ -52,6 +56,10 @@ BEGIN(set)
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
 RET_ENDP
+BEGIN(set_unchecked)
+	movl %ebx,  (v)
+	movl %ecx, 4(v)
+RET_ENDP
 #undef v
 
 #define v  %esi
@@ -67,6 +75,20 @@ RET_ENDP
 BEGIN(add)
 	addl %eax,  (v)
 	adcl %edx, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+	jno 0f
+	subl %eax,  (v)
+	sbbl %edx, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+
+RET_ENDP
+BEGIN(add_unchecked)
+	addl %eax,  (v)
+	adcl %edx, 4(v)
 RET_ENDP
 #undef v
 
@@ -74,6 +96,24 @@ RET_ENDP
 BEGIN(add_return)
 	addl  (v), %eax
 	adcl 4(v), %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
+	movl %eax,  (v)
+	movl %edx, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+2:
+#endif
+
+RET_ENDP
+BEGIN(add_return_unchecked)
+	addl  (v), %eax
+	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -83,6 +123,20 @@ RET_ENDP
 BEGIN(sub)
 	subl %eax,  (v)
 	sbbl %edx, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+	jno 0f
+	addl %eax,  (v)
+	adcl %edx, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+
+RET_ENDP
+BEGIN(sub_unchecked)
+	subl %eax,  (v)
+	sbbl %edx, 4(v)
 RET_ENDP
 #undef v
 
@@ -93,6 +147,27 @@ BEGIN(sub_return)
 	sbbl $0, %edx
 	addl  (v), %eax
 	adcl 4(v), %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
+	movl %eax,  (v)
+	movl %edx, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+2:
+#endif
+
+RET_ENDP
+BEGIN(sub_return_unchecked)
+	negl %edx
+	negl %eax
+	sbbl $0, %edx
+	addl  (v), %eax
+	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -102,6 +177,20 @@ RET_ENDP
 BEGIN(inc)
 	addl $1,  (v)
 	adcl $0, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+	jno 0f
+	subl $1,  (v)
+	sbbl $0, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+
+RET_ENDP
+BEGIN(inc_unchecked)
+	addl $1,  (v)
+	adcl $0, 4(v)
 RET_ENDP
 #undef v
 
@@ -111,6 +200,26 @@ BEGIN(inc_return)
 	movl 4(v), %edx
 	addl $1, %eax
 	adcl $0, %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
+	movl %eax,  (v)
+	movl %edx, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+2:
+#endif
+
+RET_ENDP
+BEGIN(inc_return_unchecked)
+	movl  (v), %eax
+	movl 4(v), %edx
+	addl $1, %eax
+	adcl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -120,6 +229,20 @@ RET_ENDP
 BEGIN(dec)
 	subl $1,  (v)
 	sbbl $0, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+	jno 0f
+	addl $1,  (v)
+	adcl $0, 4(v)
+	int $4
+0:
+	_ASM_EXTABLE(0b, 0b)
+#endif
+
+RET_ENDP
+BEGIN(dec_unchecked)
+	subl $1,  (v)
+	sbbl $0, 4(v)
 RET_ENDP
 #undef v
 
@@ -129,6 +252,26 @@ BEGIN(dec_return)
 	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
+	movl %eax,  (v)
+	movl %edx, 4(v)
+
+#ifdef CONFIG_PAX_REFCOUNT
+2:
+#endif
+
+RET_ENDP
+BEGIN(dec_return_unchecked)
+	movl  (v), %eax
+	movl 4(v), %edx
+	subl $1, %eax
+	sbbl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
 RET_ENDP
@@ -140,6 +283,13 @@ BEGIN(add_unless)
 	adcl %edx, %edi
 	addl  (v), %eax
 	adcl 4(v), %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
 	cmpl %eax, %ecx
 	je 3f
 1:
@@ -165,6 +315,13 @@ BEGIN(inc_not_zero)
 1:
 	addl $1, %eax
 	adcl $0, %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
 	movl %eax,  (v)
 	movl %edx, 4(v)
 	movl $1, %eax
@@ -183,6 +340,13 @@ BEGIN(dec_if_positive)
 	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 1f)
+#endif
+
 	js 1f
 	movl %eax,  (v)
 	movl %edx, 4(v)
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index db3ae854..845f5c3 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -22,9 +22,16 @@
 
 ENTRY(atomic64_read_cx8)
 	read64 %ecx
+	pax_force_retaddr
 	ret
 ENDPROC(atomic64_read_cx8)
 
+ENTRY(atomic64_read_unchecked_cx8)
+	read64 %ecx
+	pax_force_retaddr
+	ret
+ENDPROC(atomic64_read_unchecked_cx8)
+
 ENTRY(atomic64_set_cx8)
 1:
 /* we don't need LOCK_PREFIX since aligned 64-bit writes
@@ -32,20 +39,33 @@ ENTRY(atomic64_set_cx8)
 	cmpxchg8b (%esi)
 	jne 1b
 
+	pax_force_retaddr
 	ret
 ENDPROC(atomic64_set_cx8)
 
+ENTRY(atomic64_set_unchecked_cx8)
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes
+ * are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	pax_force_retaddr
+	ret
+ENDPROC(atomic64_set_unchecked_cx8)
+
 ENTRY(atomic64_xchg_cx8)
 1:
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
 
+	pax_force_retaddr
 	ret
 ENDPROC(atomic64_xchg_cx8)
 
-.macro addsub_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
+.macro addsub_return func ins insc unchecked=""
+ENTRY(atomic64_\func\()_return\unchecked\()_cx8)
 	pushl %ebp
 	pushl %ebx
 	pushl %esi
@@ -61,6 +81,15 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %ecx
 	\ins\()l %esi, %ebx
 	\insc\()l %edi, %ecx
+
+.ifb \unchecked
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+2:
+	_ASM_EXTABLE(2b, 3f)
+#endif
+.endif
+
 	LOCK_PREFIX
 	cmpxchg8b (%ebp)
 	jne 1b
@@ -68,19 +97,29 @@ ENTRY(atomic64_\func\()_return_cx8)
 10:
 	movl %ebx, %eax
 	movl %ecx, %edx
+
+.ifb \unchecked
+#ifdef CONFIG_PAX_REFCOUNT
+3:
+#endif
+.endif
+
 	popl %edi
 	popl %esi
 	popl %ebx
 	popl %ebp
+	pax_force_retaddr
 	ret
-ENDPROC(atomic64_\func\()_return_cx8)
+ENDPROC(atomic64_\func\()_return\unchecked\()_cx8)
 .endm
 
 addsub_return add add adc
 addsub_return sub sub sbb
+addsub_return add add adc _unchecked
+addsub_return sub sub sbb _unchecked
 
-.macro incdec_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
+.macro incdec_return func ins insc unchecked=""
+ENTRY(atomic64_\func\()_return\unchecked\()_cx8)
 	pushl %ebx
 
 	read64 %esi
@@ -89,6 +128,15 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %edx, %ecx
 	\ins\()l $1, %ebx
 	\insc\()l $0, %ecx
+
+.ifb \unchecked
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+2:
+	_ASM_EXTABLE(2b, 3f)
+#endif
+.endif
+
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -96,13 +144,23 @@ ENTRY(atomic64_\func\()_return_cx8)
 10:
 	movl %ebx, %eax
 	movl %ecx, %edx
+
+.ifb \unchecked
+#ifdef CONFIG_PAX_REFCOUNT
+3:
+#endif
+.endif
+
 	popl %ebx
+	pax_force_retaddr
 	ret
-ENDPROC(atomic64_\func\()_return_cx8)
+ENDPROC(atomic64_\func\()_return\unchecked\()_cx8)
 .endm
 
 incdec_return inc add adc
 incdec_return dec sub sbb
+incdec_return inc add adc _unchecked
+incdec_return dec sub sbb _unchecked
 
 ENTRY(atomic64_dec_if_positive_cx8)
 	pushl %ebx
@@ -113,6 +171,13 @@ ENTRY(atomic64_dec_if_positive_cx8)
 	movl %edx, %ecx
 	subl $1, %ebx
 	sbb $0, %ecx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 2f)
+#endif
+
 	js 2f
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
@@ -122,6 +187,7 @@ ENTRY(atomic64_dec_if_positive_cx8)
 	movl %ebx, %eax
 	movl %ecx, %edx
 	popl %ebx
+	pax_force_retaddr
 	ret
 ENDPROC(atomic64_dec_if_positive_cx8)
 
@@ -144,6 +210,13 @@ ENTRY(atomic64_add_unless_cx8)
 	movl %edx, %ecx
 	addl %ebp, %ebx
 	adcl %edi, %ecx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 3f)
+#endif
+
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -153,6 +226,7 @@ ENTRY(atomic64_add_unless_cx8)
 	addl $8, %esp
 	popl %ebx
 	popl %ebp
+	pax_force_retaddr
 	ret
 4:
 	cmpl %edx, 4(%esp)
@@ -173,6 +247,13 @@ ENTRY(atomic64_inc_not_zero_cx8)
 	xorl %ecx, %ecx
 	addl $1, %ebx
 	adcl %edx, %ecx
+
+#ifdef CONFIG_PAX_REFCOUNT
+	into
+1234:
+	_ASM_EXTABLE(1234b, 3f)
+#endif
+
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
@@ -180,5 +261,6 @@ ENTRY(atomic64_inc_not_zero_cx8)
 	movl $1, %eax
 3:
 	popl %ebx
+	pax_force_retaddr
 	ret
 ENDPROC(atomic64_inc_not_zero_cx8)
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 0057a7a..6fa3eb7 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -234,7 +234,7 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 							void __iomem *addr)
 {
-	static atomic_t next_id;
+	static atomic_unchecked_t next_id;
 	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
 	/* These are page-unaligned. */
 	struct mmiotrace_map map = {
@@ -258,7 +258,7 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 			.private = trace
 		},
 		.phys = offset,
-		.id = atomic_inc_return(&next_id)
+		.id = atomic_inc_return_unchecked(&next_id)
 	};
 	map.map_id = trace->id;
 
diff --git a/fs/exec.c b/fs/exec.c
index 1977c2a..e9552b2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -57,6 +57,11 @@
 #include <linux/oom.h>
 #include <linux/compat.h>
 
+#ifdef CONFIG_PAX_REFCOUNT
+#include <linux/kallsyms.h>
+#include <linux/kdebug.h>
+#endif
+
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
@@ -1743,3 +1748,21 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 				  argv, envp, flags);
 }
 #endif
+
+#ifdef CONFIG_PAX_REFCOUNT
+void pax_report_refcount_overflow(struct pt_regs *regs)
+{
+	if (current->signal->curr_ip)
+		printk(KERN_EMERG "PAX: From %pI4: refcount overflow detected in: %s:%d, uid/euid: %u/%u\n",
+				&current->signal->curr_ip, current->comm, task_pid_nr(current),
+				from_kuid_munged(&init_user_ns, current_uid()), from_kuid_munged(&init_user_ns, current_euid()));
+	else
+		printk(KERN_EMERG "PAX: refcount overflow detected in: %s:%d, uid/euid: %u/%u\n", current->comm, task_pid_nr(current),
+				from_kuid_munged(&init_user_ns, current_uid()), from_kuid_munged(&init_user_ns, current_euid()));
+	print_symbol(KERN_EMERG "PAX: refcount overflow occured at: %s\n", instruction_pointer(regs));
+	preempt_disable();
+	show_regs(regs);
+	preempt_enable();
+	force_sig_info(SIGKILL, SEND_SIG_FORCED, current);
+}
+#endif
-- 
2.5.0
