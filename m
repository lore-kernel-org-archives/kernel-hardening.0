Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 16:14:47 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160108161446.GC32692@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
 <20160108152738.GG16432@e104818-lin.cambridge.arm.com>
 <20160108153653.GB32692@leverpostej>
 <20160108154814.GI16432@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160108154814.GI16432@e104818-lin.cambridge.arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere
 in physical memory
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: keescook@chromium.org, arnd@arndb.de, kernel-hardening@lists.openwall.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, stuart.yoder@freescale.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Catalin,

I think we agree w.r.t. the code you suggest. I just disagree with the
suggestion that using mem= for carveouts is something we must, or even
could support -- it's already fragile.

More on that below.

On Fri, Jan 08, 2016 at 03:48:15PM +0000, Catalin Marinas wrote:
> On Fri, Jan 08, 2016 at 03:36:54PM +0000, Mark Rutland wrote:
> > On Fri, Jan 08, 2016 at 03:27:38PM +0000, Catalin Marinas wrote:
> > > On Wed, Dec 30, 2015 at 04:26:10PM +0100, Ard Biesheuvel wrote:
> > > > +static void __init enforce_memory_limit(void)
> > > > +{
> > > > +	const phys_addr_t kbase = round_down(__pa(_text), MIN_KIMG_ALIGN);
> > > > +	u64 to_remove = memblock_phys_mem_size() - memory_limit;
> > > > +	phys_addr_t max_addr = 0;
> > > > +	struct memblock_region *r;
> > > > +
> > > > +	if (memory_limit == (phys_addr_t)ULLONG_MAX)
> > > > +		return;
> > > > +
> > > > +	/*
> > > > +	 * The kernel may be high up in physical memory, so try to apply the
> > > > +	 * limit below the kernel first, and only let the generic handling
> > > > +	 * take over if it turns out we haven't clipped enough memory yet.
> > > > +	 */
> > > > +	for_each_memblock(memory, r) {
> > > > +		if (r->base + r->size > kbase) {
> > > > +			u64 rem = min(to_remove, kbase - r->base);
> > > > +
> > > > +			max_addr = r->base + rem;
> > > > +			to_remove -= rem;
> > > > +			break;
> > > > +		}
> > > > +		if (to_remove <= r->size) {
> > > > +			max_addr = r->base + to_remove;
> > > > +			to_remove = 0;
> > > > +			break;
> > > > +		}
> > > > +		to_remove -= r->size;
> > > > +	}
> > > > +
> > > > +	memblock_remove(0, max_addr);
> > > > +
> > > > +	if (to_remove)
> > > > +		memblock_enforce_memory_limit(memory_limit);
> > > > +}
> > > 
> > > IIUC, this is changing the user expectations a bit. There are people
> > > using the mem= limit to hijack some top of the RAM for other needs
> > > (though they could do it in a saner way like changing the DT memory
> > > nodes).
> > 
> > Which will be hopelessly broken in the presence of KASLR, the kernel
> > being loaded at a different address, pages betting reserved differently
> > due to page size, etc.
> 
> With KASLR disabled, I think we should aim for the existing behaviour as
> much as possible. The original aim of these patches was to relax the
> kernel image placement rules, to make it easier for boot loaders rather
> than completely randomising it.

Sure. My point was there were other reasons this is extremely fragile
currently, regardless of KASLR. For example, due to reservations
occurring differently.

Consider that when we add memory we may shave off portions of memory due
to page size, as we do in early_init_dt_add_memory_arch. Regions may be
fused or split for other reasons which may change over time, leading to
a different amount of memory being shaved off.

Afterwards memblock_enforce_memory_limit figures out the max address to keep
with:

        /* find out max address */
        for_each_memblock(memory, r) { 
                if (limit <= r->size) {
                        max_addr = r->base + limit;
                        break;
                }    
                limit -= r->size;
        }

Given all that, you cannot use mem= to prevent use of some memory, except for a
specific kernel binary with some value found by experimentation.

I think we need to make it clear that this is completely and hopelessly broken,
and should not pretend to support that.

> With KASLR enabled, I agree it's hard to make any assumptions about what
> memory is available.

As above, I do not think this is safe at all across kernel binaries.

> But removing memory only from the top would also > help with the point
> you already raised - keeping lower memory for > devices with narrower
> DMA mask.

I'm happy with the logic you suggest for the purpose of keeping low DMA
memory.

I think we must make it clear that mem= cannot be used to protect or
carve out memory -- it's a best effort tool for test purposes.

Thanks,
Mark.
