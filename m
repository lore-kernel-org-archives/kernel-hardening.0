Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1459969867.2818.28.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Wed, 06 Apr 2016 21:11:07 +0200
In-Reply-To: <CA+55aFxM2gWkV26ppU5hLh=s541Qx5yecbRySxDGKa1VP7NG=g@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	 <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	 <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	 <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	 <CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
	 <CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
	 <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
	 <1459968792.2818.22.camel@debian.org>
	 <CA+55aFxM2gWkV26ppU5hLh=s541Qx5yecbRySxDGKa1VP7NG=g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-3YVxs4q1aGb2+bPdIUBO"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on
 leakage in /proc/iomem file
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-3YVxs4q1aGb2+bPdIUBO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer., 2016-04-06 at 12:02 -0700, Linus Torvalds wrote:
> So yeah, maybe swap partitions are still more common than I thought.
> And I didn't even consider the possibility that people would hibernate
> a desktop like you do.

To be fair, it's *my* use case, because suspend won't work but I'm lazy and
don't like to reopen everything I was doing, but still have to shut the
machine down once in a while (or to save power). And *I* would gladly trade
hibernation for kaslr and PAX_SANITIZE on those desktops.

Regards,
--=20
Yves-Alexis


--=-3YVxs4q1aGb2+bPdIUBO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXBV9LAAoJEG3bU/KmdcClt04IAIiNYvXedcpWh5zLSonUVJEN
VRdllEt+im+0Mk1fVaVyJDqcHpc4296+2822ZFRdGpda4UGnoBEoOVsrZPPEwHju
jTK3JotmkK1f/m970BHbiBuJ/h2I/vIMnIlv/Cyfey+AWCOeElyvolRjgg1sG7sK
yO5WRkhtmGwpMqG1af+1sAnt+mdfiiZwpH53DLKlp5M1bCmpiLVE3wjjWDN7V+2H
lcG+t/etEQo1BDT6pu7G2FZvieHRbm4Mzwp/X4BoIDUszIP7ZtPnu8ojtJI2FLfo
6rZpPXG2XS/KpUFQnjIeVdM3lYwWq3qmnut6qDyCQyjgBUITn7nQUOnC6bNwazI=
=fDkg
-----END PGP SIGNATURE-----

--=-3YVxs4q1aGb2+bPdIUBO--
