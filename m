From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH V4 3/5] KVM: X86: Adding skeleton for Memory ROE
Date: Sun, 21 Oct 2018 00:21:25 +0200
Message-Id: <20181020222127.6368-4-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20181020222127.6368-1-ahmedsoliman0x666@gmail.com>
References: <20181020222127.6368-1-ahmedsoliman0x666@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, Ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
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
 arch/x86/include/asm/kvm_host.h |  11 ++-
 arch/x86/kvm/Kconfig            |   7 ++
 arch/x86/kvm/mmu.c              |  72 +++++++++++++---
 arch/x86/kvm/x86.c              | 143 +++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |   3 +
 include/uapi/linux/kvm_para.h   |   4 +
 virt/kvm/kvm_main.c             |  34 +++++++-
 7 files changed, 255 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b2e3e2cf1b..aa080c3e302e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -238,6 +238,15 @@ struct kvm_mmu_memory_cache {
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
@@ -1178,7 +1187,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 acc_track_mask, u64 me_mask);
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1bbec387d289..2fcbb1788a24 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,13 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_ROE
+	bool "Hypercall Memory Read-Only Enforcement"
+	depends on KVM && X86
+	help
+	This option adds KVM_HC_ROE hypercall to kvm as a hardening
+	mechanism to protect memory pages from being edited.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cc36abe1ee44..c54aa5287e14 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1484,9 +1484,8 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
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
@@ -1498,6 +1497,38 @@ static bool __rmap_write_protect(struct kvm *kvm,
 	return flush;
 }
 
+#ifdef CONFIG_KVM_ROE
+static bool __rmap_write_protect_roe(struct kvm *kvm,
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
+		prot = !test_bit(d->i, d->memslot->roe_bitmap) && pt_protect;
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
+#ifdef CONFIG_KVM_ROE
+	if (d != NULL)
+		return __rmap_write_protect_roe(kvm, rmap_head, pt_protect, d);
+#endif
+	return __rmap_write_protection(kvm, rmap_head, pt_protect);
+}
+
 static bool spte_clear_dirty(u64 *sptep)
 {
 	u64 spte = *sptep;
@@ -1585,7 +1616,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmap_head, false, NULL);
+		__rmap_write_protection(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1661,11 +1692,15 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
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
@@ -5569,21 +5604,36 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
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
@@ -5680,7 +5730,7 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					false, NULL);
 	spin_unlock(&kvm->mmu_lock);
 
-	/* see kvm_mmu_slot_remove_write_access */
+	/* see kvm_mmu_slot_apply_write_access*/
 	lockdep_assert_held(&kvm->slots_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca717737347e..70f2b42a2f91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4276,7 +4276,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
+	 * kvm_mmu_slot_apply_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 	if (is_dirty)
@@ -6798,7 +6798,137 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 }
 #endif
 
-/*
+#ifdef CONFIG_KVM_ROE
+static void kvm_roe_protect_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t gfn, u64 npages)
+{
+	int i;
+
+	for (i = gfn - slot->base_gfn; i < gfn + npages - slot->base_gfn; i++)
+		set_bit(i, slot->roe_bitmap);
+	kvm_mmu_slot_apply_write_access(kvm, slot);
+	kvm_arch_flush_shadow_memslot(kvm, slot);
+}
+
+static int __kvm_roe_protect_range(struct kvm *kvm, gpa_t gpa, u64 npages)
+{
+	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int count = 0;
+
+	while (npages != 0) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot) {
+			gfn += 1;
+			npages -= 1;
+			continue;
+		}
+		if (gfn + npages > slot->base_gfn + slot->npages) {
+			u64 _npages = slot->base_gfn + slot->npages - gfn;
+
+			kvm_roe_protect_slot(kvm, slot, gfn, _npages);
+			gfn += _npages;
+			count += _npages;
+			npages -= _npages;
+		} else {
+			kvm_roe_protect_slot(kvm, slot, gfn, npages);
+			count += npages;
+			npages = 0;
+		}
+	}
+	if (count == 0)
+		return -EINVAL;
+	return count;
+}
+
+static int kvm_roe_protect_range(struct kvm *kvm, gpa_t gpa, u64 npages)
+{
+	int r;
+
+	mutex_lock(&kvm->slots_lock);
+	r = __kvm_roe_protect_range(kvm, gpa, npages);
+	mutex_unlock(&kvm->slots_lock);
+	return r;
+}
+
+static bool kvm_roe_userspace(struct kvm_vcpu *vcpu)
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
+static int kvm_roe_full_protect_range(struct kvm_vcpu *vcpu, u64 gva,
+		u64 npages)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa;
+	u64 hva;
+	u64 count = 0;
+	int i;
+	int status;
+
+	if (gva & ~PAGE_MASK)
+		return -EINVAL;
+	// We need to make sure that there will be no overflow
+	if ((npages << PAGE_SHIFT) >> PAGE_SHIFT != npages || npages == 0)
+		return -EINVAL;
+	for (i = 0; i < npages; i++) {
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva + (i << PAGE_SHIFT),
+				NULL);
+		hva = gfn_to_hva(kvm, gpa >> PAGE_SHIFT);
+		if (kvm_is_error_hva(hva))
+			continue;
+		if (!access_ok(VERIFY_WRITE, hva, 1 << PAGE_SHIFT))
+			continue;
+		status =  kvm_roe_protect_range(vcpu->kvm, gpa, 1);
+		if (status > 0)
+			count += status;
+	}
+	if (count == 0)
+		return -EINVAL;
+	return count;
+}
+
+static int kvm_roe(struct kvm_vcpu *vcpu, u64 a0, u64 a1, u64 a2, u64 a3)
+{
+	int ret;
+	/*
+	 * First we need to make sure that we are running from something that
+	 * isn't usermode
+	 */
+	if (kvm_roe_userspace(vcpu))
+		return -KVM_ENOSYS;
+	switch (a0) {
+	case ROE_VERSION:
+		ret = 1; //current version
+		break;
+	case ROE_MPROTECT:
+		ret = kvm_roe_full_protect_range(vcpu, a1, a2);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+#endif
+
+ /*
  * kvm_pv_kick_cpu_op:  Kick a vcpu.
  *
  * @apicid - apicid of vcpu to be kicked.
@@ -6868,6 +6998,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_SEND_IPI:
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
+#endif
+#ifdef CONFIG_KVM_ROE
+	case KVM_HC_ROE:
+		ret = kvm_roe(vcpu, a0, a1, a2, a3);
+		break;
 #endif
 	default:
 		ret = -KVM_ENOSYS;
@@ -9119,8 +9254,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
 	/* Still write protect RO slot */
+	kvm_mmu_slot_apply_write_access(kvm, new);
 	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new);
 		return;
 	}
 
@@ -9158,7 +9293,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_x86_ops->slot_enable_log_dirty)
 			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
 		else
-			kvm_mmu_slot_remove_write_access(kvm, new);
+			kvm_mmu_slot_apply_write_access(kvm, new);
 	} else {
 		if (kvm_x86_ops->slot_disable_log_dirty)
 			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c926698040e0..be6885bc28bc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -297,6 +297,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
+#ifdef CONFIG_KVM_ROE
+	unsigned long *roe_bitmap;
+#endif
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 6c0ce49931e5..e6004e0750fd 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -28,7 +28,11 @@
 #define KVM_HC_MIPS_CONSOLE_OUTPUT	8
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
+#define KVM_HC_ROE			11
 
+/* ROE Functionality parameters */
+#define ROE_VERSION			0
+#define ROE_MPROTECT			1
 /*
  * hypercalls use architecture specific
  */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f986e31fa68c..423a9c014120 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -554,6 +554,11 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			      struct kvm_memory_slot *dont)
 {
+#ifdef CONFIG_KVM_ROE
+	if (!dont)
+		kvfree(free->roe_bitmap);
+#endif
+
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		kvm_destroy_dirty_bitmap(free);
 
@@ -800,6 +805,17 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }
 
+static int kvm_init_roe_bitmap(struct kvm_memory_slot *slot)
+{
+#ifdef CONFIG_KVM_ROE
+	slot->roe_bitmap = kvzalloc(BITS_TO_LONGS(slot->npages) *
+	sizeof(unsigned long), GFP_KERNEL);
+	if (!slot->roe_bitmap)
+		return -ENOMEM;
+#endif
+	return 0;
+}
+
 /*
  * Insert memslot and re-sort memslots based on their GFN,
  * so binary search could be used to lookup GFN.
@@ -1017,6 +1033,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
 	}
+	if (kvm_init_roe_bitmap(&new) < 0)
+		goto out_free;
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!slots)
@@ -1270,13 +1288,23 @@ static bool memslot_is_readonly(struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEM_READONLY;
 }
 
+static bool gfn_is_readonly(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+#ifdef CONFIG_KVM_ROE
+	return test_bit(gfn - slot->base_gfn, slot->roe_bitmap) ||
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
@@ -1320,7 +1348,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
 	unsigned long hva = __gfn_to_hva_many(slot, gfn, NULL, false);
 
 	if (!kvm_is_error_hva(hva) && writable)
-		*writable = !memslot_is_readonly(slot);
+		*writable = !gfn_is_readonly(slot, gfn);
 
 	return hva;
 }
@@ -1558,7 +1586,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	/* Do not map writable pfn in the readonly memslot. */
-	if (writable && memslot_is_readonly(slot)) {
+	if (writable && gfn_is_readonly(slot, gfn)) {
 		*writable = false;
 		writable = NULL;
 	}
-- 
2.18.1
