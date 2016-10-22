Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 23 Oct 2016 01:17:17 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161022231717.GE3334@pc.thejh.net>
References: <CAEXv5_jjqZkLEsPY_B6++pf8EeVY=2YkvRJc+rGvEFSaXdRX=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Content-Disposition: inline
In-Reply-To: <CAEXv5_jjqZkLEsPY_B6++pf8EeVY=2YkvRJc+rGvEFSaXdRX=A@mail.gmail.com>
Subject: Re: [kernel-hardening] HARDENED_ATOMIC benchmarks
To: David Windsor <dwindsor@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 22, 2016 at 06:13:29PM -0400, David Windsor wrote:
> Hi,
>=20
> The following are the results of benchmarking HARDENED_ATOMIC.  The
> benchmarks performed were dbench and a timed Linux kernel compile using t=
he
> Phoronix test suite [1] on a Linux VirtualBox guest.
>=20
> dbench was chosen specifically to gauge the performance penalty involved =
in
> heavy usage of struct file->f_count, as this is one of the hottest users =
of
> atomic_t/atomic_long_t.

As far as I can tell, dbench doesn't actually exercise f_count all that much
because it doesn't use threads, it just forks, meaning that the file
descriptor table isn't shared, which in turn means that fdget() and fdput()
don't do any refcounting. (And even if it did use threads, it probably
wouldn't be testing the contended case.)

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYC/N9AAoJED4KNFJOeCOoJkwP/A4giA38nyXUTXaTTndjIIeT
eyUdfCbVdDOq8S+3us54UxKTrFwXYp74GZQReEdCoCYGj7cpvEXoLw/dBBNxbJEk
F6VIZnzkCW5rtV7EHxXYrlhaltMqxLyxdEKxXl58e8WYZirlnVNU/YFIWrAfXtWI
T9rwh4N2HC+f9trNsb95TiB8QshSV/s5zxs7rN84ISKGDTUu2JS/6SN/MzLCk20I
H8/umcNHXnk51FQ0mV7VctEkA1yPRUzRrHXWV2cFXQHBvuede5ye/z7Cza91XEcV
aZqQJrYYvZzkjaH9wc/9xvaNIK0DX9OStA7hbBpcmbMr6+euyj7yJmH25QHYO3C5
/7EPdiPdzGlK+/lC/1uwAalTTLMVHD9QX1hR7U0sMsJQ55BbH7PThKQp/Co2gb/b
9TrNZlh97pWLHmB5smed4hibdquuXoWpbZJk1s4xU8vrGy6MhvMPe2izur9aFcoK
go96Bz93PIlfOI6cN75RgKcma07fduEOwPUV/Km2nc2ZMVqod9CR2WDnBJoXCOj1
UxL2dOoyLPY3dVwM0BL4PRUQR+I2XAIg4R0E6bPfmf2dffkC8ZvWDkO8MXT6IdAT
AqNWmKLVJwWcjhEaTITJWqxElKrIaM4qwz3qCWT0wC25pRwR4tJGzYG/NN0K9u16
tDFjpeEgT0wRDeLQIMpk
=W5fw
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
