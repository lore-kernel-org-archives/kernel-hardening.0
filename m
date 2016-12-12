Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyfijNTvi0AN1kC4oWZqdGyoRD4WUVAf+kjFytVOE3kNw@mail.gmail.com>
References: <20161211204345.GA1558@kroah.com> <20161212034817.1773-1-Jason@zx2c4.com>
 <CA+55aFyfijNTvi0AN1kC4oWZqdGyoRD4WUVAf+kjFytVOE3kNw@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 12 Dec 2016 06:48:27 +0100
Message-ID: <CAHmME9qSW1U3dU+VjV8UBz=XOMfpbTkOCyrz74VnQTNcJW_FUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable function
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Linus,

On Mon, Dec 12, 2016 at 5:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> The above is extremely inefficient. Considering that most kernel data
> would be expected to be smallish, that matters (ie the usual benchmark
> would not be about hashing megabytes of data, but instead millions of
> hashes of small data).
>
> I think this could be rewritten (at least for 64-bit architectures) as
>
>     #ifdef CONFIG_DCACHE_WORD_ACCESS
>
>         if (left)
>                 b |= le64_to_cpu(load_unaligned_zeropad(data) &
> bytemask_from_count(left));
>
>     #else
>
>         .. do the duff's device thing with the switch() ..
>
>     #endif
>
> which should give you basically perfect code generation (ie a single
> 64-bit load and a byte mask).

I modified the test to hash data of size 0 through 7 repeatedly
100000000 times, and benchmarked that a few times on a Skylake laptop.
The `load_unaligned_zeropad & bytemask_from_count` version was
consistently 7% slower.

I then modified it again to simply hash a 4 byte constant repeatedly
1000000000 times. The `load_unaligned_zeropad & bytemask_from_count`
version was around 6% faster. I tried again with a 7 byte constant and
got more or less a similar result.

Then I tried with a 1 byte constant, and found that the
`load_unaligned_zeropad & bytemask_from_count` version was slower.

So, it would seem that between the `if (left)` and the `switch
(left)`, there's the same number of branches. But for small values of
`left`, the duff's device just has simpler arithmetic, whereas for
large values of `left`, the `load_unaligned_zeropad` prevails. If
micro-optimization is really appealing, one could imagine a hybrid of
the two:

    switch (left) {
    case 7:
    case 6:
    case 5:
    case 4:
        b |= le64_to_cpu(load_unaligned_zeropad(data) &
bytemask_from_count(left));
        break;
    case 3: b |= ((u64)data[2]) << 16;
    case 2: b |= ((u64)data[1]) <<  8;
    case 1: b |= ((u64)data[0]); break;
    case 0: break;
    }

But I'm not sure this complication is worth it, and it might be more
likely that the left-over size is 4 bytes most of the time, so we
should just use your trick on platforms that support it.

Jason
