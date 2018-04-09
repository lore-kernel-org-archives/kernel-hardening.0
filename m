From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2 0/2] crypto: removing various VLAs
Date: Mon, 9 Apr 2018 14:35:50 +0000
Message-ID: <ca31b95a8b8e4dab90c5ea2eb6e6477f@AcuMS.aculab.com>
References: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Salvatore Mesoraca
> Sent: 09 April 2018 14:55
>=20
> v2:
> 	As suggested by Herbert Xu, the blocksize and alignmask checks
> 	have been moved to crypto_check_alg.
> 	So, now, all the other separate checks are not necessary.
> 	Also, the defines have been moved to include/crypto/algapi.h.
>=20
> v1:
> 	As suggested by Laura Abbott[1], I'm resending my patch with
> 	MAX_BLOCKSIZE and MAX_ALIGNMASK defined in an header, so they
> 	can be used in other places.
> 	I took this opportunity to deal with some other VLAs not
> 	handled in the old patch.

If the constants are visible they need better names.
Maybe CRYPTO_MAX_xxx.

You can also do much better than allocating MAX_BLOCKSIZE + MAX_ALIGNMASK
bytes by requesting 'long' aligned on-stack memory.
The easiest way is to define a union like:

union crypto_tmp {
	u8 buf[CRYPTO_MAX_TMP_BUF];
	long buf_align;
};

Then in each function:

	union tmp crypto_tmp;
	u8 *keystream =3D PTR_ALIGN(tmp.buf, alignmask + 1);

I think CRYPTO_MAX_TMP_BUF needs to be MAX_BLOCKSIZE + MAX_ALIGNMASK - size=
of (long).

	David
