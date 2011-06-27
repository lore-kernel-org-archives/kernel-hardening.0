Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 27 Jun 2011 11:03:00 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110627070300.GA4463@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <4E07F1C0.2070305@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E07F1C0.2070305@jp.fujitsu.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 27, 2011 at 11:58 +0900, KOSAKI Motohiro wrote:
> (2011/06/24 21:08), Vasiliy Kulikov wrote:
> > /proc/PID/io may be used for gathering private information.  E.g. for
> > openssh and vsftpd daemons wchars/rchars may be used to learn the
> > precise password length.  Restrict it to processes being able to ptrace
> > the target process.
> > 
> > ptrace_may_access() is needed to prevent keeping open file descriptor of
> > "io" file, executing setuid binary and gathering io information of the
> > setuid'ed process.
> > 
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> 
> This description seems makes sense to me. But Vasilly, I have one question.
> Doesn't this change break iotop command or other userland tools?

I don't use iotop, but after reading the sources it looks like it uses
taskstats for information gathering, which will be broken for sure by
the second patch.  All other userland tools using alien io files will be
broken too.

I'd say the whole approach of world readable debugging/statistics
information was broken from the beginning, now we are stuck with these
interfaces because of acient mistakes.

BTW, what to do with sched and status?  It stores some sensitive
information too (execution times and vm space, respectively).


> > ---
> >  fs/proc/base.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 14def99..5ae25d1 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -2712,6 +2712,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
> >  	struct task_io_accounting acct = task->ioac;
> >  	unsigned long flags;
> >  
> > +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> > +		return -EACCES;
> > +
> 
> I think this check need a comment. Usually procfs don't use ptrace_may_access() directly
> (see mm_for_maps) because it's racy against exec().

This makes sense.  Reading /proc/self/io and exec'ing setuid program
would cause the race.  What lock should I use to block execve()?


Also I'm worried about these statistics after dropping the privileges.
After setuid() and similar things not changing pid unprivileged user
gets some information about the previous io activity of this task being
privileged.  In some situations it doesn't reveal any sensitive
information, in some it might.  Clearing taskstats on credential
changing functions would totally break taskstats' interfaces; and should
be temporary changing fsuid/euid followed by reverting it considered
harmfull?  I don't know.


> However I think your code is ok.
> because a few bytes io accounting leak has no big matter.

Please don't do any assumptions about the significance of these few
bytes.  It can be not "few" bytes if either the scheduler's granularity
is significant or the scheduler does wrong assumptions about CPU speeds.
Also if someone gets CAP_SYS_NICE he may totally break these assumptions.

My ssh example is just a proof that io stat is harmfull *sometimes*.
I didn't investigate in what cases it is harmless for sure (if it's
possible at all).


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
