From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 27 Nov 2017 16:38:03 +0000
Message-Id: <20171127163806.31435-10-mark.rutland@arm.com>
In-Reply-To: <20171127163806.31435-1-mark.rutland@arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 09/12] arm64/kvm: preserve host HCR_EL2 value
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
is a constant value. This works today, as the host HCR_EL2 value is
always the same, but this will get in the way of supporting extensions
that require HCR_EL2 bits to be set conditionally for the host.

To allow such features to work without KVM having to explicitly handle
every possible host feature combination, this patch has KVM save/restore
the host HCR when switching to/from a guest HCR.

For __{activate,deactivate}_traps(), the HCR save/restore is made common
across the !VHE and VHE paths. As the host and guest HCR values must
have E2H set when VHE is in use, register redirection should always be
in effect at EL2, and this change should not adversely affect the VHE
code.

For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
to toggle the TGE bit with a RMW sequence, as we already do in
__tlb_switch_to_guest_vhe().

The now unused HCR_HOST_VHE_FLAGS definition is removed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_arm.h  | 1 -
 arch/arm64/include/asm/kvm_host.h | 5 ++++-
 arch/arm64/kvm/hyp/switch.c       | 5 +++--
 arch/arm64/kvm/hyp/tlb.c          | 6 +++++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 62854d5d1d3b..aa02b05430e8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -84,7 +84,6 @@
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
 #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
-#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_RES1		((1 << 31) | (1 << 23))
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 674912d7a571..39184aa3e2f2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -199,10 +199,13 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* HYP configuration */
+	/* Guest HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
 
+	/* Host HYP configuration */
+	u64 host_hcr_el2;
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 525c01f48867..2205f0be3ced 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -71,6 +71,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
+	vcpu->arch.host_hcr_el2 = read_sysreg(hcr_el2);
+
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
 	 * register accesses to EL2, however, the ARM ARM clearly states that
@@ -116,7 +118,6 @@ static void __hyp_text __deactivate_traps_vhe(void)
 		    MDCR_EL2_TPMS;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
 }
@@ -129,7 +130,6 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_RW, hcr_el2);
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
@@ -151,6 +151,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	__deactivate_traps_arch()();
 	write_sysreg(0, hstr_el2);
 	write_sysreg(0, pmuserenr_el0);
+	write_sysreg(vcpu->arch.host_hcr_el2, hcr_el2);
 }
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 73464a96c365..c2b0680efa2c 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -49,12 +49,16 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 
 static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm)
 {
+	u64 val;
+
 	/*
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
 	write_sysreg(0, vttbr_el2);
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	val = read_sysreg(hcr_el2);
+	val |= HCR_TGE;
+	write_sysreg(val, hcr_el2);
 }
 
 static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm)
-- 
2.11.0
