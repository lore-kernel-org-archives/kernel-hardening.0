Date: Mon, 5 Jun 2017 23:00:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170606030004.4go6btmobrsmqiwz@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606005108.5646-5-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that the RNG is ready before
 using
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 02:50:59AM +0200, Jason A. Donenfeld wrote:
> Otherwise, we might be seeding the RNG using bad randomness, which is
> dangerous.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  crypto/rng.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/rng.c b/crypto/rng.c
> index f46dac5288b9..e042437e64b4 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -48,12 +48,14 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
>  		if (!buf)
>  			return -ENOMEM;
>  
> -		get_random_bytes(buf, slen);
> +		err = get_random_bytes_wait(buf, slen);

Note that crypto_rng_reset() is called by big_key_init() in
security/keys/big_key.c as a late_initcall().  So if we are on a
system where the crng doesn't get initialized until during the system
boot scripts, and big_key is compiled directly into the kernel, the
boot could end up deadlocking.

There may be other instances of where crypto_rng_reset() is called by
an initcall, so big_key_init() may not be an exhaustive enumeration of
potential problems.  But this is an example of why the synchronous
API, although definitely much more convenient, can end up being a trap
for the unwary....

						- Ted
