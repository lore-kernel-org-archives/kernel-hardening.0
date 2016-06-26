Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:50 -0700
Message-Id: <ec58e505925c46bd43f9c4275c78292d4483af16.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 28/29] sched: Free the stack early if CONFIG_THREAD_INFO_IN_TASK
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
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
 include/linux/sched.h |  1 +
 kernel/fork.c         | 23 ++++++++++++++++++++++-
 kernel/sched/core.c   |  9 +++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4108b4880b86..0b9486826d62 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2659,6 +2659,7 @@ static inline void kernel_signal_stop(void)
 }
 
 extern void release_task(struct task_struct * p);
+extern void release_task_stack(struct task_struct *tsk);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
diff --git a/kernel/fork.c b/kernel/fork.c
index 06761de69360..8dd1329e1bf8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -269,11 +269,32 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 	}
 }
 
-void free_task(struct task_struct *tsk)
+void release_task_stack(struct task_struct *tsk)
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
+	WARN_ON_ONCE(tsk->stack);
+#endif
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 51d7105f529a..00c9ba5cf605 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2742,6 +2742,15 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 		 * task and put them back on the free list.
 		 */
 		kprobe_flush_task(prev);
+
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+		/*
+		 * If thread_info is in task_struct, then the dead task no
+		 * longer needs its stack.  Free it right away.
+		 */
+		release_task_stack(prev);
+#endif
+
 		put_task_struct(prev);
 	}
 
-- 
2.7.4
