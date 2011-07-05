Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Jul 2011 09:26:59 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
Message-ID: <20110705142659.GA18290@peqn>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704115523.GA11252@albatros>
Subject: [kernel-hardening] Re: [PATCH] shm: handle separate PID namespaces case
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Vasiliy Kulikov (segoon@openwall.com):
> shm_try_destroy_orphaned() and shm_try_destroy_current() didn't handle
> the case of separate PID namespaces, but a single IPC namespace.  If
> there are tasks with the same PID values using the same shmem object,
> the wrong destroy decision could be reached.
> 
> On shm segment creation store the pointer to the creator task in
> shmid_kernel->shm_creator field and zero it on task exit.  Then
> use the ->shm_creator insread of ->shm_cprid in both functions.
> As shmid_kernel object is already locked at this stage, no additional
> locking is needed.

Thanks, Vasiliy.  Sounds like the Documentation/ file could stand some
clarification.

A concern below, though:

> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  include/linux/shm.h |    3 +++
>  ipc/shm.c           |   27 ++++++++++++++++++++-------
>  2 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/shm.h b/include/linux/shm.h
> index b030a4e..12d2234 100644
> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -95,6 +95,9 @@ struct shmid_kernel /* private to the kernel */
>  	pid_t			shm_cprid;
>  	pid_t			shm_lprid;
>  	struct user_struct	*mlock_user;
> +
> +	/* The task created the shm object.  NULL if the task is dead. */
> +	struct task_struct	*shm_creator;
>  };
>  
>  /* shm_mode upper byte flags */
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 22006f1..3baae98 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -239,7 +239,23 @@ static int shm_try_destroy_current(int id, void *p, void *data)
>  	if (IS_ERR(shp))
>  		return 0;
>  
> -	if (shp->shm_cprid != task_tgid_vnr(current)) {
> +	if (shp->shm_creator != current) {
> +		shm_unlock(shp);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Mark it as orphaned to destroy the segment when
> +	 * kernel.shm_forced_rmid is changed.
> +	 * It is noop if the following shm_may_destroy() returns true.
> +	 */
> +	shp->shm_creator = NULL;

This function, shm_try_destroy_current(), only gets called by shm_exit()
if the shm_forced_rmid is set, right?  So something funky can happen if
first shm_forced_rmid is 0 and some get created and the creating tasks
exits, then shm_forced_rmid gets set to one, and the task pointer gets
reused?

Using a struct pid may still be the best bet.  It's much lighter-weight
than a task struct, so keeping a ref shouldn't much matter.  It'll
avoid this wraparound issue (assuming I'm not imagining that issue).
Struct pid is namespace-safe, and you can still do your simple, quick
pointer comparison.

> +	/*
> +	 * Don't even try to destroy it.  If shm_forced_rmid=0 and IPC_RMID
> +	 * is not set, it shouldn't be deleted here.
> +	 */
> +	if (!ns->shm_forced_rmid) {
>  		shm_unlock(shp);
>  		return 0;
>  	}
> @@ -255,7 +271,6 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
>  {
>  	struct ipc_namespace *ns = data;
>  	struct shmid_kernel *shp = shm_lock(ns, id);
> -	struct task_struct *task;
>  
>  	if (IS_ERR(shp))
>  		return 0;
> @@ -263,11 +278,8 @@ static int shm_try_destroy_orphaned(int id, void *p, void *data)
>  	/*
>  	 * We want to destroy segments without users and with already
>  	 * exit'ed originating process.
> -	 *
> -	 * XXX: the originating process may exist in another pid namespace.
>  	 */
> -	task = find_task_by_vpid(shp->shm_cprid);
> -	if (task != NULL) {
> +	if (shp->shm_creator != NULL) {
>  		shm_unlock(shp);
>  		return 0;
>  	}
> @@ -295,7 +307,7 @@ void exit_shm(struct task_struct *task)
>  	if (!nsp)
>  		return;
>  	ns = nsp->ipc_ns;
> -	if (!ns || !ns->shm_forced_rmid)
> +	if (!ns)
>  		return;
>  
>  	/* Destroy all already created segments, but not mapped yet */
> @@ -494,6 +506,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>  	shp->shm_segsz = size;
>  	shp->shm_nattch = 0;
>  	shp->shm_file = file;
> +	shp->shm_creator = current;
>  	/*
>  	 * shmid gets reported as "inode#" in /proc/pid/maps.
>  	 * proc-ps tools use this. Changing this will break them.
> -- 
> 1.7.0.4
