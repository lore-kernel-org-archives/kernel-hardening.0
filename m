Date: Mon, 6 May 2019 12:21:12 +0200
From: Solar Designer <solar@openwall.com>
Subject: race-free process signaling
Message-ID: <20190506102112.GA12668@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I totally missed the recent work in this area (I'm not on LKML), and am
now wondering whether the solution that got in ("use /proc/<pid> fds as
stable handles on struct pid"):

https://lwn.net/Articles/773459/
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9dce6679d736cb3d612af39bab9f31f8db66f9b

is better or worse than what I had proposed in 1999 and 2005 ("locking"
of pids for the caller's own visibility only):

https://marc.info/?l=linux-kernel&m=112784189115058

[Subject starts with "PID reuse safety for userspace apps", in case MARC
is ever gone and someone wants to look this up in another archive.

I proposed a lockpid syscall back then, but I'd use a mere prctl now.]

I still like my proposal much better - no dependency on procfs, much
simpler implementation - but perhaps I'm missing the context here.

Maybe I should have sent a patch back then.  Oh well.

Alexander
