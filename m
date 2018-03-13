Date: Tue, 13 Mar 2018 12:39:03 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 2/2] dh key: get rid of stack array allocation
Message-ID: <20180313173903.GA19174@mail.hallyn.com>
References: <20180313042907.29598-1-tycho@tycho.ws>
 <20180313042907.29598-2-tycho@tycho.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313042907.29598-2-tycho@tycho.ws>
To: Tycho Andersen <tycho@tycho.ws>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Tycho Andersen (tycho@tycho.ws):
> Similarly to the previous patch, we would like to get rid of stack
> allocated arrays: https://lkml.org/lkml/2018/3/7/621
> 
> In this case, we can also use a malloc style approach to free the temporary
> buffer, being careful to also use kzfree to free them (indeed, at least one
> of these has a memzero_explicit, but it seems like maybe they both
> should?).
> 
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: David Howells <dhowells@redhat.com>
> CC: James Morris <jmorris@namei.org>
> CC: "Serge E. Hallyn" <serge@hallyn.com>

Acked-by: Serge Hallyn <serge@hallyn.com>

for both, thanks.

> ---
>  security/keys/dh.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/security/keys/dh.c b/security/keys/dh.c
> index d1ea9f325f94..f02261b24759 100644
> --- a/security/keys/dh.c
> +++ b/security/keys/dh.c
> @@ -162,19 +162,27 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
>  			goto err;
>  
>  		if (zlen && h) {
> -			u8 tmpbuffer[h];
> +			u8 *tmpbuffer;
>  			size_t chunk = min_t(size_t, zlen, h);
> -			memset(tmpbuffer, 0, chunk);
> +
> +			err = -ENOMEM;
> +			tmpbuffer = kzalloc(chunk, GFP_KERNEL);
> +			if (!tmpbuffer)
> +				goto err;
>  
>  			do {
>  				err = crypto_shash_update(desc, tmpbuffer,
>  							  chunk);
> -				if (err)
> +				if (err) {
> +					kzfree(tmpbuffer);
>  					goto err;
> +				}
>  
>  				zlen -= chunk;
>  				chunk = min_t(size_t, zlen, h);
>  			} while (zlen);
> +
> +			kzfree(tmpbuffer);
>  		}
>  
>  		if (src && slen) {
> @@ -184,13 +192,20 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
>  		}
>  
>  		if (dlen < h) {
> -			u8 tmpbuffer[h];
> +			u8 *tmpbuffer;
> +
> +			err = -ENOMEM;
> +			tmpbuffer = kzalloc(h, GFP_KERNEL);
> +			if (!tmpbuffer)
> +				goto err;
>  
>  			err = crypto_shash_final(desc, tmpbuffer);
> -			if (err)
> +			if (err) {
> +				kzfree(tmpbuffer);
>  				goto err;
> +			}
>  			memcpy(dst, tmpbuffer, dlen);
> -			memzero_explicit(tmpbuffer, h);
> +			kzfree(tmpbuffer);
>  			return 0;
>  		} else {
>  			err = crypto_shash_final(desc, dst);
> -- 
> 2.15.1
