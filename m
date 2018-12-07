From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [PATCH 09/10] KVM: Add new exit reason For ROE violations
Date: Fri,  7 Dec 2018 14:48:02 +0200
Message-Id: <20181207124803.10828-10-ahmedsoliman@mena.vt.edu>
In-Reply-To: <20181207124803.10828-1-ahmedsoliman@mena.vt.edu>
References: <20181207124803.10828-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

The problem is that qemu will not be able to detect ROE violations, so
one option would be create host API to tell if a given page is ROE
protected, or create ROE violation exit reason.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
---
 arch/x86/kvm/x86.c       | 10 +++++++++-
 include/kvm/roe.h        | 12 ++++++++++++
 include/uapi/linux/kvm.h |  2 +-
 virt/kvm/kvm_main.c      |  1 +
 virt/kvm/roe.c           |  2 +-
 virt/kvm/roe_generic.h   |  9 +--------
 6 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28475c83f9..ddd15bb1a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5334,6 +5334,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 			const struct read_write_emulator_ops *ops)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	struct kvm_memory_slot *slot;
 	gpa_t gpa;
 	int rc;
 
@@ -5375,7 +5376,14 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 
 	vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
-	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa >> PAGE_SHIFT);
+	if (slot && ops->write && (kvm_roe_check_range(slot, gpa>>PAGE_SHIFT,
+			gpa - (gpa & PAGE_MASK), bytes) ||
+			gfn_is_full_roe(slot, gpa>>PAGE_SHIFT)))
+		vcpu->run->exit_reason = KVM_EXIT_ROE;
+	else
+		vcpu->run->exit_reason = KVM_EXIT_MMIO;
+
 	vcpu->run->mmio.phys_addr = gpa;
 
 	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
diff --git a/include/kvm/roe.h b/include/kvm/roe.h
index 6a86866623..3121a67753 100644
--- a/include/kvm/roe.h
+++ b/include/kvm/roe.h
@@ -13,4 +13,16 @@ void kvm_roe_arch_commit_protection(struct kvm *kvm,
 		struct kvm_memory_slot *slot);
 int kvm_roe(struct kvm_vcpu *vcpu, u64 a0, u64 a1, u64 a2, u64 a3);
 bool kvm_roe_arch_is_userspace(struct kvm_vcpu *vcpu);
+bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
+		int len);
+static inline bool gfn_is_full_roe(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return test_bit(gfn - slot->base_gfn, slot->roe_bitmap);
+
+}
+static inline bool gfn_is_partial_roe(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return test_bit(gfn - slot->base_gfn, slot->partial_roe_bitmap);
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2b7a652c9f..185767e512 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -235,7 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
-
+#define KVM_EXIT_ROE		  28
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
 #define KVM_INTERNAL_ERROR_EMULATION	1
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d129b05d5..c3a21d3bc8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -62,6 +62,7 @@
 #include "async_pf.h"
 #include "vfio.h"
 #include "roe_generic.h"
+#include <kvm/roe.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
diff --git a/virt/kvm/roe.c b/virt/kvm/roe.c
index dfb1de314c..6555838f0c 100644
--- a/virt/kvm/roe.c
+++ b/virt/kvm/roe.c
@@ -60,7 +60,7 @@ bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
 		return false;
 	return kvm_roe_protected_range(slot, gpa, len);
 }
-
+EXPORT_SYMBOL_GPL(kvm_roe_check_range);
 
 void kvm_roe_free(struct kvm_memory_slot *slot)
 {
diff --git a/virt/kvm/roe_generic.h b/virt/kvm/roe_generic.h
index ad121372f2..f1ce4a8aec 100644
--- a/virt/kvm/roe_generic.h
+++ b/virt/kvm/roe_generic.h
@@ -14,12 +14,5 @@ void kvm_roe_free(struct kvm_memory_slot *slot);
 int kvm_roe_init(struct kvm_memory_slot *slot);
 bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
 		int len);
-static inline bool gfn_is_full_roe(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return test_bit(gfn - slot->base_gfn, slot->roe_bitmap);
-}
-static inline bool gfn_is_partial_roe(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return test_bit(gfn - slot->base_gfn, slot->partial_roe_bitmap);
-}
+
 #endif
-- 
2.19.2
