Date: Mon, 6 Feb 2017 14:32:15 +0800
From: Boqun Feng <boqun.feng@gmail.com>
Message-ID: <20170206063215.GA9178@tardis.cn.ibm.com>
References: <20170203132558.474916683@infradead.org>
 <20170203132737.566324209@infradead.org>
 <20170206042428.GA17028@tardis.cn.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20170206042428.GA17028@tardis.cn.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 4/5] atomic: Introduce atomic_try_cmpxchg()
To: Peter Zijlstra <peterz@infradead.org>
Cc: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 06, 2017 at 12:24:28PM +0800, Boqun Feng wrote:
> On Fri, Feb 03, 2017 at 02:26:02PM +0100, Peter Zijlstra wrote:
> > Add a new cmpxchg interface:
> >=20
> >   bool try_cmpxchg(u{8,16,32,64} *ptr, u{8,16,32,64} *val, u{8,16,32,64=
} new);
> >=20
> > Where the boolean returns the result of the compare; and thus if the
> > exchange happened; and in case of failure, the new value of *ptr is
> > returned in *val.
> >=20
> > This allows simplification/improvement of loops like:
> >=20
> > 	for (;;) {
> > 		new =3D val $op $imm;
> > 		old =3D cmpxchg(ptr, val, new);
> > 		if (old =3D=3D val)
> > 			break;
> > 		val =3D old;
> > 	}
> >=20
> > into:
> >=20
> > 	for (;;) {
> > 		new =3D val $op $imm;
> > 		if (try_cmpxchg(ptr, &val, new))
> > 			break;
> > 	}
> >=20
> > while also generating better code (GCC6 and onwards).
> >=20
>=20
> But switching to try_cmpxchg() will make @val a memory location, which
> could not be put in a register. And this will generate unnecessary
> memory accesses on archs having enough registers(PPC, e.g.).
>=20

Hmm.. it turns out that compilers can figure out that @val could be fit
in a register(maybe in the escape analysis step), so don't treat it as a
memory location. This is at least true for GCC 5.4.0 on PPC. So I think
we can rely on this?

> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> > --- a/arch/x86/include/asm/atomic.h
> > +++ b/arch/x86/include/asm/atomic.h
> > @@ -186,6 +186,12 @@ static __always_inline int atomic_cmpxch
> >  	return cmpxchg(&v->counter, old, new);
> >  }
> > =20
> > +#define atomic_try_cmpxchg atomic_try_cmpxchg
> > +static __always_inline bool atomic_try_cmpxchg(atomic_t *v, int *old, =
int new)
> > +{
> > +	return try_cmpxchg(&v->counter, old, new);
> > +}
> > +
> >  static inline int atomic_xchg(atomic_t *v, int new)
> >  {
> >  	return xchg(&v->counter, new);
> > --- a/arch/x86/include/asm/cmpxchg.h
> > +++ b/arch/x86/include/asm/cmpxchg.h
> > @@ -153,6 +153,75 @@ extern void __add_wrong_size(void)
> >  #define cmpxchg_local(ptr, old, new)					\
> >  	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
> > =20
> > +
> > +#define __raw_try_cmpxchg(_ptr, _pold, _new, size, lock)		\
> > +({									\
> > +	bool success;							\
> > +	__typeof__(_ptr) _old =3D (_pold);				\
> > +	__typeof__(*(_ptr)) __old =3D *_old;				\
> > +	__typeof__(*(_ptr)) __new =3D (_new);				\
> > +	switch (size) {							\
> > +	case __X86_CASE_B:						\
> > +	{								\
> > +		volatile u8 *__ptr =3D (volatile u8 *)(_ptr);		\
> > +		asm volatile(lock "cmpxchgb %[new], %[ptr]"		\
> > +			     CC_SET(z)					\
> > +			     : CC_OUT(z) (success),			\
> > +			       [ptr] "+m" (*__ptr),			\
> > +			       [old] "+a" (__old)			\
> > +			     : [new] "q" (__new)			\
> > +			     : "memory");				\
> > +		break;							\
> > +	}								\
> > +	case __X86_CASE_W:						\
> > +	{								\
> > +		volatile u16 *__ptr =3D (volatile u16 *)(_ptr);		\
> > +		asm volatile(lock "cmpxchgw %[new], %[ptr]"		\
> > +			     CC_SET(z)					\
> > +			     : CC_OUT(z) (success),			\
> > +			       [ptr] "+m" (*__ptr),			\
> > +			       [old] "+a" (__old)			\
> > +			     : [new] "r" (__new)			\
> > +			     : "memory");				\
> > +		break;							\
> > +	}								\
> > +	case __X86_CASE_L:						\
> > +	{								\
> > +		volatile u32 *__ptr =3D (volatile u32 *)(_ptr);		\
> > +		asm volatile(lock "cmpxchgl %[new], %[ptr]"		\
> > +			     CC_SET(z)					\
> > +			     : CC_OUT(z) (success),			\
> > +			       [ptr] "+m" (*__ptr),			\
> > +			       [old] "+a" (__old)			\
> > +			     : [new] "r" (__new)			\
> > +			     : "memory");				\
> > +		break;							\
> > +	}								\
> > +	case __X86_CASE_Q:						\
> > +	{								\
> > +		volatile u64 *__ptr =3D (volatile u64 *)(_ptr);		\
> > +		asm volatile(lock "cmpxchgq %[new], %[ptr]"		\
> > +			     CC_SET(z)					\
> > +			     : CC_OUT(z) (success),			\
> > +			       [ptr] "+m" (*__ptr),			\
> > +			       [old] "+a" (__old)			\
> > +			     : [new] "r" (__new)			\
> > +			     : "memory");				\
> > +		break;							\
> > +	}								\
> > +	default:							\
> > +		__cmpxchg_wrong_size();					\
> > +	}								\
> > +	*_old =3D __old;							\
> > +	success;							\
> > +})
> > +
> > +#define __try_cmpxchg(ptr, pold, new, size)				\
> > +	__raw_try_cmpxchg((ptr), (pold), (new), (size), LOCK_PREFIX)
> > +
> > +#define try_cmpxchg(ptr, pold, new)					\
> > +	__try_cmpxchg((ptr), (pold), (new), sizeof(*(ptr)))
> > +
> >  /*
> >   * xadd() adds "inc" to "*ptr" and atomically returns the previous
> >   * value of "*ptr".
> > --- a/include/linux/atomic.h
> > +++ b/include/linux/atomic.h
> > @@ -423,6 +423,28 @@
> >  #endif
> >  #endif /* atomic_cmpxchg_relaxed */
> > =20
> > +#ifndef atomic_try_cmpxchg
> > +
> > +#define __atomic_try_cmpxchg(type, _p, _po, _n)				\
> > +({									\
> > +	typeof(_po) __po =3D (_po);					\
> > +	typeof(*(_po)) __o =3D *__po;					\
> > +	bool success =3D (atomic_cmpxchg##type((_p), __o, (_n)) =3D=3D __o);	\
> > +	*__po =3D __o;							\
>=20
> Besides, is this part correct? atomic_cmpxchg_*() wouldn't change the
> value of __o, so *__po wouldn't be changed.. IOW, in case of failure,
> *ptr wouldn't be updated to a new value.
>=20
> Maybe this should be:
>=20
> 	bool success;
> 	*__po =3D atomic_cmpxchg##type((_p), __o, (_n));
> 	sucess =3D (*__po =3D=3D _o);

typo... should be

	success =3D (*__po =3D=3D __o);

Regards,
Boqun

>=20
> , right?
>=20
> Regards,
> Boqun
>=20
> > +	success;							\
> > +})
> > +
> > +#define atomic_try_cmpxchg(_p, _po, _n)		__atomic_try_cmpxchg(, _p, _p=
o, _n)
> > +#define atomic_try_cmpxchg_relaxed(_p, _po, _n)	__atomic_try_cmpxchg(_=
relaxed, _p, _po, _n)
> > +#define atomic_try_cmpxchg_acquire(_p, _po, _n)	__atomic_try_cmpxchg(_=
acquire, _p, _po, _n)
> > +#define atomic_try_cmpxchg_release(_p, _po, _n)	__atomic_try_cmpxchg(_=
release, _p, _po, _n)
> > +
> > +#else /* atomic_try_cmpxchg */
> > +#define atomic_try_cmpxchg_relaxed	atomic_try_cmpxchg
> > +#define atomic_try_cmpxchg_acquire	atomic_try_cmpxchg
> > +#define atomic_try_cmpxchg_release	atomic_try_cmpxchg
> > +#endif /* atomic_try_cmpxchg */
> > +
> >  /* cmpxchg_relaxed */
> >  #ifndef cmpxchg_relaxed
> >  #define  cmpxchg_relaxed		cmpxchg
> >=20
> >=20



--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAliYGGwACgkQSXnow7UH
+rhKbgf/b3UpzlZGzM5BAEllfp2epwGznffvFEg1l3kxkxiT3ypc7TR6nTSAuaC2
/y+697hzs144yK6QzPWkkvalGmfSVr3rR7DqLINWlb0ZOrd4+KbUI/VWxA6U8QDB
LJG2SPea+9MqFvi1Nli2WvfNGB/X3BSyuwtlkXyLpARJ2cwneoQqEkA/dMVTewkH
iOUQKJ1taUZ3mLVHizKc3xEbd7NiM+jGqZ4pqjvxOyoPrrv+/8zm70ZN/0ROo0YZ
TEXz2fn7HqxmcgZpFycdbYPWcVolFEddSoxnGYxNZpT4QuYgPz39cQc3My7EBxM+
Dq+9jt6iXEyV/EEqGYhZVC2dBHuBHQ==
=i7h0
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
