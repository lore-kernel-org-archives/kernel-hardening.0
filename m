Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 9 Oct 2013 11:35:21 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20131009103521.GA4108@dztty>
References: <CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
 <20131004191113.GA3916@dztty>
 <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
 <20131004192712.GA4334@dztty>
 <CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
 <20131004194142.GA4524@dztty>
 <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
 <87fvsgy7cn.fsf@xmission.com>
 <CALCETrVFNcGtsm3N50sZRDWmBOJ3VWn=BidAOV4Q+eDwYhJ+vw@mail.gmail.com>
 <871u40r1v9.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u40r1v9.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if
 file's opener may access task
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 04, 2013 at 05:35:22PM -0700, Eric W. Biederman wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
> 
> > On Fri, Oct 4, 2013 at 3:55 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Andy Lutomirski <luto@amacapital.net> writes:
> >>
> >>> On Fri, Oct 4, 2013 at 12:41 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >>>> On Fri, Oct 04, 2013 at 12:32:09PM -0700, Andy Lutomirski wrote:
> >>>>> On Fri, Oct 4, 2013 at 12:27 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >>
> >>>>> > So sorry Andy, I don't follow what you are describing.
> >>>>>
> >>>>> And what parameters are you passing to security_ptrace_access_check?
> >>>>> It's supposed to be f_cred, right?  Because you want to make sure
> >>>>> that, if the opener had some low-privilege label, the target has
> >>>>> execed and gotten a more secure label, and the reader has a
> >>>>> high-privilege label, that the opener's label is checked against the
> >>>>> target's new label.
> >>>> The current's cred each time.
> >>>
> >>> Exactly.  Hence the NAK.
> >>>
> >>>>
> >>>> Is there some mechanism to check what you describe?
> >>>>
> >>>
> >>> No.  You could try to add one, but getting it to be compatible with
> >>> YAMA might be really messy.
> >>>
> >>> Or you could see if destroying and recreating all the inodes on exec
> >>> or some other revoke-like approach would work.
> >>
> >> This is a revoke like approach, and yes proc has a fully functional
> >> revoke infrastructure.  Right now that revoke is based on the process
> >> going away.  The problem challenge is that the process is morphing.
> >>
> >> The practical question is which runtime checks do we want to perform.
> >>
> >> If we can say in no uncertain terms that short of a suid exec that
> >> no calls (such as setuid) can change the process permissions beyond
> >> our ability to access the file, we can detect and exec and use that
> >> as a signal.
> >
> > If you could ptrace a process before it calls setuid and you can't
> > after it calls setuid, then this is stupid and doesn't matter -- once
> > you've pwned a process, you retain your pwnership at least until exec.
> 
> That is a reasonable principle to work from.  Still I am seeing cases
> where dumpable can change in principle if not in fact with a cred
> change.
> 
> But yes exec does appear to be the event to focus on.
> 
> > So yes, except that it's not just suid exec.  It's any exec that any
> > LSM would not do if no_new_privs were set.
> 
> >> Alternatively we may to look at a processes credentials and in all
> >> cases where those change use that as a signal that the file must
> >> be reopened.
> >
> > Hmm.  So why don't we just do a revoke whenever an exec that changes
> > cred happens?  (This will have some false positives, like unsharing
> > userns, I think, but we probably don't care.)
> 
> But because it is proc and because people do crazy things we have to
> investigate and test before we merge something like that.  I believe
> there was a patch not long ago that would fail an access if the openers
> and and the accessors creds which blew up rather quickly.
> 
> But it is definitely worth looking at.
We can track current exec or even target exec, use the percpu id solution
that was discussed here, and it seems Ingo like the solution:
https://lkml.org/lkml/2012/3/11/23

Grsecurity already do this!


Now to not break things and allow file descriptor to be passed, we couple
the exec id with the *cred and capability superset* check

The advantage of this solution would be:
* We'll have only a *one* ptrace_may_access(),LSM and permission check
  during ->open() or ->read()/write()...

A one check will do the job.


We do this by:
1) During ->open() store the opener exec id somewhere...

2) Call ptrace_may_access() and LSM check during ->open() or later
during ->read(),write()...

3) Then during ->read(),write(): check if current's exec id matches the
opener exec id, if not then there was an execve and continue with the
cred superset check using file->f_cred, the logic here is to check if
opener is privileged than current:

  * Same user namespace: check same uid, gid and capability superset
  * Different user namespaces: check if opener is an ancestor and its
    file->f_cred->euid is the owner...

   IOW make sure that opener is more privileged than current, or with
   the same privileges!

If it fails we return 0, end of file! otherwise allow the operation.


So if opener execve a more privileged process, the read() will fail.

This will make it easy to have a *one* ptrace_may_access() during all
syscalls!


Thoughts ?

-- 
Djalal Harouni
http://opendz.org
