MIME-Version: 1.0
In-Reply-To: <20170620060344.ngbnzg2mz5hvq4kw@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com> <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
 <20170620060344.ngbnzg2mz5hvq4kw@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 20 Jun 2017 10:14:29 +0200
Message-ID: <CAHmME9oHZz44uQ1tq=M=Vrxc5NY-2r4xFjbwge-Hp=U-cCEYfQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Ted,

On Tue, Jun 20, 2017 at 02:03:44AM -0400, Theodore Ts'o wrote:
> I actually had set up an earlier version of your patch for on Saturday
> while I was in Beijing.  (Like Linus, I'm attending the LinuxCon China
> conference Monday and Tuesday.)  I had even created the signed tag,
> I've since respun the commit to reflect your newer patch (see the
> random_for_linus_stable tag on random.git) and rebased the dev branch
> on top of that.  Please take a look and comment.

So it looks like you've gone with 4a072c71f49. If that looks good
(moving the lock, etc) to you, then great, we're done. If there are
still locking objections (are there?), then we'll need to revisit.

> but I didn't send the pull request to Linus because I was waiting to
> see about how discussions over the locking strategy and the spammy log
> messages on PowerPC was going to get resolved.
> The other open issue I want to resolve before sending a pull request
> this week is whether we want to change the default for
> CONFIG_WARN_UNSEEDED_RANDOM so that the answer is 'n'.

In the v1 of this patch many moons ago, it was just vanilla, default y,
but due to the spamminess, I thought folks would revolt. So I made a
change:

Specifically, I added `depends on DEBUG_KERNEL`. This means that these
useful warnings will only poke other kernel developers. This is probably
exactly what we want. If the various associated developers see a warning
coming from their particular subsystem, they'll be more motivated to
fix it. Ordinary users on distribution kernels shouldn't see the
warnings or the spam at all, since typically users aren't using
DEBUG_KERNEL.

Then, to make things _even less_ annoying to kernel developers, you
added a nice patch on top to squelch repeated messages.

So, I still think this current strategy is a good one, of default y, but
depends on DEBUG_KERNEL.

Regards,
Jason
