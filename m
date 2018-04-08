MIME-Version: 1.0
In-Reply-To: <20180408031500.GA25197@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-2-git-send-email-s.mesoraca16@gmail.com> <20180408031500.GA25197@gondor.apana.org.au>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 8 Apr 2018 10:56:17 +0200
Message-ID: <CAJHCu1KkNgiFR1cZ+T6-+t5-41theqVsLU8umgqLi8JWhs2nxw@mail.gmail.com>
Subject: Re: [PATCH 1/6] crypto: api - laying macros for statically allocated buffers
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-04-08 5:15 GMT+02:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Sat, Apr 07, 2018 at 08:38:18PM +0200, Salvatore Mesoraca wrote:
>> Creating 2 new compile-time constants for internal use,
>> in preparation for the removal of VLAs[1] from crypto code.
>> All ciphers implemented in Linux have a block size less than or
>> equal to 16 bytes and the most demanding hw require 16 bytes
>> alignment for the block buffer.
>>
>> [1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> ---
>>  crypto/internal.h | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/crypto/internal.h b/crypto/internal.h
>> index 9a3f399..89ae41e 100644
>> --- a/crypto/internal.h
>> +++ b/crypto/internal.h
>> @@ -26,6 +26,14 @@
>>  #include <linux/rwsem.h>
>>  #include <linux/slab.h>
>>
>> +/*
>> + * Maximum values for blocksize and alignmask, used to allocate
>> + * static buffers that are big enough for any combination of
>> + * ciphers and architectures.
>> + */
>> +#define MAX_BLOCKSIZE                        16
>> +#define MAX_ALIGNMASK                        15
>
> No please don't put this here if you intend on using it everywhere.
> This file is reserved for truly internal bits.
>
> Perhaps include/crypto/algapi.h would be a better place.

OK, thank you for the suggestion :)

Salvatore
