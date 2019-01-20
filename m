From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [RESEND PATCH V8 06/11] KVM: X86: Enable ROE for x86
Date: Mon, 21 Jan 2019 01:39:35 +0200
Message-Id: <20190120233940.15282-7-ahmedsoliman@mena.vt.edu>
In-Reply-To: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
References: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

This patch implements kvm_roe_arch_commit_protection and
kvm_roe_arch_is_userspace for x86, and invoke kvm_roe via the
appropriate vmcall.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/Makefile           |   4 +-
 arch/x86/kvm/mmu.c              |  71 +++++-----------------
 arch/x86/kvm/mmu.h              |  30 +++++++++-
 arch/x86/kvm/roe.c              | 101 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/roe_arch.h         |  28 +++++++++
 arch/x86/kvm/x86.c              |  11 ++--
 7 files changed, 183 insertions(+), 64 deletions(-)
 create mode 100644 arch/x86/kvm/roe.c
 create mode 100644 arch/x86/kvm/roe_arch.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4660ce90de..797d838c3e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1239,7 +1239,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 acc_track_mask, u64 me_mask);
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 69b3a7c300..39f7766afe 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,7 +9,9 @@ CFLAGS_vmx.o := -I.
 KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
-				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
+			   $(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
+			   $(KVM)/roe.o roe.o
+
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bbfe3f2863..2e3a43076e 100644
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
@@ -1343,8 +1343,8 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 	__pte_list_remove(sptep, rmap_head);
 }
 
-static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
-					   struct kvm_memory_slot *slot)
+struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+		struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
@@ -1394,16 +1394,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
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
@@ -1411,8 +1401,7 @@ struct rmap_iterator {
  *
  * Returns sptep if found, NULL otherwise.
  */
-static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
-			   struct rmap_iterator *iter)
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head, struct rmap_iterator *iter)
 {
 	u64 *sptep;
 
@@ -1438,7 +1427,7 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
  *
  * Returns sptep if found, NULL otherwise.
  */
-static u64 *rmap_get_next(struct rmap_iterator *iter)
+u64 *rmap_get_next(struct rmap_iterator *iter)
 {
 	u64 *sptep;
 
@@ -1513,7 +1502,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  *
  * Return true if tlb need be flushed.
  */
-static bool spte_write_protect(u64 *sptep, bool pt_protect)
+bool spte_write_protect(u64 *sptep, bool pt_protect)
 {
 	u64 spte = *sptep;
 
@@ -1531,8 +1520,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 }
 
 static bool __rmap_write_protect(struct kvm *kvm,
-				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect, void *data)
+		struct kvm_rmap_head *rmap_head, bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1631,7 +1619,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmap_head, false, NULL);
+		__rmap_write_protect(kvm, rmap_head, false);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1701,22 +1689,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn)
-{
-	struct kvm_rmap_head *rmap_head;
-	int i;
-	bool write_protected = false;
-
-	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
-		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmap_head, true,
-				NULL);
-	}
-
-	return write_protected;
-}
-
 static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
@@ -5562,10 +5534,6 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 	kvm_page_track_unregister_notifier(kvm, node);
 }
 
-/* The return value indicates if tlb flush on all vcpus is needed. */
-typedef bool (*slot_level_handler) (struct kvm *kvm,
-		struct kvm_rmap_head *rmap_head, void *data);
-
 /* The caller should hold mmu-lock before calling this function. */
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
@@ -5609,9 +5577,8 @@ slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
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
@@ -5673,21 +5640,15 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head,
 				    void *data)
 {
-	return __rmap_write_protect(kvm, rmap_head, false, data);
+	return __rmap_write_protect(kvm, rmap_head, false);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot)
+void kvm_mmu_slot_apply_write_access(struct kvm *kvm,
+		struct kvm_memory_slot *memslot)
 {
-	bool flush;
-
-	spin_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
-				      false, NULL);
-	spin_unlock(&kvm->mmu_lock);
-
+	bool flush = protect_all_levels(kvm, memslot);
 	/*
-	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
+	 * kvm_mmu_slot_apply_write_access() and kvm_vm_ioctl_get_dirty_log()
 	 * which do tlb flush out of mmu-lock should be serialized by
 	 * kvm->slots_lock otherwise tlb flush would be missed.
 	 */
@@ -5792,7 +5753,7 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					false, NULL);
 	spin_unlock(&kvm->mmu_lock);
 
-	/* see kvm_mmu_slot_remove_write_access */
+	/* see kvm_mmu_slot_apply_write_access*/
 	lockdep_assert_held(&kvm->slots_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 49d7f2f002..35b46a6a0a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -4,7 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
-
+#include "roe_arch.h"
 #define PT64_PT_BITS 9
 #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
 #define PT32_PT_BITS 10
@@ -43,6 +43,24 @@
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
@@ -203,13 +221,19 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
-				    struct kvm_memory_slot *slot, u64 gfn);
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 gfn_t spte_to_gfn(u64 *sptep);
+bool slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
+		slot_level_handler fn, bool lock_flush_tlb, void *data);
+struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+		struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/roe.c b/arch/x86/kvm/roe.c
new file mode 100644
index 0000000000..f787106be8
--- /dev/null
+++ b/arch/x86/kvm/roe.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * KVM Read Only Enforcement
+ * Copyright (c) 2018 Ahmed Abd El Mawgood
+ *
+ * Author: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
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
+		struct kvm_memory_slot *memslot)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+	bool prot;
+	bool flush = false;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		int idx = spte_to_gfn(sptep) - memslot->base_gfn;
+
+		prot = !test_bit(idx, memslot->roe_bitmap) && pt_protect;
+		flush |= spte_write_protect(sptep, prot);
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
+
+	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
+		rmap_head = __gfn_to_rmap(gfn, i, slot);
+		write_protected |= __rmap_write_protect_roe(kvm, rmap_head,
+				true, slot);
+	}
+	return write_protected;
+}
+
+static bool slot_rmap_apply_protection(struct kvm *kvm,
+		struct kvm_rmap_head *rmap_head, void *data)
+{
+	struct kvm_memory_slot *memslot = (struct kvm_memory_slot *) data;
+	bool prot_mask = !(memslot->flags & KVM_MEM_READONLY);
+
+	return __rmap_write_protect_roe(kvm, rmap_head, prot_mask, memslot);
+}
+
+bool roe_protect_all_levels(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+	bool flush;
+
+	spin_lock(&kvm->mmu_lock);
+	flush = slot_handle_all_level(kvm, memslot, slot_rmap_apply_protection,
+			false, memslot);
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
index 0000000000..17a8b79d36
--- /dev/null
+++ b/arch/x86/kvm/roe_arch.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __KVM_ROE_HARCH_H__
+#define __KVM_ROE_HARCH_H__
+/*
+ * KVM Read Only Enforcement
+ * Copyright (c) 2018 Ahmed Abd El Mawgood
+ *
+ * Author: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
+ *
+ */
+#include "mmu.h"
+
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
+#endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02c8e095a2..19b0f2307e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <kvm/roe.h>
 #include "irq.h"
 #include "mmu.h"
 #include "i8254.h"
@@ -4469,7 +4470,7 @@ int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm, struct kvm_clear_dirty_log *lo
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
-	 * kvm_mmu_slot_remove_write_access().
+	 * kvm_mmu_slot_apply_write_access().
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 	if (flush)
@@ -7025,7 +7026,6 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	return ret;
 }
 #endif
-
 /*
  * kvm_pv_kick_cpu_op:  Kick a vcpu.
  *
@@ -7097,6 +7097,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
 #endif
+	case KVM_HC_ROE:
+		ret = kvm_roe(vcpu, a0, a1, a2, a3);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -9360,8 +9363,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
 	/* Still write protect RO slot */
+	kvm_mmu_slot_apply_write_access(kvm, new);
 	if (new->flags & KVM_MEM_READONLY) {
-		kvm_mmu_slot_remove_write_access(kvm, new);
 		return;
 	}
 
@@ -9399,7 +9402,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		if (kvm_x86_ops->slot_enable_log_dirty)
 			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
 		else
-			kvm_mmu_slot_remove_write_access(kvm, new);
+			kvm_mmu_slot_apply_write_access(kvm, new);
 	} else {
 		if (kvm_x86_ops->slot_disable_log_dirty)
 			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
-- 
2.19.2
