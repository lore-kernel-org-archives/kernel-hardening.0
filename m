Date: Tue, 20 Jun 2017 02:03:44 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170620060344.ngbnzg2mz5hvq4kw@thunk.org>
References: <20170614192838.3jz4sxpcuhxygx4z@breakpoint.cc>
 <20170614224526.29076-1-Jason@zx2c4.com>
 <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rv3EjOVF4LhYZ0VS2LYKjDr_-TxzNHvyE_mKZ_UX0+eA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] random: silence compiler warnings and fix race
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 19, 2017 at 10:57:18PM +0200, Jason A. Donenfeld wrote:
> 
> With rc6 already released and rc7 coming up, I'd really appreciate you
> stepping in here and either ACKing the above commit, or giving your
> two cents about it in case I need to roll something different.

I actually had set up an earlier version of your patch for on Saturday
while I was in Beijing.  (Like Linus, I'm attending the LinuxCon China
conference Monday and Tuesday.)  I had even created the signed tag,
but I didn't send the pull request to Linus because I was waiting to
see about how discussions over the locking strategy and the spammy log
messages on PowerPC was going to get resolved.

I've since respun the commit to reflect your newer patch (see the
random_for_linus_stable tag on random.git) and rebased the dev branch
on top of that.  Please take a look and comment.

The other open issue I want to resolve before sending a pull request
this week is whether we want to change the default for
CONFIG_WARN_UNSEEDED_RANDOM so that the answer is 'n'.  It *is* spammy
for PowerPC, because they aren't getting their CRNG initialized
quickly enough, so several userspace processes are getting
fork/exec'ed with an uninitialized CRNG.  That being said, it is a
valid warning because it means that the initial stack canary for the
first couple of PowerPC processes are being created without a fully
initialized CRNG, which may mean that an attacker might be able to
circumvent the stack canary on the first couple of processes.  So that
could potentially be a real security issue on Power.  OTOH, most Power
users aren't going to be able to do anything about the fact the stack
canaries of the system daemons started during early boot don't have
strong randomness, so perhaps we should disable the warning by
default.

Opinions?

						- Ted
