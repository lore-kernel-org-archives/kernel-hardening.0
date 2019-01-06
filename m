From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [PATCH V8 01/11] KVM: State whether memory should be freed in kvm_free_memslot
Date: Sun,  6 Jan 2019 21:23:35 +0200
Message-Id: <20190106192345.13578-2-ahmedsoliman@mena.vt.edu>
In-Reply-To: <20190106192345.13578-1-ahmedsoliman@mena.vt.edu>
References: <20190106192345.13578-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

The conditions upon which kvm_free_memslot are kind of ad-hock,
it will be hard to extend memslot with allocatable data that needs to be
freed, so I replaced the current mechanism by clear flag that states if
the memory slot should be freed.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
---
 virt/kvm/kvm_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1f888a103f..2f37b4b6a2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -548,9 +548,10 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
  * Free any memory in @free but not in @dont.
  */
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			      struct kvm_memory_slot *dont)
+			      struct kvm_memory_slot *dont,
+			      enum kvm_mr_change change)
 {
-	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
+	if (change == KVM_MR_DELETE)
 		kvm_destroy_dirty_bitmap(free);
 
 	kvm_arch_free_memslot(kvm, free, dont);
@@ -566,7 +567,7 @@ static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 		return;
 
 	kvm_for_each_memslot(memslot, slots)
-		kvm_free_memslot(kvm, memslot, NULL);
+		kvm_free_memslot(kvm, memslot, NULL, KVM_MR_DELETE);
 
 	kvfree(slots);
 }
@@ -1061,14 +1062,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
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
2.19.2
