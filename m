MIME-Version: 1.0
In-Reply-To: <20180408031935.GC25197@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-3-git-send-email-s.mesoraca16@gmail.com> <20180408031935.GC25197@gondor.apana.org.au>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 8 Apr 2018 10:58:48 +0200
Message-ID: <CAJHCu1LQuvcxsfTYddN5o3=pMzj6mtnBKvTG9O378pv3w_Q24Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] crypto: ctr - avoid VLA use
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

018-04-08 5:19 GMT+02:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Sat, Apr 07, 2018 at 08:38:19PM +0200, Salvatore Mesoraca wrote:
>>
>> @@ -206,6 +207,14 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
>>       if (alg->cra_blocksize < 4)
>>               goto out_put_alg;
>>
>> +     /* Block size must be <= MAX_BLOCKSIZE. */
>> +     if (alg->cra_blocksize > MAX_BLOCKSIZE)
>> +             goto out_put_alg;
>> +
>> +     /* Alignmask must be <= MAX_ALIGNMASK. */
>> +     if (alg->cra_alignmask > MAX_ALIGNMASK)
>> +             goto out_put_alg;
>> +
>
> Since you're also adding a check to cipher algorithms in general,
> none of these individual checks are needed anymore.

Fair enough.
After removing the individual checks the modification to the single files
will be just a couple of lines, is it OK for you if I collapse all of them in
just a single commit?

Thank you,

Salvatore
