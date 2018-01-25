References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151632010687.21271.12004432287640499992.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Cyril Novikov <cnovikov@lynx.com>
Message-ID: <cfd29ebf-b2ac-dfba-db4d-0fd3321959ce@lynx.com>
Date: Wed, 24 Jan 2018 23:09:54 -0800
MIME-Version: 1.0
In-Reply-To: <151632010687.21271.12004432287640499992.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 02/10] asm/nospec, array_ptr: sanitize speculative
 array de-references
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On 1/18/2018 4:01 PM, Dan Williams wrote:
> 'array_ptr' is proposed as a generic mechanism to mitigate against
> Spectre-variant-1 attacks, i.e. an attack that bypasses boundary checks
> via speculative execution). The 'array_ptr' implementation is expected
> to be safe for current generation cpus across multiple architectures
> (ARM, x86).

I'm an outside reviewer, not subscribed to the list, so forgive me if I 
do something not according to protocol. I have the following comments on 
this change:

After discarding the speculation barrier variant, is array_ptr() needed 
at all? You could have a simpler sanitizing macro, say

#define array_sanitize_idx(idx, sz) ((idx) & array_ptr_mask((idx), (sz)))

(adjusted to not evaluate idx twice). And use it as follows:

if (idx < array_size) {
     idx = array_sanitize_idx(idx, array_size);
     do_something(array[idx]);
}

If I understand the speculation stuff correctly, unlike array_ptr(), 
this "leaks" array[0] rather than nothing (*NULL) when executed 
speculatively. However, it's still much better than leaking an arbitrary 
location in memory. The attacker can likely get array[0] "leaked" by 
passing 0 as idx anyway.

> +/*
> + * If idx is negative or if idx > size then bit 63 is set in the mask,
> + * and the value of ~(-1L) is zero. When the mask is zero, bounds check
> + * failed, array_ptr will return NULL.
> + */
> +#ifndef array_ptr_mask
> +static inline unsigned long array_ptr_mask(unsigned long idx, unsigned long sz)
> +{
> +	return ~(long)(idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1);
> +}
> +#endif

Why does this have to resort to the undefined behavior of shifting a 
negative number to the right? You can do without it:

return ((idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1)) - 1;

Of course, you could argue that subtracting 1 from 0 to get all ones is 
also an undefined behavior, but it's still much better than the shift, 
isn't it?

> +#define array_ptr(base, idx, sz)					\
> +({									\
> +	union { typeof(*(base)) *_ptr; unsigned long _bit; } __u;	\
> +	typeof(*(base)) *_arr = (base);					\
> +	unsigned long _i = (idx);					\
> +	unsigned long _mask = array_ptr_mask(_i, (sz));			\
> +									\
> +	__u._ptr = _arr + (_i & _mask);					\
> +	__u._bit &= _mask;						\
> +	__u._ptr;							\
> +})

Call me paranoid, but I think this may actually create an exploitable 
bug on 32-bit systems due to casting the index to an unsigned long, if 
the index as it comes from userland is a 64-bit value. You have 
*replaced* the "if (idx < array_size)" check with checking if 
array_ptr() returns NULL. Well, it doesn't return NULL if the low 32 
bits of the index are in-bounds, but the high 32 bits are not zero. 
Apart from the return value pointing to the wrong place, the subsequent 
code may then assume that the 64-bit idx is actually valid and trip on 
it badly.

--
Cyril
