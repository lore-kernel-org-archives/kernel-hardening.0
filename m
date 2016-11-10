Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 10 Nov 2016 22:24:37 +0200
Message-Id: <1478809488-18303-3-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v4 PATCH 02/13] percpu-refcount: leave atomic counter unprotected
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Hans Liljestrand <ishkamiel@gmail.com>

This is a temporary solution, and a deviation from the PaX/Grsecurity
implementation where the counter in question is protected against
overflows. That however necessitates decreasing the PERCPU_COUNT_BIAS
which is used in lib/percpu-refcount.c. Such a change effectively cuts
the safe counter range down by half, and still allows the counter to,
without warning, prematurely reach zero (which is what the bias aims to
prevent).

A slightly expanded summary follows. Please see percpu-refcount source
for more details, particularly lib/percup-refcount.c where the
aforementioned bias is set and documented.

The atomic counter (defined in include/linux/percpu-refcount.h) needs to
be updated in a non-atomic way.  This means that before all the percpu
refs are added the value could be off in either direction, but no more
than the actual "true" value of the counter. In order to prevent the
counter prematurely reaching zero, a bias is used to offset the range
from [MIN,MAX] to [1,MAX]+[MIN,-1] (with "zero" in the middle, as far
from 0 as possible).

The problem is then that if the atomic is protected it cannot wrap (and
zero is already offset next to the "wrap-barrier", so it is practically
guaranteed to do just that). One solution would be to decrease this
bias, effectively cutting the safe range in half (now [1,MAX]). And
while overflows at MAX would be caught, the counter could still
prematurely reach zero. (Although since the counter can be off at most
by it's true value, presumably an overflow would still trigger at some
point during the percpu ref additions, but not necessarily before zero
had been reached one or more times.)

The immediate solution would be to go with the bias decrease (and
document the repercussions), but we have already seen some objections to
that due to the reasons above. Other solutions would seem to require
more comprehensive changes into how percpu-ref works, which we felt were
not suited for this patch series. We therefore decided to switch the
counter to an atomic_long_wrap_t and just document the issue for now.

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 include/linux/percpu-refcount.h | 18 ++++++++++++++----
 lib/percpu-refcount.c           | 12 ++++++------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 1c7eec0..7c6a482 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -81,7 +81,17 @@ enum {
 };
 
 struct percpu_ref {
-	atomic_long_t		count;
+	/*
+	 * This is a temporary solution.
+	 *
+	 * The count should technically not be allowed to wrap, but due to the
+	 * way the counter is used (in lib/percpu-refcount.c) together with the
+	 * PERCPU_COUNT_BIAS it needs to wrap. This leaves the counter open
+	 * to over/underflows. A non-wrapping atomic, together with a bias
+	 * decrease would reduce the safe range in half, and also offer only
+	 * partial protection.
+	 */
+	atomic_long_wrap_t	count;
 	/*
 	 * The low bit of the pointer indicates whether the ref is in percpu
 	 * mode; if set, then get/put will manipulate the atomic_t.
@@ -174,7 +184,7 @@ static inline void percpu_ref_get_many(struct percpu_ref *ref, unsigned long nr)
 	if (__ref_is_percpu(ref, &percpu_count))
 		this_cpu_add(*percpu_count, nr);
 	else
-		atomic_long_add(nr, &ref->count);
+		atomic_long_add_wrap(nr, &ref->count);
 
 	rcu_read_unlock_sched();
 }
@@ -272,7 +282,7 @@ static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
 
 	if (__ref_is_percpu(ref, &percpu_count))
 		this_cpu_sub(*percpu_count, nr);
-	else if (unlikely(atomic_long_sub_and_test(nr, &ref->count)))
+	else if (unlikely(atomic_long_sub_and_test_wrap(nr, &ref->count)))
 		ref->release(ref);
 
 	rcu_read_unlock_sched();
@@ -320,7 +330,7 @@ static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
 
 	if (__ref_is_percpu(ref, &percpu_count))
 		return false;
-	return !atomic_long_read(&ref->count);
+	return !atomic_long_read_wrap(&ref->count);
 }
 
 #endif
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 9ac959e..2849e06 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -80,7 +80,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 	else
 		start_count++;
 
-	atomic_long_set(&ref->count, start_count);
+	atomic_long_set_wrap(&ref->count, start_count);
 
 	ref->release = release;
 	ref->confirm_switch = NULL;
@@ -134,7 +134,7 @@ static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
 		count += *per_cpu_ptr(percpu_count, cpu);
 
 	pr_debug("global %ld percpu %ld",
-		 atomic_long_read(&ref->count), (long)count);
+		 atomic_long_read_wrap(&ref->count), (long)count);
 
 	/*
 	 * It's crucial that we sum the percpu counters _before_ adding the sum
@@ -148,11 +148,11 @@ static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
 	 * reaching 0 before we add the percpu counts. But doing it at the same
 	 * time is equivalent and saves us atomic operations:
 	 */
-	atomic_long_add((long)count - PERCPU_COUNT_BIAS, &ref->count);
+	atomic_long_add_wrap((long)count - PERCPU_COUNT_BIAS, &ref->count);
 
-	WARN_ONCE(atomic_long_read(&ref->count) <= 0,
+	WARN_ONCE(atomic_long_read_wrap(&ref->count) <= 0,
 		  "percpu ref (%pf) <= 0 (%ld) after switching to atomic",
-		  ref->release, atomic_long_read(&ref->count));
+		  ref->release, atomic_long_read_wrap(&ref->count));
 
 	/* @ref is viewed as dead on all CPUs, send out switch confirmation */
 	percpu_ref_call_confirm_rcu(rcu);
@@ -194,7 +194,7 @@ static void __percpu_ref_switch_to_percpu(struct percpu_ref *ref)
 	if (!(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC))
 		return;
 
-	atomic_long_add(PERCPU_COUNT_BIAS, &ref->count);
+	atomic_long_add_wrap(PERCPU_COUNT_BIAS, &ref->count);
 
 	/*
 	 * Restore per-cpu operation.  smp_store_release() is paired with
-- 
2.7.4
