Date: Tue, 20 Mar 2018 22:05:53 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 1/2] big key: get rid of stack array allocation
Message-ID: <20180321040553.GC18067@cisco>
References: <20180313042907.29598-1-tycho@tycho.ws>
 <20180315015139.GA641@zzz.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315015139.GA641@zzz.localdomain>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Wed, Mar 14, 2018 at 06:51:39PM -0700, Eric Biggers wrote:
> On Mon, Mar 12, 2018 at 10:29:06PM -0600, Tycho Andersen wrote:
> > We're interested in getting rid of all of the stack allocated arrays in the
> > kernel [1]. This patch removes one in keys by switching to malloc/free.
> > Note that we use kzalloc, to avoid leaking the nonce. I'm not sure this is
> > really necessary, but extra paranoia seems prudent.
> > 
> > Manually tested using the program from the add_key man page to trigger
> > big_key.
> > 
> > [1]: https://lkml.org/lkml/2018/3/7/621
> > 
> > Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> > CC: David Howells <dhowells@redhat.com>
> > CC: James Morris <jmorris@namei.org>
> > CC: "Serge E. Hallyn" <serge@hallyn.com>
> > CC: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  security/keys/big_key.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/security/keys/big_key.c b/security/keys/big_key.c
> > index fa728f662a6f..70f9f785c59d 100644
> > --- a/security/keys/big_key.c
> > +++ b/security/keys/big_key.c
> > @@ -108,13 +108,18 @@ static int big_key_crypt(enum big_key_op op, struct big_key_buf *buf, size_t dat
> >  	 * an .update function, so there's no chance we'll wind up reusing the
> >  	 * key to encrypt updated data. Simply put: one key, one encryption.
> >  	 */
> > -	u8 zero_nonce[crypto_aead_ivsize(big_key_aead)];
> > +	u8 *zero_nonce;
> > +
> > +	zero_nonce = kzalloc(crypto_aead_ivsize(big_key_aead), GFP_KERNEL);
> > +	if (!zero_nonce)
> > +		return -ENOMEM;
> >  
> >  	aead_req = aead_request_alloc(big_key_aead, GFP_KERNEL);
> > -	if (!aead_req)
> > +	if (!aead_req) {
> > +		kfree(zero_nonce);
> >  		return -ENOMEM;
> > +	}
> >  
> > -	memset(zero_nonce, 0, sizeof(zero_nonce));
> >  	aead_request_set_crypt(aead_req, buf->sg, buf->sg, datalen, zero_nonce);
> >  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
> >  	aead_request_set_ad(aead_req, 0);
> > @@ -131,6 +136,7 @@ static int big_key_crypt(enum big_key_op op, struct big_key_buf *buf, size_t dat
> >  error:
> >  	mutex_unlock(&big_key_aead_lock);
> >  	aead_request_free(aead_req);
> > +	kzfree(zero_nonce);
> >  	return ret;
> 
> A dynamic allocation here doesn't make sense -- the algorithm is hard-coded to
> AES-GCM, so the IV size is fixed.  You should just include <crypto/gcm.h> and
> use GCM_AES_IV_LEN.  As a sanity check you can add
> 'BUG_ON(crypto_aead_ivsize(big_key_aead) != GCM_AES_IV_LEN' to big_key_init().
> 
> kzfree() also doesn't make sense since the nonce is not secret information.

Thanks, I've fixed this for v2.

Cheers,

Tycho
