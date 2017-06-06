Date: Tue, 6 Jun 2017 10:26:43 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170606172643.GC88445@gmail.com>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
 <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz>
 <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
 <CAHmME9rTpe4FM2+VSxZB48JDPCNTpSWzHx2DW1om7DW_1PvttQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rTpe4FM2+VSxZB48JDPCNTpSWzHx2DW1om7DW_1PvttQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason,

On Tue, Jun 06, 2017 at 05:23:04PM +0200, Jason A. Donenfeld wrote:
> Hey again Eric,
> 
> One thing led to another and I wound up just rewriting all the crypto
> in big_keys.c. I'll include this for v4:
> 
> https://git.zx2c4.com/linux-dev/commit/?h=jd/rng-blocker&id=886ff283b9808aecb14aa8e397da8496a9635aed
> 
> Not only was the use of crypto/rng inappropriate, but the decision to
> go with aes-ecb is shocking. Seeing that this author had no other
> commits in the tree, and that all subsequent commits that mentioned
> his name were cleaning up his mess, I just went ahead and removed both
> the crypto/rng misusage and changed from aes-ecb to aes-gcm.
> 
> Anyway, I'll wait for some more reviews on v3, and then this can be
> reviewed for v4.
> 
> Regards,
> Jason

I agree that the use of ECB mode in big_key is broken, and thanks for trying to
fix it!  I think using GCM is good, but please leave a very conspicuous comment
where the nonce is being set to 0, noting that it's safe only because a unique
key is used to encrypt every big_key *and* the big_keys are not updatable (via
an .update method in the key_type), resulting in each GCM key being used for
only a single encryption.

Also, I think you should send this to the keyrings mailing list and maintainer
so it can be discussed and merged separately from your RNG changes.

Eric
