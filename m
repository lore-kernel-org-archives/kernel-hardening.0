Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:51 -0700
Message-Id: <32d90073b4c98c2fab5af97d9eecf7eea2f8c251.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v4 29/29] fork: Cache two thread stacks per cpu if CONFIG_VMAP_STACK is set
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

vmalloc is a bit slow, and pounding vmalloc/vfree will eventually
force a global TLB flush.

To reduce pressure on them, if CONFIG_VMAP_STACK, cache two thread
stacks per cpu.  This will let us quickly allocate a hopefully
cache-hot, TLB-hot stack under heavy forking workloads (shell script
style).

On my silly pthread_create benchmark, it saves about 2 µs per
pthread_create+join with CONFIG_VMAP_STACK=y.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/fork.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8dd1329e1bf8..4b8ea904e47b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -159,10 +159,37 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  * kmemcache based allocator.
  */
 # if THREAD_SIZE >= PAGE_SIZE || defined(CONFIG_VMAP_STACK)
+
+#ifdef CONFIG_VMAP_STACK
+/*
+ * vmalloc is a bit slow, and calling vfree enough times will force a TLB
+ * flush.  Try to minimize the number of calls by caching stacks.
+ */
+#define NR_CACHED_STACKS 2
+static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
+#endif
+
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 #ifdef CONFIG_VMAP_STACK
-	void *stack = __vmalloc_node_range(
+	void *stack;
+	int i;
+
+	local_irq_disable();
+	for (i = 0; i < NR_CACHED_STACKS; i++) {
+		struct vm_struct *s = this_cpu_read(cached_stacks[i]);
+
+		if (!s)
+			continue;
+		this_cpu_write(cached_stacks[i], NULL);
+
+		tsk->stack_vm_area = s;
+		local_irq_enable();
+		return s->addr;
+	}
+	local_irq_enable();
+
+	stack = __vmalloc_node_range(
 		THREAD_SIZE, THREAD_SIZE, VMALLOC_START, VMALLOC_END,
 		THREADINFO_GFP | __GFP_HIGHMEM, PAGE_KERNEL,
 		0, node, __builtin_return_address(0));
@@ -185,10 +212,29 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 
 static inline void free_thread_stack(struct task_struct *tsk)
 {
-	if (task_stack_vm_area(tsk))
+#ifdef CONFIG_VMAP_STACK
+	if (task_stack_vm_area(tsk)) {
+		unsigned long flags;
+		int i;
+
+		local_irq_save(flags);
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			if (this_cpu_read(cached_stacks[i]))
+				continue;
+
+			this_cpu_write(cached_stacks[i], tsk->stack_vm_area);
+			goto done;
+		}
+
 		vfree(tsk->stack);
-	else
-		free_kmem_pages((unsigned long)tsk->stack, THREAD_SIZE_ORDER);
+
+done:
+		local_irq_restore(flags);
+		return;
+	}
+#endif
+
+	free_kmem_pages((unsigned long)tsk->stack, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_stack_cache;
-- 
2.7.4
