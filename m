MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <4fbe11f1-c92e-a4d5-616d-01e983f5405f@microchip.com>
References: <20180307215615.GA18928@beast> <4fbe11f1-c92e-a4d5-616d-01e983f5405f@microchip.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 8 Mar 2018 13:55:22 -0800
Message-ID: <CAGXu5jKEM8ot_YQ8Jt=npGrVWSwj=ROse4YOyQb9QmpEQkx=sg@mail.gmail.com>
Subject: Re: [PATCH] crypto/ecc: Remove stack VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, LKML <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-crypto <linux-crypto@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 1:43 AM, Tudor Ambarus
<tudor.ambarus@microchip.com> wrote:
> Hi, Kees,
>
>
> On 03/07/2018 11:56 PM, Kees Cook wrote:
>>
>> On the quest to remove all VLAs from the kernel[1], this switches to
>> a pair of kmalloc regions instead of using the stack. This also moves
>> the get_random_bytes() after all allocations (and drops the needless
>> "nbytes" variable).
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   crypto/ecc.c | 23 +++++++++++++++++------
>>   1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/crypto/ecc.c b/crypto/ecc.c
>> index 18f32f2a5e1c..5bfa63603da0 100644
>> --- a/crypto/ecc.c
>> +++ b/crypto/ecc.c
>> @@ -1025,9 +1025,7 @@ int crypto_ecdh_shared_secret(unsigned int curve_id,
>> unsigned int ndigits,
>>   {
>>         int ret = 0;
>>         struct ecc_point *product, *pk;
>> -       u64 priv[ndigits];
>> -       u64 rand_z[ndigits];
>> -       unsigned int nbytes;
>> +       u64 *priv, *rand_z;
>>         const struct ecc_curve *curve = ecc_get_curve(curve_id);
>>         if (!private_key || !public_key || !curve) {
>> @@ -1035,14 +1033,22 @@ int crypto_ecdh_shared_secret(unsigned int
>> curve_id, unsigned int ndigits,
>>                 goto out;
>>         }
>>   -     nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +       priv = kmalloc_array(ndigits, sizeof(*priv), GFP_KERNEL);
>> +       if (!priv) {
>> +               ret = -ENOMEM;
>> +               goto out;
>> +       }
>>   -     get_random_bytes(rand_z, nbytes);
>> +       rand_z = kmalloc_array(ndigits, sizeof(*rand_z), GFP_KERNEL);
>> +       if (!rand_z) {
>> +               ret = -ENOMEM;
>> +               goto kfree_out;
>> +       }
>>         pk = ecc_alloc_point(ndigits);
>>         if (!pk) {
>>                 ret = -ENOMEM;
>> -               goto out;
>> +               goto kfree_out;
>>         }
>>         product = ecc_alloc_point(ndigits);
>> @@ -1051,6 +1057,8 @@ int crypto_ecdh_shared_secret(unsigned int curve_id,
>> unsigned int ndigits,
>>                 goto err_alloc_product;
>>         }
>>   +     get_random_bytes(rand_z, ndigits << ECC_DIGITS_TO_BYTES_SHIFT);
>> +
>>         ecc_swap_digits(public_key, pk->x, ndigits);
>>         ecc_swap_digits(&public_key[ndigits], pk->y, ndigits);
>>         ecc_swap_digits(private_key, priv, ndigits);
>> @@ -1065,6 +1073,9 @@ int crypto_ecdh_shared_secret(unsigned int curve_id,
>> unsigned int ndigits,
>>         ecc_free_point(product);
>>   err_alloc_product:
>>         ecc_free_point(pk);
>> +kfree_out:
>> +       kfree(priv);
>
>
> I think we should use kzfree here.
>
>> +       kfree(rand_z);
>
>
> Probably here too.

Ah yeah, good idea. I'll send a v2.

> Looks like there are few intermediate buffers in ecc
> that should be zeroized as well.

Can you send a patch for those?

Thanks!

-Kees

>
> Best,
> ta
>>
>>   out:
>>         return ret;
>>   }
>>
>



-- 
Kees Cook
Pixel Security
