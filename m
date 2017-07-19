From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:24 +0100
Message-Id: <1500480092-28480-4-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 03/11] arm64: add pointer authentication register bits
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The ARMv8.3 pointer authentication extension adds:

* New fields in ID_AA64ISAR1 to report the presence of pointer
  authentication functionality.

* New control bits in SCTLR_ELx to enable this functionality.

* New system registers to hold the keys necessary for this
  functionality.

* A new ESR_ELx.EC code used when the new instructions are affected by
  configurable traps

This patch adds the relevant definitions to <asm/sysreg.h> and
<asm/esr.h> for these, to be used by subsequent patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/esr.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8cabd57..f6ebc1f 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -30,7 +30,8 @@
 #define ESR_ELx_EC_CP14_LS	(0x06)
 #define ESR_ELx_EC_FP_ASIMD	(0x07)
 #define ESR_ELx_EC_CP10_ID	(0x08)
-/* Unallocated EC: 0x09 - 0x0B */
+#define ESR_ELx_EC_PAC		(0x09)
+/* Unallocated EC: 0x0A - 0x0B */
 #define ESR_ELx_EC_CP14_64	(0x0C)
 /* Unallocated EC: 0x0d */
 #define ESR_ELx_EC_ILL		(0x0E)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16e44fa..d902cc5 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -164,6 +164,19 @@
 #define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
 #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
 
+#define SYS_APIAKEYLO_EL1		sys_reg(3, 0, 2, 1, 0)
+#define SYS_APIAKEYHI_EL1		sys_reg(3, 0, 2, 1, 1)
+#define SYS_APIBKEYLO_EL1		sys_reg(3, 0, 2, 1, 2)
+#define SYS_APIBKEYHI_EL1		sys_reg(3, 0, 2, 1, 3)
+
+#define SYS_APDAKEYLO_EL1		sys_reg(3, 0, 2, 2, 0)
+#define SYS_APDAKEYHI_EL1		sys_reg(3, 0, 2, 2, 1)
+#define SYS_APDBKEYLO_EL1		sys_reg(3, 0, 2, 2, 2)
+#define SYS_APDBKEYHI_EL1		sys_reg(3, 0, 2, 2, 3)
+
+#define SYS_APGAKEYLO_EL1		sys_reg(3, 0, 2, 3, 0)
+#define SYS_APGAKEYHI_EL1		sys_reg(3, 0, 2, 3, 1)
+
 #define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 
 #define SYS_AFSR0_EL1			sys_reg(3, 0, 5, 1, 0)
@@ -296,7 +309,11 @@
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
 /* Common SCTLR_ELx flags. */
+#define SCTLR_ELx_ENIA	(1 << 31)
+#define SCTLR_ELx_ENIB	(1 << 30)
+#define SCTLR_ELx_ENDA	(1 << 27)
 #define SCTLR_ELx_EE    (1 << 25)
+#define SCTLR_ELx_ENDB	(1 << 13)
 #define SCTLR_ELx_I	(1 << 12)
 #define SCTLR_ELx_SA	(1 << 3)
 #define SCTLR_ELx_C	(1 << 2)
@@ -326,9 +343,22 @@
 #define ID_AA64ISAR0_AES_SHIFT		4
 
 /* id_aa64isar1 */
+#define ID_AA64ISAR1_GPI_SHIFT		28
+#define ID_AA64ISAR1_GPA_SHIFT		24
 #define ID_AA64ISAR1_LRCPC_SHIFT	20
 #define ID_AA64ISAR1_FCMA_SHIFT		16
 #define ID_AA64ISAR1_JSCVT_SHIFT	12
+#define ID_AA64ISAR1_APA_SHIFT		4
+#define ID_AA64ISAR1_API_SHIFT		8
+
+#define ID_AA64ISAR1_APA_NI		0x0
+#define ID_AA64ISAR1_APA_ARCHITECTED	0x1
+#define ID_AA64ISAR1_API_NI		0x0
+#define ID_AA64ISAR1_API_IMP_DEF	0x1
+#define ID_AA64ISAR1_GPA_NI		0x0
+#define ID_AA64ISAR1_GPA_ARCHITECTED	0x1
+#define ID_AA64ISAR1_GPI_NI		0x0
+#define ID_AA64ISAR1_GPI_IMP_DEF	0x1
 
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_GIC_SHIFT		24
-- 
1.9.1
