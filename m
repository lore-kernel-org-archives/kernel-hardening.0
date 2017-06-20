Date: Tue, 20 Jun 2017 11:38:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20170620033809.GC17764@gondor.apana.org.au>
References: <20170610025912.6499-1-Jason@zx2c4.com>
 <20170611212023.31101-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170611212023.31101-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH] rsa-pkcs1pad: use constant time memory comparison for
 MACs
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, stable@vger.kernel.org, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 11, 2017 at 11:20:23PM +0200, Jason A. Donenfeld wrote:
> Otherwise, we enable all sorts of forgeries via timing attack.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Suggested-by: Stephan Müller <smueller@chronox.de>
> Cc: stable@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
