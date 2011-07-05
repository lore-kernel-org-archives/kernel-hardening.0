Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 5 Jul 2011 18:50:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110705145033.GA3052@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110705142659.GA18290@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705142659.GA18290@peqn>
Subject: [kernel-hardening] Re: [PATCH] shm: handle separate PID namespaces case
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Serge,

On Tue, Jul 05, 2011 at 09:26 -0500, Serge Hallyn wrote:
> > diff --git a/ipc/shm.c b/ipc/shm.c
> > index 22006f1..3baae98 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -239,7 +239,23 @@ static int shm_try_destroy_current(int id, void *p, void *data)
> >  	if (IS_ERR(shp))
> >  		return 0;
> >  
> > -	if (shp->shm_cprid != task_tgid_vnr(current)) {
> > +	if (shp->shm_creator != current) {
> > +		shm_unlock(shp);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Mark it as orphaned to destroy the segment when
> > +	 * kernel.shm_forced_rmid is changed.
> > +	 * It is noop if the following shm_may_destroy() returns true.
> > +	 */
> > +	shp->shm_creator = NULL;
> 
> This function, shm_try_destroy_current(), only gets called by shm_exit()
> if the shm_forced_rmid is set, right?  So something funky can happen if
> first shm_forced_rmid is 0 and some get created and the creating tasks
> exits, then shm_forced_rmid gets set to one, and the task pointer gets
> reused?

No, sinse this patch exit_shm() iterates all segments regardless of
shm_forced_rmid value (it is tried to _destroy_ the segment only if
shm_forced_rmid==1).  The ->shm_creator is set when the segment is
created and explicitly NULL'ed when the task exits.  As it has such
explicit rules, the ref counting is not needed at all.

Also ->shm_creator is not needed for anything, but for tracking whether
the creator has already exited, so keeping a reference neither to task
nor to pid is needed at all.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
