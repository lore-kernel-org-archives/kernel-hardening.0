Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 2 Oct 2013 15:55:06 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131002145506.GA2669@dztty>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
 <524B78A2.40007@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B78A2.40007@amacapital.net>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com, tixxdz@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 01, 2013 at 06:36:34PM -0700, Andy Lutomirski wrote:
> On 10/01/2013 01:26 PM, Djalal Harouni wrote:
> > Since /proc entries varies at runtime, permission checks need to happen
> > during each system call.
> > 
> > However even with that /proc file descriptors can be passed to a more
> > privileged process (e.g. a suid-exec) which will pass the classic
> > ptrace_may_access() permission check. The open() call will be issued in
> > general by an unprivileged process while the disclosure of sensitive
> > /proc information will happen using a more privileged process at
> > read(),write()...
> > 
> > Therfore we need a more sophisticated check to detect if the cred of the
> > process have changed, and if the cred of the original opener that are
> > stored in the file->f_cred have enough permission to access the task's
> > /proc entries during read(), write()...
> > 
> > Add the proc_allow_access() function that will receive the file->f_cred
> > as an argument, and tries to check if the opener had enough permission
> > to access the task's /proc entries.
> > 
> > This function should be used with the ptrace_may_access() check.
> > 
> > Cc: Kees Cook <keescook@chromium.org>
> > Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> > ---
> >  fs/proc/base.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/proc/internal.h |  2 ++
> >  2 files changed, 58 insertions(+)
> > 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index e834946..c29eeae 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -168,6 +168,62 @@ int proc_same_open_cred(const struct cred *fcred)
> >  		cap_issubset(cred->cap_permitted, fcred->cap_permitted));
> >  }
> >  
> > +/* Returns 0 on success, -errno on denial. */
> > +static int __proc_allow_access(const struct cred *cred,
> > +			       struct task_struct *task, unsigned int mode)
> > +{
> > +	int ret = 0;
> > +	const struct cred *tcred;
> > +	const struct cred *fcred = cred;
> > +
> > +	rcu_read_lock();
> > +	tcred = __task_cred(task);
> > +	if (uid_eq(fcred->uid, tcred->euid) &&
> > +	    uid_eq(fcred->uid, tcred->suid) &&
> > +	    uid_eq(fcred->uid, tcred->uid)  &&
> > +	    gid_eq(fcred->gid, tcred->egid) &&
> > +	    gid_eq(fcred->gid, tcred->sgid) &&
> > +	    gid_eq(fcred->gid, tcred->gid))
> > +		goto out;
> > +
> 
> What's this for?  Is it supposed to be an optimization?  If so, it looks
> potentially exploitable, although I don't really understand what you're
> trying to do.
This function should be used in addition to the ptrace_may_access() one.

This will help to check if the original process that opened a
/proc/pid/* file is able to read(),write() to it.

As we have said, the file descriptor can be passed to a more privileged
process to pass the ptrace_may_access(). If we detect that current's
cred have changed between ->open() (unprivileged) and ->read()
(privileged, exec a suid-exec), then we call this helper function to
check the file's opener cred against the target task during this
->read(),->write()...

This should block vulnerabilities like the /proc/pid/mem
http://lwn.net/Articles/476947/

Since current will not have the same privileges of the process that
opened the file (cred have changed).


So:
This is not an optimization!

Can you elaborate more on the potentially exploitable please ?


It has the same logic of ptrace_may_access(). Didn't want to modifiy
ptrace_may_access() since it relies on current and its context and if we
do, we'll have to touch the capability checks also. So just add this one
here and call it only if current's cred change.


> --Andy

-- 
Djalal Harouni
http://opendz.org
