Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453510799.3734.153.camel@decadent.org.uk>
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sat, 23 Jan 2016 00:59:59 +0000
In-Reply-To: <CAGXu5jKbroEt0nO=yA4V6esKePseO75tcsK=YVy-=1NEuzwxzQ@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	 <1453502345-30416-3-git-send-email-keescook@chromium.org>
	 <CAP145piccauJvW6JrVzxm1xM3_5xtMk_Fa+uwFx-84+dKCS0WQ@mail.gmail.com>
	 <CAGXu5j+dS3nEc-9HhxBxQO0gWC-bakWxfJHzmfsVb7_AK_8+Jw@mail.gmail.com>
	 <CAP145pgdjQ4ALiq0wN9s-7PP5pxfMJs5xY7rdCjtYua6guUZqg@mail.gmail.com>
	 <CAGXu5jKbroEt0nO=yA4V6esKePseO75tcsK=YVy-=1NEuzwxzQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-b1ax81mfbcfld+vwSseD"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] sysctl: allow CLONE_NEWUSER
 to be disabled
To: kernel-hardening@lists.openwall.com, Robert =?UTF-8?Q?=C5=9Awi=C4=99cki?= <robert@swiecki.net>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W.
 Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-b1ax81mfbcfld+vwSseD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-01-22 at 15:00 -0800, Kees Cook wrote:
> On Fri, Jan 22, 2016 at 2:55 PM, Robert =C5=9Awi=C4=99cki <robert@swiecki=
.net> wrote:
> > 2016-01-22 23:50 GMT+01:00 Kees Cook <keescook@chromium.org>:
> >=20
> > > > Seems that Debian and some older Ubuntu versions are already using
> > > >=20
> > > > $ sysctl -a | grep usern
> > > > kernel.unprivileged_userns_clone =3D 0
> > > >=20
> > > > Shall we be consistent wit it?
> > >=20
> > > Oh! I didn't see that on systems I checked. On which version did you =
find that?
> >=20
> > $ uname -a
> > Linux bc1 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.3-5~bpo8+1
> > (2016-01-07) x86_64 GNU/Linux
> > $ cat /etc/debian_version
> > 8.2
>=20
> Ah-ha, Debian only, though it looks like this was just committed to
> the Ubuntu kernel tree too:
>=20
>=20
> > IIRC some older kernels delivered with Ubuntu Precise were also using
> > it (but maybe I'm mistaken)
>=20
> I don't see it there.
>=20
> I think my patch is more complete, but I'm happy to change the name if
> this sysctl has already started to enter the global consciousness. ;)
>=20
> Serge, Ben, what do you think?

I agree that using the '_restrict' suffix for new restrictions makes
sense. =C2=A0I also don't think that a third possible value for
kernel.unprivileged_userns_clone would would be understandable.

I would probably make kernel.unprivileged_userns_clone a wrapper for
kernel.userns_restrict in Debian, then deprecate and eventually remove
it.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n
--=-b1ax81mfbcfld+vwSseD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVqLQj+e/yOyVhhEJAQphXA/9FMO8e5N8fSfEopqbG0eutRAUWsCqUi8+
8GJKV2PMSfn9hyDFvEj0qwvBLsgT65tqlEs6mvV4FL378m5E+baSKGGSAXK+3Qzp
zGCZMyCUPW39w+sHaK6NBI9HbfSCtZMEeMq0UlhKb6QKvjGcAjzvopLbT8f7BX0G
EL0Cs8nV5hQzyV54c4gOvaCmhvW1y/HfGi00YE8Pm61r9skRXcKaO6O3ke6mEsVS
zMbsV/9FxYjVRsg+rh9xKQ68ugAW1J6ohPuJbhPKkucRjQr9XpyWALINXywWsXKw
S19BQnpYt9q5I4VSQ8LxIqOrr8wMvPOuoo/ml+jwLBZ6xCzK4bp6gqc4ZuXd9XjY
lZKjOpOZPycSmdhSXrCYjO+VocOdNQA568G+kiSGhdod4rMxxXKJBWR700vopsbx
ScOR6dmowWBFFrcsva19ZY+RevXGunPzvvQGv52LqmApqvDat0yvRFY6uVZtiBr0
9doOE8wnHIsvxUTv+opciPoS52GTgxeE1My6vXgzqJDRRoac1BNIdHtCSvhpK493
gqcGJPdltOZ8AZIPkCmnBX5R5Al38bmU0nYAl7pAbr3JZKR+la4HI0G4HG+QrLIm
drzPx8MyxAs5NGblXHhuu+LyRebpOvd6E45/dri1It5kN/FHituJk1hhv0Ym6YOT
lZbaz7NfCcs=
=Nb9X
-----END PGP SIGNATURE-----

--=-b1ax81mfbcfld+vwSseD--
