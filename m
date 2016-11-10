Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 00:57:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110235714.GR3568@worktop.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 03:15:44PM -0800, Kees Cook wrote:
> On Thu, Nov 10, 2016 at 2:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Nov 10, 2016 at 10:13:10PM +0100, Peter Zijlstra wrote:

> >> As it stands kref is a pointless wrapper. If it were to provide
> >> something actually useful, like wrap protection, then it might actually
> >> make sense to use it.
> >
> > It provides the correct cleanup ability for a reference count and the
> > object it is in, so it's not all that pointless :)

I really fail to see the point of:

	kref_put(&obj->ref, obj_free);

over:

	if (atomic_dec_and_test(&obj->ref))
		obj_free(obj);

Utter pointless wrappery afaict.

> > But I'm always willing to change it to make it work better for people,
> > if kref did the wrapping protection (i.e. used a non-wrapping atomic
> > type), then you would have that.  I thought that was what this patchset
> > provided...

So kref could simply do something like the below patch. But this patch
set completely rapes the atomic interface.

> > And yes, this is a horridly large patchset.  I've looked at these
> > changes, and in almost all of them, people are using atomic_t as merely
> > a "counter" for something (sequences, rx/tx stats, etc), to get away
> > without having to lock it with an external lock.
> >
> > So, does it make more sense to just provide a "pointless" api for this
> > type of "counter" pattern:
> >         counter_inc()
> >         counter_dec()
> >         counter_read()
> >         counter_set()
> >         counter_add()
> >         counter_subtract()
> > Those would use the wrapping atomic type, as they can wrap all they want
> > and no one really is in trouble.  Once those changes are done, just make
> > atomic_t not wrap and all should be fine, no other code should need to
> > be changed.

Still hate; yes there's a lot of stats which are just fine to wrap. But
there's a lot more atomic out there than refcounts and stats.

The locking primitives for example use atomic_t, and they really don't
want the extra overhead associated with this overflow crap, or the
namespace pollution.

> reference counters (say, "refcount" implemented with new atomic_nowrap_t)
> 
> statistic counters (say, "statcount" implemented with new atomic_wrap_t)
> 
> everything else (named "atomic_t", implemented as either
> atomic_nowrap_t or atomic_wrap_t, depending on CONFIG)

So the problem is that atomic_t has _much_ _much_ more than just add/sub
operations, which are the only ones modified for this patch set.

The whole wrap/nowrap thing doesn't make any bloody sense what so ever
for !arith operators like bitops or just plain cmpxchg.


---
 include/linux/kref.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index e15828fd71f1..6af1f9344793 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -39,11 +39,26 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
-	/* If refcount was 0 before incrementing then we have a race
+	/*
+	 * If refcount was 0 before incrementing then we have a race
 	 * condition when this kref is freeing by some other thread right now.
 	 * In this case one should use kref_get_unless_zero()
 	 */
-	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
+	unsigned int old, new, val = atomic_read(&kref->refcount);
+
+	for (;;) {
+		WARN_ON_ONCE(val < 1);
+
+		new = val + 1;
+		if (new < val)
+			BUG(); /* overflow */
+
+		old = atomic_cmpxchg_relaxed(&kref->refcount, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
 }
 
 /**
@@ -67,9 +82,23 @@ static inline void kref_get(struct kref *kref)
 static inline int kref_sub(struct kref *kref, unsigned int count,
 	     void (*release)(struct kref *kref))
 {
+	unsigned int old, new, val = atomic_read(&kref->refcount);
+
 	WARN_ON(release == NULL);
 
-	if (atomic_sub_and_test((int) count, &kref->refcount)) {
+	for (;;) {
+		new = val - count;
+		if (new > val)
+			BUG(); /* underflow */
+
+		old = atomic_cmpxchg_release(&kref->refcount, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	if (!new) {
 		release(kref);
 		return 1;
 	}
@@ -102,6 +131,7 @@ static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
 {
+	/* XXX also fix */
 	WARN_ON(release == NULL);
 	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
 		mutex_lock(lock);
@@ -133,6 +163,23 @@ static inline int kref_put_mutex(struct kref *kref,
  */
 static inline int __must_check kref_get_unless_zero(struct kref *kref)
 {
-	return atomic_add_unless(&kref->refcount, 1, 0);
+	unsigned int old, new, val = atomic_read(&kref->refcount);
+
+	for (;;) {
+		if (!val)
+			return 0;
+
+		new = val + 1;
+		if (new < val)
+			BUG(); /* overflow */
+
+		old = atomic_cmpxchg_relaxed(&kref->refcount, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	return 1;
 }
 #endif /* _KREF_H_ */
