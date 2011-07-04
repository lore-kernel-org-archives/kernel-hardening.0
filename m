Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 21:51:53 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110704175153.GA3638@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
 <20110703180028.GA26742@albatros>
 <20110704115523.GA11252@albatros>
 <20110704150513.GA6893@redhat.com>
 <20110704152636.GA21350@albatros>
 <20110704153757.GA9078@redhat.com>
 <20110704170150.GA2806@albatros>
 <20110704172945.GA14076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704172945.GA14076@redhat.com>
Subject: Re: [kernel-hardening] Re: [PATCH] shm: optimize locking and
 ipc_namespace getting
To: kernel-hardening@lists.openwall.com
Cc: akpm@linux-foundation.org, Serge Hallyn <serge.hallyn@canonical.com>, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, rdunlap@xenotime.net, tj@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 04, 2011 at 19:29 +0200, Oleg Nesterov wrote:
> On 07/04, Vasiliy Kulikov wrote:
> > -	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
> > +	if (&shm_ids(ns).in_use)
> 
> Afaics, unlike shm_destroy_orphaned(), exit_shm() can check .in_use
> lockless and thus avoid down_write() in the fast path. Given that
> this sem is "global", I think this makes sense.
> 
> exit_shm() only cares about shmid_kernel's which were created by
> current, we can't miss .in_use++ in ipc_addid(), it was called by us.
> and thus we can't miss in_use != 0 although it is not stable without
> the lock.

I agree that if in some moment of shm_exit() .in_use is zero, we can
avoid the loop.  But is it guaranteed .in_use is assigned a value in an
atomic way?  I mean, e.g. if it was 0x00ff and becomes equal to 0x0100
is it possible .in_use's lower bytes are changed _before_ the high
bytes?  Then it can be observed as zero, when it logically is not.  Even
if it is guaranteed for some architectures, is it possible the implicit
atomicity is violated by some new architecture?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
