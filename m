From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:27 +0100
Message-Id: <1500480092-28480-7-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 06/11] arm64: Don't trap host pointer auth use to EL2
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

To allow EL0 (and/or EL1) to use pointer authentication functionality,
we must ensure that pointer authentication instructions and accesses to
pointer authentication keys are not trapped to EL2 (where we will not be
able to handle them).

This patch ensures that HCR_EL2 is configured appropriately when the
kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
ensuring that EL1 can access keys and permit EL0 use of instructions.
For VHE kernels, EL2 access is controlled by EL3, and we need not set
anything.

This does not enable support for KVM guests, since KVM manages HCR_EL2
itself.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_arm.h |  2 ++
 arch/arm64/kernel/head.S         | 19 +++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 61d694c..c1267e8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,8 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_API		(UL(1) << 41)
+#define HCR_APK		(UL(1) << 40)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 973df7d..8b8e8d7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -412,10 +412,25 @@ CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
 
 	/* Hyp configuration. */
 	mov	x0, #HCR_RW			// 64-bit EL1
-	cbz	x2, set_hcr
+	cbz	x2, 1f
 	orr	x0, x0, #HCR_TGE		// Enable Host Extensions
 	orr	x0, x0, #HCR_E2H
-set_hcr:
+1:
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	/*
+	 * Disable pointer authentication traps to EL2. The HCR_EL2.{APK,API}
+	 * bits exist iff at least one authentication mechanism is implemented.
+	 */
+	mrs	x1, id_aa64isar1_el1
+	mov_q	x3, ((0xf << ID_AA64ISAR1_GPI_SHIFT) | \
+		     (0xf << ID_AA64ISAR1_GPA_SHIFT) | \
+		     (0xf << ID_AA64ISAR1_API_SHIFT) | \
+		     (0xf << ID_AA64ISAR1_APA_SHIFT))
+	and	x1, x1, x3
+	cbz	x1, 1f
+	orr	x0, x0, #(HCR_APK | HCR_API)
+1:
+#endif
 	msr	hcr_el2, x0
 	isb
 
-- 
1.9.1
