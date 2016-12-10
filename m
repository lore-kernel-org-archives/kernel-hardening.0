Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 10 Dec 2016 13:32:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20161210053208.GA27951@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com>
 <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
Subject: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 09, 2016 at 09:25:38PM -0800, Andy Lutomirski wrote:
>
> > The following crypto drivers initialize a scatterlist to point into an
> > ablkcipher_request, which may have been allocated on the stack with
> > SKCIPHER_REQUEST_ON_STACK():
> >
> >         drivers/crypto/ccp/ccp-crypto-aes-xts.c:162
> >         drivers/crypto/ccp/ccp-crypto-aes.c:94
> 
> These are real, and I wish I'd known about them sooner.

Are you sure? Any instance of *_ON_STACK must only be used with
sync algorithms and most drivers under drivers/crypto declare
themselves as async.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
