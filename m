Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2011 14:04:53 +0200
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20110701120453.GA28008@elte.hu>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
 <20110701112534.GG20990@elte.hu>
 <20110701113533.GA19945@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701113533.GA19945@albatros>
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: solar@openwall.com, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Vasiliy Kulikov <segoon@openwall.com> wrote:

> On Fri, Jul 01, 2011 at 13:25 +0200, Ingo Molnar wrote:
> > Furthermore, if testing shows that this is not actually breaking 
> > anything in a serious way we could also in theory simplify the patch 
> > and just make this the default behavior with no runtime ability to 
> > switch it off.
> 
> I'm afraid it's impossible.  From -ow readme:
> 
> "Of course, this breaks the way things are defined, so some 
> applications might stop working. In particular, expect most 
> commercial databases to break. Apache and PostgreSQL are known to 
> work, though. :-)"
> 
> http://www.openwall.com/linux/README.shtml
> 
> But as it was written in days of Linux 2.4.x, the situation could 
> have changed.  A desktop system seems to work.

As we really prefer working systems over non-working ones (and lots 
of unattached shm segments can clearly result in a non-working 
system) we can only accept the "this will break stuff" argument if 
it's *demonstrated* to break stuff and if the failure scenario is 
carefully described in the commit.

It would take a serious breakage to override a "system locks up 
swapping itself to death" failure scenario.

Thanks,

	Ingo
