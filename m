From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:26 +0100
Message-Id: <1500480092-28480-6-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 05/11] arm64/cpufeature: detect pointer authentication
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

So that we can dynamically handle the presence of pointer authentication
functionality, wire up probing code in cpufeature.c.

Currently, this only detects the presence of an architected algorithm.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  4 +++-
 arch/arm64/kernel/cpufeature.c   | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8d2272c..903b458 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -39,7 +39,9 @@
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
+#define ARM64_HAS_ADDRESS_AUTH			21
+#define ARM64_HAS_GENERIC_AUTH			22
 
-#define ARM64_NCAPS				21
+#define ARM64_NCAPS				23
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b23ad83..4016b1e7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -892,6 +892,28 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	{
+		.desc = "Address authentication (architected algorithm)",
+		.capability = ARM64_HAS_ADDRESS_AUTH,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_APA_SHIFT,
+		.min_field_value = ID_AA64ISAR1_APA_ARCHITECTED,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.desc = "Generic authentication (architected algorithm)",
+		.capability = ARM64_HAS_GENERIC_AUTH,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_GPA_SHIFT,
+		.min_field_value = ID_AA64ISAR1_GPA_ARCHITECTED,
+		.matches = has_cpuid_feature
+	},
+#endif /* CONFIG_ARM64_POINTER_AUTHENTICATION */
 	{},
 };
 
-- 
1.9.1
