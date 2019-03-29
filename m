Date: Fri, 29 Mar 2019 15:45:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
In-Reply-To: <20190329173209.GA23683@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1903291519060.1497-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 29 Mar 2019, Oleg Nesterov wrote:

> On 03/28, Paul E. McKenney wrote:
> >
> > On Thu, Mar 28, 2019 at 05:26:42PM +0100, Oleg Nesterov wrote:
> > >
> > > Since you added Paul let me add more confusion to this thread ;)
> >
> > Woo-hoo!!!  More confusion!  Bring it on!!!  ;-)
> 
> OK, thanks, you certainly managed to confused me much more than I expected!
> 
> > > There were some concerns about the lack of barriers in put_pid(), but I can't
> > > find that old discussion and I forgot the result of that discussion...
> > >
> > > Paul, could you confirm that this code
> > >
> > > 	CPU_0		CPU_1
> > >
> > > 	X = 1;		if (READ_ONCE(Y))
> > > 	mb();			X = 2;
> > > 	Y = 1;		BUG_ON(X != 2);
> > >
> > >
> > > is correct? I think it is, control dependency pairs with mb(), right?
> >
> > The BUG_ON() is supposed to happen at the end of time, correct?
> 
> Yes,
> 
> > As written, there is (in the strict sense) a data race between the load
> > of X in the BUG_ON() and CPU_0's store to X.
> 
> Well, this pseudo code is simply wrong, I meant that "X = 1" on CPU 0
> must not happen after "X = 2" on CPU 1 or we have a problem.

The situation is worse than that.  Strictly speaking, any time there is
a data race you have a problem.  In particular, the C11 Standard
permits a data race to cause undefined behavior.  For example, the
Standard wouldn't be violated if a data race caused your computer to
catch on fire.

In real life the situation isn't that bad, and you can do things the
Standard doesn't cover if you are very familiar with the properties of
the compiler.  But compilers change over time, so relying on special 
knowledge about it might not be a good idea in the long run.

> > But the more I talk to compiler writers, the
> > less comfortable I become with data races in general.  :-/
> >
> > So I would also feel better if the "Y = 1" was WRITE_ONCE().
> 
> If we forget about potential compiler bugs, then it is not clear to me how
> WRITE_ONCE() can help in this case. mb() implies the compiler barrier, and
> we do not really need the "once" semantics?

There is a big difference between WRITE_ONCE() and plain assignment.  
Given "WRITE_ONCE(X, 2)", the compiler will emit a simple store
instruction.  But given "X = 2", the compiler is allowed to emit
instructions equivalent to:

	if (X != 2)
		X = 2;

This is not a simple store; it also contains a load.  (And in some 
situations, a transformation like this might even be beneficial, 
because it can avoid a cache line transfer.)

CPUs are allowed to execute loads out of order with respect to control
dependencies.  So for example, if your pseudo-code for CPU_1 got
compiled to object code equivalent to:

	if (READ_ONCE(Y)) {
		if (X != 2)
			X = 2;
	}

then the CPU might read the value of X before reading the value of Y.  
This might not look like a problem, but it would be an example of a
race.

> But as for put_pid(), it actually does atomic_dec_and_test(&Y), so this is
> probably not relevant.
> 
> > On the other hand, this is a great opportunity to try out Alan Stern's
> > prototype plain-accesses patch to the Linux Kernel Memory Model (LKMM)!
> >
> > https://lkml.kernel.org/r/Pine.LNX.4.44L0.1903191459270.1593-200000@iolanthe.rowland.org
> 
> Heh. Will do, but only after I buy more brains.
> 
> > Here is what I believe is the litmus test that your are interested in:
> >
> > ------------------------------------------------------------------------
> > C OlegNesterov-put_pid
> >
> > {}
> >
> > P0(int *x, int *y)
> > {
> > 	*x = 1;
> > 	smp_mb();
> > 	*y = 1;
> > }
> >
> > P1(int *x, int *y)
> > {
> > 	int r1;
> >
> > 	r1 = READ_ONCE(*y);
> > 	if (r1)
> > 		*x = 2;
> > }
> >
> > exists (1:r1=1 /\ ~x=2)
> 
> I am not familiar with litmus, and I do not really understand what (and why)
> it reports.
> 
> > Running this through herd with Alan's patch detects the data race
> > and says that the undesired outcome is allowed:
> 
> OK, so it says that "*x = 2" can happen before "*x = 1" even if P1() observes
> *y == 1.
> 
> Still can't understand how this can happen... Nevermind ;)

You might imagine that the compiler could generate object code for P1() 
equivalent to:

	tmp = *x;
	*x = 2;
	if (!READ_ONCE(*y))
		*x = tmp;

Given this object code, P1 might indeed set *x to 2 before P0 sets *x
to 1.  I believe the Standard allows the compiler to do this sort of 
thing, although of course it would be a stupid thing to do.

Using plain accesses gives the compiler a tremendous amount of freedom
-- a lot more than many people think.

Alan

> > Using WRITE_ONCE() for both P0()'s store to y and P1()'s store to x
> > gets rid of both the "Flag data-race" and the undesired outcome:
> 
> ...
> 
> > P1(int *x, int *y)
> > {
> > 	int r1;
> >
> > 	r1 = READ_ONCE(*y);
> > 	if (r1)
> > 		WRITE_ONCE(*x, 2);
> > }
> 
> And this is what Documentation/memory-barriers.txt says in the "CONTROL
> DEPENDENCIES" section:
> 
> 		q = READ_ONCE(a);
> 		if (q) {
> 			WRITE_ONCE(b, 1);
> 		}
> 
> 	Control dependencies pair normally with other types of barriers.
> 	That said, please note that neither READ_ONCE() nor WRITE_ONCE()
> 	are optional!
> 
> but again, I fail to really understand why WRITE_ONCE() is not optional
> in this particular case.
> 
> Thanks!
> 
> Oleg.
