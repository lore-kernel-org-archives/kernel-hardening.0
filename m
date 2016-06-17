Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 17 Jun 2016 13:00:42 -0700
Message-Id: <44f658aacbabd9d1689b3e0aae60ee8746881eff.1466192946.git.luto@kernel.org>
In-Reply-To: <cover.1466192946.git.luto@kernel.org>
References: <cover.1466192946.git.luto@kernel.org>
In-Reply-To: <cover.1466192946.git.luto@kernel.org>
References: <cover.1466192946.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v2 06/13] fork: Add generic vmalloced stack support
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
vmalloc_node.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/Kconfig                        | 29 +++++++++++++
 arch/ia64/include/asm/thread_info.h |  2 +-
 include/linux/sched.h               | 15 +++++++
 kernel/fork.c                       | 81 +++++++++++++++++++++++++++++--------
 4 files changed, 109 insertions(+), 18 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d794384a0404..a71e6e7195e6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -658,4 +658,33 @@ config ARCH_NO_COHERENT_DMA_MMAP
 config CPU_NO_EFFICIENT_FFS
 	def_bool n
 
+config HAVE_ARCH_VMAP_STACK
+	def_bool n
+	help
+	  An arch should select this symbol if it can support kernel stacks
+	  in vmalloc space.  This means:
+
+	  - vmalloc space must be large enough to hold many kernel stacks.
+	    This may rule out many 32-bit architectures.
+
+	  - Stacks in vmalloc space need to work reliably.  For example, if
+	    vmap page tables are created on demand, either this mechanism
+	    needs to work while the stack points to a virtual address with
+	    unpopulated page tables or arch code (switch_to and switch_mm,
+	    most likely) needs to ensure that the stack's page table entries
+	    are populated before running on a possibly unpopulated stack.
+
+	  - If the stack overflows into a guard page, something reasonable
+	    should happen.  The definition of "reasonable" is flexible, but
+	    instantly rebooting without logging anything would be unfriendly.
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
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index aa995b67c3f5..d13edda6e09c 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -56,7 +56,7 @@ struct thread_info {
 #define alloc_thread_info_node(tsk, node)	((struct thread_info *) 0)
 #define task_thread_info(tsk)	((struct thread_info *) 0)
 #endif
-#define free_thread_info(ti)	/* nothing */
+#define free_thread_info(tsk)	/* nothing */
 #define task_stack_page(tsk)	((void *)(tsk))
 
 #define __HAVE_THREAD_FUNCTIONS
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6e42ada26345..a37c3b790309 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1918,6 +1918,9 @@ struct task_struct {
 #ifdef CONFIG_MMU
 	struct task_struct *oom_reaper_list;
 #endif
+#ifdef CONFIG_VMAP_STACK
+	struct vm_struct *stack_vm_area;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -1934,6 +1937,18 @@ extern int arch_task_struct_size __read_mostly;
 # define arch_task_struct_size (sizeof(struct task_struct))
 #endif
 
+#ifdef CONFIG_VMAP_STACK
+static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
+{
+	return t->stack_vm_area;
+}
+#else
+static inline struct vm_struct *task_stack_vm_area(const struct task_struct *t)
+{
+	return NULL;
+}
+#endif
+
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
diff --git a/kernel/fork.c b/kernel/fork.c
index cd2abe6e4e41..ad77a6b07708 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -158,19 +158,38 @@ void __weak arch_release_thread_info(struct thread_info *ti)
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
  * kmemcache based allocator.
  */
-# if THREAD_SIZE >= PAGE_SIZE
+# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
+#ifdef CONFIG_VMAP_STACK
+	struct thread_info *ti = __vmalloc_node_range(
+		THREAD_SIZE, THREAD_SIZE, VMALLOC_START, VMALLOC_END,
+		THREADINFO_GFP | __GFP_HIGHMEM, PAGE_KERNEL,
+		0, node, __builtin_return_address(0));
+
+	/*
+	 * We can't call find_vm_area() in interrupt context, and
+	 * free_thread_info can be called in interrupt context, so cache
+	 * the vm_struct.
+	 */
+	if (ti)
+		tsk->stack_vm_area = find_vm_area(ti);
+	return ti;
+#else
 	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
 						  THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
+#endif
 }
 
-static inline void free_thread_info(struct thread_info *ti)
+static inline void free_thread_info(struct task_struct *tsk)
 {
-	free_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	if (task_stack_vm_area(tsk))
+		vfree(tsk->stack);
+	else
+		free_kmem_pages((unsigned long)tsk->stack, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
@@ -181,9 +200,9 @@ static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 	return kmem_cache_alloc_node(thread_info_cache, THREADINFO_GFP, node);
 }
 
-static void free_thread_info(struct thread_info *ti)
+static void free_thread_info(struct task_struct *tsk)
 {
-	kmem_cache_free(thread_info_cache, ti);
+	kmem_cache_free(thread_info_cache, tsk->stack);
 }
 
 void thread_info_cache_init(void)
@@ -213,24 +232,46 @@ struct kmem_cache *vm_area_cachep;
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache *mm_cachep;
 
-static void account_kernel_stack(struct thread_info *ti, int account)
+static void account_kernel_stack(struct task_struct *tsk, int account)
 {
-	struct zone *zone = page_zone(virt_to_page(ti));
+	struct zone *zone;
+	struct thread_info *ti = task_thread_info(tsk);
+	struct vm_struct *vm = task_stack_vm_area(tsk);
+
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
+
+	if (vm) {
+		int i;
 
-	mod_zone_page_state(zone, NR_KERNEL_STACK_KB,
-			    THREAD_SIZE / 1024 * account);
+		BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
-	/* All stack pages belong to the same memcg. */
-	memcg_kmem_update_page_stat(
-		virt_to_page(ti), MEMCG_KERNEL_STACK,
-		account * (THREAD_SIZE / PAGE_SIZE));
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
+			mod_zone_page_state(page_zone(vm->pages[i]),
+					    1, PAGE_SIZE / 1024 * account);
+		}
+
+		/* All stack pages belong to the same memcg. */
+		memcg_kmem_update_page_stat(
+			vm->pages[0], MEMCG_KERNEL_STACK,
+			account * (THREAD_SIZE / PAGE_SIZE));
+	} else {
+		zone = page_zone(virt_to_page(ti));
+
+		mod_zone_page_state(zone, NR_KERNEL_STACK_KB,
+				    THREAD_SIZE / 1024 * account);
+
+		/* All stack pages belong to the same memcg. */
+		memcg_kmem_update_page_stat(
+			virt_to_page(ti), MEMCG_KERNEL_STACK,
+			account * (THREAD_SIZE / PAGE_SIZE));
+	}
 }
 
 void free_task(struct task_struct *tsk)
 {
-	account_kernel_stack(tsk->stack, -1);
+	account_kernel_stack(tsk, -1);
 	arch_release_thread_info(tsk->stack);
-	free_thread_info(tsk->stack);
+	free_thread_info(tsk);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
@@ -342,6 +383,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
+	struct vm_struct *stack_vm_area;
 	int err;
 
 	if (node == NUMA_NO_NODE)
@@ -354,11 +396,16 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	if (!ti)
 		goto free_tsk;
 
+	stack_vm_area = task_stack_vm_area(tsk);
+
 	err = arch_dup_task_struct(tsk, orig);
 	if (err)
 		goto free_ti;
 
 	tsk->stack = ti;
+#ifdef CONFIG_VMAP_STACK
+	tsk->stack_vm_area = stack_vm_area;
+#endif
 #ifdef CONFIG_SECCOMP
 	/*
 	 * We must handle setting up seccomp filters once we're under
@@ -390,14 +437,14 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->task_frag.page = NULL;
 	tsk->wake_q.next = NULL;
 
-	account_kernel_stack(ti, 1);
+	account_kernel_stack(tsk, 1);
 
 	kcov_task_init(tsk);
 
 	return tsk;
 
 free_ti:
-	free_thread_info(ti);
+	free_thread_info(tsk);
 free_tsk:
 	free_task_struct(tsk);
 	return NULL;
-- 
2.5.5
