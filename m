Date: Tue, 20 Mar 2018 22:05:11 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 2/2] dh key: get rid of stack array allocation
Message-ID: <20180321040511.GB18067@cisco>
References: <20180313042907.29598-1-tycho@tycho.ws>
 <20180313042907.29598-2-tycho@tycho.ws>
 <20180315022112.GB641@zzz.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315022112.GB641@zzz.localdomain>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Wed, Mar 14, 2018 at 07:21:12PM -0700, Eric Biggers wrote:
> On Mon, Mar 12, 2018 at 10:29:07PM -0600, Tycho Andersen wrote:
> > Similarly to the previous patch, we would like to get rid of stack
> > allocated arrays: https://lkml.org/lkml/2018/3/7/621
> > 
> > In this case, we can also use a malloc style approach to free the temporary
> > buffer, being careful to also use kzfree to free them (indeed, at least one
> > of these has a memzero_explicit, but it seems like maybe they both
> > should?).
> > 
> > Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> > CC: David Howells <dhowells@redhat.com>
> > CC: James Morris <jmorris@namei.org>
> > CC: "Serge E. Hallyn" <serge@hallyn.com>
> > ---
> >  security/keys/dh.c | 27 +++++++++++++++++++++------
> >  1 file changed, 21 insertions(+), 6 deletions(-)
> > 
> > diff --git a/security/keys/dh.c b/security/keys/dh.c
> > index d1ea9f325f94..f02261b24759 100644
> > --- a/security/keys/dh.c
> > +++ b/security/keys/dh.c
> > @@ -162,19 +162,27 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
> >  			goto err;
> >  
> >  		if (zlen && h) {
> > -			u8 tmpbuffer[h];
> > +			u8 *tmpbuffer;
> >  			size_t chunk = min_t(size_t, zlen, h);
> > -			memset(tmpbuffer, 0, chunk);
> > +
> > +			err = -ENOMEM;
> > +			tmpbuffer = kzalloc(chunk, GFP_KERNEL);
> > +			if (!tmpbuffer)
> > +				goto err;
> >  
> >  			do {
> >  				err = crypto_shash_update(desc, tmpbuffer,
> >  							  chunk);
> > -				if (err)
> > +				if (err) {
> > +					kzfree(tmpbuffer);
> >  					goto err;
> > +				}
> >  
> >  				zlen -= chunk;
> >  				chunk = min_t(size_t, zlen, h);
> >  			} while (zlen);
> > +
> > +			kzfree(tmpbuffer);
> >  		}
> 
> This is just hashing zeroes.  Why not use the zeroes at the end of the 'src'
> buffer which was allocated as 'outbuf' in __keyctl_dh_compute()?  It's already
> the right size.  It might even simplify the code a bit since
> crypto_shash_update() would no longer need to be in a loop.

Can you clarify what you mean by the "end" here? It looks like the end
is copied over with the user string just before it's passed into
keyctl_dh_compute_kdf().

In any case, I agree that it's dumb to do this allocation in a loop
now. What if instead we just do one big long allocation of zlen, hash
it, and then free it? This has the advantage that it's not allocated
two functions away from where it's used...

> >  
> >  		if (src && slen) {
> > @@ -184,13 +192,20 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
> >  		}
> >  
> >  		if (dlen < h) {
> > -			u8 tmpbuffer[h];
> > +			u8 *tmpbuffer;
> > +
> > +			err = -ENOMEM;
> > +			tmpbuffer = kzalloc(h, GFP_KERNEL);
> > +			if (!tmpbuffer)
> > +				goto err;
> >  
> >  			err = crypto_shash_final(desc, tmpbuffer);
> > -			if (err)
> > +			if (err) {
> > +				kzfree(tmpbuffer);
> >  				goto err;
> > +			}
> >  			memcpy(dst, tmpbuffer, dlen);
> > -			memzero_explicit(tmpbuffer, h);
> > +			kzfree(tmpbuffer);
> >  			return 0;
> >  		} else {
> >  			err = crypto_shash_final(desc, dst);
> > -- 
> 
> Why not instead round the allocated size of 'outbuf' in keyctl_dh_compute_kdf()
> up to the next 'crypto_shash_digestsize()'-boundary?  Then this temporary buffer
> wouldn't be needed at all.

Thanks, I've made this change (and split it out into a separate patch)
for v2.

Tycho
