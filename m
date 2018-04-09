MIME-Version: 1.0
In-Reply-To: <20180408092219.s24ymooq7afu43c2@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-4-git-send-email-s.mesoraca16@gmail.com>
 <20180408031619.GB25197@gondor.apana.org.au> <CAJHCu1LiPkDzL8rQMDdope=di+TZxz6gXuMKFQi_YpkSNquJ_g@mail.gmail.com>
 <20180408092219.s24ymooq7afu43c2@gondor.apana.org.au>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 9 Apr 2018 15:27:03 +0200
Message-ID: <CAJHCu1La-QVqjd5nVMWF_vKMZhhuqGRWshEHGTLkZCeiDDvFGw@mail.gmail.com>
Subject: Re: [PATCH 3/6] crypto: api - avoid VLA use
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-04-08 11:22 GMT+02:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Sun, Apr 08, 2018 at 11:07:12AM +0200, Salvatore Mesoraca wrote:
>>
>> > This check should be done when the algorithm is registered.  Perhaps
>> > crypto_check_alg.
>>
>> Please correct me if I'm wrong:
>> isn't crypto_check_alg invoked also during hashing algorithm registration?
>> In this patch-set I'm dealing only with ciphers, because the maximum
>> block size (16)
>> is relatively small and it's also the most common block size with
>> ciphers (maybe I should
>> have explicitly referenced ciphers in the macro names, my bad).
>> I don't think that it would be OK to use a similar approach for hashes
>> too, because some
>> of them have block size >= 1024 bytes.
>
> Yes we want to make it for ciphers only even if we move it to
> crypto_check_alg.
>
> For a legacy type like cipher cou can do it by
>
>         if (!alg->cra_type && (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
>                               CRYPTO_ALG_TYPE_CIPHER)
>                 do_cipher_specific_check();
>

Thank you very much for your help.
I'm sending the new version.

Salvatore
