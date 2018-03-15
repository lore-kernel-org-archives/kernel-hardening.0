MIME-Version: 1.0
In-Reply-To: <20180315095428.GA31069@gondor.apana.org.au>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com> <20180315095428.GA31069@gondor.apana.org.au>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Thu, 15 Mar 2018 11:42:25 +0100
Message-ID: <CAJHCu1+hKPTijqMO-bz5iB7fdmdxbh+xcpzW96tLYvOUBqhemg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ctr: avoid VLA use
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-15 10:54 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
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
>
> Please move the check to ctr instance creation time.  That is,
> if the underlying blocksize is greater than 16 bytes than simply
> fail the creation.

Good, I'll send a v2.
Thank you for your help,

Salvatore
