Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:54:04 -0700
Message-Id: <0adfb2c369747002dc8442f71987d1fb6eb9feb7.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 31/32] sched: Free the stack early if CONFIG_THREAD_INFO_IN_TASK
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

We currently keep every task's stack around until the task_struct
itself is freed.  This means that we keep the stack allocation alive
for longer than necessary and that, under load, we free stacks in
big batches whenever RCU drops the last task reference.  Neither of
these is good for reuse of cache-hot memory, and freeing in batches
prevents us from usefully caching small numbers of vmalloced stacks.

On architectures that have thread_info on the stack, we can't easily
change this, but on architectures that set THREAD_INFO_IN_TASK, we
can free it as soon as the task is dead.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 include/linux/init_task.h |  4 +++-
 include/linux/sched.h     | 14 ++++++++++++++
 kernel/fork.c             | 35 ++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c       |  4 ++++
 4 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c04d44eeb3c..325f649d77ff 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -186,7 +186,9 @@ extern struct task_group root_task_group;
 #endif
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
-# define INIT_TASK_TI(tsk) .thread_info = INIT_THREAD_INFO(tsk),
+# define INIT_TASK_TI(tsk)			\
+	.thread_info = INIT_THREAD_INFO(tsk),	\
+	.stack_refcount = ATOMIC_INIT(1),
 #else
 # define INIT_TASK_TI(tsk)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18bef18fef88..cefd136248c4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1934,6 +1934,10 @@ struct task_struct {
 #ifdef CONFIG_VMAP_STACK
 	struct vm_struct *stack_vm_area;
 #endif
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	/* A live task holds one reference. */
+	atomic_t stack_refcount;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
@@ -3112,12 +3116,22 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 
 #endif
 
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+static inline void *try_get_task_stack(struct task_struct *tsk)
+{
+	return atomic_inc_not_zero(&tsk->stack_refcount) ?
+		task_stack_page(tsk) : NULL;
+}
+
+extern void put_task_stack(struct task_struct *tsk);
+#else
 static inline void *try_get_task_stack(struct task_struct *tsk)
 {
 	return task_stack_page(tsk);
 }
 
 static inline void put_task_stack(struct task_struct *tsk) {}
+#endif
 
 #define task_stack_end_corrupted(task) \
 		(*(end_of_stack(task)) != STACK_END_MAGIC)
diff --git a/kernel/fork.c b/kernel/fork.c
index d2a64a0413be..3003edae90fc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -269,11 +269,40 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 	}
 }
 
-void free_task(struct task_struct *tsk)
+static void release_task_stack(struct task_struct *tsk)
 {
 	account_kernel_stack(tsk, -1);
 	arch_release_thread_stack(tsk->stack);
 	free_thread_stack(tsk);
+	tsk->stack = NULL;
+#ifdef CONFIG_VMAP_STACK
+	tsk->stack_vm_area = NULL;
+#endif
+}
+
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+void put_task_stack(struct task_struct *tsk)
+{
+	if (atomic_dec_and_test(&tsk->stack_refcount))
+		release_task_stack(tsk);
+}
+#endif
+
+void free_task(struct task_struct *tsk)
+{
+#ifndef CONFIG_THREAD_INFO_IN_TASK
+	/*
+	 * The task is finally done with both the stack and thread_info,
+	 * so free both.
+	 */
+	release_task_stack(tsk);
+#else
+	/*
+	 * If the task had a separate stack allocation, it should be gone
+	 * by now.
+	 */
+	WARN_ON_ONCE(atomic_read(&tsk->stack_refcount) != 0);
+#endif
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
@@ -411,6 +440,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #ifdef CONFIG_VMAP_STACK
 	tsk->stack_vm_area = stack_vm_area;
 #endif
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	atomic_set(&tsk->stack_refcount, 1);
+#endif
 
 	if (err)
 		goto free_stack;
@@ -1750,6 +1782,7 @@ bad_fork_cleanup_count:
 	atomic_dec(&p->cred->user->processes);
 	exit_creds(p);
 bad_fork_free:
+	put_task_stack(p);
 	free_task(p);
 fork_out:
 	return ERR_PTR(retval);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 51d7105f529a..a2da85cbcbde 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2742,6 +2742,10 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 		 * task and put them back on the free list.
 		 */
 		kprobe_flush_task(prev);
+
+		/* Task is done with its stack. */
+		put_task_stack(prev);
+
 		put_task_struct(prev);
 	}
 
-- 
2.7.4
