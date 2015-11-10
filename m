Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1447152151.29239.0.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Tue, 10 Nov 2015 11:42:31 +0100
In-Reply-To: <20151109211341.GA29829@srcf.ucam.org>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
	 <5640E0DD.6040107@labbott.name> <20151109182832.GB20491@io.lakedaemon.net>
	 <13041.1447095477@turing-police.cc.vt.edu>
	 <20151109190224.GD20491@io.lakedaemon.net>
	 <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
	 <20151109210922.GF20491@io.lakedaemon.net>
	 <20151109211341.GA29829@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-vOO9lonqxyLw4BFifyXv"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@google.com>, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-vOO9lonqxyLw4BFifyXv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun., 2015-11-09 at 21:13 +0000, Matthew Garrett wrote:
> On Mon, Nov 09, 2015 at 09:09:22PM +0000, Jason Cooper wrote:
>=20
> > Well, That's why I referred to reading from /boot or from a flash
> > partition.=C2=A0=C2=A0Existing bootloaders in the field already have th=
at
> > capability.=C2=A0=C2=A0That's how they load the kernel.
>=20
> This doesn't really handle cases like network booting. Most SoCs have=20
> some kind of RNG, recent x86 has hardware RNG, older x86 frequently has=
=20
> an RNG in a TPM. Pulling an entropy seed from the filesystem is a=20
> reasonable fallback, but we should definitely be thinking of it as a=20
> fallback - someone with physical access to your system while it's turned=
=20
> off may be able to infer the ASLR state for your next boot, for=20
> instance.

About the TPM RNG: I was definitely interested in the =E2=80=9Cget entropy =
from
TPM=E2=80=9D kind of thing for my laptop (even though I think my laptop wou=
ld
not be the worst place to find entropy). Right now I'm using rng-tools
to read from /dev/hwrng (handled by tpm_rng module), which then feeds
entropy to /dev/random (or maybe directly using the RND ioctls).

Do you think bypassing userland completely in order to be able to feed
that entropy even before userland is completely initialized would be
helpful?

Regards,

--=20
Yves-Alexis


--=-vOO9lonqxyLw4BFifyXv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWQcoXAAoJEG3bU/KmdcClHgYH/jxvJTNOlw0r5JNz7bQ9wwKs
yNZU3k1bOe4INZwRKxQOsJZCO7Lg78JHXlu2u4gjNl8wCR6Ric5GqsWiC6c4HmPO
gHqZZE1HHCkWGAE3mQp0wuJ6b50XFeqUKck7XXsHK78IGDTde5mMxmsMnWy0Tu1e
RU2xTIC3+j8tcZzT2mw2mc4FQoWcM5FbRssGUXdXGM0FIJjw8LGKcWkbtPji8Lvo
fvbBDJJngGjDSnEp1VD8xr+phUR8xp50Tu+z6SidXQjXFMQUTb+CdWbDnSE5YC9r
gnvN7ROmnIrxUBtvyDpy6fAoAzdc0jDbt9h2KIgwp4ozjKPjYm14SfNUK7xyrpg=
=QPgy
-----END PGP SIGNATURE-----

--=-vOO9lonqxyLw4BFifyXv--
