From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH V6 8/8] KVM: Log ROE violations in system log
Date: Sun,  4 Nov 2018 19:11:24 +0200
Message-Id: <20181104171124.5717-9-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com>
References: <20181104171124.5717-1-ahmedsoliman0x666@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, "Ahmed Lotfy igor . stoppa @ gmail . com" <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
---
 virt/kvm/kvm_main.c    |  7 +++++++
 virt/kvm/roe.c         | 14 ++++++++++++++
 virt/kvm/roe_generic.h |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 48c5d9d9474e..d625db7f5350 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -63,6 +63,8 @@
 #include "vfio.h"
 #include "roe_generic.h"
 
+#include <kvm/roe.h>
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
 
@@ -1867,6 +1869,7 @@ static u64 roe_gfn_to_hva(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
 	addr = __gfn_to_hva_many(slot, gfn, NULL, false);
 	return addr;
 }
+
 static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
@@ -1874,6 +1877,10 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 	unsigned long addr;
 
 	addr = roe_gfn_to_hva(memslot, gfn, offset, len);
+	if (gfn_is_full_roe(memslot, gfn) ||
+			kvm_roe_check_range(memslot, gfn, offset, len))
+		kvm_warning_roe_violation((gfn << PAGE_SHIFT) + offset, data,
+				len);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_to_user((void __user *)addr + offset, data, len);
diff --git a/virt/kvm/roe.c b/virt/kvm/roe.c
index e94314fed3a3..c30c6b028638 100644
--- a/virt/kvm/roe.c
+++ b/virt/kvm/roe.c
@@ -76,6 +76,20 @@ void kvm_roe_free(struct kvm_memory_slot *slot)
 	kvfree(slot->prot_list);
 }
 
+void kvm_warning_roe_violation(u64 addr, const void *data, int len)
+{
+	int i;
+	const char *d = data;
+	char *buf = kvmalloc(len * 3 + 1, GFP_KERNEL);
+
+	for (i = 0; i < len; i++)
+		sprintf(buf+3*i, " %02x", d[i]);
+	pr_warn("ROE violation:\n");
+	pr_warn("\tAttempt to write %d bytes at address 0x%08llx\n", len, addr);
+	pr_warn("\tData: %s\n", buf);
+	kvfree(buf);
+}
+
 static void kvm_roe_protect_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		gfn_t gfn, u64 npages, bool partial)
 {
diff --git a/virt/kvm/roe_generic.h b/virt/kvm/roe_generic.h
index 006fc7b52bba..bce426441468 100644
--- a/virt/kvm/roe_generic.h
+++ b/virt/kvm/roe_generic.h
@@ -11,6 +11,7 @@
  */
 #ifdef CONFIG_KVM_ROE
 
+void kvm_warning_roe_violation(u64 addr, const void *data, int len);
 void kvm_roe_free(struct kvm_memory_slot *slot);
 int kvm_roe_init(struct kvm_memory_slot *slot);
 bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
@@ -39,6 +40,7 @@ static bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn,
 {
 	return false;
 }
+static void kvm_warning_roe_violation(u64 addr, const void *data, int len) {}
 #endif
 
 #endif
-- 
2.18.1
