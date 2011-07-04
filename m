Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 4 Jul 2011 17:37:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20110704153757.GA9078@redhat.com>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org> <20110630134855.GA6165@mail.hallyn.com> <20110630135718.GA13406@albatros> <20110703180028.GA26742@albatros> <20110704115523.GA11252@albatros> <20110704150513.GA6893@redhat.com> <20110704152636.GA21350@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704152636.GA21350@albatros>
Subject: [kernel-hardening] Re: [PATCH] shm: handle separate PID namespaces case
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: akpm@linux-foundation.org, Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 07/04, Vasiliy Kulikov wrote:
>
> On Mon, Jul 04, 2011 at 17:05 +0200, Oleg Nesterov wrote:
> > On 07/04, Vasiliy Kulikov wrote:
> > >
> > > @@ -239,7 +239,23 @@ static int shm_try_destroy_current(int id, void *p, void *data)
> > >  	if (IS_ERR(shp))
> > >  		return 0;
> > >
> > > -	if (shp->shm_cprid != task_tgid_vnr(current)) {
> > > +	if (shp->shm_creator != current) {
> > > +		shm_unlock(shp);
> > > +		return 0;
> >
> > I know absolutely nothing about ipc/, so probably I am wrong. But do
> > we really need shm_lock()
>
> It is needed to protect against parallel reads.  To read one may just
> hold shm_lock, but to write both shm_lock and rw_mutex are needed.

Hmm. Still can't understand... Once again, it seems to me we can
check shp->shm_creator != current and return lockless. Or do you
think without shm_lock() we can see the false positive?

If shp->shm_creator was current, it was set by use, we can't miss
this shp. Of course, if we are going to shm_destroy() then we need
shm_lock().

Thanks,

Oleg.
