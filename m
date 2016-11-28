Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 28 Nov 2016 13:13:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161128121347.GY3092@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, aik@ozlabs.ru, david@gibson.dropbear.id.au
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 28, 2016 at 11:56:17AM +0000, Reshetova, Elena wrote:
> First, about the types. 
> We do have a number of instances of atomic_long_t used as refcounters, see below:

Right, those were expected. We could do long_refcount_t I suppose.

> And yes, we *do* have at least one instance (again not 100% finished,
> more might show up) of atomic64_t used as refcounter:
> 
> arch/powerpc/mm/mmu_context_iommu.c:
> struct mm_iommu_table_group_mem_t {
> ...
>     atomic64_t mapped;
> ...
> }

*urgh*, Alexey does that really need to be atomic64_t ? Wouldn't
atomic_long_t work for you?

> Next with regards to API. Networking code surely wins the competitions
> of giving the most trouble.  The biggest overall issue seem to be in
> fact that freeing the object happens not when refcount is zero, but
> when it is -1, which is obviously impossible to implement with current
> API that only returns unsigned int. 
> 
> Most common constructions that are hard to fit into current API are:
> 
> -    if (atomic_cmpxchg(&cur->refcnt, 1, 0) == 1) {...} (typical for networking code)

Right, we spoke about this before, and the dec_if_one() you mentioned
below could replace that.

> -    if (atomic_cmpxchg(&p->refcnt, 0, -1) == 0) {..} (typical for networking code)

That's really weird, a refcount of -1 doesn't really make sense.

> -    if (atomic_add_unless(&inode->i_count, -1, 1)) (typical for fs and other code)

And that's dec_not_one(), really weird that, why do they need that?

> Also, refcount_add() seems to be needed in number of places since it
> looks like refcounts in some cases are increased by two or by some
> constant.  Luckily we haven't seen a need a sub().

There is sub_and_test() usage in for example memcontrol.c.

> The following functions are also needed quite commonly:

> refcount_inc_return()
> refcount_dec_return()

What for? They don't typicaly make sense for refcounting? Other than the
trivial pattern of dec_return() == 0, which is already well covered.

> I also saw one use of this from net/ipv4/udp.c:
>     if (!sk || !atomic_inc_not_zero_hint(&sk->sk_refcnt, 2))

Yes, that one is quite unfortunate, we can trivially support that
ofcourse, but it does make a bit of a mess of things.

> Lastly as I mentioned previously, almost half of invocations of dec()
> in the code is plain atomic_dec() without any if statements and any
> checks on what happens as a result of dec().  Peter previously
> suggested to turn them into WARN_ON(refcount_dec_and_test()), but
> looking in the code, it is not really clear what would this help to
> achieve?  

Well, it clearly marks where refcounting goes bad and we leak crap. A
regular decrement should _never_ hit 0.

> It is clear that in that places the caller explicitly
> doesn't care about how the dec() goes and what is the end result....

No, the typical usage would be you _know_ it will not hit 0. Any other
usage is broken and bad.
