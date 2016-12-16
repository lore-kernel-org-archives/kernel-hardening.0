Reply-To: kernel-hardening@lists.openwall.com
Message-Id: <1481922923.2204853.821591377.2CD623CB@webmail.messagingengine.com>
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CAHmME9pz=syTiLXUsbXFyGdbGK6pxbnU+TVLDkbYiTa-9+sckQ@mail.gmail.com>
Date: Fri, 16 Dec 2016 22:15:23 +0100
In-Reply-To: <CAHmME9pz=syTiLXUsbXFyGdbGK6pxbnU+TVLDkbYiTa-9+sckQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v5 1/4] siphash: add cryptographically
 secure PRF
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, George Spelvin <linux@sciencehorizons.net>, Andi Kleen <ak@linux.intel.com>, David Miller <davem@davemloft.net>, David Laight <David.Laight@aculab.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, Eric Biggers <ebiggers3@gmail.com>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Netdev <netdev@vger.kernel.org>, Tom Herbert <tom@herbertland.com>, Linus Torvalds <torvalds@linux-foundation.org>, Vegard Nossum <vegard.nossum@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 16, 2016, at 22:01, Jason A. Donenfeld wrote:
> Yes, on x86-64. But on i386 chacha20 incurs nearly the same kind of
> slowdown as siphash, so I expect the comparison to be more or less
> equal. There's another thing I really didn't like about your chacha20
> approach which is that it uses the /dev/urandom pool, which means
> various things need to kick in in the background to refill this.
> Additionally, having to refill the buffered chacha output every 32 or
> so longs isn't nice. These things together make for inconsistent and
> hard to understand general operating system performance, because
> get_random_long is called at every process startup for ASLR. So, in
> the end, I believe there's another reason for going with the siphash
> approach: deterministic performance.

*Hust*, so from where do you generate your key for siphash if called
early from ASLR?

Bye,
Hannes
