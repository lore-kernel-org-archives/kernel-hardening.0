Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Jul 2011 13:30:13 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110715133013.4fa38d19@notabene.brown>
In-Reply-To: <20110714150602.GA30019@openwall.com>
References: <20110707075610.GA3411@albatros>
	<20110707081930.GA4393@albatros>
	<20110712132723.GA3193@albatros>
	<CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
	<20110713091408.0d456352@notabene.brown>
	<20110713063142.GA19976@openwall.com>
	<20110713170657.59dae548@notabene.brown>
	<CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
	<alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
	<20110714112751.1bfd998f@notabene.brown>
	<20110714150602.GA30019@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Solar Designer <solar@openwall.com>
Cc: James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 14 Jul 2011 19:06:02 +0400 Solar Designer <solar@openwall.com> wrote:

> On Thu, Jul 14, 2011 at 11:27:51AM +1000, NeilBrown wrote:
> > I'm still trying to understand the full consequences, but I agree that there
> > is no rush - the code has been this way for quite a while and their is no
> > obvious threat that would expedite things (as far as I know).
> 
> I don't insist on getting this in sooner than in the next merge window,
> although I would have liked that.  Relevant userspace vulnerabilities
> are being found quite often - I'll include some examples below.
> 
> > However I'm not convinced that testing will help all that much - if there are
> > problems they will be is rare corner cases that testing is unlikely to find.
> 
> This makes sense.
> 
> > The only case where this change will improve safety is where:
> >  1/ a process has RLIMIT_NPROC set
> >  2/ the process is running with root privileges
> >  3/ the process calls setuid() and doesn't handle errors.
> 
> Yes, and this is a pretty common case.
> 
> > I think the only times that a root process would have RLIMIT_NPROC set are:
> >  1/ if it explicitly set up rlimits before calling setuid.  In this case
> >       we should be able to expect that the process checks setuid .. maybe
> >       this is naive(?)
> 
> RLIMIT_NPROC could be set by the parent process or by pam_limits.  The
> machine I am typing this on has:
> 
> *       hard    nproc   200
> 
> (as well as other limits) in /etc/security/limits.conf, so if this
> machine's kernel let setuid() fail on RLIMIT_NPROC, I would be taking
> extra risk of a security compromise by reducing the risk of system
> crashes from inadvertent excessive resource consumption by runaway
> processes - a tradeoff I'd rather avoid.
> 
> >  2/ if the process was setuid-root and inherited rlimits from before, and
> >       never re-set them.  In this case it is easy to imagine that a setuid()
> >       would not be checked.
> 
> Right.  (In practice, all kinds of programs tend to forget to check
> setuid() return value, though.)
> 
> Actually, for the problem to apply to setuid-root programs, they need to
> switch their real uid first (more fully become root), then try to switch
> to a user - but this is common.
> 
> Here are some examples for 2011-2010:
> 
> "... missing setuid() retval check in opielogin which leads to easy root
> compromise":
> 
> http://www.openwall.com/lists/oss-security/2011/06/22/6
> 
> "The /usr/lib/libgnomesu/gnomesu-pam-backend suid binary which belongs
> to the libgnomesu package is not checking setuid() return values.
> 
> As a result, two cooperating users, or users with access to guest,
> cgi or web accounts can run arbitrary commands as root very easily."
> 
> http://www.openwall.com/lists/oss-security/2011/05/30/2
> 
> pam_xauth (exploitable if pam_limits is also used):
> 
> http://www.openwall.com/lists/oss-security/2010/08/16/2
> 
> A collection of examples from 2006:
> 
> http://lists.openwall.net/linux-kernel/2006/08/20/156

This is useful background that I think would be good have int the changelog.

I'm still bothers that the proposed patch can cause exec to fail for an
separate 'innocent' process.
It also seems to 'hide' the problem - just shuffling code around.
The comment in do_execve_common helps.  A similar comment in set_user
wouldn't hurt.

But what do you think of this.  It sure that only the process which ignored
the return value from setuid is inconvenienced.
??

NeilBrown

commit e47554d38340d4c4c3eccf207de682fe6b29224e
Author: NeilBrown <neilb@suse.de>
Date:   Fri Jul 15 13:20:09 2011 +1000

    Protect execve from being used after 'setuid' has failed.
    
    Many programs do not check setuid for failure so when it fails they
    might continue to use elevated privileged without intending to.
    Of particular concern is a call to 'exec' as this is common after
    dropping privileges and allows the elevated privileges to be misused.
    
    The patch http://lkml.org/lkml/2003/7/13/226 introduced a RLIMIT_NPROC
    check in set_user() to check for NPROC exceeding via setuid() and
    similar functions.  Before the check there was a possibility to greatly
    exceed the allowed number of processes by an unprivileged user if the
    program relied on rlimit only.  But the check created new security
    threat: many poorly written programs simply don't check setuid() return
    code and believe it cannot fail if executed with root privileges.  So,
    when the check fails we set a process flag which causes execve to fail.
    
    Following examples of vulnerabilities due to processes not checking
    error from setuid provided by Solar Designer <solar@openwall.com>:
    
    Here are some examples for 2011-2010:
    
    "... missing setuid() retval check in opielogin which leads to easy root
    compromise":
    
    http://www.openwall.com/lists/oss-security/2011/06/22/6
    
    "The /usr/lib/libgnomesu/gnomesu-pam-backend suid binary which belongs
    to the libgnomesu package is not checking setuid() return values.
    
    As a result, two cooperating users, or users with access to guest,
    cgi or web accounts can run arbitrary commands as root very easily."
    
    http://www.openwall.com/lists/oss-security/2011/05/30/2
    
    pam_xauth (exploitable if pam_limits is also used):
    
    http://www.openwall.com/lists/oss-security/2010/08/16/2
    
    A collection of examples from 2006:
    
    http://lists.openwall.net/linux-kernel/2006/08/20/156
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..c282ebb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1434,6 +1434,16 @@ static int do_execve_common(const char *filename,
 	bool clear_in_exec;
 	int retval;
 
+	if (current->flags & PF_SETUSER_FAILED) {
+		/* setuid failed and program is trying to 
+		 * 'exec' anyway (rather than e.g. clean up and
+		 * exit), so fail rather than allow a possible
+		 * security breach
+		 */
+		retval = -EAGAIN;
+		goto out_ret;
+	}
+
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..6b13923 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1759,6 +1759,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
+#define PF_SETUSER_FAILED 0x00001000	/* set_user failed so privs should not be used */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
 #define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
diff --git a/kernel/cred.c b/kernel/cred.c
index 174fa84..05c46fc 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -508,10 +508,8 @@ int commit_creds(struct cred *new)
 		key_fsgid_changed(task);
 
 	/* do it
-	 * - What if a process setreuid()'s and this brings the
-	 *   new uid over his NPROC rlimit?  We can check this now
-	 *   cheaply with the new uid cache, so if it matters
-	 *   we should be checking for it.  -DaveM
+	 * RLIMIT_NPROC limits on user->processes have already been imposed
+	 * in set_user().
 	 */
 	alter_cred_subscribers(new, 2);
 	if (new->user != old->user)
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..9b8f03f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -588,6 +588,8 @@ static int set_user(struct cred *new)
 	struct user_struct *new_user;
 
 	new_user = alloc_uid(current_user_ns(), new->uid);
+	current->flags |= PF_SETUSER_FAILED;
+
 	if (!new_user)
 		return -EAGAIN;
 
@@ -596,6 +598,7 @@ static int set_user(struct cred *new)
 		free_uid(new_user);
 		return -EAGAIN;
 	}
+	current->flags &= ~PF_SETUSER_FAILED;
 
 	free_uid(new->user);
 	new->user = new_user;
