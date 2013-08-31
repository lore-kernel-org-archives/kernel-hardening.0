Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 31 Aug 2013 21:26:37 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130831202637.GA6013@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
 <20130826172054.GE27005@ZenIV.linux.org.uk>
 <20130827172406.GA2664@dztty>
 <20130828201141.GA21455@dztty>
 <CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
 <20130828211116.GA22184@dztty>
 <87sixt735b.fsf@xmission.com>
 <20130829091127.GA2635@dztty>
 <CAGXu5jJtiji1KPPLSr5SXKXGwBbb8McWZY3DqCZFWXKtP=KEzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJtiji1KPPLSr5SXKXGwBbb8McWZY3DqCZFWXKtP=KEzA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

(Sorry for my late response)

On Thu, Aug 29, 2013 at 03:14:32PM -0700, Kees Cook wrote:
> On Thu, Aug 29, 2013 at 2:11 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > Hi Eric,
> >
> > On Wed, Aug 28, 2013 at 05:26:56PM -0700, Eric W. Biederman wrote:
> >>
> >> I have take a moment and read this thread, and have been completely
> >> unenlightend.  People are upset but it is totally unclear why.
> >>
> >> There is no explanation why it is ok to ignore the suid-exec case, as
> >> the posted patches do.  Which ultimately means the patches provide
> > Please, did you take a look at the patches ?
> > -       INF("syscall",    S_IRUGO, proc_pid_syscall),
> > +       INF("syscall",    S_IRUSR, proc_pid_syscall),
> >
> > Can you please tell me how did you come to the conclusion that the
> > patches "ignore the suid-exec case as the posted patches do" ?
> 
> There are a few conditions that need to be handled. The original fix
> that Al landed was to stop this:
> 
> create IPC
> fork child
> child opens /proc/self/syscall
> child sends fd to parent over IPC
> child execs setuid process
> parent reads setuid process's "syscall" file
> 
> The solution was to check perms of reader (in this case parent wasn't
> privileged, so it gets denied).
Yes, of course


> The new problem is:
> 
> open /proc/$target/syscall
> dup to stdin
> exec setuid process that reports contents of stdin
> 
> So, changing perms to 0400 doesn't actually fix what we want to fix,
> since it can still by bypassed under more limited situations:
> 
> open /proc/self/syscall
> dup to stdin
> exec setuid process that reports contents of stdin
> 
> So, changing to 0400 means only setuid programs that aren't already
> running will have their ASLR leaked.
Yes I do realize. That change was only to block leaks against already
running processes and *restore* the old permissions.


> [...] 
> Maybe I'm lacking imagination, but changing to 0400 does reduce the
> scope of the leak from all processes to "just" what was execed. This
> still needs to be addressed, but I don't see a way to handle this
> without explicitly invalidating the /proc handle across exec.
Yes Kees,

I did try a year ago to adapt the exec_id from grsecurity and failed
(and failed again to resend - not enough resources):
https://lkml.org/lkml/2012/3/10/174


Kees IMHO the right solution is to invalidate the fd across exec as
you suggest

Alan Cox's thread which describe the problem correctly:
https://lkml.org/lkml/2012/1/29/35

Alan suggested to revoke() the file handles.



So:
There are more of these /proc files with 0444 and without appropriate
ptrace protections that allow ASLR leaks, and doing 0400 will not
totally fix it, not to mention that 0400 on /proc/pid/maps can break
glibc, etc.


A solution would be to implement the per-cpu exec_id used in grsecurity
and also suggested here:
https://lkml.org/lkml/2012/3/11/23

grsecurity uses the current (reader) exec_id to track if this is still
the same reader. We can use the target exec_id instead of the reader to
bind all these files to their exec_id target task + ptrace checkes at
open(), read(), write()...

Can we consider this some sort of a revoke() for these special files?


Thanks

-- 
Djalal Harouni
http://opendz.org
