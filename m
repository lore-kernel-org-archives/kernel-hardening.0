Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 30 Jun 2011 17:57:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110630135718.GA13406@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630134855.GA6165@mail.hallyn.com>
Subject: [kernel-hardening] Re: + ipc-introduce-shm_rmid_forced-sysctl.patch added to -mm tree
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Serge,

On Thu, Jun 30, 2011 at 08:48 -0500, Serge Hallyn wrote:
> Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> > +static int shm_try_destroy_orphaned(int id, void *p, void *data)
> > +{
> > +	struct ipc_namespace *ns = data;
> > +	struct shmid_kernel *shp = shm_lock(ns, id);
> > +	struct task_struct *task;
> > +
> > +	if (IS_ERR(shp))
> > +		return 0;
> > +
> > +	/*
> > +	 * We want to destroy segments without users and with already
> > +	 * exit'ed originating process.
> > +	 *
> > +	 * XXX: the originating process may exist in another pid namespace.
> > +	 */
> 
> (Sorry, I no longer have the original patch.  I'd meant to take a closer
> look at the time...)
> 
> So shp should store a reference to the struct pid, which you can check
> here?  I think that'll do exactly what you need.

Documentation/namespaces/compatibility-list.txt says that IPC and PID
namespaces have not been fully separated yet.  This is a core problem.
If I store a reference to pid namespace, it would solve only this little
problem, but the global problem of pid vs. ipc namespaces is left
unsolved.  It would be much more consistent to fix the whole ipc code in
one step (if ever).


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
