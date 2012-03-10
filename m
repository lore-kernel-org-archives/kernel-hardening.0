Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:16 +0100
Message-Id: <1331421919-15499-7-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 6/9] proc: protect /proc/<pid>/* ONE files from reader across execve
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Protect the /proc/<pid>/{stack,stat,personality} ONE files from reader
across execve by checking the exec_id of the reader.

The check is against current's exec_id since there are no permission
checks (ptrace) at open time and currently we do not want to change the
internal logic of these files, so we just make sure that the reader process
did not perform an execve at read time.

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Solar Designer <solar@openwall.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/array.c |    4 ++++
 fs/proc/base.c  |   34 +++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c602b8d..20b6f5e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -381,6 +381,10 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
 	permitted = ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT);
+
+	if (!proc_exec_id_ok(current, m->private))
+		return 0;
+
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6df8ddd..0a5383e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -305,6 +305,7 @@ static void unlock_trace(struct task_struct *task)
 static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
+	struct proc_file_private *priv = m->private;
 	struct stack_trace trace;
 	unsigned long *entries;
 	int err;
@@ -320,17 +321,24 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.skip		= 0;
 
 	err = lock_trace(task);
-	if (!err) {
-		save_stack_trace_tsk(task, &trace);
+	if (err)
+		goto out_free;
 
-		for (i = 0; i < trace.nr_entries; i++) {
-			seq_printf(m, "[<%pK>] %pS\n",
-				   (void *)entries[i], (void *)entries[i]);
-		}
-		unlock_trace(task);
+	err = 0;
+	if (!proc_exec_id_ok(current, priv))
+		goto out_unlock;
+
+	save_stack_trace_tsk(task, &trace);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%pK>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
 	}
-	kfree(entries);
 
+out_unlock:
+	unlock_trace(task);
+out_free:
+	kfree(entries);
 	return err;
 }
 #endif
@@ -3021,10 +3029,14 @@ static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
 	int err = lock_trace(task);
-	if (!err) {
+	if (err)
+		return err;
+
+	err = 0;
+	if (proc_exec_id_ok(current, m->private))
 		seq_printf(m, "%08x\n", task->personality);
-		unlock_trace(task);
-	}
+
+	unlock_trace(task);
 	return err;
 }
 
-- 
1.7.1
