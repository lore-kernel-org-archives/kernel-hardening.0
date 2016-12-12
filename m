Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Dec 2016 21:42:29 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20161212054229.GA31382@zzz>
References: <20161211204345.GA1558@kroah.com>
 <20161212034817.1773-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161212034817.1773-1-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v2] siphash: add cryptographically secure hashtable
 function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, ak@linux.intel.com, Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 12, 2016 at 04:48:17AM +0100, Jason A. Donenfeld wrote:
>
> diff --git a/lib/Makefile b/lib/Makefile
> index 50144a3aeebd..71d398b04a74 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -22,7 +22,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 sha1.o chacha20.o md5.o irq_regs.o argv_split.o \
>  	 flex_proportions.o ratelimit.o show_mem.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> -	 earlycpio.o seq_buf.o nmi_backtrace.o nodemask.o win_minmax.o
> +	 earlycpio.o seq_buf.o siphash.o \
> +	 nmi_backtrace.o nodemask.o win_minmax.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> @@ -44,7 +45,7 @@ obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
>  obj-y += kstrtox.o
>  obj-$(CONFIG_TEST_BPF) += test_bpf.o
>  obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
> -obj-$(CONFIG_TEST_HASH) += test_hash.o
> +obj-$(CONFIG_TEST_HASH) += test_hash.o test_siphash.o

Maybe add to the help text for CONFIG_TEST_HASH that it now tests siphash too?

> +static inline u64 le64_to_cpuvp(const void *p)
> +{
> +	return le64_to_cpup(p);
> +}

This assumes the key and message buffers are aligned to __alignof__(u64).
Unless that's going to be a clearly documented requirement for callers, you
should use get_unaligned_le64() instead.  And you can pass a 'u8 *' directly to
get_unaligned_le64(), no need for a helper function.

> +	b = (v0 ^ v1) ^ (v2 ^ v3);
> +	return (__force u64)cpu_to_le64(b);
> +}

It makes sense for this to return a u64, but that means the cpu_to_le64() is
wrong, since u64 indicates CPU endianness.  It should just return 'b'.

> +++ b/lib/test_siphash.c
> @@ -0,0 +1,116 @@
> +/* Test cases for siphash.c
> + *
> + * Copyright (C) 2015-2016 Jason A. Donenfeld <Jason@zx2c4.com>
> + *
> + * This file is provided under a dual BSD/GPLv2 license.
> + *
> + * SipHash: a fast short-input PRF
> + * https://131002.net/siphash/
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/siphash.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +
> +static const u8 test_vectors[64][8] = {
> +	{ 0x31, 0x0e, 0x0e, 0xdd, 0x47, 0xdb, 0x6f, 0x72 },

Can you mention in a comment where the test vectors came from?

> +		if (memcmp(&out, test_vectors[i], 8)) {
> +			pr_info("self-test %u: FAIL\n", i + 1);
> +			ret = -EINVAL;
> +		}

If you make the output really be CPU-endian like I'm suggesting then this will
need to be something like:

	if (out != get_unaligned_le64(test_vectors[i])) {

Or else make the test vectors be an array of u64.

- Eric
