Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20161212034817.1773-1-Jason@zx2c4.com>
References: <20161211204345.GA1558@kroah.com> <20161212034817.1773-1-Jason@zx2c4.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Dec 2016 20:01:36 -0800
Message-ID: <CA+55aFyfijNTvi0AN1kC4oWZqdGyoRD4WUVAf+kjFytVOE3kNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 11, 2016 at 7:48 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> +       switch (left) {
> +               case 7: b |= ((u64)data[6]) << 48;
> +               case 6: b |= ((u64)data[5]) << 40;
> +               case 5: b |= ((u64)data[4]) << 32;
> +               case 4: b |= ((u64)data[3]) << 24;
> +               case 3: b |= ((u64)data[2]) << 16;
> +               case 2: b |= ((u64)data[1]) <<  8;
> +               case 1: b |= ((u64)data[0]); break;
> +               case 0: break;
> +       }

The above is extremely inefficient. Considering that most kernel data
would be expected to be smallish, that matters (ie the usual benchmark
would not be about hashing megabytes of data, but instead millions of
hashes of small data).

I think this could be rewritten (at least for 64-bit architectures) as

    #ifdef CONFIG_DCACHE_WORD_ACCESS

        if (left)
                b |= le64_to_cpu(load_unaligned_zeropad(data) &
bytemask_from_count(left));

    #else

        .. do the duff's device thing with the switch() ..

    #endif

which should give you basically perfect code generation (ie a single
64-bit load and a byte mask).

Totally untested, just looking at the code and trying to make sense of it.

... and obviously, it requires an actual high-performance use-case to
make any difference.

                  Linus
