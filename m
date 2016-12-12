Reply-To: kernel-hardening@lists.openwall.com
References: <20161209230851.GB64048@google.com>
 <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
From: Gary R Hook <ghook@amd.com>
Message-ID: <1747e6e9-35dc-48cc-7345-4f0412ba2521@amd.com>
Date: Mon, 12 Dec 2016 12:45:18 -0600
MIME-Version: 1.0
In-Reply-To: <CALCETrWfa5VJQNu3XjeFhF0cDFWF+M-dPwsT_7dzO5YSxsneGg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
To: Andy Lutomirski <luto@amacapital.net>, Eric Biggers <ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Herbert Xu <herbert@gondor.apana.org.au>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 12/12/2016 12:34 PM, Andy Lutomirski wrote:

<...snip...>

>
> I have a patch to make these depend on !VMAP_STACK.
>
>>         drivers/crypto/ccp/ccp-crypto-aes-cmac.c:105,119,142
>>         drivers/crypto/ccp/ccp-crypto-sha.c:95,109,124
>>         drivers/crypto/ccp/ccp-crypto-aes-xts.c:162
>>         drivers/crypto/ccp/ccp-crypto-aes.c:94
>
> According to Herbert, these are fine.  I'm personally less convinced
> since I'm very confused as to what "async" means in the crypto code,
> but I'm going to leave these alone.

I went back through the code, and AFAICT every argument to sg_init_one() in
the above-cited files is a buffer that is part of the request context. Which
is allocated by the crypto framework, and therefore will never be on the 
stack.
Right?

I don't (as yet) see a need for any patch to these. Someone correct me 
if I'm
missing something.

<...snip...>

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
