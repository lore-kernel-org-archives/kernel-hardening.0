Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 12 Sep 2013 02:23:15 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130912012315.GB2748@dztty>
References: <20130826172054.GE27005@ZenIV.linux.org.uk>
 <20130827172406.GA2664@dztty>
 <20130828201141.GA21455@dztty>
 <CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
 <20130828211116.GA22184@dztty>
 <87sixt735b.fsf@xmission.com>
 <20130829091127.GA2635@dztty>
 <CAGXu5jJtiji1KPPLSr5SXKXGwBbb8McWZY3DqCZFWXKtP=KEzA@mail.gmail.com>
 <20130831202637.GA6013@dztty>
 <877gf1pb7c.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gf1pb7c.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Eric,

(Sorry for the delay, please see below)

On Sat, Aug 31, 2013 at 06:44:39PM -0700, Eric W. Biederman wrote:
> Djalal Harouni <tixxdz@opendz.org> writes:
[...] 
> > Yes Kees,
> >
> > I did try a year ago to adapt the exec_id from grsecurity and failed
> > (and failed again to resend - not enough resources):
> > https://lkml.org/lkml/2012/3/10/174
> >
> >
> > Kees IMHO the right solution is to invalidate the fd across exec as
> > you suggest
> >
> > Alan Cox's thread which describe the problem correctly:
> > https://lkml.org/lkml/2012/1/29/35
> >
> > Alan suggested to revoke() the file handles.
> 
> That was in particular with respect to /dev/mem.
> 
> In the general case calling setuid or any of it's cousins can cause the
> same problem.  So a revoke that only works at exec time is insufficient.
Well, in that particular case the flaw is in the programs that don't
handle setuid and its cousins correctly. IMHO this is a different case,
our concerns here are external suid-exec programs.

A sort of revoke or file handle invalidating on exec is already used as
the close-on-exec flag.


> 
> The problem we are examining is what happens when the file descriptor is
> passed to a more privileged process that will pass the ptrace_may_access
> check while the original process that opened the file did not.
> 
> We have file->f_cred that has the permissions of the process at open
> time, and likely that should factor into the calculations somehow.
Ok, thanks

> Alternatively we may simply be able to call get_task_cred() at the time
> we open the file and if the cred on the process changes fail.  I know
> Linus was looking at something like that recently, but ran into problmes
> with Chromes sandbox. (Sigh).  Although I think he was talking about
> file->f_cred...
Ok, can you provide a link please? thanks


> This is most definitely a solvable problem with current mechanisms, but
> it is going to take some grunt work to make it happen.
Please see below for a small PoC to test what you suggest Eric

So we embed a f_cred inside a seq_file struct and set it at seq_open()
We can also remove that 'user_ns' that is embedded in seq_file sruct
since we'll have it inside the f_cred! 


I've added a proc_may_access() function that will check the f_cred of
the opener against the target at read time, I've done this for:
1) the reader at open time may have enough permissions
2) reader does a suid-exec or change its ruid/euid
3) suid-exec or same reader with new privileged creds reads data

This is a legitimate scenario which I didn't want to block, so the fd
still can be passed but you will be able to read from it only if you
pass a) the classic ptrace check b) the check of f_cred against the
target.

IMO it's better than: check only if the cred of the process changes.


Since this is just a PoC for /proc/*/stack, I'll do more test, improve
it and send it as a series, thanks!

Any comment is welcome



diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..025a53e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -139,6 +139,54 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = show } )
 
+/* Returns 0 on success, -errno on denial. */
+static int __proc_may_access(struct task_struct *task,
+			     const struct cred *fcred, unsigned int mode)
+{
+	int ret = 0;
+	const struct cred *tcred;
+
+	rcu_read_lock();
+	tcred = __task_cred(task);
+	if (uid_eq(fcred->uid, tcred->euid) &&
+	    uid_eq(fcred->uid, tcred->suid) &&
+	    uid_eq(fcred->uid, tcred->uid)  &&
+	    gid_eq(fcred->gid, tcred->egid) &&
+	    gid_eq(fcred->gid, tcred->sgid) &&
+	    gid_eq(fcred->gid, tcred->gid))
+		goto out;
+
+	if (mode & PTRACE_MODE_NOAUDIT)
+		ret = security_capable_noaudit(fcred, tcred->user_ns,
+					       CAP_SYS_PTRACE);
+	else
+		ret = security_capable(fcred, tcred->user_ns,
+				       CAP_SYS_PTRACE);
+
+	if (ret)
+		ret = -EPERM;
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
+/**
+ * proc_may_access - Check if the file's opener had enough permissions
+ * to access the target process.
+ *
+ * Callers must hold the task->signal->cred_guard_mutex
+ */
+int proc_may_access(struct task_struct *task,
+		    const struct cred *fcred, unsigned int mode)
+{
+	int ret;
+	task_lock(task);
+	ret = __proc_may_access(task, fcred, mode);
+	task_unlock(task);
+	return !ret;
+}
+
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
@@ -306,6 +354,7 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long *entries;
 	int err;
 	int i;
+	const struct cred *fcred = m->f_cred;
 
 	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
 	if (!entries)
@@ -317,17 +366,24 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	trace.skip		= 0;
 
 	err = lock_trace(task);
-	if (!err) {
-		save_stack_trace_tsk(task, &trace);
+	if (err)
+		goto free;
 
-		for (i = 0; i < trace.nr_entries; i++) {
-			seq_printf(m, "[<%pK>] %pS\n",
-				   (void *)entries[i], (void *)entries[i]);
-		}
-		unlock_trace(task);
+	err = 0;
+	if (!proc_may_access(task, fcred, PTRACE_MODE_ATTACH))
+		goto unlock;
+
+	save_stack_trace_tsk(task, &trace);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%pK>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
 	}
-	kfree(entries);
 
+unlock:
+	unlock_trace(task);
+free:
+	kfree(entries);
 	return err;
 }
 #endif
@@ -689,6 +745,22 @@ static int proc_single_show(struct seq_file *m, void *v)
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
+	struct task_struct *task = get_proc_task(file_inode(filp));
+	struct mm_struct *mm;
+
+	if (!task)
+		return -ESRCH;
+
+	mm = mm_access(task, PTRACE_MODE_ATTACH);
+	put_task_struct(task);
+
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+
+	/* do not pin mm */
+	if (mm)
+		mmput(mm);
+
 	return single_open(filp, proc_single_show, inode);
 }
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 651d09a..304ac5f 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -159,6 +159,8 @@ extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
 /*
  * base.c
  */
+extern int proc_may_access(struct task_struct *,
+			   const struct cred *, unsigned int mode);
 extern const struct dentry_operations pid_dentry_operations;
 extern int pid_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int proc_setattr(struct dentry *, struct iattr *);
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..a5e5b98 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -57,6 +57,7 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	memset(p, 0, sizeof(*p));
 	mutex_init(&p->lock);
 	p->op = op;
+	p->f_cred = file->f_cred;
 #ifdef CONFIG_USER_NS
 	p->user_ns = file->f_cred->user_ns;
 #endif
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 4e32edc..aea27e9 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -26,6 +26,7 @@ struct seq_file {
 	struct mutex lock;
 	const struct seq_operations *op;
 	int poll_event;
+	const struct cred *f_cred;
 #ifdef CONFIG_USER_NS
 	struct user_namespace *user_ns;
 #endif


-- 
Djalal Harouni
http://opendz.org
