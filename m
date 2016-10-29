Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 12:19:52 -0400
Message-Id: <1477757996-22468-2-git-send-email-dwindsor@gmail.com>
In-Reply-To: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
References: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening][RFC PATCH 1/5] fs: add overflow protection to struct fs_struct.users
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, elena.reshetova@intel.com, ishkamiel@gmail.com, takahiro.akashi@linaro.org, colin@cvidal.org, dwindsor@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Change type of struct fs_struct.users to atomic_t.  This enables overflow
protection: when CONFIG_HARDENED_ATOMIC is enabled, atomic_t variables
cannot be overflowed.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>
---
 fs/exec.c                 | 2 +-
 fs/fs_struct.c            | 8 ++++----
 fs/namespace.c            | 2 +-
 fs/proc/task_nommu.c      | 2 +-
 include/linux/fs_struct.h | 2 +-
 kernel/fork.c             | 6 +++---
 kernel/user_namespace.c   | 2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4e497b9..ad79491 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1429,7 +1429,7 @@ static void check_unsafe_exec(struct linux_binprm *bprm)
 	}
 	rcu_read_unlock();
 
-	if (p->fs->users > n_fs)
+	if (atomic_read(&p->fs->users) > n_fs)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
 	else
 		p->fs->in_exec = 1;
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 7dca743..697c96e 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -99,7 +99,7 @@ void exit_fs(struct task_struct *tsk)
 		task_lock(tsk);
 		spin_lock(&fs->lock);
 		tsk->fs = NULL;
-		kill = !--fs->users;
+		kill = !atomic_dec_return(&fs->users);
 		spin_unlock(&fs->lock);
 		task_unlock(tsk);
 		if (kill)
@@ -112,7 +112,7 @@ struct fs_struct *copy_fs_struct(struct fs_struct *old)
 	struct fs_struct *fs = kmem_cache_alloc(fs_cachep, GFP_KERNEL);
 	/* We don't need to lock fs - think why ;-) */
 	if (fs) {
-		fs->users = 1;
+		atomic_set(&fs->users, 1);
 		fs->in_exec = 0;
 		spin_lock_init(&fs->lock);
 		seqcount_init(&fs->seq);
@@ -139,7 +139,7 @@ int unshare_fs_struct(void)
 
 	task_lock(current);
 	spin_lock(&fs->lock);
-	kill = !--fs->users;
+	kill = !atomic_dec_return(&fs->users);
 	current->fs = new_fs;
 	spin_unlock(&fs->lock);
 	task_unlock(current);
@@ -159,7 +159,7 @@ EXPORT_SYMBOL(current_umask);
 
 /* to be mentioned only in INIT_TASK */
 struct fs_struct init_fs = {
-	.users		= 1,
+	.users		= ATOMIC_INIT(1),
 	.lock		= __SPIN_LOCK_UNLOCKED(init_fs.lock),
 	.seq		= SEQCNT_ZERO(init_fs.seq),
 	.umask		= 0022,
diff --git a/fs/namespace.c b/fs/namespace.c
index 5d205f9..66a0b99 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3394,7 +3394,7 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (fs->users != 1)
+	if (atomic_read(&fs->users) != 1)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 3717562..b318930 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -51,7 +51,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 	else
 		bytes += kobjsize(mm);
 	
-	if (current->fs && current->fs->users > 1)
+	if (current->fs && atomic_read(&current->fs->users) > 1)
 		sbytes += kobjsize(current->fs);
 	else
 		bytes += kobjsize(current->fs);
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 0efc3e6..e0e1e5f 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -6,7 +6,7 @@
 #include <linux/seqlock.h>
 
 struct fs_struct {
-	int users;
+	atomic_t users;
 	spinlock_t lock;
 	seqcount_t seq;
 	int umask;
diff --git a/kernel/fork.c b/kernel/fork.c
index 623259f..f06f356 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1203,7 +1203,7 @@ static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 			spin_unlock(&fs->lock);
 			return -EAGAIN;
 		}
-		fs->users++;
+		atomic_inc(&fs->users);
 		spin_unlock(&fs->lock);
 		return 0;
 	}
@@ -2129,7 +2129,7 @@ static int unshare_fs(unsigned long unshare_flags, struct fs_struct **new_fsp)
 		return 0;
 
 	/* don't need lock here; in the worst case we'll do useless copy */
-	if (fs->users == 1)
+	if (atomic_read(&fs->users) == 1)
 		return 0;
 
 	*new_fsp = copy_fs_struct(fs);
@@ -2242,7 +2242,7 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 			fs = current->fs;
 			spin_lock(&fs->lock);
 			current->fs = new_fs;
-			if (--fs->users)
+			if (atomic_dec_return(&fs->users))
 				new_fs = NULL;
 			else
 				new_fs = fs;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 86b7854..8fbc98b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1034,7 +1034,7 @@ static int userns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	if (!thread_group_empty(current))
 		return -EINVAL;
 
-	if (current->fs->users != 1)
+	if (atomic_read(&current->fs->users) != 1)
 		return -EINVAL;
 
 	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
-- 
2.7.4
