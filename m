From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH 3/3] [RFC V3] KVM: X86: Adding skeleton for Memory ROE
Date: Thu, 19 Jul 2018 23:38:02 +0200
Message-Id: <20180719213802.17161-4-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com>
References: <20180719213802.17161-1-ahmedsoliman0x666@gmail.com>
To: kvm@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, nathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Hildenbrand <david@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, David Vrabel <david.vrabel@nutanix.com>, nigel.edwards@hpe.com, Rik van Riel <riel@surriel.com>, Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch introduces a hypercall implemented for X86 that can assist
against subset of kernel rootkits, it works by place readonly protection in
shadow PTE. The end result protection is also kept in a bitmap for each
kvm_memory_slot and is used as reference when updating SPTEs. The whole
goal is to protect the guest kernel static data from modification if
attacker is running from guest ring 0, for this reason there is no
hypercall to revert effect of Memory ROE hypercall. This patch doesn't
implement integrity check on guest TLB so obvious attack on the current
implementation will involve guest virtual address -> guest physical
address remapping, but there are plans to fix that.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++-
 arch/x86/kvm/Kconfig            |  7 ++++
 arch/x86/kvm/mmu.c              | 72 ++++++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              | 82 +++++++++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h        |  3 ++
 include/uapi/linux/kvm_para.h   |  1 +
 virt/kvm/kvm_main.c             | 29 +++++++++++++--
 7 files changed, 186 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c13cd28d9d1b..128bcfa246a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -236,6 +236,15 @@ struct kvm_mmu_memory_cache {
 	void *objects[KVM_NR_MEM_OBJS];
 };
 
+/*
+ * This is internal structure used to be be able to access kvm memory slot and
+ * have track of the number of current PTE when doing shadow PTE walk
+ */
+struct kvm_write_access_data {
+	int i;
+	struct kvm_memory_slot *memslot;
+};
+
 /*
  * the pages used as guest page table on soft mmu are tracked by
  * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
@@ -1130,7 +1139,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 acc_track_mask, u64 me_mask);
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 92fd433c50b9..8ae822a8dc7a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,13 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_MROE
+	bool "Hypercall Memory Read-Only Enforcement"
+	depends on KVM && X86
+	help
+	This option add KVM_HC_HMROE hypercall to kvm which as hardening
+	mechanism to protect memory pages from being edited.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 77661530b2c4..4ce6a9a19a23 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1416,9 +1416,8 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect, void *data)
+static bool __rmap_write_protection(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head, bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1430,6 +1429,38 @@ static bool __rmap_write_protect(struct kvm *kvm,
 	return flush;
 }
 
+#ifdef CONFIG_KVM_MROE
+static bool __rmap_write_protect_mroe(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head,
+		bool pt_protect,
+		struct kvm_write_access_data *d)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+	bool prot;
+	bool flush = false;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		prot = !test_bit(d->i, d->memslot->mroe_bitmap) && pt_protect;
+		flush |= spte_write_protect(sptep, prot);
+		d->i++;
+	}
+	return flush;
+}
+#endif
+
+static bool __rmap_write_protect(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head,
+		bool pt_protect,
+		struct kvm_write_access_data *d)
+{
+#ifdef CONFIG_KVM_MROE
+	if (d != NULL)
+		return __rmap_write_protect_mroe(kvm, rmap_head, pt_protect, d);
+#endif
+	return __rmap_write_protection(kvm, rmap_head, pt_protect);
+}
+
 static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
@@ -1517,7 +1548,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmap_head, false, NULL);
+		__rmap_write_protection(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1593,11 +1624,15 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	struct kvm_rmap_head *rmap_head;
 	int i;
 	bool write_protected = false;
+	struct kvm_write_access_data data = {
+		.i = 0,
+		.memslot = slot,
+	};
 
 	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true,
-				NULL);
+				&data);
 	}
 
 	return write_protected;
@@ -5190,21 +5225,36 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    void *data)
 {
-	return __rmap_write_protect(kvm, rmap_head, false, data);
+	return __rmap_write_protect(kvm, rmap_head, false,
+			(struct kvm_write_access_data *)data);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
+static bool slot_rmap_apply_protection(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head,
+		void *data)
+{
+	struct kvm_write_access_data *d = (struct kvm_write_access_data *) data;
+	bool prot_mask = !(d->memslot->flags & KVM_MEM_READONLY);
+
+	return __rmap_write_protect(kvm, rmap_head, prot_mask, d);
+}
+
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot)
 {
 	bool flush;
+	struct kvm_write_access_data data = {
+		.i = 0,
+		.memslot = memslot,
+	};
 
 	spin_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
-				      false, NULL);
+	flush = slot_handle_all_level(kvm, memslot, slot_rmap_apply_protection,
+				      false, &data);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
-	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
+	 * kvm_mmu_slot_apply_write_access() and kvm_vm_ioctl_get_dirty_log()
 	 * which do tlb flush out of mmu-lock should be serialized by
 	 * kvm->slots_lock otherwise tlb flush would be missed.
 	 */
@@ -5301,7 +5351,7 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					false, NULL);
 	spin_unlock(&kvm->mmu_lock);
 
-	/* see kvm_mmu_slot_remove_write_access */
+	/* see kvm_mmu_slot_apply_write_access*/
 	lockdep_assert_held(&kvm->slots_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0046aa70205a..9addc46d75be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4177,7 +4177,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
+	 * kvm_mmu_slot_apply_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 	if (is_dirty)
@@ -6670,7 +6670,76 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 }
 #endif
 
-/*
+#ifdef CONFIG_KVM_MROE
+static int __roe_protect_frame(struct kvm *kvm, gpa_t gpa)
+{
+	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot || gfn > slot->base_gfn + slot->npages)
+		return -EINVAL;
+	set_bit(gfn - slot->base_gfn, slot->mroe_bitmap);
+	kvm_mmu_slot_apply_write_access(kvm, slot);
+	kvm_arch_flush_shadow_memslot(kvm, slot);
+
+	return 0;
+}
+
+static int roe_protect_frame(struct kvm *kvm, gpa_t gpa)
+{
+	int r;
+
+	mutex_lock(&kvm->slots_lock);
+	r = __roe_protect_frame(kvm, gpa);
+	mutex_unlock(&kvm->slots_lock);
+	return r;
+}
+
+static bool kvm_mroe_userspace(struct kvm_vcpu *vcpu)
+{
+	u64 rflags;
+	u64 cr0 = kvm_read_cr0(vcpu);
+	u64 iopl;
+
+	// first checking we are not in protected mode
+	if ((cr0 & 1) == 0)
+		return false;
+	/*
+	 * we don't need to worry about comments in __get_regs
+	 * because we are sure that this function will only be
+	 * triggered at the end of a hypercall
+	 */
+	 rflags = kvm_get_rflags(vcpu);
+	iopl = (rflags >> 12) & 3;
+	if (iopl != 3)
+		return false;
+	return true;
+}
+
+static int kvm_mroe(struct kvm_vcpu *vcpu, u64 gva)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa;
+	u64 hva;
+
+	/*
+	 * First we need to maek sure that we are running from something that
+	 * isn't usermode
+	 */
+	if (kvm_mroe_userspace(vcpu))
+		return -1;//I don't really know what to return
+	if (gva & ~PAGE_MASK)
+		return -EINVAL;
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+	hva = gfn_to_hva(kvm, gpa >> PAGE_SHIFT);
+	if (!access_ok(VERIFY_WRITE, hva, PAGE_SIZE))
+		return -EINVAL;
+	return roe_protect_frame(vcpu->kvm, gpa);
+}
+#endif
+
+ /*
  * kvm_pv_kick_cpu_op:  Kick a vcpu.
  *
  * @apicid - apicid of vcpu to be kicked.
@@ -6737,6 +6806,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_CLOCK_PAIRING:
 		ret = kvm_pv_clock_pairing(vcpu, a0, a1);
 		break;
+#endif
+#ifdef CONFIG_KVM_MROE
+	case KVM_HC_HMROE:
+		ret = kvm_mroe(vcpu, a0);
+		break;
 #endif
 	default:
 		ret = -KVM_ENOSYS;
@@ -8971,8 +9045,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
 	/* Still write protect RO slot */
+	kvm_mmu_slot_apply_write_access(kvm, new);
 	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new);
 		return;
 	}
 
@@ -9010,7 +9084,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_x86_ops->slot_enable_log_dirty)
 			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
 		else
-			kvm_mmu_slot_remove_write_access(kvm, new);
+			kvm_mmu_slot_apply_write_access(kvm, new);
 	} else {
 		if (kvm_x86_ops->slot_disable_log_dirty)
 			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ee7bc548a83..82c5780e11d9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -297,6 +297,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
+#ifdef CONFIG_KVM_MROE
+	unsigned long *mroe_bitmap;
+#endif
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index dcf629dd2889..4e2badc09b5b 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -26,6 +26,7 @@
 #define KVM_HC_MIPS_EXIT_VM		7
 #define KVM_HC_MIPS_CONSOLE_OUTPUT	8
 #define KVM_HC_CLOCK_PAIRING		9
+#define KVM_HC_HMROE			10
 
 /*
  * hypercalls use architecture specific
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b47507faab5..0f7141e4d550 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -794,6 +794,17 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
+static int kvm_init_mroe_bitmap(struct kvm_memory_slot *slot)
+{
+#ifdef CONFIG_KVM_MROE
+	slot->mroe_bitmap = kvzalloc(BITS_TO_LONGS(slot->npages) *
+	sizeof(unsigned long), GFP_KERNEL);
+	if (!slot->mroe_bitmap)
+		return -ENOMEM;
+#endif
+	return 0;
+}
+
 /*
  * Insert memslot and re-sort memslots based on their GFN,
  * so binary search could be used to lookup GFN.
@@ -1011,6 +1022,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
 	}
+	if (kvm_init_mroe_bitmap(&new) < 0)
+		goto out_free;
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!slots)
@@ -1264,13 +1277,23 @@ static bool memslot_is_readonly(struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEM_READONLY;
 }
 
+static bool gfn_is_readonly(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+#ifdef CONFIG_KVM_MROE
+	return test_bit(gfn - slot->base_gfn, slot->mroe_bitmap) ||
+		memslot_is_readonly(slot);
+#else
+	return memslot_is_readonly(slot);
+#endif
+}
+
 static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				       gfn_t *nr_pages, bool write)
 {
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return KVM_HVA_ERR_BAD;
 
-	if (memslot_is_readonly(slot) && write)
+	if (gfn_is_readonly(slot, gfn) && write)
 		return KVM_HVA_ERR_RO_BAD;
 
 	if (nr_pages)
@@ -1314,7 +1337,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false);
 
 	if (!kvm_is_error_hva(hva) && writable)
-		*writable = !memslot_is_readonly(slot);
+		*writable = !gfn_is_readonly(slot, gfn);
 
 	return hva;
 }
@@ -1554,7 +1577,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	/* Do not map writable pfn in the readonly memslot. */
-	if (writable && memslot_is_readonly(slot)) {
+	if (writable && gfn_is_readonly(slot, gfn)) {
 		*writable = false;
 		writable = NULL;
 	}
-- 
2.16.4
