Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Tue, 20 Dec 2016 09:55:58 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C22783@IRSMSX102.ger.corp.intel.com>
References: <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
 <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
 <20161216140158.GS3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
 <20161219101243.GB3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C22713@IRSMSX102.ger.corp.intel.com>
 <20161220093051.GB12200@kroah.com>
 <2236FBA76BA1254E88B949DDB74E612B41C22746@IRSMSX102.ger.corp.intel.com>
 <20161220095135.GA13910@kroah.com>
In-Reply-To: <20161220095135.GA13910@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: Conversion from atomic_t to refcount_t: summary of issues
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Liljestrand Hans <ishkamiel@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>


> > > On Tue, Dec 20, 2016 at 09:13:58AM +0000, Reshetova, Elena wrote:
> > > > > On Mon, Dec 19, 2016 at 07:55:15AM +0000, Reshetova, Elena wrote:
> > > > > > Well, again, you are right in theory, but in practice for examp=
le for
> struct
> > > > > sched_group { atomic_t ref; ... }:
> > > > > >
> > > > > > http://lxr.free-electrons.com/source/kernel/sched/core.c#L6178
> > > > > >
> > > > > > To me this is a refcounter that needs the protection.
> > > > >
> > > > > Only if you have more than UINT_MAX CPUs or something like that.
> > > > >
> > > > > And if you really really want to use refcount_t there, you could =
+1 the
> > > > > scheme and it'd work again.
> > > >
> > > > Well, yes, probably, but there are many cases like this in practice=
,
> > > > so we would need to have a good plan how to get it all submitted an=
d
> > > > tested properly. The current patch set is already bigger than what =
we
> > > > had before and it is only growing.
> > >
> > > kernel programming is hard :)
> > >
> > > Don't get frustrated, it's going to be a lot of work, just break it u=
p
> > > into chunks and go at it...
> > >
> > > > Hans will provide more info later today based on his testing, which
> > > > shows many places in kernel core where we DO actually have incremen=
t
> > > > on zero happening in practice and whole kernel doesn't even boot wi=
th
> > > > the strictest approach (refusing to inc on zero). And we are only a=
ble
> > > > to test for x86....
> > > >
> > > > Given the massive amount of changes, it would be good to merge this=
 at
> > > > least in couple of stages:
> > > >
> > > > 1) first soft version of refcount_t API which at least allows
> > > > increment on zero and all atomic_t used as refcounter occurrences t=
hat
> > > > don't require reference counter scheme change (+1 or other)
> > >
> > > Why not merge the "correct" implementation?  Don't submit something
> that
> > > doesn't work well.  Then fix up the instances that are broken when yo=
u
> > > convert them to this new api.
> >
> > It is not that the implementation is incorrect, it is just less
> > radical change in logical behavior. The main issue is going to be
> > testing.
>=20
> Again, kernel programming is hard :)
>=20
> > It is hard to make sure we don't break things up, so that's why
> > usually a softer approach is to do such big changes in parts. We can
> > test on x86 and do at least compilation for arm, but what about the
> > rest? It is a logical change which is bigger than we had before and
> > consequences might be severe if we miss smth.
>=20
> You add the correct implementation of refcount_t, and then push the
> individual conversions through the various subsystem maintainers who
> will review and test the code for correctness.  Just like any other api
> change we do.  Why is this somehow "different"?

Can we really assume help on this for testing on all archs from maintainers=
?
If so, it does help greatly.=20

> > > > 2) patch set that fixes all problematic places (potentially with co=
de
> rewrite)
> > > > 3) patch that removes possibility of inc on zero from refcount_t
> > >
> > > That implies that 3) would not happen for another year or so, not goo=
d.
> > > Do it right the first time.
> >
> > I didn't have that timetable in mind, I would say couple of months the =
most.
>=20
> 3 months is just one kernel development cycle, this is going to take
> longer than that, but optimism is nice to have :)
>=20
> thanks,
>=20
> greg k-h
