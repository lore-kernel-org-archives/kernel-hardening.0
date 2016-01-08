Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 15:36:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160108153653.GB32692@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
 <20160108152738.GG16432@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160108152738.GG16432@e104818-lin.cambridge.arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere
 in physical memory
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, arnd@arndb.de, bhupesh.sharma@freescale.com, stuart.yoder@freescale.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 08, 2016 at 03:27:38PM +0000, Catalin Marinas wrote:
> On Wed, Dec 30, 2015 at 04:26:10PM +0100, Ard Biesheuvel wrote:
> > +static void __init enforce_memory_limit(void)
> > +{
> > +	const phys_addr_t kbase = round_down(__pa(_text), MIN_KIMG_ALIGN);
> > +	u64 to_remove = memblock_phys_mem_size() - memory_limit;
> > +	phys_addr_t max_addr = 0;
> > +	struct memblock_region *r;
> > +
> > +	if (memory_limit == (phys_addr_t)ULLONG_MAX)
> > +		return;
> > +
> > +	/*
> > +	 * The kernel may be high up in physical memory, so try to apply the
> > +	 * limit below the kernel first, and only let the generic handling
> > +	 * take over if it turns out we haven't clipped enough memory yet.
> > +	 */
> > +	for_each_memblock(memory, r) {
> > +		if (r->base + r->size > kbase) {
> > +			u64 rem = min(to_remove, kbase - r->base);
> > +
> > +			max_addr = r->base + rem;
> > +			to_remove -= rem;
> > +			break;
> > +		}
> > +		if (to_remove <= r->size) {
> > +			max_addr = r->base + to_remove;
> > +			to_remove = 0;
> > +			break;
> > +		}
> > +		to_remove -= r->size;
> > +	}
> > +
> > +	memblock_remove(0, max_addr);
> > +
> > +	if (to_remove)
> > +		memblock_enforce_memory_limit(memory_limit);
> > +}
> 
> IIUC, this is changing the user expectations a bit. There are people
> using the mem= limit to hijack some top of the RAM for other needs
> (though they could do it in a saner way like changing the DT memory
> nodes).

Which will be hopelessly broken in the presence of KASLR, the kernel
being loaded at a different address, pages betting reserved differently
due to page size, etc.

I hope that no-one usees this for anything other than testing low-memory
conditions. If they want to steal memory they need to carve it out
explicitly.

We can behave as we used to, but we shouldn't give the impression that
such usage is supported.

Thanks,
Mark.
