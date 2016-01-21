Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jan 2016 16:10:06 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
Message-ID: <20160121161006.GF2510@codeblueprint.co.uk>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-21-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-21-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 19/21] efi: stub: add implementation of
 efi_random_alloc()
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 11 Jan, at 02:19:13PM, Ard Biesheuvel wrote:
> This implements efi_random_alloc(), which allocates a chunk of memory of
> a certain size at a certain alignment, and uses the random_seed argument
> it receives to randomize the offset of the allocation.

s/offset/address/ ?

I see what you're getting at with the word "offset" but ultimately,
this is a memory allocation function, and it returns an address.

"offset" implies to me that the implementation allocates a larger
memory chunk than is required and returns an address that is >= the
start of the bigger-than-required-allocation.

> This is implemented by iterating over the UEFI memory map, counting the
> number of suitable slots (aligned offsets) within each region, and picking
> a random number between 0 and 'number of slots - 1' to select the slot,
> This should guarantee that each possible offset is chosen equally likely.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/libstub/efistub.h |  4 +
>  drivers/firmware/efi/libstub/random.c  | 85 ++++++++++++++++++++
>  2 files changed, 89 insertions(+)
> 
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index 206b7252b9d1..7a38e29da53d 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -46,4 +46,8 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>  efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
>  				  unsigned long size, u8 *out);
>  
> +efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
> +			      unsigned long size, unsigned long align_bits,
> +			      unsigned long *addr, unsigned long random_seed);
> +
>  #endif
> diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
> index f539b1e31459..d4829824508c 100644
> --- a/drivers/firmware/efi/libstub/random.c
> +++ b/drivers/firmware/efi/libstub/random.c
> @@ -33,3 +33,88 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
>  
>  	return rng->get_rng(rng, NULL, size, out);
>  }
> +
> +/*
> + * Return a weight for a memory entry depending on how many offsets it covers
> + * that are suitably aligned and supply enough room for the allocation.
> + */
> +static unsigned long get_entry_weight(efi_memory_desc_t *md, unsigned long size,
> +				      unsigned long align_bits)
> +{
> +	u64 start, end;
> +
> +	if (md->type != EFI_CONVENTIONAL_MEMORY)
> +		return 0;
> +
> +	if (!(md->attribute & EFI_MEMORY_WB))
> +		return 0;

This could do with a comment. When would EFI_CONVENTIONAL_MEMORY not
have this attribute capability in the memory map?

> +
> +	start = round_up(md->phys_addr, 1 << align_bits);
> +	end = round_down(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - size,
> +			 1 << align_bits);
> +
> +	if (start >= end)
> +		return 0;
> +
> +	return (end - start) >> align_bits;
> +}
> +
> +/*
> + * The UEFI memory descriptors have a virtual address field that is only used
> + * when installing the virtual mapping using SetVirtualAddressMap(). Since it
> + * is unused here, we can reuse it to keep track of each descriptor's weight.
> + */
> +#define MD_WEIGHT(md)	((md)->virt_addr)
> +
> +efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
> +			      unsigned long size, unsigned long align_bits,
> +			      unsigned long *addr, unsigned long random_seed)
> +{
> +	unsigned long map_size, desc_size, max_weight = 0, target;
> +	efi_memory_desc_t *memory_map;
> +	efi_status_t status = EFI_NOT_FOUND;
> +	int l;

Could you pick a more descriptive variable name?

> +
> +	status = efi_get_memory_map(sys_table_arg, &memory_map, &map_size,
> +				    &desc_size, NULL, NULL);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	/* assign each entry in the memory map a weight */
> +	for (l = 0; l < map_size; l += desc_size) {
> +		efi_memory_desc_t *md = (void *)memory_map + l;
> +		unsigned long weight;
> +
> +		weight = get_entry_weight(md, size, align_bits);
> +		MD_WEIGHT(md) = weight;
> +		max_weight += weight;
> +	}
> +
> +	/* find a random number between 0 and max_weight */
> +	target = (max_weight * (u16)random_seed) >> 16;
> +
> +	/* find the entry whose accumulated weight covers the target */
> +	for (l = 0; l < map_size; l += desc_size) {
> +		efi_memory_desc_t *md = (void *)memory_map + l;
> +
> +		if (target < MD_WEIGHT(md)) {
> +			unsigned long pages;
> +
> +			*addr = round_up(md->phys_addr, 1 << align_bits) +
> +				(target << align_bits);
> +			pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> +
> +			status = efi_call_early(allocate_pages,
> +						EFI_ALLOCATE_ADDRESS,
> +						EFI_LOADER_DATA,
> +						pages,
> +						(efi_physical_addr_t *)addr);

You're mixing data types here. efi_physical_addr_t is always 64-bits,
but 'addr' is unsigned long, which is 32-bits on 32-bit platforms.
This cast isn't safe.

> +			break;
> +		}
> +		target -= MD_WEIGHT(md);

I think this needs a comment.
