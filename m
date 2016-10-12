Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Wed, 12 Oct 2016 17:25:29 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BDDB97@IRSMSX102.ger.corp.intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-2-git-send-email-elena.reshetova@intel.com>
 <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
 <20161012082634.GK19531@linaro.org>
In-Reply-To: <20161012082634.GK19531@linaro.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] Re: [RFC PATCH 01/13] Add architecture
 independent hardened atomic base
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi!
<snip>

> > -ATOMIC_LONG_ADD_SUB_OP(sub, _relaxed) -ATOMIC_LONG_ADD_SUB_OP(sub,=20
> > _acquire) -ATOMIC_LONG_ADD_SUB_OP(sub, _release)
> > +ATOMIC_LONG_ADD_SUB_OP(add,,)
> > +ATOMIC_LONG_ADD_SUB_OP(add,,_wrap)
> > +ATOMIC_LONG_ADD_SUB_OP(add, _relaxed,) ATOMIC_LONG_ADD_SUB_OP(add,=20
> > +_acquire,) ATOMIC_LONG_ADD_SUB_OP(add, _release,)
> > +ATOMIC_LONG_ADD_SUB_OP(sub,,)
> > +//ATOMIC_LONG_ADD_SUB_OP(sub,,_wrap) todo: check if this is really=20
> > +not needed
>=20
> Let's get this question answered. Seems like it'd make sense to create=20
> complete function coverage?

>I'd love to know the answer since there tons of variants of atomic operati=
ons.

So, the approach we have taken so far is to define only functions that are =
used/needed so far in the changes that we did in subsystems.
This obviously doesn't cover all possible options. I guess in order to supp=
ort future changes we need a full coverage, indeed...   =20

<snip>

> > -ATOMIC_LONG_OP(add)
> > -ATOMIC_LONG_OP(sub)
> > -ATOMIC_LONG_OP(and)
> > -ATOMIC_LONG_OP(andnot)
> > -ATOMIC_LONG_OP(or)
> > -ATOMIC_LONG_OP(xor)
> > +ATOMIC_LONG_OP(add,)
> > +ATOMIC_LONG_OP(add,_wrap)
> > +ATOMIC_LONG_OP(sub,)
> > +ATOMIC_LONG_OP(sub,_wrap)
> > +ATOMIC_LONG_OP(and,)
> > +ATOMIC_LONG_OP(or,)
> > +ATOMIC_LONG_OP(xor,)
> > +ATOMIC_LONG_OP(andnot,)

>For instance, are we sure that we would never call atomic_long_and_wrap() =
to atomic_long_wrap_t variable?
Yes, same story, now we are not calling it, but things change obviously. We=
 wanted to start somewhere, and this set is already quite big even with the=
 current needs.=20
So, does everyone agree that we should provide full coverage?=20

<snip>=20

> >
> > +#ifndef CONFIG_HARDENED_ATOMIC
> > +#define atomic_read_wrap(v) atomic_read(v) #define=20
> > +atomic_set_wrap(v, i) atomic_set((v), (i)) #define=20
> > +atomic_add_wrap(i, v) atomic_add((i), (v)) #define=20
> > +atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))=20
> > +#define atomic_sub_wrap(i, v) atomic_sub((i), (v)) #define=20
> > +atomic_inc_wrap(v) atomic_inc(v) #define=20
> > +atomic_inc_and_test_wrap(v) atomic_inc_and_test(v) #define=20
> > +atomic_inc_return_wrap(v) atomic_inc_return(v) #define=20
> > +atomic_add_return_wrap(i, v) atomic_add_return((i), (v)) #define=20
> > +atomic_dec_wrap(v) atomic_dec(v) #define atomic_cmpxchg_wrap(v, o,=20
> > +n) atomic_cmpxchg((v), (o), (n)) #define atomic_xchg_wrap(v, i)=20
> > +atomic_xchg((v), (i)) #define atomic_long_read_wrap(v)=20
> > +atomic_long_read(v) #define atomic_long_set_wrap(v, i)=20
> > +atomic_long_set((v), (i)) #define atomic_long_add_wrap(i, v)=20
> > +atomic_long_add((i), (v)) #define atomic_long_sub_wrap(i, v)=20
> > +atomic_long_sub((i), (v)) #define atomic_long_inc_wrap(v)=20
> > +atomic_long_inc(v) #define atomic_long_add_return_wrap(i, v)=20
> > +atomic_long_add_return((i), (v)) #define=20
> > +atomic_long_inc_return_wrap(v) atomic_long_inc_return(v) #define=20
> > +atomic_long_sub_and_test_wrap(v) atomic_long_sub_and_test(v)=20
> > +#define atomic_long_dec_wrap(v) atomic_long_dec(v) #define=20
> > +atomic_long_xchg_wrap(v, i) atomic_long_xchg((v), (i)) #endif /*=20
> > +CONFIG_HARDENED_ATOMIC */

>It seems that there are missing function definitions here if atomic_long s=
hould have all the counterparts to atomic:
>    atomic_long_add_unless_wrap()
>    atomic_long_cmpxchg_wrap()


Again, this is based on the current usage of atomic_long_wrap_t, not the fu=
ll coverage.=20

Best Regards,
Elena.
