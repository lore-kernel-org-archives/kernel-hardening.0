Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 30 Jan 2016 15:34:56 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160130143455.GA27221@pc.thejh.net>
References: <1453622354-50686-1-git-send-email-sbauer@eng.utah.edu>
 <1453622354-50686-3-git-send-email-sbauer@eng.utah.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1453622354-50686-3-git-send-email-sbauer@eng.utah.edu>
Subject: Re: [kernel-hardening] [RFC PATCH 2/2] x86: SROP mitigation:
 implement signal cookies
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 24, 2016 at 12:59:14AM -0700, Scott Bauer wrote:
> This patch adds SROP mitigation logic to the x86 signal delivery
> and sigreturn code. The cookie is placed in the unused alignment
> space above the saved FP state, if it exists. If there is no FP
> state to save then the cookie is placed in the alignment space above
> the sigframe.

A nice side effect of this patch is that it will mitigate the ability of
a process in strict seccomp to effectively call sigprocmask() using
sigreturn.

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWrMoPAAoJED4KNFJOeCOoBloQAI8HgR6ZbPq2tncgJhidZuO1
GENVnZtPceM6SQOzTPBnW1se+qlSv39dx7tEZV4J8I7lKY4ehq/PBIoo+ENupzqW
ebX59uhpUYblVRN7DXS6W+Tfl08CyyoYY61KrSuyF5YJJ1uxTUAQVJPEfvsyWNLn
FroD4acvZWDvnUxVptc8aDl40Nj1nCAhljNIiAk5SdKh95KPPEAKNCkXj872gAIs
o+ayCOO65zrncMf+V6MZscI03WIOnh+X8YWhv7a/2NmKlq3lAVtWRbpkoM07ZB/m
ooZVpcVchK92Ax2VYOXo2dhnB0uRqMot6KlIGDsDZ5LHa2oSwTzXKvU1zqT+dAVg
El8HLFStFkUutWj6qpMk01OJ8setHLO0Hke4Mqxr9PMBZj9yMAq6pg7R65L9Ackt
mhCh6QBUcHdN6pyGf+NhnZ05jQEqNo9neQAbTg3XuLdj+1yt0U2lwcUqpIRcWKjl
seyu3CyySLaxsdRKNfD3dCLVIwUMUroChk2F4T5CBi3UPXLd9rCRAl2ZWN/VBz0f
rWZhbtgTtpwl1iWtgWAe4qet/z3D/W+W/mHUFJ0PeGAOInUwb6JFPhbOCI/CDpZ4
0Bl0TNkAY5vmpTaJguw+b7xt3Q5/eiSobL76kTYKB8uf91cEt0rvVJzWFkY0V62l
znP/4XwiI/UHN+I6RIS/
=MjFN
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
