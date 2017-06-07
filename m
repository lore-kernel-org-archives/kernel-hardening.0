Date: Wed, 7 Jun 2017 19:58:35 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170607235835.jyblbocmkdpe7i2p@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-2-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v4 01/13] random: invalidate batched entropy after crng
 init
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:47:52PM +0200, Jason A. Donenfeld wrote:
> It's possible that get_random_{u32,u64} is used before the crng has
> initialized, in which case, its output might not be cryptographically
> secure. For this problem, directly, this patch set is introducing the
> *_wait variety of functions, but even with that, there's a subtle issue:
> what happens to our batched entropy that was generated before
> initialization. Prior to this commit, it'd stick around, supplying bad
> numbers. After this commit, we force the entropy to be re-extracted
> after each phase of the crng has initialized.
> 
> In order to avoid a race condition with the position counter, we
> introduce a simple rwlock for this invalidation. Since it's only during
> this awkward transition period, after things are all set up, we stop
> using it, so that it doesn't have an impact on performance.
> 
> This should probably be backported to 4.11.
> 
> (Also: adding my copyright to the top. With the patch series from
> January, this patch, and then the ones that come after, I think there's
> a relevant amount of code in here to add my name to the top.)
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, applied.  This will be on the for_stable that I will be
sending to Linus sometime during 4.12-rcX.

					- Ted
