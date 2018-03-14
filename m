From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: ctr: avoid VLA use
Date: Wed, 14 Mar 2018 14:31:27 +0100
Message-ID: <4726635.XOh0VtZf4O@tauon.chronox.de>
In-Reply-To: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Am Mittwoch, 14. M=E4rz 2018, 14:17:30 CET schrieb Salvatore Mesoraca:

Hi Salvatore,

>  	if (walk.nbytes) {
> -		crypto_ctr_crypt_final(&walk, child);
> -		err =3D blkcipher_walk_done(desc, &walk, 0);
> +		err =3D crypto_ctr_crypt_final(&walk, child);
> +		err =3D blkcipher_walk_done(desc, &walk, err);

I guess you either want to handle the error from crypto_ctr_crypt_final or =
do=20
an err |=3D blkcipher_walk_done.

>  	}
>=20
>  	return err;



Ciao
Stephan
