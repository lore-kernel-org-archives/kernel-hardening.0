Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 22 Dec 2016 03:40:00 +0100
Message-ID: <CAHmME9qWXQ_SA6f5m9Aa0J5otNqesoCF=p+RAW53fv0K+bMH7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: George's crazy full state idea (Re: HalfSipHash Acceptable Usage)
To: Andy Lutomirski <luto@kernel.org>
Cc: George Spelvin <linux@sciencehorizons.net>, Ted Ts'o <tytso@mit.edu>, Andi Kleen <ak@linux.intel.com>, "David S. Miller" <davem@davemloft.net>, David Laight <David.Laight@aculab.com>, "D. J. Bernstein" <djb@cr.yp.to>, Eric Biggers <ebiggers3@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Tom Herbert <tom@herbertland.com>, Linus Torvalds <torvalds@linux-foundation.org>, Vegard Nossum <vegard.nossum@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Wed, Dec 21, 2016 at 5:13 PM, George Spelvin
>> After some thinking, I still like the "state-preserving" construct
>> that's equivalent to the current MD5 code.  Yes, we could just do
>> siphash(current_cpu || per_cpu_counter, global_key), but it's nice to
>> preserve a bit more.
>>
>> It requires library support from the SipHash code to return the full
>> SipHash state, but I hope that's a fair thing to ask for.

This is not a good idea. If I understand correctly, the idea here is
to just keep around SipHash's internal state variables, and chain them
over to the next call, sort of like how md5_transform with the current
code works on the same scratch space. There has been no security
analysis in the literature on this use of the primitive, and I have no
confidence that this is a secure use of the function. Unless somebody
can point me toward a paper I missed or a comment from a real
cryptographer about the specifics of SipHash, I think I'm right to
admonish against this dangerous road.

Let's talk about constructions. And let's only decide on a
construction that we're actually equipped to analyze. Let's definitely
not talk about making our own primitives, or retrofitting nice
primitive's internals into our own Frankenstein.

Alternatively, if I'm wrong, please send me an eprint/arXiv link to a
paper that discusses this use of SipHash.
