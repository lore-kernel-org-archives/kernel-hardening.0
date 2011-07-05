Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 5 Jul 2011 21:29:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110705172902.GA5626@albatros>
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
To: akpm@linux-foundation.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 04, 2011 at 15:55 +0400, Vasiliy Kulikov wrote:
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
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
[...]
> +	if (!ns->shm_forced_rmid) {

Oops, this patch is based on my old tree where it was shm_forced_rmid
instead of shm_rmid_forced.  I'll resend these 2 patches.  Sorry for the
noise...

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
