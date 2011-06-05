Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 6 Jun 2011 00:04:40 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605200438.GA7344@albatros>
References: <20110605182830.GB5789@albatros>
 <20110605183027.GA5859@albatros>
 <20110605194440.GA9413@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20110605194440.GA9413@openwall.com>
Subject: Re: [kernel-hardening] [RFC v1] debugfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Solar,

On Sun, Jun 05, 2011 at 23:44 +0400, Solar Designer wrote:
> However, please note that some Linux distros running in containers will
> happen to mount sysfs, which with OpenVZ provides some very limited
> functionality (just to make those distros happy).  Perhaps whatever you
> implement will need to be consistent/compatible with that.

Ah, I used OpenVZ with sysfs feature disabled.  I thought it is just
left blank.  In the code I see it is indeed functional.  Will look into
this.

Thanks!

--=20
Vasiliy

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN6+FRAAoJEBoUx9gkVaZcq4cQAI/NKe74YDfByP5OvsP1uc6a
si6yOVHxu4twxUVfYdNBL9rTDGLD1qfquu7msJ8xHcTvAPJJAPQ1ZJSN3gbv3u8J
TYoZQRDMwRgZ18amCPF70hXgNVFJliGfRl7o/OAoNfNErV40/dOs8li5P/XXQljM
+FtElcA8vGkIkJz4sW5Xs9HCYLovfNPsVs6KIRGHAeWRykWQ9xtc3xfSfhz6X/MG
YBgHcX2pIRcDHexn7CUgkII6DUA+dHeoLKCTf3JWbWfsL7xhyODX6tElv+a0q9TO
hlR5gBCgWQ3S491UEhG8Bw7tc1BoZX2PglQhwVx/iS3P7zCB92+8yLxCqhvXmw03
j7UUzRNUjsZ1dNmfMZZ8wIuRol2D0b/SEz4WsI+SY1P60sWMhPnbI4PodJ312cQM
48H7TwhnCxzNjc287/1bN0W2EnXFSbxdK+jmkGa11TpF+0ewfcnhjxnT6yqxK7eB
xApZ068RSJ3oNJRSICr950ijzyCISX4YiCO3q7l7nBY8heM7T5MzE6tb4EmegyZZ
12aQLbcfg13Bn90YVqKgR4J+cDuRHqZ/o+m4dpO4F+/zvmwGdv8LiStBiRWUhZWh
klcVfK2z3ewv+DqnLKAHRRQBf0IHr13lgadRGoTnl9jD31HBnc9ifEKPbEOLPHL0
ziInIjShNWci6X/NPLk0
=D4wE
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
