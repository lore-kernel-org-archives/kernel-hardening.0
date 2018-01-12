From: ebiederm@xmission.com (Eric W. Biederman)
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
	<151571801681.27429.15417813964230837664.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 11 Jan 2018 20:42:41 -0600
In-Reply-To: <151571801681.27429.15417813964230837664.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Thu, 11 Jan 2018 16:46:56 -0800")
Message-ID: <8760874x26.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v2 06/19] asm-generic/barrier: mask speculative execution flows
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Dan Williams <dan.j.williams@intel.com> writes:

> diff --git a/include/linux/nospec.h b/include/linux/nospec.h
> new file mode 100644
> index 000000000000..5c66fc30f919
> --- /dev/null
> +++ b/include/linux/nospec.h
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright(c) 2018 Intel Corporation. All rights reserved.
> +
> +#ifndef __NOSPEC_H__
> +#define __NOSPEC_H__
> +
> +#include <linux/jump_label.h>
> +#include <asm/barrier.h>
> +
> +#ifndef array_ptr_mask
> +#define array_ptr_mask(idx, sz)						\
> +({									\
> +	unsigned long mask;						\
> +	unsigned long _i = (idx);					\
> +	unsigned long _s = (sz);					\
> +									\
> +	mask = ~(long)(_i | (_s - 1 - _i)) >> (BITS_PER_LONG - 1);	\
> +	mask;								\
> +})
> +#endif

This could really use a comment that explains it generates 0
for out of bound accesses and -1L aka 0xffffffffffffffff for
all other accesses.

The code is clever enough which values it generates is not obvious.

Eric
