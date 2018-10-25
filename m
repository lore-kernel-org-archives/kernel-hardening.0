Date: Thu, 25 Oct 2018 02:13:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 16/17] prmem: pratomic-long
Message-ID: <20181025001312.GA3159@worktop.c.hoisthospitality.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-17-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023213504.28905-17-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 24, 2018 at 12:35:03AM +0300, Igor Stoppa wrote:
> +static __always_inline
> +bool __pratomic_long_op(bool inc, struct pratomic_long_t *l)
> +{
> +	struct page *page;
> +	uintptr_t base;
> +	uintptr_t offset;
> +	unsigned long flags;
> +	size_t size = sizeof(*l);
> +	bool is_virt = __is_wr_after_init(l, size);
> +
> +	if (WARN(!(is_virt || likely(__is_wr_pool(l, size))),
> +		 WR_ERR_RANGE_MSG))
> +		return false;
> +	local_irq_save(flags);
> +	if (is_virt)
> +		page = virt_to_page(l);
> +	else
> +		vmalloc_to_page(l);
> +	offset = (~PAGE_MASK) & (uintptr_t)l;
> +	base = (uintptr_t)vmap(&page, 1, VM_MAP, PAGE_KERNEL);
> +	if (WARN(!base, WR_ERR_PAGE_MSG)) {
> +		local_irq_restore(flags);
> +		return false;
> +	}
> +	if (inc)
> +		atomic_long_inc((atomic_long_t *)(base + offset));
> +	else
> +		atomic_long_dec((atomic_long_t *)(base + offset));
> +	vunmap((void *)base);
> +	local_irq_restore(flags);
> +	return true;
> +
> +}

That's just hideously nasty.. and horribly broken.

We're not going to duplicate all these kernel interfaces wrapped in gunk
like that. Also, you _cannot_ call vunmap() with IRQs disabled. Clearly
you've never tested this with debug bits enabled.
