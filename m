Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 26 Jul 2011 18:48:48 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110726144848.GA7133@albatros>
References: <1310759683.30257.123.camel@moss-pluto>
 <20110721140936.632d2c8b@notabene.brown>
 <20110721124830.GA1325@openwall.com>
 <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
 <20110721193939.GA3914@openwall.com>
 <20110725171423.GA3739@albatros>
 <20110725234013.GB24110@openwall.com>
 <20110726104713.37273143@notabene.brown>
 <20110726011629.GA24610@openwall.com>
 <20110726141118.32f948e0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726141118.32f948e0@notabene.brown>
Subject: [kernel-hardening] [patch v2] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: kernel-hardening@lists.openwall.com
Cc: Solar Designer <solar@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Neil, Solar,

On Tue, Jul 26, 2011 at 14:11 +1000, NeilBrown wrote:
> I don't really see that failing mmap is any more hackish than failing execve.
> 
> Both are certainly hacks.  It is setuid that should fail, but that is
> problematic.
> 
> We seem to agree that it is acceptable to delay the failure until the process
> actually tries to run some code for the user.  I just think that
> mapping-a-file-for-exec is a more direct measure of "trying to run some code
> for the user" than "execve" is.
> 
> So they are both hacks, but one it more thorough than the other.  In the
> world of security I would hope that "thorough" would win.

Well, I don't mind against something more generic than the check in
execve(), however, the usefulness of the check in mmap() is unclear to
me.  You want to make more programs fail after setuid(), but does mmap
stops really many programs?  Do you know any program doing mmap/dlopen
after setuid() call?  What if the program will not do any mmap/dlopen
and e.g. start to handle network connections or do some computations?
I suppose the latter case is much more often than mmap/dlopen.

(Also, reading significant amount of data could be gained via read()
without any mmap.)

More generic place is all resource allocation syscalls, but it start to
be too complex for this sort of things IMO.


Meanwhile, the patch with the cleared PF on successful fork/exec is as
follows:

-------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: [patch v2] move RLIMIT_NPROC check from set_user() to do_execve_common()

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
under the limit, the defered execve() failure because NPROC limit was
exceeded days ago would be unexpected.  If the limit is not exceeded
anymore, we clear the flag on both execve() and fork().

Similar check was introduced in -ow patches (without the process flag).

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/exec.c             |   17 +++++++++++++++++
 include/linux/sched.h |    1 +
 kernel/cred.c         |    7 +++----
 kernel/fork.c         |    2 +-
 kernel/sys.c          |   13 +++++++++----
 5 files changed, 31 insertions(+), 9 deletions(-)

---
diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..e8b7c1a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1433,6 +1433,23 @@ static int do_execve_common(const char *filename,
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
+
+	/* If we steep below the limit, we don't want to make following
+	 * execve() fail. */
+	current->flags &= ~PF_NPROC_EXCEEDED;
 
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..0f44484 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -995,7 +995,7 @@ static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER | PF_NPROC_EXCEEDED);
 	new_flags |= PF_FORKNOEXEC;
 	new_flags |= PF_STARTING;
 	p->flags = new_flags;
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
+	 * for programs doing set*uid()+execve() by harmlessly defering the
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
---
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
