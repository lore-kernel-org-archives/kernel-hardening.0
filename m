From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 14 Feb 2017 20:52:33 +0000
Message-Id: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 0/5] arm64: mmu: avoid writeable-executable mappings
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, keescook@chromium.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

Changes since v2:
  - ensure that text mappings remain writable under rodata=off
  - rename create_mapping_late() to update_mapping_prot()
  - clarify commit log of #2
  - add acks

Changes since v1:
- add patch to move TLB maintenance into create_mapping_late() and remove it
  from its callers (#2)
- use the true address not the linear alias when patching branch instructions,
  spotted by Suzuki (#3)
- mark mark_linear_text_alias_ro() __init (#3)
- move the .rela section back into __initdata: as it turns out, leaving a hole
  between the segments results in a peculiar situation where other unrelated
  allocations end up right in the middle of the kernel Image, which is
  probably a bad idea (#5). See below for an example.
- add acks

Ard Biesheuvel (5):
  arm: kvm: move kvm_vgic_global_state out of .text section
  arm64: mmu: move TLB maintenance from callers to create_mapping_late()
  arm64: alternatives: apply boot time fixups via the linear mapping
  arm64: mmu: map .text as read-only from the outset
  arm64: mmu: apply strict permissions to .init.text and .init.data

 arch/arm64/include/asm/mmu.h      |  1 +
 arch/arm64/include/asm/sections.h |  3 +-
 arch/arm64/kernel/alternative.c   |  2 +-
 arch/arm64/kernel/smp.c           |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 25 +++++---
 arch/arm64/mm/mmu.c               | 61 +++++++++++++-------
 virt/kvm/arm/vgic/vgic.c          |  4 +-
 7 files changed, 65 insertions(+), 32 deletions(-)

-- 
2.7.4
