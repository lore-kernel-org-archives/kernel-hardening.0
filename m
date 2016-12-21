Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1482335804.8944.44.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20161221032829.3031.qmail@ns.sciencehorizons.net>
 <1482298164.8944.8.camel@edumazet-glaptop3.roam.corp.google.com>
 <CAHmME9oCfCwAq1qP09uAN6vvakh4wXDMHunsL9D7W_LDeN_OQQ@mail.gmail.com> <1482335804.8944.44.camel@edumazet-glaptop3.roam.corp.google.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 21 Dec 2016 17:33:29 +0100
Message-ID: <CAHmME9pBFbNt=dfBZiYvjUxqo3aLWb-6aD6V3+L1ujsmJA95+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: HalfSipHash Acceptable Usage
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: George Spelvin <linux@sciencehorizons.net>, Theodore Ts'o <tytso@mit.edu>, Andi Kleen <ak@linux.intel.com>, David Miller <davem@davemloft.net>, David Laight <David.Laight@aculab.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, Eric Biggers <ebiggers3@gmail.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Netdev <netdev@vger.kernel.org>, Tom Herbert <tom@herbertland.com>, Linus Torvalds <torvalds@linux-foundation.org>, Vegard Nossum <vegard.nossum@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

On Wed, Dec 21, 2016 at 4:56 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> That really was for 1024 bytes blocks, so pretty much useless for our
> discussion ?
>
> Reading your numbers last week, I thought SipHash was faster, but George
> numbers are giving the opposite impression.
>
> I do not have a P4 to make tests, so I only can trust you or George.

I'm not sure how George came up with those numbers, but the ones I
sent are output from that benchmark function in the last email. I'd be
interested in learning this too.

As mentioned in the last email, it looks like potential 32-bit issues
are really just specific to old Intel chips. Other 32-bit
architectures do fine. So, for new kernels, even if somehow there is a
tiny performance regression (though I couldn't see one) on old
architectures, I really doubt it will affect anybody in practice.

Jason
