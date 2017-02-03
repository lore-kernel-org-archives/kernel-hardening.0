Message-Id: <20170203132737.365388918@infradead.org>
Date: Fri, 03 Feb 2017 14:26:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
References: <20170203132558.474916683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-ref-5a.patch
Subject: [kernel-hardening] [PATCH 2/5] kref: Implement using refcount_t
To: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Use the refcount_t 'atomic' type to implement kref, this makes kref
more robust by bringing saturation semantics.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/kref.h |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -15,17 +15,14 @@
 #ifndef _KREF_H_
 #define _KREF_H_
 
-#include <linux/bug.h>
-#include <linux/atomic.h>
-#include <linux/kernel.h>
-#include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/refcount.h>
 
 struct kref {
-	atomic_t refcount;
+	refcount_t refcount;
 };
 
-#define KREF_INIT(n)	{ .refcount = ATOMIC_INIT(n), }
+#define KREF_INIT(n)	{ .refcount = REFCOUNT_INIT(n), }
 
 /**
  * kref_init - initialize object.
@@ -33,12 +30,12 @@ struct kref {
  */
 static inline void kref_init(struct kref *kref)
 {
-	atomic_set(&kref->refcount, 1);
+	refcount_set(&kref->refcount, 1);
 }
 
-static inline int kref_read(const struct kref *kref)
+static inline unsigned int kref_read(const struct kref *kref)
 {
-	return atomic_read(&kref->refcount);
+	return refcount_read(&kref->refcount);
 }
 
 /**
@@ -47,11 +44,7 @@ static inline int kref_read(const struct
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
@@ -75,7 +68,7 @@ static inline int kref_put(struct kref *
 {
 	WARN_ON(release == NULL);
 
-	if (atomic_dec_and_test(&kref->refcount)) {
+	if (refcount_dec_and_test(&kref->refcount)) {
 		release(kref);
 		return 1;
 	}
@@ -88,7 +81,7 @@ static inline int kref_put_mutex(struct
 {
 	WARN_ON(release == NULL);
 
-	if (atomic_dec_and_mutex_lock(&kref->refcount, lock)) {
+	if (refcount_dec_and_mutex_lock(&kref->refcount, lock)) {
 		release(kref);
 		return 1;
 	}
@@ -101,7 +94,7 @@ static inline int kref_put_lock(struct k
 {
 	WARN_ON(release == NULL);
 
-	if (atomic_dec_and_lock(&kref->refcount, lock)) {
+	if (refcount_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
 		return 1;
 	}
@@ -126,6 +119,6 @@ static inline int kref_put_lock(struct k
  */
 static inline int __must_check kref_get_unless_zero(struct kref *kref)
 {
-	return atomic_add_unless(&kref->refcount, 1, 0);
+	return refcount_inc_not_zero(&kref->refcount);
 }
 #endif /* _KREF_H_ */
