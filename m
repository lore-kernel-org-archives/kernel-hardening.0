Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 16 Jan 2017 14:23:03 +0100
Message-Id: <1484572984-13388-2-git-send-email-djalal@gmail.com>
In-Reply-To: <1484572984-13388-1-git-send-email-djalal@gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH v4 1/2] procfs: use an enum for possible hidepid values
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Lafcadio Wluiki <wluikil@gmail.com>

Previously, the hidepid parameter was checked by comparing literal
integers 0, 1, 2. Let's add a proper enum for this, to make the checking
more expressive:

        0 → HIDEPID_OFF
        1 → HIDEPID_NO_ACCESS
        2 → HIDEPID_INVISIBLE

This changes the internal labelling only, the userspace-facing interface
remains unmodified, and still works with literal integers 0, 1, 2.

No functional changes.

Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Djalal Harouni <tixxdz@gmail.com>
Signed-off-by: Lafcadio Wluiki <wluikil@gmail.com>
---
 fs/proc/base.c                | 8 ++++----
 fs/proc/inode.c               | 2 +-
 fs/proc/root.c                | 3 ++-
 include/linux/pid_namespace.h | 6 ++++++
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8e7e61b..cd8dd15 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -729,11 +729,11 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms = has_pid_permissions(pid, task, 1);
+	has_perms = has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (pid->hide_pid == 2) {
+		if (pid->hide_pid == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
@@ -1725,7 +1725,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	stat->gid = GLOBAL_ROOT_GID;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, 2)) {
+		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -3179,7 +3179,7 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
 		char name[PROC_NUMBUF];
 		int len;
-		if (!has_pid_permissions(ns, iter.task, 2))
+		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
 		len = snprintf(name, sizeof(name), "%d", iter.tgid);
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 842a5ff..5d9bafb 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -106,7 +106,7 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 
 	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
-	if (pid->hide_pid != 0)
+	if (pid->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
 
 	return 0;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1988440..b90da88 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -58,7 +58,8 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
 				return 0;
-			if (option < 0 || option > 2) {
+			if (option < HIDEPID_OFF ||
+			    option > HIDEPID_INVISIBLE) {
 				pr_err("proc: hidepid value must be between 0 and 2.\n");
 				return 0;
 			}
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 34cce96..c2a989d 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -21,6 +21,12 @@ struct pidmap {
 
 struct fs_pin;
 
+enum { /* definitions for pid_namespace's hide_pid field */
+	HIDEPID_OFF	  = 0,
+	HIDEPID_NO_ACCESS = 1,
+	HIDEPID_INVISIBLE = 2,
+};
+
 struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
-- 
2.5.5
