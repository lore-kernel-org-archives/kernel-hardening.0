From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sat, 11 Feb 2017 19:26:48 +0900
Message-Id: <1486808828-8854-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [PATCH v5] fork: free vmapped stacks in cache when cpus are offline
To: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Hoeun Ryu <hoeun.ryu@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

 Using virtually mapped stack, kernel stacks are allocated via vmalloc.
In the current implementation, two stacks per cpu can be cached when
tasks are freed and the cached stacks are used again in task duplications.
but the cached stacks may remain unfreed even when cpus are offline.
 By adding a cpu hotplug callback to free the cached stacks when a cpu
goes offline, the pages of the cached stacks are not wasted.

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
v5:
 - wrap cpuhp_setup_state() in a new function, vm_stack_cache_init() which
   actually do nothing when !CONFIG_VMAP_STACK
 - add __may_unused to free_vm_stack_cache()
v4:
 - use CPUHP_BP_PREPARE_DYN state for cpuhp setup
 - fix minor coding style
v3:
 - fix misuse of per-cpu api
 - fix location of function definition within CONFIG_VMAP_STACK
v2:
 - remove cpuhp callback for `startup`, only `teardown` callback is installed.

 kernel/fork.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 937ba59..86a1110 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -168,6 +168,32 @@ void __weak arch_release_thread_stack(unsigned long *stack)
  */
 #define NR_CACHED_STACKS 2
 static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
+
+static int __maybe_unused free_vm_stack_cache(unsigned int cpu)
+{
+	struct vm_struct **cached_vm_stacks = per_cpu_ptr(cached_stacks, cpu);
+	int i;
+
+	for (i = 0; i < NR_CACHED_STACKS; i++) {
+		struct vm_struct *vm_stack = cached_vm_stacks[i];
+
+		if (!vm_stack)
+			continue;
+
+		vfree(vm_stack->addr);
+		cached_vm_stacks[i] = NULL;
+	}
+
+	return 0;
+}
+
+static inline int vm_stack_cache_init(void)
+{
+	return cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
+				 NULL, free_vm_stack_cache);
+}
+#else
+static __always_inline int vm_stack_cache_init(void) { return 0; }
 #endif
 
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
@@ -456,6 +482,8 @@ void __init fork_init(void)
 	for (i = 0; i < UCOUNT_COUNTS; i++) {
 		init_user_ns.ucount_max[i] = max_threads/2;
 	}
+
+	vm_stack_cache_init();
 }
 
 int __weak arch_dup_task_struct(struct task_struct *dst,
-- 
2.7.4
