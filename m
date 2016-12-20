Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1482231302.28665.56.camel@cs-046.org.aalto.fi>
From: Liljestrand Hans <ishkamiel@gmail.com>
Date: Tue, 20 Dec 2016 12:55:02 +0200
In-Reply-To: <20161220094152.GK3124@twins.programming.kicks-ass.net>
References: <20161128121347.GY3092@twins.programming.kicks-ass.net>
	 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
	 <20161201191543.GG3124@twins.programming.kicks-ass.net>
	 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
	 <20161207135241.GI3107@twins.programming.kicks-ass.net>
	 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
	 <20161216140158.GS3107@twins.programming.kicks-ass.net>
	 <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
	 <20161219101243.GB3107@twins.programming.kicks-ass.net>
	 <2236FBA76BA1254E88B949DDB74E612B41C22713@IRSMSX102.ger.corp.intel.com>
	 <20161220094152.GK3124@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-12-20 at 10:41 +0100, Peter Zijlstra wrote:
> On Tue, Dec 20, 2016 at 09:13:58AM +0000, Reshetova, Elena wrote:
> > > On Mon, Dec 19, 2016 at 07:55:15AM +0000, Reshetova, Elena wrote:
> > > > Well, again, you are right in theory, but in practice for example for struct
> > > sched_group { atomic_t ref; ... }:
> > > >
> > > > http://lxr.free-electrons.com/source/kernel/sched/core.c#L6178
> > > >
> > > > To me this is a refcounter that needs the protection.
> > > 
> > > Only if you have more than UINT_MAX CPUs or something like that.
> > > 
> > > And if you really really want to use refcount_t there, you could +1 the
> > > scheme and it'd work again.
> > 
> > Well, yes, probably, but there are many cases like this in practice,
> > so we would need to have a good plan how to get it all submitted and
> > tested properly. The current patch set is already bigger than what we
> > had before and it is only growing.  Hans will provide more info later
> > today based on his testing, which shows many places in kernel core
> > where we DO actually have increment on zero happening in practice and
> > whole kernel doesn't even boot with the strictest approach (refusing
> > to inc on zero). And we are only able to test for x86.... 
> > 
> > Given the massive amount of changes, it would be good to merge this at
> > least in couple of stages: 
> > 
> > 1) first soft version of refcount_t API which at least allows
> > increment on zero and all atomic_t used as refcounter occurrences that
> > don't require reference counter scheme change (+1 or other) 2) patch
> > set that fixes all problematic places (potentially with code rewrite)
> > 3) patch that removes possibility of inc on zero from refcount_t
> 
> I don't get it. Why ?
> 
> Just leave the weird and problematic cases using atomic_t. Its far
> harder to remove crap later.

Yes, ideally we would either fix or leave them as atomic_t. One reason
for the proposal is subtle places that might not get caught in
audit/testing, in those cases allowing refcount_inc to increment on 0
(with a WARN) would ensure the code still works.

We were also hoping reviewing might have been easier with that
separation, but perhaps that was misguided, and separating/skipping the
weird places might serve the same purpose without mucking with the API.


For reference, I've listed here the places that were causing "increment
on 0" WARNs on my previous boot (temporarily allowed inc on 0 to make
boot possible). These seem to be mostly related to resource reuse, but
we haven't yet to looked in detail on how to deal with them.

fs/ext4/mballoc.c:3399          ext4_mb_use_preallocated
        Seems to have separate tracking of destruction
net/ipv4/fib_semantics.c:994    fib_create_info
net/ipv4/devinet.c:233          inetdev_init
net/ipv4/tcp_ipv4.c:1793        inet_sk_rx_dst_set
net/ipv4/route.c:2153:          __ip_route_output_key_hash
net/ipv6/ip6_fib.c:949          fib6_add
net/ipv6/route.c:1048           ip6_pol_route
net/ipv6/addrconf.c:930         ipv6_add_addr
net/ipv6/addrconf.c:357         ipv6_add_dev
net/core/filter.c:940           sk_filter_charge
        net stuff related to caching?
fs/inode.c:813                  find_inode_fast
        Seems to reuse freeing resources?
mm/backing-dev.c:399            wb_congested_get_create
        Initializes to 0

There's also some places that initializes the refcounts to zero (either
using REFCOUNT_INIT or refcount_set). Some of these places are quite
confusing (or, at least to me), so the idea was that doing the changes
incrementally might keep them more manageable.

Regards,
-hans liljestrand
