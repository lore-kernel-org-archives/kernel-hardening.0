Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 19:36:44 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110704153644.GB21350@albatros>
References: <20110622152514.GA9521@albatros>
 <20110704150859.GB6893@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704150859.GB6893@redhat.com>
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Oleg Nesterov <oleg@redhat.com>
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 04, 2011 at 17:08 +0200, Oleg Nesterov wrote:
> On 06/22, Vasiliy Kulikov wrote:
> >
> > +void exit_shm(struct task_struct *task)
> > +{
> > +	struct nsproxy *nsp = task->nsproxy;
> > +	struct ipc_namespace *ns;
> > +
> > +	if (!nsp)
> > +		return;
> > +	ns = nsp->ipc_ns;
> > +	if (!ns || !ns->shm_rmid_forced)
> 
> This looks confusing, imho. How it is possible that ->nsproxy or
> ->ipc_ns is NULL?

I spotted the same checking logic in other places.  I don't know whether
it is redundant, I guess it can happen when the namespace is dying.
Probably it cannot happed inside of task do_exit(), only for extern
observers.


> > +		return;
> > +
> > +	/* Destroy all already created segments, but not mapped yet */
> > +	down_write(&shm_ids(ns).rw_mutex);
> > +	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
> >  	up_write(&shm_ids(ns).rw_mutex);
> 
> Again, I do not pretend I understand ipc/, but it seems we can check
> ns->ipc_ids[].in_use != 0 before the slow path, no?

Looks like you're right.  Given it is do_exit(), the boost is
significant.

I'll send the patch for this thing and the locking part.


Thank you!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
