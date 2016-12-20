Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Dec 2016 14:13:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161220131345.GM3124@twins.programming.kicks-ass.net>
References: <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
 <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
 <20161216140158.GS3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
 <20161219101243.GB3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C22713@IRSMSX102.ger.corp.intel.com>
 <20161220094152.GK3124@twins.programming.kicks-ass.net>
 <1482231302.28665.56.camel@cs-046.org.aalto.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482231302.28665.56.camel@cs-046.org.aalto.fi>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Liljestrand Hans <ishkamiel@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 20, 2016 at 12:55:02PM +0200, Liljestrand Hans wrote:

> For reference, I've listed here the places that were causing "increment
> on 0" WARNs on my previous boot (temporarily allowed inc on 0 to make
> boot possible). These seem to be mostly related to resource reuse, but
> we haven't yet to looked in detail on how to deal with them.
> 
> fs/ext4/mballoc.c:3399          ext4_mb_use_preallocated
>         Seems to have separate tracking of destruction

This one seems particularly daft, since afaict all pa_count usage is
under pa_lock. No need for it to be atomic. Also, that code is weird, it
has separate pa_free and pa_deleted state.

This should definitely not be converted to refcount_t until its
sanitized.

> net/ipv4/fib_semantics.c:994    fib_create_info

This one I'm not sure how its not broken.

It does something like:

		ofi = fib_find_info(fi);
		if (ofi) {
			// use ofi, free fi
		}

		spin_lock_hb();
		atomic_inc(&fi->fib_clntref);
		// insert fi
		spin_unlock_hb();


If that races against itself, both instances can fail to find an
existing matching fi, and both will insert fi, resulting in a duplicate
fi.

Also, note that at the point of atomic_inc(), fi isn't in fact published
and therefore this need not be an atomic operation.

I could of course miss something subtle, since I only read part of this
code. In any case, even if that were somehow incorrect, I think you can
init fib_clntref with 1 and make it work with that.

> net/ipv4/devinet.c:233          inetdev_init

This seems to use atomic_inc before the object is published, and could
therefore simply use atomic_set().

> net/ipv4/tcp_ipv4.c:1793        inet_sk_rx_dst_set

That needs more context to be evaluated. Also seems very dodgy code in
any case. We need the caller of this function that calls it on 0.

> net/ipv4/route.c:2153:          __ip_route_output_key_hash

need more context, there's not in fact an atomic_ in that function, and
its a giant function.

> net/ipv6/ip6_fib.c:949          fib6_add

Can't make sense of this :/



Didn't look at the rest, but going by the above blindly converting to
refcount_t without prior cleanups isn't a good idea.
