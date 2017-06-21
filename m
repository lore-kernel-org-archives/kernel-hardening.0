From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <20170621000300.11646-1-Jason@zx2c4.com>
References: <CAHmME9qvPL+vdY16SgV2VzuDDyM4r+hkYy8yGG3LJaa-3igxfA@mail.gmail.com> <20170621000300.11646-1-Jason@zx2c4.com>
Date: Wed, 21 Jun 2017 16:06:49 +1000
Message-ID: <87k245ub5y.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH] random: warn when kernel uses unseeded randomness
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>"Jason A. Donenfeld" <Jason@zx2c4.com>, Jeffrey Walton <noloader@gmail.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> This enables an important dmesg notification about when drivers have
> used the crng without it being seeded first. Prior, these errors would
> occur silently, and so there hasn't been a great way of diagnosing these
> types of bugs for obscure setups. By adding this as a config option, we
> can leave it on by default, so that we learn where these issues happen,
> in the field, will still allowing some people to turn it off, if they
> really know what they're doing and do not want the log entries.
>
> However, we don't leave it _completely_ by default. An earlier version
> of this patch simply had `default y`. I'd really love that, but it turns
> out, this problem with unseeded randomness being used is really quite
> present and is going to take a long time to fix. Thus, as a compromise
> between log-messages-for-all and nobody-knows, this is `default y`,
> except it is also `depends on DEBUG_KERNEL`. This will ensure that the
> curious see the messages while others don't have to.

All the distro kernels I'm aware of have DEBUG_KERNEL=y.

Where all includes at least RHEL, SLES, Fedora, Ubuntu & Debian.

So it's still essentially default y.

Emitting *one* warning by default would be reasonable. That gives users
who are interested something to chase, they can then turn on the option
to get the full story.

Filling the dmesg buffer with repeated warnings is really not helpful.

cheers
