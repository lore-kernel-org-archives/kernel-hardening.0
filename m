MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170815201544.8479-1-ard.biesheuvel@linaro.org>
References: <20170815201544.8479-1-ard.biesheuvel@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 15 Aug 2017 13:29:29 -0700
Message-ID: <CAGXu5jJprvbsa2o_Tazw3XNO1QQQw2d_XcDfzZhkDcXR9BfFew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH] ARM: decompressor: implement autonomous KASLR offset calculation
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 15, 2017 at 1:15 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> This enables KASLR for environments that are not KASLR-aware, or only
> to a limited extent. The decompressor collects information about the
> placement of the zImage, DTB and initrd, and parses the /memory DT
> node and the /memreserve/s and /reserved-memory node, and combines this
> information to select a suitable KASLR offset, and proceeds to decompress
> the kernel at this offset in physical memory. It then invoked the kernel
> proper while passing on this information, so that it can be taken into
> account to create the virtual mapping.
>
> This code shuffles some registers together to create a poor man's seed,
> which will be superseded by the value of /chosen/kaslr-seed if present.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>
> This is a followup to, and applies onto my series 'implement KASLR for ARM'
> sent out yesterday.
>
> As suggested by Nico, it would be useful if the decompressor can autonomously
> enable KASLR randomization, so that is what I tried to implement. I left a
> couple of TODOs in there, but the general approach should be visible. It ends
> up iterating over the memreserves and /reserved-mem subnodes twice for each
> candidate region, once for counting them, and again to retrieve the selection
> region. I don't think there's a performance concern here, but there is some
> room for optimization.
>
> Comments welcome.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
>
>  arch/arm/boot/compressed/Makefile |   8 +-
>  arch/arm/boot/compressed/head.S   |  29 ++
>  arch/arm/boot/compressed/kaslr.c  | 337 ++++++++++++++++++++
>  3 files changed, 373 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index d50430c40045..771b1ba1baa3 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -85,8 +85,14 @@ $(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/
>  $(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
>         $(addprefix $(obj)/,$(libfdt_hdrs))
>
> +ifneq ($(CONFIG_ARM_ATAG_DTB_COMPAT)$(CONFIG_RANDOMIZE_BASE),)
> +OBJS   += $(libfdt_objs)
>  ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
> -OBJS   += $(libfdt_objs) atags_to_fdt.o
> +OBJS   += atags_to_fdt.o
> +endif
> +ifeq ($(CONFIG_RANDOMIZE_BASE),y)
> +OBJS   += kaslr.o
> +endif
>  endif
>
>  targets       := vmlinux vmlinux.lds piggy_data piggy.o \
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 7111a2cbef95..769ed959604d 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -382,6 +382,35 @@ restart:   adr     r0, LC0
>  dtb_check_done:
>  #endif
>
> +#ifdef CONFIG_RANDOMIZE_BASE
> +               ldr_l   r1, kaslr_offset
> +               cmp     r1, #0
> +               bne     0f                      @ skip if kaslr_offset > 0
> +               stmfd   sp!, {r0-r3, ip, lr}
> +
> +               adr_l   r2, _text               @ start of zImage
> +               stmfd   sp!, {r2, r10}          @ pass start and size of zImage
> +
> +               eor     r3, r0, r3, ror #1      @ poor man's kaslr seed, will
> +               eor     r3, r3, r1, ror #2      @ be superseded by kaslr-seed
> +               eor     r3, r3, r2, ror #3      @ from /chosen if present
> +               eor     r3, r3, r4, ror #5
> +               eor     r3, r3, r5, ror #8
> +               eor     r3, r3, r6, ror #13
> +               eor     r3, r3, r7, ror #21
> +
> +               mov     r0, r8                  @ pass DTB address
> +               mov     r1, r4                  @ pass base address
> +               mov     r2, r9                  @ pass decompressed image size
> +               bl      kaslr_early_init
> +               add     sp, sp, #8
> +               cmp     r0, #0
> +               addne   r4, r4, r0              @ add offset to base address
> +               ldmfd   sp!, {r0-r3, ip, lr}
> +               bne     restart
> +0:
> +#endif
> +
>  /*
>   * Check to see if we will overwrite ourselves.
>   *   r4  = final kernel address (possibly with LSB set)
> diff --git a/arch/arm/boot/compressed/kaslr.c b/arch/arm/boot/compressed/kaslr.c
> new file mode 100644
> index 000000000000..a6fd2fefc04a
> --- /dev/null
> +++ b/arch/arm/boot/compressed/kaslr.c
> @@ -0,0 +1,337 @@
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
> +
> +#include <asm/pgtable.h>
> +#include <asm/zimage.h>
> +
> +struct regions {
> +       u32 pa_start;
> +       u32 pa_end;
> +       u32 image_size;
> +       u32 zimage_start;
> +       u32 zimage_size;
> +       u32 initrd_start;
> +       u32 initrd_size;
> +       u32 dtb_start;
> +       u32 dtb_size;
> +       int reserved_mem;
> +};
> +
> +static const char default_cmdline[] = CONFIG_CMDLINE;
> +
> +static const char *get_command_line(const void *fdt, int chosen)
> +{
> +       const char *prop;
> +       int len;
> +
> +       prop = fdt_getprop(fdt, chosen, "bootargs", &len);
> +
> +       if (IS_ENABLED(CONFIG_CMDLINE_EXTEND)) {
> +               if (!prop)
> +                       return default_cmdline;
> +
> +               /* TODO merge with hardcoded cmdline */
> +       }
> +       return prop;
> +}
> +
> +static u32 __memparse(const char *val, const char **retptr)
> +{
> +       const char *p = val;
> +       u32 ret = 0;
> +       int base;
> +
> +       if (*p == '0') {
> +               p++;
> +               if (*p == 'x' || *p == 'X') {
> +                       p++;
> +                       base = 16;
> +               } else {
> +                       base = 8;
> +               }
> +       } else {
> +               base = 10;
> +       }
> +
> +       while (*val != ',' && *val != ' ' && *val != '\0') {
> +               char c = *val++;
> +
> +               switch (c) {
> +               case '0' ... '9':
> +                       ret = ret * base + (c - '0');
> +                       continue;
> +               case 'a' ... 'f':
> +                       ret = ret * base + (c - 'a' + 10);
> +                       continue;
> +               case 'A' ... 'F':
> +                       ret = ret * base + (c - 'A' + 10);
> +                       continue;
> +               case 'g':
> +               case 'G':
> +                       ret <<= 10;
> +               case 'm':
> +               case 'M':
> +                       ret <<= 10;
> +               case 'k':
> +               case 'K':
> +                       ret <<= 10;
> +                       break;
> +               default:
> +                       if (retptr)
> +                               *retptr = NULL;
> +                       return 0;
> +               }
> +       }
> +       if (retptr)
> +               *retptr = val;
> +       return ret;
> +}
> +
> +static bool regions_intersect(u32 s1, u32 e1, u32 s2, u32 e2)
> +{
> +       return e1 >= s2 && e2 >= s1;
> +}
> +
> +static bool intersects_occupied_region(const void *fdt, u32 start,
> +                                      u32 end, struct regions *regions)
> +{
> +       int i;
> +
> +       if (regions_intersect(start, end, regions->zimage_start,
> +                             regions->zimage_start + regions->zimage_size))
> +               return true;
> +
> +       if (regions_intersect(start, end, regions->initrd_start,
> +                             regions->initrd_start + regions->initrd_size))
> +               return true;
> +
> +       if (regions_intersect(start, end, regions->dtb_start,
> +                             regions->dtb_start + regions->dtb_size))
> +               return true;
> +
> +       for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
> +               u64 base, size;
> +
> +               if (fdt_get_mem_rsv(fdt, i, &base, &size) < 0)
> +                       continue;
> +               if (regions_intersect(start, end, base, base + size))
> +                       return true;
> +       }
> +
> +       if (regions->reserved_mem != -FDT_ERR_NOTFOUND) {
> +               int subnode;
> +
> +               for (subnode = fdt_first_subnode(fdt, regions->reserved_mem);
> +                    subnode != -FDT_ERR_NOTFOUND;
> +                    subnode = fdt_next_subnode(fdt, subnode)) {
> +                       const void *prop;
> +
> +                       prop = fdt_getprop(fdt, subnode, "reg", NULL);
> +                       if (!prop)
> +                               continue;
> +
> +                       /* TODO check for overlap */
> +               }
> +       }
> +       return false;
> +}
> +
> +static u32 count_suitable_regions(const void *fdt, struct regions *regions)
> +{
> +       u32 pa, ret = 0;
> +
> +       for (pa = regions->pa_start; pa < regions->pa_end; pa += SZ_2M) {
> +               if (!intersects_occupied_region(fdt, pa,
> +                                               pa + regions->image_size,
> +                                               regions))
> +                       ret++;
> +       }
> +       return ret;
> +}
> +
> +static u32 get_numbered_region(const void *fdt,
> +                                        struct regions *regions,
> +                                        int num)
> +{
> +       u32 pa;
> +
> +       for (pa = regions->pa_start; pa < regions->pa_end; pa += SZ_2M) {
> +               if (!intersects_occupied_region(fdt, pa,
> +                                               pa + regions->image_size,
> +                                               regions))
> +                       if (num-- == 0)
> +                               return pa;
> +       }
> +       return regions->pa_start; /* should not happen */
> +}
> +
> +static u32 get_memory_end(const void *fdt)
> +{
> +       int mem_node, address_cells, size_cells, len;
> +       const unsigned char *reg;
> +       const int *prop;
> +       u64 memory_end = 0;
> +
> +       /* Look for a node called "memory" at the lowest level of the tree */
> +       mem_node = fdt_path_offset (fdt, "/memory");
> +       if (mem_node <= 0)
> +               return 0;
> +
> +       /*
> +        * Retrieve the #address-cells and #size-cells properties
> +        * from the root node, or use the default if not provided.
> +        */
> +       address_cells = 1;
> +       size_cells = 1;
> +
> +       prop = fdt_getprop (fdt, 0, "#address-cells", &len);
> +       if (len == 4)
> +               address_cells = fdt32_to_cpu (*prop);
> +       prop = fdt_getprop (fdt, 0, "#size-cells", &len);
> +       if (len == 4)
> +               size_cells = fdt32_to_cpu (*prop);
> +
> +       /*
> +        * Now find the 'reg' property of the /memory node, and iterate over
> +        * the base/size pairs.
> +        */
> +       reg = fdt_getprop (fdt, mem_node, "reg", &len);
> +       while (len >= 4 * (address_cells + size_cells)) {
> +               u64 base, size;
> +
> +               if (address_cells == 1) {
> +                       base = fdt32_to_cpu(*(fdt32_t *)reg);
> +                       reg += 4;
> +                       len -= 4;
> +               } else { /* assume address_cells == 2 */
> +                       base = fdt64_to_cpu(*(fdt64_t *)reg);
> +                       reg += 8;
> +                       len -= 8;
> +               }
> +               if (size_cells == 1) {
> +                       size = fdt32_to_cpu(*(fdt32_t *)reg);
> +                       reg += 4;
> +                       len -= 4;
> +               } else { /* assume size_cells == 2 */
> +                       size = fdt64_to_cpu(*(fdt64_t *)reg);
> +                       reg += 8;
> +                       len -= 8;
> +               }
> +
> +               memory_end = max(memory_end, base + size);
> +       }
> +       return min(memory_end, (u64)U32_MAX);
> +}
> +
> +u32 kaslr_early_init(const void *fdt, u32 image_base, u32 image_size, u32 seed,
> +                    u32 zimage_start, u32 zimage_end)
> +{
> +       struct regions regions;
> +       const char *command_line;
> +       const void *prop;
> +       const char *p;
> +       int chosen, len;
> +       u32 lowmem_top, num;
> +
> +       if (fdt_check_header(fdt))
> +               return 0;
> +
> +       regions.pa_start = round_down(image_base, SZ_128M);
> +
> +       regions.dtb_start = (u32)fdt;
> +       regions.dtb_size = fdt_totalsize(fdt);
> +
> +       regions.zimage_start = zimage_start;
> +       regions.zimage_size = zimage_end - zimage_start;
> +
> +       chosen = fdt_path_offset(fdt, "/chosen");
> +       if (chosen == -FDT_ERR_NOTFOUND)
> +               return 0;
> +
> +       /* check for the presence of /chosen/kaslr-seed */
> +       prop = fdt_getprop(fdt, chosen, "kaslr-seed", &len);
> +       if (prop)
> +               seed = *(u32 *)prop;

Without kaslr-seed, perhaps also include build-time entropy (as I did
in x86's decompressor with build_str):

static unsigned long get_boot_seed(void)
{
        unsigned long hash = 0;

        hash = rotate_xor(hash, build_str, sizeof(build_str));
        hash = rotate_xor(hash, boot_params, sizeof(*boot_params));

        return hash;
}

You're effectively starting with hash == r3. This could be further
enhanced with a __latent_entropy string when that plugin is enabled:

static u8 compile_time_entropy[32] __latent_entropy;

...

seed = rotate_xor(seed, compile_time_entropy, sizeof(compile_time_entropy));

And toss in the fdt too? (I have no idea if this is the correct way to
do this....)

seed = rotate_xor(seed, fdt, fdt_totalsize(fdt));

> +
> +       if (!IS_ENABLED(CONFIG_CMDLINE_FORCE))
> +               command_line = get_command_line(fdt, chosen);
> +
> +       if (!command_line)
> +               command_line = default_cmdline;
> +
> +       /* check the command line for the presence of 'nokaslr' */
> +       p = strstr(command_line, "nokaslr");
> +       if (p == command_line || (p > command_line && *(p - 1) == ' '))
> +               return 0;
> +
> +       /* check the command line for the presence of 'vmalloc=' */
> +       p = strstr(command_line, "vmalloc=");
> +       if (p == command_line || (p > command_line && *(p - 1) == ' '))
> +               lowmem_top = VMALLOC_END - __memparse(p + 8, NULL) -
> +                            VMALLOC_OFFSET;
> +       else
> +               lowmem_top = VMALLOC_DEFAULT_BASE;
> +
> +       regions.pa_end = lowmem_top - PAGE_OFFSET + regions.pa_start;
> +
> +       /* check for initrd on the command line */
> +       regions.initrd_start = regions.initrd_size = 0;
> +       p = strstr(command_line, "initrd=");
> +       if (p == command_line || (p > command_line && *(p - 1) == ' ')) {
> +               regions.initrd_start = __memparse(p + 7, &p);
> +               if (*p++ == ',')
> +                       regions.initrd_size = __memparse(p, NULL);
> +               if (regions.initrd_size == 0)
> +                       regions.initrd_start = 0;
> +       }
> +
> +       /* ... or in /chosen */
> +       if (regions.initrd_size == 0) {
> +               prop = fdt_getprop(fdt, chosen, "linux,initrd-start", &len);
> +               if (prop)
> +                       regions.initrd_start = (len == 4) ?
> +                                              fdt32_to_cpu(*(fdt32_t *)prop) :
> +                                              fdt32_to_cpu(*(fdt64_t *)prop);
> +
> +               prop = fdt_getprop(fdt, chosen, "linux,initrd-end", &len);
> +               if (prop) {
> +                       regions.initrd_size = (len == 4) ?
> +                                             fdt32_to_cpu(*(fdt32_t *)prop) :
> +                                             fdt32_to_cpu(*(fdt64_t *)prop);
> +                       regions.initrd_size -= regions.initrd_start;
> +               }
> +       }
> +
> +       /* check the memory nodes for the size of the lowmem region */
> +       regions.pa_end = min(regions.pa_end, get_memory_end(fdt));
> +
> +       regions.reserved_mem = fdt_path_offset(fdt, "/reserved-memory");
> +       regions.image_size = round_up(image_size, SZ_2M);
> +
> +       /*
> +        * Iterate over the physical memory range covered by the lowmem region
> +        * in 2 MB increments, and count each offset at which we don't overlap
> +        * with any of the reserved regions for the zImage itself, the DTB,
> +        * the initrd and any regions described as reserved in the device tree.
> +        * This produces a count, which we will scale by multiplying by a 16-bit
> +        * random value and shifting right by 16 places.
> +        * Using this random value, we iterate over the physical memory range
> +        * again until we counted enough iterations, and return the offset we
> +        * ended up at.
> +        */
> +       num = ((u16)seed * count_suitable_regions(fdt, &regions)) >> 16;
> +
> +       kaslr_offset = get_numbered_region(fdt, &regions, num) -
> +                      regions.pa_start;
> +
> +       return kaslr_offset;
> +}
> --
> 2.11.0
>



-- 
Kees Cook
Pixel Security
