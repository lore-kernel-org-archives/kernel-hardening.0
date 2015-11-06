Reply-To: kernel-hardening@lists.openwall.com
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <563D1B35.7010603@digikod.net>
Date: Fri, 6 Nov 2015 22:27:17 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="PJOeDu2NfFA41wddORIpcsaWeJRH0L1AV"
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PJOeDu2NfFA41wddORIpcsaWeJRH0L1AV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Excellent initiative!

FYI, you can find the grsecurity patches automatically integrated in a co=
nsistent Git repository: https://github.com/linux-scraping/linux-grsecuri=
ty . I took all patches I could find (with their signatures and changelog=
s!), starting from the beginning of the Linux Git history (2005: v2.6.14.=
2), and applying them following branches and merges. The result is quite =
interesting and help to dive into the Linux/grsecurity internals (with lo=
g, blame and bisect). Moreover, it show the work of Brad Spengler backpor=
ting fixes.
I did the same with PaX but it needs some more work before going public.

Regards,
 Micka=C3=ABl


On 11/05/15 21:59, Kees Cook wrote:
> I'm organizing a community of people to work on the various kernel
> self-protection technologies (most of which are found in PaX and
> Grsecurity). I'm building on the presentation I gave at Kernel Summit
> where I sought to convince the other upstream Linux kernel developers
> that security is more than fixing bugs, and that we need to bring in
> proactive defenses:
> http://lwn.net/Articles/662219/
>=20
> This is especially highlighted by the Washington Post article today:
> http://www.washingtonpost.com/sf/business/2015/11/05/net-of-insecurity-=
the-kernel-of-the-argument/
>=20
> Between the companies that recognize the critical nature of this work,
> and with Linux Foundation's Core Infrastructure Initiative happy to
> start funding specific work in this area, I think we can really make a
> dent.
>=20
> Let's start the work. I've built some wiki pages around my slides,
> where we can take notes, list examples, and coordinate:
> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
>=20
> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
> gcc plugin, which will also get us the gcc plugin infrastructure.
> Other people, please speak up on what you'd like to tackle.
>=20
> I recommend PAX_REFCOUNT, PAX_USERCOPY, and GRKERNSEC_KSTACKOVERFLOW
> for some non-plugin stuff to look at.
>=20
> Once we've got plugins, then we should look at PAX_MEMORY_STACKLEAK
> and PAX_CONSTIFY_PLUGIN.
>=20
> If you're feeling like disrupting people who depend on debugging, do
> GRKERNSEC_HIDESYM.
>=20
> If you're feeling especially bold, start on PAX_KERNEXEC and follow it
> up with PAX_MEMORY_UDEREF.
>=20
> Of course, there's plenty of other things, and tons I haven't listed
> in the wiki -- please add them and bring them up for discussion here.
>=20
> -Kees
>=20



--PJOeDu2NfFA41wddORIpcsaWeJRH0L1AV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJWPRs1AAoJECLe/t9zvWqVjX4IAIKTZGZC0sIhjNnKF4TPCKM3
cERvWJdEjp9tlwHJqwZ66VFFsYv6cgjg/weRoWT0dPmiLUFoyIgMsnxEUhaJqXNu
2a7msMk95zEOCKeraLhA46/u+JXF4dNnaY6RFXIkM5w4M64qATyCbDhMzuFIOo7Z
MxiF8CXN3qfyaFVH1dbpYIVRbNbL2+yjrSeXIb9FSadDR1jiOVQLf70MRFoJCxtk
WQy1HbV8ejo/ZFC74vu1J49XJqkbeu9IxC2OvD4A8mbCuIj2h9Jd+EhyvEyE2954
uyzv+ymDA1YiV7Pvo3QqNwYOPbqOWIc3N7W5gPLZah8GBFuDTiwbZ4JBIP7kruM=
=/88+
-----END PGP SIGNATURE-----

--PJOeDu2NfFA41wddORIpcsaWeJRH0L1AV--
