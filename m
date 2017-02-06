From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon,  6 Feb 2017 16:24:28 +0000
Message-Id: <1486398275-3966-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 0/7] arm64: efi: PE/COFF cleanup/hardening
To: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com
Cc: labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, leif.lindholm@linaro.org, pjones@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

Ard Biesheuvel (5):
  arm64: efi: move EFI header and related data to a separate .S file
  arm64: efi: ensure that the PE/COFF header pointer appears at offset
    0x3c
  arm64: efi: remove pointless dummy .reloc section
  arm64: efi: replace open coded constants with symbolic ones
  arm64: efi: split Image code and data into separate PE/COFF sections

Mark Rutland (2):
  include: pe.h: allow for use in assembly
  include: pe.h: add some missing definitions

 arch/arm64/kernel/efi-header.S  | 178 ++++++++++++++++++++
 arch/arm64/kernel/head.S        | 176 +------------------
 arch/arm64/kernel/vmlinux.lds.S |   5 +
 include/linux/pe.h              | 177 +++++++++----------
 4 files changed, 280 insertions(+), 256 deletions(-)
 create mode 100644 arch/arm64/kernel/efi-header.S

-- 
2.7.4
