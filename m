Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 13:47:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111124755.GI3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net>
 <20161110204838.GE17134@arm.com>
 <20161110211310.GX3117@twins.programming.kicks-ass.net>
 <20161110222744.GD8086@kroah.com>
 <CAGXu5jJz_dHt-QNqPrYFnQNhj1oV_ux62SSi=PN=VEBm6oq0Mg@mail.gmail.com>
 <20161110235714.GR3568@worktop.programming.kicks-ass.net>
 <1478824161.7326.5.camel@cvidal.org>
 <20161111124126.GG11945@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161111124126.GG11945@leverpostej>
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 12:41:27PM +0000, Mark Rutland wrote:
> On Fri, Nov 11, 2016 at 01:29:21AM +0100, Colin Vidal wrote:

> > I wonder if we didn't make a confusion between naming and
> > specifications. I have thought about Kees idea and what you're saying:
> > 
> > - The name "atomic_t" name didn't tell anything about if the variable
> >   can wrap or not. It just tells there is no race condition on
> >   concurrent access, nothing else, and users are well with that. OK
> >   then, we don't modify atomic_t, it makes sense.
> > 
> > - Hence, let's say a new type "refcount_t". It names exactly what we
> >   try to protect in this patch set. A much more simpler interface than
> >   atomic_t would be needed, and it protects on race condition and
> >   overflows (precisely what is expected of a counter reference). Not
> >   an opt-in solution, but it is much less invasive since we "just"
> >   have to modify the kref implementation and some vfs reference
> >   counters.
> > 
> > That didn't tell us how actually implements refcount_t: reuse some
> > atomic_t code or not (it would be simpler anyways, since we don't have
> > to implement the whole atomic_t interface). Still, this is another
> > problem.
> > 
> > Sounds better?
> 
> Regardless of atomic_t semantics, a refcount_t would be far more obvious
> to developers than atomic_t and/or kref, and better documents the intent
> of code using it.
> 
> We'd still see abuse of atomic_t (and so this won't solve the problems
> Kees mentioned), but even as something orthogonal I think that would
> make sense to have.

Furthermore, you could implement that refcount_t stuff using
atomic_cmpxchg() in generic code. While that is sub-optimal for ll/sc
architectures you at least get generic code that works to get started.

Also, I suspect that if your refcounts are heavily contended, you'll
have other problems than the performance of these primitives.

Code for refcount_inc(), refcount_inc_not_zero() and
refcount_sub_and_test() can be copy-pasted from the kref patch I send
yesterday.
