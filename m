Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 9 Oct 2016 21:37:31 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161009193731.GD14666@pc.thejh.net>
References: <1476016472.2329.38.camel@cvidal.org>
 <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPYgjWmOFizS0g23"
Content-Disposition: inline
In-Reply-To: <1476040182.2329.72.camel@cvidal.org>
Subject: Re: [kernel-hardening] self introduction
To: Colin Vidal <colin@cvidal.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--mPYgjWmOFizS0g23
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 09, 2016 at 09:09:42PM +0200, Colin Vidal wrote:
> Hi David,
>=20
> > If you're interested, the HARDENED_ATOMIC team is looking for people
> > to help porting the feature to other architectures.=A0=A0ARM is a
> > reasonable candidate for someone new to the project.=A0=A0I have begun
> > this effort myself, but if you'd like to collaborate I'd be
> > grateful.
>=20
> Sounds good!
>=20
> > It essentially involves porting the original arch-specific features
> > from PAX_REFCOUNT into Elena Reshetova's official HARDENED_ATOMIC
> > tree, which can be found at
> > https://github.com/esreshetova/linux-stable
>=20
> The link seems broken (https://github.com/esreshetova too). I found
> https://github.com/dwindsor/hardened-atomic but it is empty. Did I
> miss something/Github filter?

Typo in the link, I think?
https://github.com/ereshetova/linux-stable


> > Please contact me if you have any questions; I'd be glad to help!
>=20
> I actually have question. :-) As far as I understand, PAX_REFCOUNT [1]
> is mainly a x86-only

No, PAX_REFCOUNT also supports a bunch of other architectures. As far as
I can tell from a quick look: ARM, MIPS, PowerPC and SPARC.

> port from PaX project

It is part of the PaX patch.

> in order to avoid overflow
> on atomic_t variable (and avoid use-after-free exploits)

Yes - overflow (beyond INT_MAX) and underflow (beyond INT_MIN).

=2E I am a
> little bit confused about the Elena patch-set HARDENED_ATOMIC [2]. It
> is a more mature/recent version of the port, isn't it ?

HARDENED_ATOMIC is a patch based on PAX_REFCOUNT that is developed with
the intent to merge it into the upstream kernel.

--mPYgjWmOFizS0g23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+px7AAoJED4KNFJOeCOoPJQP/20UNfdXs4cuUztq4JYJJwsf
MSzgWAV7HICOeZEfe0lfT8jZFPXHUXUSM2V3Kc5KL/YG08q9lXlxE21t2LEwBNhp
thm/f0KeoJgI5dQAh4T9DU8u0G1MJxaHfshTNELaJEaYlFMnJiXx9+W2itO7/xjJ
YYDwxT8fzybApiuFvPmk3Nl+1tq32PhGRXOOEnkIwT2autJDTR5FBJqM8BknkUC8
DL8rHYAC2VAAKFeufV+8Rl0XATgju+ASU0bpNA92OpXBHy6SyczerqTefcv0IKuz
qqMf8UPhfNJgONSRgrbqLeUfb38JAHmw8T9VTzSJJxqmstYzwkt5BDJiud5mjBug
OTnIuxP2bim+DapHcUzq/cHmelTMhnrYLKafss4iCNhFpNNyEv+fJTN0cEpqzog1
BYOmoOm6otyBWy9cK1Poi6vvYXMxNguApEyCWcQDmNy60PzavKZLp0s7KI3wH5ye
fSHIg+yN3X4/HN7DY5QdCYUCQ5oovCdvWY1ZRyxlbUV1EXsA5HQv38ON5TeGizfp
QLX3yE0BY4fB8rDTX6gYMlcj3+51o76Nud8Y+5ezDtQ1qGKnxuIo7mjJFnTBqwTk
8xzzjuS3huaKYvxZotmSXhXh3KgQShu+B0TaCq8C3BYd7GK9aooa8guhXTOEkr7B
FxeIfjyi9xsuFRJ6G5D9
=TRpY
-----END PGP SIGNATURE-----

--mPYgjWmOFizS0g23--
