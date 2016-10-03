Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 3 Oct 2016 11:47:53 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161003094752.GN14666@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cEobB2knsyc5ebfU"
Content-Disposition: inline
In-Reply-To: <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--cEobB2knsyc5ebfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 03, 2016 at 09:41:25AM +0300, Elena Reshetova wrote:
> This adds x86-specific code in order to support
> HARDENED_ATOMIC feature. When overflow is detected
> in atomic_t or atomic_long_t types, the counter is
> decremented back by one (to keep it at INT_MAX or
> LONG_MAX) and issue is reported using BUG().
> The side effect is that in both legitimate and
> non-legitimate cases a counter cannot wrap.
>=20
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
[...]
>  static __always_inline void atomic_add(int i, atomic_t *v)
>  {
> -	asm volatile(LOCK_PREFIX "addl %1,%0"
> +	asm volatile(LOCK_PREFIX "addl %1,%0\n"
> +
> +#ifdef CONFIG_HARDENED_ATOMIC
> +		     "jno 0f\n"
> +		     LOCK_PREFIX "subl %1,%0\n"
> +		     "int $4\n0:\n"
> +		     _ASM_EXTABLE(0b, 0b)
> +#endif
> +
> +		     : "+m" (v->counter)
> +		     : "ir" (i));
> +}

It might make sense to point out in the Kconfig entry
that on X86, this can only be relied on if
kernel.panic_on_oops=3D=3D1 because otherwise, you can
(depending on the bug, in a worst-case scenario) get
past 0x7fffffff within seconds using multiple racing
processes.
(See https://bugs.chromium.org/p/project-zero/issues/detail?id=3D856 .)


An additional idea for future development:

One way to work around that would be to interpret the
stored value 2^30 as zero, and interpret other values
accordingly. Like this:

#define SIGNED_ATOMIC_BASE 0x40000000U

static __always_inline int atomic_read(const atomic_t *v)
{
  return READ_ONCE((v)->counter) - SIGNED_ATOMIC_BASE;
}

static __always_inline void atomic_set(atomic_t *v, int i)
{
  WRITE_ONCE(v->counter, i + SIGNED_ATOMIC_BASE);
}

static __always_inline int atomic_add_return(int i, atomic_t *v)
{
  return i + xadd_check_overflow(&v->counter, i) - SIGNED_ATOMIC_BASE;
}

With this change, atomic_t could still be used as a signed integer
with half the range of an int, but its stored value would only
become negative on overflow. Then, the "jno" instruction in the
hardening code could be replaced with "jns" to reliably block
overflows.

The downsides of this approach would be:
 - One extra increment or decrement every time an atomic_t is read
   or written. This should be relatively cheap - it should be
   operating on a register -, but it's still not ideal. atomic_t
   users could perhaps opt out with something like
   atomic_unsigned_t.
 - Implicit atomic_t initialization to zero by zeroing memory
   would stop working. This would probably be the biggest issue
   with this approach.

I think that unfortunately, there are a large number of atomic_t
users that don't explicitly initialize the atomic_t and instead
rely on implicit initialization to zero, and changing that would
cause a lot of code churn - so while this would IMO improve the
mitigation, this series should IMO be merged without it and
instead have a small warning in the Kconfig entry or so.

--cEobB2knsyc5ebfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX8ilIAAoJED4KNFJOeCOoeh8P/2T0nxxIg1zyj0SWYoGgYBj8
LsM2mhmMw3Hu40IgpSn2cO7vyEm6pKAzE9WO2WuxsnA6VHBzv4rWGTPbEuYuOafD
wzf7ScfmKHFkjeVDi41/xVR4e+y4w20Tx2IrK23PrieihaBhHIxryFDGItTXVh7f
0lgM/5okohMrEN2JzqdiUgg7oRJKRqfvFkfAZikD+C2yIMktegoeq7pWPSSKmLlZ
SFeko7Oq/wfZS25xajISrhh/9g8zJVHvmxCxp4DuzoSq4cQS95BiG8x/aQCBuexb
dE0K7mrPg5zXdDjsBXOyp21R7bs8+8AZbqTs+zmt4Z/poJz78Q7LbB9PNAm40FCb
fUDemzapKb63lnLLdYb2+4/bvZy8h/U61kpRpeNmjgSNye6An39vX6dNDSKoaGi4
5HKhiNiJe3DG0ndR4K1xtMUkyhK2Xrwlk3dt1A/I//UTo7ocknD6CxeFUwoU3PS3
rJiOxmBFOjMkPsla4b3VSXxzTzs8zNs5l80/U2tGBD2V9oaGqat6mINtmOi8V+Z+
48wtQ5bKf6B+UzK9IwxfrMc+0arYu5Vxn9QUWLKuXa7fpxlfkL3tJA6CFGT5gzcx
qdP3jaYuxfifseW3rb08kkJkd3TPzE/uB8KeRcKZmeYVPQ8COnfBK4/VKDQJwH4c
OflcxAHasjYIgYf41eth
=Fcbz
-----END PGP SIGNATURE-----

--cEobB2knsyc5ebfU--
