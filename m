Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 9 Nov 2011 21:09:46 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111109170946.GA30780@albatros>
References: <20111108121412.GA14450@albatros>
 <4EBA0A32.3000607@kernel.sg>
 <20111109161123.GC2557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109161123.GC2557@kroah.com>
Subject: [kernel-hardening] Re: Fwd: kernel: multiple flaws allowing to sniff keystrokes
 timings
To: Greg KH <greg@kroah.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, security@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Nov 09, 2011 at 08:11 -0800, Greg KH wrote:
> On Wed, Nov 09, 2011 at 01:05:54PM +0800, Eugene Teo wrote:
> > 1) https://lkml.org/lkml/2011/11/7/340
> > 
> > "/proc/interrupts contains the number of emitted interrupts, which
> > should not be world readable.  The information about keyboard interrupts
> > number may be used to learn the precise number of characters
> > in users' passwords by simply watching the changes of number of emitted
> > interrupts during the life of gksu-like programs."
> > 
> > PoC: http://www.openwall.com/lists/oss-security/2011/11/07/9
> > 
> > Vulnerable: all Linux versions, all distros with procfs mounted.
> > 
> > (The patch misses the same infoleak via /proc/stat, which must be closed
> > too.)
> 
> The patch is also buggy, and might be reverted at any moment :(

Hm?  This patch was never applied (at least I haven't received a tip for it).

You're probably talking about /proc/$PID/fd* with a weird deplock
warning, which is irrelevant.


> > 2) https://lkml.org/lkml/2011/11/7/355
[...]
> But we really can't change this as it would break compatibility, as Alan
> Cox pointed out, so what can be done here?
> 
> > 3) https://lkml.org/lkml/2011/11/8/136
[...]
> revoke() is still a dream (I looked into it and no other OS implements
> it as we have talked about it so I still fail to see how it would really
> work), so don't hold your breath waiting for that to happen...

Sad.  I see only two solutions then:

1) show zero fields to unprivileged users (for /proc/interrupts and
/proc/stat it is CAP_SYS_ADMIN, for /proc/$PID/{stat,sched,schedstat} it
is ptrace_may_access(), for ttys it is uid check) and real values for
privileged.  The same technique is used in /proc/$PID/sched for eip/esp
values.

2) completely deny the syscalls in questions for unprivileged users.
Not a way to go with /proc/$PID/* as it would break top and other cpu
monitors.


The solution for /proc/$PID/* could come from the applications themselves,
i.e. they could create additional CPU noise while processing sensible
information like passwords (like some crypto software does to protect
against timing attacks), but it is crazy to expect this from all developers.
Probably it would not even fix the issue as the activity can be still
learned from other programs they interact with via the same /proc/$PID/*
files or other implicit information sources.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
