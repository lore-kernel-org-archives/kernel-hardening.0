From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:29 +0100
Message-Id: <1500480092-28480-9-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 08/11] arm64: expose user PAC bit positions via ptrace
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When pointer authentication is in use, data/instruction pointers have a
number of PAC bits inserted into them. The number and position of these
bits depends on the configured TCR_ELx.TxSZ and whether tagging is
enabled. ARMv8.3 allows tagging to differ for instruction and data
pointers.

For userspace debuggers to unwind the stack and/or to follow pointer
chains, they need to be able to remove the PAC bits before attempting to
use a pointer.

This patch adds a new structure with masks describing the location of
the PAC bits in userspace instruction and data pointers (i.e. those
addressable via TTBR0), which userspace can query via PTRACE_GETREGSET.
By clearing these bits from pointers, userspace can acquire the PAC-less
versions.

This new regset is exposed when the kernel is built with (user) pointer
authentication support, and the feature is enabled. Otherwise, it is
hidden.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jiong Wang <jiong.wang@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yao Qi <yao.qi@arm.com>
---
 arch/arm64/include/asm/pointer_auth.h |  8 +++++++
 arch/arm64/include/uapi/asm/ptrace.h  |  5 +++++
 arch/arm64/kernel/ptrace.c            | 39 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h              |  1 +
 4 files changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index 964da0c..ae72c7c 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -16,9 +16,11 @@
 #ifndef __ASM_POINTER_AUTH_H
 #define __ASM_POINTER_AUTH_H
 
+#include <linux/bitops.h>
 #include <linux/random.h>
 
 #include <asm/cpufeature.h>
+#include <asm/memory.h>
 #include <asm/sysreg.h>
 
 #ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
@@ -71,6 +73,12 @@ static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
 	*new = *old;
 }
 
+/*
+ * The pointer bits used by a pointer authentication code.
+ * If we were to use tagged pointers, bits 63:56 would also apply.
+ */
+#define ptrauth_pac_mask() 	GENMASK(54, VA_BITS)
+
 #define mm_ctx_ptrauth_init(ctx) \
 	ptrauth_keys_init(&(ctx)->ptrauth_keys)
 
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index d1ff83d..5092fbf 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -90,6 +90,11 @@ struct user_hwdebug_state {
 	}		dbg_regs[16];
 };
 
+struct user_pac_mask {
+	__u64		data_mask;
+	__u64		insn_mask;
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI__ASM_PTRACE_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 1b38c01..fae9d50 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -40,8 +40,10 @@
 #include <linux/elf.h>
 
 #include <asm/compat.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
+#include <asm/pointer_auth.h>
 #include <asm/syscall.h>
 #include <asm/traps.h>
 #include <asm/system_misc.h>
@@ -701,6 +703,30 @@ static int system_call_set(struct task_struct *target,
 	return ret;
 }
 
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+static int pac_mask_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	/*
+	 * The PAC bits can differ across data and instruction pointers
+	 * depending on TCR_EL1.TBID*, which we may make use of in future, so
+	 * we expose separate masks.
+	 */
+	unsigned long mask = ptrauth_pac_mask();
+	struct user_pac_mask uregs = {
+		.data_mask = mask,
+		.insn_mask = mask,
+	};
+
+	if (!cpus_have_cap(ARM64_HAS_ADDRESS_AUTH))
+		return -EINVAL;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &uregs, 0, -1);
+}
+#endif
+
 enum aarch64_regset {
 	REGSET_GPR,
 	REGSET_FPR,
@@ -710,6 +736,9 @@ enum aarch64_regset {
 	REGSET_HW_WATCH,
 #endif
 	REGSET_SYSTEM_CALL,
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	REGSET_PAC_MASK,
+#endif
 };
 
 static const struct user_regset aarch64_regsets[] = {
@@ -767,6 +796,16 @@ enum aarch64_regset {
 		.get = system_call_get,
 		.set = system_call_set,
 	},
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	[REGSET_PAC_MASK] = {
+		.core_note_type = NT_ARM_PAC_MASK,
+		.n = sizeof(struct user_pac_mask) / sizeof(u64),
+		.size = sizeof(u64),
+		.align = sizeof(u64),
+		.get = pac_mask_get,
+		/* this cannot be set dynamically */
+	},
+#endif
 };
 
 static const struct user_regset_view user_aarch64_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index b5280db..60652f1 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -416,6 +416,7 @@
 #define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
 #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
+#define NT_ARM_PAC_MASK		0x406	/* ARM pointer authentication code masks */
 #define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
 #define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
 #define NT_METAG_TLS	0x502		/* Metag TLS pointer */
-- 
1.9.1
