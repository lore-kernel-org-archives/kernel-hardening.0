From: David Windsor <dwindsor@gmail.com>
Date: Tue,  7 Feb 2017 18:56:34 -0500
Message-Id: <1486511794-14490-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening] [PATCH] refcount: add refcount_t API kernel-doc comments
To: kernel-hardening@lists.openwall.com, peterz@infradead.org, elena.reshetova@intel.com
Cc: keescook@chromium.org, dwindsor@gmail.com, ishkamiel@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

This adds kernel-doc comments for the new refcount_t API.  Additional feature documentation can go in 
Documentation/security, if needed.

---
 include/linux/refcount.h | 110 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 102 insertions(+), 8 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index fc5abdb..ba5a0214 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -42,22 +42,51 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
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
 
 #define REFCOUNT_INIT(n)       { .refs = ATOMIC_INIT(n), }
 
+/**
+ * refcount_set - set a refcount's internal counter
+ * @r: the refcount
+ * @n: value to which internal counter will be set
+ */
 static inline void refcount_set(refcount_t *r, unsigned int n)
 {
        atomic_set(&r->refs, n);
 }
 
+/**
+ * refcount_read - get a refcount's internal counter
+ * @r: the refcount
+ *
+ * Return: the value of the refcount's internal counter
+ */
 static inline unsigned int refcount_read(const refcount_t *r)
 {
        return atomic_read(&r->refs);
 }
 
+
+/**
+ * refcount_add_not_zero - add a value to a refcount unless the refcount is 0
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Will saturate at UINT_MAX and WARN.
+ *
+ * Return: false if the refcount is 0, true otherwise.
+ */
 static inline __must_check
 bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 {
@@ -85,12 +114,17 @@ bool refcount_add_not_zero(unsigned int i, refcount_t *r)
        return true;
 }
 
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
 static inline __must_check
 bool refcount_inc_not_zero(refcount_t *r)
@@ -98,29 +132,49 @@ bool refcount_inc_not_zero(refcount_t *r)
        return refcount_add_not_zero(1, r);
 }
 
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
 static inline void refcount_inc(refcount_t *r)
 {
        WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
 }
 
+/**
+ * refcount_add - add a value to a refcount
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Similar to atomic_add(), will saturate at UINT_MAX and WARN.
+ */
 static inline void refcount_add(unsigned int i, refcount_t *r)
 {
        WARN(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
 }
 
-/*
+/**
+ * refcount_sub_and_test - subtract from a refcount and test if it is 0
+ * @i: amount to subtract from the refcount
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
+ * resulting refcount is 0, the refcount's initial value is UINT_MAX
+ * or the subtraction operation causes an underflow.
  */
 static inline __must_check
 bool refcount_sub_and_test(unsigned int i, refcount_t *r)
@@ -145,13 +199,27 @@ bool refcount_sub_and_test(unsigned int i, refcount_t *r)
        return !new;
 }
 
+/**
+ * refcount_dec_and_test - decrement a refcount and test if it is 0
+ * @r: the refcount
+ *
+ * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
+ * decrement when saturated at UINT_MAX.
+ *
+ * Return: true if the resulting refcount is greater than 0, false if the
+ * resulting refcount is 0, the refcount's initial value is UINT_MAX
+ * or the decrement operation causes an underflow.
+ */
 static inline __must_check
 bool refcount_dec_and_test(refcount_t *r)
 {
        return refcount_sub_and_test(1, r);
 }
 
-/*
+/**
+ * refcount_dec - decrement a refcount
+ * @r: the refcount
+ *
  * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
  * when saturated at UINT_MAX.
  *
@@ -164,7 +232,10 @@ void refcount_dec(refcount_t *r)
        WARN(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
 }
 
-/*
+/**
+ * refcount_dec_if_one - decrement a refcount if it is 1
+ * @r: the refcount
+ *
  * No atomic_t counterpart, it attempts a 1 -> 0 transition and returns the
  * success thereof.
  *
@@ -174,6 +245,8 @@ void refcount_dec(refcount_t *r)
  * It can be used like a try-delete operator; this explicit case is provided
  * and not cmpxchg in generic, because that would allow implementing unsafe
  * operations.
+ *
+ * Return: true if the refcount was decremented, false otherwise
  */
 static inline __must_check
 bool refcount_dec_if_one(refcount_t *r)
@@ -181,11 +254,16 @@ bool refcount_dec_if_one(refcount_t *r)
        return atomic_cmpxchg_release(&r->refs, 1, 0) == 1;
 }
 
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
+ * Return: false if the refcount was 1, true otherwise
  */
 static inline __must_check
 bool refcount_dec_not_one(refcount_t *r)
@@ -213,13 +291,21 @@ bool refcount_dec_not_one(refcount_t *r)
        return true;
 }
 
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
 static inline __must_check
 bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
@@ -236,13 +322,21 @@ bool refcount_dec_and_mutex_lock(refcount_t *r, struct mutex *lock)
        return true;
 }
 
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
 static inline __must_check
 bool refcount_dec_and_lock(refcount_t *r, spinlock_t *lock)
-- 
2.7.4
