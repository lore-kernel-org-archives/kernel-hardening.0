Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <1467843928-29351-1-git-send-email-keescook@chromium.org>
References: <1467843928-29351-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1468347964_2257P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jul 2016 14:26:04 -0400
Message-ID: <86866.1468347964@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Re: [PATCH 0/9] mm: Hardened usercopy
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1468347964_2257P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jul 2016 15:25:19 -0700, Kees Cook said:
> Hi,
>
> This is a start of the mainline port of PAX_USERCOPY[1]. After I started
> writing tests (now in lkdtm in -next) for Casey's earlier port[2], I
> kept tweaking things further and further until I ended up with a whole
> new patch series. To that end, I took Rik's feedback and made a number
> of other changes and clean-ups as well.

And the good news is that my issues with ptrace() and ping seem to
have cleared up - I suspect there was a dangling piece of the original
4-patch series still lurking in my tree that appears to have been
slayed by a 'git reset --hard'.

Am running a next-20160708 kernel with the 9-patch series and it's working...

--==_Exmh_1468347964_2257P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV4U2PAdmEQWDXROgAQJyFA/8DxSvclE9PpMHLFM48L0KCljNrEkeF0K4
JFL+edjUn62QeEndfVbKmhB548QQxou8tEtf8j6Gg79ZTqNvvJnZZYeWQ7mMCmVG
JKIl/anKTkX/eZVBDRzvztDPhy3VhmR/GnkTSaI+V3X5xxuG3b7IzmDHHhXI98Mi
jYbEbdAqd0AVZp28es92g6JmpKrjgVEig7q6R9KLAvEknNFCd4V2AMeexvhNQ6GR
r0NK9ceh97AgBdB2OJE4ClQsK7ndOSTsw7NWa0yJElR/c8iN4LCEz9khpnFA9OZC
rCOjvAwwVHHLnAgdBJM1tNA3YpgNAtxvEZwfs227kJAEzWK0c4U4VwgvJywvdG7x
bU8J/yd/67qglWJ9eFxMN+Dgswb8O/D7fjl87ssO0FG5iWeGo77B3Gvq5EVdaU52
A9QQtebOOscKkg1uy75bIII6TeC4tAiCl8HWCrL4Jh7A/RFn9oStKiJHGUnRIu7t
JSoJ41TYQt07fEZ+q7TR0c0lAu4ipJ3Z2uKCokzqw/4VJYP86X11S5yFqTWsINDv
HwIvTgi5BomNJ7rc6GwdE+9yapKCEubKUAj1Y45A9REn4AEDgr9uLks/34Bf9u9m
GPhx/CN07iXJFDPHEpmFhx1OTHFo1J7XcZf7d75P4oh4vB1NbvqFwBNH2N2vlAlD
aHWnDM5jsOc=
=fNmC
-----END PGP SIGNATURE-----

--==_Exmh_1468347964_2257P--
