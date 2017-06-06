MIME-Version: 1.0
In-Reply-To: <20170606030004.4go6btmobrsmqiwz@thunk.org>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 05:56:20 +0200
Message-ID: <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that the RNG is ready before using
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Ted,

On Tue, Jun 6, 2017 at 5:00 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Note that crypto_rng_reset() is called by big_key_init() in
> security/keys/big_key.c as a late_initcall().  So if we are on a
> system where the crng doesn't get initialized until during the system
> boot scripts, and big_key is compiled directly into the kernel, the
> boot could end up deadlocking.
>
> There may be other instances of where crypto_rng_reset() is called by
> an initcall, so big_key_init() may not be an exhaustive enumeration of
> potential problems.  But this is an example of why the synchronous
> API, although definitely much more convenient, can end up being a trap
> for the unwary....

Thanks for pointing this out. I'll look more closely into it and see
if I can figure out a good way of approaching this.

Indeed you're right -- that we have to be really quite careful every
time we use the synchronous API. For this reason, I separated things
out into the wait_for_random_bytes and then the wrapper around
wait_for_random_bytes+get_random_bytes of get_random_bytes_wait. The
idea here would be that drivers could place a single
wait_for_random_bytes at some userspace entry point -- a configuration
ioctl, for example -- and then try to ensure that all calls to
get_random_bytes are ordered _after_ that wait_for_random_bytes call.
While this pattern doesn't fix all cases of unseeded get_random_bytes
calls -- we'll need to do some module loading order cleverness for
that, as we discussed in the other thread -- I think this pattern will
fix an acceptable amount of call sites, as seen here in this patchset,
that it makes it worthwhile. Having it, too, I think would encourage
other new drivers to think about when their calls to get_random_bytes
happens, and if it's possible for them to defer it until after a
userspace-blocking call to wait_for_random_bytes.

Anyway, I'll look into and fix up the problem you mentioned. Looking
forward to your feedback on the other patches here.

Regards,
Jason
