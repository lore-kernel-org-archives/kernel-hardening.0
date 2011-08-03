Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 3 Aug 2011 23:52:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110803195258.GA7063@albatros>
References: <20110801180151.GA26686@albatros>
 <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros>
 <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
 <20110802124530.GA2543@albatros>
 <CA+55aFx_FMg2Y0jMrzYUpAqgxWFjxnFzzrqvysoqrYyz+Ue6BQ@mail.gmail.com>
 <20110803123352.88670c9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803123352.88670c9c.akpm@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [PATCH] shm: fix a race between
 shm_exit() and shm_init()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>, Kay Sievers <kay.sievers@vrfy.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 03, 2011 at 12:33 -0700, Andrew Morton wrote:
> > > +       /*
> > > +        * For init_ipc_ns shm_ids().rw_mutex is statically initialized
> > > +        * as kernel threads should be able to use it in do_exit() before
> > > +        * shm_init(), which is called on do_initcall()
> > > +        */
> > > +       if (ns == &init_ipc_ns)
> > > +                ipc_init_ids(&shm_ids(ns));
> > > +       else
> > > +               ipc_init_ids(&shm_ids(ns));
> 
> afacit init_ipc_ns.ids[0].rw_mutex and init_ipc_ns.ids[1].rw_mutex
> never get initialised with this patch?

No, these .rw_mutex are initialized in runtime, as before.


This patch should fix the specific oops (not a dependency issue):

https://lkml.org/lkml/2011/8/3/256


> Still.  It seems that the real bug is that driver_init() is trying to
> invoke userspace helpers before the kernel is ready to run userspace.

What if declare a completion, trigger it after all ns init code is
finished, and wait on the completion inside of
call_usermodehelper_exec()?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
