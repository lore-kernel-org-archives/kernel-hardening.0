Date: Mon, 5 Jun 2017 21:44:04 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170606044404.GA3469@zzz>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
 <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 05:56:20AM +0200, Jason A. Donenfeld wrote:
> Hey Ted,
> 
> On Tue, Jun 6, 2017 at 5:00 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > Note that crypto_rng_reset() is called by big_key_init() in
> > security/keys/big_key.c as a late_initcall().  So if we are on a
> > system where the crng doesn't get initialized until during the system
> > boot scripts, and big_key is compiled directly into the kernel, the
> > boot could end up deadlocking.
> >
> > There may be other instances of where crypto_rng_reset() is called by
> > an initcall, so big_key_init() may not be an exhaustive enumeration of
> > potential problems.  But this is an example of why the synchronous
> > API, although definitely much more convenient, can end up being a trap
> > for the unwary....
> 
> Thanks for pointing this out. I'll look more closely into it and see
> if I can figure out a good way of approaching this.

I don't think big_key even needs randomness at init time.  The 'big_key_rng'
could just be removed and big_key_gen_enckey() changed to call
get_random_bytes().  (Or get_random_bytes_wait(), I guess; it's only reachable
via the keyring syscalls.)

It's going to take a while to go through all 217 users of get_random_bytes()
like this, though...  It's really a shame there's no way to guarantee good
randomness at boot time.

Eric
