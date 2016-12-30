Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Fri, 30 Dec 2016 13:17:08 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C32F34@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
 <20161230010627.GA9882@zzz>
In-Reply-To: <20161230010627.GA9882@zzz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: Eric Biggers <ebiggers3@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Thu, Dec 29, 2016 at 08:55:58AM +0200, Elena Reshetova wrote:
> > +
> > +static inline __must_check
> > +bool refcount_add_not_zero(unsigned int i, refcount_t *r)
> > +{
> > +       unsigned int old, new, val =3D atomic_read(&r->refs);
> > +
> > +       for (;;) {
> > +               if (!val)
> > +                       return false;
> > +
> > +               if (unlikely(val =3D=3D UINT_MAX))
> > +                       return true;
> > +
> > +               new =3D val + i;
> > +               if (new < val)
> > +                       new =3D UINT_MAX;
> > +               old =3D atomic_cmpxchg_relaxed(&r->refs, val, new);
> > +               if (old =3D=3D val)
> > +                       break;
> > +
> > +               val =3D old;
> > +       }
> > +
> > +       WARN(new =3D=3D UINT_MAX, "refcount_t: saturated; leaking memor=
y.\n");
> > +
> > +       return true;
> > +}
> > +
> > +/*
> > + * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WAR=
N.
> > + *
> > + * Provides no memory ordering, it is assumed the caller has guarantee=
d the
> > + * object memory to be stable (RCU, etc.). It does provide a control d=
ependency
> > + * and thereby orders future stores. See the comment on top.
> > + */
> > +static inline __must_check
> > +bool refcount_inc_not_zero(refcount_t *r)
> > +{
> > +       return refcount_add_not_zero(1, r);
> > +}
> > +
> > +/*
> > + * Similar to atomic_inc(), will saturate at UINT_MAX and WARN.
> > + *
> > + * Provides no memory ordering, it is assumed the caller already has a
> > + * reference on the object, will WARN when this is not so.
> > + */
> > +static inline void refcount_inc(refcount_t *r)
> > +{
> > +       WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; us=
e-after-
> free.\n");
> > +}
> > +
>=20
> ... and refcount_inc() compiles to over 100 bytes of instructions on x86_=
64.
> This is the wrong approach.  We need a low-overhead solution, otherwise n=
o one
> will turn on refcount protection and the feature will be useless.
>=20
> What exactly is wrong with the current solution in PAX/grsecurity?  Looki=
ng at
> the x86 version they have atomic_inc() do 'lock incl' like usual, then us=
e 'jo'
> to, if the counter overflowed, jump to *out-of-line* error handling code,=
 in a
> separate section of the kernel image.   Then it raises a software interru=
pt, and
> the interrupt handler sets the overflowed counter to INT_MAX and does the
> needed
> logging and signal raising.
>=20
> That approach seems very efficient.  It seems the only overhead when some=
one
> isn't actually exploiting a refcount bug is the 'jo' instruction, with th=
e
> branch not taken.  There aren't even any other in-line instructions to wa=
ste
> icache space.
> I do see they used to use a slightly different approach that did a decrem=
ent
> instead of setting the counter to INT_MAX.  And that was clearly racy bec=
ause
> two concurrent increments could circumvent the overflow protection.  But =
AFAICS
> their current solution is not racy in any meaningful way, since the setti=
ng to
> INT_MAX means an overflow will be detected again on the next increment, e=
ven if
> there were some concurrent increments in the mean time.  (And if by some =
stretch
> of the imagination, it was possible to execute *another* INT_MAX incremen=
ts
> before the fixup code had a chance to run, the correct solution would be =
to
> simply use 'js' instead of 'jo' to detect overflows.  I'm guessing the on=
ly
> reason they don't do that is because some atomic_t's are used to store ne=
gative
> values...)

>=20
> So given that there is an existing solution which AFAICS is efficient and
> achieves the desired protection, why has the proposal turned into a monst=
rous
> cmpxchg loop that won't be practical to enable by default?

I guess we can try to benchmark the whole thing to see what is the overhead=
.
Especially now when we have the subsystem parts ready.=20

And if you have been following the story since beginning, we also have PaX/=
grsecurity
approach done for linux-next/stable and benchmarks have been previously pos=
ted, so
would be easy to compare if needed.=20

I guess one could in principle think of mixed approach between this one and=
 the one that=20
PaX/grsecurity had: define refcount_t type and API, but use assembly instru=
ctions
behind to speed things up.=20

> I also think that the "warn when incrementing a 0 refcount" part of the c=
hange
> shouldn't be there.  It's additional overhead that seems tangential to th=
e main
> goal of the feature which is to protect against refcount overflows, not t=
o
> protect against random increments in some object which has *already* been=
 freed
> and potentially exploited.

Actually having warn for now was useful debugging feature: we got to found =
out many places which would not work otherwise.=20

Best Regards,
Elena.

>=20
> - Eric
