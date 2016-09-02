Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri,  2 Sep 2016 16:02:06 +0100
Message-Id: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v2 0/7] arm64: Privileged Access Never using TTBR0_EL1 switching
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Julien Grall <julien.grall@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is the second version of the arm64 PAN emulation by disabling
TTBR0_EL1 accesses. The major change from v1 is the use of a thread_info
member to store the real TTBR0_EL1 value. The advantage is slightly
simpler assembler macros for uaccess_enable with the downside that
switch_mm() must always update the saved ttbr0 even if there is no mm
switch.

Whether we could simplify these patches further to use some TCR_EL1.EPD0
tricks remains to be confirmed with the ARM architects. However, it is
unlikely that they would deem such idea architecturally safe, hence this
series only switches TTBR0_EL1 in accordance with the ARM ARM.

Changes since v1:

- Using thread_info instead of per-CPU variable for the real TTBR0_EL1
  value (mentioned above)

- Factored out the cpu_do_switch_mm errata workaround to a separate
  macro and avoided the "errata" argument to the uaccess_enable asm
  macro

- Fix build error with allnoconfig by moving the uaccess_* asm macros to
  asm/uaccess.h and avoid some cyclic header includes

- _PSR_PAN_BIT moved to the non-uapi ptrace.h

- Use x21 instead of lr as temporary register in entry.S

As per v1, the code requires more testing, especially for combinations
where hardware PAN and/or UAO are present.

The patches are also available on this branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux ttbr0-pan

Thanks for reviewing/testing.

Catalin Marinas (7):
  arm64: Factor out PAN enabling/disabling into separate uaccess_* macros
  arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm macro
  arm64: Introduce uaccess_{disable,enable} functionality based on TTBR0_EL1
  arm64: Disable TTBR0_EL1 during normal kernel execution
  arm64: Handle faults caused by inadvertent user access with PAN enabled
  arm64: xen: Enable user access before a privcmd hvc call
  arm64: Enable CONFIG_ARM64_TTBR0_PAN

 arch/arm64/Kconfig                      |   8 ++
 arch/arm64/include/asm/assembler.h      |  37 +++++++++
 arch/arm64/include/asm/cpufeature.h     |   6 ++
 arch/arm64/include/asm/efi.h            |  14 ++++
 arch/arm64/include/asm/futex.h          |  14 ++--
 arch/arm64/include/asm/kernel-pgtable.h |   7 ++
 arch/arm64/include/asm/mmu_context.h    |  32 ++++++--
 arch/arm64/include/asm/ptrace.h         |   2 +
 arch/arm64/include/asm/thread_info.h    |   3 +
 arch/arm64/include/asm/uaccess.h        | 136 ++++++++++++++++++++++++++++++--
 arch/arm64/kernel/armv8_deprecated.c    |  10 +--
 arch/arm64/kernel/asm-offsets.c         |   3 +
 arch/arm64/kernel/cpufeature.c          |   1 +
 arch/arm64/kernel/entry.S               |  71 ++++++++++++++++-
 arch/arm64/kernel/head.S                |   6 +-
 arch/arm64/kernel/setup.c               |   8 ++
 arch/arm64/kernel/vmlinux.lds.S         |   5 ++
 arch/arm64/lib/clear_user.S             |   8 +-
 arch/arm64/lib/copy_from_user.S         |   8 +-
 arch/arm64/lib/copy_in_user.S           |   8 +-
 arch/arm64/lib/copy_to_user.S           |   8 +-
 arch/arm64/mm/context.c                 |   7 +-
 arch/arm64/mm/fault.c                   |  22 ++++--
 arch/arm64/mm/proc.S                    |  12 +--
 arch/arm64/xen/hypercall.S              |  19 +++++
 25 files changed, 381 insertions(+), 74 deletions(-)
