From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:21 +0100
Message-Id: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 00/11] ARMv8.3 pointer authentication userspace support
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This series adds support for the ARMv8.3 pointer authentication extension.

Since RFC [1]:
* Make the KVM context switch (semi-lazy)
* Rebase to v4.13-rc1
* Improve pointer authentication documentation
* Add hwcap documentation
* Various minor cleanups

I've pushed the series to the arm64/pointer-auth branch [2] of my linux tree.
I've also pushed out a necessary bootwrapper patch to the pointer-auth branch
[3] of my bootwrapper repo.


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
space, and will operate as NOPs on any ARMv8 parts which do not feature the
extension (or if purposefully disabled by the kernel). Software using only this
subset of the instructions should function correctly on all ARMv8-A parts.

Additionally, instructions are added to authenticate small blocks of memory in
similar fashion, using APGAKey (A.K.A. Generic key).


This Series
===========

This series enables the use of instructions using APIAKey, which is initialised
and maintained per-process (shared by all threads). This series does not add
support for APIBKey, APDAKey, APDBKey, nor APGAKey. The series only supports
the use of an architected algorithm.

I've given this some basic testing with a homebrew test suite. More ideally,
we'd add some tests to the kernel source tree.

I've added some basic KVM support, but this doesn't cater for systems with
mismatched support. Looking forward, we'll need ID register emulation in KVM so
that we can hide features from guests to cater for such cases.


Open questions
==============

* Should keys be per-thread rather than per-process?

  My understanding is that glibc can't (currently) handle threads having
  different keys, but it might be that another libc would prefer per-thread
  keys. If desired, we could add a mechanism for a thread to re-initialize its
  keys without an exec*().

* Do we need a separate hwcap for XPAC* instructions?

  Library code performing stack unwinding may need to interoperate with other
  code which may or may not be using pointer authentication. It may be
  desirable to use XPAC* rather than attempting authentication and/or acquiring
  the PAC masks via ptrace.

  As we may expose APIBKey (potentially separately from APIAKey) in future,
  HWCAP_APIA cannot be used to determine when these instruction can/should be
  used.

* Should we expose a per-process data key now, to go with the insn key?

  I don't currently have a use-case for this.

* Should we expose generic authentication (i.e. APGAKey)?

  I don't currently have a use-case for this.

* Should the kernel remove PACs when unwinding user stacks?

  This is simple to do, but it's arguably placing a policy in the kernel as to
  what we expect user stacks to look like. Regardless, userspace will have to
  perform this when unwinding with DWARF.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-April/498941.html
[2] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/pointer-auth
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mark/boot-wrapper-aarch64.git pointer-auth

Mark Rutland (11):
  arm64: docs: describe ELF hwcaps
  asm-generic: mm_hooks: allow hooks to be overridden individually
  arm64: add pointer authentication register bits
  arm64/cpufeature: add ARMv8.3 id_aa64isar1 bits
  arm64/cpufeature: detect pointer authentication
  arm64: Don't trap host pointer auth use to EL2
  arm64: add basic pointer authentication support
  arm64: expose user PAC bit positions via ptrace
  arm64/kvm: preserve host HCR_EL2 value
  arm64/kvm: context-switch ptrauth registers
  arm64: docs: document pointer authentication

 Documentation/arm64/booting.txt                |   8 ++
 Documentation/arm64/elf_hwcaps.txt             | 138 +++++++++++++++++++++++++
 Documentation/arm64/pointer-authentication.txt |  85 +++++++++++++++
 arch/arm64/Kconfig                             |  23 +++++
 arch/arm64/include/asm/cpucaps.h               |   4 +-
 arch/arm64/include/asm/esr.h                   |   3 +-
 arch/arm64/include/asm/kvm_arm.h               |   3 +-
 arch/arm64/include/asm/kvm_host.h              |  28 ++++-
 arch/arm64/include/asm/kvm_hyp.h               |   7 ++
 arch/arm64/include/asm/mmu.h                   |   5 +
 arch/arm64/include/asm/mmu_context.h           |  25 ++++-
 arch/arm64/include/asm/pointer_auth.h          |  97 +++++++++++++++++
 arch/arm64/include/asm/sysreg.h                |  30 ++++++
 arch/arm64/include/uapi/asm/hwcap.h            |   1 +
 arch/arm64/include/uapi/asm/ptrace.h           |   5 +
 arch/arm64/kernel/cpufeature.c                 |  39 ++++++-
 arch/arm64/kernel/cpuinfo.c                    |   1 +
 arch/arm64/kernel/head.S                       |  19 +++-
 arch/arm64/kernel/ptrace.c                     |  39 +++++++
 arch/arm64/kvm/handle_exit.c                   |  21 ++++
 arch/arm64/kvm/hyp/Makefile                    |   1 +
 arch/arm64/kvm/hyp/ptrauth-sr.c                |  91 ++++++++++++++++
 arch/arm64/kvm/hyp/switch.c                    |   9 +-
 arch/arm64/kvm/hyp/tlb.c                       |   6 +-
 arch/arm64/kvm/sys_regs.c                      |  32 ++++++
 include/asm-generic/mm_hooks.h                 |  11 ++
 include/uapi/linux/elf.h                       |   1 +
 27 files changed, 719 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/arm64/elf_hwcaps.txt
 create mode 100644 Documentation/arm64/pointer-authentication.txt
 create mode 100644 arch/arm64/include/asm/pointer_auth.h
 create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c

-- 
1.9.1
