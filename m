Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 09:55:00 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128085500.djlm5rlbhjlpfj4i@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 02/12] array_idx: sanitize speculative array
 de-references
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, Cyril Novikov <cnovikov@lynx.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Firstly, I only got a few patches of this series so I couldn't review all of them 
- please Cc: me to all future Meltdown and Spectre related patches!

* Dan Williams <dan.j.williams@intel.com> wrote:

> 'array_idx' is proposed as a generic mechanism to mitigate against
> Spectre-variant-1 attacks, i.e. an attack that bypasses boundary checks
> via speculative execution). The 'array_idx' implementation is expected
> to be safe for current generation cpus across multiple architectures
> (ARM, x86).

nit: Stray closing parenthesis

s/cpus/CPUs

> Based on an original implementation by Linus Torvalds, tweaked to remove
> speculative flows by Alexei Starovoitov, and tweaked again by Linus to
> introduce an x86 assembly implementation for the mask generation.
> 
> Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
> Co-developed-by: Alexei Starovoitov <ast@kernel.org>
> Suggested-by: Cyril Novikov <cnovikov@lynx.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/nospec.h |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100644 include/linux/nospec.h
> 
> diff --git a/include/linux/nospec.h b/include/linux/nospec.h
> new file mode 100644
> index 000000000000..f59f81889ba3
> --- /dev/null
> +++ b/include/linux/nospec.h
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright(c) 2018 Intel Corporation. All rights reserved.

Given the close similarity of Linus's array_access() prototype pseudocode there 
should probably also be:

    Copyright (C) 2018 Linus Torvalds

in that file?

> +
> +#ifndef __NOSPEC_H__
> +#define __NOSPEC_H__
> +
> +/*
> + * When idx is out of bounds (idx >= sz), the sign bit will be set.
> + * Extend the sign bit to all bits and invert, giving a result of zero
> + * for an out of bounds idx, or ~0UL if within bounds [0, sz).
> + */
> +#ifndef array_idx_mask
> +static inline unsigned long array_idx_mask(unsigned long idx, unsigned long sz)
> +{
> +	/*
> +	 * Warn developers about inappropriate array_idx usage.
> +	 *
> +	 * Even if the cpu speculates past the WARN_ONCE branch, the

s/cpu/CPU

> +	 * sign bit of idx is taken into account when generating the
> +	 * mask.
> +	 *
> +	 * This warning is compiled out when the compiler can infer that
> +	 * idx and sz are less than LONG_MAX.

Please use 'idx' and 'sz' in quotes, to make sure they stand out more in free 
flowing comment text. Also please use '()' to denote functions/methods.

I.e. something like:

	 * Warn developers about inappropriate array_idx() usage.
	 *
	 * Even if the CPU speculates past the WARN_ONCE() branch, the
	 * sign bit of 'idx' is taken into account when generating the
	 * mask.
	 *
	 * This warning is compiled out when the compiler can infer that
	 * 'idx' and 'sz' are less than LONG_MAX.

That's just one example - please apply it to all comments consistently.

> +	 */
> +	if (WARN_ONCE(idx > LONG_MAX || sz > LONG_MAX,
> +			"array_idx limited to range of [0, LONG_MAX]\n"))

Same in user facing messages:

			"array_idx() limited to range of [0, LONG_MAX]\n"))

> + * For a code sequence like:
> + *
> + *     if (idx < sz) {
> + *         idx = array_idx(idx, sz);
> + *         val = array[idx];
> + *     }
> + *
> + * ...if the cpu speculates past the bounds check then array_idx() will
> + * clamp the index within the range of [0, sz).

s/cpu/CPU

> + */
> +#define array_idx(idx, sz)						\
> +({									\
> +	typeof(idx) _i = (idx);						\
> +	typeof(sz) _s = (sz);						\
> +	unsigned long _mask = array_idx_mask(_i, _s);			\
> +									\
> +	BUILD_BUG_ON(sizeof(_i) > sizeof(long));			\
> +	BUILD_BUG_ON(sizeof(_s) > sizeof(long));			\
> +									\
> +	_i &= _mask;							\
> +	_i;								\
> +})
> +#endif /* __NOSPEC_H__ */

For heaven's sake, please name a size variable as 'size', not 'sz'. We don't have 
a shortage of characters and can deobfuscate common primitives, can we?

Also, beyond the nits, I also hate the namespace here. We have a new generic 
header providing two new methods:

	#include <linux/nospec.h>

	array_idx_mask()
	array_idx()

which is then optimized for x86 in asm/barrier.h. That's already a non-sequitor.

Then we introduce uaccess API variants with a _nospec() postfix.

Then we add ifence() to x86.

There's no naming coherency to this.

A better approach would be to signal the 'no speculation' aspect of the 
array_idx() methods already: naming it array_idx_nospec() would be a solution,
as it clearly avoids speculation beyond the array boundaries.

Also, without seeing the full series it's hard to tell, whether the introduction 
of linux/nospec.h is justified, but it feels somewhat suspect.

Thanks,

	Ingo
