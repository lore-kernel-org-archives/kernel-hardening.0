Date: Tue, 30 Oct 2018 16:28:16 +0000
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 16/17] prmem: pratomic-long
Message-ID: <20181030162815.GB20827@arm.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-17-igor.stoppa@huawei.com>
 <20181025001312.GA3159@worktop.c.hoisthospitality.com>
 <806bfff0-8d62-9918-480d-ec791b93841e@gmail.com>
 <20181030155841.GF8177@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030155841.GF8177@hirez.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Boqun Feng <boqun.feng@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 04:58:41PM +0100, Peter Zijlstra wrote:
> On Mon, Oct 29, 2018 at 11:17:14PM +0200, Igor Stoppa wrote:
> > 
> > 
> > On 25/10/2018 01:13, Peter Zijlstra wrote:
> > > On Wed, Oct 24, 2018 at 12:35:03AM +0300, Igor Stoppa wrote:
> > > > +static __always_inline
> > > > +bool __pratomic_long_op(bool inc, struct pratomic_long_t *l)
> > > > +{
> > > > +	struct page *page;
> > > > +	uintptr_t base;
> > > > +	uintptr_t offset;
> > > > +	unsigned long flags;
> > > > +	size_t size = sizeof(*l);
> > > > +	bool is_virt = __is_wr_after_init(l, size);
> > > > +
> > > > +	if (WARN(!(is_virt || likely(__is_wr_pool(l, size))),
> > > > +		 WR_ERR_RANGE_MSG))
> > > > +		return false;
> > > > +	local_irq_save(flags);
> > > > +	if (is_virt)
> > > > +		page = virt_to_page(l);
> > > > +	else
> > > > +		vmalloc_to_page(l);
> > > > +	offset = (~PAGE_MASK) & (uintptr_t)l;
> > > > +	base = (uintptr_t)vmap(&page, 1, VM_MAP, PAGE_KERNEL);
> > > > +	if (WARN(!base, WR_ERR_PAGE_MSG)) {
> > > > +		local_irq_restore(flags);
> > > > +		return false;
> > > > +	}
> > > > +	if (inc)
> > > > +		atomic_long_inc((atomic_long_t *)(base + offset));
> > > > +	else
> > > > +		atomic_long_dec((atomic_long_t *)(base + offset));
> > > > +	vunmap((void *)base);
> > > > +	local_irq_restore(flags);
> > > > +	return true;
> > > > +
> > > > +}
> > > 
> > > That's just hideously nasty.. and horribly broken.
> > > 
> > > We're not going to duplicate all these kernel interfaces wrapped in gunk
> > > like that.
> > 
> > one possibility would be to have macros which use typeof() on the parameter
> > being passed, to decide what implementation to use: regular or write-rare
> > 
> > This means that type punning would still be needed, to select the
> > implementation.
> > 
> > Would this be enough? Is there some better way?
> 
> Like mentioned elsewhere; if you do write_enable() + write_disable()
> thingies, it all becomes:
> 
> 	write_enable();
> 	atomic_foo(&bar);
> 	write_disable();
> 
> No magic gunk infested duplication at all. Of course, ideally you'd then
> teach objtool about this (or a GCC plugin I suppose) to ensure any
> enable reached a disable.

Isn't the issue here that we don't want to change the page tables for the
mapping of &bar, but instead want to create a temporary writable alias
at a random virtual address?

So you'd want:

	wbar = write_enable(&bar);
	atomic_foo(wbar);
	write_disable(wbar);

which is probably better expressed as a map/unmap API. I suspect this
would also be the only way to do things for cmpxchg() loops, where you
want to create the mapping outside of the loop to minimise your time in
the critical section.

Will
