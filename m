From: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH V5 5/5] KVM: Small Refactoring to kvm_free_memslot
Date: Fri, 26 Oct 2018 17:12:23 +0200
Message-Id: <20181026151223.16810-6-ahmedsoliman0x666@gmail.com>
In-Reply-To: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This should be a little bit more readable and prone to memory leaks

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>
---
 virt/kvm/kvm_main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2d3011e8490e..79c98db03c84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -550,11 +550,11 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
  * Free any memory in @free but not in @dont.
  */
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			      struct kvm_memory_slot *dont)
+			      struct kvm_memory_slot *dont,
+			      enum kvm_mr_change change)
 {
+	if (change == KVM_MR_DELETE) {
 #ifdef CONFIG_KVM_ROE
-	if (!dont) {
-		//TODO still this might leak
 		struct protected_chunk *pos, *n;
 		struct list_head *head = free->prot_list;
 		kvfree(free->roe_bitmap);
@@ -564,10 +564,9 @@ static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			kvfree(pos);
 		}
 		kvfree(free->prot_list);
-	}
 #endif
-	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		kvm_destroy_dirty_bitmap(free);
+	}
 
 	kvm_arch_free_memslot(kvm, free, dont);
 
@@ -582,7 +581,7 @@ static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 		return;
 
 	kvm_for_each_memslot(memslot, slots)
-		kvm_free_memslot(kvm, memslot, NULL);
+		kvm_free_memslot(kvm, memslot, NULL, KVM_MR_DELETE);
 
 	kvfree(slots);
 }
@@ -1100,14 +1099,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	kvm_arch_commit_memory_region(kvm, mem, &old, &new, change);
 
-	kvm_free_memslot(kvm, &old, &new);
+	kvm_free_memslot(kvm, &old, &new, change);
 	kvfree(old_memslots);
 	return 0;
 
 out_slots:
 	kvfree(slots);
 out_free:
-	kvm_free_memslot(kvm, &new, &old);
+	kvm_free_memslot(kvm, &new, &old, change);
 out:
 	return r;
 }
-- 
2.18.1
