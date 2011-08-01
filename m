Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 1 Aug 2011 23:22:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110801192245.GA7202@albatros>
References: <20110801180151.GA26686@albatros>
 <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros>
 <20110801120750.5c0e6d2b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801120750.5c0e6d2b.akpm@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs.
 threads)
To: kernel-hardening@lists.openwall.com
Cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, torvalds@linux-foundation.org, Marc Zyngier <maz@misterjones.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 01, 2011 at 12:07 -0700, Andrew Morton wrote:
> On Mon, 1 Aug 2011 23:03:41 +0400
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
> > > Are we talking about init_ipc_ns.ids[] here?  If so, did you try
> > > initializing the three rwsems at compile-time?
> > > 
> > > That's rather a nasty hack though.  It'd be better to run the mystery
> > > init function before starting the threads.
> > 
> > Looks like it solves the race.
> 
> What patch are you talking about here?

Sorry for short sentences :)  I tried the patch you've suggested -
initialize rw_mutex in the init_ipc_ns declaration.  Surely, it solves a
specific race.  As no kernel threads actually use shm, other fields are
not needed to be initialized before do_initcall().

However, it is a bit ugly as it divides namespace initialization code
into init_ipc_ns initialization and other namespaces.  It's better to
use the same code for all namespaces (as it currently is).


> >  However, I think it should be solved on
> > another level.
> 
> What level?

I mean it is a bug of _implicit_ assume that kthreads don't use ns
related information.  So, AFAICS, it can be fixed 2 ways:

1) Move creations of kernel threads somewhere after namespaces
initializations in the init chain.

2) Deferring threads creation until all ns initialization is done.


> >  Other bugs might be hidden with this race.
> 
> What bugs?

I don't speak about specific bugs (I know the only one, which is this shm
related bug), but I suppose some threads might use some ns related
information as well.  At least I don't see whether it is somehow
explicitly denied currently.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
