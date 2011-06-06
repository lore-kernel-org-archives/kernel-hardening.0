Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 6 Jun 2011 22:08:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110606180806.GA3986@albatros>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
 <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
 <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20110605201025.GA9541@openwall.com>
Subject: Re: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 00:10 +0400, Solar Designer wrote:
> > Process A with UID=3D1000 opens /proc/123/, while 123 has UID=3D1000.
> >=20
> > 123 exec's setuid binary, /proc/123/ becomes unaccessible to A.
> >=20
> > However, A still keeps the directory opened and may read its contents.
>=20
> Oh, this is a valid concern.  Please research this.  Perhaps there
> should be a may-ptrace check (or maybe more than one).

This is similar to CVE-2011-1020:

https://lkml.org/lkml/2011/2/7/368
http://seclists.org/fulldisclosure/2011/Jan/421

The proposed solution for separate procfs files is implementing
additional runtime checks (besides POSIX perms), however, it probably
doesn't scale for the whole PID directory.

Will try to invent some simple way to deal with it.

--=20
Vasiliy

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN7ReBAAoJEBoUx9gkVaZccFAP/1AdknhciHbADdLBG+2+AsMS
qEQ9Kij+mYJC8UMGx7DnJn5YJXTIHa8OTd60rSmKpgWEGe91gTwHrBlB2iAIvz56
GhE8oDTTlndsHZuRNfK0R+9p1yP2NP8qxJcVg09EtXVC5BdE8fh6xdMD4TeQwMS2
ZopjQt7J7eUjhajmOrGH03AcOJ8XbtpYEbouSOcGrceAxk5KaN5iL2/8h+by6G5x
9lkQgwO+t0wNay6GUVsID53NtDtopKzxLSBAtps7/ZHjqtl2ENh65npjbZzgaYiW
Y5lrTapKmULDefm5DY/iSGfS2oOcIH2z1JQhR74AfV6SO/VljWwSs2qgNBBGye1O
kQhnEgf72s3TQQtqWKuoedGgdC9aP39JFM2hFCbxLQJwz4rLAluN+OHVFQ+3bgek
yo9NyS2Wkm9a63/5DzeEhtYrLUUQbnqFi4tr2NSlBA1Sgp77eaKadDyvj0PV0G8U
+xIP938mDuaOgaft7YXpSFHXQledLCEQCYfbTzyrFrYoPttWgjfrPZDI05YbV2h4
zpbQyw9Cu0ItuLSVOvlN+IONxT2tCEmI0AhrQhL3esClekB3aydunkol9gClskc1
gqHF2EXWPlLzalfg9/0IJXY80Y7kbBAOq2lYaTaWaFs/CkXar+oe0BUVuzHY8+pb
bdBfDZVC0tpbfAGxJBoT
=eWEO
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
