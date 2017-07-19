From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:32 +0100
Message-Id: <1500480092-28480-12-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 11/11] arm64: docs: document pointer authentication
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that we've added code to support pointer authentication, add some
documentation so that people can figure out if/how to use it.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jiong Wang <jiong.wang@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yao Qi <yao.qi@arm.com>
---
 Documentation/arm64/booting.txt                |  8 +++
 Documentation/arm64/elf_hwcaps.txt             |  5 ++
 Documentation/arm64/pointer-authentication.txt | 85 ++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)
 create mode 100644 Documentation/arm64/pointer-authentication.txt

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 8d0df62..8df9f46 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -205,6 +205,14 @@ Before jumping into the kernel, the following conditions must be met:
     ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b0.
   - The DT or ACPI tables must describe a GICv2 interrupt controller.
 
+  For CPUs with pointer authentication functionality:
+  - If EL3 is present:
+    SCR_EL3.APK (bit 16) must be initialised to 0b1
+    SCR_EL3.API (bit 17) must be initialised to 0b1
+  - If the kernel is entered at EL1:
+    HCR_EL2.APK (bit 40) must be initialised to 0b1
+    HCR_EL2.API (bit 41) must be initialised to 0b1
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.
diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
index 7bc2921..91c4441 100644
--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -131,3 +131,8 @@ HWCAP_LRCPC
 
     Functionality implied by ID_AA64ISAR1_EL1.LRCPC == 0b0001.
 
+HWCAP_APIA
+
+    EL0 AddPac and Auth functionality using APIAKey_EL1 is enabled, as
+    described by Documentation/arm64/pointer-authentication.txt.
+
diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
new file mode 100644
index 0000000..e9b5c6b
--- /dev/null
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -0,0 +1,85 @@
+Pointer authentication in AArch64 Linux
+=======================================
+
+Author: Mark Rutland <mark.rutland@arm.com>
+Date: 2017-07-19
+
+This document briefly describes the provision of pointer authentication
+functionality in AArch64 Linux.
+
+
+Architecture overview
+---------------------
+
+The ARMv8.3 Pointer Authentication extension adds primitives that can be
+used to mitigate certain classes of attack where an attacker can corrupt
+the contents of some memory (e.g. the stack).
+
+The extension uses a Pointer Authentication Code (PAC) to determine
+whether pointers have been modified unexpectedly. A PAC is derived from
+a pointer, another value (such as the stack pointer), and a secret key
+held in system registers.
+
+The extension adds instructions to insert a valid PAC into a pointer,
+and to verify/remove the PAC from a pointer. The PAC occupies a number
+of high-order bits of the pointer, which varies dependent on the
+configured virtual address size and whether pointer tagging is in use.
+
+A subset of these instructions have been allocated from the HINT
+encoding space. In the absence of the extension (or when disabled),
+these instructions behave as NOPs. Applications and libraries using
+these instructions operate correctly regardless of the presence of the
+extension.
+
+
+Basic support
+-------------
+
+When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and relevant HW
+support is present, the kernel will assign a random APIAKey value to
+each process at exec*() time. This key is shared by all threads within
+the process, and the key is preserved across fork(). Presence of
+functionality using APIAKey is advertised via HWCAP_APIA.
+
+Recent versions of GCC can compile code with APIAKey-based return
+address protection when passed the -msign-return-address option. This
+uses instructions in the HINT space, and such code can run on systems
+without the pointer authentication extension.
+
+The remaining instruction and data keys (APIBKey, APDAKey, APDBKey) are
+reserved for future use, and instructions using these keys must not be
+used by software until a purpose and scope for their use has been
+decided. To enable future software using these keys to function on
+contemporary kernels, where possible, instructions using these keys are
+made to behave as NOPs.
+
+The generic key (APGAKey) is currently unsupported. Instructions using
+the generic key must not be used by software.
+
+
+Debugging
+---------
+
+When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and relevant HW
+support is present, the kernel will expose the position of TTBR0 PAC
+bits in the NT_ARM_PAC_MASK regset (struct user_pac_mask), which
+userspace can acqure via PTRACE_GETREGSET.
+
+Separate masks are exposed for data pointers and instruction pointers,
+as the set of PAC bits can vary between the two. Debuggers should not
+expect that HWCAP_APIA implies the presence (or non-presence) of this
+regset -- in future the kernel may support the use of APIBKey, APDAKey,
+and/or APBAKey, even in the absence of APIAKey.
+
+Note that the masks apply to TTBR0 addresses, and are not valid to apply
+to TTBR1 addresses (e.g. kernel pointers).
+
+
+Virtualization
+--------------
+
+When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and uniform HW
+support is present, KVM will context switch all keys used by vCPUs.
+Otherwise, the feature is disabled. When disabled, accesses to keys, or
+use of instructions enabled within the guest will trap to EL2, and an
+UNDEFINED exception will be injected into the guest.
-- 
1.9.1
