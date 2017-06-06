MIME-Version: 1.0
In-Reply-To: <20170606044404.GA3469@zzz>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org> <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 14:34:43 +0200
Message-ID: <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Tue, Jun 6, 2017 at 6:44 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> I don't think big_key even needs randomness at init time.  The 'big_key_rng'
> could just be removed and big_key_gen_enckey() changed to call
> get_random_bytes().  (Or get_random_bytes_wait(), I guess; it's only reachable
> via the keyring syscalls.)

That sounds good to me. I'll go ahead and make these changes, and will
add you to the Cc for the patch. You'll find the latest version in
here:
https://git.zx2c4.com/linux-dev/log/?h=jd/rng-blocker

> It's going to take a while to go through all 217 users of get_random_bytes()
> like this, though...  It's really a shame there's no way to guarantee good
> randomness at boot time.

Yes, I agree whole-heartedly.  A lot of people have proposals for
fixing the direct idea of entropy gathering, but for whatever reason,
Ted hasn't merged stuff. I think Stephan (CCd) rewrote big critical
sections of the RNG, called LRNG, and published a big paper for peer
review and did a lot of cool engineering, but for some reason this
hasn't been integrated. I look forward to movement on this front in
the future, if it ever happens. Would be great.

However, in lieu of that, I agree that playing whack a mole with all
call sites is mega arduous and error prone. In my original message to
Ted about this, I proposed instead a more global approach of
introducing an rng_init() to complement things like late_init() and
device_init() and such. The idea here would be two-fold:

- Modules that are built in would only be loaded as a callback to the
initialization of the RNG. An API for that already exists.
- Modules that are external would simply block userspace in
request_module until the RNG is initialized. This patch series adds
that kind of API.

If I understood correctly, Ted was worried that this might introduce
some headaches with module load ordering. However, IMHO, dealing with
the very few use cases of ordering issues is going to be far less
arduous than playing whack-a-mole with every call site. But, given the
fact that we still do need a blocking API (this patch series), I
decided to go with implementing this first, and then second attacking
the more difficult issue of adding rng_init().

So hopefully a combination of this patch series and the next one will
amount to something workable.

Long term, though, I think we need Stephan's work, in one form or
another, to be merged.

Jason
