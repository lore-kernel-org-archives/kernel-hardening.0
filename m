Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAHmME9qSW1U3dU+VjV8UBz=XOMfpbTkOCyrz74VnQTNcJW_FUw@mail.gmail.com>
References: <20161211204345.GA1558@kroah.com> <20161212034817.1773-1-Jason@zx2c4.com>
 <CA+55aFyfijNTvi0AN1kC4oWZqdGyoRD4WUVAf+kjFytVOE3kNw@mail.gmail.com> <CAHmME9qSW1U3dU+VjV8UBz=XOMfpbTkOCyrz74VnQTNcJW_FUw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Dec 2016 13:37:03 -0800
Message-ID: <CA+55aFymjmEPNx8ZwhxtiE=nPG_5gbkzUQhdRAwTareuNcV=tA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 11, 2016 at 9:48 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> I modified the test to hash data of size 0 through 7 repeatedly
> 100000000 times, and benchmarked that a few times on a Skylake laptop.
> The `load_unaligned_zeropad & bytemask_from_count` version was
> consistently 7% slower.
>
> I then modified it again to simply hash a 4 byte constant repeatedly
> 1000000000 times. The `load_unaligned_zeropad & bytemask_from_count`
> version was around 6% faster. I tried again with a 7 byte constant and
> got more or less a similar result.
>
> Then I tried with a 1 byte constant, and found that the
> `load_unaligned_zeropad & bytemask_from_count` version was slower.
>
> So, it would seem that between the `if (left)` and the `switch
> (left)`, there's the same number of branches.

Interesting.

For the dcache code (which is where that trick comes from), we used to
have a loop (rather than the duff's device thing), and it performed
badly due to the consistently badly predicted branch of the loop. But
I never compared it against the duff's device version.

I guess you could try to just remove the "if (left)" test entirely, if
it is at least partly the mispredict. It should do the right thing
even with a zero count, and it might schedule the code better. Code
size _should_ be better with the byte mask model (which won't matter
in the hot loop example, since it will all be cached, possibly even in
the uop cache for really tight benchmark loops).

             Linus
