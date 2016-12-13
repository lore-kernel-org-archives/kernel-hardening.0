Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 13 Dec 2016 11:39:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20161213033942.GC5601@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com>
 <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
 <1747e6e9-35dc-48cc-7345-4f0412ba2521@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1747e6e9-35dc-48cc-7345-4f0412ba2521@amd.com>
Subject: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: Gary R Hook <ghook@amd.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 12:45:18PM -0600, Gary R Hook wrote:
> On 12/12/2016 12:34 PM, Andy Lutomirski wrote:
> 
> <...snip...>
> 
> >
> >I have a patch to make these depend on !VMAP_STACK.
> >
> >>        drivers/crypto/ccp/ccp-crypto-aes-cmac.c:105,119,142
> >>        drivers/crypto/ccp/ccp-crypto-sha.c:95,109,124
> >>        drivers/crypto/ccp/ccp-crypto-aes-xts.c:162
> >>        drivers/crypto/ccp/ccp-crypto-aes.c:94
> >
> >According to Herbert, these are fine.  I'm personally less convinced
> >since I'm very confused as to what "async" means in the crypto code,
> >but I'm going to leave these alone.
> 
> I went back through the code, and AFAICT every argument to sg_init_one() in
> the above-cited files is a buffer that is part of the request context. Which
> is allocated by the crypto framework, and therefore will never be on the
> stack.
> Right?

Right.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
