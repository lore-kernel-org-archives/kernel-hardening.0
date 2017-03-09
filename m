From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 09:25:02 +0100
Message-Id: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v5 00/10] arm64: mmu: avoid W+X mappings and re-enable PTE_CONT for kernel
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Having memory that is writable and executable at the same time is a
security hazard, and so we tend to avoid those when we can. However,
at boot time, we keep .text mapped writable during the entire init
phase, and the init region itself is mapped rwx as well.

Let's improve the situation by:
- making the alternatives patching use the linear mapping
- splitting the init region into separate text and data regions

This removes all RWX mappings except the really early one created
in head.S (which we could perhaps fix in the future as well)

Changes since v4:
- the PTE_CONT patch has now spawned four more preparatory patches that clean
  up some of the page table creation code before reintroducing the contiguous
  attribute management
- add Mark's R-b to #4 and #5

Changes since v3:
- use linear alias only when patching the core kernel, and not for modules
- add patch to reintroduce the use of PTE_CONT for kernel mappings, except
  for regions that are remapped read-only later on (i.e, .rodata and the
  linear alias of .text+.rodata)

Changes since v2:
  - ensure that text mappings remain writable under rodata=off
  - rename create_mapping_late() to update_mapping_prot()
  - clarify commit log of #2
  - add acks

Ard Biesheuvel (10):
  arm: kvm: move kvm_vgic_global_state out of .text section
  arm64: mmu: move TLB maintenance from callers to create_mapping_late()
  arm64: alternatives: apply boot time fixups via the linear mapping
  arm64: mmu: map .text as read-only from the outset
  arm64: mmu: apply strict permissions to .init.text and .init.data
  arm64/mmu: align alloc_init_pte prototype with pmd/pud versions
  arm64/mmu: ignore debug_pagealloc for kernel segments
  arm64/mmu: add contiguous bit to sanity bug check
  arm64/mmu: replace 'page_mappings_only' parameter with flags argument
  arm64: mm: set the contiguous bit for kernel mappings where
    appropriate

 arch/arm64/include/asm/mmu.h      |   1 +
 arch/arm64/include/asm/pgtable.h  |  10 +
 arch/arm64/include/asm/sections.h |   2 +
 arch/arm64/kernel/alternative.c   |  11 +-
 arch/arm64/kernel/smp.c           |   1 +
 arch/arm64/kernel/vmlinux.lds.S   |  25 +-
 arch/arm64/mm/mmu.c               | 250 ++++++++++++++------
 virt/kvm/arm/vgic/vgic.c          |   4 +-
 8 files changed, 212 insertions(+), 92 deletions(-)

-- 
2.7.4
