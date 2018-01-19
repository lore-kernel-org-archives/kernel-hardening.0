MIME-Version: 1.0
In-Reply-To: <151632010687.21271.12004432287640499992.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632010687.21271.12004432287640499992.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 19 Jan 2018 11:20:48 +0100
Message-ID: <CAG48ez0Y97-gyzWBmcVbUyLuzUG42To=Mm8PAKuzWma6XbFmew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4 02/10] asm/nospec, array_ptr:
 sanitize speculative array de-references
To: Dan Williams <dan.j.williams@intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, the arch/x86 maintainers <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 19, 2018 at 1:01 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> 'array_ptr' is proposed as a generic mechanism to mitigate against
> Spectre-variant-1 attacks, i.e. an attack that bypasses boundary checks
> via speculative execution). The 'array_ptr' implementation is expected
> to be safe for current generation cpus across multiple architectures
> (ARM, x86).
>
> Based on an original implementation by Linus Torvalds, tweaked to remove
> speculative flows by Alexei Starovoitov, and tweaked again by Linus to
> introduce an x86 assembly implementation for the mask generation.
[...]
> +/*
> + * If idx is negative or if idx > size then bit 63 is set in the mask,
> + * and the value of ~(-1L) is zero. When the mask is zero, bounds check
> + * failed, array_ptr will return NULL.
> + */
> +#ifndef array_ptr_mask
> +static inline unsigned long array_ptr_mask(unsigned long idx, unsigned long sz)
> +{
> +       return ~(long)(idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1);
> +}
> +#endif

Nit: Maybe add a comment saying that this is equivalent to
"return ((long)idx >= 0 && idx < sz) ? ULONG_MAX : 0"?

> +/**
> + * array_ptr - Generate a pointer to an array element, ensuring
> + * the pointer is bounded under speculation to NULL.
> + *
> + * @base: the base of the array
> + * @idx: the index of the element, must be less than LONG_MAX
> + * @sz: the number of elements in the array, must be less than LONG_MAX
> + *
> + * If @idx falls in the interval [0, @sz), returns the pointer to
> + * @arr[@idx], otherwise returns NULL.
> + */
> +#define array_ptr(base, idx, sz)                                       \
> +({                                                                     \
> +       union { typeof(*(base)) *_ptr; unsigned long _bit; } __u;       \
> +       typeof(*(base)) *_arr = (base);                                 \
> +       unsigned long _i = (idx);                                       \
> +       unsigned long _mask = array_ptr_mask(_i, (sz));                 \
> +                                                                       \
> +       __u._ptr = _arr + (_i & _mask);                                 \
> +       __u._bit &= _mask;                                              \

AFAICS, if `idx` is out of bounds, you first zero out the index
(`_i & _mask`) and then immediately afterwards zero out
the whole pointer (`_u._bit &= _mask`).
Is there a reason for the `_i & _mask`, and if so, can you
add a comment explaining that?
