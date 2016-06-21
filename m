Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466533189.2756.52.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 21 Jun 2016 14:19:49 -0400
In-Reply-To: <CAGXu5jLQk8zha3cx158GU6AGN+XDManurTmuC08XjYcJBJhvfg@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org>
	 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
	 <CALCETrX0VXZVgy0_6-Jq_sT4yPKYogGjTZvn8VqvMzPtw4-3wg@mail.gmail.com>
	 <CA+55aFzBAdM2UGpmVQjhnEtsvfPmJE1aqeoo4e65PrQvsvsFnQ@mail.gmail.com>
	 <CALCETrWEokFnfjx_LjG_S4TizjVo=YcJNpeoSwxHn0-d2+Aw+A@mail.gmail.com>
	 <CAGXu5jLQk8zha3cx158GU6AGN+XDManurTmuC08XjYcJBJhvfg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-iRBwSazlTytAWjIbeDno"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks
 with guard pages (x86, core)
To: kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@amacapital.net>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-iRBwSazlTytAWjIbeDno
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-06-21 at 11:12 -0700, Kees Cook wrote:
> On Tue, Jun 21, 2016 at 10:27 AM, Andy Lutomirski
> <luto@amacapital.net> wrote:
> > FWIW, it may be a while before this can be enabled in distro
> > kernels.
> > There are some code paths (*cough* crypto users *cough*) that think
> > that calling sg_init_one with a stack address is a reasonable thing
> > to
> > do, and it doesn't work with a vmalloced stack.=C2=A0=C2=A0grsecurity w=
orks
> ... O_o ...
>=20
> Why does it not work on a vmalloced stack??

Because virt_to_page() does not work on vmalloced
memory.

--=20
All Rights Reversed.


--=-iRBwSazlTytAWjIbeDno
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXaYVFAAoJEM553pKExN6DW9wIAJGaNx+6WeMQkYnYyi+B9CVI
2Oc9YIw237LfSNkFqzsa1awGA5Z2C6m1qwaT3MoDJlKem4/em4xjdbWKdkTbM3lP
nSINT0cqztExGZDLVNFtiLpjypp1mJsLYsywlZP8n4gGDR5T0qIqXY2JQSlhJcAd
dH8A1x9GgMke0l/WkALesvEuRqIFNWAMBUFI7LJ4J4Zs0Tt4lvJAioT4XlLqDFKG
a0AUxkKaoeRmpUYrRgSMHBgY1WzUkd6YI6Hjbr0U8rk3Mis/pQ+9Bgnr8bj29bRv
BqwQOtO4EC9ZQ+yZCg6RMfxEZ3ARqtGAyKTekvP/RQUxjmopjwuhLkdSPGMIPMI=
=1NxW
-----END PGP SIGNATURE-----

--=-iRBwSazlTytAWjIbeDno--
