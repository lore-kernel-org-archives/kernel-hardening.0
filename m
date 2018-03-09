From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] staging: vchiq_arm: Clear VLA warning
In-Reply-To: <1520576470-20628-1-git-send-email-me@tobin.cc>
References: <1520576470-20628-1-git-send-email-me@tobin.cc>
Date: Fri, 09 Mar 2018 10:11:47 -0800
Message-ID: <877eqli0f0.fsf@anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
To: "Tobin C. Harding" <me@tobin.cc>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stefan Wahren <stefan.wahren@i2se.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

--=-=-=
Content-Type: text/plain

"Tobin C. Harding" <me@tobin.cc> writes:

> The kernel would like to have all stack VLA usage removed[1].  The
> array here is fixed (declared with a const variable) but it appears
> like VLA to the compiler.  We can use a pre-processor define to quiet
> the compiler.
>
> [1]: https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>
> The name of this constant may need changing, there is already a
> pre-processor constant VCHIQ_MAX_SERVICES

Maybe just use ARRAY_SIZE(local_max_services) and not have the #define?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlqizmQACgkQtdYpNtH8
nuip/g//fOzcTK1Mgomn3nfvXcxq5Rzl5d1e9ZX5CeOd1ecNomwGhAuMWxYWf4rP
g7j+Kah7c13lGQ0EcJTlC59T1Ml2WAtfEU5RiY0396+W30eRABALO3Afa/bsghHZ
HfgruKUTGA6MipeguFadfLSh/WPDy/AEW+pcCe005MZ+R9PYau+KK+d2BZfntMoI
4TncmLyCSChsYmWW/HFZreaNncV3C53tMv0R2uLoH/a7MmQhHWqwcuFPLp9BJ8Vq
UzfXx7Kbhd7zs6knQOv0wHULUAcoh61MR+wNYpZZycJ6gM2hmJNKRTnLE5ZfPRS7
4Zt9dhdIYODmlRZ5oItFHOxYakWGfDTKTjLWfbl0dBdHnPbZwVvdnafhfKMLcBIw
5dHbxJvdJPM4HEqjq95Ky9aXuCxq36OQK8qpi7W/9xsJCh1AqPw6li4611uULF/w
6X6NN7Xv+bOXFhndA0AKEn52+/zu80vpCPhK/MG7NUy9djLIX0ELM/dJQmDH8yPC
6cHK8fZpOBFaCqvTm5nwuduKRYGYfY1pdgQ1g6D9s/sMcwTESxBITIovTdtIKjq4
d5WvFvIXKzP/DgiPrHyOhfNcRgyQN4RDwdm4tCxQLHFGOwS9nUwSaottCMOVQCYM
GZTIiWGky7/1vOa5ynJVkItUTopwqiBKtsnOIxCGCaryEunp0dQ=
=1Rra
-----END PGP SIGNATURE-----
--=-=-=--
