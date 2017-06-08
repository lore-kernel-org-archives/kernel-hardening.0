MIME-Version: 1.0
In-Reply-To: <20170607235835.jyblbocmkdpe7i2p@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-2-Jason@zx2c4.com>
 <20170607235835.jyblbocmkdpe7i2p@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Jun 2017 02:52:26 +0200
Message-ID: <CAHmME9qP+_3chw0z1_j_QrRWdFYOQfM_0e8hxPFY21gExzUpKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 01/13] random: invalidate batched entropy after crng init
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 8, 2017 at 1:58 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Thanks, applied.  This will be on the for_stable that I will be
> sending to Linus sometime during 4.12-rcX.

I think you might have just missed the kbuild test robot complaining
about an incorrect compiler warning, when using an ancient gcc for the
sh platform. I fixed that bug in v5, which I posted about an hour
ago. The only change was a single commit, so you can just cherry-pick
that as you wish:

https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/patch/?id=2f390fd961d1f97738d7af4f4797542e05f4607e

Other than that one commit change, it was the same.

Or, if it's easier, the tag for-random-4.12 in
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git is for you.
