Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 11:26:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160108112622.GA3097@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere
 in physical memory
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Dec 30, 2015 at 04:26:10PM +0100, Ard Biesheuvel wrote:
> This relaxes the kernel Image placement requirements, so that it
> may be placed at any 2 MB aligned offset in physical memory.
> 
> This is accomplished by ignoring PHYS_OFFSET when installing
> memblocks, and accounting for the apparent virtual offset of
> the kernel Image. As a result, virtual address references
> below PAGE_OFFSET are correctly mapped onto physical references
> into the kernel Image regardless of where it sits in memory.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/arm64/booting.txt  | 12 ++---
>  arch/arm64/include/asm/boot.h    |  5 ++
>  arch/arm64/include/asm/kvm_mmu.h |  2 +-
>  arch/arm64/include/asm/memory.h  | 15 +++---
>  arch/arm64/kernel/head.S         |  6 ++-
>  arch/arm64/mm/init.c             | 50 +++++++++++++++++++-
>  arch/arm64/mm/mmu.c              | 12 +++++
>  7 files changed, 86 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> index 701d39d3171a..03e02ebc1b0c 100644
> --- a/Documentation/arm64/booting.txt
> +++ b/Documentation/arm64/booting.txt
> @@ -117,14 +117,14 @@ Header notes:
>    depending on selected features, and is effectively unbound.
>  
>  The Image must be placed text_offset bytes from a 2MB aligned base
> -address near the start of usable system RAM and called there. Memory
> -below that base address is currently unusable by Linux, and therefore it
> -is strongly recommended that this location is the start of system RAM.
> -The region between the 2 MB aligned base address and the start of the
> -image has no special significance to the kernel, and may be used for
> -other purposes.
> +address anywhere in usable system RAM and called there. The region
> +between the 2 MB aligned base address and the start of the image has no
> +special significance to the kernel, and may be used for other purposes.
>  At least image_size bytes from the start of the image must be free for
>  use by the kernel.
> +NOTE: versions prior to v4.6 cannot make use of memory below the
> +physical offset of the Image so it is recommended that the Image be
> +placed as close as possible to the start of system RAM.

We need a head flag for this so that a bootloader can determine whether
it can load the kernel anywhere or should try for the lowest possible
address. Then the note would describe the recommended behaviour in the
absence of the flag.

The flag for KASLR isn't sufficient as you can build without it (and it
only tells the bootloader that the kernel accepts entropy in x1).

We might also want to consider if we need to determine whether or not
the bootloader actually provided entropy, (and if we need a more general
handshake between the bootlaoder and kernel to determine that kind of
thing).

>  Any memory described to the kernel (even that below the start of the
>  image) which is not marked as reserved from the kernel (e.g., with a
> diff --git a/arch/arm64/include/asm/boot.h b/arch/arm64/include/asm/boot.h
> index 81151b67b26b..984cb0fa61ce 100644
> --- a/arch/arm64/include/asm/boot.h
> +++ b/arch/arm64/include/asm/boot.h
> @@ -11,4 +11,9 @@
>  #define MIN_FDT_ALIGN		8
>  #define MAX_FDT_SIZE		SZ_2M
>  
> +/*
> + * arm64 requires the kernel image to be 2 MB aligned

Nit: The image is TEXT_OFFSET from that 2M-aligned base.
s/image/mapping/? 

[...]

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

We might want ot preserve the low 4GB if possible, for those IOMMU-less
devices which can only do 32-bit addressing.

Otherwise this looks good to me!

Thanks,
Mark.
