MIME-Version: 1.0
In-Reply-To: <20180314183157.GA183724@gmail.com>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com> <20180314183157.GA183724@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 14 Mar 2018 20:25:17 +0100
Message-ID: <CAJHCu1JARUv+8QU1Vy38Cswovvi1cAE_jYQm+QAic9rqhgw_bg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ctr: avoid VLA use
Content-Type: text/plain; charset="UTF-8"
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-14 19:31 GMT+01:00 Eric Biggers <ebiggers3@gmail.com>:
> On Wed, Mar 14, 2018 at 02:17:30PM +0100, Salvatore Mesoraca wrote:
>> All ciphers implemented in Linux have a block size less than or
>> equal to 16 bytes and the most demanding hw require 16 bits
>> alignment for the block buffer.
>> We avoid 2 VLAs[1] by always allocating 16 bytes with 16 bits
>> alignment, unless the architecture support efficient unaligned
>> accesses.
>> We also check, at runtime, that our assumptions still stand,
>> possibly dynamically allocating a new buffer, just in case
>> something changes in the future.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> ---
>>
>> Notes:
>>     Can we maybe skip the runtime check?
>>
>>  crypto/ctr.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 42 insertions(+), 8 deletions(-)
>>
>> diff --git a/crypto/ctr.c b/crypto/ctr.c
>> index 854d924..f37adf0 100644
>> --- a/crypto/ctr.c
>> +++ b/crypto/ctr.c
>> @@ -35,6 +35,16 @@ struct crypto_rfc3686_req_ctx {
>>       struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
>>  };
>>
>> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +#define DECLARE_CIPHER_BUFFER(name) u8 name[16]
>> +#else
>> +#define DECLARE_CIPHER_BUFFER(name) u8 __aligned(16) name[16]
>> +#endif
>> +
>> +#define CHECK_CIPHER_BUFFER(name, size, align)                       \
>> +     likely(size <= sizeof(name) &&                          \
>> +            name == PTR_ALIGN(((u8 *) name), align + 1))
>> +
>>  static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
>>                            unsigned int keylen)
>>  {
>> @@ -52,22 +62,35 @@ static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
>>       return err;
>>  }
>>
>> -static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
>> -                                struct crypto_cipher *tfm)
>> +static int crypto_ctr_crypt_final(struct blkcipher_walk *walk,
>> +                               struct crypto_cipher *tfm)
>>  {
>>       unsigned int bsize = crypto_cipher_blocksize(tfm);
>>       unsigned long alignmask = crypto_cipher_alignmask(tfm);
>>       u8 *ctrblk = walk->iv;
>> -     u8 tmp[bsize + alignmask];
>> -     u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
>>       u8 *src = walk->src.virt.addr;
>>       u8 *dst = walk->dst.virt.addr;
>>       unsigned int nbytes = walk->nbytes;
>> +     DECLARE_CIPHER_BUFFER(tmp);
>> +     u8 *keystream, *tmp2;
>> +
>> +     if (CHECK_CIPHER_BUFFER(tmp, bsize, alignmask))
>> +             keystream = tmp;
>> +     else {
>> +             tmp2 = kmalloc(bsize + alignmask, GFP_ATOMIC);
>> +             if (!tmp2)
>> +                     return -ENOMEM;
>> +             keystream = PTR_ALIGN(tmp2 + 0, alignmask + 1);
>> +     }
>>
>>       crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
>>       crypto_xor_cpy(dst, keystream, src, nbytes);
>>
>>       crypto_inc(ctrblk, bsize);
>> +
>> +     if (unlikely(keystream != tmp))
>> +             kfree(tmp2);
>> +     return 0;
>>  }
>
> This seems silly; isn't the !CHECK_CIPHER_BUFFER() case unreachable?  Did you
> even test it? If there's going to be limits, the crypto API ought to enforce
> them when registering an algorithm.

Yes, as I wrote in the commit log, I put that code just in case
something changes (i.e.
someone adds a cipher with a bigger block size), so that it won't fail
but just work as
is. Although I didn't really like it, hence the note.

> A better alternative may be to move the keystream buffer into the request
> context, which is allowed to be variable length.  It looks like that would
> require converting the ctr template over to the skcipher API, since the
> blkcipher API doesn't have a request context.  But my understanding is that that
> will need to be done eventually anyway, since the blkcipher (and ablkcipher) API
> is going away.  I converted a bunch of algorithms recently and I can look at the
> remaining ones in crypto/*.c if no one else gets to it first, but it may be a
> little while until I have time.

This seems much better. I don't think that removing these VLAs is
urgent, after all their sizes
are limited and not under user control: we can just wait.
I might help porting some crypto/*.c to skcipher API.

> Also, I recall there being a long discussion a while back about how
> __aligned(16) doesn't work on local variables because the kernel's stack pointer
> isn't guaranteed to maintain the alignment assumed by the compiler (see commit
> b8fbe71f7535)...

Oh... didn't know this! Interesting...

Thank you for your time,

Salvatore
