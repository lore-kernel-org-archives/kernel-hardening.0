From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH V6 5/8] KVM: X86: Enable ROE for x86
Date: Sun,  4 Nov 2018 19:11:21 +0200
Message-Id: <20181104171124.5717-6-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com>
References: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, "Ahmed Lotfy igor . stoppa @ gmail . com" <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This patch implements kvm_roe_arch_commit_protection and
kvm_roe_arch_is_userspace for x86, and invoke kvm_roe via the
appropriate vmcall.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/Kconfig            |   8 +++
 arch/x86/kvm/Makefile           |   4 +-
 arch/x86/kvm/mmu.c              |  61 ++++++++----------
 arch/x86/kvm/mmu.h              |  40 +++++++++++-
 arch/x86/kvm/roe.c              | 106 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/roe_arch.h         |  50 +++++++++++++++
 arch/x86/kvm/x86.c              |  11 ++--
 8 files changed, 237 insertions(+), 45 deletions(-)
 create mode 100644 arch/x86/kvm/roe.c
 create mode 100644 arch/x86/kvm/roe_arch.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55e51ff7e421..eefa2e8c7c44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1229,7 +1229,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 acc_track_mask, u64 me_mask);
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1bbec387d289..390a2481efdd 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,14 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_ROE
+	def_bool y
+	bool "Hypercall Memory Read-Only Enforcement"
+	depends on KVM && X86
+	help
+	This option adds KVM_HC_ROE hypercall to kvm as a hardening
+	mechanism to protect memory pages from being edited.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index dc4f2fdf5e57..8b359bc51b3e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,8 +9,10 @@ CFLAGS_vmx.o := -I.
 KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
-				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
+			   $(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
+
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
+kvm-$(CONFIG_KVM_ROE)		+= $(KVM)/roe.o roe.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c54ec914935b..4e6887ddfe31 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -23,7 +23,7 @@
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
-
+#include "roe_arch.h"
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -1307,8 +1307,8 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 	__pte_list_remove(sptep, rmap_head);
 }
 
-static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
-					   struct kvm_memory_slot *slot)
+struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+		struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
@@ -1358,16 +1358,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	__pte_list_remove(spte, rmap_head);
 }
 
-/*
- * Used by the following functions to iterate through the sptes linked by a
- * rmap.  All fields are private and not assumed to be used outside.
- */
-struct rmap_iterator {
-	/* private fields */
-	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
-	int pos;			/* index of the sptep */
-};
-
 /*
  * Iteration must be started by this function.  This should also be used after
  * removing/dropping sptes from the rmap link because in such cases the
@@ -1375,8 +1365,7 @@ struct rmap_iterator {
  *
  * Returns sptep if found, NULL otherwise.
  */
-static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
-			   struct rmap_iterator *iter)
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head, struct rmap_iterator *iter)
 {
 	u64 *sptep;
 
@@ -1402,7 +1391,7 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
  *
  * Returns sptep if found, NULL otherwise.
  */
-static u64 *rmap_get_next(struct rmap_iterator *iter)
+u64 *rmap_get_next(struct rmap_iterator *iter)
 {
 	u64 *sptep;
 
@@ -1473,7 +1462,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  *
  * Return true if tlb need be flushed.
  */
-static bool spte_write_protect(u64 *sptep, bool pt_protect)
+bool spte_write_protect(u64 *sptep, bool pt_protect)
 {
 	u64 spte = *sptep;
 
@@ -1491,8 +1480,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 }
 
 static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect, void *data)
+		struct kvm_rmap_head *rmap_head, bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1591,7 +1579,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmap_head, false, NULL);
+		__rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1661,17 +1649,17 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
+
+bool kvm_mmu_slot_gfn_write_protect_old(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn)
 {
 	struct kvm_rmap_head *rmap_head;
 	int i;
 	bool write_protected = false;
-
 	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmap_head, true,
-				NULL);
+		write_protected |= __rmap_write_protect(kvm, rmap_head,
+				true);
 	}
 
 	return write_protected;
@@ -5526,10 +5514,6 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	kvm_page_track_unregister_notifier(kvm, node);
 }
 
-/* The return value indicates if tlb flush on all vcpus is needed. */
-typedef bool (*slot_level_handler) (struct kvm *kvm,
-		struct kvm_rmap_head *rmap_head, void *data);
-
 /* The caller should hold mmu-lock before calling this function. */
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
@@ -5573,9 +5557,8 @@ slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			lock_flush_tlb, data);
 }
 
-static __always_inline bool
-slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		      slot_level_handler fn, bool lock_flush_tlb, void *data)
+bool slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		slot_level_handler fn, bool lock_flush_tlb, void *data)
 {
 	return slot_handle_level(kvm, memslot, fn, PT_PAGE_TABLE_LEVEL,
 				 PT_MAX_HUGEPAGE_LEVEL, lock_flush_tlb, data);
@@ -5627,11 +5610,10 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    void *data)
 {
-	return __rmap_write_protect(kvm, rmap_head, false, data);
+	return __rmap_write_protect(kvm, rmap_head, false);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot)
+bool protect_all_levels_old(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	bool flush;
 
@@ -5639,9 +5621,14 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
 				      false, NULL);
 	spin_unlock(&kvm->mmu_lock);
-
+	return flush;
+}
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
+		struct kvm_memory_slot *memslot)
+{
+	bool flush = protect_all_levels(kvm, memslot);
 	/*
-	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
+	 * kvm_mmu_slot_apply_write_access() and kvm_vm_ioctl_get_dirty_log()
 	 * which do tlb flush out of mmu-lock should be serialized by
 	 * kvm->slots_lock otherwise tlb flush would be missed.
 	 */
@@ -5738,7 +5725,7 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					false, NULL);
 	spin_unlock(&kvm->mmu_lock);
 
-	/* see kvm_mmu_slot_remove_write_access */
+	/* see kvm_mmu_slot_apply_write_access*/
 	lockdep_assert_held(&kvm->slots_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index c7b333147c4a..23cf58062546 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -4,7 +4,6 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
-
 #define PT64_PT_BITS 9
 #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
 #define PT32_PT_BITS 10
@@ -43,6 +42,24 @@
 #define PT32_ROOT_LEVEL 2
 #define PT32E_ROOT_LEVEL 3
 
+#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
+	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
+			_spte_; _spte_ = rmap_get_next(_iter_))
+
+/*
+ * Used by the following functions to iterate through the sptes linked by a
+ * rmap.  All fields are private and not assumed to be used outside.
+ */
+struct rmap_iterator {
+	/* private fields */
+	struct pte_list_desc *desc;     /* holds the sptep if not NULL */
+	int pos;                        /* index of the sptep */
+};
+
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
+		struct rmap_iterator *iter);
+u64 *rmap_get_next(struct rmap_iterator *iter);
+bool spte_write_protect(u64 *sptep, bool pt_protect);
 static inline u64 rsvd_bits(int s, int e)
 {
 	if (e < s)
@@ -203,12 +220,31 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
+/* The return value indicates if tlb flush on all vcpus is needed. */
+typedef bool (*slot_level_handler) (struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head, void *data);
+
 void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm);
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
-bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
+bool kvm_mmu_slot_gfn_write_protect_old(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
+bool protect_all_levels_old(struct kvm *kvm, struct kvm_memory_slot *memslot);
+bool slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		slot_level_handler fn, bool lock_flush_tlb, void *data);
+struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+		struct kvm_memory_slot *slot);
+/*
+ * This include line **must** be the last line in this file, here is why
+ * some functions have 2 versions fcn_old() vs fcn_roe() the old functions is
+ * old in the sence of it was already there. Now to resolve the issue of
+ * #ifdef CONFIG_KVM_ROE everywhere there is static inline functions that
+ * resolve fcn() into either fcn_old or fcn_roe() that are placed in roe_arch.h
+ * I had 2 options first is move all those functions with there #ifdef to here
+ * or include "roe_arch.h". I chose the later one
+ */
+#include "roe_arch.h"
 #endif
diff --git a/arch/x86/kvm/roe.c b/arch/x86/kvm/roe.c
new file mode 100644
index 000000000000..cd3e6944c15f
--- /dev/null
+++ b/arch/x86/kvm/roe.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * KVM Read Only Enforcement
+ * Copyright (c) 2018 Ahmed Mohamed Abd El Mawgood
+ *
+ * Author Ahmed Mohamed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
+ *
+ */
+#include <linux/types.h>
+#include <linux/kvm_host.h>
+#include <kvm/roe.h>
+
+
+#include <asm/kvm_host.h>
+#include "kvm_cache_regs.h"
+#include "mmu.h"
+#include "roe_arch.h"
+
+static bool __rmap_write_protect_roe(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head, bool pt_protect,
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
+
+bool kvm_mmu_slot_gfn_write_protect_roe(struct kvm *kvm,
+		struct kvm_memory_slot *slot, u64 gfn)
+{
+	struct kvm_rmap_head *rmap_head;
+	int i;
+	bool write_protected = false;
+	struct kvm_write_access_data data = {
+		.i = 0,
+		.memslot = slot,
+	};
+	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
+		rmap_head = __gfn_to_rmap(gfn, i, slot);
+		write_protected |= __rmap_write_protect_roe(kvm, rmap_head,
+				true, &data);
+	}
+	return write_protected;
+}
+
+static bool slot_rmap_apply_protection(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head, void *data)
+{
+	struct kvm_write_access_data *d = (struct kvm_write_access_data *) data;
+	bool prot_mask = !(d->memslot->flags & KVM_MEM_READONLY);
+
+	return __rmap_write_protect_roe(kvm, rmap_head, prot_mask, d);
+}
+
+bool roe_protect_all_levels(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+	bool flush;
+	struct kvm_write_access_data data = {
+		.i = 0,
+		.memslot = memslot,
+	};
+	spin_lock(&kvm->mmu_lock);
+	flush = slot_handle_all_level(kvm, memslot, slot_rmap_apply_protection,
+			false, &data);
+	spin_unlock(&kvm->mmu_lock);
+	return flush;
+}
+
+void kvm_roe_arch_commit_protection(struct kvm *kvm,
+		struct kvm_memory_slot *slot)
+{
+	kvm_mmu_slot_apply_write_access(kvm, slot);
+	kvm_arch_flush_shadow_memslot(kvm, slot);
+}
+EXPORT_SYMBOL_GPL(kvm_roe_arch_commit_protection);
+
+bool kvm_roe_arch_is_userspace(struct kvm_vcpu *vcpu)
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
+	 * triggered at the end of a hypercall instruction.
+	 */
+	rflags = kvm_get_rflags(vcpu);
+	iopl = (rflags >> 12) & 3;
+	if (iopl != 3)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_roe_arch_is_userspace);
diff --git a/arch/x86/kvm/roe_arch.h b/arch/x86/kvm/roe_arch.h
new file mode 100644
index 000000000000..41c496be4344
--- /dev/null
+++ b/arch/x86/kvm/roe_arch.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __KVM_ROE_HARCH_H__
+#define __KVM_ROE_HARCH_H__
+/*
+ * KVM Read Only Enforcement
+ * Copyright (c) 2018 Ahmed Mohamed Abd El Mawgood
+ *
+ * Author Ahmed Mohamed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
+ *
+ */
+#include "mmu.h"
+#ifdef CONFIG_KVM_ROE
+
+/*
+ * This is internal structure used to be be able to access kvm memory slot and
+ * have track of the number of current PTE when doing shadow PTE walk
+ */
+struct kvm_write_access_data {
+	int i;
+	struct kvm_memory_slot *memslot;
+};
+bool roe_protect_all_levels(struct kvm *kvm, struct kvm_memory_slot *memslot);
+
+static inline bool protect_all_levels(struct kvm *kvm,
+		struct kvm_memory_slot *memslot)
+{
+	return roe_protect_all_levels(kvm, memslot);
+}
+bool kvm_mmu_slot_gfn_write_protect_roe(struct kvm *kvm,
+		struct kvm_memory_slot *slot, u64 gfn);
+static inline bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
+		struct kvm_memory_slot *slot, u64 gfn)
+{
+	return kvm_mmu_slot_gfn_write_protect_roe(kvm, slot, gfn);
+}
+#else
+static inline bool protect_all_levels(struct kvm *kvm,
+		struct kvm_memory_slot *memslot)
+{
+	return protect_all_levels_old(kvm, memslot);
+}
+static inline bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
+		struct kvm_memory_slot *slot, u64 gfn)
+{
+	return kvm_mmu_slot_gfn_write_protect_old(kvm, slot, gfn);
+}
+
+#endif
+#endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66d66d77caee..8510988ead61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <kvm/roe.h>
 #include "irq.h"
 #include "mmu.h"
 #include "i8254.h"
@@ -4409,7 +4410,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
+	 * kvm_mmu_slot_apply_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 	if (is_dirty)
@@ -6927,7 +6928,6 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	return ret;
 }
 #endif
-
 /*
  * kvm_pv_kick_cpu_op:  Kick a vcpu.
  *
@@ -6999,6 +6999,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
 #endif
+	case KVM_HC_ROE:
+		ret = kvm_roe(vcpu, a0, a1, a2, a3);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -9261,8 +9264,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
 	/* Still write protect RO slot */
+	kvm_mmu_slot_apply_write_access(kvm, new);
 	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new);
 		return;
 	}
 
@@ -9300,7 +9303,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_x86_ops->slot_enable_log_dirty)
 			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
 		else
-			kvm_mmu_slot_remove_write_access(kvm, new);
+			kvm_mmu_slot_apply_write_access(kvm, new);
 	} else {
 		if (kvm_x86_ops->slot_disable_log_dirty)
 			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
-- 
2.18.1
