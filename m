From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 15 Feb 2017 15:37:58 +0000
Message-Id: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 0/3] arm64: eliminate early RWX mappings
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This series is a proof of concept that eliminates the RWX mappings from
the early kernel mapping. I realize I got carried away a bit while hacking
on this, and I am not convinced this is something we should merge, but since
I did the work already, I am sharing this mostly as a discussion piece.

Patch #1 updates the early mapping routines to map the kernel image
non-executable initially, and selectively update permissions on regions
that contain executable code.

Patch #2 tweaks the text offset of relocatable kernels so that the init
section (which could require a RWX mapping otherwise) appears at a swapper
block boundary.

Patch #3 updates the image loader in the EFI stub to take the modified text
offset into account.

Note that this approach interferes with the ability of external debuggers to
set software breakpoints, but the early mapping is not very long lived anyway.

Ard Biesheuvel (3):
  arm64: mmu: restrict permissions of early kernel mappings
  arm64: boot: align __inittext with swapper block on relocatable
    kernels
  arm64: efi: use effective text offset when allocating Image

 arch/arm64/include/asm/kernel-pgtable.h   |  3 ++
 arch/arm64/kernel/efi-entry.S             |  5 ++
 arch/arm64/kernel/head.S                  | 53 +++++++++++++++++++-
 arch/arm64/kernel/image.h                 | 24 +++++++--
 arch/arm64/kernel/vmlinux.lds.S           | 14 +++---
 drivers/firmware/efi/libstub/Makefile     |  1 -
 drivers/firmware/efi/libstub/arm64-stub.c | 13 +++--
 7 files changed, 96 insertions(+), 17 deletions(-)

-- 
2.7.4
