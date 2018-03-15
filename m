Date: Thu, 15 Mar 2018 17:54:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ctr: avoid VLA use
Message-ID: <20180315095428.GA31069@gondor.apana.org.au>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 14, 2018 at 02:17:30PM +0100, Salvatore Mesoraca wrote:
> All ciphers implemented in Linux have a block size less than or
> equal to 16 bytes and the most demanding hw require 16 bits
> alignment for the block buffer.
> We avoid 2 VLAs[1] by always allocating 16 bytes with 16 bits
> alignment, unless the architecture support efficient unaligned
> accesses.
> We also check, at runtime, that our assumptions still stand,
> possibly dynamically allocating a new buffer, just in case
> something changes in the future.

Please move the check to ctr instance creation time.  That is,
if the underlying blocksize is greater than 16 bytes than simply
fail the creation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
