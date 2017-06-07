Date: Wed, 7 Jun 2017 15:10:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20170607071053.GC29532@gondor.apana.org.au>
References: <20170606215129.26388-1-Jason@zx2c4.com>
 <20170607042219.GC594@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607042219.GC594@zzz>
Subject: [kernel-hardening] Re: [PATCH v2] security/keys: rewrite all of big_key crypto
To: Eric Biggers <ebiggers3@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, David Howells <dhowells@redhat.com>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 09:22:19PM -0700, Eric Biggers wrote:
> Hi Jason,
> 
> On Tue, Jun 06, 2017 at 11:51:29PM +0200, Jason A. Donenfeld wrote:
> > issue now. And, some error paths forgot to zero out sensitive material, so
> > this patch changes a kfree into a kzfree.
> 
> There are other places in big_key.c that should be doing kzfree() instead of
> kfree().  Sorry, I actually recently did a patchset that fixed this for major
> parts of the keyrings API, but I skipped the big_key type because it was one of
> the more obscure key types (and frankly I have no idea what, if anything,
> actually uses it).  Probably the switch to kzfree() should be its own patch
> since it's a separate logical change.
> 
> >  {
> >  	int ret = -EINVAL;
> >  	struct scatterlist sgio;
> > -	SKCIPHER_REQUEST_ON_STACK(req, big_key_skcipher);
> > -
> > -	if (crypto_skcipher_setkey(big_key_skcipher, key, ENC_KEY_SIZE)) {
> > +	u8 req_on_stack[sizeof(struct aead_request) +
> > +			crypto_aead_reqsize(big_key_aead)];
> > +	struct aead_request *aead_req = (struct aead_request *)req_on_stack;
> > +
> 
> The crypto API with CONFIG_VMAP_STACK=y and CONFIG_DEBUG_SG=y is unhappy with
> using an aead_request on the stack, because it can't create a scatterlist from
> it.  It will need to be on the heap instead.  (Or else the crypto API fixed.)

You should not create AEAD requests on the stack.  The only reason
skcipher requests can be created on the stack is for backwards
compatibility with the sync blkcipher interface.

For new code you should always allocate the request using
aead_request_alloc.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
