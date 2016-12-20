Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Tue, 20 Dec 2016 09:58:01 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C22797@IRSMSX102.ger.corp.intel.com>
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
In-Reply-To: <20161220094152.GK3124@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: Liljestrand Hans <ishkamiel@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

> On Tue, Dec 20, 2016 at 09:13:58AM +0000, Reshetova, Elena wrote:
> > > On Mon, Dec 19, 2016 at 07:55:15AM +0000, Reshetova, Elena wrote:
> > > > Well, again, you are right in theory, but in practice for example f=
or struct
> > > sched_group { atomic_t ref; ... }:
> > > >
> > > > http://lxr.free-electrons.com/source/kernel/sched/core.c#L6178
> > > >
> > > > To me this is a refcounter that needs the protection.
> > >
> > > Only if you have more than UINT_MAX CPUs or something like that.
> > >
> > > And if you really really want to use refcount_t there, you could +1 t=
he
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
>=20
> I don't get it. Why ?
>=20
> Just leave the weird and problematic cases using atomic_t. Its far
> harder to remove crap later.

If it is internal change (not API), should be quite easy to remove later. B=
ut ok, I guess for really weird cases, it might be easier to postpone their=
 change until the next patch set. And if we get help in testing, then hopef=
ully it will go without major breakdowns.=20
