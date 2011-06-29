Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 29 Jun 2011 15:14:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110629151436.9be479fb.akpm@linux-foundation.org>
In-Reply-To: <20110622152514.GA9521@albatros>
References: <20110622152514.GA9521@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 22 Jun 2011 19:25:14 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> This patch adds support for shm_rmid_forced sysctl.  If set to 1, all
> shared memory objects in current ipc namespace will be automatically
> forced to use IPC_RMID.  POSIX way of handling shmem allows to create
> shm objects and call shmdt() leaving shm object associated with no
> process, thus consuming memory not counted via rlimits.  With
> shm_rmid_forced=1 the shared memory object is counted at least for one
> process, so OOM killer may effectively kill the fat process holding
> the shared memory.
> 
> It obviously breaks POSIX, some programs relying on the feature would
> stop working.  So, set shm_rmid_forced=1 only if you're sure nobody uses
> "orphaned" memory.  shm_rmid_forced=0 by default for compatability
> reasons.
> 
> The feature was previously impemented in -ow as a configure option.
> 

What a horrid patch.  But given the POSIX (mis?)feature I don't see a
better way, and the feature seems desirable.  Sigh.

What sort of users would want to turn this on, and why?

> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -44,6 +44,7 @@ struct ipc_namespace {
>  	size_t		shm_ctlall;
>  	int		shm_ctlmni;
>  	int		shm_tot;
> +	int		shm_rmid_forced;
>  
>  	struct notifier_block ipcns_nb;

Please send a patch which adds a nice comment to this field.

Perhaps shm_rmid_forced should have had bool type.

> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *ns)
>  	ns->shm_ctlmax = SHMMAX;
>  	ns->shm_ctlall = SHMALL;
>  	ns->shm_ctlmni = SHMMNI;
> +	ns->shm_rmid_forced = 0;
>  	ns->shm_tot = 0;
>  	ipc_init_ids(&shm_ids(ns));
>  }

The problem is that nobody will test your feature.  So for testing
purposes, let's enable the feature by default.  I assume this:

--- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl-ipc-introduce-shm_rmid_forced-sysctl-testing
+++ a/ipc/shm.c
@@ -74,7 +74,7 @@ void shm_init_ns(struct ipc_namespace *n
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
-	ns->shm_rmid_forced = 0;
+	ns->shm_rmid_forced = 1;
 	ns->shm_tot = 0;
 	ipc_init_ids(&shm_ids(ns));
 }

will do that?

> +static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
> +{
> +	return (shp->shm_nattch == 0) &&
> +	       (ns->shm_rmid_forced ||
> +		(shp->shm_perm.mode & SHM_DEST));
> +}

Just because the existing code is crappily documented doesn't mean that
we have to copy that ;)
