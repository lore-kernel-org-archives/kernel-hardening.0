Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1468351439.32683.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 12 Jul 2016 15:23:59 -0400
In-Reply-To: <CAGXu5jKKd-VcuLooiRV-ktbnYuB_EaOtUbQOOy7e5VGNgWBU-A@mail.gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
	 <20160705014209.caca7667ac0984c2975b4f41@gmail.com>
	 <CAGXu5jKKd-VcuLooiRV-ktbnYuB_EaOtUbQOOy7e5VGNgWBU-A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Y29sRYWzknlJzkFhq+5Y"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH v2 2/3] Mark functions with the
 __nocapture attribute
To: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>


--=-Y29sRYWzknlJzkFhq+5Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-12 at 15:08 -0400, Kees Cook wrote:
> On Mon, Jul 4, 2016 at 7:42 PM, Emese Revfy <re.emese@gmail.com>
> wrote:
> >=20
> > The nocapture gcc attribute can be on functions only.
> > The attribute takes one or more unsigned integer constants as
> > parameters
> > that specify the function argument(s) of const char* type to
> > initify.
> > If the marked argument is a vararg then the plugin initifies
> > all vararg arguments.
>=20
> Why is this called "nocapture"? Not captured by what? It seems like
> it
> means "initify this if possible". Am I misunderstanding its purpose?

It means they don't escape via that function, i.e. they aren't stored
anywhere to be used in any way after the call.
--=-Y29sRYWzknlJzkFhq+5Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXhUPPFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ioIrhAAkoGYfw4Z8fPR7cOJDfp5kG0LFds+25zqzQhR6cLw1K7pOJ0hNZO+DV9W
Z2aSG99PYtPAipEiIuN3IZkaVq5Io2T51xyHil4ngNI+aZgnLTFSlklNAYDNjQjj
XxLSNjneCJkl652jdGVxVcvv0kU2+PjHwO5AK/9Qbj+AwtTrRVgXHS3VTpRi9y6y
8kneie8ChYCg29SmknoZaEuKuuwcI5Wld+nHvTkuZnBCqkgZfw+YRMz2K1S6jgQB
vMBwiTeAj4HzzxyHerPKP6xUS+ARp+HFQEYc0M2n72GolpWfEiYKa6NxJ+wHEY5V
ooD4wgI5y3Ee8YQJg9EV7bXR54HSv6VdxJcule5L2Ls6Wp4It5rwnPF8GL/e4Cz/
PiSaPnfn2qYT+mX5CBplec93vAwEflm5J485RmAmJtyR7JewAMBb2hUZzmxBew2h
uVO7DfN7PvgwfAB+XGS0Zk9PVKTZqXhNkuIviqd5S2qLORxYV9P1ckUCJECJ0Qk/
xWJAoBChjVRcbC9BCii3fi55/RBVZgDIBMDCK/pS7ORuOwoWudNN4IXDzClxNg2G
O0A8WJYE7LDX/9mBVZ9tUrqHcifKp6cecosvSij6QMZJ7GhNc+jLCgHfqsewVcFV
VxQnFm6hee1rR3tn7MW/2/dhDXQe9eMcX2w1Eg7npMWgFp6Fugs=
=aUpr
-----END PGP SIGNATURE-----

--=-Y29sRYWzknlJzkFhq+5Y--
