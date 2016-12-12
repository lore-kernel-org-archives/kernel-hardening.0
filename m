Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161212054229.GA31382@zzz>
References: <20161211204345.GA1558@kroah.com> <20161212034817.1773-1-Jason@zx2c4.com>
 <20161212054229.GA31382@zzz>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 12 Dec 2016 22:17:13 +0100
Message-ID: <CAHmME9qj29LxYWaJbRAB6HbnJQXge8fjuH1RnhOnYuRnoJAQRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable function
To: Eric Biggers <ebiggers3@gmail.com>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Eric,

Lots of good points; thanks for the review. Responses are inline below.

On Mon, Dec 12, 2016 at 6:42 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> Maybe add to the help text for CONFIG_TEST_HASH that it now tests siphash too?

Good call. Will do.

> This assumes the key and message buffers are aligned to __alignof__(u64).
> Unless that's going to be a clearly documented requirement for callers, you
> should use get_unaligned_le64() instead.  And you can pass a 'u8 *' directly to
> get_unaligned_le64(), no need for a helper function.

I had thought about that briefly, but just sort of figured most people
were passing in aligned variables... but that's a pretty bad
assumption to make especially for 64-bit alignment. I'll switch to
using the get_unaligned functions.

[As a side note, I wonder if crypto/chacha20_generic.c should be using
the unaligned functions instead too, at least for the iv reading...]

> It makes sense for this to return a u64, but that means the cpu_to_le64() is
> wrong, since u64 indicates CPU endianness.  It should just return 'b'.

At first I was very opposed to making this change, since by returning
a value with an explicit byte order, you can cast to u8 and have
uniform indexed byte access across platforms. But of course this
doesn't make any sense, since it's returning a u64, and it makes all
other bitwise operations non-uniform anyway.  I checked with JP
(co-creator of siphash, CC'd) and he confirmed your suspicion that it
was just to make the test vector comparison easier and for some
byte-wise uniformity, but that it's not strictly necessary. So, I've
removed that last cpu_to_le64, and I've also refactored those test
vectors to be written as ULL literals, so that a simple == integer
comparison will work across platforms.

> Can you mention in a comment where the test vectors came from?

Sure, will do.


> If you make the output really be CPU-endian like I'm suggesting then this will
> need to be something like:
>
>         if (out != get_unaligned_le64(test_vectors[i])) {
>
> Or else make the test vectors be an array of u64.

Yep, I wound up doing that.

Thanks Eric! Will submit a v3 soon if nobody else has comments.

Jason
