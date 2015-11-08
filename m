Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1446979151.4680.5.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Sun, 08 Nov 2015 11:39:11 +0100
In-Reply-To: <CAGXu5jKkF61CG_Aiv19p24XvJ7yQ-V+J_RBXbvMbw-cWmzDbmQ@mail.gmail.com>
References: 
	<CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	 <1446816504.8412.35.camel@debian.org>
	 <CAGXu5jKkF61CG_Aiv19p24XvJ7yQ-V+J_RBXbvMbw-cWmzDbmQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-CoKsg1rUq8kE4A37LaGB"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>


--=-CoKsg1rUq8kE4A37LaGB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On ven., 2015-11-06 at 10:11 -0800, Kees Cook wrote:
> I think GRKERNSEC_KERN_LOCKOUT is kind of on both sides of the
> kernel/userspace defense fence. For now, I think the granularity of
> response for KSPP-ported features will likely just be a full system
> Oops. But I suspect once more of them land, we'll want the finer
> granularity that GRKERNSEC_KERN_LOCKOUT provides.

Yes I was really mentioning=C2=A0GRKERNSEC_BRUTE because it looks similar
to=C2=A0GRKERNSEC_KERN_LOCKOUT but I was more interested by the latter in t=
he
current context. In any case (whether we want fine-grained stuff or not), I
think we definitely need a way to prevent repeated exploit attempts.

Regards,
--=20
Yves-Alexis


--=-CoKsg1rUq8kE4A37LaGB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWPyZPAAoJEG3bU/KmdcClliMIAKJG3JdU8E1++wAZ+87BAqDR
VhDORt1H2YTGHjO67hE0lW9deHBAiZzWzuBmS3Mt95OzKd4Zzqs9eSGaw2toiAFZ
GoUhDAU4QWzktWZut4FMXCJl76cen9lyIzzrldEflZXUsu6yn7WS8iXwvn7geq2D
wc1Huq0urK61IBaFSupaC5BaRINXCXNvEjqHdoat5yicL2wywQf9stU9eegOSr1z
12KDwwSViS6kMd+nzJqAy9HtkHRgfctZ8EstOfszkD5t4Seacx+TReyYvlhtR/SQ
NPoqk+UW5zmIHjlQpJam9ZVayAkG/0tn9ix6jE6U67ZLXczPPoEO0jlD3TMs74M=
=I9pO
-----END PGP SIGNATURE-----

--=-CoKsg1rUq8kE4A37LaGB--
