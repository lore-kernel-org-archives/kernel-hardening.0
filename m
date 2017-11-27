From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 27 Nov 2017 16:37:54 +0000
Message-Id: <20171127163806.31435-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 00/12] ARMv8.3 pointer authentication userspace support
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

This series adds support for the ARMv8.3 pointer authentication extension,
enabling userspace return address protection with recent versions of GCC.

Since RFC [1]:
* Make the KVM context switch (semi-lazy)
* Rebase to v4.13-rc1
* Improve pointer authentication documentation
* Add hwcap documentation
* Various minor cleanups

Since v1 [2]:
* Rebase to v4.15-rc1
* Settle on per-process keys
* Strip PACs when unwinding userspace
* Don't expose an XPAC hwcap (this is implied by ID registers)
* Leave APIB, ABPDA, APDB, and APGA keys unsupported for now
* Support IMP DEF algorithms
* Rely on KVM ID register emulation
* Various cleanups

While there are use-cases for keys other than APIAKey, the only software that
I'm aware of with pointer authentication support is GCC, which only makes use
of APIAKey. I'm happy to add support for other keys as users appear.

I've pushed the series to the arm64/pointer-auth branch [3] of my linux tree.
I've also pushed out a necessary bootwrapper patch to the pointer-auth branch
[4] of my bootwrapper repo.


Extension Overview 
==================

The ARMv8.3 pointer authentication extension adds functionality to detect
modification of pointer values, mitigating certain classes of attack such as
stack smashing, and making return oriented programming attacks harder

The extension introduces the concept of a pointer authentication code (PAC),
which is stored in some upper bits of pointers. Each PAC is derived from the
original pointer, another 64-bit value (e.g. the stack pointer), and a secret
128-bit key.

New instructions are added which can be used to:

* Insert a PAC into a pointer
* Strip a PAC from a pointer
* Authenticate strip a PAC from a pointer

If authentication succeeds, the code is removed, yielding the original pointer.
If authentication fails, bits are set in the pointer such that it is guaranteed
to cause a fault if used.

These instructions can make use of four keys:

* APIAKey (A.K.A. Instruction A key)
* APIBKey (A.K.A. Instruction B key)
* APDAKey (A.K.A. Data A key)
* APDBKey (A.K.A. Data B Key)

A subset of these instruction encodings have been allocated from the HINT
space, and will operate as NOPs on any ARMv8-A parts which do not feature the
extension (or if purposefully disabled by the kernel). Software using only this
subset of the instructions should function correctly on all ARMv8-A parts.

Additionally, instructions are added to authenticate small blocks of memory in
similar fashion, using APGAKey (A.K.A. Generic key).


This Series
===========

This series enables the use of instructions using APIAKey, which is initialised
and maintained per-process (shared by all threads). This series does not add
support for APIBKey, APDAKey, APDBKey, nor APGAKey.

I've given this some basic testing with a homebrew test suite. More ideally,
we'd add some tests to the kernel source tree.

I've added some basic KVM support, which relies on the recently introduced ID
register emulation to hide mismatched support from guests.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-April/498941.html
[2] https://lkml.kernel.org/r/1500480092-28480-1-git-send-email-mark.rutland@arm.com
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/pointer-auth
[4] git://git.kernel.org/pub/scm/linux/kernel/git/mark/boot-wrapper-aarch64.git pointer-auth


Mark Rutland (12):
  asm-generic: mm_hooks: allow hooks to be overridden individually
  arm64: add pointer authentication register bits
  arm64/cpufeature: add ARMv8.3 id_aa64isar1 bits
  arm64/cpufeature: detect pointer authentication
  arm64: Don't trap host pointer auth use to EL2
  arm64: add basic pointer authentication support
  arm64: expose user PAC bit positions via ptrace
  arm64: perf: strip PAC when unwinding userspace
  arm64/kvm: preserve host HCR_EL2 value
  arm64/kvm: context-switch ptrauth registers
  arm64: enable pointer authentication
  arm64: docs: document pointer authentication

 Documentation/arm64/booting.txt                |   8 ++
 Documentation/arm64/elf_hwcaps.txt             |   6 ++
 Documentation/arm64/pointer-authentication.txt |  85 ++++++++++++++++++++
 arch/arm64/Kconfig                             |  23 ++++++
 arch/arm64/include/asm/cpucaps.h               |   8 +-
 arch/arm64/include/asm/esr.h                   |   3 +-
 arch/arm64/include/asm/kvm_arm.h               |   3 +-
 arch/arm64/include/asm/kvm_host.h              |  28 ++++++-
 arch/arm64/include/asm/kvm_hyp.h               |   7 ++
 arch/arm64/include/asm/mmu.h                   |   5 ++
 arch/arm64/include/asm/mmu_context.h           |  25 +++++-
 arch/arm64/include/asm/pointer_auth.h          | 104 +++++++++++++++++++++++++
 arch/arm64/include/asm/sysreg.h                |  30 +++++++
 arch/arm64/include/uapi/asm/hwcap.h            |   1 +
 arch/arm64/include/uapi/asm/ptrace.h           |   7 ++
 arch/arm64/kernel/cpufeature.c                 | 103 ++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                    |   1 +
 arch/arm64/kernel/head.S                       |  19 ++++-
 arch/arm64/kernel/perf_callchain.c             |   5 +-
 arch/arm64/kernel/ptrace.c                     |  38 +++++++++
 arch/arm64/kvm/handle_exit.c                   |  21 +++++
 arch/arm64/kvm/hyp/Makefile                    |   1 +
 arch/arm64/kvm/hyp/ptrauth-sr.c                |  91 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c                    |   9 ++-
 arch/arm64/kvm/hyp/tlb.c                       |   6 +-
 arch/arm64/kvm/sys_regs.c                      |  32 ++++++++
 include/asm-generic/mm_hooks.h                 |  11 +++
 include/uapi/linux/elf.h                       |   1 +
 28 files changed, 668 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/arm64/pointer-authentication.txt
 create mode 100644 arch/arm64/include/asm/pointer_auth.h
 create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c

-- 
2.11.0
