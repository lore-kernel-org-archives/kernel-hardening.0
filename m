Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 27 Jun 2011 12:52:42 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110627085242.GA6635@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <4E07F1C0.2070305@jp.fujitsu.com>
 <20110627070300.GA4463@albatros>
 <4E08324D.9040605@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E08324D.9040605@jp.fujitsu.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

(cc'ed Linus)

On Mon, Jun 27, 2011 at 16:33 +0900, KOSAKI Motohiro wrote:
> (2011/06/27 16:03), Vasiliy Kulikov wrote:
> > On Mon, Jun 27, 2011 at 11:58 +0900, KOSAKI Motohiro wrote:
> >> (2011/06/24 21:08), Vasiliy Kulikov wrote:
> >>> /proc/PID/io may be used for gathering private information.  E.g. for
> >>> openssh and vsftpd daemons wchars/rchars may be used to learn the
> >>> precise password length.  Restrict it to processes being able to ptrace
> >>> the target process.
> >>>
> >>> ptrace_may_access() is needed to prevent keeping open file descriptor of
> >>> "io" file, executing setuid binary and gathering io information of the
> >>> setuid'ed process.
> >>>
> >>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> >>
> >> This description seems makes sense to me. But Vasilly, I have one question.
> >> Doesn't this change break iotop command or other userland tools?
> > 
> > I don't use iotop, but after reading the sources it looks like it uses
> > taskstats for information gathering, which will be broken for sure by
> > the second patch.  All other userland tools using alien io files will be
> > broken too.
> > 
> > I'd say the whole approach of world readable debugging/statistics
> > information was broken from the beginning, now we are stuck with these
> > interfaces because of acient mistakes.
> 
> Just idea. (perhaps it's too dumb).
> 
> If a user want to know throughput, usually they only need KB/s granularity.
> If a user want to know password hints, they need to know strict bytes granularity.
> So, adding some random bytes to this statistics may help to obscure key data,
> or just "stat = ROUND_UP(stat, 1024)".
> 
> But, I hope to wait another experts response. they may know better approach. :)

Yep, Linus has already suggested a similar thing:
http://www.openwall.com/lists/oss-security/2011/06/27/4

As to random bytes - if it is very predictable (e.g. rand() % 10000) one
may restore the original value.  But it would still do much harm to good
programs (io stats going up and down!).  Adding really random bytes
seems somewhat too complicated for these needs to me.

As to rounding - this is a workaround, not a fix.  What if some program
reads one byte from tty and then do some io activity exactly of 1kb-1?
Then you just measure kbs and get original tty activity.  (just a crazy
example to show that it is not a full solution.)


Without any proof/estimate, just an idea: it's possible to get not only
password length, which needs as much granularity as possible, but
another information, which doesn't need any strict value.  E.g.
statistics changing, what should indicate that some significant event
has just happened.


> >>> ---
> >>>  fs/proc/base.c |    7 +++++--
> >>>  1 files changed, 5 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/proc/base.c b/fs/proc/base.c
> >>> index 14def99..5ae25d1 100644
> >>> --- a/fs/proc/base.c
> >>> +++ b/fs/proc/base.c
> >>> @@ -2712,6 +2712,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
> >>>  	struct task_io_accounting acct = task->ioac;
> >>>  	unsigned long flags;
> >>>  
> >>> +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> >>> +		return -EACCES;
> >>> +
> >>
> >> I think this check need a comment. Usually procfs don't use ptrace_may_access() directly
> >> (see mm_for_maps) because it's racy against exec().
> > 
> > This makes sense.  Reading /proc/self/io and exec'ing setuid program
> > would cause the race.  What lock should I use to block execve()?
> > 
> > 
> > Also I'm worried about these statistics after dropping the privileges.
> > After setuid() and similar things not changing pid unprivileged user
> > gets some information about the previous io activity of this task being
> > privileged.  In some situations it doesn't reveal any sensitive
> > information, in some it might.  Clearing taskstats on credential
> > changing functions would totally break taskstats' interfaces; and should
> > be temporary changing fsuid/euid followed by reverting it considered
> > harmfull?  I don't know.
> 
> Can you please explain more? I'm feeling "reset at credential change" is
> reasonable idea. How broken is there?

In the code I see taskstats statistics is kept untouched, so it would
break userspace assumptions about the statistics.


> >> However I think your code is ok.
> >> because a few bytes io accounting leak has no big matter.
> > 
> > Please don't do any assumptions about the significance of these few
> > bytes.  It can be not "few" bytes if either the scheduler's granularity
> > is significant or the scheduler does wrong assumptions about CPU speeds.
> > Also if someone gets CAP_SYS_NICE he may totally break these assumptions.
> > 
> > My ssh example is just a proof that io stat is harmfull *sometimes*.
> > I didn't investigate in what cases it is harmless for sure (if it's
> > possible at all).
> 
> Umm. reasonable. task->signal->cred_guard_mutex can be used for preventing
> exec() race, I think. (see check_mem_permission() and et al).

(the same should go into the taskstats fix) 

Looks sane, thank you!


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
