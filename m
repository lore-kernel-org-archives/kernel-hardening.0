Date: Fri, 29 Mar 2019 18:32:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190329173209.GA23683@redhat.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com>
 <CAG48ez2bbSYpNHcC4oucx_AG=5y4K5pZfSOfN3mxGadJGpHuQQ@mail.gmail.com>
 <20190328143738.GA261521@google.com>
 <CAG48ez1-3dLvzQoxxoUzTUq8dc1wwvwPBBxX_X9FWMscWTS-FQ@mail.gmail.com>
 <20190328162641.GC19441@redhat.com>
 <20190328173707.GP4102@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328173707.GP4102@linux.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Alan Stern <stern@rowland.harvard.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/28, Paul E. McKenney wrote:
>
> On Thu, Mar 28, 2019 at 05:26:42PM +0100, Oleg Nesterov wrote:
> >
> > Since you added Paul let me add more confusion to this thread ;)
>
> Woo-hoo!!!  More confusion!  Bring it on!!!  ;-)

OK, thanks, you certainly managed to confused me much more than I expected!

> > There were some concerns about the lack of barriers in put_pid(), but I can't
> > find that old discussion and I forgot the result of that discussion...
> >
> > Paul, could you confirm that this code
> >
> > 	CPU_0		CPU_1
> >
> > 	X = 1;		if (READ_ONCE(Y))
> > 	mb();			X = 2;
> > 	Y = 1;		BUG_ON(X != 2);
> >
> >
> > is correct? I think it is, control dependency pairs with mb(), right?
>
> The BUG_ON() is supposed to happen at the end of time, correct?

Yes,

> As written, there is (in the strict sense) a data race between the load
> of X in the BUG_ON() and CPU_0's store to X.

Well, this pseudo code is simply wrong, I meant that "X = 1" on CPU 0
must not happen after "X = 2" on CPU 1 or we have a problem.


> But the more I talk to compiler writers, the
> less comfortable I become with data races in general.  :-/
>
> So I would also feel better if the "Y = 1" was WRITE_ONCE().

If we forget about potential compiler bugs, then it is not clear to me how
WRITE_ONCE() can help in this case. mb() implies the compiler barrier, and
we do not really need the "once" semantics?

But as for put_pid(), it actually does atomic_dec_and_test(&Y), so this is
probably not relevant.

> On the other hand, this is a great opportunity to try out Alan Stern's
> prototype plain-accesses patch to the Linux Kernel Memory Model (LKMM)!
>
> https://lkml.kernel.org/r/Pine.LNX.4.44L0.1903191459270.1593-200000@iolanthe.rowland.org

Heh. Will do, but only after I buy more brains.

> Here is what I believe is the litmus test that your are interested in:
>
> ------------------------------------------------------------------------
> C OlegNesterov-put_pid
>
> {}
>
> P0(int *x, int *y)
> {
> 	*x = 1;
> 	smp_mb();
> 	*y = 1;
> }
>
> P1(int *x, int *y)
> {
> 	int r1;
>
> 	r1 = READ_ONCE(*y);
> 	if (r1)
> 		*x = 2;
> }
>
> exists (1:r1=1 /\ ~x=2)

I am not familiar with litmus, and I do not really understand what (and why)
it reports.

> Running this through herd with Alan's patch detects the data race
> and says that the undesired outcome is allowed:

OK, so it says that "*x = 2" can happen before "*x = 1" even if P1() observes
*y == 1.

Still can't understand how this can happen... Nevermind ;)

> Using WRITE_ONCE() for both P0()'s store to y and P1()'s store to x
> gets rid of both the "Flag data-race" and the undesired outcome:

...

> P1(int *x, int *y)
> {
> 	int r1;
>
> 	r1 = READ_ONCE(*y);
> 	if (r1)
> 		WRITE_ONCE(*x, 2);
> }

And this is what Documentation/memory-barriers.txt says in the "CONTROL
DEPENDENCIES" section:

		q = READ_ONCE(a);
		if (q) {
			WRITE_ONCE(b, 1);
		}

	Control dependencies pair normally with other types of barriers.
	That said, please note that neither READ_ONCE() nor WRITE_ONCE()
	are optional!

but again, I fail to really understand why WRITE_ONCE() is not optional
in this particular case.

Thanks!

Oleg.
