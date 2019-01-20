From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [RESEND PATCH V8 10/11] KVM: Log ROE violations in system log
Date: Mon, 21 Jan 2019 01:39:39 +0200
Message-Id: <20190120233940.15282-11-ahmedsoliman@mena.vt.edu>
In-Reply-To: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
References: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
---
 virt/kvm/kvm_main.c    |  3 ++-
 virt/kvm/roe.c         | 25 +++++++++++++++++++++++++
 virt/kvm/roe_generic.h |  3 ++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d92d300539..b3dc7255b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1945,13 +1945,14 @@ static u64 roe_gfn_to_hva(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
 	addr = __gfn_to_hva_many(slot, gfn, NULL, false);
 	return addr;
 }
+
 static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
 	int r;
 	unsigned long addr;
-
 	addr = roe_gfn_to_hva(memslot, gfn, offset, len);
+	kvm_roe_check_and_log(memslot, gfn, data, offset, len);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_to_user((void __user *)addr + offset, data, len);
diff --git a/virt/kvm/roe.c b/virt/kvm/roe.c
index 9540473f89..e424b45e1c 100644
--- a/virt/kvm/roe.c
+++ b/virt/kvm/roe.c
@@ -76,6 +76,31 @@ void kvm_roe_free(struct kvm_memory_slot *slot)
 	kvfree(slot->prot_list);
 }
 
+static void kvm_warning_roe_violation(u64 addr, const void *data, int len)
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
+void kvm_roe_check_and_log(struct kvm_memory_slot *memslot, gfn_t gfn,
+		const void *data, int offset, int len)
+{
+	if (!memslot)
+		return;
+	if (!gfn_is_full_roe(memslot, gfn) &&
+		!kvm_roe_check_range(memslot, gfn, offset, len))
+		return;
+	kvm_warning_roe_violation((gfn << PAGE_SHIFT) + offset, data, len);
+}
+
 static void kvm_roe_protect_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		gfn_t gfn, u64 npages, bool partial)
 {
diff --git a/virt/kvm/roe_generic.h b/virt/kvm/roe_generic.h
index f1ce4a8aec..6c5f0cf381 100644
--- a/virt/kvm/roe_generic.h
+++ b/virt/kvm/roe_generic.h
@@ -14,5 +14,6 @@ void kvm_roe_free(struct kvm_memory_slot *slot);
 int kvm_roe_init(struct kvm_memory_slot *slot);
 bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
 		int len);
-
+void kvm_roe_check_and_log(struct kvm_memory_slot *memslot, gfn_t gfn,
+		const void *data, int offset, int len);
 #endif
-- 
2.19.2
