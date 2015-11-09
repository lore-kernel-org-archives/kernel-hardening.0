Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <20151109182832.GB20491@io.lakedaemon.net>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com> <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com> <563F4A78.21151.23C6852D@pageexec.freemail.hu> <5640E0DD.6040107@labbott.name>
 <20151109182832.GB20491@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1447095477_2452P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Nov 2015 13:57:57 -0500
Message-ID: <13041.1447095477@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection features
To: kernel-hardening@lists.openwall.com
Cc: Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1447095477_2452P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Nov 2015 18:28:32 +0000, Jason Cooper said:
> I had a proposal a while back (can't find atm, sorry) to have the
> bootloader load the random-seed into RAM ...

It's *easy* to come up with an API to hand the kernel 64 or 128 bits of
random to kick things off.

The *hard* part is finding 64 or so bits of trustable random to hand to
the kernel....


--==_Exmh_1447095477_2452P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVkDstQdmEQWDXROgAQJKHQ/+IotM+0ViTdV4T9qy9rLmCzYrMSYf3XDw
YTarWif0MDQRrKnZigrA0R2/+s98wX2iATbuJc7XP8sItiqZq/KL2adZYNE2y3mL
wI6QDNgfbw5XNekxty2CFqTEzBcy6Mbtl9V3fWJH/ez3/07Vwrm213HhdLPQmoX6
uthhdZfjjomhL8wJA9TpR4gH3l0C00ccKCEWCDZD3l2cYiREPAouC/7KPDCilNdg
QNdTe5sdQ5w38fn82T40gTZCYAe/iQ3rPAHd6fm5uft9fs5cX2jRuCytix2cp4+5
G2xSA8AKBu1hDfz3u89ambWFXdNnQ9XF6hBZN5GOeHrOcDkWILkBm4hwHG/SDCEu
zZG5JTzuG6sM44Jlm0YpbEQAfh8rbi2dK/1AI02DHAFUTc2jl6oc7oHOZtM7bpDR
9Ow2q3ABBZosNRFb3IczeBJjvOFUuH/Ym1JqLJDncFvIkeuFBZTmFkdaHYKFKPBK
IOuTKvGouf3Hyus/XssijY+QV1tX0juzciK56v4G/bx9b7FvwfjW5IxkGakpzjy5
PiRtp+jFNR2J0pQvgMShj25yG1C7lbP/yLhAvheYJSmPwv8P3aHW2PeSNP03pEts
0viC625OxX3oAfDE3v49p2TMlQ535fPXR3Sv31xA8YSJKyLRe5B32gluIYvSrN58
kgd1foornB8=
=9AzY
-----END PGP SIGNATURE-----

--==_Exmh_1447095477_2452P--
