From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Date: Sun, 18 Jun 2017 19:55:04 +0200
Message-ID: <2812305.zGuAXT15AM@positron.chronox.de>
In-Reply-To: <20170618154625.5qu3eduqjtgk5bal@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <1606799.lNpamfCTbW@tauon.chronox.de> <20170618154625.5qu3eduqjtgk5bal@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel uses unseeded randomness
To: Theodore Ts'o <tytso@mit.edu>
Cc: kernel-hardening@lists.openwall.com, Michael Ellerman <mpe@ellerman.id.au>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Am Sonntag, 18. Juni 2017, 17:46:25 CEST schrieb Theodore Ts'o:

Hi Theodore,

> > IMHO, users using the get_random_u64 or get_random_u32 are use cases that
> > do not require a fully seeded DRNG thus do not need a cryptographically
> > strong random number. Hence, I would think that the logging should be
> > removed from get_random_u32/u64.
> 
> You are effectively proposing that there ought to be a middle range of
> security between prandom_32, get_random_u32/get_random_u64 and
> get_random_bytes().  I think that's going to lead to all sorts of
> complexity and bugs from people not understanding when they should use
> get_random_u32 vs get_random_bytes versus prandom_u32.  And then we'll
> end up needing to audit all of the callsites for get_random_u32() so
> they don't violate this new usage rule that you are proposing.

I only proposed to get rid of the log messages indicating a non-seeded DRNG.

But you bring up an interesting point: if it is true you say that it is hard 
for people to use differnent types of APIs regarding entropy and random 
numbers right (which I would concur with), and considering that you imply that 
get_random_bytes, get_random_u32 and get_random_u64 have the same security 
strength, why do we have these three APIs to begin with? The get_random_bytes 
API would then be more than enough.

Ciao
Stephan
