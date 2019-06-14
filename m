Date: Fri, 14 Jun 2019 20:14:34 +0200
From: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
Message-ID: <20190614201434.3fa4bb6d@primarylaptop.localdomain>
In-Reply-To: <20190614162811.o33yeq65ythjumrh@shell.armlinux.org.uk>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
	<CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
	<20190614162811.o33yeq65ythjumrh@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/voOOXX9XV5OPRkIfDNCClwK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Paul Kocialkowski <paul.kocialkowski@bootlin.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

--Sig_/voOOXX9XV5OPRkIfDNCClwK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Jun 2019 17:28:11 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> I'm wondering whether this is sloppy wording or whether the author is
> really implying that they call the kernel decompressor with the MMU
> enabled, against the express instructions in
> Documentation/arm/Booting.
According to [1]
> If they are going against the express instructions, all bets are off.

More background on the decompressor patch:
- The "ANDROID: arm: decompressor: Flush tlb before swiching domain 0 to
  client mode" patch is needed anyway since 3.4 in any case, and
  according to the thread about it [1], the MMU is on at boot.
- There is a downstream u-boot port for the Galaxy SIII and other very
  similar devices, which doesn't setup the MMU at boot, but I'm not
  confident enough to test in on the devices I have. To test with
  u-boot I'd need to find a new device.
- If I don't manage to find a new device to test on, since there is
  already some setup code like arch/arm/boot/compressed/head-sa1100.S
  that deal with MMU that are enabled with the bootloader, are patches
  to add a new file like that still accepted? The big downside is that
  using something like that is probably incompatible with
  ARCH_MULTIPLATFORM.

References:
-----------
[1]http://lkml.iu.edu/hypermail/linux/kernel/1212.1/02099.html
[2]https://blog.forkwhiletrue.me/posts/an-almost-fully-libre-galaxy-s3/

Denis.

--Sig_/voOOXX9XV5OPRkIfDNCClwK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEeC+d2+Nrp/PU3kkGX138wUF34mMFAl0D5AoACgkQX138wUF3
4mPGRg//XSxQro0dtk4EQYdV0C1YPG1fXjbs8d+Mq3FkDDXuzQd22ph1a0tHxWwX
sojh58OJZHrdcnL/CC4V85qxTEW5gK7V3zklM3gZEaktbU7/7P1BHMAvI9RNrU+A
A64fKneSHJu2o9dRpKQLCuuMOgBPWNX5wAeBdF1Wnrvt+XTtdNF7Skt52mOWlOU9
hWHtU1Qfg6NKd7F/j5IhXlfghz/E6MtdGXTl3w23nZkYe4D250ZTzlrJMfxEUkqd
7Wn4a4aiuXfXzN173/8aA7xZZFRC1Km2LOvmv2qPyXvYKZplAy6Zu7TNwgKZfqDg
hmDFNAR4oMZH05mPnPwk2jAhvf10Rq74Nn+Xfi5DMbIwS43pCpCmepF0NqCu+QRQ
esd/EWz5KcNFJxMnSi4OWa9+eH8vXERBJTNERLTLtuf3hN5+GTKgp0+Qpaax/lcr
8hrQ0Tij7aZMEzaOYP/fYF02xESxWUPxWWm2XQdIW1MJEFSWgwIDjgSp/06j0g0Y
NOh5LIrH9cPwGB86dppI8ctW/Ca1ifkn3FxYMLyBnraWXehgZqX13Col0oViSLHn
coKhAQ31tAzCkIlJ5+gwlspGc6vBMthHh4gc2RjqxC9ji3f+XY1/aKy3HhBs+Nj3
BJ/yjZ7dGkpzJNY70DQ1z2a2A8L3Ct6+TVyFpDixm/sq4NUYZ6A=
=Ws9W
-----END PGP SIGNATURE-----

--Sig_/voOOXX9XV5OPRkIfDNCClwK--
