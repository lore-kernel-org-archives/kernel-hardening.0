From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 04/11] arm64: Don't trap host pointer auth use to EL2
Date: Tue, 17 Apr 2018 19:37:28 +0100
Message-Id: <20180417183735.56985-5-mark.rutland@arm.com>
In-Reply-To: <20180417183735.56985-1-mark.rutland@arm.com>
References: <20180417183735.56985-1-mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, cdall@kernel.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

To allow EL0 (and/or EL1) to use pointer authentication functionality,
we must ensure that pointer authentication instructions and accesses to
pointer authentication keys are not trapped to EL2.

This patch ensures that HCR_EL2 is configured appropriately when the
kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
ensuring that EL1 can access keys and permit EL0 use of instructions.
For VHE kernels host EL0 (TGE && E2H) is unaffected by these settings,
and it doesn't matter how we configure HCR_EL2.{API,APK}, so we don't
bother setting them.

This does not enable support for KVM guests, since KVM manages HCR_EL2
itself when running VMs.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_arm.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 89b3dda7e3cb..4d57e1e58323 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,8 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_API		(UL(1) << 41)
+#define HCR_APK		(UL(1) << 40)
 #define HCR_TEA		(UL(1) << 37)
 #define HCR_TERR	(UL(1) << 36)
 #define HCR_TLOR	(UL(1) << 35)
@@ -86,7 +88,7 @@
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
-#define HCR_HOST_NVHE_FLAGS (HCR_RW)
+#define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
-- 
2.11.0
