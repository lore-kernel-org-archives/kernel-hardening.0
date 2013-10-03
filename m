Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 3 Oct 2013 20:29:26 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131003192926.GB2390@dztty>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
 <524B78A2.40007@amacapital.net>
 <20131002145506.GA2669@dztty>
 <CALCETrW=6nnU0uQBqbFyJY8Fj+CHoGbOnGJ-aOB+3GwtV0f1bw@mail.gmail.com>
 <20131003143653.GA32445@dztty>
 <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 03, 2013 at 04:12:37PM +0100, Andy Lutomirski wrote:
> On Thu, Oct 3, 2013 at 3:36 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Wed, Oct 02, 2013 at 05:44:17PM +0100, Andy Lutomirski wrote:
> >> On Wed, Oct 2, 2013 at 3:55 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > On Tue, Oct 01, 2013 at 06:36:34PM -0700, Andy Lutomirski wrote:
> >> >> On 10/01/2013 01:26 PM, Djalal Harouni wrote:
> >> >> > Since /proc entries varies at runtime, permission checks need to happen
> >> >> > during each system call.
> >> >> >
> >> >> > However even with that /proc file descriptors can be passed to a more
> >> >> > privileged process (e.g. a suid-exec) which will pass the classic
> >> >> > ptrace_may_access() permission check. The open() call will be issued in
> >> >> > general by an unprivileged process while the disclosure of sensitive
> >> >> > /proc information will happen using a more privileged process at
> >> >> > read(),write()...
> >> >> >
> >> >> > Therfore we need a more sophisticated check to detect if the cred of the
> >> >> > process have changed, and if the cred of the original opener that are
> >> >> > stored in the file->f_cred have enough permission to access the task's
> >> >> > /proc entries during read(), write()...
> >> >> >
> >> >> > Add the proc_allow_access() function that will receive the file->f_cred
> >> >> > as an argument, and tries to check if the opener had enough permission
> >> >> > to access the task's /proc entries.
> >> >> >
> >> >> > This function should be used with the ptrace_may_access() check.
> >> >> >
> >> >> > Cc: Kees Cook <keescook@chromium.org>
> >> >> > Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> >> >> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> >> >> > ---
> >> >> >  fs/proc/base.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >> >> >  fs/proc/internal.h |  2 ++
> >> >> >  2 files changed, 58 insertions(+)
> >> >> >
> >> >> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> >> >> > index e834946..c29eeae 100644
> >> >> > --- a/fs/proc/base.c
> >> >> > +++ b/fs/proc/base.c
> >> >> > @@ -168,6 +168,62 @@ int proc_same_open_cred(const struct cred *fcred)
> >> >> >             cap_issubset(cred->cap_permitted, fcred->cap_permitted));
> >> >> >  }
> >> >> >
> >> >> > +/* Returns 0 on success, -errno on denial. */
> >> >> > +static int __proc_allow_access(const struct cred *cred,
> >> >> > +                          struct task_struct *task, unsigned int mode)
> >> >> > +{
> >> >> > +   int ret = 0;
> >> >> > +   const struct cred *tcred;
> >> >> > +   const struct cred *fcred = cred;
> >> >> > +
> >> >> > +   rcu_read_lock();
> >> >> > +   tcred = __task_cred(task);
> >> >> > +   if (uid_eq(fcred->uid, tcred->euid) &&
> >> >> > +       uid_eq(fcred->uid, tcred->suid) &&
> >> >> > +       uid_eq(fcred->uid, tcred->uid)  &&
> >> >> > +       gid_eq(fcred->gid, tcred->egid) &&
> >> >> > +       gid_eq(fcred->gid, tcred->sgid) &&
> >> >> > +       gid_eq(fcred->gid, tcred->gid))
> >> >> > +           goto out;
> >> >> > +
> >> >>
> >> >> What's this for?  Is it supposed to be an optimization?  If so, it looks
> >> >> potentially exploitable, although I don't really understand what you're
> >> >> trying to do.
> >> > This function should be used in addition to the ptrace_may_access() one.
> >>
> >> Sorry, I was unclear.  I meant: what are the uid and gid checks for?
> > The uid/gid are checks of the current (reader) on the target task, like
> > the ptrace checks. fcred here is the cred of current at open time.
> >
> 
> This isn't a faithful copy of __ptrace_may_access -- the real function
> gives LSMs a chance to veto ptracing.  That's critical even without
> LSMs because cap_ptrace_access_check needs to get called.  (Think
> about setcap'd programs instead of setuid programs.)
Yes, I already did this, not only setuid, capabilities also are handled
See the whole patch, please!


Yes, and speaking about LSMs I've mentioned in my patches and doc, that
the proposed function proc_allow_access() should be used after
ptrace_may_access(). proc_allow_access() is not a replacement for
ptrace_may_access(), it should be used *after* it.

So cap_ptrace_access_check() is called, and before the file->f_cred
checks. The LSM veto is already there.

Don't forget that proc_allow_access() is not for ptracing, it's targeted
to the procfs entries! and who opened the file.



Finally take a look at what you say about: cap_ptrace_access_check()


it does:
1)
if (cred->user_ns == child_cred->user_ns &&
    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
	return 0

2)
if (ns_capable(child_cred->user_ns, CAP_SYS_PTRACE))
	return 0

    ns_capable() calls security_capable().



And take a look at what I did, Andy please:
[PATCH v2 1/9] procfs: add proc_same_open_cred() to check if the cred
have changed

proc_same_open_cred() returns 1 on success

1) for proc_same_open_cred()
   if (f_cred->user_ns != cred->user_ns)
        return 0

   return (uid_eq(fcred->uid, cred->uid) &&
                  gid_eq(fcred->gid, cred->gid) &&
                  cap_issubset(cred->cap_permitted, f_cred->cap_permitted));

So it handles the (1) of cap_ptrace_access_check()


If this previous proc_same_open_cred() returns 0 (cred have changed)

goto (2) [PATCH v2 2/9] procfs: add proc_allow_access() to check if
file's opener may access task

proc_allow_access() returns 1 on success


2) It does the uid/gid checks which is complete

   Later it does security_capable() check which will do:
   security_ops->capable(f_cred, ns, cap, SECURITY_CAP_AUDIT);

   Take the old f_cred of file opener and do the capability check
   during this moment, ->read(),->write()

   So LSM support, and if LSM is disabled then we have the cap_capable()
   which will go and check userns and capabilities.


Andy if you see that I've missed something please let me know


So Andy the solution is complete and I think ! can you please recheck

(I'll also recheck it).

> To fix this, I think you'll need to actually invoke
> __ptrace_may_access.  That will be a mess because you don't have a
> task_struct to pass in, so you'll have to refactor the code to
> separately check for task==current and for cred-based permissions.
> That, in turn, will mean that you need to get the LSMs to play along,
> which includes Yama.  To fix that, you'll probably need to check
> yama's task-based constraints at open time, which may be at least as
> complicated as the revoke-based approach.
As I've demonstrated above, no mess and it's not compilcated, very easy
to support :-)

Thanks Andy


> --Andy

-- 
Djalal Harouni
http://opendz.org
