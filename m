Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:18:58 +0100
Message-Id: <1452518355-4606-6-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 05/21] arm64: kvm: deal with kernel symbols outside of linear mapping
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

KVM on arm64 uses a fixed offset between the linear mapping at EL1 and
the HYP mapping at EL2. Before we can move the kernel virtual mapping
out of the linear mapping, we have to make sure that references to kernel
symbols that are accessed via the HYP mapping are translated to their
linear equivalent.

To prevent inadvertent direct references from sneaking in later, change
the type of all extern declarations to HYP kernel symbols to the opaque
'struct kvm_ksym', which does not decay to a pointer type like char arrays
and function references. This is not bullet proof, but at least forces the
user to take the address explicitly rather than referencing it directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h    |  2 ++
 arch/arm/include/asm/kvm_mmu.h    |  2 ++
 arch/arm/kvm/arm.c                |  5 +++--
 arch/arm/kvm/mmu.c                |  8 +++-----
 arch/arm64/include/asm/kvm_asm.h  | 19 ++++++++++++-------
 arch/arm64/include/asm/kvm_host.h |  8 +++++---
 arch/arm64/include/asm/kvm_mmu.h  |  2 ++
 arch/arm64/include/asm/virt.h     |  4 ----
 arch/arm64/kvm/debug.c            |  1 +
 arch/arm64/kvm/hyp.S              |  6 +++---
 10 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 194c91b610ff..484ffdf7c70b 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -99,6 +99,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+
+extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 405aa1883307..412b363f79e9 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -30,6 +30,8 @@
 #define HYP_PAGE_OFFSET		PAGE_OFFSET
 #define KERN_TO_HYP(kva)	(kva)
 
+#define kvm_ksym_ref(kva)	(kva)
+
 /*
  * Our virtual mapping for the boot-time MMU-enable code. Must be
  * shared across all the page-tables. Conveniently, we use the vectors
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e06fd299de08..70e6d557c75f 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -969,7 +969,7 @@ static void cpu_init_hyp_mode(void *dummy)
 	pgd_ptr = kvm_mmu_get_httbr();
 	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
 	hyp_stack_ptr = stack_page + PAGE_SIZE;
-	vector_ptr = (unsigned long)__kvm_hyp_vector;
+	vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
 
 	__cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr);
 
@@ -1061,7 +1061,8 @@ static int init_hyp_mode(void)
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
-	err = create_hyp_mappings(__kvm_hyp_code_start, __kvm_hyp_code_end);
+	err = create_hyp_mappings(kvm_ksym_ref(__kvm_hyp_code_start),
+				  kvm_ksym_ref(__kvm_hyp_code_end));
 	if (err) {
 		kvm_err("Cannot map world-switch code\n");
 		goto out_free_mappings;
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7dace909d5cf..9ab9e4b6376e 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -31,8 +31,6 @@
 
 #include "trace.h"
 
-extern char  __hyp_idmap_text_start[], __hyp_idmap_text_end[];
-
 static pgd_t *boot_hyp_pgd;
 static pgd_t *hyp_pgd;
 static pgd_t *merged_hyp_pgd;
@@ -1647,9 +1645,9 @@ int kvm_mmu_init(void)
 {
 	int err;
 
-	hyp_idmap_start = kvm_virt_to_phys(__hyp_idmap_text_start);
-	hyp_idmap_end = kvm_virt_to_phys(__hyp_idmap_text_end);
-	hyp_idmap_vector = kvm_virt_to_phys(__kvm_hyp_init);
+	hyp_idmap_start = kvm_virt_to_phys(&__hyp_idmap_text_start);
+	hyp_idmap_end = kvm_virt_to_phys(&__hyp_idmap_text_end);
+	hyp_idmap_vector = kvm_virt_to_phys(&__kvm_hyp_init);
 
 	/*
 	 * We rely on the linker script to ensure at build time that the HYP
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5e377101f919..e3865845d3e1 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -105,24 +105,29 @@
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
+struct kvm_ksym;
 
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
-extern char __kvm_hyp_vector[];
+extern struct kvm_ksym __kvm_hyp_vector;
 
 #define	__kvm_hyp_code_start	__hyp_text_start
 #define	__kvm_hyp_code_end	__hyp_text_end
+extern struct kvm_ksym __hyp_text_start;
+extern struct kvm_ksym __hyp_text_end;
 
-extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
-extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern struct kvm_ksym __kvm_flush_vm_context;
+extern struct kvm_ksym __kvm_tlb_flush_vmid_ipa;
+extern struct kvm_ksym __kvm_tlb_flush_vmid;
 
-extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+extern struct kvm_ksym __kvm_vcpu_run;
 
-extern u64 __vgic_v3_get_ich_vtr_el2(void);
+extern struct kvm_ksym __hyp_idmap_text_start, __hyp_idmap_text_end;
 
-extern u32 __kvm_get_mdcr_el2(void);
+extern struct kvm_ksym __vgic_v3_get_ich_vtr_el2;
+
+extern struct kvm_ksym __kvm_get_mdcr_el2;
 
 #endif
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a35ce7266aac..90c6368ad7c8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -222,7 +222,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
-u64 kvm_call_hyp(void *hypfn, ...);
+u64 __kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
@@ -243,8 +243,8 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 	 * Call initialization code, and switch to the full blown
 	 * HYP code.
 	 */
-	kvm_call_hyp((void *)boot_pgd_ptr, pgd_ptr,
-		     hyp_stack_ptr, vector_ptr);
+	__kvm_call_hyp((void *)boot_pgd_ptr, pgd_ptr,
+		       hyp_stack_ptr, vector_ptr);
 }
 
 static inline void kvm_arch_hardware_disable(void) {}
@@ -258,4 +258,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 
+#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 61505676d085..0899026a2821 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -73,6 +73,8 @@
 
 #define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
 
+#define kvm_ksym_ref(sym)	((void *)&sym - KIMAGE_VADDR + PAGE_OFFSET)
+
 /*
  * We currently only support a 40bit IPA.
  */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 7a5df5252dd7..215ad4649dd7 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -50,10 +50,6 @@ static inline bool is_hyp_mode_mismatched(void)
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
-/* The section containing the hypervisor text */
-extern char __hyp_text_start[];
-extern char __hyp_text_end[];
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 47e5f0feaee8..f73d8c9b999b 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -24,6 +24,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #include "trace.h"
 
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 86c289832272..309e3479dc2c 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -923,7 +923,7 @@ __hyp_panic_str:
 	.align	2
 
 /*
- * u64 kvm_call_hyp(void *hypfn, ...);
+ * u64 __kvm_call_hyp(void *hypfn, ...);
  *
  * This is not really a variadic function in the classic C-way and care must
  * be taken when calling this to ensure parameters are passed in registers
@@ -940,10 +940,10 @@ __hyp_panic_str:
  * used to implement __hyp_get_vectors in the same way as in
  * arch/arm64/kernel/hyp_stub.S.
  */
-ENTRY(kvm_call_hyp)
+ENTRY(__kvm_call_hyp)
 	hvc	#0
 	ret
-ENDPROC(kvm_call_hyp)
+ENDPROC(__kvm_call_hyp)
 
 .macro invalid_vector	label, target
 	.align	2
-- 
2.5.0
