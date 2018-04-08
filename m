Date: Sun, 8 Apr 2018 11:16:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/6] crypto: api - avoid VLA use
Message-ID: <20180408031619.GB25197@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-4-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1523126303-23205-4-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Apr 07, 2018 at 08:38:20PM +0200, Salvatore Mesoraca wrote:
>
>  int crypto_init_cipher_ops(struct crypto_tfm *tfm)
>  {
> +	const unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
> +	const unsigned int size = crypto_tfm_alg_blocksize(tfm);
>  	struct cipher_tfm *ops = &tfm->crt_cipher;
>  	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
>  
> +	if (size > MAX_BLOCKSIZE || alignmask > MAX_ALIGNMASK)
> +		return -EINVAL;
> +

This check should be done when the algorithm is registered.  Perhaps
crypto_check_alg.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
