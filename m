Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Jan 2016 16:55:20 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160122165517.GD11645@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-9-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452518355-4606-9-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v3 08/21] arm64: add support for module PLTs
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

This looks good.

My comments below are mostly nits, and much of the rest probably betrays
my lack of familiarity with ELF.

On Mon, Jan 11, 2016 at 02:19:01PM +0100, Ard Biesheuvel wrote:
> This adds support for emitting PLTs at module load time for relative
> branches that are out of range. This is a prerequisite for KASLR, which
> may place the kernel and the modules anywhere in the vmalloc area,
> making it more likely that branch target offsets exceed the maximum
> range of +/- 128 MB.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/Kconfig              |   9 ++
>  arch/arm64/Makefile             |   6 +-
>  arch/arm64/include/asm/module.h |  11 ++
>  arch/arm64/kernel/Makefile      |   1 +
>  arch/arm64/kernel/module-plts.c | 137 ++++++++++++++++++++
>  arch/arm64/kernel/module.c      |  12 ++
>  arch/arm64/kernel/module.lds    |   4 +
>  7 files changed, 179 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index ffa3c549a4ba..778df20bf623 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -363,6 +363,7 @@ config ARM64_ERRATUM_843419
>  	bool "Cortex-A53: 843419: A load or store might access an incorrect address"
>  	depends on MODULES
>  	default y
> +	select ARM64_MODULE_CMODEL_LARGE
>  	help
>  	  This option builds kernel modules using the large memory model in
>  	  order to avoid the use of the ADRP instruction, which can cause
> @@ -702,6 +703,14 @@ config ARM64_LSE_ATOMICS
>  
>  endmenu
>  
> +config ARM64_MODULE_CMODEL_LARGE
> +	bool
> +
> +config ARM64_MODULE_PLTS
> +	bool
> +	select ARM64_MODULE_CMODEL_LARGE
> +	select HAVE_MOD_ARCH_SPECIFIC
> +
>  endmenu
>  
>  menu "Boot options"
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index cd822d8454c0..db462980c6be 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -41,10 +41,14 @@ endif
>  
>  CHECKFLAGS	+= -D__aarch64__
>  
> -ifeq ($(CONFIG_ARM64_ERRATUM_843419), y)
> +ifeq ($(CONFIG_ARM64_MODULE_CMODEL_LARGE), y)
>  KBUILD_CFLAGS_MODULE	+= -mcmodel=large
>  endif
>  
> +ifeq ($(CONFIG_ARM64_MODULE_PLTS),y)
> +KBUILD_LDFLAGS_MODULE	+= -T $(srctree)/arch/arm64/kernel/module.lds
> +endif
> +
>  # Default value
>  head-y		:= arch/arm64/kernel/head.o
>  
> diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
> index e80e232b730e..7b8cd3dc9d8e 100644
> --- a/arch/arm64/include/asm/module.h
> +++ b/arch/arm64/include/asm/module.h
> @@ -20,4 +20,15 @@
>  
>  #define MODULE_ARCH_VERMAGIC	"aarch64"
>  
> +#ifdef CONFIG_ARM64_MODULE_PLTS
> +struct mod_arch_specific {
> +	struct elf64_shdr	*core_plt;
> +	struct elf64_shdr	*init_plt;
> +	int			core_plt_count;
> +	int			init_plt_count;
> +};
> +#endif
> +
> +u64 get_module_plt(struct module *mod, void *loc, u64 val);
> +
>  #endif /* __ASM_MODULE_H */
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 474691f8b13a..f42b0fff607f 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -30,6 +30,7 @@ arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
>  					   ../../arm/kernel/opcodes.o
>  arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
>  arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
> +arm64-obj-$(CONFIG_ARM64_MODULE_PLTS)	+= module-plts.o
>  arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o
>  arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
>  arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
> diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
> new file mode 100644
> index 000000000000..4a8ef9ea01ee
> --- /dev/null
> +++ b/arch/arm64/kernel/module-plts.c
> @@ -0,0 +1,137 @@
> +/*
> + * Copyright (C) 2014-2015 Linaro Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/elf.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +struct plt_entry {
> +	__le32	mov0;	/* movn	x16, #0x....			*/
> +	__le32	mov1;	/* movk	x16, #0x...., lsl #16		*/
> +	__le32	mov2;	/* movk	x16, #0x...., lsl #32		*/
> +	__le32	br;	/* br	x16				*/
> +} __aligned(8);

We only need natural alignment for the instructions, so what's the
alignment for? I can't see that anything else cares.

It might be worth a comment regarding why why use x16 (i.e. because the
AAPCS says that as IP0 it is valid for veneers/PLTs to clobber).

> +static bool in_init(const struct module *mod, void *addr)
> +{
> +	return (u64)addr - (u64)mod->module_init < mod->init_size;
> +}
> +
> +u64 get_module_plt(struct module *mod, void *loc, u64 val)
> +{
> +	struct plt_entry entry = {
> +		cpu_to_le32(0x92800010 | (((~val      ) & 0xffff)) << 5),
> +		cpu_to_le32(0xf2a00010 | ((( val >> 16) & 0xffff)) << 5),
> +		cpu_to_le32(0xf2c00010 | ((( val >> 32) & 0xffff)) << 5),
> +		cpu_to_le32(0xd61f0200)
> +	}, *plt;

It would be nice if we could un-magic this, though I see that reusing
the existing insn or reloc_insn code is painful here.

> +	int i, *count;
> +
> +	if (in_init(mod, loc)) {
> +		plt = (struct plt_entry *)mod->arch.init_plt->sh_addr;
> +		count = &mod->arch.init_plt_count;
> +	} else {
> +		plt = (struct plt_entry *)mod->arch.core_plt->sh_addr;
> +		count = &mod->arch.core_plt_count;
> +	}
> +
> +	/* Look for an existing entry pointing to 'val' */
> +	for (i = 0; i < *count; i++)
> +		if (plt[i].mov0 == entry.mov0 &&
> +		    plt[i].mov1 == entry.mov1 &&
> +		    plt[i].mov2 == entry.mov2)
> +			return (u64)&plt[i];

I think that at the cost of redundantly comparing the br x16, you could
simplify this by comparing the whole struct, e.g.

	for (i = 0; i < *count; i++)
		if (plt[i] == entry)
			return (u64)&plt[i];

Which would also work if we change the veneer for some reason.

> +
> +	i = (*count)++;

given i == *count at the end of the loop, you could just increment
*count here.

> +	plt[i] = entry;
> +	return (u64)&plt[i];
> +}
> +
> +static int duplicate_rel(Elf64_Addr base, const Elf64_Rela *rela, int num)

Perhaps: static bool is_duplicate_rel

> +{
> +	int i;
> +
> +	for (i = 0; i < num; i++) {
> +		if (rela[i].r_info == rela[num].r_info &&
> +		    rela[i].r_addend == rela[num].r_addend)
> +			return 1;
> +	}
> +	return 0;
> +}
> +
> +/* Count how many PLT entries we may need */
> +static unsigned int count_plts(Elf64_Addr base, const Elf64_Rela *rela, int num)
> +{
> +	unsigned int ret = 0;
> +	int i;
> +
> +	/*
> +	 * Sure, this is order(n^2), but it's usually short, and not
> +	 * time critical
> +	 */
> +	for (i = 0; i < num; i++)
> +		switch (ELF64_R_TYPE(rela[i].r_info)) {
> +		case R_AARCH64_JUMP26:
> +		case R_AARCH64_CALL26:
> +			if (!duplicate_rel(base, rela, i))
> +				ret++;
> +			break;
> +		}

While braces aren't strictly required on the for loop, i think it would
look better with them given the contained logic is non-trivial.

> +	return ret;
> +}
> +
> +int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
> +			      char *secstrings, struct module *mod)
> +{
> +	unsigned long core_plts = 0, init_plts = 0;
> +	Elf64_Shdr *s, *sechdrs_end = sechdrs + ehdr->e_shnum;
> +
> +	/*
> +	 * To store the PLTs, we expand the .text section for core module code
> +	 * and the .init.text section for initialization code.
> +	 */

That comment is a bit misleading, given we don't touch .text and
.init.text, but rather .core.plt and .init.plt, relying on
layout_sections to group those with .text and .init.text.

> +	for (s = sechdrs; s < sechdrs_end; ++s)
> +		if (strcmp(".core.plt", secstrings + s->sh_name) == 0)
> +			mod->arch.core_plt = s;
> +		else if (strcmp(".init.plt", secstrings + s->sh_name) == 0)
> +			mod->arch.init_plt = s;

This would be nicer with braces.

> +
> +	if (!mod->arch.core_plt || !mod->arch.init_plt) {
> +		pr_err("%s: sections missing\n", mod->name);
> +		return -ENOEXEC;
> +	}
> +
> +	for (s = sechdrs + 1; s < sechdrs_end; ++s) {

Could we have a comment as to why we skip the first Shdr? I recall it's
in some way special, but I can't recall why/how.

> +		const Elf64_Rela *rels = (void *)ehdr + s->sh_offset;
> +		int numrels = s->sh_size / sizeof(Elf64_Rela);
> +		Elf64_Shdr *dstsec = sechdrs + s->sh_info;
> +
> +		if (s->sh_type != SHT_RELA)
> +			continue;

We only have RELA, and no REL?

Thanks,
Mark.

> +
> +		if (strstr(secstrings + s->sh_name, ".init"))
> +			init_plts += count_plts(dstsec->sh_addr, rels, numrels);
> +		else
> +			core_plts += count_plts(dstsec->sh_addr, rels, numrels);
> +	}
> +
> +	mod->arch.core_plt->sh_type = SHT_NOBITS;
> +	mod->arch.core_plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
> +	mod->arch.core_plt->sh_addralign = L1_CACHE_BYTES;
> +	mod->arch.core_plt->sh_size = core_plts * sizeof(struct plt_entry);
> +	mod->arch.core_plt_count = 0;
> +
> +	mod->arch.init_plt->sh_type = SHT_NOBITS;
> +	mod->arch.init_plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
> +	mod->arch.init_plt->sh_addralign = L1_CACHE_BYTES;
> +	mod->arch.init_plt->sh_size = init_plts * sizeof(struct plt_entry);
> +	mod->arch.init_plt_count = 0;
> +	pr_debug("%s: core.plt=%lld, init.plt=%lld\n", __func__,
> +		 mod->arch.core_plt->sh_size, mod->arch.init_plt->sh_size);
> +	return 0;
> +}
> diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
> index 93e970231ca9..3a298b0e21bb 100644
> --- a/arch/arm64/kernel/module.c
> +++ b/arch/arm64/kernel/module.c
> @@ -38,6 +38,11 @@ void *module_alloc(unsigned long size)
>  				GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
>  				NUMA_NO_NODE, __builtin_return_address(0));
>  
> +	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
> +		p = __vmalloc_node_range(size, MODULE_ALIGN, VMALLOC_START,
> +				VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
> +				NUMA_NO_NODE, __builtin_return_address(0));
> +
>  	if (p && (kasan_module_alloc(p, size) < 0)) {
>  		vfree(p);
>  		return NULL;
> @@ -361,6 +366,13 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  		case R_AARCH64_CALL26:
>  			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 26,
>  					     AARCH64_INSN_IMM_26);
> +
> +			if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
> +			    ovf == -ERANGE) {
> +				val = get_module_plt(me, loc, val);
> +				ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2,
> +						     26, AARCH64_INSN_IMM_26);
> +			}
>  			break;
>  
>  		default:
> diff --git a/arch/arm64/kernel/module.lds b/arch/arm64/kernel/module.lds
> new file mode 100644
> index 000000000000..3682fa107918
> --- /dev/null
> +++ b/arch/arm64/kernel/module.lds
> @@ -0,0 +1,4 @@
> +SECTIONS {
> +        .core.plt : { BYTE(0) }
> +        .init.plt : { BYTE(0) }
> +}
> -- 
> 2.5.0
> 
