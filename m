Date: Tue, 26 Mar 2019 18:38:00 +0100
From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v9 12/19] zinc: BLAKE2s generic C implementation
 and selftest
Message-ID: <20190326173759.GA607@zzz.localdomain>
References: <20190322071122.6677-1-Jason@zx2c4.com>
 <20190322071122.6677-13-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322071122.6677-13-Jason@zx2c4.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Samuel Neves <sneves@dei.uc.pt>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Andy Lutomirski <luto@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jason, a few comments on this patch:

On Fri, Mar 22, 2019 at 01:11:15AM -0600, Jason A. Donenfeld wrote:
> The C implementation was originally based on Samuel Neves' public
> domain reference implementation but has since been heavily modified
> for the kernel. We're able to do compile-time optimizations by moving
> some scaffolding around the final function into the header file.
> 
> Information: https://blake2.net/
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
> Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: kernel-hardening@lists.openwall.com
> Cc: linux-crypto@vger.kernel.org
> ---
>  include/zinc/blake2s.h      |   56 +
>  lib/zinc/Kconfig            |    3 +
>  lib/zinc/Makefile           |    3 +
>  lib/zinc/blake2s/blake2s.c  |  295 +++++
>  lib/zinc/selftest/blake2s.c | 2090 +++++++++++++++++++++++++++++++++++
>  5 files changed, 2447 insertions(+)
>  create mode 100644 include/zinc/blake2s.h
>  create mode 100644 lib/zinc/blake2s/blake2s.c
>  create mode 100644 lib/zinc/selftest/blake2s.c
> 
> diff --git a/include/zinc/blake2s.h b/include/zinc/blake2s.h
> new file mode 100644
> index 000000000000..5f1a1aeaf129
> --- /dev/null
> +++ b/include/zinc/blake2s.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#ifndef _ZINC_BLAKE2S_H
> +#define _ZINC_BLAKE2S_H
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <asm/bug.h>
> +
> +enum blake2s_lengths {
> +	BLAKE2S_BLOCK_SIZE = 64,
> +	BLAKE2S_HASH_SIZE = 32,
> +	BLAKE2S_KEY_SIZE = 32

Perhaps call the latter two BLAKE2S_MAX_HASH_SIZE and BLAKE2S_MAX_KEY_SIZE,
since lower values can be selected too?

> +};
> +
> +struct blake2s_state {
> +	u32 h[8];
> +	u32 t[2];
> +	u32 f[2];
> +	u8 buf[BLAKE2S_BLOCK_SIZE];
> +	size_t buflen;
> +	u8 last_node;
> +};

Since this API doesn't actually support any of BLAKE2's tree hashing modes, I
think 'last_node' should be removed from this struct for now.  It's never set.

> +
> +void blake2s_init(struct blake2s_state *state, const size_t outlen);
> +void blake2s_init_key(struct blake2s_state *state, const size_t outlen,
> +		      const void *key, const size_t keylen);
> +void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen);
> +void blake2s_final(struct blake2s_state *state, u8 *out, const size_t outlen);

Since the caller must pass the same 'outlen' into blake2s_init() and
blake2s_final(), perhaps that should be verified by the DEBUG checks?  It would
be easy for someone to get this wrong.  Or remove the outlen argument from
blake2s_final(), instead using the saved length from blake2s_init()?

> diff --git a/lib/zinc/blake2s/blake2s.c b/lib/zinc/blake2s/blake2s.c
> new file mode 100644
> index 000000000000..c817954e6bcd
> --- /dev/null
> +++ b/lib/zinc/blake2s/blake2s.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0 OR MIT
> +/*
> + * Copyright (C) 2012 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.

If Samuel's reference implementation is "public domain" as you stated in the
commit message, why is this copyright statement from 2012 here?
Public domain == not copyrighted.

> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + *
> + * This is an implementation of the BLAKE2s hash and PRF functions.
> + *
> + * Information: https://blake2.net/
> + *
> + */
> +
> +#include <zinc/blake2s.h>
> +#include "../selftest/run.h"
> +
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/bug.h>
> +#include <asm/unaligned.h>
> +
> +typedef union {
> +	struct {
> +		u8 digest_length;
> +		u8 key_length;
> +		u8 fanout;
> +		u8 depth;
> +		u32 leaf_length;
> +		u32 node_offset;
> +		u16 xof_length;

Technically the leaf_length, node_offset, and xof_length fields should be
__le32, __le32, and __le16 respectively.

> +void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
> +{
> +	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
> +
> +	if (unlikely(!inlen))
> +		return;
> +	if (inlen > fill) {
> +		memcpy(state->buf + state->buflen, in, fill);
> +		blake2s_compress(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
> +		state->buflen = 0;
> +		in += fill;
> +		inlen -= fill;
> +	}
> +	if (inlen > BLAKE2S_BLOCK_SIZE) {
> +		const size_t nblocks =
> +			(inlen + BLAKE2S_BLOCK_SIZE - 1) / BLAKE2S_BLOCK_SIZE;

This can be written as:

		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);

> +
> +static int __init mod_init(void)
> +{
> +	if (!nosimd)
> +		blake2s_fpu_init();
> +	if (!selftest_run("blake2s", blake2s_selftest, blake2s_nobs,
> +			  ARRAY_SIZE(blake2s_nobs)))
> +		return -ENOTRECOVERABLE;
> +	return 0;
> +}
> +
> +static void __exit mod_exit(void)
> +{
> +}
> +
> +module_param(nosimd, bool, 0);
> +module_init(mod_init);
> +module_exit(mod_exit);
> +MODULE_LICENSE("GPL v2");

The MODULE_LICENSE() doesn't match the SPDX license tag.  Intentional?

> +MODULE_DESCRIPTION("BLAKE2s hash function");
> +MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
> diff --git a/lib/zinc/selftest/blake2s.c b/lib/zinc/selftest/blake2s.c
> new file mode 100644
> index 000000000000..1b5c210dc7a8
> --- /dev/null
> +++ b/lib/zinc/selftest/blake2s.c
> @@ -0,0 +1,2090 @@
> +// SPDX-License-Identifier: GPL-2.0 OR MIT
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +static const u8 blake2s_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
[snip]
> +};
> +
> +static const u8 blake2s_keyed_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
[snip]
> +};

There should be a comment mentioning where these test vectors came from.  Are
they from a published source?  Or did you use a different implementation of
BLAKE2s to generate them?

> +
> +static bool __init blake2s_selftest(void)
> +{
> +	u8 key[BLAKE2S_KEY_SIZE];
> +	u8 buf[ARRAY_SIZE(blake2s_testvecs)];
> +	u8 hash[BLAKE2S_HASH_SIZE];
> +	size_t i;
> +	bool success = true;
> +
> +	for (i = 0; i < BLAKE2S_KEY_SIZE; ++i)
> +		key[i] = (u8)i;
> +
> +	for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i)
> +		buf[i] = (u8)i;
> +
> +	for (i = 0; i < ARRAY_SIZE(blake2s_keyed_testvecs); ++i) {
> +		blake2s(hash, buf, key, BLAKE2S_HASH_SIZE, i, BLAKE2S_KEY_SIZE);
> +		if (memcmp(hash, blake2s_keyed_testvecs[i], BLAKE2S_HASH_SIZE)) {
> +			pr_err("blake2s keyed self-test %zu: FAIL\n", i + 1);
> +			success = false;
> +		}
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i) {
> +		blake2s(hash, buf, NULL, BLAKE2S_HASH_SIZE, i, 0);
> +		if (memcmp(hash, blake2s_testvecs[i], BLAKE2S_HASH_SIZE)) {
> +			pr_err("blake2s unkeyed self-test %zu: FAIL\n", i + i);
> +			success = false;
> +		}
> +	}
> +	return success;
> +}

This tests here miss a lot of cases.  I can break the implementation in some
pretty major ways and it still passes the tests.

We'll get better test coverage of this via testmgr once this is exposed via the
"regular" crypto API.  E.g. the latest testmgr will automatically test multiple
update() calls, and buffers with various alignments.  If we also make your new
'simd_get()' function call crypto_simd_usable() rather than may_use_simd()
directly, then testmgr will also cover the case where some update() are done in
a SIMD-usable context and some aren't.

However, any functionality that won't be exposed by the regular crypto API still
needs to be tested here, e.g. the following which aren't currently tested:

	- blake2s_hmac()
	- Key and digest lengths other than the default

- Eric
