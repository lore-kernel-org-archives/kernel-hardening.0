Date: Thu, 14 Feb 2019 12:28:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v5 03/12] __wr_after_init: Core and default arch
Message-ID: <20190214112849.GM32494@hirez.programming.kicks-ass.net>
References: <cover.1550097697.git.igor.stoppa@huawei.com>
 <b99f0de701e299b9d25ce8cfffa3387b9687f5fc.1550097697.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b99f0de701e299b9d25ce8cfffa3387b9687f5fc.1550097697.git.igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 14, 2019 at 12:41:32AM +0200, Igor Stoppa wrote:
> +static inline void *wr_memset(void *p, int c, __kernel_size_t n)
> +{
> +	return memset(p, c, n);
> +}
> +
> +static inline void *wr_memcpy(void *p, const void *q, __kernel_size_t n)
> +{
> +	return memcpy(p, q, n);
> +}
> +
> +#define wr_assign(var, val)	((var) = (val))
> +#define wr_rcu_assign_pointer(p, v)	rcu_assign_pointer(p, v)
> +
> +#else
> +
> +void *wr_memset(void *p, int c, __kernel_size_t n);
> +void *wr_memcpy(void *p, const void *q, __kernel_size_t n);
> +
> +/**
> + * wr_assign() - sets a write-rare variable to a specified value
> + * @var: the variable to set
> + * @val: the new value
> + *
> + * Returns: the variable
> + */
> +
> +#define wr_assign(dst, val) ({			\
> +	typeof(dst) tmp = (typeof(dst))val;	\
> +						\
> +	wr_memcpy(&dst, &tmp, sizeof(dst));	\
> +	dst;					\
> +})
> +
> +/**
> + * wr_rcu_assign_pointer() - initialize a pointer in rcu mode
> + * @p: the rcu pointer - it MUST be aligned to a machine word
> + * @v: the new value
> + *
> + * Returns the value assigned to the rcu pointer.
> + *
> + * It is provided as macro, to match rcu_assign_pointer()
> + * The rcu_assign_pointer() is implemented as equivalent of:
> + *
> + * smp_mb();
> + * WRITE_ONCE();
> + */
> +#define wr_rcu_assign_pointer(p, v) ({	\
> +	smp_mb();			\
> +	wr_assign(p, v);		\
> +	p;				\
> +})

This requires that wr_memcpy() (through wr_assign) is single-copy-atomic
for native types. There is not a comment in sight that states this.

Also, is this true of x86/arm64 memcpy ?
