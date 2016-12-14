Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAHmME9oMaQOhzJbNKh8GN759iJngeRdXt3naOnFhY9mD6t5Kxg@mail.gmail.com>
References: <20161214035927.30004-1-Jason@zx2c4.com> <20161214184605.24006-1-Jason@zx2c4.com>
 <CALx6S35UgTyqkYUjS5gYFH4HnjW974WQ_JiDXxgb9rZ7gnY52Q@mail.gmail.com> <CAHmME9oMaQOhzJbNKh8GN759iJngeRdXt3naOnFhY9mD6t5Kxg@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 14 Dec 2016 21:55:51 +0100
Message-ID: <CAHmME9pR3tD2zknKsYaFaTJm_3aBBOA6c174hypm6S-q9wp5nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 1/3] siphash: add cryptographically secure hashtable function
To: Tom Herbert <tom@herbertland.com>
Cc: Netdev <netdev@vger.kernel.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, David Laight <David.Laight@aculab.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Tom,

Just following up on what I mentioned in my last email...

On Wed, Dec 14, 2016 at 8:35 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> I think your suggestion for (2) will contribute to further
> optimizations for (1). In v2, I had another patch in there adding
> siphash_1word, siphash_2words, etc, like jhash, but I implemented it
> by taking u32 variables and then just concatenating these into a
> buffer and passing them to the main siphash function. I removed it
> from v3 because I thought that these kind of missed the whole point.
> In particular:
>
> a) siphash24_1word, siphash24_2words, siphash24_3words, etc should
> take u64, not u32, since that's what siphash operates on natively

I implemented these here:
https://git.zx2c4.com/linux-dev/commit/?h=siphash&id=4652b6f3643bdba217e2194d89661348bbac48a0

This will be part of the next version of the series I submit. It's not
immediately clear that using it is strictly faster than the struct
trick though. However, I'm not yet sure why this would be.

Jason
