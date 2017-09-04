Date: Mon, 4 Sep 2017 14:53:52 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20170903120757.14968-27-ard.biesheuvel@linaro.org>
Message-ID: <nycvar.YSQ.7.76.1709041449041.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org> <20170903120757.14968-27-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 26/29] ARM: decompressor: add KASLR support
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 3 Sep 2017, Ard Biesheuvel wrote:

> Add support to the decompressor to load the kernel at a randomized
> offset, and invoke the kernel proper while passing on the information
> about the offset at which the kernel was loaded.
> 
> This implementation will extract some pseudo-randomness from the low
> bits of the generic timer (if available), and use CRC-16 to combine
> it with the build ID string and the device tree binary (which ideally
> has a /chosen/kaslr-seed property, but may also have other properties
> that differ between boots). This seed is used to select one of the
> candidate offsets in the lowmem region that don't overlap the zImage
> itself, the DTB, the initrd and /memreserve/s and/or /reserved-memory
> nodes that should be left alone.
> 
> When booting via the UEFI stub, it is left up to the firmware to supply
> a suitable seed and select an offset.

Why did you remove the entropy contribution from general regs upon 
entry? That was an easy way to enable KASLR on those platforms not using 
DT as they would simply have to put some random value in any of the 
regs.


> 
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/boot/compressed/Makefile |   8 +-
>  arch/arm/boot/compressed/head.S   |  84 ++++-
>  arch/arm/boot/compressed/kaslr.c  | 398 ++++++++++++++++++++
>  3 files changed, 484 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index d50430c40045..771b1ba1baa3 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -85,8 +85,14 @@ $(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/
>  $(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
>  	$(addprefix $(obj)/,$(libfdt_hdrs))
>  
> +ifneq ($(CONFIG_ARM_ATAG_DTB_COMPAT)$(CONFIG_RANDOMIZE_BASE),)
> +OBJS	+= $(libfdt_objs)
>  ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
> -OBJS	+= $(libfdt_objs) atags_to_fdt.o
> +OBJS	+= atags_to_fdt.o
> +endif
> +ifeq ($(CONFIG_RANDOMIZE_BASE),y)
> +OBJS	+= kaslr.o
> +endif
>  endif
>  
>  targets       := vmlinux vmlinux.lds piggy_data piggy.o \
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 583cc6899d98..79b4033b0ed4 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -381,6 +381,42 @@ restart:	adr	r0, LC0
>  dtb_check_done:
>  #endif
>  
> +#ifdef CONFIG_RANDOMIZE_BASE
> +		ldr	r1, kaslr_offset	@ check if the kaslr_offset is
> +		cmp	r1, #0			@ already set
> +#ifdef CONFIG_EFI_STUB
> +		ldreq	r1, __efi_boot		@ UEFI has its own KASLR init
> +		cmpeq	r1, #0			@ routine so skip over this one
> +#endif
> +		bne	1f
> +
> +		stmfd	sp!, {r0-r3, ip, lr}
> +		adr_l	r2, _text		@ start of zImage
> +		stmfd	sp!, {r2, r8, r10}	@ pass stack arguments
> +
> +#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V6K) || defined(CONFIG_CPU_V7)
> +		/*
> +		 * Get some pseudo-entropy from the low bits of the generic
> +		 * timer if it is implemented.
> +		 */
> +		mrc	p15, 0, r1, c0, c1, 1	@ read ID_PFR1 register
> +		tst	r1, #0x10000		@ have generic timer?
> +		beq	0f
> +		mrrc	p15, 1, r3, r1, c14	@ read CNTVCT
> +#endif
> +0:		adr_l	r0, kaslr_offset	@ pass &kaslr_offset in r0
> +		mov	r1, r4			@ pass base address
> +		mov	r2, r9			@ pass decompressed image size
> +		eor	r3, r3, r3, ror #16	@ pass initial seed
> +		bl	kaslr_early_init
> +		add	sp, sp, #12
> +		cmp	r0, #0
> +		addne	r4, r4, r0		@ add offset to base address
> +		ldmfd	sp!, {r0-r3, ip, lr}
> +		bne	restart
> +1:
> +#endif
> +
>  /*
>   * Check to see if we will overwrite ourselves.
>   *   r4  = final kernel address (possibly with LSB set)
> @@ -1356,25 +1392,63 @@ __hyp_reentry_vectors:
>  
>  __enter_kernel:
>  		mov	r0, #0			@ must be 0
> +#ifdef CONFIG_RANDOMIZE_BASE
> +		ldr	r3, kaslr_offset
> +		add	r4, r4, #4		@ skip first instruction
> +#endif
>   ARM(		mov	pc, r4		)	@ call kernel
>   M_CLASS(	add	r4, r4, #1	)	@ enter in Thumb mode for M class
>   THUMB(		bx	r4		)	@ entry point is always ARM for A/R classes
>  
> +#ifdef CONFIG_RANDOMIZE_BASE
> +		/*
> +		 * Minimal implementation of CRC-16 that does not use a
> +		 * lookup table and uses 32-bit wide loads, so it still
> +		 * performs reasonably well with the D-cache off. Equivalent
> +		 * to lib/crc16.c for input sizes that are 4 byte multiples.
> +		 */
> +ENTRY(__crc16)
> +		push	{r4, lr}
> +		ldr	r3, =0xa001		@ CRC-16 polynomial
> +0:		subs	r2, r2, #4
> +		popmi	{r4, pc}
> +		ldr	r4, [r1], #4
> +#ifdef __ARMEB__
> +		eor	ip, r4, r4, ror #16	@ endian swap
> +		bic	ip, ip, #0x00ff0000
> +		mov	r4, r4, ror #8
> +		eor	r4, r4, ip, lsr #8
> +#endif
> +		eor	r0, r0, r4
> +		.rept	32
> +		lsrs	r0, r0, #1
> +		eorcs	r0, r0, r3
> +		.endr
> +		b	0b
> +ENDPROC(__crc16)
> +
> +		.align	2
> +kaslr_offset:	.long	0
> +#ifdef CONFIG_EFI_STUB
> +__efi_boot:	.long	0
> +#endif
> +#endif
> +
>  reloc_code_end:
>  
>  #ifdef CONFIG_EFI_STUB
>  		.align	2
> -_start:		.long	start - .
> -
>  ENTRY(efi_stub_entry)
>  		@ allocate space on stack for passing current zImage address
>  		@ and for the EFI stub to return of new entry point of
>  		@ zImage, as EFI stub may copy the kernel. Pointer address
>  		@ is passed in r2. r0 and r1 are passed through from the
>  		@ EFI firmware to efi_entry
> -		adr	ip, _start
> -		ldr	r3, [ip]
> -		add	r3, r3, ip
> +#ifdef CONFIG_RANDOMIZE_BASE
> +		adr	r3, __efi_boot
> +		str	r3, [r3]		@ set __efi_boot != 0
> +#endif
> +		adr_l	r3, start
>  		stmfd	sp!, {r3, lr}
>  		mov	r2, sp			@ pass zImage address in r2
>  		bl	efi_entry
> diff --git a/arch/arm/boot/compressed/kaslr.c b/arch/arm/boot/compressed/kaslr.c
> new file mode 100644
> index 000000000000..c68bdea764b6
> --- /dev/null
> +++ b/arch/arm/boot/compressed/kaslr.c
> @@ -0,0 +1,398 @@
> +/*
> + * Copyright (C) 2017 Linaro Ltd;  <ard.biesheuvel@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <libfdt.h>
> +#include <linux/types.h>
> +#include <generated/compile.h>
> +#include <generated/utsrelease.h>
> +#include <asm/pgtable.h>
> +
> +struct regions {
> +	u32 pa_start;
> +	u32 pa_end;
> +	u32 image_size;
> +	u32 zimage_start;
> +	u32 zimage_size;
> +	u32 dtb_start;
> +	u32 dtb_size;
> +	u32 initrd_start;
> +	u32 initrd_size;
> +	int reserved_mem;
> +	int reserved_mem_addr_cells;
> +	int reserved_mem_size_cells;
> +};
> +
> +extern u32 __crc16(u32 crc, u32 const input[], int byte_count);
> +
> +static u32 __memparse(const char *val, const char **retptr)
> +{
> +	int base = 10;
> +	u32 ret = 0;
> +
> +	if (*val == '0') {
> +		val++;
> +		if (*val == 'x' || *val == 'X') {
> +			val++;
> +			base = 16;
> +		} else {
> +			base = 8;
> +		}
> +	}
> +
> +	while (*val != ',' && *val != ' ' && *val != '\0') {
> +		char c = *val++;
> +
> +		switch (c) {
> +		case '0' ... '9':
> +			ret = ret * base + (c - '0');
> +			continue;
> +		case 'a' ... 'f':
> +			ret = ret * base + (c - 'a' + 10);
> +			continue;
> +		case 'A' ... 'F':
> +			ret = ret * base + (c - 'A' + 10);
> +			continue;
> +		case 'g':
> +		case 'G':
> +			ret <<= 10;
> +		case 'm':
> +		case 'M':
> +			ret <<= 10;
> +		case 'k':
> +		case 'K':
> +			ret <<= 10;
> +			break;
> +		default:
> +			if (retptr)
> +				*retptr = NULL;
> +			return 0;
> +		}
> +	}
> +	if (retptr)
> +		*retptr = val;
> +	return ret;
> +}
> +
> +static bool regions_intersect(u32 s1, u32 e1, u32 s2, u32 e2)
> +{
> +	return e1 >= s2 && e2 >= s1;
> +}
> +
> +static bool intersects_reserved_region(const void *fdt, u32 start,
> +				       u32 end, struct regions *regions)
> +{
> +	int subnode, len, i;
> +	u64 base, size;
> +
> +	/* check for overlap with /memreserve/ entries */
> +	for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
> +		if (fdt_get_mem_rsv(fdt, i, &base, &size) < 0)
> +			continue;
> +		if (regions_intersect(start, end, base, base + size))
> +			return true;
> +	}
> +
> +	if (regions->reserved_mem < 0)
> +		return false;
> +
> +	/* check for overlap with static reservations in /reserved-memory */
> +	for (subnode = fdt_first_subnode(fdt, regions->reserved_mem);
> +	     subnode >= 0;
> +	     subnode = fdt_next_subnode(fdt, subnode)) {
> +		const fdt32_t *reg;
> +
> +		len = 0;
> +		reg = fdt_getprop(fdt, subnode, "reg", &len);
> +		while (len >= (regions->reserved_mem_addr_cells +
> +			       regions->reserved_mem_size_cells)) {
> +
> +			base = fdt32_to_cpu(reg[0]);
> +			if (regions->reserved_mem_addr_cells == 2)
> +				base = (base << 32) | fdt32_to_cpu(reg[1]);
> +
> +			reg += regions->reserved_mem_addr_cells;
> +			len -= 4 * regions->reserved_mem_addr_cells;
> +
> +			size = fdt32_to_cpu(reg[0]);
> +			if (regions->reserved_mem_size_cells == 2)
> +				size = (size << 32) | fdt32_to_cpu(reg[1]);
> +
> +			reg += regions->reserved_mem_size_cells;
> +			len -= 4 * regions->reserved_mem_size_cells;
> +
> +			if (base >= regions->pa_end)
> +				continue;
> +
> +			if (regions_intersect(start, end, base,
> +					      min(base + size, (u64)U32_MAX)))
> +				return true;
> +		}
> +	}
> +	return false;
> +}
> +
> +static bool intersects_occupied_region(const void *fdt, u32 start,
> +				       u32 end, struct regions *regions)
> +{
> +	if (regions_intersect(start, end, regions->zimage_start,
> +			      regions->zimage_start + regions->zimage_size))
> +		return true;
> +
> +	if (regions_intersect(start, end, regions->initrd_start,
> +			      regions->initrd_start + regions->initrd_size))
> +		return true;
> +
> +	if (regions_intersect(start, end, regions->dtb_start,
> +			      regions->dtb_start + regions->dtb_size))
> +		return true;
> +
> +	return intersects_reserved_region(fdt, start, end, regions);
> +}
> +
> +static u32 count_suitable_regions(const void *fdt, struct regions *regions)
> +{
> +	u32 pa, ret = 0;
> +
> +	for (pa = regions->pa_start; pa < regions->pa_end; pa += SZ_2M) {
> +		if (!intersects_occupied_region(fdt, pa,
> +						pa + regions->image_size,
> +						regions))
> +			ret++;
> +	}
> +	return ret;
> +}
> +
> +static u32 get_numbered_region(const void *fdt,
> +					 struct regions *regions,
> +					 int num)
> +{
> +	u32 pa;
> +
> +	for (pa = regions->pa_start; pa < regions->pa_end; pa += SZ_2M) {
> +		if (!intersects_occupied_region(fdt, pa,
> +						pa + regions->image_size,
> +						regions))
> +			if (num-- == 0)
> +				return pa;
> +	}
> +	return regions->pa_start; /* should not happen */
> +}
> +
> +static void get_cell_sizes(const void *fdt, int node, int *addr_cells,
> +			   int *size_cells)
> +{
> +	const int *prop;
> +	int len;
> +
> +	/*
> +	 * Retrieve the #address-cells and #size-cells properties
> +	 * from the 'node', or use the default if not provided.
> +	 */
> +	*addr_cells = *size_cells = 1;
> +
> +	prop = fdt_getprop(fdt, node, "#address-cells", &len);
> +	if (len == 4)
> +		*addr_cells = fdt32_to_cpu(*prop);
> +	prop = fdt_getprop(fdt, node, "#size-cells", &len);
> +	if (len == 4)
> +		*size_cells = fdt32_to_cpu(*prop);
> +}
> +
> +static u32 get_memory_end(const void *fdt)
> +{
> +	int mem_node, address_cells, size_cells, len;
> +	const fdt32_t *reg;
> +	u64 memory_end = 0;
> +
> +	/* Look for a node called "memory" at the lowest level of the tree */
> +	mem_node = fdt_path_offset(fdt, "/memory");
> +	if (mem_node <= 0)
> +		return 0;
> +
> +	get_cell_sizes(fdt, 0, &address_cells, &size_cells);
> +
> +	/*
> +	 * Now find the 'reg' property of the /memory node, and iterate over
> +	 * the base/size pairs.
> +	 */
> +	len = 0;
> +	reg = fdt_getprop(fdt, mem_node, "reg", &len);
> +	while (len >= 4 * (address_cells + size_cells)) {
> +		u64 base, size;
> +
> +		base = fdt32_to_cpu(reg[0]);
> +		if (address_cells == 2)
> +			base = (base << 32) | fdt32_to_cpu(reg[1]);
> +
> +		reg += address_cells;
> +		len -= 4 * address_cells;
> +
> +		size = fdt32_to_cpu(reg[0]);
> +		if (size_cells == 2)
> +			size = (size << 32) | fdt32_to_cpu(reg[1]);
> +
> +		reg += size_cells;
> +		len -= 4 * size_cells;
> +
> +		memory_end = max(memory_end, base + size);
> +	}
> +	return min(memory_end, (u64)U32_MAX);
> +}
> +
> +static char *__strstr(const char *s1, const char *s2, int l2)
> +{
> +	int l1;
> +
> +	l1 = strlen(s1);
> +	while (l1 >= l2) {
> +		l1--;
> +		if (!memcmp(s1, s2, l2))
> +			return (char *)s1;
> +		s1++;
> +	}
> +	return NULL;
> +}
> +
> +static const char *get_cmdline_param(const char *cmdline, const char *param,
> +				     int param_size)
> +{
> +	static const char default_cmdline[] = CONFIG_CMDLINE;
> +	const char *p;
> +
> +	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline != NULL) {
> +		p = __strstr(cmdline, param, param_size);
> +		if (p == cmdline ||
> +		    (p > cmdline && *(p - 1) == ' '))
> +			return p;
> +	}
> +
> +	if (IS_ENABLED(CONFIG_CMDLINE_FORCE)  ||
> +	    IS_ENABLED(CONFIG_CMDLINE_EXTEND)) {
> +		p = __strstr(default_cmdline, param, param_size);
> +		if (p == default_cmdline ||
> +		    (p > default_cmdline && *(p - 1) == ' '))
> +			return p;
> +	}
> +	return NULL;
> +}
> +
> +u32 kaslr_early_init(u32 *kaslr_offset, u32 image_base, u32 image_size,
> +		     u32 seed, u32 zimage_start, const void *fdt,
> +		     u32 zimage_end)
> +{
> +	static const char __aligned(4) build_id[] = UTS_VERSION UTS_RELEASE;
> +	struct regions regions;
> +	const char *command_line;
> +	const char *p;
> +	int chosen, len;
> +	u32 lowmem_top, num;
> +
> +	if (fdt_check_header(fdt))
> +		return 0;
> +
> +	chosen = fdt_path_offset(fdt, "/chosen");
> +	if (chosen < 0)
> +		return 0;
> +
> +	command_line = fdt_getprop(fdt, chosen, "bootargs", &len);
> +
> +	/* check the command line for the presence of 'nokaslr' */
> +	p = get_cmdline_param(command_line, "nokaslr", sizeof("nokaslr") - 1);
> +	if (p != NULL)
> +		return 0;
> +
> +	/* check the command line for the presence of 'vmalloc=' */
> +	p = get_cmdline_param(command_line, "vmalloc=", sizeof("vmalloc=") - 1);
> +	if (p != NULL)
> +		lowmem_top = VMALLOC_END - __memparse(p + 8, NULL) -
> +			     VMALLOC_OFFSET;
> +	else
> +		lowmem_top = VMALLOC_DEFAULT_BASE;
> +
> +	regions.image_size = round_up(image_size, SZ_2M);
> +	regions.pa_start = round_down(image_base, SZ_128M);
> +	regions.pa_end = lowmem_top - PAGE_OFFSET + regions.pa_start -
> +			 regions.image_size;
> +	regions.zimage_start = zimage_start;
> +	regions.zimage_size = zimage_end - zimage_start;
> +	regions.dtb_start = (u32)fdt;
> +	regions.dtb_size = fdt_totalsize(fdt);
> +
> +	/*
> +	 * Stir up the seed a bit by taking the CRC of the DTB:
> +	 * hopefully there's a /chosen/kaslr-seed in there.
> +	 */
> +	seed = __crc16(seed, fdt, regions.dtb_size);
> +
> +	/* stir a bit more using data that changes between builds */
> +	seed = __crc16(seed, (u32 *)build_id, sizeof(build_id));
> +
> +	/* check for initrd on the command line */
> +	regions.initrd_start = regions.initrd_size = 0;
> +	p = get_cmdline_param(command_line, "initrd=", sizeof("initrd=") - 1);
> +	if (p != NULL) {
> +		regions.initrd_start = __memparse(p + 7, &p);
> +		if (*p++ == ',')
> +			regions.initrd_size = __memparse(p, NULL);
> +		if (regions.initrd_size == 0)
> +			regions.initrd_start = 0;
> +	}
> +
> +	/* ... or in /chosen */
> +	if (regions.initrd_size == 0) {
> +		const fdt32_t *prop;
> +		u64 start = 0, end = 0;
> +
> +		prop = fdt_getprop(fdt, chosen, "linux,initrd-start", &len);
> +		if (prop) {
> +			start = fdt32_to_cpu(prop[0]);
> +			if (len == 8)
> +				start = (start << 32) | fdt32_to_cpu(prop[1]);
> +		}
> +
> +		prop = fdt_getprop(fdt, chosen, "linux,initrd-end", &len);
> +		if (prop) {
> +			end = fdt32_to_cpu(prop[0]);
> +			if (len == 8)
> +				end = (end << 32) | fdt32_to_cpu(prop[1]);
> +		}
> +		if (start != 0 && end != 0 && start < U32_MAX) {
> +			regions.initrd_start = start;
> +			regions.initrd_size = max_t(u64, end, U32_MAX) - start;
> +		}
> +	}
> +
> +	/* check the memory nodes for the size of the lowmem region */
> +	regions.pa_end = min(regions.pa_end, get_memory_end(fdt));
> +
> +	/* check for a reserved-memory node and record its cell sizes */
> +	regions.reserved_mem = fdt_path_offset(fdt, "/reserved-memory");
> +	if (regions.reserved_mem >= 0)
> +		get_cell_sizes(fdt, regions.reserved_mem,
> +			       &regions.reserved_mem_addr_cells,
> +			       &regions.reserved_mem_size_cells);
> +
> +	/*
> +	 * Iterate over the physical memory range covered by the lowmem region
> +	 * in 2 MB increments, and count each offset at which we don't overlap
> +	 * with any of the reserved regions for the zImage itself, the DTB,
> +	 * the initrd and any regions described as reserved in the device tree.
> +	 * This produces a count, which we will scale by multiplying by a 16-bit
> +	 * random value and shifting right by 16 places.
> +	 * Using this random value, we iterate over the physical memory range
> +	 * again until we counted enough iterations, and return the offset we
> +	 * ended up at.
> +	 */
> +	num = ((u16)seed * count_suitable_regions(fdt, &regions)) >> 16;
> +
> +	*kaslr_offset = get_numbered_region(fdt, &regions, num) -
> +			regions.pa_start;
> +
> +	return *kaslr_offset;
> +}
> -- 
> 2.11.0
> 
> 
