Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2011 20:50:35 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110702165035.GC26232@openwall.com>
References: <20110622152514.GA9521@albatros> <20110629151436.9be479fb.akpm@linux-foundation.org> <20110701112534.GG20990@elte.hu> <20110701113533.GA19945@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701113533.GA19945@albatros>
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 01, 2011 at 03:35:33PM +0400, Vasiliy Kulikov wrote:
> From -ow readme:
> 
> "Of course, this breaks the way things are defined, so some applications
> might stop working. In particular, expect most commercial databases to
> break. Apache and PostgreSQL are known to work, though. :-)"
> 
> http://www.openwall.com/linux/README.shtml
> 
> But as it was written in days of Linux 2.4.x, the situation could have
> changed.  A desktop system seems to work.

I wrote the above in 2.0.x days (circa 1998) and it was based on FUD
rather than on any real evidence of any breakage.  Apache and PostgreSQL
were a couple of known users of shared memory segments, and these did
not break.  I was not aware of any programs that presumably did break.
Of course, those probably do exist, but I don't recall anyone ever
reporting any to me (as maintainer of -ow patches), although the warning
quoted above might have played a role in such non-reporting.

Alexander
