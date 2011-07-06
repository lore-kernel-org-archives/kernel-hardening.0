Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 6 Jul 2011 20:57:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110706165732.GA4820@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110705142659.GA18290@peqn>
 <20110705145033.GA3052@albatros>
 <20110705155755.GB14784@peqn>
 <20110705174200.GC6102@albatros>
 <20110706163140.GA24949@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706163140.GA24949@peqn>
Subject: Re: [kernel-hardening] Re: [PATCH] shm: handle separate PID
 namespaces case
To: kernel-hardening@lists.openwall.com
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Serge,

On Wed, Jul 06, 2011 at 11:31 -0500, Serge Hallyn wrote:
> > diff --git a/ipc/shm.c b/ipc/shm.c
> > index ab3385a..bf46636 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *ns)
> >  	ns->shm_ctlmax = SHMMAX;
> >  	ns->shm_ctlall = SHMALL;
> >  	ns->shm_ctlmni = SHMMNI;
> > +	ns->shm_rmid_forced = 1;
> 
> Given the description in Documentation/sysctl/kernel.txt, shouldn't
> this default to 0?

This is a change for testing purposes only, by Andrew:

http://www.openwall.com/lists/kernel-hardening/2011/06/29/7


> >  /*
> > + * shm_may_destroy - identifies whether shm segment should be destroyed now
> > + *
> > + * Returns true if and only if there are no active users of the segment and
> > + * one of the following is true:
> > + *
> > + * 1) shmctl(id, IPC_RMID, NULL) was called for this shp
> > + *
> > + * 2) sysctl kernel.shm_rmid_forced is set to 1.
> > + */
> > +static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
> 
> 'may' usually implies a permission check.  Would this be better named
> 'shm_should_destroy()'?

Looks right.


> > +/* Called with ns->shm_ids(ns).rw_mutex locked */
> > +static int shm_try_destroy_current(int id, void *p, void *data)
> > +{
> > +	struct ipc_namespace *ns = data;
> > +	struct kern_ipc_perm *ipcp = p;
> > +	struct shmid_kernel *shp = container_of(ipcp, struct shmid_kernel, shm_perm);
> > +
> > +	if (shp->shm_creator != current)
> > +		return 0;
> > +
> > +	/*
> > +	 * Mark it as orphaned to destroy the segment when
> > +	 * kernel.shm_rmid_forced is changed.
> > +	 * It is noop if the following shm_may_destroy() returns true.
> > +	 */
> > +	shp->shm_creator = NULL;
> > +
> > +	/*
> > +	 * Don't even try to destroy it.  If shm_rmid_forced=0 and IPC_RMID
> > +	 * is not set, it shouldn't be deleted here.
> > +	 */
> > +	if (!ns->shm_rmid_forced)
> > +		return 0;
> > +
> > +	if (shm_may_destroy(ns, shp)) {
> 
> This seems redundant.  Would it be better to just make this
> 
> 	if (shp->shm_nattch == 0) {
> 
> here as we already know ns->shm_rmid_forced == 1?

As this check doesn't cost much (shm_may_destroy() even may be inlined),
I want to leave the code here more readable.


> > +		shm_lock_by_ptr(shp);
> > +		shm_destroy(ns, shp);
> 
> Wish there were a clean way to document that the locks will be
> released by shm_destroy().

Isn't the current comment sufficient?

/*
 * shm_destroy - free the struct shmid_kernel
 *
 * @ns: namespace
 * @shp: struct to free
 *
 * It has to be called with shp and shm_ids.rw_mutex (writer) locked,
 * but returns with shp unlocked and freed.
 */


> > +void shm_destroy_orphaned(struct ipc_namespace *ns)
> > +{
> > +	down_write(&shm_ids(ns).rw_mutex);
> > +	if (&shm_ids(ns).in_use)
> > +		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
> > +	up_write(&shm_ids(ns).rw_mutex);
> 
> Hm, is this going to cause contention when killing a lot of tasks?

The default limit is 4096 segments, IMO too few to cause something
nasty.


> > +}
> > +
> > +
> > +void exit_shm(struct task_struct *task)
> > +{
> > +	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
> > +
> > +	/* Destroy all already created segments, but not mapped yet */
> > +	down_write(&shm_ids(ns).rw_mutex);
> > +	if (&shm_ids(ns).in_use)
> > +		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
> > +	up_write(&shm_ids(ns).rw_mutex);
> 
> Having exit_shm() call shm_destroy_orphaned(task->nsproxy->ipc_ns) seems
> more future-proof?

shm_destroy_orphaned() doesn't clear ->shm_creator.  Logically it sovles
another problem - it is used ONLY to be consistent while changing
kernel.shm_rmid_forced (having orphans with shm_rmid_forced=1 is not
honest).


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
