Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1451489172-17420-13-git-send-email-ard.biesheuvel@linaro.org>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451489172-17420-13-git-send-email-ard.biesheuvel@linaro.org>
Date: Tue, 5 Jan 2016 11:51:46 -0800
Message-ID: <CAGXu5jJzvfof=Hj4Ei8Q2Sa+VG08_7dSc64Hn5FP2D=2RmW5zA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 12/13] arm64: add support for relocatable kernel
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, LKML <linux-kernel@vger.kernel.org>, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 30, 2015 at 7:26 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> This adds support for runtime relocation of the kernel Image, by
> building it as a PIE (ET_DYN) executable and applying the dynamic
> relocations in the early boot code.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/arm64/booting.txt |  3 +-
>  arch/arm64/Kconfig              | 13 ++++
>  arch/arm64/Makefile             |  6 +-
>  arch/arm64/include/asm/memory.h |  3 +
>  arch/arm64/kernel/head.S        | 75 +++++++++++++++++++-
>  arch/arm64/kernel/setup.c       | 22 +++---
>  arch/arm64/kernel/vmlinux.lds.S |  9 +++
>  scripts/sortextable.c           |  4 +-
>  8 files changed, 117 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> index 03e02ebc1b0c..b17181eb4a43 100644
> --- a/Documentation/arm64/booting.txt
> +++ b/Documentation/arm64/booting.txt
> @@ -109,7 +109,8 @@ Header notes:
>                         1 - 4K
>                         2 - 16K
>                         3 - 64K
> -  Bits 3-63:   Reserved.
> +  Bit 3:       Relocatable kernel.
> +  Bits 4-63:   Reserved.
>
>  - When image_size is zero, a bootloader should attempt to keep as much
>    memory as possible free for use by the kernel immediately after the
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 54eeab140bca..f458fb9e0dce 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -363,6 +363,7 @@ config ARM64_ERRATUM_843419
>         bool "Cortex-A53: 843419: A load or store might access an incorrect address"
>         depends on MODULES
>         default y
> +       select ARM64_MODULE_CMODEL_LARGE
>         help
>           This option builds kernel modules using the large memory model in
>           order to avoid the use of the ADRP instruction, which can cause
> @@ -709,6 +710,18 @@ config ARM64_MODULE_PLTS
>         bool
>         select HAVE_MOD_ARCH_SPECIFIC
>
> +config ARM64_MODULE_CMODEL_LARGE
> +       bool
> +
> +config ARM64_RELOCATABLE_KERNEL

Should this be called "CONFIG_RELOCATABLE" instead, just to keep
naming the same across x86, powerpw, and arm64?

> +       bool "Kernel address space layout randomization (KASLR)"

Strictly speaking, this enables KASLR, but doesn't provide it,
correct? It still relies on the boot loader for the randomness?

> +       select ARM64_MODULE_PLTS
> +       select ARM64_MODULE_CMODEL_LARGE
> +       help
> +         This feature randomizes the virtual address of the kernel image, to
> +         harden against exploits that rely on knowledge about the absolute
> +         addresses of certain kernel data structures.
> +
>  endmenu
>
>  menu "Boot options"
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index d4654830e536..75dc477d45f5 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -15,6 +15,10 @@ CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
>  OBJCOPYFLAGS   :=-O binary -R .note -R .note.gnu.build-id -R .comment -S
>  GZFLAGS                :=-9
>
> +ifneq ($(CONFIG_ARM64_RELOCATABLE_KERNEL),)
> +LDFLAGS_vmlinux                += -pie
> +endif
> +
>  KBUILD_DEFCONFIG := defconfig
>
>  # Check for binutils support for specific extensions
> @@ -41,7 +45,7 @@ endif
>
>  CHECKFLAGS     += -D__aarch64__
>
> -ifeq ($(CONFIG_ARM64_ERRATUM_843419), y)
> +ifeq ($(CONFIG_ARM64_MODULE_CMODEL_LARGE), y)
>  KBUILD_CFLAGS_MODULE   += -mcmodel=large
>  endif
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 557228658666..afab3e669e19 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -121,6 +121,9 @@ extern phys_addr_t          memstart_addr;
>  /* PHYS_OFFSET - the physical address of the start of memory. */
>  #define PHYS_OFFSET            ({ memstart_addr; })
>
> +/* the virtual base of the kernel image (minus TEXT_OFFSET) */
> +extern u64                     kimage_vaddr;
> +
>  /* the offset between the kernel virtual and physical mappings */
>  extern u64                     kimage_voffset;
>
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 01a33e42ed70..ab582ee58b58 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -59,8 +59,15 @@
>
>  #define __HEAD_FLAG_PAGE_SIZE ((PAGE_SHIFT - 10) / 2)
>
> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
> +#define __HEAD_FLAG_RELOC      1
> +#else
> +#define __HEAD_FLAG_RELOC      0
> +#endif
> +
>  #define __HEAD_FLAGS   ((__HEAD_FLAG_BE << 0) |        \
> -                        (__HEAD_FLAG_PAGE_SIZE << 1))
> +                        (__HEAD_FLAG_PAGE_SIZE << 1) | \
> +                        (__HEAD_FLAG_RELOC << 3))
>
>  /*
>   * Kernel startup entry point.
> @@ -231,6 +238,9 @@ ENTRY(stext)
>          */
>         ldr     x27, 0f                         // address to jump to after
>                                                 // MMU has been enabled
> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
> +       add     x27, x27, x23                   // add KASLR displacement
> +#endif
>         adr_l   lr, __enable_mmu                // return (PIC) address
>         b       __cpu_setup                     // initialise processor
>  ENDPROC(stext)
> @@ -243,6 +253,16 @@ ENDPROC(stext)
>  preserve_boot_args:
>         mov     x21, x0                         // x21=FDT
>
> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
> +       /*
> +        * Mask off the bits of the random value supplied in x1 so it can serve
> +        * as a KASLR displacement value which will move the kernel image to a
> +        * random offset in the lower half of the VMALLOC area.
> +        */
> +       mov     x23, #(1 << (VA_BITS - 2)) - 1
> +       and     x23, x23, x1, lsl #SWAPPER_BLOCK_SHIFT
> +#endif
> +
>         adr_l   x0, boot_args                   // record the contents of
>         stp     x21, x1, [x0]                   // x0 .. x3 at kernel entry
>         stp     x2, x3, [x0, #16]
> @@ -402,6 +422,9 @@ __create_page_tables:
>          */
>         mov     x0, x26                         // swapper_pg_dir
>         ldr     x5, =KIMAGE_VADDR
> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
> +       add     x5, x5, x23                     // add KASLR displacement
> +#endif
>         create_pgd_entry x0, x5, x3, x6
>         ldr     w6, kernel_img_size
>         add     x6, x6, x5
> @@ -443,10 +466,52 @@ __mmap_switched:
>         str     xzr, [x6], #8                   // Clear BSS
>         b       1b
>  2:
> +
> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
> +
> +#define R_AARCH64_RELATIVE     0x403
> +#define R_AARCH64_ABS64                0x101
> +
> +       /*
> +        * Iterate over each entry in the relocation table, and apply the
> +        * relocations in place.
> +        */
> +       adr_l   x8, __dynsym_start              // start of symbol table
> +       adr_l   x9, __reloc_start               // start of reloc table
> +       adr_l   x10, __reloc_end                // end of reloc table
> +
> +0:     cmp     x9, x10
> +       b.hs    2f
> +       ldp     x11, x12, [x9], #24
> +       ldr     x13, [x9, #-8]
> +       cmp     w12, #R_AARCH64_RELATIVE
> +       b.ne    1f
> +       add     x13, x13, x23                   // relocate
> +       str     x13, [x11, x23]
> +       b       0b
> +
> +1:     cmp     w12, #R_AARCH64_ABS64
> +       b.ne    0b
> +       add     x12, x12, x12, lsl #1           // symtab offset: 24x top word
> +       add     x12, x8, x12, lsr #(32 - 3)     // ... shifted into bottom word
> +       ldrsh   w14, [x12, #6]                  // Elf64_Sym::st_shndx
> +       ldr     x15, [x12, #8]                  // Elf64_Sym::st_value
> +       cmp     w14, #-0xf                      // SHN_ABS (0xfff1) ?
> +       add     x14, x15, x23                   // relocate
> +       csel    x15, x14, x15, ne
> +       add     x15, x13, x15
> +       str     x15, [x11, x23]
> +       b       0b
> +
> +2:     adr_l   x8, kimage_vaddr                // make relocated kimage_vaddr
> +       dc      cvac, x8                        // value visible to secondaries
> +       dsb     sy                              // with MMU off
> +#endif
> +
>         adr_l   sp, initial_sp, x4
>         str_l   x21, __fdt_pointer, x5          // Save FDT pointer
>
> -       ldr     x0, =KIMAGE_VADDR               // Save the offset between
> +       ldr_l   x0, kimage_vaddr                // Save the offset between
>         sub     x24, x0, x24                    // the kernel virtual and
>         str_l   x24, kimage_voffset, x0         // physical mappings
>
> @@ -462,6 +527,10 @@ ENDPROC(__mmap_switched)
>   * hotplug and needs to have the same protections as the text region
>   */
>         .section ".text","ax"
> +
> +ENTRY(kimage_vaddr)
> +       .quad           _text - TEXT_OFFSET
> +
>  /*
>   * If we're fortunate enough to boot at EL2, ensure that the world is
>   * sane before dropping to EL1.
> @@ -622,7 +691,7 @@ ENTRY(secondary_startup)
>         adrp    x26, swapper_pg_dir
>         bl      __cpu_setup                     // initialise processor
>
> -       ldr     x8, =KIMAGE_VADDR
> +       ldr     x8, kimage_vaddr
>         ldr     w9, 0f
>         sub     x27, x8, w9, sxtw               // address to jump to after enabling the MMU
>         b       __enable_mmu
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 96177a7c0f05..2faee6042e99 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -292,16 +292,15 @@ u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
>
>  void __init setup_arch(char **cmdline_p)
>  {
> -       static struct vm_struct vmlinux_vm __initdata = {
> -               .addr           = (void *)KIMAGE_VADDR,
> -               .size           = 0,
> -               .flags          = VM_IOREMAP,
> -               .caller         = setup_arch,
> -       };
> -
> -       vmlinux_vm.size = round_up((unsigned long)_end - KIMAGE_VADDR,
> -                                  1 << SWAPPER_BLOCK_SHIFT);
> -       vmlinux_vm.phys_addr = __pa(KIMAGE_VADDR);
> +       static struct vm_struct vmlinux_vm __initdata;
> +
> +       vmlinux_vm.addr = (void *)kimage_vaddr;
> +       vmlinux_vm.size = round_up((u64)_end - kimage_vaddr,
> +                                  SWAPPER_BLOCK_SIZE);
> +       vmlinux_vm.phys_addr = __pa(kimage_vaddr);
> +       vmlinux_vm.flags = VM_IOREMAP;
> +       vmlinux_vm.caller = setup_arch;
> +
>         vm_area_add_early(&vmlinux_vm);
>
>         pr_info("Boot CPU: AArch64 Processor [%08x]\n", read_cpuid_id());
> @@ -367,7 +366,8 @@ void __init setup_arch(char **cmdline_p)
>         conswitchp = &dummy_con;
>  #endif
>  #endif
> -       if (boot_args[1] || boot_args[2] || boot_args[3]) {
> +       if ((!IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL) && boot_args[1]) ||
> +           boot_args[2] || boot_args[3]) {
>                 pr_err("WARNING: x1-x3 nonzero in violation of boot protocol:\n"
>                         "\tx1: %016llx\n\tx2: %016llx\n\tx3: %016llx\n"
>                         "This indicates a broken bootloader or old kernel\n",
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index f935f082188d..cc1486039338 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -148,6 +148,15 @@ SECTIONS
>         .altinstr_replacement : {
>                 *(.altinstr_replacement)
>         }
> +       .rela : ALIGN(8) {
> +               __reloc_start = .;
> +               *(.rela .rela*)
> +               __reloc_end = .;
> +       }
> +       .dynsym : ALIGN(8) {
> +               __dynsym_start = .;
> +               *(.dynsym)
> +       }
>
>         . = ALIGN(PAGE_SIZE);
>         __init_end = .;
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index af247c70fb66..5ecbedefdb0f 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -266,9 +266,9 @@ do_file(char const *const fname)
>                 break;
>         }  /* end switch */
>         if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
> -       ||  r2(&ehdr->e_type) != ET_EXEC
> +       || (r2(&ehdr->e_type) != ET_EXEC && r2(&ehdr->e_type) != ET_DYN)
>         ||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
> -               fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
> +               fprintf(stderr, "unrecognized ET_EXEC/ET_DYN file %s\n", fname);
>                 fail_file();
>         }
>
> --
> 2.5.0
>

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
