Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jul 2011 14:09:36 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110721140936.632d2c8b@notabene.brown>
In-Reply-To: <1310759683.30257.123.camel@moss-pluto>
References: <20110713170657.59dae548@notabene.brown>
	<CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
	<alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
	<20110714112751.1bfd998f@notabene.brown>
	<20110714150602.GA30019@openwall.com>
	<20110715133013.4fa38d19@notabene.brown>
	<20110715063113.GA3166@albatros>
	<20110715170650.585f1dad@notabene.brown>
	<20110715073823.GA3821@albatros>
	<1310738313.30257.27.camel@moss-pluto>
	<20110715152641.GA6286@albatros>
	<1310759683.30257.123.camel@moss-pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 15 Jul 2011 15:54:43 -0400 Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Fri, 2011-07-15 at 19:26 +0400, Vasiliy Kulikov wrote:
> > Hi Stephen,
> > 
> > On Fri, Jul 15, 2011 at 09:58 -0400, Stephen Smalley wrote:
> > > Does this have implications for Android's zygote model?  There you have
> > > a long running uid 0 / all caps process (the zygote), which forks itself
> > > upon receiving a request to spawn an app and then calls
> > 
> > > setgroups();
> > > setrlimit(); setgid(); setuid();
> > 
> > Is RLIMIT_NPROC forced in your model and setuid() is expected to fail
> > because of NPROC exceeding?  If no, then it is not touched at all.
> 
> I don't know what their intent is.  But it is an example of a case where
> moving the enforcement from setuid() to a subsequent execve() causes the
> check to never get applied.  As to whether or not they care, I don't
> know.  An app that calls fork() repeatedly will still be stopped, but an
> app that repeatedly connects to the zygote and asks to spawn another
> instance of itself would be unlimited.
> 
> OTOH, the current RLIMIT_NPROC check and lack of setuid() error checking
> has been a repeated issue for Android.
> 

So where does this leave us?  Between a rock and a hard place?

It says to me that moving the check from set_user to execve is simply
Wrong(TM).  It may be convenient and do TheRightThing in certain common
cases, but it also can do the Wrong thing in other cases and I don't think
that is an acceptable trade off.

Having setuid succeed when it should fail is simply incorrect.

The problem - as we all know - is that user space doesn't always check error
status properly.  If we were to look for precedent I would point to SIGPIPE.
The only reason for that to exist is because programs don't always check that
a "write" succeeds so we have a mechanism to kill off processes that don't
check the error status and keep sending.

I would really like to apply that to this problem ... but that has already
been suggested (years ago) and found wanting.  Maybe we can revisit it?

The value of the SIGPIPE approach (whether it is SIGPIPE or SIGXCPU or
SIGVEC ... if only there were a SIGXNPROC) is that the program remains in
complete control.  It can find out if the NPROC limit has been exceeded at
the "right" time.


The only other solution that I can think of which isn't "Wrong(TM)" is my
first patch which introduced PF_SETUSER_FAILED.
With this patch setuid() still fails if it should, so the calling process
still remains in control.   But if it fails to exercise that control, the
kernel steps in.

Vasiliy didn't like that because it allows a process to ignore the setuid
failure, perform some in-process activity as root when expecting it to be as
some-other-user, and only fails when execve is attempted - possibly too late.

Against this I ask: what exactly is our goal here?
Is it to stop all possible abuses?  I think not.  That is impossible.
Is it to stop certain known and commonly repeated errors?  I think so. That
is clearly valuable.

We know (Thanks to Solar Designer's list) that unchecked setuid followed by
execve is a commonly repeated error, so trapping that can be justified.
Do we know that accessing the filesystem first is a commonly repeated error?
If not, there is no clear motive to deal with that problem.
If, however, it is then maybe a check for PF_SETUSER_FAILED in
inode_permission() would be the right thing.

Or maybe we just set PF_SETUSER_FAILED and leave it up to some security
module to decide what to disable or report when that is set?

In short:  I don't think there can be a solution that is both completely
correct and completely safe.  I would go for "as correct as possible" with
"closes common vulnerabilities".

NeilBrown
