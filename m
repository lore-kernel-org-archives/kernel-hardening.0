Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:27 +0100
Message-Id: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 00/22] arm64: implement support for KASLR
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This series implements KASLR for arm64, by building the kernel as a PIE
executable that can relocate itself at runtime, and moving it to a random
offset in the vmalloc area. v2 and up also implement physical randomization,
i.e., it allows the kernel to deal with being loaded at any physical offset
(modulo the required alignment), and invokes the EFI_RNG_PROTOCOL from the
UEFI stub to obtain random bits and perform the actual randomization of the
physical load address.

Changes since v3:
- Implemented base relative kallsyms address tables. This saves 250 KB of
  permanent .rodata (for a defconfig build), but more importantly, saves about
  1.4 MB of __init data in the dynamic relocation table. This patch has been
  picked up by akpm in the mean time, but it is reproduced here for completeness
- Reimplemented the KASLR init code in C. This has a couple of benefits, i.e.,
  we can now parse the 'nokaslr' command line option in a timely fashion, and we
  can pass the KASLR random seed via /chosen/kaslr-seed rather than via x1,
  which means fewer changes to bootloaders. This is implemented using a two pass
  approach, i.e., the kernel is booted without KASLR to a state where it can
  invoke ordinary C code, and it re-enters the early boot code to recreate
  the kernel mappings at an offset if it finds the prerequisite data in the FDT.
  Note that this requires some mild refactoring to ensure that early_fixmap_init
  and fixmap_remap_fdt can cope with being called twice.
- Added a patch to enable the inappropriately named huge-vmap feature for arm64,
  which allows ioremap() (but not vmap or vmalloc) to use block mappings. This
  should be an improvement in itself, but the significance for this series is
  that it also allows the __init region to be unmapped entirely via
  unmap_kernel_range() [which complains about block mappings without this
  feature enabled]
- Split the implementation of CONFIG_RELOCATABLE and CONFIG_RANDOMIZE_BASE into
  separate patches.
- Randomize the module region independently from the core kernel. It is chosen
  such that it covers the [_stext, _etext] interval of the core kernel to avoid
  using PLT entries unless we really have to.
- Update the module PLT patch to replace the O(n^2) searches with sorting, and
  use a single .plt section for __init and ordinary code.
- Added panic notifiers to report the KASLR offset, and whether a mem= limit is
  in effect.
- Replaced Mark Rutland's asm/elf.g split off patch with one that puts the C
  declarations between #ifndef __ASSEMBLY__/#endif
- Incorporated feedback (and tags) from Mark Rutland and Matt Fleming
- Minor tweaks and fixes.
  
Changes since v2:
- Incorporated feedback from Marc Zyngier into the KVM patch (#5)
- Dropped the pgdir section and the patch that memblock_reserve()'s the kernel
  sections at a smaller granularity. This is no longer necessary with the pgdir
  section gone. This also fixes an issue spotted by James Morse where the fixmap
  page tables are not zeroed correctly; these have been moved back to the .bss
  section.
- Got rid of all ifdef'ery regarding the number of translation levels in the
  changed .c files, by introducing new definitions in pgtable.h (#3, #6)
- Fixed KAsan support, which was broken by all earlier versions.
- Moved module region along with the virtually randomized kernel, so that module
  addresses become unpredictable as well, and we only have to rely on veneers in
  the PLTs when the module region is exhausted (which is somewhat more likely
  since the module region is now shared with other uses of the vmalloc area)
- Added support for the 'nokaslr' command line option. This affects the
  randomization performed by the stub, and results in a warning if passed while
  the bootloader also presented a random seed for virtual KASLR in register x1.
- The .text/.rodata sections of the kernel are no longer aliased in the linear
  region with a writable mapping.
- Added a separate image header flag for kernel images that may be loaded at any
  2 MB aligned offset (+ TEXT_OFFSET)
- The KASLR displacement is now corrected if it results in the kernel image
  intersecting a PUD/PMD boundary (4k and 16k/64k granule kernels, respectively)
- Split out UEFI stub random routines into separate patches.
- Implemented a weight based EFI random allocation routine so that each suitable
  offset in available memory is equally likely to be selected (as suggested by
  Kees Cook)
- Reused CONFIG_RELOCATABLE and CONFIG_RANDOMIZE_BASE instead of introducing
  new Kconfig symbols to describe the same functionality.
- Reimplemented mem= logic so memory is clipped from the top first.

Changes since v1/RFC:
- This series now implements fully independent virtual and physical address
  randomization at load time. I have recycled some patches from this series:
  http://thread.gmane.org/gmane.linux.ports.arm.kernel/455151, and updated the
  final UEFI stub patch to randomize the physical address as well.
- Added a patch to deal with the way KVM on arm64 makes assumptions about the
  relation between kernel symbols and the linear mapping (on which the HYP
  mapping is based), as these assumptions cease to be valid once we move the
  kernel Image out of the linear mapping.
- Updated the module PLT patch so it works on BE kernels as well.
- Moved the constant Image header values to head.S, and updated the linker
  script to provide the kernel size using R_AARCH64_ABS32 relocation rather
  than a R_AARCH64_ABS64 relocation, since those are always resolved at build
  time. This allows me to get rid of the post-build perl script to swab header
  values on BE kernels.
- Minor style tweaks.

Notes:
- These patches apply on top of Mark Rutland's pagetable rework series:
  http://thread.gmane.org/gmane.linux.ports.arm.kernel/462438
- The arm64 Image is uncompressed by default, and the Elf64_Rela format uses
  24 bytes per relocation entry. This results in considerable bloat (i.e., a
  couple of MBs worth of relocation data in an .init section). However, no
  build time postprocessing is required, we rely fully on the toolchain to
  produce the image
- We have to rely on the bootloader to supply some randomness in
  /chosen/kaslr-seed upon kernel entry. Since we have no decompressor, it is
  simply not feasible to collect randomness in the head.S code path before
  mapping the kernel and enabling the MMU.
- The EFI_RNG_PROTOCOL that is invoked in patch #13 to supply randomness on
  UEFI systems is not universally available. A QEMU/KVM firmware image that
  implements a pseudo-random version is available here:
  http://people.linaro.org/~ard.biesheuvel/QEMU_EFI.fd.aarch64-rng.bz2
  (requires access to PMCCNTR_EL0 and support for AES instructions)
  See below for instructions how to run the pseudo-random version on real
  hardware.

Code can be found here:
git://git.linaro.org/people/ard.biesheuvel/linux-arm.git arm64-kaslr-v4a
https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/shortlog/refs/heads/arm64-kaslr-v4a

Patch #1 updates the OF code to allow the minimum memblock physical address to
be overridden by the arch.

Patch #2 introduces KIMAGE_VADDR as the base of the kernel virtual region.

Patch #3 introduces pte_offset_kimg(), pmd_offset_kimg() and pud_offset_kimg()
that allow statically allocated page tables (i.e., by fixmap and kasan) to be
traversed before the linear mapping is installed.

Patch #4 rewrites early_fixmap_init() so it does not rely on the linear mapping
(i.e., the use of phys_to_virt() is avoided)

Patch #5 updates KVM on arm64 so it can deal with kernel symbols whose addresses
are not covered by the linear mapping.

Patch #6 wires up the huge-vmap generic feature for arm64.

Patch #7 moves the kernel virtual mapping to the vmalloc area, along with the
module region which is kept right below it, as before.

Patch #8 adds support for PLTs in modules so that relative branches can be
resolved via a PLT if the target is out of range. This is required for KASLR,
since modules may be loaded far away from the core kernel.

Patch #9 and #10 move arm64 to the a new generic relative version of the extable
implementation so that it no longer contains absolute addresses that require
fixing up at relocation time, but uses relative offsets instead.

Patch #11 reverts some changes to the Image header population code so we no
longer depend on the linker to populate the header fields. This is necessary
since the R_AARCH64_ABS64 relocations that are emitted for these fields are not
resolved at build time for PIE executables.

Patch #12 updates the code in head.S that needs to execute before relocation to
avoid the use of values that are subject to dynamic relocation. These values
will not be populated in PIE executables.

Patch #13 allows the kernel Image to be loaded anywhere in physical memory, by
decoupling PHYS_OFFSET from the base of the kernel image.

Patch #14 wraps C declarations in asm/elf.h inside #ifndef __ASSEMBLY__ so we
can include it in head.S

Patch #15 updates scripts/sortextable.c so it accepts ET_DYN (relocatable)
executables as well as ET_EXEC (static) executables.

Patch #16 implements base kallsyms base relative address tables.

Patch #17 implements CONFIG_RELOCATABLE, i.e., building vmlinux as a PIE
executable that self relocates at early boot time

Patch #18 implements the core KASLR, by taking randomness supplied in
/chosen/kaslr-seed and using it to move the kernel inside the vmalloc area,
and randomize the module region around it.

Patch #19 implements efi_get_random_bytes() based on the EFI_RNG_PROTOCOL

Patch #20 implements efi_random_alloc()

Patch #21 moves the allocation for the converted command line (UTF-16 to ASCII)
away from the base of memory. This is necessary since for parsing 

Patch #22 implements the actual KASLR, by randomizing the kernel physical
address, and passing entropy in /chosen/kaslr-seed so that the kernel proper can
relocate itself virtually.

Ard Biesheuvel (22):
  of/fdt: make memblock minimum physical address arch configurable
  arm64: introduce KIMAGE_VADDR as the virtual base of the kernel region
  arm64: pgtable: implement static [pte|pmd|pud]_offset variants
  arm64: decouple early fixmap init from linear mapping
  arm64: kvm: deal with kernel symbols outside of linear mapping
  arm64: add support for ioremap() block mappings
  arm64: move kernel image to base of vmalloc area
  arm64: add support for module PLTs
  extable: add support for relative extables to search and sort routines
  arm64: switch to relative exception tables
  arm64: avoid R_AARCH64_ABS64 relocations for Image header fields
  arm64: avoid dynamic relocations in early boot code
  arm64: allow kernel Image to be loaded anywhere in physical memory
  arm64: make asm/elf.h available to asm files
  scripts/sortextable: add support for ET_DYN binaries
  kallsyms: add support for relative offsets in kallsyms address table
  arm64: add support for building the kernel as a relocate PIE binary
  arm64: add support for kernel ASLR
  efi: stub: implement efi_get_random_bytes() based on EFI_RNG_PROTOCOL
  efi: stub: add implementation of efi_random_alloc()
  efi: stub: use high allocation for converted command line
  arm64: efi: invoke EFI_RNG_PROTOCOL to supply KASLR randomness

 Documentation/arm64/booting.txt                      |  20 +-
 Documentation/features/vm/huge-vmap/arch-support.txt |   2 +-
 arch/arm/include/asm/kvm_asm.h                       |   2 +
 arch/arm/kvm/arm.c                                   |   8 +-
 arch/arm64/Kconfig                                   |  41 ++++
 arch/arm64/Makefile                                  |  10 +-
 arch/arm64/include/asm/assembler.h                   |  26 ++-
 arch/arm64/include/asm/boot.h                        |   6 +
 arch/arm64/include/asm/elf.h                         |  24 ++-
 arch/arm64/include/asm/futex.h                       |  12 +-
 arch/arm64/include/asm/kasan.h                       |   2 +-
 arch/arm64/include/asm/kernel-pgtable.h              |  11 ++
 arch/arm64/include/asm/kvm_asm.h                     |   2 +
 arch/arm64/include/asm/kvm_host.h                    |   8 +-
 arch/arm64/include/asm/memory.h                      |  47 +++--
 arch/arm64/include/asm/module.h                      |  11 ++
 arch/arm64/include/asm/pgtable.h                     |  23 ++-
 arch/arm64/include/asm/uaccess.h                     |  30 +--
 arch/arm64/include/asm/word-at-a-time.h              |   7 +-
 arch/arm64/kernel/Makefile                           |   2 +
 arch/arm64/kernel/armv8_deprecated.c                 |   7 +-
 arch/arm64/kernel/efi-entry.S                        |   2 +-
 arch/arm64/kernel/head.S                             | 134 +++++++++++--
 arch/arm64/kernel/image.h                            |  45 +++--
 arch/arm64/kernel/kaslr.c                            | 169 ++++++++++++++++
 arch/arm64/kernel/module-plts.c                      | 201 ++++++++++++++++++++
 arch/arm64/kernel/module.c                           |  20 +-
 arch/arm64/kernel/module.lds                         |   3 +
 arch/arm64/kernel/setup.c                            |  29 +++
 arch/arm64/kernel/vmlinux.lds.S                      |  20 +-
 arch/arm64/kvm/hyp.S                                 |   6 +-
 arch/arm64/mm/dump.c                                 |  12 +-
 arch/arm64/mm/extable.c                              |   2 +-
 arch/arm64/mm/init.c                                 | 119 ++++++++++--
 arch/arm64/mm/kasan_init.c                           |  18 +-
 arch/arm64/mm/mmu.c                                  | 186 +++++++++++++-----
 arch/x86/include/asm/efi.h                           |   2 +
 drivers/firmware/efi/libstub/Makefile                |   2 +-
 drivers/firmware/efi/libstub/arm-stub.c              |  40 ++--
 drivers/firmware/efi/libstub/arm64-stub.c            |  78 +++++---
 drivers/firmware/efi/libstub/efi-stub-helper.c       |   7 +-
 drivers/firmware/efi/libstub/efistub.h               |   7 +
 drivers/firmware/efi/libstub/fdt.c                   |   9 +
 drivers/firmware/efi/libstub/random.c                | 135 +++++++++++++
 drivers/of/fdt.c                                     |   5 +-
 include/linux/efi.h                                  |   5 +-
 init/Kconfig                                         |  16 ++
 kernel/kallsyms.c                                    |  38 +++-
 lib/extable.c                                        |  50 ++++-
 scripts/kallsyms.c                                   |  88 ++++++++-
 scripts/link-vmlinux.sh                              |   4 +
 scripts/namespace.pl                                 |   2 +
 scripts/sortextable.c                                |  10 +-
 53 files changed, 1496 insertions(+), 269 deletions(-)
 create mode 100644 arch/arm64/kernel/kaslr.c
 create mode 100644 arch/arm64/kernel/module-plts.c
 create mode 100644 arch/arm64/kernel/module.lds
 create mode 100644 drivers/firmware/efi/libstub/random.c

EFI_RNG_PROTOCOL on real hardware
=================================

To test whether your UEFI implements the EFI_RNG_PROTOCOL, download the
following executable and run it from the UEFI Shell:
http://people.linaro.org/~ard.biesheuvel/RngTest.efi

FS0:\> rngtest
UEFI RNG Protocol Testing :
----------------------------
 -- Locate UEFI RNG Protocol : [Fail - Status = Not Found]

If your UEFI does not implement the EFI_RNG_PROTOCOL, you can download and
install the pseudo-random version that uses the generic timer and PMCCNTR_EL0
values and permutes them using a couple of rounds of AES.
http://people.linaro.org/~ard.biesheuvel/RngDxe.efi

NOTE: not for production!! This is a quick and dirty hack to test the KASLR
code, and is not suitable for anything else.

FS0:\> rngdxe
FS0:\> rngtest
UEFI RNG Protocol Testing :
----------------------------
 -- Locate UEFI RNG Protocol : [Pass]
 -- Call RNG->GetInfo() interface :
     >> Supported RNG Algorithm (Count = 2) :
          0) 44F0DE6E-4D8C-4045-A8C7-4DD168856B9E
          1) E43176D7-B6E8-4827-B784-7FFDC4B68561
 -- Call RNG->GetRNG() interface :
     >> RNG with default algorithm : [Pass]
     >> RNG with SP800-90-HMAC-256 : [Fail - Status = Unsupported]
     >> RNG with SP800-90-Hash-256 : [Fail - Status = Unsupported]
     >> RNG with SP800-90-CTR-256 : [Pass]
     >> RNG with X9.31-3DES : [Fail - Status = Unsupported]
     >> RNG with X9.31-AES : [Fail - Status = Unsupported]
     >> RNG with RAW Entropy : [Pass]
 -- Random Number Generation Test with default RNG Algorithm (20 Rounds):
          01) - 27
          02) - 61E8
          03) - 496FD8
          04) - DDD793BF
          05) - B6C37C8E23
          06) - 4D183C604A96
          07) - 9363311DB61298
          08) - 5715A7294F4E436E
          09) - F0D4D7BAA0DD52318E
          10) - C88C6EBCF4C0474D87C3
          11) - B5594602B482A643932172
          12) - CA7573F704B2089B726B9CF1
          13) - A93E9451CB533DCFBA87B97C33
          14) - 45AA7B83DB6044F7BBAB031F0D24
          15) - 3DD7A4D61F34ADCB400B5976730DCF
          16) - 4DD168D21FAB8F59708330D6A9BEB021
          17) - 4BBB225E61C465F174254159467E65939F
          18) - 030A156C9616337A20070941E702827DA8E1
          19) - AB0FC11C9A4E225011382A9D164D9D55CA2B64
          20) - 72B9B4735DC445E5DA6AF88DE965B7E87CB9A23C
