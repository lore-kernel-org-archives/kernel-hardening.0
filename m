Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 12 Dec 2016 22:44:09 +0100
Message-ID: <CAHmME9o3otY8oKW1TGDWM23j4yz3PVvZViuwmfJ+szpWbm2BfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable function
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

> I guess you could try to just remove the "if (left)" test entirely, if
> it is at least partly the mispredict. It should do the right thing
> even with a zero count, and it might schedule the code better. Code
> size _should_ be better with the byte mask model (which won't matter
> in the hot loop example, since it will all be cached, possibly even in
> the uop cache for really tight benchmark loops).

Originally I had just forgotten the `if (left)`, and had the same
sub-par benchmarks. In the v3 revision that I'm working on at the
moment, I'm using your dcache trick for cases 3,5,6,7 and
short-circuiting cases 1,2,4 to just directly access those bytes as
integers. For the 32-bit case, I do something similar, but built
inside of the duff's device. This should give optimal performance for
the most popular use cases, which involve hashing "some stuff" plus a
leftover u16 (port number?) or u32 (ipv4 addr?).

#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
       switch (left) {
       case 0: break;
       case 1: b |= data[0]; break;
       case 2: b |= get_unaligned_le16(data); break;
       case 4: b |= get_unaligned_le32(data); break;
       default:
               b |= le64_to_cpu(load_unaligned_zeropad(data) &
bytemask_from_count(left));
               break;
       }
#else
       switch (left) {
       case 7: b |= ((u64)data[6]) << 48;
       case 6: b |= ((u64)data[5]) << 40;
       case 5: b |= ((u64)data[4]) << 32;
       case 4: b |= get_unaligned_le32(data); break;
       case 3: b |= ((u64)data[2]) << 16;
       case 2: b |= get_unaligned_le16(data); break;
       case 1: b |= data[0];
       }
#endif

It seems like this might be best of all worlds?

Jason
