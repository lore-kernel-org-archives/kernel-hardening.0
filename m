Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20131003143653.GA32445@dztty>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
 <1380659178-28605-3-git-send-email-tixxdz@opendz.org> <524B78A2.40007@amacapital.net>
 <20131002145506.GA2669@dztty> <CALCETrW=6nnU0uQBqbFyJY8Fj+CHoGbOnGJ-aOB+3GwtV0f1bw@mail.gmail.com>
 <20131003143653.GA32445@dztty>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Oct 2013 16:12:37 +0100
Message-ID: <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 3, 2013 at 3:36 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Wed, Oct 02, 2013 at 05:44:17PM +0100, Andy Lutomirski wrote:
>> On Wed, Oct 2, 2013 at 3:55 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> > On Tue, Oct 01, 2013 at 06:36:34PM -0700, Andy Lutomirski wrote:
>> >> On 10/01/2013 01:26 PM, Djalal Harouni wrote:
>> >> > Since /proc entries varies at runtime, permission checks need to happen
>> >> > during each system call.
>> >> >
>> >> > However even with that /proc file descriptors can be passed to a more
>> >> > privileged process (e.g. a suid-exec) which will pass the classic
>> >> > ptrace_may_access() permission check. The open() call will be issued in
>> >> > general by an unprivileged process while the disclosure of sensitive
>> >> > /proc information will happen using a more privileged process at
>> >> > read(),write()...
>> >> >
>> >> > Therfore we need a more sophisticated check to detect if the cred of the
>> >> > process have changed, and if the cred of the original opener that are
>> >> > stored in the file->f_cred have enough permission to access the task's
>> >> > /proc entries during read(), write()...
>> >> >
>> >> > Add the proc_allow_access() function that will receive the file->f_cred
>> >> > as an argument, and tries to check if the opener had enough permission
>> >> > to access the task's /proc entries.
>> >> >
>> >> > This function should be used with the ptrace_may_access() check.
>> >> >
>> >> > Cc: Kees Cook <keescook@chromium.org>
>> >> > Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
>> >> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
>> >> > ---
>> >> >  fs/proc/base.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >> >  fs/proc/internal.h |  2 ++
>> >> >  2 files changed, 58 insertions(+)
>> >> >
>> >> > diff --git a/fs/proc/base.c b/fs/proc/base.c
>> >> > index e834946..c29eeae 100644
>> >> > --- a/fs/proc/base.c
>> >> > +++ b/fs/proc/base.c
>> >> > @@ -168,6 +168,62 @@ int proc_same_open_cred(const struct cred *fcred)
>> >> >             cap_issubset(cred->cap_permitted, fcred->cap_permitted));
>> >> >  }
>> >> >
>> >> > +/* Returns 0 on success, -errno on denial. */
>> >> > +static int __proc_allow_access(const struct cred *cred,
>> >> > +                          struct task_struct *task, unsigned int mode)
>> >> > +{
>> >> > +   int ret = 0;
>> >> > +   const struct cred *tcred;
>> >> > +   const struct cred *fcred = cred;
>> >> > +
>> >> > +   rcu_read_lock();
>> >> > +   tcred = __task_cred(task);
>> >> > +   if (uid_eq(fcred->uid, tcred->euid) &&
>> >> > +       uid_eq(fcred->uid, tcred->suid) &&
>> >> > +       uid_eq(fcred->uid, tcred->uid)  &&
>> >> > +       gid_eq(fcred->gid, tcred->egid) &&
>> >> > +       gid_eq(fcred->gid, tcred->sgid) &&
>> >> > +       gid_eq(fcred->gid, tcred->gid))
>> >> > +           goto out;
>> >> > +
>> >>
>> >> What's this for?  Is it supposed to be an optimization?  If so, it looks
>> >> potentially exploitable, although I don't really understand what you're
>> >> trying to do.
>> > This function should be used in addition to the ptrace_may_access() one.
>>
>> Sorry, I was unclear.  I meant: what are the uid and gid checks for?
> The uid/gid are checks of the current (reader) on the target task, like
> the ptrace checks. fcred here is the cred of current at open time.
>

This isn't a faithful copy of __ptrace_may_access -- the real function
gives LSMs a chance to veto ptracing.  That's critical even without
LSMs because cap_ptrace_access_check needs to get called.  (Think
about setcap'd programs instead of setuid programs.)

To fix this, I think you'll need to actually invoke
__ptrace_may_access.  That will be a mess because you don't have a
task_struct to pass in, so you'll have to refactor the code to
separately check for task==current and for cred-based permissions.
That, in turn, will mean that you need to get the LSMs to play along,
which includes Yama.  To fix that, you'll probably need to check
yama's task-based constraints at open time, which may be at least as
complicated as the revoke-based approach.

--Andy
