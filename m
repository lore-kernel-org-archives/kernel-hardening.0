Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 5 Oct 2013 14:23:37 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131005132337.GA4095@dztty>
References: <20131004085911.GA2157@dztty>
 <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
 <20131004182353.GA2600@dztty>
 <CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
 <20131004191113.GA3916@dztty>
 <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
 <20131004192712.GA4334@dztty>
 <CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
 <20131004194142.GA4524@dztty>
 <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 04, 2013 at 03:17:08PM -0700, Andy Lutomirski wrote:
> On Fri, Oct 4, 2013 at 12:41 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Fri, Oct 04, 2013 at 12:32:09PM -0700, Andy Lutomirski wrote:
> >> On Fri, Oct 4, 2013 at 12:27 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > On Fri, Oct 04, 2013 at 12:16:26PM -0700, Andy Lutomirski wrote:
> >> >> On Fri, Oct 4, 2013 at 12:11 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> >> > On Fri, Oct 04, 2013 at 07:34:08PM +0100, Andy Lutomirski wrote:
> >> >> >> On Fri, Oct 4, 2013 at 7:23 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> >> >> > On Fri, Oct 04, 2013 at 04:40:01PM +0100, Andy Lutomirski wrote:
> >> >> >> >> On Fri, Oct 4, 2013 at 9:59 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> >> >> >> > On Thu, Oct 03, 2013 at 02:09:55PM -0700, Andy Lutomirski wrote:
> >> >> > [...]
> >> >> >> Sorry, I described the obviously broken scenario incorrectly.  Your
> >> >> >> patch breaks (in the absence of things like selinux) if a exec
> >> >> >> something setuid root.
> >> >> >>
> >> >> >> [...]
> >> >> >>
> >> >> >> >
> >> >> >> > I did the check in the proc_same_open_cred() function:
> >> >> >> >  return (uid_eq(fcred->uid, cred->uid) &&
> >> >> >> >          gid_eq(fcred->gid, cred->gid) &&
> >> >> >> >          cap_issubset(cred->cap_permitted, fcred->cap_permitted));
> >> >> >>
> >> >> >> Which has nothing to do with anything.  If that check fails, you're
> >> >> >> just going on to a different, WRONG check/.
> >> >> >>
> >> >> >> >
> >> >> >> > Check if this is the same uid/gid and the capabilities superset!
> >> >> >> >
> >> >> >> > But in the proc_allow_access() the capabilities superset is missing.
> >> >> >> >
> >> >> >> >
> >> >> >> > So to fix it:
> >> >> >> > 1) if proc_same_open_cred() detects that cred have changed between
> >> >> >> > ->open() and ->read() then abort, return zero, the ->read(),write()...
> >> >> >>
> >> >> >> IMO yuck.
> >> >> >>
> >> >> >> >
> >> >> >> >
> >> >> >> > 2) Improve the proc_allow_access() check by:
> >> >> >> >    if this is the same user namespace then check uid/gid of f_cred on
> >> >> >> >    target cred task, and the capabilities superset:
> >> >> >> >    cap_issubset(tcred->cap_permitted, fcred->cap_permitted));
> >> >> >> >
> >> >> >> >    If it fails let security_capable() or file_ns_capable() do its magic.
> >> >> >> >
> >> >> >>
> >> >> >> NAK.  You need to actually call the LSM.  What if the reason to fail
> >> >> >> the request isn't that the writer gained capabilities -- what if the
> >> >> >> writer's selinux label changed?
> >> >> > Sorry I can't follow you here! Can you be more explicit please?
> >> >> >
> >> >> > For me we are already doing this during ptrace_may_access() on each
> >> >> > syscall, which will call LSM to inspect the privileges on each ->open(),
> >> >> > ->write()... So LSM hooks are already called. If you want to have more
> >> >> > LSM hooks, then perhaps that's another problem?
> >> >>
> >> >> Can you show me where, in your code, LSMs are asked whether the
> >> >> process calling read() is permitted to ptrace the process that the
> >> >> proc file points at?
> >> > Yes.
> >> > [PATCH v2 9/9] procfs: improve permission checks on /proc/*/syscall
> >> >
> >> > ->read()
> >> >   ->syscall_read()
> >> >     ->lock_trace()
> >> >       ->ptrace_may_access()
> >> >         ->__ptrace_may_access()
> >> >           ->security_ptrace_access_check()
> >> >             ->yama_ptrace_access_check()
> >> >             ->security_ops->ptrace_access_check()
> >> >
> >> >
> >> > And also for patch:
> >> > [PATCH v2 8/9] procfs: improve permission checks on /proc/*/stack
> >> >
> >> > And during ->open() and ->read()
> >> >
> >> >
> >> > So sorry Andy, I don't follow what you are describing.
> >>
> >> And what parameters are you passing to security_ptrace_access_check?
> >> It's supposed to be f_cred, right?  Because you want to make sure
> >> that, if the opener had some low-privilege label, the target has
> >> execed and gotten a more secure label, and the reader has a
> >> high-privilege label, that the opener's label is checked against the
> >> target's new label.
> > The current's cred each time.
> 
> Exactly.  Hence the NAK.
But Having two LSM Hooks there is really not practical!

Note to mention some of these redundancy checks...

> >
> > Is there some mechanism to check what you describe?
> >
> 
> No.  You could try to add one, but getting it to be compatible with
> YAMA might be really messy.
LSM is limitted in this situation, and it can't work with YAMA, or
perhaps YAMA will just return -EPERM

So this LSM protections are currently vulnerable too!


> Or you could see if destroying and recreating all the inodes on exec
> or some other revoke-like approach would work.
> 
> --Andy

-- 
Djalal Harouni
http://opendz.org
