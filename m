Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 12:56:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20161214045614.GB9592@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com>
 <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
 <20161213033928.GB5601@gondor.apana.org.au>
 <CALCETrVz4B2rthaKPJAOpiHm1kCh-mD2C5kKti0q8iBQ0QEzuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVz4B2rthaKPJAOpiHm1kCh-mD2C5kKti0q8iBQ0QEzuA@mail.gmail.com>
Subject: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 13, 2016 at 09:06:31AM -0800, Andy Lutomirski wrote:
>
> > Having 0 as type and CRYPTO_ALG_ASYNC as mask in general means
> > that we're requesting a sync algorithm (i.e., ASYNC bit off).
> >
> > However, it is completely unnecessary for shash as they can never
> > be async.  So this could be changed to just ("michael_mic", 0, 0).
> 
> I'm confused by a bunch of this.
> 
> 1. Is it really the case that crypto_alloc_xyz(..., CRYPTO_ALG_ASYNC)
> means to allocate a *synchronous* transform?  That's not what I
> expected.

crypto_alloc_xyz(name, 0, CRYPTO_ALG_ASYNC) allocates a sync tfm
and crypto_alloc_xyz(name, CRYPTO_ALG_ASYNC, CRYPTO_ALG_ASYNC)
allocates an async tfm while crypto_alloc_xyz(name, 0, 0) does
not care whether the allocated tfm is sync or asnc.

> 2. What guarantees that an async request is never allocated on the
> stack?  If it's just convention, could an assertion be added
> somewhere?

Sure we can add an assertion.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
