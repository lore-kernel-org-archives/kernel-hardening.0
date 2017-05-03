Message-ID: <1493839649.2133.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 03 May 2017 15:27:29 -0400
In-Reply-To: <1493838148.20270.12.camel@redhat.com>
References: 
	<CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
	 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
	 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
	 <1493683745.2530.2.camel@redhat.com>
	 <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
	 <1493838148.20270.12.camel@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-W0bPJ/D3oh6snzqMlny3"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Rik van Riel <riel@redhat.com>, Mathias Krause <minipli@googlemail.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel =?UTF-8?Q?Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-W0bPJ/D3oh6snzqMlny3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Maintainers integrate code one patch series at a
> time. That is not a constraint you can work around,
> because code does need to be reviewed.

By not requiring fixes for issues like undefined function pointer usage
or other undefined behavior to be split up in hundreds of patches to go
through many different maintainers / many different trees. The same goes
for things like basic constification  (i.e. const and __ro_after_init)
that are clear cut and don't involve a performance compromise (so an
equivalent to pax_{open_close}_kernel would be different).

It's extremely unrealistic to get type-based Control Flow Integrity like
RAP for the mainline kernel if the fixes cannot be queued up in a single
tree. It also deters people from working on any of these small,
incremental improvements since they need to split it all up and try to
deal with dozens of maintainers, with most of the patches being lost.
See what happened to past attempts at this stuff.

Of course it needs to be reviewed and hopefully tested, but for fixing
clear cases of undefined behavior (i.e. those caught by UBSan or other
sanitizers and not covered by flags like -fno-strict-overflow -fno-
strict-aliasing) or uncontroversial things like missing const (without
other code changes beyond making pointers const), it should be possible
to land fixes via one tree. It isn't an issue that's specific to
security patches.
--=-W0bPJ/D3oh6snzqMlny3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlkKLyEWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKg6FD/9FHq3cT5II+JYjezNd8bSRAhGN
9Mv0gFG/5nbpVblaNVDWmf2bYsFuBYc1CrQl0EU5lEQ8PFhWDuV5JbZNYZlQPUQr
oa5VPSybgvaj/n4/19NZUyxQPPNPI/kp7VQeLNfybmoaV2dimU/iYVgVNOVnTrA0
bSPrnfVFgsT0E2Ldu/lTooNU4pzLnEi6CHr3jcBQaM2sDuduNWzNnsHZR3Pi2Ol4
Fuis7RfL/PDkRJrO36ufnatc6OX0Mev3eSrFPUt1Yp3xpHhz//bY2vPWJDFtMpv8
rhag9qIKQnmO3/HZqHOwlmSmtdZCibPFaWeTldP0Vv7qLnUC3PR+Y0uUtapzbR0Z
kppJl4sxaQSJM3FwXRwzIGjz+/rGWJycH3SbSAWIB55lku83Wy5//5iyivcLH6xG
Ug5BcWJIrHRzuGciF9PFiV9UC2XwxgB30Uu0p8Rgk1k3CkhFxx3vkbaSIqKwrhBx
w7CZJ4ax2XoadyntBloA0zHd4ukDLYldjGlvQskju4hPyWbGSAr81YuNEsF4hyld
RbuMZitW76q99bBSUgQYiuq5PhsZfNpyknkWAqS4rTeVnYcQZJY65NA101EE7Rbh
xsUYHXDICQn+ZbQ607UQtNz/lFxsVua0GPlJn4f2jiiLhF1r08WO2mX47n+6XJUb
Sug9u4076GHEFUaAyA==
=vMIT
-----END PGP SIGNATURE-----

--=-W0bPJ/D3oh6snzqMlny3--
