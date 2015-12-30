Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 30 Dec 2015 16:26:04 +0100
Message-Id: <1451489172-17420-6-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v2 05/13] arm64: kvm: deal with kernel symbols outside of linear mapping
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
 arch/arm/include/asm/kvm_asm.h   |  2 ++
 arch/arm/include/asm/kvm_mmu.h   |  2 ++
 arch/arm/kvm/arm.c               |  9 +++++----
 arch/arm/kvm/mmu.c               | 12 +++++------
 arch/arm64/include/asm/kvm_asm.h | 21 +++++++++++---------
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 arch/arm64/include/asm/virt.h    |  4 ----
 arch/arm64/kernel/vmlinux.lds.S  |  4 ++--
 arch/arm64/kvm/debug.c           |  4 +++-
 virt/kvm/arm/vgic-v3.c           |  2 +-
 10 files changed, 34 insertions(+), 28 deletions(-)

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
index e06fd299de08..014b542ea658 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -427,7 +427,7 @@ static void update_vttbr(struct kvm *kvm)
 		 * shareable domain to make sure all data structures are
 		 * clean.
 		 */
-		kvm_call_hyp(__kvm_flush_vm_context);
+		kvm_call_hyp(kvm_ksym_ref(__kvm_flush_vm_context));
 	}
 
 	kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
@@ -600,7 +600,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		__kvm_guest_enter();
 		vcpu->mode = IN_GUEST_MODE;
 
-		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
+		ret = kvm_call_hyp(kvm_ksym_ref(__kvm_vcpu_run), vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		/*
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
index 7dace909d5cf..7c448b943e3a 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -31,8 +31,6 @@
 
 #include "trace.h"
 
-extern char  __hyp_idmap_text_start[], __hyp_idmap_text_end[];
-
 static pgd_t *boot_hyp_pgd;
 static pgd_t *hyp_pgd;
 static pgd_t *merged_hyp_pgd;
@@ -63,7 +61,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid, kvm);
+	kvm_call_hyp(kvm_ksym_ref(__kvm_tlb_flush_vmid), kvm);
 }
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
@@ -75,7 +73,7 @@ static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * anything there.
 	 */
 	if (kvm)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
+		kvm_call_hyp(kvm_ksym_ref(__kvm_tlb_flush_vmid_ipa), kvm, ipa);
 }
 
 /*
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
index 5e377101f919..830402f847e0 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -105,24 +105,27 @@
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
+struct kvm_ksym;
 
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
-extern char __kvm_hyp_vector[];
+extern struct kvm_ksym __kvm_hyp_vector;
 
-#define	__kvm_hyp_code_start	__hyp_text_start
-#define	__kvm_hyp_code_end	__hyp_text_end
+extern struct kvm_ksym __kvm_hyp_code_start;
+extern struct kvm_ksym __kvm_hyp_code_end;
 
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
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 363c2f529951..f935f082188d 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -35,9 +35,9 @@ jiffies = jiffies_64;
 	VMLINUX_SYMBOL(__hyp_idmap_text_start) = .;	\
 	*(.hyp.idmap.text)				\
 	VMLINUX_SYMBOL(__hyp_idmap_text_end) = .;	\
-	VMLINUX_SYMBOL(__hyp_text_start) = .;		\
+	VMLINUX_SYMBOL(__kvm_hyp_code_start) = .;	\
 	*(.hyp.text)					\
-	VMLINUX_SYMBOL(__hyp_text_end) = .;
+	VMLINUX_SYMBOL(__kvm_hyp_code_end) = .;
 
 #define IDMAP_TEXT					\
 	. = ALIGN(SZ_4K);				\
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 47e5f0feaee8..99e5a403af4e 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -24,6 +24,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #include "trace.h"
 
@@ -72,7 +73,8 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 void kvm_arm_init_debug(void)
 {
-	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
+	__this_cpu_write(mdcr_el2,
+			 kvm_call_hyp(kvm_ksym_ref(__kvm_get_mdcr_el2)));
 }
 
 /**
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 487d6357b7e7..58f5a6521307 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -247,7 +247,7 @@ int vgic_v3_probe(struct device_node *vgic_node,
 		goto out;
 	}
 
-	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	ich_vtr_el2 = kvm_call_hyp(kvm_ksym_ref(__vgic_v3_get_ich_vtr_el2));
 
 	/*
 	 * The ListRegs field is 5 bits, but there is a architectural
-- 
2.5.0
