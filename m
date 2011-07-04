Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 4 Jul 2011 17:05:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20110704150513.GA6893@redhat.com>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org> <20110630134855.GA6165@mail.hallyn.com> <20110630135718.GA13406@albatros> <20110703180028.GA26742@albatros> <20110704115523.GA11252@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704115523.GA11252@albatros>
Subject: [kernel-hardening] Re: [PATCH] shm: handle separate PID namespaces case
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: akpm@linux-foundation.org, Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/04, Vasiliy Kulikov wrote:
>
> @@ -239,7 +239,23 @@ static int shm_try_destroy_current(int id, void *p, void *data)
>  	if (IS_ERR(shp))
>  		return 0;
>
> -	if (shp->shm_cprid != task_tgid_vnr(current)) {
> +	if (shp->shm_creator != current) {
> +		shm_unlock(shp);
> +		return 0;

I know absolutely nothing about ipc/, so probably I am wrong. But do
we really need shm_lock() (which also another idr_find) to check
->shm_creator ? This is calles by idr_for_each() and afaics "void *p"
should match, no?

IOW, can't shm_try_destroy_current() do something like

	struct shmid_kernel *shp = container_of(p, shmid_kernel, shm_perm);

	if (shp->shm_creator != current)
		return;

	shm_lock();
	...

?

Just curious.

Oleg.
