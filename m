MIME-Version: 1.0
In-Reply-To: <20180408031619.GB25197@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-4-git-send-email-s.mesoraca16@gmail.com> <20180408031619.GB25197@gondor.apana.org.au>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 8 Apr 2018 11:07:12 +0200
Message-ID: <CAJHCu1LiPkDzL8rQMDdope=di+TZxz6gXuMKFQi_YpkSNquJ_g@mail.gmail.com>
Subject: Re: [PATCH 3/6] crypto: api - avoid VLA use
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-04-08 5:16 GMT+02:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Sat, Apr 07, 2018 at 08:38:20PM +0200, Salvatore Mesoraca wrote:
>>
>>  int crypto_init_cipher_ops(struct crypto_tfm *tfm)
>>  {
>> +     const unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
>> +     const unsigned int size = crypto_tfm_alg_blocksize(tfm);
>>       struct cipher_tfm *ops = &tfm->crt_cipher;
>>       struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
>>
>> +     if (size > MAX_BLOCKSIZE || alignmask > MAX_ALIGNMASK)
>> +             return -EINVAL;
>> +
>
> This check should be done when the algorithm is registered.  Perhaps
> crypto_check_alg.

Please correct me if I'm wrong:
isn't crypto_check_alg invoked also during hashing algorithm registration?
In this patch-set I'm dealing only with ciphers, because the maximum
block size (16)
is relatively small and it's also the most common block size with
ciphers (maybe I should
have explicitly referenced ciphers in the macro names, my bad).
I don't think that it would be OK to use a similar approach for hashes
too, because some
of them have block size >= 1024 bytes.

Thank you for your time,

Salvatore
