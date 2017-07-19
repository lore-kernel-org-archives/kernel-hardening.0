From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:31 +0100
Message-Id: <1500480092-28480-11-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 10/11] arm64/kvm: context-switch ptrauth registers
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When pointer authentication is supported, a guest may wish to use it.
This patch adds the necessary KVM infrastructure for this to work, with
a semi-lazy context switch of the pointer auth state.

When we schedule a vcpu, we disable guest usage of pointer
authentication instructions and accesses to the keys. While these are
disabled, we avoid context-switching the keys. When we trap the guest
trying to use pointer authentication functionality, we change to eagerly
context-switching the keys, and enable the feature. The next time the
vcpu is scheduled out/in, we start again.

This is sufficient for systems with uniform pointer authentication
support. For systems with mismatched support, it will be necessary to
hide the feature from the guest's view of the ID registers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_host.h | 23 +++++++++-
 arch/arm64/include/asm/kvm_hyp.h  |  7 +++
 arch/arm64/kvm/handle_exit.c      | 21 +++++++++
 arch/arm64/kvm/hyp/Makefile       |  1 +
 arch/arm64/kvm/hyp/ptrauth-sr.c   | 91 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c       |  4 ++
 arch/arm64/kvm/sys_regs.c         | 32 ++++++++++++++
 7 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0d7c3dd..f97defa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -135,6 +135,18 @@ enum vcpu_sysreg {
 	PMSWINC_EL0,	/* Software Increment Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
+	/* Pointer Authentication Registers */
+	APIAKEYLO_EL1,
+	APIAKEYHI_EL1,
+	APIBKEYLO_EL1,
+	APIBKEYHI_EL1,
+	APDAKEYLO_EL1,
+	APDAKEYHI_EL1,
+	APDBKEYLO_EL1,
+	APDBKEYHI_EL1,
+	APGAKEYLO_EL1,
+	APGAKEYHI_EL1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -368,10 +380,19 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr);
 }
 
+void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	kvm_arm_vcpu_ptrauth_disable(vcpu);
+}
+
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4572a9b..3093f35 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -152,6 +152,13 @@ void __debug_restore_state(struct kvm_vcpu *vcpu,
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
+void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
+			       struct kvm_cpu_context *host_ctxt,
+			       struct kvm_cpu_context *guest_ctxt);
+void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
+			      struct kvm_cpu_context *host_ctxt,
+			      struct kvm_cpu_context *guest_ctxt);
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a16..9fc561f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -136,6 +136,26 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return ret;
 }
 
+/*
+ * Handle the guest trying to use a ptrauth instruction, or trying to access a
+ * ptrauth register.
+ */
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
+{
+	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH) &&
+	    cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
+		kvm_arm_vcpu_ptrauth_enable(vcpu);
+	} else {
+		kvm_inject_undefined(vcpu);
+	}
+}
+
+static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	kvm_arm_vcpu_ptrauth_trap(vcpu);
+	return 1;
+}
+
 static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
@@ -168,6 +188,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
+	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 14c4e3b..91f2100 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
+obj-$(CONFIG_KVM_ARM_HOST) += ptrauth-sr.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
new file mode 100644
index 0000000..2784fb3
--- /dev/null
+++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2017 ARM Ltd
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
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/cpucaps.h>
+#include <asm/cpufeature.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+
+static bool __hyp_text __ptrauth_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.hcr_el2 & (HCR_API | HCR_APK);
+}
+
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static void __hyp_text __ptrauth_save_state(struct kvm_cpu_context *ctxt)
+{
+	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH)) {
+		__ptrauth_save_key(ctxt->sys_regs, APIA);
+		__ptrauth_save_key(ctxt->sys_regs, APIB);
+		__ptrauth_save_key(ctxt->sys_regs, APDA);
+		__ptrauth_save_key(ctxt->sys_regs, APDB);
+	}
+
+	if (cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
+		__ptrauth_save_key(ctxt->sys_regs, APGA);
+	}
+}
+
+#define __ptrauth_restore_key(regs, key) 					\
+({										\
+	write_sysreg_s(regs[key ## KEYLO_EL1], SYS_ ## key ## KEYLO_EL1);	\
+	write_sysreg_s(regs[key ## KEYHI_EL1], SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static void __hyp_text __ptrauth_restore_state(struct kvm_cpu_context *ctxt)
+{
+
+	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH)) {
+		__ptrauth_restore_key(ctxt->sys_regs, APIA);
+		__ptrauth_restore_key(ctxt->sys_regs, APIB);
+		__ptrauth_restore_key(ctxt->sys_regs, APDA);
+		__ptrauth_restore_key(ctxt->sys_regs, APDB);
+	}
+
+	if (cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
+		__ptrauth_restore_key(ctxt->sys_regs, APGA);
+	}
+}
+
+void __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
+					  struct kvm_cpu_context *host_ctxt,
+					  struct kvm_cpu_context *guest_ctxt)
+{
+	if (!__ptrauth_is_enabled(vcpu))
+		return;
+
+	__ptrauth_save_state(host_ctxt);
+	__ptrauth_restore_state(guest_ctxt);
+}
+
+void __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
+					 struct kvm_cpu_context *host_ctxt,
+					 struct kvm_cpu_context *guest_ctxt)
+{
+	if (!__ptrauth_is_enabled(vcpu))
+		return;
+
+	__ptrauth_save_state(guest_ctxt);
+	__ptrauth_restore_state(host_ctxt);
+}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 6108813..df609d9 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -309,6 +309,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg_restore_guest_state(guest_ctxt);
 	__debug_restore_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 
+	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
+
 	/* Jump in the fire! */
 again:
 	exit_code = __guest_enter(vcpu, host_ctxt);
@@ -367,6 +369,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	fp_enabled = __fpsimd_enabled();
 
+	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
+
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_save_state(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7786288..0f7d9ae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -837,6 +837,32 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
+
+void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+}
+
+void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
+}
+
+static bool trap_ptrauth(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *rd)
+{
+	kvm_arm_vcpu_ptrauth_trap(vcpu);
+	return false;
+}
+
+#define __PTRAUTH_KEY(k)						\
+	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k }
+
+#define PTRAUTH_KEY(k)							\
+	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
+	__PTRAUTH_KEY(k ## KEYHI_EL1)
+
 static bool access_cntp_tval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
@@ -950,6 +976,12 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
 
+	PTRAUTH_KEY(APIA),
+	PTRAUTH_KEY(APIB),
+	PTRAUTH_KEY(APDA),
+	PTRAUTH_KEY(APDB),
+	PTRAUTH_KEY(APGA),
+
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
-- 
1.9.1
