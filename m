Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 12 Dec 2011 15:36:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111212113618.GB12141@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2 -next] proc: fix task_struct memleak
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

proc_pid_permission() doesn't put task_struct on every /proc/$pid/
access.  A demo from Hugh Dickins:

while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done

Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 This is a patch against a hidepid patchset from -mm.

 fs/proc/base.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8caf5cb..c2b38bc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -646,9 +646,14 @@ static bool has_pid_permissions(struct pid_namespace *pid,
 static int proc_pid_permission(struct inode *inode, int mask)
 {
 	struct pid_namespace *pid = inode->i_sb->s_fs_info;
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task;
+	bool has_perms;
+
+	task = get_proc_task(inode);
+	has_perms = has_pid_permissions(pid, task, 1);
+	put_task_struct(task);
 
-	if (!has_pid_permissions(pid, task, 1)) {
+	if (!has_perms) {
 		if (pid->hide_pid == 2) {
 			/*
 			 * Let's make getdents(), stat(), and open()
-- 
1.7.0.4
