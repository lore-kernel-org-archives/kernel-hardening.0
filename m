MIME-Version: 1.0
In-Reply-To: <20180112091246.GP32035@hirez.programming.kicks-ass.net>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571801681.27429.15417813964230837664.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180112091246.GP32035@hirez.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Jan 2018 16:41:37 -0800
Message-ID: <CAPcyv4j++bw8dO1cbEZpf3u+wDGM89A7d06MTHtugHHJs8CJ5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 06/19] asm-generic/barrier: mask speculative execution flows
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 12, 2018 at 1:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jan 11, 2018 at 04:46:56PM -0800, Dan Williams wrote:
>> diff --git a/include/linux/nospec.h b/include/linux/nospec.h
>> new file mode 100644
>> index 000000000000..5c66fc30f919
>> --- /dev/null
>> +++ b/include/linux/nospec.h
>> @@ -0,0 +1,71 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright(c) 2018 Intel Corporation. All rights reserved.
>> +
>> +#ifndef __NOSPEC_H__
>> +#define __NOSPEC_H__
>> +
>> +#include <linux/jump_label.h>
>> +#include <asm/barrier.h>
>> +
>> +#ifndef array_ptr_mask
>> +#define array_ptr_mask(idx, sz)                                              \
>> +({                                                                   \
>> +     unsigned long mask;                                             \
>> +     unsigned long _i = (idx);                                       \
>> +     unsigned long _s = (sz);                                        \
>> +                                                                     \
>> +     mask = ~(long)(_i | (_s - 1 - _i)) >> (BITS_PER_LONG - 1);      \
>> +     mask;                                                           \
>> +})
>> +#endif
>> +
>> +/**
>> + * __array_ptr - Generate a pointer to an array element, ensuring
>> + * the pointer is bounded under speculation to NULL.
>> + *
>> + * @base: the base of the array
>> + * @idx: the index of the element, must be less than LONG_MAX
>> + * @sz: the number of elements in the array, must be less than LONG_MAX
>> + *
>> + * If @idx falls in the interval [0, @sz), returns the pointer to
>> + * @arr[@idx], otherwise returns NULL.
>> + */
>> +#define __array_ptr(base, idx, sz)                                   \
>> +({                                                                   \
>> +     union { typeof(*(base)) *_ptr; unsigned long _bit; } __u;       \
>> +     typeof(*(base)) *_arr = (base);                                 \
>> +     unsigned long _i = (idx);                                       \
>> +     unsigned long _mask = array_ptr_mask(_i, (sz));                 \
>> +                                                                     \
>> +     __u._ptr = _arr + (_i & _mask);                                 \
>> +     __u._bit &= _mask;                                              \
>> +     __u._ptr;                                                       \
>> +})
>> +
>> +#ifdef CONFIG_SPECTRE1_IFENCE
>> +DECLARE_STATIC_KEY_TRUE(nospec_key);
>> +#else
>> +DECLARE_STATIC_KEY_FALSE(nospec_key);
>> +#endif
>> +
>> +#ifdef ifence_array_ptr
>> +/*
>> + * The expectation is that no compiler or cpu will mishandle __array_ptr
>> + * leading to problematic speculative execution. Bypass the ifence
>> + * based implementation by default.
>> + */
>> +#define array_ptr(base, idx, sz)                             \
>> +({                                                           \
>> +     typeof(*(base)) *__ret;                                 \
>> +                                                             \
>> +     if (static_branch_unlikely(&nospec_key))                \
>> +             __ret = ifence_array_ptr(base, idx, sz);        \
>> +     else                                                    \
>> +             __ret = __array_ptr(base, idx, sz);             \
>> +     __ret;                                                  \
>> +})
>
>
> So I think this wants:
>
> #ifndef HAVE_JUMP_LABEL
> #error Compiler lacks asm-goto, can generate unsafe code
> #endif
>
> Suppose the generic array_ptr_mask() is unsafe on some arch and they
> only implement ifence_array_ptr() and they compile without asm-goto,
> then the above reverts to a dynamic condition, which can be speculated.
> If we then speculate into the 'bad' __array_ptr we're screwed.

True.

>
>> +#else
>> +#define array_ptr __array_ptr
>> +#endif
>> +
>> +#endif /* __NOSPEC_H__ */
>
>
> In general I think I would write all this in a form like:
>
> #define __array_ptr(base, idx, sz)                                      \
> ({                                                                      \
>         union { typeof(*(base)) *_ptr; unsigned long _bit; } __u;       \
>         typeof(*(base)) *_arr = (base);                                 \
>         unsigned long _i = (idx);                                       \
>         unsigned long _mask = array_ptr_mask(_i, (sz));                 \
>                                                                         \
>         __u._ptr = _arr + (_i & _mask);                                 \
>         __u._bit &= _mask;                                              \
>         __u._ptr;                                                       \
> })
>
> #if defined(array_ptr_mask) && defined(ifence_array_ptr)
>
> #ifndef HAVE_JUMP_LABEL
> #error Compiler lacks asm-goto, can generate unsafe code
> #endif
>
> #define array_ptr(base, idx, sz)                                \
> ({                                                              \
>         typeof(*(base)) *__ret;                                 \
>                                                                 \
>         if (static_branch_unlikely(&nospec_key))                \
>                 __ret = ifence_array_ptr(base, idx, sz);        \
>         else                                                    \
>                 __ret = __array_ptr(base, idx, sz);             \
>         __ret;                                                  \
> })
>
> #elif defined(array_ptr_mask)
>
> #define array_ptr(base, idx, sz) __array_ptr(base, idx, sz)
>
> #elif defined(ifence_array_ptr)
>
> #define array_ptr(base, idx, sz) ifence_array_ptr(base, idx, sz)
>
> #else
>
> /* XXX we want a suitable warning here ? */
>
> #define array_ptr(base, idx, sz) (idx < sz ? base + idx : NULL)
>
> #endif
>
> and stick the generic array_ptr_mask into asm-generic/nospec.h or
> something.
>
> Then the static key stuff is limited to architectures that define _both_
> array_ptr_mask and ifence_array_ptr.

This certainly needs a Kconfig "depends on JUMP_LABEL" to turn on the
dynamic switching at all, and a HAVE_JUMP_LABEL compile time failure
if the compiler lacks support. I don't think we need the checks on
'defined(array_ptr_mask) or that 'XXX' warning case, because default
mask is assumed safe, and otherwise better than nothing.
