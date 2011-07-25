Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 25 Jul 2011 21:14:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110725171423.GA3739@albatros>
References: <20110715063113.GA3166@albatros>
 <20110715170650.585f1dad@notabene.brown>
 <20110715073823.GA3821@albatros>
 <1310738313.30257.27.camel@moss-pluto>
 <20110715152641.GA6286@albatros>
 <1310759683.30257.123.camel@moss-pluto>
 <20110721140936.632d2c8b@notabene.brown>
 <20110721124830.GA1325@openwall.com>
 <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
 <20110721193939.GA3914@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721193939.GA3914@openwall.com>
Subject: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

The patch http://lkml.org/lkml/2003/7/13/226 introduced an RLIMIT_NPROC
check in set_user() to check for NPROC exceeding via setuid() and
similar functions.  Before the check there was a possibility to greatly
exceed the allowed number of processes by an unprivileged user if the
program relied on rlimit only.  But the check created new security
threat: many poorly written programs simply don't check setuid() return
code and believe it cannot fail if executed with root privileges.  So,
the check is removed in this patch because of too often privilege
escalations related to buggy programs.

The NPROC can still be enforced in the common code flow of daemons
spawning user processes.  Most of daemons do fork()+setuid()+execve().
The check introduced in execve() (1) enforces the same limit as in
setuid() and (2) doesn't create similar security issues.

Neil Brown suggested to track what specific process has exceeded the
limit by setting PF_NPROC_EXCEEDED process flag.  With the change only
this process would fail on execve(), and other processes' execve()
behaviour is not changed.

Solar Designer suggested to re-check whether NPROC limit is still
exceeded at the moment of execve().  If the process was sleeping for
days between set*uid() and execve(), and the NPROC counter step down
under the limit, the deferred execve() failure because NPROC limit was
exceeded days ago would be unexpected.

Similar check was introduced in -ow patches (without the process flag).

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/exec.c             |   13 +++++++++++++
 include/linux/sched.h |    1 +
 kernel/cred.c         |    7 +++----
 kernel/sys.c          |   13 +++++++++----
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..706a213 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1433,6 +1433,19 @@ static int do_execve_common(const char *filename,
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
+	const struct cred *cred = current_cred();
+
+	/*
+	 * We move the actual failure in case of RLIMIT_NPROC excess from
+	 * set*uid() to execve() because too many poorly written programs
+	 * don't check setuid() return code.  Here we additionally recheck
+	 * whether NPROC limit is still exceeded.
+	 */
+	if ((current->flags & PF_NPROC_EXCEEDED) &&
+	    atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC)) {
+		retval = -EAGAIN;
+		goto out_ret;
+	}
 
 	retval = unshare_files(&displaced);
 	if (retval)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..f024c63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1759,6 +1759,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
+#define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
 #define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
diff --git a/kernel/cred.c b/kernel/cred.c
index 174fa84..52f4342 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -508,11 +508,10 @@ int commit_creds(struct cred *new)
 		key_fsgid_changed(task);
 
 	/* do it
-	 * - What if a process setreuid()'s and this brings the
-	 *   new uid over his NPROC rlimit?  We can check this now
-	 *   cheaply with the new uid cache, so if it matters
-	 *   we should be checking for it.  -DaveM
+	 * RLIMIT_NPROC limits on user->processes have already been checked
+	 * in set_user().
 	 */
+
 	alter_cred_subscribers(new, 2);
 	if (new->user != old->user)
 		atomic_inc(&new->user->processes);
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..fc40cbc 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -591,11 +591,16 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
+	/*
+	 * We don't fail in case of NPROC limit excess here because too many
+	 * poorly written programs don't check set*uid() return code, assuming
+	 * it never fails if called by root.  We may still enforce NPROC limit
+	 * for programs doing set*uid()+execve() by harmlessly deferring the
+	 * failure to the execve() stage.
+	 */
 	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
-			new_user != INIT_USER) {
-		free_uid(new_user);
-		return -EAGAIN;
-	}
+			new_user != INIT_USER)
+		current->flags |= PF_NPROC_EXCEEDED;
 
 	free_uid(new->user);
 	new->user = new_user;
-- 
1.7.0.4
