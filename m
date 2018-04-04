MIME-Version: 1.0
In-Reply-To: <4e536889-439a-49e6-dd95-2d4286913202@redhat.com>
References: <1522400006-8859-1-git-send-email-s.mesoraca16@gmail.com> <4e536889-439a-49e6-dd95-2d4286913202@redhat.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 4 Apr 2018 11:49:54 +0200
Message-ID: <CAJHCu1KEuu61_7sWaGtxWgC-3SQeu2cyeFhK0+3s5t3FNNWg9A@mail.gmail.com>
Subject: Re: [v3] crypto: ctr - avoid VLA use
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Laura Abbott <labbott@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-04-03 23:37 GMT+02:00 Laura Abbott <labbott@redhat.com>:
> On 03/30/2018 01:53 AM, Salvatore Mesoraca wrote:
>> ---
>>   crypto/ctr.c | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/crypto/ctr.c b/crypto/ctr.c
>> index 854d924..49c469d 100644
>> --- a/crypto/ctr.c
>> +++ b/crypto/ctr.c
>> @@ -21,6 +21,9 @@
>>   #include <linux/scatterlist.h>
>>   #include <linux/slab.h>
>>   +#define MAX_BLOCKSIZE 16
>> +#define MAX_ALIGNMASK 15
>> +
>
>
> Can we pull this out into a header file, I think this would cover
>
> crypto/cipher.c: In function =E2=80=98cipher_crypt_unaligned=E2=80=99:
> crypto/cipher.c:70:2: warning: ISO C90 forbids variable length array
> =E2=80=98buffer=E2=80=99 [-Wvla]
>   u8 buffer[size + alignmask];
>   ^~

Yeah, I'll send a patchset that includes the fix for crypto/cipher.c too.

Thank you for the suggestion :)

Salvatore
