Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 22:36:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605183620.GB5859@albatros>
References: <20110603191153.GB514@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20110603191153.GB514@openwall.com>
Subject: [kernel-hardening] Re: [owl-dev] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 03, 2011 at 23:11 +0400, Solar Designer wrote:
> Indeed, we could set some of these perms with chmod post-mount, but as
> discussed this has drawbacks.  So ideally our preferred configuration
> (which will be the default on Owl) should be achievable with mount
> options alone.

What if implement mode=3DXXX option to alter root directory permissions
only, like tmpfs?  Then all non-pid files may be chmod'ed without any
race due to distro-specific policy and then "chmod a+rx /proc" to allow
nonroot users to see procfs files.

Thanks,

--=20
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN68ykAAoJEBoUx9gkVaZcoQsP/19foUUZM71huFAAwHspXbw8
QpIz4/Kqp3RnlxCRTn+7voQP2zZQU0J4YgvIHIps0OcKICJTEURPfZCcyg19rZGf
6NsVVflJGKUNETDf776EK4Yg30TuOWYc/A+zDDEDYInp8eUDICvLSv3iTPzRbNcb
RYvnasEyK5i5F/hGT+5zML5PCZBze/eTzd75CXTnzXzK+ti+/ilo0y29TcLcMGmO
Vki5nrDACAl3C7QOlMKzgiv7tJ/TyfD9gNSSvYcSusbLG507kan3bkZDB7BBj6ZY
3IDKbWrtuyWRHKthaS+fcT6eHzCcdnuURKiKtH1CyolNura2Ic3jkXb/JyTCO9Zs
jhKrUUT/1IDaYkou6d3e6G1cPebotR8nb3BeDMf7f89xU1kRdjJpfDPV3cj9u6cw
siyxwBMdJbbBQWSfptcgftYEAkEsY5xzzBRE2il22fGL+8SWxXbageLuWKrHlrdJ
WyQPtdKUj60wbKOXzmwJQgzJGfSca/sDbSQRAOksKdzo9wHlxfU1NZoaqR9v0yNm
28/BgC/IwcATWeK3AquhMSMPVcmo8TQQBzIje5AzUZfejnfkLGK7ltmfMf8NnC3f
Ojkw+4gsqDtmCXXkvl8DYHGt022HbJJGXSXQsKoTfFPq3dRJgPb5qxB/4EsdsXM7
HduYYlej3dkXnz/q/MZ6
=oGvc
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
