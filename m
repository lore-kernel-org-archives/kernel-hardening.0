Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 13 Dec 2016 11:39:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20161213033928.GB5601@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com>
 <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
Subject: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 10:34:10AM -0800, Andy Lutomirski wrote:
>
> Here's my status.
> 
> >         drivers/crypto/bfin_crc.c:351
> >         drivers/crypto/qce/sha.c:299
> >         drivers/crypto/sahara.c:973,988
> >         drivers/crypto/talitos.c:1910
> >         drivers/crypto/qce/sha.c:325
> 
> I have a patch to make these depend on !VMAP_STACK.

Why? They're all marked as ASYNC AFAIK.

> I have a patch to convert this to, drumroll please:
> 
>     priv->tx_tfm_mic = crypto_alloc_shash("michael_mic", 0,
>                           CRYPTO_ALG_ASYNC);
> 
> Herbert, I'm at a loss as what a "shash" that's "ASYNC" even means.

Having 0 as type and CRYPTO_ALG_ASYNC as mask in general means
that we're requesting a sync algorithm (i.e., ASYNC bit off).

However, it is completely unnecessary for shash as they can never
be async.  So this could be changed to just ("michael_mic", 0, 0).

> >         net/ceph/crypto.c:182
> 
> This:
> 
> size_t zero_padding = (0x10 - (src_len & 0x0f));
> 
> is an amazing line of code...
> 
> But this driver uses cbc and wants to do synchronous crypto, and I
> don't think that the crypto API supports real synchronous crypto using
> CBC, so I'm going to let someone else fix this.

It does through skcipher if you allocate with (0, CRYPTO_ALG_ASYNC).

I'll try to fix this.

> >         net/rxrpc/rxkad.c:737,1000
> 
> Herbert, can you fix this?

Sure I'll take a look.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
