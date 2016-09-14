Reply-To: kernel-hardening@lists.openwall.com
References: <20160908223558.GA11742@www.outflux.net>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <43f1953c-d8a3-647f-20eb-bec4898e1b8e@suse.cz>
Date: Wed, 14 Sep 2016 09:59:42 +0200
MIME-Version: 1.0
In-Reply-To: <20160908223558.GA11742@www.outflux.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SCmBI0OHadtpjcpbT9cG8TkILHfO3Kdqv"
Subject: [kernel-hardening] Re: [PATCH] pty: make ptmx file ops read-only after init
To: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SCmBI0OHadtpjcpbT9cG8TkILHfO3Kdqv
Content-Type: multipart/mixed; boundary="41SAiPljRDciVLOIwHECT0BnqN2Tb7OKH"
From: Jiri Slaby <jslaby@suse.cz>
To: Kees Cook <keescook@chromium.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Message-ID: <43f1953c-d8a3-647f-20eb-bec4898e1b8e@suse.cz>
Subject: Re: [PATCH] pty: make ptmx file ops read-only after init
References: <20160908223558.GA11742@www.outflux.net>
In-Reply-To: <20160908223558.GA11742@www.outflux.net>

--41SAiPljRDciVLOIwHECT0BnqN2Tb7OKH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/09/2016, 12:35 AM, Kees Cook wrote:
> The ptmx_fops structure is only changed during init, so mark it as such=
=2E

Right, but I am missing what is the benefit? You would have to elaborate
here...

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/tty/pty.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index 51e0d32883ba..a23fa5ed1d67 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -800,7 +800,7 @@ out_free_file:
>  	return retval;
>  }
> =20
> -static struct file_operations ptmx_fops;
> +static struct file_operations ptmx_fops __ro_after_init;
> =20
>  static void __init unix98_pty_init(void)
>  {
>=20

thanks,
--=20
js
suse labs


--41SAiPljRDciVLOIwHECT0BnqN2Tb7OKH--

--SCmBI0OHadtpjcpbT9cG8TkILHfO3Kdqv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIsBAEBCAAWBQJX2QNyDxxqc2xhYnlAc3VzZS5jegAKCRC9JbEEBrRwSfA3EACG
EVksnFvLMipcfFLz/qXIN3eRpUnmjCQPPgEmo8Xps4ZnVZYac8wXDJ0/VN1eVjl5
XCbt1fCoCp2sTFQXIZ1a4QpB7kn/MFGTBki90eEIZclR/FKx5VtpeVP0hcI+BpKd
JAb6hkQ9PwAOAPWidNkO75Fb07AER8A6nSp/enFDw7GMFmeECvoW7QDD5EhNsKtW
whtwnqTCyXnZgBR0P4IMTOy746+chMdEDjA0d3/Wwhm3pXOT42NZQ0LN2J60e/mO
myBi+dA/Yh2OfJOetC7SGtQ8yd96G5rB5PkCEgeVpgE3On3Q/mMiaZwRw7Uaz77v
BXQ4G4G8FazTfEnW+3dsyC2l4YhRqV6geX2QUe4eRvio9dGTHxan95DEn0Va9xcj
uqU0AVdMln7HdGvUeSt9QA3r/ne9xotxqmZn1rsLb6gfQfTBKv9VkclQtxSArDqp
5qYaKPlcJt3H20r1kjhvPLKmXUjXBu+Bd0hhgMRJDL4vpBIBas7MM6xWxGVpT52/
bgguTMzic7HzVbi7SiqNWQYw1hnDto+FLJ/UV0PjTcLnNfx54BPNekqO27XxZ6G3
JADS/J7CIdCk8zePG71MI7bZv5jFmNOZ+ukUwJVBrwgrS/mqV5OBAUAy3ylImg+i
NzOg3pIDoRM5l2Xic9Bwn4fMgJpjbztoOo2ZevU5Cg==
=jqbt
-----END PGP SIGNATURE-----

--SCmBI0OHadtpjcpbT9cG8TkILHfO3Kdqv--
