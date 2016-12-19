Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 19 Dec 2016 07:55:15 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C220DD@IRSMSX102.ger.corp.intel.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <1480693474.28515.56.camel@cs-046.org.aalto.fi>
 <20161207135241.GI3107@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C216AE@IRSMSX102.ger.corp.intel.com>
 <20161216140158.GS3107@twins.programming.kicks-ass.net>
In-Reply-To: <20161216140158.GS3107@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: Liljestrand Hans <ishkamiel@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

> On Fri, Dec 16, 2016 at 12:10:21PM +0000, Reshetova, Elena wrote:
>=20
> > Is it ok to add at least refcount_inc_if_zero() ?
>=20
> Of course not.
>=20
> > We already have refcount_dec_if_one(), reffcount_dec_not_one() and
> > refcount_inc_not_zero(), so this one is the only missing one and would
> > greatly help in couple of cases.
>=20
> No, its absolutely insane. 0 means its freed, you cannot get another
> reference at that point.
>=20
> If you have code that relies on that, its broken.

Well, again, you are right in theory, but in practice for example for struc=
t sched_group { atomic_t ref; ... }:

http://lxr.free-electrons.com/source/kernel/sched/core.c#L6178

To me this is a refcounter that needs the protection.
