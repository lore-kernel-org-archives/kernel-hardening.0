Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 15:27:38 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160108152738.GG16432@e104818-lin.cambridge.arm.com>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere
 in physical memory
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, arnd@arndb.de, bhupesh.sharma@freescale.com, stuart.yoder@freescale.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 30, 2015 at 04:26:10PM +0100, Ard Biesheuvel wrote:
> +static void __init enforce_memory_limit(void)
> +{
> +	const phys_addr_t kbase = round_down(__pa(_text), MIN_KIMG_ALIGN);
> +	u64 to_remove = memblock_phys_mem_size() - memory_limit;
> +	phys_addr_t max_addr = 0;
> +	struct memblock_region *r;
> +
> +	if (memory_limit == (phys_addr_t)ULLONG_MAX)
> +		return;
> +
> +	/*
> +	 * The kernel may be high up in physical memory, so try to apply the
> +	 * limit below the kernel first, and only let the generic handling
> +	 * take over if it turns out we haven't clipped enough memory yet.
> +	 */
> +	for_each_memblock(memory, r) {
> +		if (r->base + r->size > kbase) {
> +			u64 rem = min(to_remove, kbase - r->base);
> +
> +			max_addr = r->base + rem;
> +			to_remove -= rem;
> +			break;
> +		}
> +		if (to_remove <= r->size) {
> +			max_addr = r->base + to_remove;
> +			to_remove = 0;
> +			break;
> +		}
> +		to_remove -= r->size;
> +	}
> +
> +	memblock_remove(0, max_addr);
> +
> +	if (to_remove)
> +		memblock_enforce_memory_limit(memory_limit);
> +}

IIUC, this is changing the user expectations a bit. There are people
using the mem= limit to hijack some top of the RAM for other needs
(though they could do it in a saner way like changing the DT memory
nodes). Your patch first tries to remove the memory below the kernel
image and only remove the top if additional limitation is necessary.

Can you not remove memory from the top and block the limit if it goes
below the end of the kernel image, with some warning that memory limit
was not entirely fulfilled?

-- 
Catalin
