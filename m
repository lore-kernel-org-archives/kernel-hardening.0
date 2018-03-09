Subject: Re: [PATCH] crypto/ecc: Remove stack VLA usage
References: <20180307215615.GA18928@beast>
 <4fbe11f1-c92e-a4d5-616d-01e983f5405f@microchip.com>
 <CAGXu5jKEM8ot_YQ8Jt=npGrVWSwj=ROse4YOyQb9QmpEQkx=sg@mail.gmail.com>
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Message-ID: <7d80acb8-89e7-0afe-6c00-4936145d611d@microchip.com>
Date: Fri, 9 Mar 2018 10:21:59 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKEM8ot_YQ8Jt=npGrVWSwj=ROse4YOyQb9QmpEQkx=sg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, LKML <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-crypto <linux-crypto@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/08/2018 11:55 PM, Kees Cook wrote:
>> Looks like there are few intermediate buffers in ecc
>> that should be zeroized as well.
> Can you send a patch for those?

Yeah, I'll take a look.

Best,
ta
