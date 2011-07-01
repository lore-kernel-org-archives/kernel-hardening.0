Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2011 13:25:34 +0200
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20110701112534.GG20990@elte.hu>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629151436.9be479fb.akpm@linux-foundation.org>
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *ns)
> >  	ns->shm_ctlmax = SHMMAX;
> >  	ns->shm_ctlall = SHMALL;
> >  	ns->shm_ctlmni = SHMMNI;
> > +	ns->shm_rmid_forced = 0;
> >  	ns->shm_tot = 0;
> >  	ipc_init_ids(&shm_ids(ns));
> >  }
> 
> The problem is that nobody will test your feature.  So for testing
> purposes, let's enable the feature by default.  I assume this:

I'd also strongly argue to keep this as a default. OOM-kills are not 
part of POSIX and violate POSIX in a number of ways already.

Furthermore, if testing shows that this is not actually breaking 
anything in a serious way we could also in theory simplify the patch 
and just make this the default behavior with no runtime ability to 
switch it off.

Thanks,

	Ingo
