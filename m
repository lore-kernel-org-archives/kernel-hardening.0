Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 28 Oct 2016 18:27:08 +0100
Message-Id: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v4 0/8] arm64: Privileged Access Never using TTBR0_EL1 switching
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Sami Tolvanen <samitolvanen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is the fourth version of the arm64 PAN emulation using TTBR0_EL1
switching. The series does not include the empty_zero_page patch from
Ard B. as I didn't have an up to date patch, nor figured out where the
discussion was left.

The patches are available on this branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux ttbr0-pan

Changes since v3:

- Xen hyp call now only enables TTBR0_EL1 if needed without clearing PAN

- Fix for user space cache maintenance trapping/emulation

- Simplified asm macros based on Mark R's "alternative_else_nop_endif"

- Separate patch for fixing the synchronous external abort description

- #includes clean-up

Catalin Marinas (8):
  arm64: Update the synchronous external abort fault description
  arm64: Factor out PAN enabling/disabling into separate uaccess_*
    macros
  arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm
    macro
  arm64: Introduce uaccess_{disable,enable} functionality based on
    TTBR0_EL1
  arm64: Disable TTBR0_EL1 during normal kernel execution
  arm64: Handle faults caused by inadvertent user access with PAN
    enabled
  arm64: xen: Enable user access before a privcmd hvc call
  arm64: Enable CONFIG_ARM64_SW_TTBR0_PAN

 arch/arm64/Kconfig                      |   8 ++
 arch/arm64/include/asm/assembler.h      |  29 ++++++
 arch/arm64/include/asm/cpufeature.h     |   6 ++
 arch/arm64/include/asm/efi.h            |  26 ++++-
 arch/arm64/include/asm/futex.h          |  17 ++--
 arch/arm64/include/asm/kernel-pgtable.h |   7 ++
 arch/arm64/include/asm/mmu_context.h    |  53 +++++++---
 arch/arm64/include/asm/thread_info.h    |   3 +
 arch/arm64/include/asm/uaccess.h        | 175 ++++++++++++++++++++++++++++++--
 arch/arm64/kernel/armv8_deprecated.c    |  11 +-
 arch/arm64/kernel/asm-offsets.c         |   3 +
 arch/arm64/kernel/cpufeature.c          |   1 +
 arch/arm64/kernel/entry.S               |  67 +++++++++++-
 arch/arm64/kernel/head.S                |   6 +-
 arch/arm64/kernel/setup.c               |   9 ++
 arch/arm64/kernel/traps.c               |   9 +-
 arch/arm64/kernel/vmlinux.lds.S         |   5 +
 arch/arm64/lib/clear_user.S             |  11 +-
 arch/arm64/lib/copy_from_user.S         |  11 +-
 arch/arm64/lib/copy_in_user.S           |  11 +-
 arch/arm64/lib/copy_to_user.S           |  11 +-
 arch/arm64/mm/cache.S                   |   6 +-
 arch/arm64/mm/context.c                 |   7 +-
 arch/arm64/mm/fault.c                   |  22 ++--
 arch/arm64/mm/proc.S                    |   6 +-
 arch/arm64/xen/hypercall.S              |  15 +++
 26 files changed, 437 insertions(+), 98 deletions(-)
