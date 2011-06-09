Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 9 Jun 2011 18:17:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110609141745.GA11957@albatros>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
Subject: [kernel-hardening] rlimit_nproc check
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Solar, all -

I found 8-years old patch that enables RLIMIT_NPROC check at setuid (and
similar) calls:

http://lkml.org/lkml/2003/7/13/226

So, checking it on execve() is a bit redundant.  But it means that
setuid() may fail if it follows setrlimit() call and the target user
has already reached the limit (asserted on the test C program).  If the
limit is defined in pam_limit, the attack becomes real.


Thanks,

--=20
Vasiliy

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN8NYEAAoJEBoUx9gkVaZcJ9YQAIMMdhJK1GeFXqDzaQnqv8Tn
+rdgGwoJhkrv9Km6hiwU69vU/kjwmoWy+PmB+yasyiVzoNWuxJXIOp3irwyVII6c
QERmFfM4zwLIAewcmdzVqw2xUPTPVW5of47TnPEUM6DnHcd83xHlPM2xu364roFw
0XxG+vufHgMuwHq2nSsOLXQbmBuKtmV67VihlBfwI7Y8drRdXJvwpqB1gizeP1qs
1eGiJXTNhwzdDDjjATEthVHl8MmuRLBdj58Tg2cAeEVAlw+NaYJDXzEKSpyqwiU7
tY7vVSs8gZJN23yUlh+tcmo8DHP67MlHnvrpfgnVjsIURIaldeORywZkih6iEHka
Nmcay0/pfD2C/Z3PCHh897zPSs5ykPH+/lPL5/nODpsAn+RmoyfLUFsM4lG1qYMO
iZSj0okY4ICLGOHeUCe65d6SFyEUh+0KmQ7V57gje17X22uJ4AaCt7Az1mE8ALEQ
o5sb8hPMw3Nnl7PX59ps9/1eKKnKqcmiudMNE3Vb/vtq/vzP8lDzZzhgtFJP75bk
99W3SniNxAqXG56gRWB8coj0T1Fa5emwXFiHnOLbt2qJRdU9avbGKP3ApMb0b0x3
O/Ix8aPkXvTDMLWahLFB76NttQLX/tVtbnDIh5NBd57g50SRuyaMnqFpqse26Dbn
wwKkxzGVN4POSxi+5va9
=9QpT
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
