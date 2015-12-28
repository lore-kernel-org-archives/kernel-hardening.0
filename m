Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 28 Dec 2015 12:20:44 +0100
Message-Id: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 00/10] arm64: implement support for KASLR
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, lkml@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This series implements KASLR for arm64, by building the kernel as a PIE
executable that can relocate itself at runtime, and moving it to a random
offset in the vmalloc area.

Notes:
- These patches apply on top of Mark Rutland's pagetable rework series:
  http://thread.gmane.org/gmane.linux.ports.arm.kernel/462438
- The arm64 Image is uncompressed by default, and the Elf64_Rela format uses
  24 bytes per relocation entry. This results in considerable bloat (i.e., a
  couple of MBs worth of relocation data in an .init section). However, no
  build time postprocessing is required, we rely fully on the toolchain to
  produce the image (modulo some byte swapping in the Image header for BE
  kernels)
- We have to rely on the bootloader to supply some randomness in register x1
  upon kernel entry. Since we have no decompressor, it is simply not feasible
  to collect randomness in the head.S code path before mapping the kernel and
  enabling the MMU.
- The EFI_RNG_PROTOCOL that is invoked in patch #10 to supply randomness on
  UEFI systems is not universally available. A QEMU/KVM firmware image that
  implements a pseudo-random version is available here:
  http://people.linaro.org/~ard.biesheuvel/QEMU_EFI.fd.aarch64-rng.bz2
  (requires access to PMCCNTR_EL0 and support for AES instructions)
  See below for instructions how to run the pseudo-random version on real
  hardware.
- Only mildly tested. Help appreciated.

Code can be found here:
git://git.linaro.org/people/ard.biesheuvel/linux-arm.git arm64-kaslr
https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/shortlog/refs/heads/arm64-kaslr

Patch #1 introduces KIMAGE_VADDR as the base of the kernel virtual region.

Patch #2 memblock_reserve()'s the .bss, swapper_pg_dir and idmap_pg_dir
individually.

Patch #3 rewrites early_fixmap_init() so it does not rely on the linear mapping
(i.e., the use of phys_to_virt() is avoided)

Patch #4 moves the kernel virtual mapping to the vmalloc area, along with the
module region which is kept right below it, as before.

Patch #5 adds support for PLTs in modules so that relative branches can be
resolved via a PLT if the target is out of range.

Patch #6 moves to the x86 version of the extable implementation so that it no
longer contains absolute addresses that require fixing up at relocation time,
but uses relative offsets instead.

Patch #7 reverts some changes to the Image header population code so we no
longer depend on the linker to populate the header fields. This is necessary
since the R_AARCH64_ABS relocations that are emitted for these fields are not
resolved at build time for PIE executables.

Patch #8 updates the code in head.S that needs to execute before relocation to
avoid the use of values that are subject to dynamic relocation. These values
will not be populated in PIE executables.

Patch #9 implements the core KASLR, by taking randomness supplied in register x1
and using it to move the kernel inside the vmalloc area.

Patch #10 adds an invocation of the EFI_RNG_PROTOCOL to supply randomness to the
kernel proper.

Ard Biesheuvel (10):
  arm64: introduce KIMAGE_VADDR as the virtual base of the kernel region
  arm64: use more granular reservations for static page table
    allocations
  arm64: decouple early fixmap init from linear mapping
  arm64: move kernel image to base of vmalloc area
  arm64: add support for module PLTs
  arm64: use relative references in exception tables
  arm64: use assembly time constants for Image header fields
  arm64: avoid dynamic relocations in early boot code
  arm64: add support for relocatable kernel
  arm64: efi: invoke EFI_RNG_PROTOCOL to supply KASLR randomness

 Documentation/arm64/booting.txt         |   3 +-
 arch/arm64/Kconfig                      |  18 +++
 arch/arm64/Makefile                     |  10 +-
 arch/arm64/boot/Makefile                |   1 +
 arch/arm64/include/asm/assembler.h      |   2 +-
 arch/arm64/include/asm/compiler.h       |   2 +
 arch/arm64/include/asm/futex.h          |   4 +-
 arch/arm64/include/asm/kasan.h          |  17 +--
 arch/arm64/include/asm/memory.h         |  29 ++++-
 arch/arm64/include/asm/module.h         |  11 ++
 arch/arm64/include/asm/pgtable.h        |   7 -
 arch/arm64/include/asm/uaccess.h        |  16 +--
 arch/arm64/kernel/Makefile              |   1 +
 arch/arm64/kernel/arm64ksyms.c          |   5 +
 arch/arm64/kernel/armv8_deprecated.c    |   4 +-
 arch/arm64/kernel/efi-entry.S           |   9 +-
 arch/arm64/kernel/head.S                | 120 ++++++++++++++---
 arch/arm64/kernel/image.h               |  40 ------
 arch/arm64/kernel/module-plts.c         | 137 ++++++++++++++++++++
 arch/arm64/kernel/module.c              |   7 +
 arch/arm64/kernel/module.lds            |   4 +
 arch/arm64/kernel/setup.c               |  15 ++-
 arch/arm64/kernel/vmlinux.lds.S         |  27 ++--
 arch/arm64/mm/dump.c                    |  12 +-
 arch/arm64/mm/extable.c                 | 102 ++++++++++++++-
 arch/arm64/mm/init.c                    |  25 ++--
 arch/arm64/mm/mmu.c                     | 122 +++++------------
 drivers/firmware/efi/libstub/arm-stub.c |  31 +++++
 include/linux/efi.h                     |   5 +-
 scripts/arm64fixhdr.pl                  |  25 ++++
 scripts/sortextable.c                   |   6 +-
 31 files changed, 605 insertions(+), 212 deletions(-)
 create mode 100644 arch/arm64/kernel/module-plts.c
 create mode 100644 arch/arm64/kernel/module.lds
 create mode 100755 scripts/arm64fixhdr.pl


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
