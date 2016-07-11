Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:54:01 -0700
Message-Id: <cd442c3780f7aa2bb1b1f4d43fb61761f4d0f128.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 28/32] sched: Add try_get_task_stack() and put_task_stack()
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

There are a few places in the kernel that access stack memory
belonging to a different task.  Before we can start freeing task
stacks before the task_struct is freed, we need a way for those code
paths to pin the stack.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 include/linux/sched.h | 16 ++++++++++++++++
 init/Kconfig          |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4108b4880b86..18bef18fef88 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -3063,11 +3063,19 @@ static inline struct thread_info *task_thread_info(struct task_struct *task)
 {
 	return &task->thread_info;
 }
+
+/*
+ * When accessing the stack of a non-current task that might exit, use
+ * try_get_task_stack() instead.  task_stack_page will return a pointer
+ * that could get freed out from under you.
+ */
 static inline void *task_stack_page(const struct task_struct *task)
 {
 	return task->stack;
 }
+
 #define setup_thread_stack(new,old)	do { } while(0)
+
 static inline unsigned long *end_of_stack(const struct task_struct *task)
 {
 	return task->stack;
@@ -3103,6 +3111,14 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 }
 
 #endif
+
+static inline void *try_get_task_stack(struct task_struct *tsk)
+{
+	return task_stack_page(tsk);
+}
+
+static inline void put_task_stack(struct task_struct *tsk) {}
+
 #define task_stack_end_corrupted(task) \
 		(*(end_of_stack(task)) != STACK_END_MAGIC)
 
diff --git a/init/Kconfig b/init/Kconfig
index 2cdf20e03b1f..8823df60d312 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -33,6 +33,9 @@ config THREAD_INFO_IN_TASK
 	  make this work, an arch will need to remove all thread_info fields
 	  except flags and fix any runtime bugs.
 
+	  One subtle change that will be needed is to use try_get_task_stack()
+	  and put_task_stack() in save_thread_stack_tsk().
+
 menu "General setup"
 
 config BROKEN
-- 
2.7.4
