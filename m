MIME-Version: 1.0
In-Reply-To: <20170618154625.5qu3eduqjtgk5bal@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
 <871sqlpl63.fsf@concordia.ellerman.id.au> <1606799.lNpamfCTbW@tauon.chronox.de>
 <20170618154625.5qu3eduqjtgk5bal@thunk.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 18 Jun 2017 21:11:20 +0200
Message-ID: <CAHmME9oLau3HhirPE-B=z-BVv7fph7Ws=smzsa6_SZGxY__auA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel
 uses unseeded randomness
To: Theodore Ts'o <tytso@mit.edu>, =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>, kernel-hardening@lists.openwall.com, Michael Ellerman <mpe@ellerman.id.au>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 18, 2017 at 5:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> You are effectively proposing that there ought to be a middle range of
> security between prandom_32, get_random_u32/get_random_u64 and
> get_random_bytes().  I think that's going to lead to all sorts of
> complexity and bugs from people not understanding when they should use
> get_random_u32 vs get_random_bytes versus prandom_u32.  And then we'll
> end up needing to audit all of the callsites for get_random_u32() so
> they don't violate this new usage rule that you are proposing.

I agree with you wholeheartedly.

get_random_* provides the secure random numbers.
prandom_* provides the insecure random numbers.

Introducing some kind of middle ground will result in needless
complexity and inevitable bugs.
