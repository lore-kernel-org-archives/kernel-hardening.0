Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1459968792.2818.22.camel@debian.org>
From: Yves-Alexis Perez <corsac@debian.org>
Date: Wed, 06 Apr 2016 20:53:12 +0200
In-Reply-To: <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
	 <CA+55aFzf+yuvRu8p2EWuJLz=vombadFRHbYaRDTu96TcjO3anA@mail.gmail.com>
	 <CA+55aFykp_ifLG=GkdGEM2keZs1Kb=eYcjjLz1LQh78LVSZong@mail.gmail.com>
	 <5e5e7c7ced7bede343530ed1447d7453@abdsec.com>
	 <CA+55aFxTzWKCqYaTTLSWccriebzXSeMCkgfvf6=rckB+_jvoiw@mail.gmail.com>
	 <CAGXu5j+gQT6pseNasW2qKSQ=wagcx06sfNqsmv5NSh8=MS4zAA@mail.gmail.com>
	 <CA+55aFx5Naq0rt99KZRWMf2GtyDaW1N2dapvdks_LMwaCYR13g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KFQK0RO+0VgJPKLQsYR9"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on
 leakage in /proc/iomem file
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Emrah Demir <ed@abdsec.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-KFQK0RO+0VgJPKLQsYR9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer., 2016-04-06 at 11:43 -0700, Linus Torvalds wrote:
> Hibernation is really quite nasty when you have to have a fairly big
> special partition for it, and shrink your memory down. Writing things
> to disk was a whole lot more reasonable back in the days when laptops
> had 16MB of memory.

Actually you just have to have a swap partition, which people still set as
more or less the ram size, I think, so all in all it works (especially if
people hibernate without the ram completely used).
>=20
> I really wonder how many people use it with a modern laptop and
> distro. I doubt it's much faster than just rebooting the whole system
> anyway, and there are lots of downsides.

I quite never hibernate on my laptop (it wouldn't work anyway since I boot =
wit
kaslr and have PAX_SANITIZE), but I use hibernation on desktops where suspe=
nd
to ram doesn't work because of radeon or nvidia graphic card (actually susp=
end
usually works, resume doesn't). If/when suspend to ram works fine, I think
hibernation is mostly useless.

Regards,
--=20
Yves-Alexis


--=-KFQK0RO+0VgJPKLQsYR9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXBVsYAAoJEG3bU/KmdcClggAH/2vae5f9U5/2VQLE/h+bcepU
Bcwhd6zJlsHwlol8g/bXMo/Zyj3RkkRxn+VmY/4VWT+bub36XfuOxaaNbPn0/PQk
AEBNDuzwJuirHRCAovvffHrXiD6mVLUTdpvMwGpnp6iOER8HJKSkW/Sin8BAQD4A
pxLhzO3DVZjZ526OJekXMM9zseamIgPqLv25rGBoVGct4jyDl3D94PRVvDLIfWuK
xnagDD9+utrE8ld+rNuWpKHqLZUR/TK5inbhtORzaWSoMIrkubZM0AP9exnE1mFv
duY4Sk8SxeykqIvHV+w9tVWe6vlEUgDgTcULXpNtSnz7C2RAHTdmaQGDA+QLlz4=
=xv8X
-----END PGP SIGNATURE-----

--=-KFQK0RO+0VgJPKLQsYR9--
