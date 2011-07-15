Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Jul 2011 17:06:50 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110715170650.585f1dad@notabene.brown>
In-Reply-To: <20110715063113.GA3166@albatros>
References: <20110712132723.GA3193@albatros>
	<CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
	<20110713091408.0d456352@notabene.brown>
	<20110713063142.GA19976@openwall.com>
	<20110713170657.59dae548@notabene.brown>
	<CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
	<alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
	<20110714112751.1bfd998f@notabene.brown>
	<20110714150602.GA30019@openwall.com>
	<20110715133013.4fa38d19@notabene.brown>
	<20110715063113.GA3166@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 15 Jul 2011 10:31:13 +0400 Vasiliy Kulikov <segoon@openwall.com>
wrote:

> Neil,
>=20
> On Fri, Jul 15, 2011 at 13:30 +1000, NeilBrown wrote:
> > I'm still bothers that the proposed patch can cause exec to fail for an
> > separate 'innocent' process.
> > It also seems to 'hide' the problem - just shuffling code around.
> > The comment in do_execve_common helps.  A similar comment in set_user
> > wouldn't hurt.
> >=20
> > But what do you think of this.  It sure that only the process which ign=
ored
> > the return value from setuid is inconvenienced.
>=20
> I don't like it.  You're mixing the main problem and an RLIMIT check
> enforcement.  The main goal is denying setuid() to fail unless there is n=
ot
> enough privileges, RLIMIT in execve() is just an *attempt* to still count
> NPROC in *some* widespread cases.  But you're trying to fix setuid()
> where RLIMIT accounting is simple :\
>=20
> Your patch doesn't address the core issue in this situation:
>=20
>     setuid(); /* it fails because of RLIMIT */
>     do_some_fs();
>     execve();
>=20
> do_some_fs() should be called ONLY if root is dropped.  In your scheme
> the process may interact with FS as root while thinking it is nonroot,
> which almost always leads to privilege escalation.
>=20
> Thanks,
>=20

How about this then?

=46rom 4a1411d10c90510a4eedf94bfd6b2578425271ba Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 15 Jul 2011 13:20:09 +1000
Subject: [PATCH] Protect execve from being used after 'setuid' exceeds RLIM=
IT_NPROC

Many programs to not check setuid for failure so it is not safe
for it to fail.  So impose the RLIMIT_NPROC limit by noting the
excess in set_user with a process flag, and failing exec() if the
flag is set.

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
index 6075a1e..dfe9c61 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1434,6 +1434,17 @@ static int do_execve_common(const char *filename,
 	bool clear_in_exec;
 	int retval;
=20
+	if (current->flags & PF_NPROC_EXCEEDED) {
+		/* setuid noticed that RLIMIT_NPROC was
+		 * exceeded, but didn't fail as that easily
+		 * leads to privileges leaking.  So fail
+		 * here instead - we still limit the number of
+		 * processes running the user's code.
+		 */
+		retval =3D -EAGAIN;
+		goto out_ret;
+	}
+
 	retval =3D unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..f024c63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1759,6 +1759,7 @@ extern void thread_group_times(struct task_struct *p,=
 cputime_t *ut, cputime_t *
 #define PF_DUMPCORE	0x00000200	/* dumped core */
 #define PF_SIGNALED	0x00000400	/* killed by a signal */
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
+#define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC=
 was exceeded */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized be=
fore use */
 #define PF_FREEZING	0x00004000	/* freeze in progress. do not account to lo=
ad */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
diff --git a/kernel/cred.c b/kernel/cred.c
index 174fa84..8ef31f5 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -508,10 +508,8 @@ int commit_creds(struct cred *new)
 		key_fsgid_changed(task);
=20
 	/* do it
-	 * - What if a process setreuid()'s and this brings the
-	 *   new uid over his NPROC rlimit?  We can check this now
-	 *   cheaply with the new uid cache, so if it matters
-	 *   we should be checking for it.  -DaveM
+	 * RLIMIT_NPROC limits on user->processes have already been checked
+	 * in set_user().
 	 */
 	alter_cred_subscribers(new, 2);
 	if (new->user !=3D old->user)
diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..dd1fb9d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -592,10 +592,9 @@ static int set_user(struct cred *new)
 		return -EAGAIN;
=20
 	if (atomic_read(&new_user->processes) >=3D rlimit(RLIMIT_NPROC) &&
-			new_user !=3D INIT_USER) {
-		free_uid(new_user);
-		return -EAGAIN;
-	}
+			new_user !=3D INIT_USER)
+		/* Cause any subsequent 'exec' to fail */
+		current->flags |=3D PF_NPROC_EXCEEDED;
=20
 	free_uid(new->user);
 	new->user =3D new_user;
