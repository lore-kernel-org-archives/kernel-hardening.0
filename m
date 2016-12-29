Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 29 Dec 2016 08:55:58 +0200
Message-Id: <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an atomic_t like primitive built just for refcounting.
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

It provides saturation semantics such that overflow becomes impossible
and thereby 'spurious' use-after-free is avoided.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/kref.h     |  23 ++---
 include/linux/refcount.h | 262 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 273 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/refcount.h

diff --git a/include/linux/kref.h b/include/linux/kref.h
index a5181bd..78f840a 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -19,23 +19,26 @@
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 
 struct kref {
-	atomic_t refcount;
+	refcount_t refcount;
 };
 
+#define KREF_INIT(n)	{ .refcount = REFCOUNT_INIT(n), }
+
 /**
  * kref_init - initialize object.
  * @kref: object in question.
  */
 static inline void kref_init(struct kref *kref)
 {
-	atomic_set(&kref->refcount, 1);
+	refcount_set(&kref->refcount, 1);
 }
 
 static inline int kref_read(const struct kref *kref)
 {
-	return atomic_read(&kref->refcount);
+	return refcount_read(&kref->refcount);
 }
 
 /**
@@ -44,11 +47,7 @@ static inline int kref_read(const struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
-	/* If refcount was 0 before incrementing then we have a race
-	 * condition when this kref is freeing by some other thread right now.
-	 * In this case one should use kref_get_unless_zero()
-	 */
-	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
+	refcount_inc(&kref->refcount);
 }
 
 /**
@@ -72,7 +71,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 {
 	WARN_ON(release == NULL);
 
-	if (atomic_dec_and_test(&kref->refcount)) {
+	if (refcount_dec_and_test(&kref->refcount)) {
 		release(kref);
 		return 1;
 	}
@@ -85,7 +84,7 @@ static inline int kref_put_mutex(struct kref *kref,
 {
 	WARN_ON(release == NULL);
 
-	if (atomic_dec_and_mutex_lock(&kref->refcount, lock)) {
+	if (refcount_dec_and_mutex_lock(&kref->refcount, lock)) {
 		release(kref);
 		return 1;
 	}
@@ -98,7 +97,7 @@ static inline int kref_put_lock(struct kref *kref,
 {
 	WARN_ON(release == NULL);
 
-	if (atomic_dec_and_lock(&kref->refcount, lock)) {
+	if (refcount_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
 		return 1;
 	}
@@ -123,6 +122,6 @@ static inline int kref_put_lock(struct kref *kref,
  */
 static inline int __must_check kref_get_unless_zero(struct kref *kref)
 {
-	return atomic_add_unless(&kref->refcount, 1, 0);
+	return refcount_inc_not_zero(&kref->refcount);
 }
 #endif /* _KREF_H_ */
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
new file mode 100644
index 0000000..fc5abdb
--- /dev/null
+++ b/include/linux/refcount.h
@@ -0,0 +1,262 @@
+#ifndef _LINUX_REFCOUNT_H
+#define _LINUX_REFCOUNT_H
+
+/*
+ * Variant of atomic_t specialized for reference counts.
+ *
+ * The interface matches the atomic_t interface (to aid in porting) but only
+ * provides the few functions one should use for reference counting.
+ *
+ * It differs in that the counter saturates at UINT_MAX and will not move once
+ * there. This avoids wrapping the counter and causing 'spurious'
+ * use-after-free issues.
+ *
+ * Memory ordering rules are slightly relaxed wrt regular atomic_t functions
+ * and provide only what is strictly required for refcounts.
+ *
+ * The increments are fully relaxed; these will not provide ordering. The
+ * rationale is that whatever is used to obtain the object we're increasing the
+ * reference count on will provide the ordering. For locked data structures,
+ * its the lock acquire, for RCU/lockless data structures its the dependent
+ * load.
+ *
+ * Do note that inc_not_zero() provides a control dependency which will order
+ * future stores against the inc, this ensures we'll never modify the object
+ * if we did not in fact acquire a reference.
+ *
+ * The decrements will provide release order, such that all the prior loads and
+ * stores will be issued before, it also provides a control dependency, which
+ * will order us against the subsequent free().
+ *
+ * The control dependency is against the load of the cmpxchg (ll/sc) that
+ * succeeded. This means the stores aren't fully ordered, but this is fine
+ * because the 1->0 transition indicates no concurrency.
+ *
+ * Note that the allocator is responsible for ordering things between free()
+ * and alloc().
+ *
+ */
+
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+typedef struct refcount_struct {
+       atomic_t refs;
+} refcount_t;
+
+#define REFCOUNT_INIT(n)       { .refs = ATOMIC_INIT(n), }
+
+static inline void refcount_set(refcount_t *r, unsigned int n)
+{
+       atomic_set(&r->refs, n);
+}
+
+static inline unsigned int refcount_read(const refcount_t *r)
+{
+       return atomic_read(&r->refs);
+}
+
+static inline __must_check
+bool refcount_add_not_zero(unsigned int i, refcount_t *r)
+{
+       unsigned int old, new, val = atomic_read(&r->refs);
+
+       for (;;) {
+               if (!val)
+                       return false;
+
+               if (unlikely(val == UINT_MAX))
+                       return true;
+
+               new = val + i;
+               if (new < val)
+                       new = UINT_MAX;
+               old = atomic_cmpxchg_relaxed(&r->refs, val, new);
+               if (old == val)
+                       break;
+
+               val = old;
+       }
+
+       WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+
+       return true;
+}
+
+/*
+ * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WARN.
+ *
+ * Provides no memory ordering, it is assumed the caller has guaranteed the
+ * object memory to be stable (RCU, etc.). It does provide a control dependency
+ * and thereby orders future stores. See the comment on top.
+ */
+static inline __must_check
+bool refcount_inc_not_zero(refcount_t *r)
+{
+       return refcount_add_not_zero(1, r);
+}
+
+/*
+ * Similar to atomic_inc(), will saturate at UINT_MAX and WARN.
+ *
+ * Provides no memory ordering, it is assumed the caller already has a
+ * reference on the object, will WARN when this is not so.
+ */
+static inline void refcount_inc(refcount_t *r)
+{
+       WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+}
+
+static inline void refcount_add(unsigned int i, refcount_t *r)
+{
+       WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
+}
+
+/*
+ * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
+ * decrement when saturated at UINT_MAX.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides a control dependency such that free() must come after.
+ * See the comment on top.
+ */
+static inline __must_check
+bool refcount_sub_and_test(unsigned int i, refcount_t *r)
+{
+       unsigned int old, new, val = atomic_read(&r->refs);
+
+       for (;;) {
+               if (val == UINT_MAX)
+                       return false;
+
+               new = val - i;
+               if (WARN(new > val, "refcount_t: underflow; use-after-free.\n"))
+                       return false;
+
+               old = atomic_cmpxchg_release(&r->refs, val, new);
+               if (old == val)
+                       break;
+
+               val = old;
+       }
+
+       return !new;
+}
+
+static inline __must_check
+bool refcount_dec_and_test(refcount_t *r)
+{
+       return refcount_sub_and_test(1, r);
+}
+
+/*
+ * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
+ * when saturated at UINT_MAX.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before.
+ */
+static inline
+void refcount_dec(refcount_t *r)
+{
+       WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
+}
+
+/*
+ * No atomic_t counterpart, it attempts a 1 -> 0 transition and returns the
+ * success thereof.
+ *
+ * Like all decrement operations, it provides release memory order and provides
+ * a control dependency.
+ *
+ * It can be used like a try-delete operator; this explicit case is provided
+ * and not cmpxchg in generic, because that would allow implementing unsafe
+ * operations.
+ */
+static inline __must_check
+bool refcount_dec_if_one(refcount_t *r)
+{
+       return atomic_cmpxchg_release(&r->refs, 1, 0) == 1;
+}
+
+/*
+ * No atomic_t counterpart, it decrements unless the value is 1, in which case
+ * it will return false.
+ *
+ * Was often done like: atomic_add_unless(&var, -1, 1)
+ */
+static inline __must_check
+bool refcount_dec_not_one(refcount_t *r)
+{
+       unsigned int old, new, val = atomic_read(&r->refs);
+
+       for (;;) {
+               if (val == UINT_MAX)
+                       return true;
+
+               if (val == 1)
+                       return false;
+
+               new = val - 1;
+               if (WARN(new > val, "refcount_t: underflow; use-after-free.\n"))
+                       return true;
+
+               old = atomic_cmpxchg_release(&r->refs, val, new);
+               if (old == val)
+                       break;
+
+               val = old;
+       }
+
+       return true;
+}
+
+/*
+ * Similar to atomic_dec_and_mutex_lock(), it will WARN on underflow and fail
+ * to decrement when saturated at UINT_MAX.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides a control dependency such that free() must come after.
+ * See the comment on top.
+ */
+static inline __must_check
+bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
+{
+       if (refcount_dec_not_one(r))
+               return false;
+
+       mutex_lock(lock);
+       if (!refcount_dec_and_test(r)) {
+               mutex_unlock(lock);
+               return false;
+       }
+
+       return true;
+}
+
+/*
+ * Similar to atomic_dec_and_lock(), it will WARN on underflow and fail to
+ * decrement when saturated at UINT_MAX.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides a control dependency such that free() must come after.
+ * See the comment on top.
+ */
+static inline __must_check
+bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
+{
+       if (refcount_dec_not_one(r))
+               return false;
+
+       spin_lock(lock);
+       if (!refcount_dec_and_test(r)) {
+               spin_unlock(lock);
+               return false;
+       }
+
+       return true;
+}
+
+#endif /* _LINUX_REFCOUNT_H */
-- 
2.7.4
