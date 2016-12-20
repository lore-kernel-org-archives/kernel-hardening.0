Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Dec 2016 16:36:36 -0500
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20161220213636.tiqj2o4uupasr4aj@thunk.org>
References: <CAHmME9rPmH=wP_eHYopt8ZPG9TSN7bos3fGOuqKL2HjQW-2SWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rPmH=wP_eHYopt8ZPG9TSN7bos3fGOuqKL2HjQW-2SWA@mail.gmail.com>
Subject: [kernel-hardening] Re: HalfSipHash Acceptable Usage
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, David Laight <David.Laight@aculab.com>, David Miller <davem@davemloft.net>, Andi Kleen <ak@linux.intel.com>, George Spelvin <linux@sciencehorizons.net>, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@amacapital.net>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Tom Herbert <tom@herbertland.com>, Vegard Nossum <vegard.nossum@gmail.com>, Netdev <netdev@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 19, 2016 at 06:32:44PM +0100, Jason A. Donenfeld wrote:
> 1) Anything that requires actual long-term security will use
> SipHash2-4, with the 64-bit output and the 128-bit key. This includes
> things like TCP sequence numbers. This seems pretty uncontroversial to
> me. Seem okay to you?

Um, why do TCP sequence numbers need long-term security?  So long as
you rekey every 5 minutes or so, TCP sequence numbers don't need any
more security than that, since even if you break the key used to
generate initial sequence numbers seven a minute or two later, any
pending TCP connections will have timed out long before.

See the security analysis done in RFC 6528[1], where among other
things, it points out why MD5 is acceptable with periodic rekeying,
although there is the concern that this could break certain hueristics
used when establishing new connections during the TIME-WAIT state.

[1] https://tools.ietf.org/html/rfc6528

						- Ted
