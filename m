Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1465436379.16365.163.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 08 Jun 2016 21:39:39 -0400
In-Reply-To: <20160609004758.GA8658@grsecurity.net>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
	 <1465420302-23754-2-git-send-email-keescook@chromium.org>
	 <20160609004758.GA8658@grsecurity.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-R+K0tKn2wmd8gDDrUkSg"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH v2 1/4] mm: Hardened usercopy
To: Brad Spengler <spender@grsecurity.net>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-R+K0tKn2wmd8gDDrUkSg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-06-08 at 20:47 -0400, Brad Spengler wrote:
> >=20
> > diff --git a/mm/usercopy.c b/mm/usercopy.c
> > new file mode 100644
> > index 000000000000..e09c33070759
> > --- /dev/null
> > +++ b/mm/usercopy.c
> > @@ -0,0 +1,177 @@
> > +/*
> > + * This implements the various checks for
> > CONFIG_HARDENED_USERCOPY*,
> > + * which are designed to protect kernel memory from needless
> > exposure
> > + * and overwrite under many conditions.
> > + */
> As this is a new file being introduced which is (modulo some
> bikeshedding
> and addition of a few comments) a direct copy+paste of our code and
> comments
> in fs/exec.c, I would appreciate both a GPL notice (the same as
> exists for
> KASAN, etc) and both the PaX Team and myself being listed as the
> copyright
> owners.
>=20
I have to agree with this. Credit where credit is due.

--=20
All Rights Reversed.


--=-R+K0tKn2wmd8gDDrUkSg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJXWMjbAAoJEM553pKExN6DXHIH/idcC6tAEdhVSzSCN1tirCMe
j5YDcWZ/uX7vQZw3VjIBPR2xYnD4g1JqG3hv53HkabOJ41ACKmB7+q1cnpOjPT+l
U38CbI+Aukj9Z3771RoZx+ss7TewyTGygBrgifQpd857bKUyIzQhZUISkoA7kZ3I
ErqUvVnIT6KY/mgx43R5XlpahzO8vSyEhNVmznIYyj1w0XVpHdMLAkjkI57WixNr
lVuti2zNZ3yRdSss+FL8QOopADBGOwOtUZxC/jOZawQd1sbCcTPM1gdU9pZpIWio
DuAQPGTTZtrQfucKc/lXGqWQqko2RNYjROmJY4ZK1ATprxZs47nWPK4pwR/8Hoo=
=FBAw
-----END PGP SIGNATURE-----

--=-R+K0tKn2wmd8gDDrUkSg--
