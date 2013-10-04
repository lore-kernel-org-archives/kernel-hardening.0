Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 4 Oct 2013 19:23:53 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131004182353.GA2600@dztty>
References: <20131002145506.GA2669@dztty>
 <CALCETrW=6nnU0uQBqbFyJY8Fj+CHoGbOnGJ-aOB+3GwtV0f1bw@mail.gmail.com>
 <20131003143653.GA32445@dztty>
 <CALCETrU_D7X+jPWseiyp3FJJnw5CHhLbGz73FVDaeBpRDA+-og@mail.gmail.com>
 <20131003192926.GB2390@dztty>
 <CALCETrVDqBAcdJDFihzTZ23SJBmP5jmHfqqXyTqre38t8xn7Tg@mail.gmail.com>
 <20131003201332.GA3500@dztty>
 <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
 <20131004085911.GA2157@dztty>
 <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 04, 2013 at 04:40:01PM +0100, Andy Lutomirski wrote:
> On Fri, Oct 4, 2013 at 9:59 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Thu, Oct 03, 2013 at 02:09:55PM -0700, Andy Lutomirski wrote:
> >> On Thu, Oct 3, 2013 at 1:13 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > On Thu, Oct 03, 2013 at 12:37:49PM -0700, Andy Lutomirski wrote:
> >> >> On Thu, Oct 3, 2013 at 12:29 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > The current patches block and protect the current attacks correctly,
> > without overhead.
> >
> > Example:
> > proc_uid_map_write()
> >  -> map_write()
> >    -> file_ns_capable()
> >       -> security_capable(file->f_cred, ns, cap)
> >
> > file_ns_capable() added in commit 935d8aabd4331 by Linus
> > Add file_ns_capable() helper function for open-time capability checking
> >
> > That also goes for commit 6708075f104c3c9b0 by Eric,
> > userns: Don't let unprivileged users trick privileged users into setting
> > the id_map
> >
> > The proc_allow_access() function that I've proposed has the same logic
> > of file_ns_capable(), We can even put file_ns_capable() inside
> > proc_allow_access(). We'll add support of security_capable_noaudit()
> > inside file_ns_capable() and proc_allow_access() will be much more
> > better.
> >
> > file_ns_capable() checks where a capability was there,
> > proc_allow_access() checks where they have same uid + if capability was
> > there.
> >
> >> please either fix it, stop using f_cred, or explain why it it's okay
> >> despite not invoking LSM in the expected way.
> > I've already explained it.
> >
> > LSM is handled by ptrace_may_access() which should be called during
> > ->open() to handle f_cred, and during ->read() to handle current's cred.
> 
> This is getting tiresome.  This patch (2/9) has my NAK.  The other
> patches depend on it, so I will not ack them.  (The maintainers may or
> may not care about my NAK -- that's their business.)
Yeh tiresome, especially for fixing some leaks that affect the kernel
and ASLR for a long time now...

Ok response below:

> Your code is *wrong* for even the simple case of /proc/*/syscall.  Consider:
> 
> Start with two processes, a and b, both normal tasks started by an
> unprivileged user.  Process a opens /proc/<b's pid>/syscall.  All
> checks pass.  Process b execs a setcap'd binary.  So b's uid and gid
> do not change.
> 
> Then process a redirects stdin to that existing /proc/<b's pid>/stack
You mean /proc/<b's pid>/syscall, ok let see

> fd.  Here's the bug in your patch: process a can *still* read that fd.
>  Why?  Because *you're not checking that a's capabilities are a
> superset of b's*.  That code lives in the LSM infrastructure.  You
Please see with me:

I've made it clear that proc_allow_access() should be used after
ptrace_may_access() and documented it!

The reader process a  will have a ptrace_may_access() check against the
target process b (the setcap'd binary) during that ->read()

->read()
  -> syscall_read()
    -> lock_trace()
      -> ptrace_may_access()
        -> security_ptrace_access_check()

So the scenario you describe here is perfectly handled.


But your point on the *capabilities superset* is correct, YES.

What if a, the reader who execve a setcap'd binary. I admit there is a
window here :-)


Please see:

I did the check in the proc_same_open_cred() function:
 return (uid_eq(fcred->uid, cred->uid) &&
	 gid_eq(fcred->gid, cred->gid) &&
	 cap_issubset(cred->cap_permitted, fcred->cap_permitted));

Check if this is the same uid/gid and the capabilities superset!

But in the proc_allow_access() the capabilities superset is missing.


So to fix it:
1) if proc_same_open_cred() detects that cred have changed between
->open() and ->read() then abort, return zero, the ->read(),write()...


2) Improve the proc_allow_access() check by:
   if this is the same user namespace then check uid/gid of f_cred on
   target cred task, and the capabilities superset:
   cap_issubset(tcred->cap_permitted, fcred->cap_permitted));
   
   If it fails let security_capable() or file_ns_capable() do its magic.



The capabilities superset check are available, they are not LSM
specific.

> need to call it if you want to keep the general approach you're
> trying.  You can't fix this just by checking for CAP_PTRACE, because
> then you'll break SELinux.
IIUC, then SELinux is already broken!

You do you realize that these patches are adding a bench of
ptrace_may_access() during ->open() to give LSM a chance to inspect
f_cred and other things.


> This is messy, and it's why I think that you'd be better off doing
> this by revoking the fd on exec instead.
As I've said I'm not against revoke. If it was there I would use it!

Not implemented! and perhaps it will be complex...


Please respond, and perhaps you should reconsider your NAK! since you
were involved in the patches that were committed, and used the
file->f_cred approach

Thanks

> --Andy

-- 
Djalal Harouni
http://opendz.org
