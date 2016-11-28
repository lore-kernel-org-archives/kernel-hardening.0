Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 28 Nov 2016 14:12:19 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C1891A@IRSMSX102.ger.corp.intel.com>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
In-Reply-To: <20161128121347.GY3092@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

> > Also, refcount_add() seems to be needed in number of places since it
> > looks like refcounts in some cases are increased by two or by some
> > constant.  Luckily we haven't seen a need a sub().
>=20
> There is sub_and_test() usage in for example memcontrol.c.

Right (sub_and_test is one pattern I haven't processed yet, but I am *hopin=
g* that there are not that many).
Also now I run into atomic_sub(len -1, &sk->sk_wmem_alloc) in net/core/sock=
.c

>=20
> > The following functions are also needed quite commonly:
>=20
> > refcount_inc_return()
> > refcount_dec_return()
>=20
> What for? They don't typicaly make sense for refcounting? Other than the
> trivial pattern of dec_return() =3D=3D 0, which is already well covered.

Well, I guess you have to ask developers what for. They do verify the retur=
n to be equal to different numbers or values...
Sometimes it is ">0", sometimes "=3D=3D1", sometimes "!=3D-1". These all se=
em to be border cases and checked in some scenarios.=20

> > I also saw one use of this from net/ipv4/udp.c:
> >     if (!sk || !atomic_inc_not_zero_hint(&sk->sk_refcnt, 2))
>=20
> Yes, that one is quite unfortunate, we can trivially support that
> ofcourse, but it does make a bit of a mess of things.
>=20
> > Lastly as I mentioned previously, almost half of invocations of dec()
> > in the code is plain atomic_dec() without any if statements and any
> > checks on what happens as a result of dec().  Peter previously
> > suggested to turn them into WARN_ON(refcount_dec_and_test()), but
> > looking in the code, it is not really clear what would this help to
> > achieve?
>=20
> Well, it clearly marks where refcounting goes bad and we leak crap. A
> regular decrement should _never_ hit 0.
>=20
> > It is clear that in that places the caller explicitly
> > doesn't care about how the dec() goes and what is the end result....
>=20
> No, the typical usage would be you _know_ it will not hit 0. Any other
> usage is broken and bad.

Ok, makes sense.=20
