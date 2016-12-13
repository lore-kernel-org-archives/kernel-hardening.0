Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161213033928.GB5601@gondor.apana.org.au>
References: <20161209230851.GB64048@google.com> <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
 <20161213033928.GB5601@gondor.apana.org.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Dec 2016 09:06:31 -0800
Message-ID: <CALCETrVz4B2rthaKPJAOpiHm1kCh-mD2C5kKti0q8iBQ0QEzuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 7:39 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Dec 12, 2016 at 10:34:10AM -0800, Andy Lutomirski wrote:
>>
>> Here's my status.
>>
>> >         drivers/crypto/bfin_crc.c:351
>> >         drivers/crypto/qce/sha.c:299
>> >         drivers/crypto/sahara.c:973,988
>> >         drivers/crypto/talitos.c:1910
>> >         drivers/crypto/qce/sha.c:325
>>
>> I have a patch to make these depend on !VMAP_STACK.
>
> Why? They're all marked as ASYNC AFAIK.
>
>> I have a patch to convert this to, drumroll please:
>>
>>     priv->tx_tfm_mic = crypto_alloc_shash("michael_mic", 0,
>>                           CRYPTO_ALG_ASYNC);
>>
>> Herbert, I'm at a loss as what a "shash" that's "ASYNC" even means.
>
> Having 0 as type and CRYPTO_ALG_ASYNC as mask in general means
> that we're requesting a sync algorithm (i.e., ASYNC bit off).
>
> However, it is completely unnecessary for shash as they can never
> be async.  So this could be changed to just ("michael_mic", 0, 0).

I'm confused by a bunch of this.

1. Is it really the case that crypto_alloc_xyz(..., CRYPTO_ALG_ASYNC)
means to allocate a *synchronous* transform?  That's not what I
expected.

2. What guarantees that an async request is never allocated on the
stack?  If it's just convention, could an assertion be added
somewhere?
