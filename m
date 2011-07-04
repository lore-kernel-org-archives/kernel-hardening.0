Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 4 Jul 2011 19:29:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20110704172945.GA14076@redhat.com>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org> <20110630134855.GA6165@mail.hallyn.com> <20110630135718.GA13406@albatros> <20110703180028.GA26742@albatros> <20110704115523.GA11252@albatros> <20110704150513.GA6893@redhat.com> <20110704152636.GA21350@albatros> <20110704153757.GA9078@redhat.com> <20110704170150.GA2806@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704170150.GA2806@albatros>
Subject: [kernel-hardening] Re: [PATCH] shm: optimize locking and ipc_namespace getting
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: akpm@linux-foundation.org, Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/04, Vasiliy Kulikov wrote:
>
> exit_shm() and shm_destroy_orphaned() may avoid the loop by checking
> whether there is at least one segment in current ipc_namespace.

Obviously I can't ack because I do not really understand this code,
but looks good to me.

Minor nit,

>  void exit_shm(struct task_struct *task)
>  {
> -	struct nsproxy *nsp = task->nsproxy;
> -	struct ipc_namespace *ns;
> -
> -	if (!nsp)
> -		return;
> -	ns = nsp->ipc_ns;
> -	if (!ns)
> -		return;
> +	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
>
>  	/* Destroy all already created segments, but not mapped yet */
>  	down_write(&shm_ids(ns).rw_mutex);
> -	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
> +	if (&shm_ids(ns).in_use)

Afaics, unlike shm_destroy_orphaned(), exit_shm() can check .in_use
lockless and thus avoid down_write() in the fast path. Given that
this sem is "global", I think this makes sense.

exit_shm() only cares about shmid_kernel's which were created by
current, we can't miss .in_use++ in ipc_addid(), it was called by us.
and thus we can't miss in_use != 0 although it is not stable without
the lock.

Oleg.
