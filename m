Message-ID: <1493838148.20270.12.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 03 May 2017 15:02:28 -0400
In-Reply-To: <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
References: 
	<CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
	 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
	 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
	 <1493683745.2530.2.camel@redhat.com>
	 <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-6YuwsMWrd09wHn3Nyh0x"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel =?UTF-8?Q?Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-6YuwsMWrd09wHn3Nyh0x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-05-02 at 23:16 +0200, Mathias Krause wrote:
> On 2 May 2017 at 02:09, Rik van Riel <riel@redhat.com> wrote:
> > On Tue, 2017-05-02 at 00:01 +0200, Mathias Krause wrote:
> >=20
> > > I think the intention of the KSPP is good -- making vanilla Linux
> > > more
> > > secure. But the way it does its work harms overall Linux
> > > security. It
> > > does hurt mine, that's for sure!
> >=20
> > Yeah, no.
>=20
> Well, yes, it does! Losing access to the grsecurity patch makes the
> systems I do care about much less secure.

Your systems are not necessarily representative of the
overall security of all Linux systems in the world,
though.

> > The grsecurity people produced patches
> > that were used on maybe a few tens of thousands
> > of systems,
>=20
> Where did you pull that number from? Out of thin air, I guess. I
> know,
> for sure, there are many more installations.

I have seen a few emails suggesting there are millions
of systems with grsecurity patches around, and I got
the number wrong by several orders of magnitude.

However, that does not invalidate my original point:
the number of grsecurity protected systems is only a tiny
fraction of the entire Linux installed base.

It would be good to get hardening functionality upstream,
in order to get a majority of Linux systems (that get
deployed in the future) hardened out of the box.

> > Those Android devices are more likely to require
> > hardening, too, since they do not receive security
> > updates as quickly as the systems maintained by
> > grsecurity users.
>=20
> Why couldn't those devices benefit from grsecurity as well? Couldn't
> google or Samsung just integrate grsecurity into their Android
> kernels? They're far away from vanilla Linux anyway, so why not add
> just another patch to provide some matured security code base to
> protect those billion of Android devices? I'd guess, if a big player
> like google would sponsor / pay grsecurity to provide a patch for the
> relevant Android kernels, all sides would be happy: grsecurity for
> getting wider adoption, Android users for having secured systems.

They could, but the reality is many vendors will not
bother enabling hardening features unless the code is
already there and enabled by default in the upstream
kernel.

> > Integrating hardening into the upstream kernel is
> > a good thing for security, not a bad thing.
>=20
> I never said it's a bad thing. Indeed I'm all for making vanilla
> Linux
> more secure. Just how KSPP tries to do it is IMHO wrong. Ripping
> hunks
> out of grsecurity and trying to integrate them into vanilla Linux
> without understanding all the interdependencies or even the features
> themselves, how would that provide security? By chance, maybe. But
> not
> intentional, as that requires having thought of every corner case and
> boundary condition.

How would you do it?

Maintainers integrate code one patch series at a
time. That is not a constraint you can work around,
because code does need to be reviewed.

--=20
All rights reversed
--=-6YuwsMWrd09wHn3Nyh0x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZCilEAAoJEM553pKExN6DCkQH/ipT11hGIhtDAgXZBFfAmqIw
McnxxnEXv1sudn57o9RyE5E/HjqXYCLA7VpxJf+J9IWJIT0jcr8AB8imlKMJyYXh
rrsfQ8hvGStsfZxp+tALVi+kuQRtBCDGAGbNz+y6wC9N8LS2BcV0WDbz5SIaFZZT
EM+97RputsoAwA/fr+vCzX3e2VSrVVLyhAYFYpWYkdIJwSIDKN37sYH3vjM8dgAI
Bay91eeHeOHxxBrOs5NyNNzapigimOZYy3aXJ4GUWgAytitEDkb4fWrX9MKdeUzz
eDwUR7dicqNaT5ANlW03JiCI3NdH4ZVagJxj0d9b0TGMwump7OHTrbdKkMc3r2w=
=DTjT
-----END PGP SIGNATURE-----

--=-6YuwsMWrd09wHn3Nyh0x--
