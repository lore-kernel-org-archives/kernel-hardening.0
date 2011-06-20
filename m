Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 21:06:01 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620170600.GA25601@albatros>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
 <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
 <20110620103917.GA5230@albatros>
 <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

(cc'ed Eric)

On Mon, Jun 20, 2011 at 20:43 +1000, James Morris wrote:
> > > > hidepid=1 means users may not access any /proc/<pid>/ directories, but their
> > > > own.  Sensitive files like cmdline, io, sched*, status, wchan are now
> > > > protected against other users.  As permission checking done in
> > > > proc_pid_permission() and files' permissions are left untouched,
> > > > programs expecting specific files' permissions are not confused.
> > > 
> > > IMHO such programs are beyond broken and have voided their kernel 
> > > warranty.
> > 
> > Policykit, Debian's start-stop-daemon, util-linux use /proc/PID's uid.
> > procps use both /proc/PID's uid and gid.  Are all of them totally broken?
> 
> If they depend on specific permissions, yes.

Could you please then clarify why does this patch changes
pid_revalidate() behaviour:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=99f895518368252ba862cc15ce4eb98ebbe1bec6

It changes files permissions to allow userspace apps to quickly stat
files, not looking into /proc/PID/status.  So, uid and gid are explicit
ABI.  Breaking procfs uid/gid attributes would break these apps.

Or am I missing something?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
