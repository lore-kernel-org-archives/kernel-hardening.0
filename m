From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed,  8 Feb 2017 11:55:33 +0000
Message-Id: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 00/14] arm64+ARM: efi: PE/COFF cleanup/hardening
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, leif.lindholm@linaro.org
Cc: catalin.marinas@arm.com, linux@armlinux.org.uk, kernel-hardening@lists.openwall.com, labbott@fedoraproject.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This cleans up the PE/COFF EFI header, by taking some of Mark's patches
and use them to replace open coded constants with symbolic ones, and
remove incorrect values or unused sections.

Finally, it updates the section layout so that the kernel Image can be
mapped in a way that does not require setting RWX permissions anywhere.
Note that this is currently not a huge win, given that most current UEFI
implementations map all of RAM RWX by default, but this is finally gaining
some attention, and work is underway to make the PE/COFF loader in EDK2
adhere to the section permissions, which would also allow the RAM mapping
to default to non-executable. Work in progress nonetheless...

Changes since v1:
- added missing secondary SOB on Mark's patches
- leave Image header as before, only move the PE header to a separate file
- put PE header fixes in a separate patch
- add acks from Mark and Peter (#6)
- give ARM the same treatment as arm64 (#10 - #13)
- add NB10 PE debuglink entry to ARM PE/COFF header as well (#9, #14)

Ard Biesheuvel (12):
  arm64: efi: move EFI header and related data to a separate .S file
  arm64: efi: clean up Image header after PE header has been split off
  arm64: efi: remove forbidden values from the PE/COFF header
  arm64: efi: remove pointless dummy .reloc section
  arm64: efi: replace open coded constants with symbolic ones
  arm64: efi: split Image code and data into separate PE/COFF sections
  arm: compressed: put zImage header and EFI header in dedicated section
  arm: efi: remove forbidden values from the PE/COFF header
  arm: efi: remove pointless dummy .reloc section
  arm: efi: replace open coded constants with symbolic ones
  arm: efi: split zImage code and data into separate PE/COFF sections
  arm: efi: add PE/COFF debug table to EFI header

Mark Rutland (2):
  include: pe.h: allow for use in assembly
  include: pe.h: add some missing definitions

 arch/arm/boot/compressed/Makefile      |   4 +
 arch/arm/boot/compressed/efi-header.S  | 253 ++++++++++++--------
 arch/arm/boot/compressed/head.S        |  14 +-
 arch/arm/boot/compressed/vmlinux.lds.S |  32 ++-
 arch/arm64/kernel/efi-header.S         | 155 ++++++++++++
 arch/arm64/kernel/head.S               | 167 +------------
 arch/arm64/kernel/vmlinux.lds.S        |   5 +
 include/linux/pe.h                     | 177 +++++++-------
 8 files changed, 449 insertions(+), 358 deletions(-)
 create mode 100644 arch/arm64/kernel/efi-header.S

-- 
2.7.4
