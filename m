Date: Fri, 16 Mar 2018 23:56:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/ecc: Remove stack VLA usage
Message-ID: <20180316155632.GI7095@gondor.apana.org.au>
References: <20180308215702.GA9902@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308215702.GA9902@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 08, 2018 at 01:57:02PM -0800, Kees Cook wrote:
> On the quest to remove all VLAs from the kernel[1], this switches to
> a pair of kmalloc regions instead of using the stack. This also moves
> the get_random_bytes() after all allocations (and drops the needless
> "nbytes" variable).
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
