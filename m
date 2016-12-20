Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Dec 2016 11:26:59 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161220102659.GA17424@kroah.com>
References: <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
 <20161216140158.GS3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
 <20161219101243.GB3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C22713@IRSMSX102.ger.corp.intel.com>
 <20161220093051.GB12200@kroah.com>
 <2236FBA76BA1254E88B949DDB74E612B41C22746@IRSMSX102.ger.corp.intel.com>
 <20161220095135.GA13910@kroah.com>
 <2236FBA76BA1254E88B949DDB74E612B41C22783@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C22783@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Liljestrand Hans <ishkamiel@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 20, 2016 at 09:55:58AM +0000, Reshetova, Elena wrote:
> 
> > > > On Tue, Dec 20, 2016 at 09:13:58AM +0000, Reshetova, Elena wrote:
> > > > > > On Mon, Dec 19, 2016 at 07:55:15AM +0000, Reshetova, Elena wrote:
> > > > > > > Well, again, you are right in theory, but in practice for example for
> > struct
> > > > > > sched_group { atomic_t ref; ... }:
> > > > > > >
> > > > > > > http://lxr.free-electrons.com/source/kernel/sched/core.c#L6178
> > > > > > >
> > > > > > > To me this is a refcounter that needs the protection.
> > > > > >
> > > > > > Only if you have more than UINT_MAX CPUs or something like that.
> > > > > >
> > > > > > And if you really really want to use refcount_t there, you could +1 the
> > > > > > scheme and it'd work again.
> > > > >
> > > > > Well, yes, probably, but there are many cases like this in practice,
> > > > > so we would need to have a good plan how to get it all submitted and
> > > > > tested properly. The current patch set is already bigger than what we
> > > > > had before and it is only growing.
> > > >
> > > > kernel programming is hard :)
> > > >
> > > > Don't get frustrated, it's going to be a lot of work, just break it up
> > > > into chunks and go at it...
> > > >
> > > > > Hans will provide more info later today based on his testing, which
> > > > > shows many places in kernel core where we DO actually have increment
> > > > > on zero happening in practice and whole kernel doesn't even boot with
> > > > > the strictest approach (refusing to inc on zero). And we are only able
> > > > > to test for x86....
> > > > >
> > > > > Given the massive amount of changes, it would be good to merge this at
> > > > > least in couple of stages:
> > > > >
> > > > > 1) first soft version of refcount_t API which at least allows
> > > > > increment on zero and all atomic_t used as refcounter occurrences that
> > > > > don't require reference counter scheme change (+1 or other)
> > > >
> > > > Why not merge the "correct" implementation?  Don't submit something
> > that
> > > > doesn't work well.  Then fix up the instances that are broken when you
> > > > convert them to this new api.
> > >
> > > It is not that the implementation is incorrect, it is just less
> > > radical change in logical behavior. The main issue is going to be
> > > testing.
> > 
> > Again, kernel programming is hard :)
> > 
> > > It is hard to make sure we don't break things up, so that's why
> > > usually a softer approach is to do such big changes in parts. We can
> > > test on x86 and do at least compilation for arm, but what about the
> > > rest? It is a logical change which is bigger than we had before and
> > > consequences might be severe if we miss smth.
> > 
> > You add the correct implementation of refcount_t, and then push the
> > individual conversions through the various subsystem maintainers who
> > will review and test the code for correctness.  Just like any other api
> > change we do.  Why is this somehow "different"?
> 
> Can we really assume help on this for testing on all archs from maintainers?

Why wouldn't you be able to?  What makes this type of work different
from any other kernel change?

I don't understand the problem here...

greg k-h
