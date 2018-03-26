MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180316155632.GI7095@gondor.apana.org.au>
References: <20180308215702.GA9902@beast> <20180316155632.GI7095@gondor.apana.org.au>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 26 Mar 2018 15:38:59 -0700
Message-ID: <CAGXu5jKJ-05xb8x7A4dZmFQm10z5g9x1LhFbC1nzLT7kdVVbGg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto/ecc: Remove stack VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>, "David S. Miller" <davem@davemloft.net>, linux-crypto <linux-crypto@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 8:56 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Mar 08, 2018 at 01:57:02PM -0800, Kees Cook wrote:
>> On the quest to remove all VLAs from the kernel[1], this switches to
>> a pair of kmalloc regions instead of using the stack. This also moves
>> the get_random_bytes() after all allocations (and drops the needless
>> "nbytes" variable).
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Patch applied.  Thanks.

Hi, sorry for the noise on this one: I messed up looking at the ecc
code (I confused myself into thinking there was only a single instance
of the problem). The applied patch is both incomplete and inefficient.
I have a much simpler solution, and I'll send that with a revert...

-Kees

-- 
Kees Cook
Pixel Security
