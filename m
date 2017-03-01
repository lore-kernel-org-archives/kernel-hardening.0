From: David Windsor <dwindsor@gmail.com>
Date: Tue, 28 Feb 2017 22:34:45 -0500
Message-Id: <1488339285-23777-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening] [PATCH] refcount: add refcount_t API kernel-doc comments
To: peterz@infradead.org, mingo@kernel.org, elena.reshetova@intel.com, dwindsor@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds kernel-doc comments for the new refcount_t API.

Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/linux/refcount.h | 19 ++++++++++
 lib/refcount.c           | 95 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 105 insertions(+), 9 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 0023fee..3c02135 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -6,17 +6,36 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 
+/**
+ * refcount_t - variant of atomic_t specialized for reference counts
+ * @refs: atomic_t counter field
+ *
+ * The counter saturates at UINT_MAX and will not move once
+ * there. This avoids wrapping the counter and causing 'spurious'
+ * use-after-free issues.
+ */
 typedef struct refcount_struct {
 	atomic_t refs;
 } refcount_t;
 
 #define REFCOUNT_INIT(n)	{ .refs = ATOMIC_INIT(n), }
 
+/**
+ * refcount_set - set a refcount's value
+ * @r: the refcount
+ * @n: value to which the refcount will be set
+ */
 static inline void refcount_set(refcount_t *r, unsigned int n)
 {
 	atomic_set(&r->refs, n);
 }
 
+/**
+ * refcount_read - get a refcount's value
+ * @r: the refcount
+ *
+ * Return: the refcount's value
+ */
 static inline unsigned int refcount_read(const refcount_t *r)
 {
 	return atomic_read(&r->refs);
diff --git a/lib/refcount.c b/lib/refcount.c
index 1d33366..30e0927 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -37,6 +37,15 @@
 #include <linux/refcount.h>
 #include <linux/bug.h>
 
+/**
+ * refcount_add_not_zero - add a value to a refcount unless the refcount is 0
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Will saturate at UINT_MAX and WARN.
+ *
+ * Return: false if the refcount is 0, true otherwise.
+ */
 bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 {
 	unsigned int old, new, val = atomic_read(&r->refs);
@@ -64,18 +73,30 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_add_not_zero);
 
+/**
+ * refcount_add - add a value to a refcount
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Similar to atomic_add(), will saturate at UINT_MAX and WARN.
+ */
 void refcount_add(unsigned int i, refcount_t *r)
 {
 	WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_add);
 
-/*
+/**
+ * refcount_inc_not_zero - increment a refcount unless it is 0
+ * @r: the refcount to increment
+ *
  * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WARN.
  *
  * Provides no memory ordering, it is assumed the caller has guaranteed the
  * object memory to be stable (RCU, etc.). It does provide a control dependency
  * and thereby orders future stores. See the comment on top.
+ *
+ * Return: false if the refcount is 0, true otherwise
  */
 bool refcount_inc_not_zero(refcount_t *r)
 {
@@ -103,11 +124,16 @@ bool refcount_inc_not_zero(refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_inc_not_zero);
 
-/*
+/**
+ * refcount_inc - increment a refcount
+ * @r: the refcount to increment
+ *
  * Similar to atomic_inc(), will saturate at UINT_MAX and WARN.
  *
  * Provides no memory ordering, it is assumed the caller already has a
  * reference on the object, will WARN when this is not so.
+ *
+ * Will WARN if refcount is 0.
  */
 void refcount_inc(refcount_t *r)
 {
@@ -115,6 +141,22 @@ void refcount_inc(refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_inc);
 
+/**
+ * refcount_sub_and_test - subtract from a refcount and test if it is 0
+ * @i: amount to subtract from the refcount
+ * @r: the refcount
+ *
+ * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
+ * decrement when saturated at UINT_MAX.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides a control dependency such that free() must come after.
+ * See the comment on top.
+ *
+ * Return: true if the resulting refcount is greater than 0, false if the
+ * resulting refcount is 0, the refcount is saturated at UINT_MAX or the
+ * subtraction operation causes an underflow.
+ */
 bool refcount_sub_and_test(unsigned int i, refcount_t *r)
 {
 	unsigned int old, new, val = atomic_read(&r->refs);
@@ -140,13 +182,20 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_sub_and_test);
 
-/*
+/**
+ * refcount_dec_and_test - decrement a refcount and test if it is 0
+ * @r: the refcount
+ *
  * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
  * decrement when saturated at UINT_MAX.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides a control dependency such that free() must come after.
  * See the comment on top.
+ *
+ * Return: true if the resulting refcount is greater than 0, false if the
+ * resulting refcount is 0, the refcount is saturated at UINT_MAX or the
+ * decrement operation causes an underflow.
  */
 bool refcount_dec_and_test(refcount_t *r)
 {
@@ -154,21 +203,26 @@ bool refcount_dec_and_test(refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_dec_and_test);
 
-/*
+/**
+ * refcount_dec - decrement a refcount
+ * @r: the refcount
+ *
  * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
  * when saturated at UINT_MAX.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before.
  */
-
 void refcount_dec(refcount_t *r)
 {
 	WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
 }
 EXPORT_SYMBOL_GPL(refcount_dec);
 
-/*
+/**
+ * refcount_dec_if_one - decrement a refcount if it is 1
+ * @r: the refcount
+ *
  * No atomic_t counterpart, it attempts a 1 -> 0 transition and returns the
  * success thereof.
  *
@@ -178,6 +232,8 @@ EXPORT_SYMBOL_GPL(refcount_dec);
  * It can be used like a try-delete operator; this explicit case is provided
  * and not cmpxchg in generic, because that would allow implementing unsafe
  * operations.
+ *
+ * Return: true if the 1 -> 0 transition was successful, false otherwise
  */
 bool refcount_dec_if_one(refcount_t *r)
 {
@@ -185,11 +241,16 @@ bool refcount_dec_if_one(refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_dec_if_one);
 
-/*
+/**
+ * refcount_dec_not_one - decrement a refcount if it is not 1
+ * @r: the refcount
+ *
  * No atomic_t counterpart, it decrements unless the value is 1, in which case
  * it will return false.
  *
  * Was often done like: atomic_add_unless(&var, -1, 1)
+ *
+ * Return: true if the decrement operation was successful, false otherwise
  */
 bool refcount_dec_not_one(refcount_t *r)
 {
@@ -219,13 +280,21 @@ bool refcount_dec_not_one(refcount_t *r)
 }
 EXPORT_SYMBOL_GPL(refcount_dec_not_one);
 
-/*
+/**
+ * refcount_dec_and_mutex_lock - return holding mutex if able to decrement
+ *                               refcount to 0
+ * @r: the refcount
+ * @lock: the mutex to be locked
+ *
  * Similar to atomic_dec_and_mutex_lock(), it will WARN on underflow and fail
  * to decrement when saturated at UINT_MAX.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides a control dependency such that free() must come after.
  * See the comment on top.
+ *
+ * Return: true and hold lock if able to decrement refcount to 0, false
+ *         otherwise
  */
 bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
 {
@@ -242,13 +311,21 @@ bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
 }
 EXPORT_SYMBOL_GPL(refcount_dec_and_mutex_lock);
 
-/*
+/**
+ * refcount_dec_and_lock - return holding spinlock if able to decrement
+ *                         refcount to 0
+ * @r: the refcount
+ * @lock: the spinlock to be locked
+ *
  * Similar to atomic_dec_and_lock(), it will WARN on underflow and fail to
  * decrement when saturated at UINT_MAX.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides a control dependency such that free() must come after.
  * See the comment on top.
+ *
+ * Return: true and hold lock if able to decrement refcount to 0, false
+ *         otherwise
  */
 bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
 {
-- 
2.7.4
