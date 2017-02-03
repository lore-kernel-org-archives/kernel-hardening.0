From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sat,  4 Feb 2017 00:30:05 +0900
Message-Id: <1486135892-27249-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [PATCH 1/3] fork: dynamically allocate cache array for vmapped stacks using cpuhp
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Hoeun Ryu <hoeun.ryu@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

 Using virtually mapped stack, kernel stacks are allocated via vmalloc.
In the current implementation, two stacks per cpu can be cached when
tasks are freed and the cached stacks are used again in task duplications.
but the array for the cached stacks is statically allocated by per-cpu api.
 In this new implementation, the array for the cached stacks are dynamically
allocted and freed by cpu hotplug callbacks and the cached stacks are freed
when cpu is down. setup for cpu hotplug is established in fork_init().

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 kernel/fork.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 17 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 61284d8..54421a9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -167,26 +167,71 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  * flush.  Try to minimize the number of calls by caching stacks.
  */
 #define NR_CACHED_STACKS 2
-static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
+
+struct vm_stack_cache {
+	struct vm_struct **vm_stacks;
+	int nr;
+	int cur;
+};
+
+static DEFINE_PER_CPU(struct vm_stack_cache, vm_stacks);
+
+static int alloc_vm_stack_cache(unsigned int cpu)
+{
+	struct vm_stack_cache *vm_stack_cache = &per_cpu(vm_stacks, cpu);
+	struct vm_struct **vm_stacks = vm_stack_cache->vm_stacks;
+	int i;
+
+	/* if free_vm_stack_cache() didn't free it */
+	if (!vm_stacks) {
+		vm_stacks =
+			vzalloc(sizeof(struct vm_struct *) * NR_CACHED_STACKS);
+		if (!vm_stacks)
+			return -ENOMEM;
+	}
+
+	vm_stack_cache->vm_stacks = vm_stacks;
+	vm_stack_cache->cur = 0;
+	vm_stack_cache->nr = 0;
+
+	return 0;
+}
+
+static int free_vm_stack_cache(unsigned int cpu)
+{
+	struct vm_stack_cache *vm_stack_cache = &per_cpu(vm_stacks, cpu);
+	struct vm_struct **vm_stacks = vm_stack_cache->vm_stacks;
+	int i;
+
+	for (i = 0; i < vm_stack_cache->nr; i++) {
+		vfree(vm_stacks[i]->addr);
+		vm_stacks[i] = NULL;
+	}
+
+	vm_stack_cache->nr = 0;
+	vm_stack_cache->cur = 0;
+	/* do not free vm_stack[cpu]->vm_stacks itself, reused in allocation */
+
+	return 0;
+}
+
 #endif
 
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 #ifdef CONFIG_VMAP_STACK
+	struct vm_stack_cache *vm_stack_cache =
+		&per_cpu(vm_stacks, smp_processor_id());
+	struct vm_struct **vm_stacks = vm_stack_cache->vm_stacks;
 	void *stack;
-	int i;
 
 	local_irq_disable();
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *s = this_cpu_read(cached_stacks[i]);
-
-		if (!s)
-			continue;
-		this_cpu_write(cached_stacks[i], NULL);
-
-		tsk->stack_vm_area = s;
+	if (vm_stack_cache->cur > 0) {
+		struct vm_struct *vm_stack = vm_stacks[--vm_stack_cache->cur];
+		tsk->stack_vm_area = vm_stack;
 		local_irq_enable();
-		return s->addr;
+
+		return vm_stack->addr;
 	}
 	local_irq_enable();
 
@@ -216,15 +261,14 @@ static inline void free_thread_stack(struct task_struct *tsk)
 {
 #ifdef CONFIG_VMAP_STACK
 	if (task_stack_vm_area(tsk)) {
+		struct vm_stack_cache *vm_stack_cache =
+			&per_cpu(vm_stacks, smp_processor_id());
+		struct vm_struct **vm_stacks = vm_stack_cache->vm_stacks;
 		unsigned long flags;
-		int i;
 
 		local_irq_save(flags);
-		for (i = 0; i < NR_CACHED_STACKS; i++) {
-			if (this_cpu_read(cached_stacks[i]))
-				continue;
-
-			this_cpu_write(cached_stacks[i], tsk->stack_vm_area);
+		if (vm_stack_cache->cur < vm_stack_cache->nr) {
+			vm_stacks[vm_stack_cache->cur++] = tsk->stack_vm_area;
 			local_irq_restore(flags);
 			return;
 		}
@@ -456,6 +500,9 @@ void __init fork_init(void)
 	for (i = 0; i < UCOUNT_COUNTS; i++) {
 		init_user_ns.ucount_max[i] = max_threads/2;
 	}
+
+	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "vm_stack_cache",
+			  alloc_vm_stack_cache, free_vm_stack_cache);
 }
 
 int __weak arch_dup_task_struct(struct task_struct *dst,
-- 
2.7.4
