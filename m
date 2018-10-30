Date: Tue, 30 Oct 2018 16:58:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 16/17] prmem: pratomic-long
Message-ID: <20181030155841.GF8177@hirez.programming.kicks-ass.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-17-igor.stoppa@huawei.com>
 <20181025001312.GA3159@worktop.c.hoisthospitality.com>
 <806bfff0-8d62-9918-480d-ec791b93841e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806bfff0-8d62-9918-480d-ec791b93841e@gmail.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 29, 2018 at 11:17:14PM +0200, Igor Stoppa wrote:
> 
> 
> On 25/10/2018 01:13, Peter Zijlstra wrote:
> > On Wed, Oct 24, 2018 at 12:35:03AM +0300, Igor Stoppa wrote:
> > > +static __always_inline
> > > +bool __pratomic_long_op(bool inc, struct pratomic_long_t *l)
> > > +{
> > > +	struct page *page;
> > > +	uintptr_t base;
> > > +	uintptr_t offset;
> > > +	unsigned long flags;
> > > +	size_t size = sizeof(*l);
> > > +	bool is_virt = __is_wr_after_init(l, size);
> > > +
> > > +	if (WARN(!(is_virt || likely(__is_wr_pool(l, size))),
> > > +		 WR_ERR_RANGE_MSG))
> > > +		return false;
> > > +	local_irq_save(flags);
> > > +	if (is_virt)
> > > +		page = virt_to_page(l);
> > > +	else
> > > +		vmalloc_to_page(l);
> > > +	offset = (~PAGE_MASK) & (uintptr_t)l;
> > > +	base = (uintptr_t)vmap(&page, 1, VM_MAP, PAGE_KERNEL);
> > > +	if (WARN(!base, WR_ERR_PAGE_MSG)) {
> > > +		local_irq_restore(flags);
> > > +		return false;
> > > +	}
> > > +	if (inc)
> > > +		atomic_long_inc((atomic_long_t *)(base + offset));
> > > +	else
> > > +		atomic_long_dec((atomic_long_t *)(base + offset));
> > > +	vunmap((void *)base);
> > > +	local_irq_restore(flags);
> > > +	return true;
> > > +
> > > +}
> > 
> > That's just hideously nasty.. and horribly broken.
> > 
> > We're not going to duplicate all these kernel interfaces wrapped in gunk
> > like that.
> 
> one possibility would be to have macros which use typeof() on the parameter
> being passed, to decide what implementation to use: regular or write-rare
> 
> This means that type punning would still be needed, to select the
> implementation.
> 
> Would this be enough? Is there some better way?

Like mentioned elsewhere; if you do write_enable() + write_disable()
thingies, it all becomes:

	write_enable();
	atomic_foo(&bar);
	write_disable();

No magic gunk infested duplication at all. Of course, ideally you'd then
teach objtool about this (or a GCC plugin I suppose) to ensure any
enable reached a disable.

The alternative is something like:

#define ALLOW_WRITE(stmt) do { write_enable(); do { stmt; } while (0); write_disable(); } while (0)

which then allows you to write:

	ALLOW_WRITE(atomic_foo(&bar));

No duplication.

> > Also, you _cannot_ call vunmap() with IRQs disabled. Clearly
> > you've never tested this with debug bits enabled.
> 
> I thought I had them. And I _did_ have them enabled, at some point.
> But I must have messed up with the configuration and I failed to notice
> this.
> 
> I can think of a way it might work, albeit it's not going to be very pretty:
> 
> * for the vmap(): if I understand correctly, it might sleep while obtaining
> memory for creating the mapping. This part could be executed before
> disabling interrupts. The rest of the function, instead, would be executed
> after interrupts are disabled.
> 
> * for vunmap(): after the writing is done, change also the alternate mapping
> to read only, then enable interrupts and destroy the alternate mapping.
> Making also the secondary mapping read only makes it equally secure as the
> primary, which means that it can be visible also with interrupts enabled.

That doesn't work if you wanted to do this write while you already have
IRQs disabled for example.
