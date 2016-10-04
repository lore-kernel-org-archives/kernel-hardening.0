Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 4 Oct 2016 14:46:16 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161004124616.GF2040@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <20161003094752.GN14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDAC5B@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HCdXmnRlPgeNBad2"
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BDAC5B@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--HCdXmnRlPgeNBad2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 04, 2016 at 07:15:56AM +0000, Reshetova, Elena wrote:
> >An additional idea for future development:
>=20
> >One way to work around that would be to interpret the stored value 2^30 =
as zero, and interpret other values accordingly. Like this:
>=20
> >#define SIGNED_ATOMIC_BASE 0x40000000U
>=20
> >static __always_inline int atomic_read(const atomic_t *v) {
>   return READ_ONCE((v)->counter) - SIGNED_ATOMIC_BASE; }
>=20
> >static __always_inline void atomic_set(atomic_t *v, int i) {
>   WRITE_ONCE(v->counter, i + SIGNED_ATOMIC_BASE); }
>=20
> >static __always_inline int atomic_add_return(int i, atomic_t *v) {
>   return i + xadd_check_overflow(&v->counter, i) - SIGNED_ATOMIC_BASE; }
>=20
> >With this change, atomic_t could still be used as a signed integer with =
half the range of an int, but its stored value would only become negative o=
n overflow. Then, the "jno" instruction in the hardening code could be repl=
aced with "jns" to reliably block overflows.
>=20
> >The downsides of this approach would be:
> > - One extra increment or decrement every time an atomic_t is read
>    or written. This should be relatively cheap - it should be
>    operating on a register -, but it's still not ideal. atomic_t
>    users could perhaps opt out with something like
>    atomic_unsigned_t.
>  - Implicit atomic_t initialization to zero by zeroing memory
>    would stop working. This would probably be the biggest issue
>    with this approach.
>=20
> I am not sure the BIAS is a good idea at all. Makes things much more comp=
licated, potentially impacts performance...

Yeah, it does make things more complicated. And I just noticed that with the
BIAS, atomic_sub_and_test() would likely have to be implemented with cmpxch=
g,
so it probably doesn't help much performance-wise.

In summary: Nevermind, it was a stupid idea.

--HCdXmnRlPgeNBad2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJX86SYAAoJED4KNFJOeCOoE0sP+Na3F+GFTnwXVuMnWNKQ956U
18PxcczZS49TKRmmSDDGdi+X4/igu1EwG95t1bqktRIEZvh+ZVump0j25MBKw9Ei
q6fS7i769aott4fZGyI5iFgEoPXnzIB5OeRs9WNQ91rZ/9mwdLfj/KuaHHMzdT4c
ekTU7oyJG7VubjUjphidioMwiyKzPYKkxwV1cyHpKTW8JFICpicURreXZc1fkcaJ
kmuEiMlFtV3hApu269I/wPq5Pxq+sv6fdvBmSfP5Az8HRIGrtoS0qDwm4J6ONKao
T4jejL1xjihlRn3avtgp0u35pfop8jvemgIsUE1nTHjzCZnf+YCK08XYKDqWmLQF
cxi66oyF1+tPqKgfRuETpu4lcf+f/z4SHv8zPFtbhoVBAhNkFGYFSsD7Demb0b2B
Fr37bWhAhoVNlA8UVBTT0vffcJEUlEGADNgHhogK/IYM3jfX/ht7uPvjsS0EtLLs
W0Jq/9i0isY7/mFakUBW/uZGA655gPCGmT+RJ7wigr93aIFCEyUV935rr4hEN3D4
Pv1N0dCr+B+mxuZvgQXBG1lqfq33+NVDKFF6u2haQDq6j8aeW0oPod+A4Vwlxy2G
kouuyyITXGjBgFSSmPO2nNeqU7hzfFOUJGmdWwGc/qsxtAMIlDaxss8b+voCTtc9
MZb3c8NzIU7Yi/6Q1aI=
=wzML
-----END PGP SIGNATURE-----

--HCdXmnRlPgeNBad2--
