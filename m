Message-ID: <1493837804.20270.10.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 03 May 2017 14:56:44 -0400
In-Reply-To: <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
References: 
	<CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
	 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
	 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
	 <1493683745.2530.2.camel@redhat.com>
	 <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com>
	 <CAGXu5jKqptmWwAgsDNtTRzN-r_JYBtVoNaPbpwN+_stfY4yrQA@mail.gmail.com>
	 <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-w7wcBz9F2B8qYvxejyjT"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Shawn <citypw@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>, Daniel =?UTF-8?Q?Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-w7wcBz9F2B8qYvxejyjT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-05-03 at 12:50 +0800, Shawn wrote:

> The fragmentation of Android eco-system may be inevitable. The whole
> chains is too long from ASOP/BSP/Vendors and it affect the security
> fix being delivered to the end user. According to my own statistic
> from my customers, there will be more than 7 millions of Android
> phone
> will be using some features of PaX/Grsec this year.

That is great news. I am glad to hear the hardening features
are being used on that many phones.

Of course, given the fragmentation of the eco-system, the
only thing that can get the hardening on all of the (new)
phones in the future will be getting the hardening features
into the upstream kernel.

> btw: I share the same view with Mathias Krause and other ppl who
> really concern the real sense of security. I like KSPP in the 1st
> place. But now I lost PaX/Grsecurity test patch. Who should I blame?

I am not sure anyone deserves blame for this situation.

Spender has been doing what is best for his business,
and his work is an important asset for security-minded
people.

Kees and the other KSPP contributors have been doing what
is best for the community, and wide-spread adoption of
hardening functionality.

The important question to ask is "what do we do now?"

I suspect the answer is upstreaming more and more of the
grsecurity functionality, so nobody needs to carry around
that patch any more.

--=20
All rights reversed
--=-w7wcBz9F2B8qYvxejyjT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZCifsAAoJEM553pKExN6DwCAIAJQG4Gmm8608kIwXyuF2aAzJ
DKnDvNur7JfOidqBbOUrvh0qo87l2vVmDMVRKBU3XsYhW1GdpcvdTW5c6Hmg2USt
f1oUvadEeJfKqXopSNyfsRMUBfJa9aPgWqoZNODwIFDnpBVumj+rcUBAqrWTLiBe
5+Qtb0ly9hvfrgFJn8vA8TyedLt+a+RYopjvWFG81qJz6KDn0ABmYg3lKvB3mXsy
sHg3ObVJkqcZB353dhF28aT8DJ9ww3FRvJp2k+pcnApa/ykCpbOp/fTJ2V4AIGhp
RMcl9Ks3DHXaVirUndXAjGeGJB5zo+Ub+R9bnZynmn82b4W6OfLCvKXLD994kZ8=
=Vnn6
-----END PGP SIGNATURE-----

--=-w7wcBz9F2B8qYvxejyjT--
