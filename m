Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 14:00:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111130034.GO3157@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110235714.GR3568@worktop.programming.kicks-ass.net>
 <1478824161.7326.5.camel@cvidal.org>
 <20161111124126.GG11945@leverpostej>
 <20161111124755.GI3117@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161111124755.GI3117@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 01:47:55PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 11, 2016 at 12:41:27PM +0000, Mark Rutland wrote:

> > Regardless of atomic_t semantics, a refcount_t would be far more obvious
> > to developers than atomic_t and/or kref, and better documents the intent
> > of code using it.
> > 
> > We'd still see abuse of atomic_t (and so this won't solve the problems
> > Kees mentioned), but even as something orthogonal I think that would
> > make sense to have.
> 
> Furthermore, you could implement that refcount_t stuff using
> atomic_cmpxchg() in generic code. While that is sub-optimal for ll/sc
> architectures you at least get generic code that works to get started.
> 
> Also, I suspect that if your refcounts are heavily contended, you'll
> have other problems than the performance of these primitives.
> 
> Code for refcount_inc(), refcount_inc_not_zero() and
> refcount_sub_and_test() can be copy-pasted from the kref patch I send
> yesterday.

A wee bit like so...

---
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
new file mode 100644
index 000000000000..d1eae0d2345e
--- /dev/null
+++ b/include/linux/refcount.h
@@ -0,0 +1,75 @@
+#ifndef _LINUX_REFCOUNT_H
+#define _LINUX_REFCOUNT_H
+
+#include <linux/atomic.h>
+
+typedef struct refcount_struct {
+	atomic_t refs;
+} refcount_t;
+
+static inline void refcount_inc(refcount_t *r)
+{
+	unsigned int old, new, val = atomic_read(&r->refs);
+
+	for (;;) {
+		WARN_ON_ONCE(!val);
+
+		new = val + 1;
+		if (new < val)
+			BUG(); /* overflow */
+
+		old = atomic_cmpxchg_relaxed(&r->refs, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+}
+
+static inline bool refcount_inc_not_zero(refcount_t *r)
+{
+	unsigned int old, new, val = atomic_read(&r->refs);
+
+	for (;;) {
+		if (!val)
+			return false;
+
+		new = val + 1;
+		if (new < val)
+			BUG(); /* overflow */
+
+		old = atomic_cmpxchg_relaxed(&r->refs, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	return true;
+}
+
+static inline bool refcount_sub_and_test(int i, refcount_t *r)
+{
+	unsigned int old, new, val = atomic_read(&r->refs);
+
+	for (;;) {
+		new = val - i;
+		if (new > val)
+			BUG(); /* underflow */
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
+static inline bool refcount_dec_and_test(refcount_t *r)
+{
+	return refcount_sub_and_test(1, r);
+}
+
+#endif /* _LINUX_REFCOUNT_H */
