Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Dec 2016 15:13:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161207141353.GJ3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 29, 2016 at 03:35:15PM +0000, Reshetova, Elena wrote:
> So, could we agree on the following additions that are needed to refcount_t API:
> 
> - refcount_long_t and all related functions

sed -e 's/refcount_/&long_/g' -e 's/atomic_/&long_/g'
	-e 's/REFCOUNT_/&LONG_/g' -e 's/ATOMIC_/&LONG_/g'
	-e 's/unsigned int/unsigned long/g' -e 's/UINT/ULONG/g'

I can do a proper patch once the interface settles down.

> - refcount_add(), refcount_sub(), refcount_sub_and_test()
> - refcount_dec_if_one()

See below, completely untested.

> - refcount_dec_return(), refcount_inc_return()

Skipped those.

---
Subject: refcount_t: A special purpose refcount type
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Nov 14 18:06:19 CET 2016

Provide refcount_t, an atomic_t like primitive built just for
refcounting.

It provides saturation semantics such that overflow becomes impossible
and thereby 'spurious' use-after-free is avoided.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/refcount.h |  262 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile             |    3 
 2 files changed, 264 insertions(+), 1 deletion(-)

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
+	atomic_t refs;
+} refcount_t;
+
+#define REFCOUNT_INIT(n)	{ .refs = ATOMIC_INIT(n), }
+
+static inline void refcount_set(refcount_t *r, unsigned int n)
+{
+	atomic_set(&r->refs, n);
+}
+
+static inline unsigned int refcount_read(const refcount_t *r)
+{
+	return atomic_read(&r->refs);
+}
+
+static inline __must_check
+void refcount_add_not_zero(unsigned int i, refcount_t *r)
+{
+	unsigned int old, new, val = atomic_read(&r->refs);
+
+	for (;;) {
+		if (!val)
+			return false;
+
+		if (unlikely(val == UINT_MAX))
+			return true;
+
+		new = val + i;
+		if (new < val)
+			new = UINT_MAX;
+		old = atomic_cmpxchg_relaxed(&r->refs, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+
+	return true;
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
+	return refcount_add_not_zero(1, r);
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
+	WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+}
+
+static inline void refcount_add(unsigned int i, refcount_t *r)
+{
+	WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
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
+	unsigned int old, new, val = atomic_read(&r->refs);
+
+	for (;;) {
+		if (val == UINT_MAX)
+			return false;
+
+		new = val - i;
+		if (WARN(new > val, "refcount_t: underflow; use-after-free.\n"))
+			return false;
+
+		old = atomic_cmpxchg_release(&r->refs, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	return !new;
+}
+
+static inline __must_check
+bool refcount_dec_and_test(refcount_t *r)
+{
+	return refcount_sub_and_test(1, r);
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
+	WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
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
+	return atomic_cmpxchg_release(&r->refs, 1, 0) == 1;
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
+	unsigned int old, new, val = atomic_read(&r->refs);
+
+	for (;;) {
+		if (val == UINT_MAX)
+			return true;
+
+		if (val == 1)
+			return false;
+
+		new = val - 1;
+		if (WARN(new > val, "refcount_t: underflow; use-after-free.\n"))
+			return true;
+
+		old = atomic_cmpxchg_release(&r->refs, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	return true;
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
+	if (refcount_dec_not_one(r))
+		return false;
+
+	mutex_lock(lock);
+	if (!refcount_dec_and_test(r)) {
+		mutex_unlock(lock);
+		return false;
+	}
+
+	return true;
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
+	if (refcount_dec_not_one(r))
+		return false;
+
+	spin_lock(lock);
+	if (!refcount_dec_and_test(r)) {
+		spin_unlock(lock);
+		return false;
+	}
+
+	return true;
+}
+
+#endif /* _LINUX_REFCOUNT_H */
