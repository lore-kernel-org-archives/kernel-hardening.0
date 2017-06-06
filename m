MIME-Version: 1.0
In-Reply-To: <20170606172643.GC88445@gmail.com>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org> <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz> <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
 <CAHmME9rTpe4FM2+VSxZB48JDPCNTpSWzHx2DW1om7DW_1PvttQ@mail.gmail.com> <20170606172643.GC88445@gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 19:30:33 +0200
Message-ID: <CAHmME9q17quNY5vdoyT0FxzUK=uiFaiMXo5bY=iCxA=tWdCSUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Eric Biggers <ebiggers3@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 7:26 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> I agree that the use of ECB mode in big_key is broken, and thanks for trying to
> fix it!  I think using GCM is good, but please leave a very conspicuous comment
> where the nonce is being set to 0, noting that it's safe only because a unique
> key is used to encrypt every big_key *and* the big_keys are not updatable (via
> an .update method in the key_type), resulting in each GCM key being used for
> only a single encryption.

Good idea. I'll make a large comment about this.

>
> Also, I think you should send this to the keyrings mailing list and maintainer
> so it can be discussed and merged separately from your RNG changes.

Yea, that seems like a good idea. I'll separate things out right now.
