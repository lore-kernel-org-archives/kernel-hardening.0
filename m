Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:40 -0700
Message-Id: <51f37059777910f989486657d1e27ded4c7edad2.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 07/32] fork: Add generic vmalloced stack support
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
vmalloc_node.

grsecurity has had a similar feature (called
GRKERNSEC_KSTACKOVERFLOW) for a long time.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/Kconfig                        | 33 +++++++++++++
 arch/ia64/include/asm/thread_info.h |  2 +-
 include/linux/sched.h               | 15 ++++++
 kernel/fork.c                       | 96 +++++++++++++++++++++++++++++--------
 4 files changed, 125 insertions(+), 21 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 15996290fed4..14398fcf8292 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -661,4 +661,37 @@ config ARCH_NO_COHERENT_DMA_MMAP
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
+	depends on HAVE_ARCH_VMAP_STACK && !KASAN
+	---help---
+	  Enable this if you want the use virtually-mapped kernel stacks
+	  with guard pages.  This causes kernel stack overflows to be
+	  caught immediately rather than causing difficult-to-diagnose
+	  corruption.
+
+	  This is presently incompatible with KASAN because KASAN expects
+	  the stack to map directly to the KASAN shadow map using a formula
+	  that is incorrect if the stack is in vmalloc space.
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index d1212b84fb83..f0a72e98e5a4 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -56,7 +56,7 @@ struct thread_info {
 #define alloc_thread_stack_node(tsk, node)	((unsigned long *) 0)
 #define task_thread_info(tsk)	((struct thread_info *) 0)
 #endif
-#define free_thread_stack(ti)	/* nothing */
+#define free_thread_stack(tsk)	/* nothing */
 #define task_stack_page(tsk)	((void *)(tsk))
 
 #define __HAVE_THREAD_FUNCTIONS
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 253538f29ade..26869dba21f1 100644
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
index 146c9840c079..d2a64a0413be 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -158,19 +158,39 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
  * kmemcache based allocator.
  */
-# if THREAD_SIZE >= PAGE_SIZE
-static unsigned long *alloc_thread_stack_node(struct task_struct *tsk,
-						  int node)
+# if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
+static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
+#ifdef CONFIG_VMAP_STACK
+	void *stack = __vmalloc_node_range(THREAD_SIZE, THREAD_SIZE,
+					   VMALLOC_START, VMALLOC_END,
+					   THREADINFO_GFP | __GFP_HIGHMEM,
+					   PAGE_KERNEL,
+					   0, node,
+					   __builtin_return_address(0));
+
+	/*
+	 * We can't call find_vm_area() in interrupt context, and
+	 * free_thread_stack can be called in interrupt context, so cache
+	 * the vm_struct.
+	 */
+	if (stack)
+		tsk->stack_vm_area = find_vm_area(stack);
+	return stack;
+#else
 	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
 						  THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
+#endif
 }
 
-static inline void free_thread_stack(unsigned long *stack)
+static inline void free_thread_stack(struct task_struct *tsk)
 {
-	free_kmem_pages((unsigned long)stack, THREAD_SIZE_ORDER);
+	if (task_stack_vm_area(tsk))
+		vfree(tsk->stack);
+	else
+		free_kmem_pages((unsigned long)tsk->stack, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_stack_cache;
@@ -181,9 +201,9 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk,
 	return kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP, node);
 }
 
-static void free_thread_stack(unsigned long *stack)
+static void free_thread_stack(struct task_struct *tsk)
 {
-	kmem_cache_free(thread_stack_cache, stack);
+	kmem_cache_free(thread_stack_cache, tsk->stack);
 }
 
 void thread_stack_cache_init(void)
@@ -213,24 +233,47 @@ struct kmem_cache *vm_area_cachep;
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache *mm_cachep;
 
-static void account_kernel_stack(unsigned long *stack, int account)
+static void account_kernel_stack(struct task_struct *tsk, int account)
 {
-	/* All stack pages are in the same zone and belong to the same memcg. */
-	struct page *first_page = virt_to_page(stack);
+	void *stack = task_stack_page(tsk);
+	struct vm_struct *vm = task_stack_vm_area(tsk);
+
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_VMAP_STACK) && PAGE_SIZE % 1024 != 0);
+
+	if (vm) {
+		int i;
+
+		BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
+
+		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
+			mod_zone_page_state(page_zone(vm->pages[i]),
+					    NR_KERNEL_STACK_KB,
+					    PAGE_SIZE / 1024 * account);
+		}
 
-	mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
-			    THREAD_SIZE / 1024 * account);
+		/* All stack pages belong to the same memcg. */
+		memcg_kmem_update_page_stat(vm->pages[0], MEMCG_KERNEL_STACK_KB,
+					    account * (THREAD_SIZE / 1024));
+	} else {
+		/*
+		 * All stack pages are in the same zone and belong to the
+		 * same memcg.
+		 */
+		struct page *first_page = virt_to_page(stack);
+
+		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
+				    THREAD_SIZE / 1024 * account);
 
-	memcg_kmem_update_page_stat(
-		first_page, MEMCG_KERNEL_STACK_KB,
-		account * (THREAD_SIZE / 1024));
+		memcg_kmem_update_page_stat(first_page, MEMCG_KERNEL_STACK_KB,
+					    account * (THREAD_SIZE / 1024));
+	}
 }
 
 void free_task(struct task_struct *tsk)
 {
-	account_kernel_stack(tsk->stack, -1);
+	account_kernel_stack(tsk, -1);
 	arch_release_thread_stack(tsk->stack);
-	free_thread_stack(tsk->stack);
+	free_thread_stack(tsk);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
@@ -342,6 +385,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 {
 	struct task_struct *tsk;
 	unsigned long *stack;
+	struct vm_struct *stack_vm_area;
 	int err;
 
 	if (node == NUMA_NO_NODE)
@@ -354,11 +398,23 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	if (!stack)
 		goto free_tsk;
 
+	stack_vm_area = task_stack_vm_area(tsk);
+
 	err = arch_dup_task_struct(tsk, orig);
+
+	/*
+	 * arch_dup_task_struct clobbers the stack-related fields.  Make
+	 * sure they're properly initialized before using any stack-related
+	 * functions again.
+	 */
+	tsk->stack = stack;
+#ifdef CONFIG_VMAP_STACK
+	tsk->stack_vm_area = stack_vm_area;
+#endif
+
 	if (err)
 		goto free_stack;
 
-	tsk->stack = stack;
 #ifdef CONFIG_SECCOMP
 	/*
 	 * We must handle setting up seccomp filters once we're under
@@ -390,14 +446,14 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->task_frag.page = NULL;
 	tsk->wake_q.next = NULL;
 
-	account_kernel_stack(stack, 1);
+	account_kernel_stack(tsk, 1);
 
 	kcov_task_init(tsk);
 
 	return tsk;
 
 free_stack:
-	free_thread_stack(stack);
+	free_thread_stack(tsk);
 free_tsk:
 	free_task_struct(tsk);
 	return NULL;
-- 
2.7.4
