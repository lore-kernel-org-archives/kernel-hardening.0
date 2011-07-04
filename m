Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 19:26:36 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110704152636.GA21350@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110704150513.GA6893@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704150513.GA6893@redhat.com>
Subject: [kernel-hardening] Re: [PATCH] shm: handle separate PID namespaces case
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 04, 2011 at 17:05 +0200, Oleg Nesterov wrote:
> On 07/04, Vasiliy Kulikov wrote:
> >
> > @@ -239,7 +239,23 @@ static int shm_try_destroy_current(int id, void *p, void *data)
> >  	if (IS_ERR(shp))
> >  		return 0;
> >
> > -	if (shp->shm_cprid != task_tgid_vnr(current)) {
> > +	if (shp->shm_creator != current) {
> > +		shm_unlock(shp);
> > +		return 0;
> 
> I know absolutely nothing about ipc/, so probably I am wrong. But do
> we really need shm_lock()

It is needed to protect against parallel reads.  To read one may just
hold shm_lock, but to write both shm_lock and rw_mutex are needed.


> (which also another idr_find)

Yes, this is a waste of time, actually.  Directly locking
->shm_perm->lock is what is needed here and in shm_try_destroy_orphaned().


Thanks for looking into this!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
