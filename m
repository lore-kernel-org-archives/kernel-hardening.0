Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:11 +0100
Message-Id: <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 1/9] exec: add a global execve counter
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Procfs files and other important objects may contain sensitive information
which must not be seen, inherited or processed across execve.
The commit e268337dfe26dfc7efd422a804dbb27977a3cccc tries to fix the same
problem.

Given that consideration this patch introduces two counters:
A global atomic execve counter that will be incremented on every
do_execve_common() call, and an atomic exec_id member for the task_struct.

The task's exec_id can be used as a security check to see and to test if
some special objects belong to the appropriate process image since it will
be a uniq id on each execve operation.

There is also new helper functions:
get_task_exec_id() to get the task's exec_id and task_exec_id_ok() to
check if the provided exec_id equals the task's exec_id.

The exec_id idea is taken from the recent grsecurity patches.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/exec.c             |   11 +++++++++++
 include/linux/sched.h |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 153dee1..fb8ccae 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1448,6 +1448,14 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 EXPORT_SYMBOL(search_binary_handler);
 
 /*
+ * A global execve counter that we need to set atomically.
+ * It will be incremented on every do_execve_common() this way we can use
+ * it to check if some special objects belong to the appropriate process
+ * image.
+ */
+static atomic64_t exec_counter = ATOMIC_INIT(0);
+
+/*
  * sys_execve() executes a new program.
  */
 static int do_execve_common(const char *filename,
@@ -1460,6 +1468,7 @@ static int do_execve_common(const char *filename,
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
+	u64 exec_id;
 	const struct cred *cred = current_cred();
 
 	/*
@@ -1542,6 +1551,8 @@ static int do_execve_common(const char *filename,
 		goto out;
 
 	/* execve succeeded */
+	exec_id = atomic64_inc_return(&exec_counter);
+	atomic64_set(&current->exec_id, exec_id);
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	acct_update_integrals(current);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0657368..762f206 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1420,6 +1420,9 @@ struct task_struct {
 #endif
 	seccomp_t seccomp;
 
+/* Execve counter: will be used to check if objects belong to the appropriate
+ * process image */
+	atomic64_t exec_id;
 /* Thread group tracking */
    	u32 parent_exec_id;
    	u32 self_exec_id;
@@ -1752,6 +1755,35 @@ static inline int is_global_init(struct task_struct *tsk)
 	return tsk->pid == 1;
 }
 
+/**
+ * task_get_exec_id - get the task's exec_id
+ * @task: Task struct to operate on.
+ *
+ * Get the task's exec_id.
+ */
+static inline u64 get_task_exec_id(struct task_struct *task)
+{
+	return atomic64_read(&task->exec_id);
+}
+
+/**
+ * task_exec_id_ok - check if the task's exec_id equals the provided
+ * exec_id.
+ * @task: Task struct to check against.
+ * @exec_id: Execve ID.
+ *
+ * Check if the task's exec_id equals the provided exec_id. Use it to
+ * protect special objects.
+ *
+ * It will be more effective if the check is delayed as mush as possible
+ * to avoid any new execve surprises especially if we are checking against
+ * target task's exec_id.
+ */
+static inline int task_exec_id_ok(struct task_struct *task, u64 exec_id)
+{
+	return atomic64_read(&task->exec_id) == exec_id;
+}
+
 /*
  * is_container_init:
  * check whether in the task is init in its own pid namespace.
-- 
1.7.1
