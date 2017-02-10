From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 10 Feb 2017 17:16:41 +0000
Message-Id: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 0/4] arm64: mmu: avoid writeable-executable mappings
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, kernel-hardening@lists.openwall.com, andre.przywara@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

Ard Biesheuvel (4):
  arm: kvm: move kvm_vgic_global_state out of .text section
  arm64: alternatives: apply boot time fixups via the linear mapping
  arm64: mmu: map .text as read-only from the outset
  arm64: mmu: apply strict permissions to .init.text and .init.data

 arch/arm64/include/asm/mmu.h      |  1 +
 arch/arm64/include/asm/sections.h |  3 +-
 arch/arm64/kernel/alternative.c   |  6 +--
 arch/arm64/kernel/smp.c           |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 32 ++++++++++-----
 arch/arm64/mm/init.c              |  3 +-
 arch/arm64/mm/mmu.c               | 42 ++++++++++++++------
 virt/kvm/arm/vgic/vgic.c          |  4 +-
 8 files changed, 64 insertions(+), 28 deletions(-)

-- 
2.7.4
