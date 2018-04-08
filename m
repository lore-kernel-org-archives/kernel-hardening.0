Date: Sun, 8 Apr 2018 11:19:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: ctr - avoid VLA use
Message-ID: <20180408031935.GC25197@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-3-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1523126303-23205-3-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Apr 07, 2018 at 08:38:19PM +0200, Salvatore Mesoraca wrote:
>
> @@ -206,6 +207,14 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
>  	if (alg->cra_blocksize < 4)
>  		goto out_put_alg;
>  
> +	/* Block size must be <= MAX_BLOCKSIZE. */
> +	if (alg->cra_blocksize > MAX_BLOCKSIZE)
> +		goto out_put_alg;
> +
> +	/* Alignmask must be <= MAX_ALIGNMASK. */
> +	if (alg->cra_alignmask > MAX_ALIGNMASK)
> +		goto out_put_alg;
> +

Since you're also adding a check to cipher algorithms in general,
none of these individual checks are needed anymore.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
