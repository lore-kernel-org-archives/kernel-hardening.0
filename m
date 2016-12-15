Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Dec 2016 15:57:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20161215075746.GA14699@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qA6qKdp+qoih2Je4fxU+4E6=Gp7CVfhYU7VbOr6HJ=0Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/4] siphash: add cryptographically secure hashtable
 function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: hannes@stressinduktion.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, jeanphilippe.aumasson@gmail.com, djb@cr.yp.to, torvalds@linux-foundation.org, ebiggers3@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> Siphash needs a random secret key, yes. The point is that the hash
> function remains secure so long as the secret key is kept secret.
> Other functions can't make the same guarantee, and so nervous periodic
> key rotation is necessary, but in most cases nothing is done, and so
> things just leak over time.

Actually those users that use rhashtable now have a much more
sophisticated defence against these attacks, dyanmic rehashing
when bucket length exceeds a preset limit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
