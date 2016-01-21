Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453338072.4942.16.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 20 Jan 2016 20:01:12 -0500
In-Reply-To: <1453323437.6344.32.camel@debian.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	 <CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	 <CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
	 <1453323437.6344.32.camel@debian.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aXgcJ40kZu0LRolFzVzB"
Mime-Version: 1.0
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT
 overflow protection
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-aXgcJ40kZu0LRolFzVzB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-01-20 at 21:57 +0100, Yves-Alexis Perez wrote:
> On mar., 2016-01-19 at 11:07 -0800, Kees Cook wrote:
> > Hi David,
> >=20
> > On Thu, Dec 17, 2015 at 12:55 PM, Kees Cook <keescook@chromium.org>
> > wrote:
> > > On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org>
> > > wrote:
> > > > NOTE: This is a v2 submission because patch 3/5 in v1 was too
> > > > large to
> > > > sent
> > > > to kernel-hardening.=C2=A0=C2=A0Taking that as a sign that the patc=
h
> > > > needed to be
> > > > split,
> > > > I'm sending this version of the patchset, with the patches split
> > > > more or
> > > > less
> > > > on a per-maintainer basis (except for those in drivers/).
> >=20
> > How's the next spin coming? It looks like we have some new real-
> > world
> > examples of exploits that would have been blocked by this
> > protection:
> >=20
> > http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a
> > -linux-k
> > ernel-vulnerability-cve-2016-0728/
> >=20
> >=20
> One thing which is surprising (I have to admit I'm not really an
> expert on how
> SLAB works) is how easy it apparently is to have multiple allocations
> end up
> at the same place. You don't even have to *know* the exact address.
>=20
> Wouldn't it be possible to at least have some randomization here, so
> new
> object are not at the same place as the not-freed-ones, somehow
> preventing the
> use-after-free and forcing an attacker to do some heap massaging?
>=20
> Regards,

It could do some fine-grained randomization. It does have a measurable
performance cost since it makes allocations colder and there isn't much
room for adding entropy but it does add up over time. Depending on the
locking design it could also hurt there too.

Take a look at OpenBSD malloc if you're interested in it. It has a few
forms of randomization and they do add up:

* small array of quarantined pointers, free(ptr) randomly swaps with one
and frees that (wastes some memory, makes allocations colder) - can also
have a feature checking that junk filled for sanitization is still in
place when moving out of the quarantine at a further performance cost
(which I recently upstreamed for OpenBSD malloc)
* picking a random slot within a slab (makes allocations colder and
slows down the allocator a bit)
* picking a random slab list to satisfy each allocation (significantly
increases worst-case memory usage by spreading stuff out)
* page cache randomization (i.e. randomization of the layer below slabs
which in userspace means the allocator cache and fine-grained mmap rnd,
but it still applies to the kernel's allocation of the slab pages)
--=-aXgcJ40kZu0LRolFzVzB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWoC3ZAAoJEPnnEuWa9fIqjNYP/1ikwvW8jTsyfbjGo49EYr+7
dUASsPt+osS7SPY1Atzddv619YsZofCxH3OQM9umva4wpPmvmc1qCoOlI/gNCA3U
euAMnUSIjxv8YOGD3hLTzAyWZGlk1VjR2HIvhWA75fVMdFwUcfRg+ITq77ju9bo/
gGOgh0Jmya9MYV2xJcxwhbN17LWfPdPguSCe09PGvfom8WteF61YbcA7WZnhoy3c
xwmnmNfE6oQEPVtpc57A6Cmaj5lDT20GG33nhB7RBgb4b0lblmg00WjXuD+a+g4/
Rgj3zdVchKXx2lqBjIeMLyVSqUBuSNB2EZs/w6tehacwv8BUmHO2kMpnhUs1SGuZ
xwdh0tkzSBcO9Bny7CZBy3J2JoK7u8i08UO0Kyku7tGbnuPTwPID8fvLMCtkIU8/
OYSaR3tK3FQTqtjFOGJTPlpPo2c4EVko3uZVvTILjPQlvZPY8aprHZrvN/WoKoqi
cSBUXOWNVpOGaCjnl7VT5SNvU43Y9v6AdCZa0eY2sYOr6djXDib3pgiENgZ49Yy6
YBurL6PSbkIKNsXb4fQsK7VnryT6lOXvjJD/8qr6hYeMsFoRX4s8qbp9aTQX3L68
WMjRlLSlX8rAD0H+wYP2c+CoPF/dJeCJtFydcc9PaEkt0WXsB3eu6ZSOt5zCBUo0
MTYjFEH25TqLjKJEUTrU
=yhz9
-----END PGP SIGNATURE-----

--=-aXgcJ40kZu0LRolFzVzB--
