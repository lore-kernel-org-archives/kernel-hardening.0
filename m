Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 16 Jan 2017 14:23:04 +0100
Message-Id: <1484572984-13388-3-git-send-email-djalal@gmail.com>
In-Reply-To: <1484572984-13388-1-git-send-email-djalal@gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs hidepid= field
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Djalal Harouni <tixxdz@gmail.com>

This adds a new per-task hidepid= flag that is honored by procfs when
presenting /proc to the user, in addition to the existing hidepid= mount
option. So far, hidepid= was exclusively a per-pidns setting. Locking
down a set of processes so that they cannot see other user's processes
without affecting the rest of the system thus currently requires
creation of a private PID namespace, with all the complexity it brings,
including maintaining a stub init process as PID 1 and losing the
ability to see processes of the same user on the rest of the system.

With this patch all acesss and visibility checks in procfs now
honour two fields:

	a) the existing hide_pid field in the PID namespace
	b) the new hide_pid in struct task_struct

Access/visibility is only granted if both fields permit it; the more
restrictive one wins. By default the new task_struct hide_pid value
defaults to 0, which means behaviour is not changed from the status quo.

Setting the per-process hide_pid value is done via a new PR_SET_HIDEPID
prctl() option which takes the same three supported values as the
hidepid= mount option. The per-process hide_pid may only be increased,
never decreased, thus ensuring that once applied, processes can never
escape such a hide_pid jail.  When a process forks it inherits its
parent's hide_pid value.

Suggested usecase: let's say nginx runs as user "www-data". After
dropping privileges it may now call:

	…
	prctl(PR_SET_HIDEPID, 2);
	…

And from that point on neither nginx itself, nor any of its child
processes may see processes in /proc anymore that belong to a different
user than "www-data". Other services running on the same system remain
unaffected.

This should permit Linux distributions to more comprehensively lock down
their services, as it allows an isolated opt-in for hidepid= for
specific services. Previously hidepid= could only be set system-wide,
and then specific services had to be excluded by group membership,
essentially a more complex concept of opt-out.

A tool to test this is available here:
https://gist.github.com/tixxdz/4e6d21071463ad2c5a043984e3efb5a1

Original-author: Lafcadio Wluiki <wluikil@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 Documentation/filesystems/proc.txt |  2 ++
 fs/proc/array.c                    |  3 +++
 fs/proc/base.c                     |  8 ++++++--
 include/linux/init_task.h          |  1 +
 include/linux/sched.h              |  1 +
 include/uapi/linux/prctl.h         |  4 ++++
 kernel/fork.c                      |  1 +
 kernel/sys.c                       | 13 +++++++++++++
 8 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 72624a1..fc95261 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -164,6 +164,7 @@ read the file /proc/PID/status:
   Uid:    501     501     501     501
   Gid:    100     100     100     100
   FDSize: 256
+  HidePid:      0
   Groups: 100 14 16
   VmPeak:     5004 kB
   VmSize:     5004 kB
@@ -228,6 +229,7 @@ Table 1-2: Contents of the status files (as of 4.1)
  Gid                         Real, effective, saved set, and  file system GIDs
  Umask                       file mode creation mask
  FDSize                      number of file descriptor slots currently allocated
+ HidePid                     process access mode of /proc/<pid>/
  Groups                      supplementary group list
  NStgid                      descendant namespace thread group ID hierarchy
  NSpid                       descendant namespace process ID hierarchy
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 51a4213..e6cd1a1 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -163,6 +163,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	const struct cred *cred;
 	pid_t ppid, tpid = 0, tgid, ngid;
 	unsigned int max_fds = 0;
+	int hide_pid;
 
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
@@ -183,6 +184,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	task_lock(p);
 	if (p->files)
 		max_fds = files_fdtable(p->files)->max_fds;
+	hide_pid = p->hide_pid;
 	task_unlock(p);
 	rcu_read_unlock();
 
@@ -201,6 +203,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->egid));
 	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->sgid));
 	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->fsgid));
+	seq_put_decimal_ull(m, "\nHidePid:\t", hide_pid);
 	seq_put_decimal_ull(m, "\nFDSize:\t", max_fds);
 
 	seq_puts(m, "\nGroups:\t");
diff --git a/fs/proc/base.c b/fs/proc/base.c
index cd8dd15..596b17f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -712,7 +712,9 @@ static bool has_pid_permissions(struct pid_namespace *pid,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (pid->hide_pid < hide_pid_min)
+	int hide_pid = max(pid->hide_pid, (int) current->hide_pid);
+
+	if (hide_pid < hide_pid_min)
 		return true;
 	if (in_group_p(pid->pid_gid))
 		return true;
@@ -733,7 +735,9 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (pid->hide_pid == HIDEPID_INVISIBLE) {
+		int hide_pid = max(pid->hide_pid, (int) current->hide_pid);
+
+		if (hide_pid == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 325f649..c87de0e 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -250,6 +250,7 @@ extern struct task_group root_task_group;
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),	\
 	.timer_slack_ns = 50000, /* 50 usec default slack */		\
+	.hide_pid	= 0,						\
 	.pids = {							\
 		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
 		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ad3ec9e..ba9f1d5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1608,6 +1608,7 @@ struct task_struct {
 	/* unserialized, strictly 'current' */
 	unsigned in_execve:1; /* bit to tell LSMs we're in execve */
 	unsigned in_iowait:1;
+	unsigned hide_pid:2; /* per-process procfs hidepid= */
 #if !defined(TIF_RESTORE_SIGMASK)
 	unsigned restore_sigmask:1;
 #endif
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a8d0759..ada62b6 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -197,4 +197,8 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/* Per process, non-revokable procfs hidepid= option */
+#define PR_SET_HIDEPID 48
+#define PR_GET_HIDEPID 49
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 11c5c8a..a701a77 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1574,6 +1574,7 @@ static __latent_entropy struct task_struct *copy_process(
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
+	p->hide_pid = current->hide_pid;
 
 	task_io_accounting_init(&p->ioac);
 	acct_clear_integrals(p);
diff --git a/kernel/sys.c b/kernel/sys.c
index 842914e..4041ff4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2261,6 +2261,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_GET_FP_MODE:
 		error = GET_FP_MODE(me);
 		break;
+	case PR_SET_HIDEPID:
+		if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE ||
+		    arg3 || arg4 || arg5)
+			return -EINVAL;
+		if (arg2 < me->hide_pid)
+			return -EPERM;
+		me->hide_pid = arg2;
+		break;
+	case PR_GET_HIDEPID:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = me->hide_pid;
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.5.5
