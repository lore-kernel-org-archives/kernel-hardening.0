Date: Fri, 21 Dec 2018 10:41:20 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 03/12] __wr_after_init: generic functionality
Message-ID: <20181221184120.GG10600@bombadil.infradead.org>
References: <20181221181423.20455-1-igor.stoppa@huawei.com>
 <20181221181423.20455-4-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181221181423.20455-4-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 21, 2018 at 08:14:14PM +0200, Igor Stoppa wrote:
> +static inline int memtst(void *p, int c, __kernel_size_t len)

I don't understand why you're verifying that writes actually happen
in production code.  Sure, write lib/test_wrmem.c or something, but
verifying every single rare write seems like a mistake to me.

> +#ifndef CONFIG_PRMEM

So is this PRMEM or wr_mem?  It's not obvious that CONFIG_PRMEM controls
wrmem.

> +#define wr_assign(var, val)	((var) = (val))

The hamming distance between 'var' and 'val' is too small.  The convention
in the line immediately below (p and v) is much more readable.

> +#define wr_rcu_assign_pointer(p, v)	rcu_assign_pointer(p, v)
> +#define wr_assign(var, val) ({			\
> +	typeof(var) tmp = (typeof(var))val;	\
> +						\
> +	wr_memcpy(&var, &tmp, sizeof(var));	\
> +	var;					\
> +})

Doesn't wr_memcpy return 'var' anyway?

> +/**
> + * wr_memcpy() - copyes size bytes from q to p

typo

> + * @p: beginning of the memory to write to
> + * @q: beginning of the memory to read from
> + * @size: amount of bytes to copy
> + *
> + * Returns pointer to the destination

> + * The architecture code must provide:
> + *   void __wr_enable(wr_state_t *state)
> + *   void *__wr_addr(void *addr)
> + *   void *__wr_memcpy(void *p, const void *q, __kernel_size_t size)
> + *   void __wr_disable(wr_state_t *state)

This section shouldn't be in the user documentation of wr_memcpy().

> + */
> +void *wr_memcpy(void *p, const void *q, __kernel_size_t size)
> +{
> +	wr_state_t wr_state;
> +	void *wr_poking_addr = __wr_addr(p);
> +
> +	if (WARN_ONCE(!wr_ready, "No writable mapping available") ||

Surely not.  If somebody's called wr_memcpy() before wr_ready is set,
that means we can just call memcpy().
