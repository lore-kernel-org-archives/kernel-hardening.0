Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 15 Jun 2016 17:28:28 -0700
Message-Id: <fdee1749f758de33fed9ab8227b6afaa56388b63.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
In-Reply-To: <cover.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 06/13] fork: Add generic vmalloced stack support
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
vmalloc_node.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/Kconfig  | 12 ++++++++++++
 kernel/fork.c | 45 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d794384a0404..1acd262036b0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -658,4 +658,16 @@ config ARCH_NO_COHERENT_DMA_MMAP
 config CPU_NO_EFFICIENT_FFS
 	def_bool n
 
+config HAVE_ARCH_VMAP_STACK
+       def_bool n
+
+config VMAP_STACK
+	bool "Use a virtually-mapped stack"
+	depends on HAVE_ARCH_VMAP_STACK
+	---help---
+	  Enable this if you want the use virtually-mapped kernel stacks
+	  with guard pages.  This causes kernel stack overflows to be
+	  caught immediately rather than causing difficult-to-diagnose
+	  corruption.
+
 source "kernel/gcov/Kconfig"
diff --git a/kernel/fork.c b/kernel/fork.c
index 59e52f2120a3..37234fa0ba9b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -158,19 +158,30 @@ void __weak arch_release_thread_info(struct thread_info *ti)
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
  * kmemcache based allocator.
  */
-# if THREAD_SIZE >= PAGE_SIZE
+# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
+#ifdef CONFIG_VMAP_STACK
+	return __vmalloc_node_range(
+		THREAD_SIZE, THREAD_SIZE, VMALLOC_START, VMALLOC_END,
+		GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+		0, node, __builtin_return_address(0));
+#else
 	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
 						  THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
+#endif
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
+#ifdef CONFIG_VMAP_STACK
+	vfree(ti);
+#else
 	free_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+#endif
 }
 # else
 static struct kmem_cache *thread_info_cache;
@@ -215,15 +226,33 @@ static struct kmem_cache *mm_cachep;
 
 static void account_kernel_stack(struct thread_info *ti, int account)
 {
-	struct zone *zone = page_zone(virt_to_page(ti));
+	struct zone *zone;
+
+	if (IS_ENABLED(CONFIG_VMAP_STACK) && !virt_addr_valid(ti)) {
+		int i;
+		struct vm_struct *vm = find_vm_area(ti);
 
-	mod_zone_page_state(zone, NR_KERNEL_STACK,
-			    THREAD_SIZE / PAGE_SIZE * account);
+		WARN_ON_ONCE(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
-	/* All stack pages belong to the same memcg. */
-	memcg_kmem_update_page_stat(
-		virt_to_page(ti), MEMCG_KERNEL_STACK,
-		account * (THREAD_SIZE / PAGE_SIZE));
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
+			mod_zone_page_state(page_zone(vm->pages[i]),
+					    1, account);
+		}
+
+		/* All stack pages belong to the same memcg. */
+		memcg_kmem_update_page_stat(
+			vm->pages[0], MEMCG_KERNEL_STACK,
+			account * (THREAD_SIZE / PAGE_SIZE));
+	} else {
+		zone = page_zone(virt_to_page(ti));
+		mod_zone_page_state(zone, NR_KERNEL_STACK,
+				    THREAD_SIZE / PAGE_SIZE * account);
+
+		/* All stack pages belong to the same memcg. */
+		memcg_kmem_update_page_stat(
+			virt_to_page(ti), MEMCG_KERNEL_STACK,
+			account * (THREAD_SIZE / PAGE_SIZE));
+	}
 }
 
 void free_task(struct task_struct *tsk)
-- 
2.7.4
