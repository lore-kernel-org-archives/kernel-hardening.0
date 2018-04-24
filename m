Date: Mon, 23 Apr 2018 21:50:15 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 1/3] big key: get rid of stack array allocation
Message-ID: <20180424045015.GA4281@sol.localdomain>
References: <20180424010321.14739-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424010321.14739-1-tycho@tycho.ws>
To: Tycho Andersen <tycho@tycho.ws>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tycho,

On Mon, Apr 23, 2018 at 07:03:19PM -0600, Tycho Andersen wrote:
> We're interested in getting rid of all of the stack allocated arrays in the
> kernel [1]. This patch simply hardcodes the iv length to match that of the
> hardcoded cipher.
> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> v2: hardcode the length of the nonce to be the GCM AES IV length, and do a
>     sanity check in init(), Eric Biggers
> 
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: David Howells <dhowells@redhat.com>
> CC: James Morris <jmorris@namei.org>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Jason A. Donenfeld <Jason@zx2c4.com>
> CC: Eric Biggers <ebiggers3@gmail.com>
> ---
>  security/keys/big_key.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/security/keys/big_key.c b/security/keys/big_key.c
> index 933623784ccd..75c46786a166 100644
> --- a/security/keys/big_key.c
> +++ b/security/keys/big_key.c
> @@ -22,6 +22,7 @@
>  #include <keys/user-type.h>
>  #include <keys/big_key-type.h>
>  #include <crypto/aead.h>
> +#include <crypto/gcm.h>
>  
>  struct big_key_buf {
>  	unsigned int		nr_pages;
> @@ -109,7 +110,7 @@ static int big_key_crypt(enum big_key_op op, struct big_key_buf *buf, size_t dat
>  	 * an .update function, so there's no chance we'll wind up reusing the
>  	 * key to encrypt updated data. Simply put: one key, one encryption.
>  	 */
> -	u8 zero_nonce[crypto_aead_ivsize(big_key_aead)];
> +	u8 zero_nonce[GCM_AES_IV_SIZE];
>  
>  	aead_req = aead_request_alloc(big_key_aead, GFP_KERNEL);
>  	if (!aead_req)
> @@ -425,6 +426,12 @@ static int __init big_key_init(void)
>  		pr_err("Can't alloc crypto: %d\n", ret);
>  		return ret;
>  	}
> +
> +	if (unlikely(crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_SIZE)) {
> +		WARN(1, "big key algorithm changed?");
> +		return -EINVAL;
> +	}
> +

'big_key_aead' needs to be freed on error.

	err = -EINVAL;
	goto free_aead;

Also how about defining the IV size next to the algorithm name?
Then all the algorithm details would be on adjacent lines:

static const char big_key_alg_name[] = "gcm(aes)";
#define BIG_KEY_IV_SIZE         GCM_AES_IV_SIZE

- Eric
