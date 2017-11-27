From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 27 Nov 2017 16:38:00 +0000
Message-Id: <20171127163806.31435-7-mark.rutland@arm.com>
In-Reply-To: <20171127163806.31435-1-mark.rutland@arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 06/12] arm64: add basic pointer authentication support
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds basic support for pointer authentication, allowing
userspace to make use of APIAKey. The kernel maintains an APIAKey value
for each process (shared by all threads within), which is initialised to
a random value at exec() time.

To describe that address authentication instructions are available, the
ID_AA64ISAR0.{APA,API} fields are exposed to userspace. A new hwcap,
APIA, is added to describe that the kernel manages APIAKey.

Instructions using other keys (APIBKey, APDAKey, APDBKey) are disabled,
and will behave as NOPs. These may be made use of in future patches.

No support is added for the generic key (APGAKey), though this cannot be
trapped or made to behave as a NOP. Its presence is not advertised with
a hwcap.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/mmu.h          |  5 ++
 arch/arm64/include/asm/mmu_context.h  | 25 +++++++++-
 arch/arm64/include/asm/pointer_auth.h | 89 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/hwcap.h   |  1 +
 arch/arm64/kernel/cpufeature.c        | 17 ++++++-
 arch/arm64/kernel/cpuinfo.c           |  1 +
 6 files changed, 134 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/include/asm/pointer_auth.h

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 0d34bf0a89c7..2bcdf7f923ba 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -16,12 +16,17 @@
 #ifndef __ASM_MMU_H
 #define __ASM_MMU_H
 
+#include <asm/pointer_auth.h>
+
 #define MMCF_AARCH32	0x1	/* mm context flag for AArch32 executables */
 
 typedef struct {
 	atomic64_t	id;
 	void		*vdso;
 	unsigned long	flags;
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	struct ptrauth_keys	ptrauth_keys;
+#endif
 } mm_context_t;
 
 /*
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 3257895a9b5e..06757a537bd7 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -31,7 +31,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/proc-fns.h>
-#include <asm-generic/mm_hooks.h>
 #include <asm/cputype.h>
 #include <asm/pgtable.h>
 #include <asm/sysreg.h>
@@ -154,7 +153,14 @@ static inline void cpu_replace_ttbr1(pgd_t *pgd)
 #define destroy_context(mm)		do { } while(0)
 void check_and_switch_context(struct mm_struct *mm, unsigned int cpu);
 
-#define init_new_context(tsk,mm)	({ atomic64_set(&(mm)->context.id, 0); 0; })
+static inline int init_new_context(struct task_struct *tsk,
+			struct mm_struct *mm)
+{
+	atomic64_set(&mm->context.id, 0);
+	mm_ctx_ptrauth_init(&mm->context);
+
+	return 0;
+}
 
 /*
  * This is called when "tsk" is about to enter lazy TLB mode.
@@ -200,6 +206,8 @@ static inline void __switch_mm(struct mm_struct *next)
 		return;
 	}
 
+	mm_ctx_ptrauth_switch(&next->context);
+
 	check_and_switch_context(next, cpu);
 }
 
@@ -226,6 +234,19 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
 void verify_cpu_asid_bits(void);
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	mm_ctx_ptrauth_dup(&oldmm->context, &mm->context);
+}
+#define arch_dup_mmap arch_dup_mmap
+
+/*
+ * We need to override arch_dup_mmap before including the generic hooks, which
+ * are otherwise sufficient for us.
+ */
+#include <asm-generic/mm_hooks.h>
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* !__ASM_MMU_CONTEXT_H */
diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
new file mode 100644
index 000000000000..964da0c3dc48
--- /dev/null
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) 2016 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_POINTER_AUTH_H
+#define __ASM_POINTER_AUTH_H
+
+#include <linux/random.h>
+
+#include <asm/cpufeature.h>
+#include <asm/sysreg.h>
+
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+/*
+ * Each key is a 128-bit quantity which is split accross a pair of 64-bit
+ * registers (Lo and Hi).
+ */
+struct ptrauth_key {
+	unsigned long lo, hi;
+};
+
+/*
+ * We give each process its own instruction A key (APIAKey), which is shared by
+ * all threads. This is inherited upon fork(), and reinitialised upon exec*().
+ * All other keys are currently unused, with APIBKey, APDAKey, and APBAKey
+ * instructions behaving as NOPs.
+ */
+struct ptrauth_keys {
+	struct ptrauth_key apia;
+};
+
+static inline void ptrauth_keys_init(struct ptrauth_keys *keys)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return;
+
+	get_random_bytes(keys, sizeof(*keys));
+}
+
+#define __ptrauth_key_install(k, v)			\
+do {							\
+	write_sysreg_s(v.lo, SYS_ ## k ## KEYLO_EL1);	\
+	write_sysreg_s(v.hi, SYS_ ## k ## KEYHI_EL1);	\
+} while (0)
+
+static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return;
+
+	__ptrauth_key_install(APIA, keys->apia);
+}
+
+static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
+				    struct ptrauth_keys *new)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return;
+
+	*new = *old;
+}
+
+#define mm_ctx_ptrauth_init(ctx) \
+	ptrauth_keys_init(&(ctx)->ptrauth_keys)
+
+#define mm_ctx_ptrauth_switch(ctx) \
+	ptrauth_keys_switch(&(ctx)->ptrauth_keys)
+
+#define mm_ctx_ptrauth_dup(oldctx, newctx) \
+	ptrauth_keys_dup(&(oldctx)->ptrauth_keys, &(newctx)->ptrauth_keys)
+
+#else
+#define mm_ctx_ptrauth_init(ctx)
+#define mm_ctx_ptrauth_switch(ctx)
+#define mm_ctx_ptrauth_dup(oldctx, newctx)
+#endif
+
+#endif /* __ASM_POINTER_AUTH_H */
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index cda76fa8b9b2..20daa89d839c 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -43,5 +43,6 @@
 #define HWCAP_ASIMDDP		(1 << 20)
 #define HWCAP_SHA512		(1 << 21)
 #define HWCAP_SVE		(1 << 22)
+#define HWCAP_APIA		(1 << 23)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index babd4c173092..9df232d16845 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -145,8 +145,8 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_FCMA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_JSCVT_SHIFT, 4, 0),
 #ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_API_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_APA_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_API_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_APA_SHIFT, 4, 0),
 #endif
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_DPB_SHIFT, 4, 0),
 	ARM64_FTR_END,
@@ -832,6 +832,15 @@ static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused
 	return is_kernel_in_hyp_mode();
 }
 
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+static int cpu_enable_address_auth(void *__unused)
+{
+	config_sctlr_el1(0, SCTLR_ELx_ENIA);
+
+	return 0;
+}
+#endif /* CONFIG_ARM64_POINTER_AUTHENTICATION */
+
 static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
 			   int __unused)
 {
@@ -1025,6 +1034,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_ADDRESS_AUTH,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = has_address_auth,
+		.enable = cpu_enable_address_auth,
 	},
 	{
 		.desc = "Generic authentication (architected algorithm)",
@@ -1092,6 +1102,9 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 #ifdef CONFIG_ARM64_SVE
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
 #endif
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_APA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_APIA),
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 1e2554543506..88db0328c366 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -76,6 +76,7 @@ static const char *const hwcap_str[] = {
 	"asimddp",
 	"sha512",
 	"sve",
+	"apia",
 	NULL
 };
 
-- 
2.11.0
