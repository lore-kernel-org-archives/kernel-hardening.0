MIME-Version: 1.0
In-Reply-To: <20170606174804.31124-14-Jason@zx2c4.com>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-14-Jason@zx2c4.com>
From: Jeffrey Walton <noloader@gmail.com>
Date: Thu, 8 Jun 2017 04:43:39 -0400
Message-ID: <CAH8yC8mauXh5_a1qLn23d16SLNMJEfb4D3Ceee3PoADvZk1rbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel uses unseeded randomness
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 1:48 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
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

Please forgive my ignorance... What do the last two sentence mean exactly?

If I am running a production Debian, Fedora or Ubuntu kernel, will a
messages be present if a violation occurs? A "violation" is a policy
violation, and I mean a generator is used before its operational.

Sunlight is the best disinfectant. At least one message should be
logged to ensure the issue is known. But its not clear to me if that's
what happens when trying to parse the last two sentences.

Jeff
