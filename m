Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jul 2011 16:48:30 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110721124830.GA1325@openwall.com>
References: <20110714112751.1bfd998f@notabene.brown> <20110714150602.GA30019@openwall.com> <20110715133013.4fa38d19@notabene.brown> <20110715063113.GA3166@albatros> <20110715170650.585f1dad@notabene.brown> <20110715073823.GA3821@albatros> <1310738313.30257.27.camel@moss-pluto> <20110715152641.GA6286@albatros> <1310759683.30257.123.camel@moss-pluto> <20110721140936.632d2c8b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721140936.632d2c8b@notabene.brown>
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: NeilBrown <neilb@suse.de>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 21, 2011 at 02:09:36PM +1000, NeilBrown wrote:
> On Fri, 15 Jul 2011 15:54:43 -0400 Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Fri, 2011-07-15 at 19:26 +0400, Vasiliy Kulikov wrote:
> > > On Fri, Jul 15, 2011 at 09:58 -0400, Stephen Smalley wrote:
> > > > Does this have implications for Android's zygote model?  There you have
> > > > a long running uid 0 / all caps process (the zygote), which forks itself
> > > > upon receiving a request to spawn an app and then calls
> > > 
> > > > setgroups();
> > > > setrlimit(); setgid(); setuid();
> > > 
> > > Is RLIMIT_NPROC forced in your model and setuid() is expected to fail
> > > because of NPROC exceeding?  If no, then it is not touched at all.
> > 
> > I don't know what their intent is.  But it is an example of a case where
> > moving the enforcement from setuid() to a subsequent execve() causes the
> > check to never get applied.  As to whether or not they care, I don't
> > know.  An app that calls fork() repeatedly will still be stopped, but an
> > app that repeatedly connects to the zygote and asks to spawn another
> > instance of itself would be unlimited.
> > 
> > OTOH, the current RLIMIT_NPROC check and lack of setuid() error checking
> > has been a repeated issue for Android.
> 
> So where does this leave us?  Between a rock and a hard place?

Maybe.  I just took a look at Android's Zygote code, as found via Google
Code Search.  This appears to be the relevant place:

http://www.google.com/codesearch#atE6BTe41-M/vm/native/dalvik_system_Zygote.c&q=forkAndSpecialize&type=cs&l=439

As we can see, Stephen's description of the sequence of calls is indeed
correct.  Also, the return value from setuid() is checked here. :-)

As to which rlimits are actually set, I don't know.  This appears to be
configured at a much higher level:

http://www.google.com/codesearch#uX1GffpyOZk/core/java/com/android/internal/os/ZygoteConnection.java&q=ZygoteConnection.java&type=cs&l=247

--rlimit=r,c,m tuple of values for setrlimit() call.

I have no idea whether this --rlimit argument is ever supplied and with
what settings.  The intent of supporting it could well be other than
making use of RLIMIT_NPROC specifically.

> It says to me that moving the check from set_user to execve is simply
> Wrong(TM).  It may be convenient and do TheRightThing in certain common
> cases, but it also can do the Wrong thing in other cases and I don't think
> that is an acceptable trade off.

I disagree.  There's nothing wrong in having the check on execve(),
especially not if we combine it with a check of your proposed flag set
on setuid() (only fail execve() when the flag is set and RLIMIT_NPROC is
still or again exceeded).

> Having setuid succeed when it should fail is simply incorrect.

As far as I'm aware, no standard says that setuid() should fail if it
would exceed RLIMIT_NPROC for the target user.  There's a notion of
"appropriate privileges", but what these are is implementation-defined
and it was hardly meant to include rlimits.

> The problem - as we all know - is that user space doesn't always check error
> status properly.  If we were to look for precedent I would point to SIGPIPE.
> The only reason for that to exist is because programs don't always check that
> a "write" succeeds so we have a mechanism to kill off processes that don't
> check the error status and keep sending.
> 
> I would really like to apply that to this problem ... but that has already
> been suggested (years ago) and found wanting.  Maybe we can revisit it?
> 
> The value of the SIGPIPE approach (whether it is SIGPIPE or SIGXCPU or
> SIGVEC ... if only there were a SIGXNPROC) is that the program remains in
> complete control.  It can find out if the NPROC limit has been exceeded at
> the "right" time.

I don't mind having setuid() signal (and by default actually kill) a
process if it would exceed RLIMIT_NPROC.  However, I doubt that others
will agree.  BTW, as I told Vasiliy on the kernel-hardening list, I
think we should revisit the "can't happen" memory allocation failure in
set_user() _after_ we have dealt with the RLIMIT_NPROC issue.  I would
support the killing of process with SIGKILL or SIGSEGV (as opposed to
return -EAGAIN) on that "can't happen" condition (which might become
possible in a further revision of the code, so better safe than sorry).
Let's actually revisit this later, after having the most important fix
applied.

> The only other solution that I can think of which isn't "Wrong(TM)" is my
> first patch which introduced PF_SETUSER_FAILED.
> With this patch setuid() still fails if it should, so the calling process
> still remains in control.   But if it fails to exercise that control, the
> kernel steps in.
> 
> Vasiliy didn't like that because it allows a process to ignore the setuid
> failure, perform some in-process activity as root when expecting it to be as
> some-other-user, and only fails when execve is attempted - possibly too late.

I am with Vasiliy on this.

> Against this I ask: what exactly is our goal here?
> Is it to stop all possible abuses?  I think not.  That is impossible.
> Is it to stop certain known and commonly repeated errors?  I think so. That
> is clearly valuable.

Not checking the return value from setuid() and proceeding to do other
work is a known and commonly repeated error.  As to whether it is also
common for that other work to involve risky syscalls other than execve(),
I expect that it is, although I did not research this.

> We know (Thanks to Solar Designer's list) that unchecked setuid followed by
> execve is a commonly repeated error, so trapping that can be justified.
> Do we know that accessing the filesystem first is a commonly repeated error?
> If not, there is no clear motive to deal with that problem.
> If, however, it is then maybe a check for PF_SETUSER_FAILED in
> inode_permission() would be the right thing.
> 
> Or maybe we just set PF_SETUSER_FAILED and leave it up to some security
> module to decide what to disable or report when that is set?

I feel that we'd be inventing something more complicated yet worse than
simply moving the check would be.

Here's my current proposal:

1. Apply Vasiliy's patch to move the RLIMIT_NPROC check from setuid() to
execve(), optionally enhanced with setting PF_SETUSER_FAILED on
would-be-failed setuid() and checking this flag in execve() (in addition
to repeating the RLIMIT_NPROC check).

2. With a separate patch, add a prctl() to read the PF_SETUSER_FAILED flag.
Android will be able to use this if it wants to.

Yes, this might break RLIMIT_NPROC for Android (I wrote "might" because
I have no idea if it actually sets that specific limit or not) until it
learns to use the new prctl().  But I think that's fine, and it is not a
reason for us to introduce more complexity into the kernel, yet make our
security hardening change more limited.  There was never a guarantee (in
any standard or piece of documentation) that setuid() would fail on
exceeding RLIMIT_NPROC, and the Android/Zygote code might not actually
rely on that anyway (there's no clear indication that it does;
RLIMIT_NPROC is not in the code, nor is it mentioned in any comment).

> In short:  I don't think there can be a solution that is both completely
> correct and completely safe.  I would go for "as correct as possible" with
> "closes common vulnerabilities".

Maybe, and if so I think that one I proposed above falls in this
category as well, but it closes more vulnerabilities (and/or does so
more fully).

Thanks,

Alexander
