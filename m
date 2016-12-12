Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAHmME9o3otY8oKW1TGDWM23j4yz3PVvZViuwmfJ+szpWbm2BfA@mail.gmail.com>
References: <CAHmME9o3otY8oKW1TGDWM23j4yz3PVvZViuwmfJ+szpWbm2BfA@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 12 Dec 2016 22:57:14 +0100
Message-ID: <CAHmME9p=8dz+hjcZsboNo+s8u=38UTQKXN+YcdR0ifwJAbQ_GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable function
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 10:44 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> #if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
>        switch (left) {
>        case 0: break;
>        case 1: b |= data[0]; break;
>        case 2: b |= get_unaligned_le16(data); break;
>        case 4: b |= get_unaligned_le32(data); break;
>        default:
>                b |= le64_to_cpu(load_unaligned_zeropad(data) &
> bytemask_from_count(left));
>                break;
>        }
> #else
>        switch (left) {
>        case 7: b |= ((u64)data[6]) << 48;
>        case 6: b |= ((u64)data[5]) << 40;
>        case 5: b |= ((u64)data[4]) << 32;
>        case 4: b |= get_unaligned_le32(data); break;
>        case 3: b |= ((u64)data[2]) << 16;
>        case 2: b |= get_unaligned_le16(data); break;
>        case 1: b |= data[0];
>        }
> #endif

As it turns out, perhaps unsurprisingly, the code generation here is
really not nice, resulting in many branches instead of a computed
jump. I'll submit v3 with just a branch-less load_unaligned_zeropad
for the 64-bit/dcache case and the duff's device for the other case.
