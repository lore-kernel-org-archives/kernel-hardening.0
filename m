Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:32 +0100
Message-Id: <1453828249-14467-6-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 05/22] arm64: kvm: deal with kernel symbols outside of linear mapping
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

KVM on arm64 uses a fixed offset between the linear mapping at EL1 and
the HYP mapping at EL2. Before we can move the kernel virtual mapping
out of the linear mapping, we have to make sure that references to kernel
symbols that are accessed via the HYP mapping are translated to their
linear equivalent.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h    | 2 ++
 arch/arm/kvm/arm.c                | 8 +++++---
 arch/arm64/include/asm/kvm_asm.h  | 2 ++
 arch/arm64/include/asm/kvm_host.h | 8 +++++---
 arch/arm64/kvm/hyp.S              | 6 +++---
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 194c91b610ff..c35c349da069 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -79,6 +79,8 @@
 #define rr_lo_hi(a1, a2) a1, a2
 #endif
 
+#define kvm_ksym_ref(kva)	(kva)
+
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dda1959f0dde..975da6cfbf59 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -982,7 +982,7 @@ static void cpu_init_hyp_mode(void *dummy)
 	pgd_ptr = kvm_mmu_get_httbr();
 	stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
 	hyp_stack_ptr = stack_page + PAGE_SIZE;
-	vector_ptr = (unsigned long)__kvm_hyp_vector;
+	vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
 
 	__cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr);
 
@@ -1074,13 +1074,15 @@ static int init_hyp_mode(void)
 	/*
 	 * Map the Hyp-code called directly from the host
 	 */
-	err = create_hyp_mappings(__kvm_hyp_code_start, __kvm_hyp_code_end);
+	err = create_hyp_mappings(kvm_ksym_ref(__kvm_hyp_code_start),
+				  kvm_ksym_ref(__kvm_hyp_code_end));
 	if (err) {
 		kvm_err("Cannot map world-switch code\n");
 		goto out_free_mappings;
 	}
 
-	err = create_hyp_mappings(__start_rodata, __end_rodata);
+	err = create_hyp_mappings(kvm_ksym_ref(__start_rodata),
+				  kvm_ksym_ref(__end_rodata));
 	if (err) {
 		kvm_err("Cannot map rodata section\n");
 		goto out_free_mappings;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 52b777b7d407..30e0e04c9f16 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -26,6 +26,8 @@
 #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
 #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
 
+#define kvm_ksym_ref(sym)	((void *)&sym - KIMAGE_VADDR + PAGE_OFFSET)
+
 #ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 689d4c95e12f..e3d67ff8798b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -307,7 +307,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
-u64 kvm_call_hyp(void *hypfn, ...);
+u64 __kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
@@ -328,8 +328,8 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 	 * Call initialization code, and switch to the full blown
 	 * HYP code.
 	 */
-	kvm_call_hyp((void *)boot_pgd_ptr, pgd_ptr,
-		     hyp_stack_ptr, vector_ptr);
+	__kvm_call_hyp((void *)boot_pgd_ptr, pgd_ptr,
+		       hyp_stack_ptr, vector_ptr);
 }
 
 static inline void kvm_arch_hardware_disable(void) {}
@@ -343,4 +343,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 
+#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 0ccdcbbef3c2..870578f84b1c 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -20,7 +20,7 @@
 #include <asm/assembler.h>
 
 /*
- * u64 kvm_call_hyp(void *hypfn, ...);
+ * u64 __kvm_call_hyp(void *hypfn, ...);
  *
  * This is not really a variadic function in the classic C-way and care must
  * be taken when calling this to ensure parameters are passed in registers
@@ -37,7 +37,7 @@
  * used to implement __hyp_get_vectors in the same way as in
  * arch/arm64/kernel/hyp_stub.S.
  */
-ENTRY(kvm_call_hyp)
+ENTRY(__kvm_call_hyp)
 	hvc	#0
 	ret
-ENDPROC(kvm_call_hyp)
+ENDPROC(__kvm_call_hyp)
-- 
2.5.0
