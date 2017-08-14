From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 13:53:41 +0100
Message-Id: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 00/30] implement KASLR for ARM
To: kernel-hardening@lists.openwall.com
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This series implements randomization of the placement of the core ARM kernel
inside the lowmem region. It consists of the following parts:

- changes that allow us to build vmlinux as a PIE executable which retains
  the metadata required to fix up all absolute symbol references at runtime
- changes that eliminate absolute references from low-level code that may
  execute with the MMU off: this removes the need to perform explicit cache
  maintenance after the absolute references have been fixed up at runtime with
  the caches enabled
- changes to the core kernel startup code to take the physical offset into
  account when creating the virtual mapping (the pa-to-va mapping remains
  unchanged)
- changes to the decompressor to take the KASLR offset into account when
  placing the kernel in physical memory
- changes to the UEFI stub code to choose the KASLR offset and communicate
  it to the decompressor

Bootloader changes required for other boot environments are left as an
exercise for the reader.

To test these changes, get a UEFI image for QEMU here [0] and boot a
multi_v7_defconfig+CONFIG_RANDOMIZE_BASE=y build using:

qemu-system-aarch64 -M virt -m 2048 -bios QEMU_EFI.fd -kernel zImage \
  -device virtio-rng-pci -net none -nographic -append earlycon

and expect to see something like

[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
[    0.000000]     vmalloc : 0xf0800000 - 0xff800000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf800000 - 0xbfe00000   (   6 MB)
[    0.000000]       .text : 0xd4208000 - 0xd4c00000   (10208 kB) <---- 
[    0.000000]       .init : 0xd5200000 - 0xd5600000   (4096 kB)  <----
[    0.000000]       .data : 0xd5600000 - 0xd5776f28   (1500 kB)  <----
[    0.000000]        .bss : 0xd57805e0 - 0xd57e60ac   ( 407 kB)  <----

[0] https://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/latest/QEMU-ARM/RELEASE_GCC49/QEMU_EFI.fd

(or update patch #26 to poke a hardcoded value into kaslr_offset directly)

Note that this series partially overlaps with my series 'ARM: add and use
convenience macros for PC relative references', for which I will not send
a follow up. I kept the necessary ones, and dropped some others that are
not actually that useful in the context of KASLR.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dave Martin <dave.martin@arm.com>

Ard Biesheuvel (30):
  asm-generic: add .data.rel.ro sections to __ro_after_init
  ARM: assembler: introduce adr_l, ldr_l and str_l macros
  ARM: head-common.S: use PC-relative insn sequence for __proc_info
  ARM: head-common.S: use PC-relative insn sequence for idmap creation
  ARM: head.S: use PC-relative insn sequence for secondary_data
  ARM: kernel: use relative references for UP/SMP alternatives
  ARM: head: use PC-relative insn sequence for __smp_alt
  ARM: sleep.S: use PC-relative insn sequence for
    sleep_save_sp/mpidr_hash
  ARM: head.S: use PC-relative insn sequences for __fixup_pv_table
  ARM: head.S: use PC relative insn sequence to calculate PHYS_OFFSET
  ARM: kvm: replace open coded VA->PA calculations with adr_l call
  arm-soc: exynos: replace open coded VA->PA conversions
  arm-soc: mvebu: replace open coded VA->PA conversion
  arm-soc: various: replace open coded VA->PA calculation of pen_release
  ARM: kernel: switch to relative exception tables
  ARM: kernel: use relative phys-to-virt patch tables
  arm-soc: tegra: make sleep asm code runtime relocatable
  ARM: kernel: make vmlinux buildable as a PIE executable
  ARM: kernel: use PC-relative symbol references in MMU switch code
  ARM: kernel: use PC relative symbol references in suspend/resume code
  ARM: mm: export default vmalloc base address
  ARM: kernel: refer to swapper_pg_dir via its symbol
  ARM: kernel: implement randomization of the kernel load address
  ARM: decompressor: explicitly map decompressor binary cacheable
  ARM: compressed: factor out zImage header and make it extensible
  ARM: decompressor: add KASLR support
  efi/libstub: add 'max' parameter to efi_random_alloc()
  efi/libstub: check for vmalloc= command line argument
  efi/libstub: arm: reserve bootloader supplied initrd in memory map
  efi/libstub: arm: implement KASLR

 arch/arm/Kconfig                               |  19 ++
 arch/arm/Makefile                              |   5 +
 arch/arm/boot/compressed/head.S                |  46 ++---
 arch/arm/boot/compressed/vmlinux.lds.S         |   5 +-
 arch/arm/include/asm/Kbuild                    |   1 -
 arch/arm/include/asm/assembler.h               |  86 +++++++-
 arch/arm/include/asm/extable.h                 |  20 ++
 arch/arm/include/asm/futex.h                   |   2 +-
 arch/arm/include/asm/memory.h                  |   6 +-
 arch/arm/include/asm/pgtable.h                 |   1 +
 arch/arm/include/asm/processor.h               |   2 +-
 arch/arm/include/asm/uaccess.h                 |   8 +-
 arch/arm/include/asm/word-at-a-time.h          |   2 +-
 arch/arm/include/asm/zimage.h                  |  65 ++++++
 arch/arm/kernel/entry-armv.S                   |   6 +-
 arch/arm/kernel/head-common.S                  |  61 ++----
 arch/arm/kernel/head.S                         | 217 ++++++++++++--------
 arch/arm/kernel/hyp-stub.S                     |  33 ++-
 arch/arm/kernel/sleep.S                        |  27 +--
 arch/arm/kernel/swp_emulate.c                  |   4 +-
 arch/arm/kernel/vmlinux.lds.S                  |   9 +
 arch/arm/kvm/init.S                            |   8 +-
 arch/arm/lib/backtrace.S                       |   8 +-
 arch/arm/lib/getuser.S                         |  22 +-
 arch/arm/lib/putuser.S                         |  12 +-
 arch/arm/mach-exynos/headsmp.S                 |   9 +-
 arch/arm/mach-exynos/sleep.S                   |  26 +--
 arch/arm/mach-mvebu/coherency_ll.S             |   8 +-
 arch/arm/mach-prima2/headsmp.S                 |  11 +-
 arch/arm/mach-spear/headsmp.S                  |  11 +-
 arch/arm/mach-sti/headsmp.S                    |  10 +-
 arch/arm/mach-tegra/sleep-tegra20.S            |  22 +-
 arch/arm/mach-tegra/sleep-tegra30.S            |   6 +-
 arch/arm/mach-tegra/sleep.S                    |   4 +-
 arch/arm/mm/alignment.c                        |  14 +-
 arch/arm/mm/extable.c                          |   2 +-
 arch/arm/mm/mmu.c                              |   3 +-
 arch/arm/nwfpe/entry.S                         |   2 +-
 arch/arm/plat-versatile/headsmp.S              |   9 +-
 drivers/firmware/efi/libstub/arm-stub.c        |  51 +++--
 drivers/firmware/efi/libstub/arm32-stub.c      |  46 ++++-
 drivers/firmware/efi/libstub/arm64-stub.c      |   2 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c |   9 +
 drivers/firmware/efi/libstub/efistub.h         |   7 +-
 drivers/firmware/efi/libstub/fdt.c             |  42 ++++
 drivers/firmware/efi/libstub/random.c          |  10 +-
 include/asm-generic/vmlinux.lds.h              |   2 +-
 include/linux/hidden.h                         |  21 ++
 scripts/sortextable.c                          |   2 +-
 49 files changed, 636 insertions(+), 368 deletions(-)
 create mode 100644 arch/arm/include/asm/extable.h
 create mode 100644 arch/arm/include/asm/zimage.h
 create mode 100644 include/linux/hidden.h

-- 
2.11.0
