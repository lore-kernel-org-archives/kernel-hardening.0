From: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
Subject: [RESEND PATCH V8 11/11] KVM: ROE: Store protected chunks in red black tree
Date: Mon, 21 Jan 2019 01:39:40 +0200
Message-Id: <20190120233940.15282-12-ahmedsoliman@mena.vt.edu>
In-Reply-To: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
References: <20190120233940.15282-1-ahmedsoliman@mena.vt.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ahmedsoliman0x666@gmail.com, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
List-ID: <kernel-hardening.lists.openwall.com>

The old way of storing protected chunks was a linked list. That made
linear overhead when searching for chunks. When reaching 2000 chunk, The
time taken two read the last chunk was about 10 times slower than the
first chunk. This patch stores the chunks as tree for faster search.

Signed-off-by: Ahmed Abd El Mawgood <ahmedsoliman@mena.vt.edu>
---
 include/linux/kvm_host.h |  36 ++++++-
 virt/kvm/roe.c           | 228 +++++++++++++++++++++++++++------------
 virt/kvm/roe_generic.h   |   3 +
 3 files changed, 197 insertions(+), 70 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9acf5f54ac..5f4bec0662 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/hardirq.h>
 #include <linux/list.h>
+#include <linux/rbtree.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/signal.h>
@@ -301,7 +302,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 struct protected_chunk {
 	gpa_t gpa;
 	u64 size;
-	struct list_head list;
+	struct rb_node node;
 };
 
 static inline bool kvm_roe_range_overlap(struct protected_chunk *chunk,
@@ -316,12 +317,43 @@ static inline bool kvm_roe_range_overlap(struct protected_chunk *chunk,
 		(gpa + len - 1 >= chunk->gpa);
 }
 
+static inline int kvm_roe_range_cmp_position(struct protected_chunk *chunk,
+		gpa_t gpa, int len) {
+	/*
+	 * returns -1 if the gpa and len are smaller than chunk.
+	 * returns 0 if they overlap or strictly adjacent
+	 * returns 1 if gpa and len are bigger than the chunk
+	 */
+
+	if (gpa + len <= chunk->gpa)
+		return -1;
+	if (gpa >= chunk->gpa + chunk->size)
+		return 1;
+	return 0;
+}
+
+static inline int kvm_roe_range_cmp_mergability(struct protected_chunk *chunk,
+		gpa_t gpa, int len) {
+	/*
+	 * returns -1 if the gpa and len are smaller than chunk and not adjacent
+	 * to it
+	 * returns 0 if they overlap or strictly adjacent
+	 * returns 1 if gpa and len are bigger than the chunk and not adjacent
+	 * to it
+	 */
+	if (gpa + len < chunk->gpa)
+		return -1;
+	if (gpa > chunk->gpa + chunk->size)
+		return 1;
+	return 0;
+
+}
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long *roe_bitmap;
 	unsigned long *partial_roe_bitmap;
-	struct list_head *prot_list;
+	struct rb_root  *prot_root;
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
diff --git a/virt/kvm/roe.c b/virt/kvm/roe.c
index e424b45e1c..15297c0e57 100644
--- a/virt/kvm/roe.c
+++ b/virt/kvm/roe.c
@@ -23,10 +23,10 @@ int kvm_roe_init(struct kvm_memory_slot *slot)
 			sizeof(unsigned long), GFP_KERNEL);
 	if (!slot->partial_roe_bitmap)
 		goto fail2;
-	slot->prot_list = kvzalloc(sizeof(struct list_head), GFP_KERNEL);
-	if (!slot->prot_list)
+	slot->prot_root = kvzalloc(sizeof(struct rb_root), GFP_KERNEL);
+	if (!slot->prot_root)
 		goto fail3;
-	INIT_LIST_HEAD(slot->prot_list);
+	*slot->prot_root = RB_ROOT;
 	return 0;
 fail3:
 	kvfree(slot->partial_roe_bitmap);
@@ -40,12 +40,19 @@ int kvm_roe_init(struct kvm_memory_slot *slot)
 static bool kvm_roe_protected_range(struct kvm_memory_slot *slot, gpa_t gpa,
 		int len)
 {
-	struct list_head *pos;
-	struct protected_chunk *cur_chunk;
-
-	list_for_each(pos, slot->prot_list) {
-		cur_chunk = list_entry(pos, struct protected_chunk, list);
-		if (kvm_roe_range_overlap(cur_chunk, gpa, len))
+	struct rb_node *node = slot->prot_root->rb_node;
+
+	while (node) {
+		struct protected_chunk *cur_chunk;
+		int cmp;
+
+		cur_chunk = rb_entry(node, struct protected_chunk, node);
+		cmp = kvm_roe_range_cmp_position(cur_chunk, gpa, len);
+		if (cmp < 0)/*target chunk is before current node*/
+			node = node->rb_left;
+		else if (cmp > 0)/*target chunk is after current node*/
+			node = node->rb_right;
+		else
 			return true;
 	}
 	return false;
@@ -62,18 +69,24 @@ bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
 }
 EXPORT_SYMBOL_GPL(kvm_roe_check_range);
 
-void kvm_roe_free(struct kvm_memory_slot *slot)
+static void kvm_roe_destroy_tree(struct rb_node *node)
 {
-	struct protected_chunk *pos, *n;
-	struct list_head *head = slot->prot_list;
+	struct protected_chunk *cur_chunk;
+
+	if (!node)
+		return;
+	kvm_roe_destroy_tree(node->rb_left);
+	kvm_roe_destroy_tree(node->rb_right);
+	cur_chunk = rb_entry(node, struct protected_chunk, node);
+	kvfree(cur_chunk);
+}
 
+void kvm_roe_free(struct kvm_memory_slot *slot)
+{
 	kvfree(slot->roe_bitmap);
 	kvfree(slot->partial_roe_bitmap);
-	list_for_each_entry_safe(pos, n, head, list) {
-		list_del(&pos->list);
-		kvfree(pos);
-	}
-	kvfree(slot->prot_list);
+	kvm_roe_destroy_tree(slot->prot_root->rb_node);
+	kvfree(slot->prot_root);
 }
 
 static void kvm_warning_roe_violation(u64 addr, const void *data, int len)
@@ -193,40 +206,119 @@ static int kvm_roe_full_protect_range(struct kvm_vcpu *vcpu, u64 gva,
 	return count;
 }
 
-static int kvm_roe_insert_chunk_next(struct list_head *pos, u64 gpa, u64 size)
-{
-	struct protected_chunk *chunk;
-
-	chunk = kvzalloc(sizeof(struct protected_chunk), GFP_KERNEL);
-	chunk->gpa = gpa;
-	chunk->size = size;
-	INIT_LIST_HEAD(&chunk->list);
-	list_add(&chunk->list, pos);
-	return size;
-}
-
-static int kvm_roe_expand_chunk(struct protected_chunk *pos, u64 gpa, u64 size)
+static u64 kvm_roe_expand_chunk(struct protected_chunk *pos, u64 gpa, u64 size)
 {
 	u64 old_ptr = pos->gpa;
 	u64 old_size = pos->size;
+	u64 ret = 0;
 
-	if (gpa < old_ptr)
+	if (gpa < old_ptr) {
 		pos->gpa = gpa;
-	if (gpa + size > old_ptr + old_size)
+		ret |= KVM_ROE_MERGE_LEFT;
+	}
+	if (gpa + size > old_ptr + old_size) {
 		pos->size = gpa + size - pos->gpa;
-	return size;
+		ret |= KVM_ROE_MERGE_RIGHT;
+	}
+	return ret;
 }
+static void kvm_roe_merge_left(struct rb_root *root, struct rb_node *start)
+{
+	struct rb_root fake_root;
+	struct protected_chunk *target, *first;
+	struct rb_node *node, *stop;
+	u64 i, count = 0;
 
-static bool kvm_roe_merge_chunks(struct protected_chunk *chunk)
+	if (!start->rb_left)
+		return;
+	fake_root = (struct rb_root) {start->rb_left};
+	stop = rb_prev(rb_first(&fake_root));
+	/* Back traverse till no node can be merged*/
+	target = container_of(start, struct protected_chunk, node);
+	for (node = rb_last(&fake_root); node != stop; node = rb_prev(node)) {
+		struct protected_chunk *pos;
+
+		pos = container_of(node, struct protected_chunk, node);
+		if (kvm_roe_range_cmp_mergability(target, pos->gpa, pos->size))
+			break;
+		count += 1;
+	}
+	if (!count)
+		return;
+	/* merging step*/
+	node = rb_next(node);
+	first = container_of(node, struct protected_chunk, node);
+	kvm_roe_expand_chunk(target, first->gpa, first->size);
+	/* forward traverse and delete all in between*/
+	for (i = 0; i < count; i++) {
+		struct protected_chunk *pos;
+
+		pos = container_of(node, struct protected_chunk, node);
+		rb_erase(node, root);
+		kvfree(pos);
+		node = rb_next(node);
+	}
+}
+
+static void kvm_roe_merge_right(struct rb_root *root, struct rb_node *start)
 {
-	/*attempt merging 2 consecutive given the first one*/
-	struct protected_chunk *next = list_next_entry(chunk, list);
+	struct rb_root fake_root;
+	struct protected_chunk *target, *first;
+	struct rb_node *node, *stop;
+	u64 i, count = 0;
 
-	if (!kvm_roe_range_overlap(chunk, next->gpa, next->size))
-		return false;
-	kvm_roe_expand_chunk(chunk, next->gpa, next->size);
-	list_del(&next->list);
-	kvfree(next);
+	if (!start->rb_right)
+		return;
+	fake_root = (struct rb_root) {start->rb_right};
+	stop = rb_next(rb_last(&fake_root));
+	/* Forward traverse till no node can be merged*/
+	target = container_of(start, struct protected_chunk, node);
+	for (node = rb_first(&fake_root); node != stop; node = rb_next(node)) {
+		struct protected_chunk *pos;
+
+		pos = container_of(node, struct protected_chunk, node);
+		if (kvm_roe_range_cmp_mergability(target, pos->gpa, pos->size))
+			break;
+		count += 1;
+	}
+	if (!count)
+		return;
+	/* merging step*/
+	node = rb_prev(node);
+	first = container_of(node, struct protected_chunk, node);
+	kvm_roe_expand_chunk(target, first->gpa, first->size);
+	/* Backward traverse and delete all in between*/
+	for (i = 0; i < count; i++) {
+		struct protected_chunk *pos;
+
+		pos = container_of(node, struct protected_chunk, node);
+		rb_erase(node, root);
+		kvfree(pos);
+		node = rb_prev(node);
+	}
+}
+
+static bool kvm_roe_merge_chunks(struct rb_root *root, struct rb_node *target,
+		u64 gpa, u64 size)
+{
+	/*
+	 * attempt merging all adjacent chunks after inserting a chunk that is
+	 * adjacent or inersecting with  an existing chunk
+	 */
+	struct protected_chunk *cur;
+	u64 merge;
+
+	cur = container_of(target, struct protected_chunk, node);
+	merge = kvm_roe_expand_chunk(cur, gpa, size);
+	/*
+	 * We will not have to worry about the parent node while merging
+	 * If it was mergeable with the new to be inserted chunk we wouldn't
+	 * have gone deeper.
+	 **/
+	if (merge & KVM_ROE_MERGE_LEFT)
+		kvm_roe_merge_left(root, target);
+	if (merge & KVM_ROE_MERGE_RIGHT)
+		kvm_roe_merge_right(root, target);
 	return true;
 }
 
@@ -234,35 +326,35 @@ static int __kvm_roe_insert_chunk(struct kvm_memory_slot *slot, u64 gpa,
 		u64 size)
 {
 	/* kvm->slots_lock must be acquired*/
-	struct protected_chunk *pos;
-	struct list_head *head = slot->prot_list;
-
-	if (list_empty(head))
-		return kvm_roe_insert_chunk_next(head, gpa, size);
-	/*
-	 * pos here will never get deleted maybe the next one will
-	 * that is why list_for_each_entry_safe is completely unsafe
-	 */
-	list_for_each_entry(pos, head, list) {
-		if (kvm_roe_range_overlap(pos, gpa, size)) {
-			int ret = kvm_roe_expand_chunk(pos, gpa, size);
-
-			while (head != pos->list.next)
-				if (!kvm_roe_merge_chunks(pos))
-					break;
-			return ret;
-		}
-		if (pos->gpa > gpa) {
-			struct protected_chunk *prev;
-
-			prev = list_prev_entry(pos, list);
-			return kvm_roe_insert_chunk_next(&prev->list, gpa,
-					size);
+	struct rb_node **new = &(slot->prot_root->rb_node), *parent = NULL;
+	struct protected_chunk *insert_me;
+	bool merge = false;
+
+	while (*new) {
+		struct protected_chunk *chunk;
+		int cmp;
+
+		chunk = container_of(*new, struct protected_chunk, node);
+		cmp = kvm_roe_range_cmp_mergability(chunk, gpa, size);
+		parent = *new;
+		if (cmp < 0) {
+			new = &((*new)->rb_left);
+		} else if (cmp > 0) {
+			new = &((*new)->rb_right);
+		} else {
+			merge = true;
+			kvm_roe_merge_chunks(slot->prot_root, *new, gpa, size);
+			break;
 		}
 	}
-	pos = list_last_entry(head, struct protected_chunk, list);
-
-	return kvm_roe_insert_chunk_next(&pos->list, gpa, size);
+	if (merge)
+		return size;
+	insert_me = kvzalloc(sizeof(struct protected_chunk), GFP_KERNEL);
+	insert_me->gpa = gpa;
+	insert_me->size = size;
+	rb_link_node(&insert_me->node, parent, new);
+	rb_insert_color(&insert_me->node, slot->prot_root);
+	return size;
 }
 
 static int kvm_roe_insert_chunk(struct kvm *kvm, u64 gpa, u64 size)
diff --git a/virt/kvm/roe_generic.h b/virt/kvm/roe_generic.h
index 6c5f0cf381..8e42c9795c 100644
--- a/virt/kvm/roe_generic.h
+++ b/virt/kvm/roe_generic.h
@@ -10,6 +10,9 @@
  *
  */
 
+#define KVM_ROE_MERGE_LEFT	0x1
+#define KVM_ROE_MERGE_RIGHT	0x2
+
 void kvm_roe_free(struct kvm_memory_slot *slot);
 int kvm_roe_init(struct kvm_memory_slot *slot);
 bool kvm_roe_check_range(struct kvm_memory_slot *slot, gfn_t gfn, int offset,
-- 
2.19.2
