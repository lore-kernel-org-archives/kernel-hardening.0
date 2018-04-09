MIME-Version: 1.0
In-Reply-To: <ca31b95a8b8e4dab90c5ea2eb6e6477f@AcuMS.aculab.com>
References: <1523282087-22128-1-git-send-email-s.mesoraca16@gmail.com> <ca31b95a8b8e4dab90c5ea2eb6e6477f@AcuMS.aculab.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 9 Apr 2018 18:38:18 +0200
Message-ID: <CAJHCu1+YynzroRkfZC9ki0b=RwiDOoOJB0S97uUVWSxLgac74A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] crypto: removing various VLAs
Content-Type: text/plain; charset="UTF-8"
To: David Laight <David.Laight@aculab.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-04-09 16:35 GMT+02:00 David Laight <David.Laight@aculab.com>:
> From: Salvatore Mesoraca
>> Sent: 09 April 2018 14:55
>>
>> v2:
>>       As suggested by Herbert Xu, the blocksize and alignmask checks
>>       have been moved to crypto_check_alg.
>>       So, now, all the other separate checks are not necessary.
>>       Also, the defines have been moved to include/crypto/algapi.h.
>>
>> v1:
>>       As suggested by Laura Abbott[1], I'm resending my patch with
>>       MAX_BLOCKSIZE and MAX_ALIGNMASK defined in an header, so they
>>       can be used in other places.
>>       I took this opportunity to deal with some other VLAs not
>>       handled in the old patch.
>
> If the constants are visible they need better names.
> Maybe CRYPTO_MAX_xxx.

You are right, in fact I renamed them, but forget to write about this
in the change log.
The new names look like MAX_CIPHER_*.

> You can also do much better than allocating MAX_BLOCKSIZE + MAX_ALIGNMASK
> bytes by requesting 'long' aligned on-stack memory.
> The easiest way is to define a union like:
>
> union crypto_tmp {
>         u8 buf[CRYPTO_MAX_TMP_BUF];
>         long buf_align;
> };
>
> Then in each function:
>
>         union tmp crypto_tmp;
>         u8 *keystream = PTR_ALIGN(tmp.buf, alignmask + 1);
>
> I think CRYPTO_MAX_TMP_BUF needs to be MAX_BLOCKSIZE + MAX_ALIGNMASK - sizeof (long).

Yeah, that would be nice, it might save us 4-8 bytes on the stack.
But I was thinking, wouldn't it be even better to do something like:

u8 buf[CRYPTO_MAX_TMP_BUF] __aligned(__alignof__(long));
u8 *keystream = PTR_ALIGN(buf, alignmask + 1);

In this case __aligned should work, if I'm not missing some other
subtle GCC caveat.

Thank you,

Salvatore
