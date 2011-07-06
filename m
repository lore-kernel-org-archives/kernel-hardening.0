Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Jul 2011 20:08:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20110706180831.GA15379@redhat.com>
References: <20110630134855.GA6165@mail.hallyn.com> <20110630135718.GA13406@albatros> <20110703180028.GA26742@albatros> <20110704115523.GA11252@albatros> <20110705142659.GA18290@peqn> <20110705145033.GA3052@albatros> <20110705155755.GB14784@peqn> <20110705174200.GC6102@albatros> <20110706163140.GA24949@peqn> <20110706165732.GA4820@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706165732.GA4820@albatros>
Subject: Re: [kernel-hardening] Re: [PATCH] shm: handle separate PID
	namespaces case
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 07/06, Vasiliy Kulikov wrote:
>
> > > +void exit_shm(struct task_struct *task)
> > > +{
> > > +	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
> > > +
> > > +	/* Destroy all already created segments, but not mapped yet */
> > > +	down_write(&shm_ids(ns).rw_mutex);
> > > +	if (&shm_ids(ns).in_use)
> > > +		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
> > > +	up_write(&shm_ids(ns).rw_mutex);
> >
> > Having exit_shm() call shm_destroy_orphaned(task->nsproxy->ipc_ns) seems
> > more future-proof?
>
> shm_destroy_orphaned() doesn't clear ->shm_creator.  Logically it sovles
> another problem - it is used ONLY to be consistent while changing
> kernel.shm_rmid_forced (having orphans with shm_rmid_forced=1 is not
> honest).

Yes, there are different things.

Cough. I stil think exit_shm() should check .in_use != 0 lockless.

Oleg.
