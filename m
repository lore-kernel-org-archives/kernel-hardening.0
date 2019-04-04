Date: Thu, 4 Apr 2019 11:19:46 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
References: <20190404152314.GG14111@linux.ibm.com>
 <Pine.LNX.4.44L0.1904041138070.1288-100000@iolanthe.rowland.org>
 <20190404180842.GB183378@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404180842.GB183378@google.com>
Message-Id: <20190404181946.GJ14111@linux.ibm.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 04, 2019 at 02:08:42PM -0400, Joel Fernandes wrote:
> Thanks a lot Paul and Allen, I replied below.
> 
> On Thu, Apr 04, 2019 at 12:01:32PM -0400, Alan Stern wrote:
> > On Thu, 4 Apr 2019, Paul E. McKenney wrote:
> > 
> > > On Mon, Apr 01, 2019 at 05:11:39PM -0400, Joel Fernandes wrote:
> > 
> > > > > > So I would have expected the following litmus to result in Never, but it
> > > > > > doesn't with Alan's patch:
> > > > > > 
> > > > > > P0(int *x, int *y)
> > > > > > {
> > > > > > 	*x = 1;
> > > > > > 	smp_mb();
> > > > > > 	*y = 1;
> > > > > > }
> > > > > > 
> > > > > > P1(int *x, int *y)
> > > > > > {
> > > > > > 	int r1;
> > > > > > 
> > > > > > 	r1 = READ_ONCE(*y);
> > > > > > 	if (r1)
> > > > > > 		WRITE_ONCE(*x, 2);
> > > > > > }
> > > > > > 
> > > > > > exists (1:r1=1 /\ ~x=2)
> > > > > 
> > > > > The problem is that the compiler can turn both of P0()'s writes into reads:
> > > > > 
> > > > > P0(int *x, int *y)
> > > > > {
> > > > > 	if (*x != 1)
> > > > > 		*x = 1;
> > > > > 	smp_mb();
> > > > > 	if (*y != 1)
> > > > > 		*y = 1;
> > > > > }
> > > > > 
> > > > > These reads will not be ordered by smp_wmb(), so you have to do WRITE_ONCE()
> > > > > to get an iron-clad ordering guarantee.
> > > > 
> > > > But the snippet above has smp_mb() which does order writes, even for the
> > > > plain accesses.
> > > 
> > > True, but that code has a data race, namely P0()'s plain write to y
> > > races with P1()'s READ_ONCE().  Data races give the compiler absolutely
> > > astonishing levels of freedom to rearrange your code.  So, if you
> > > as a developer or maintainer choose to have data races, it is your
> > > responsibility to ensure that the compiler cannot mess you up.  So what
> > > you should do in that case is to list the transformed code the compiler's
> > > optimizations can produce and feed the corresponding litmus tests to LKMM,
> > > using READ_ONCE() and WRITE_ONCE() for the post-optimization accesses.
> > 
> > In this case, I strongly suspect the compiler would not mess up the
> > code badly enough to allow the unwanted end result.  But the LKMM tries
> > to avoid making strong assumptions about what compilers will or will
> > not do.
> 
> Here I was just trying to understand better how any kind of code
> transformation can cause an issue. Certainly I can see an issue if the
> compiler uses the memory location as a temporary variable as Paul pointed, to
> which I agree that a WRITE_ONCE is better. I am in favor of being careful,
> but here I was just trying to understand this better.
> 
> > > > I understand. Are we talking about load/store tearing being the issue here?
> > > > Even under load/store tearing, I feel the program will produce correct
> > > > results because r1 is either 0 or 1 (a single bit cannot be torn).
> > > 
> > > The compiler can (at least in theory) also transform *y = 1 as follows:
> > > 
> > > 	*y = r1; /* Use *y as temporary storage. */
> > > 	do_something();
> > > 	r1 = *y;
> > > 	*y = 1;
> > > 
> > > Here r1 is some register and do_something() is an inline function visible
> > > to the compiler (hence not implying barrier() upon call and return).
> > > 
> > > I don't know of any compilers that actually do this, but for me use
> > > of WRITE_ONCE() is a small price to pay to prevent all past, present,
> > > and future compiler from ever destroying^W optimizing my code in this way.
> > > 
> > > In your own code, if you dislike WRITE_ONCE() so much that you are willing
> > > to commit to (now and forever!!!) checking all applicable versions of
> > > compilers to make sure that they don't do this, well and good, knock
> > > yourself out.  But it is your responsibility to do that checking, and you
> > > can attest to LKMM that you have done so by giving LKMM litmus tests that
> > > substitute WRITE_ONCE() for that plain C-language assignment statement.
> > 
> > Remember that the LKMM does not produce strict bounds.  That is, the
> > LKMM will say that some outcomes are allowed even though no existing
> > compiler/CPU combination would ever actually produce them.  This litmus
> > test is an example.
> 
> Ok.
> 
> > > > Further, from the herd simulator output (below), according to the "States",
> > > > r1==1 means P1() AFAICS would have already finished the the read and set the
> > > > r1 register to 1.  Then I am wondering why it couldn't take the branch to set
> > > > *x to 2.  According to herd, r1 == 1 AND x == 1 is a perfectly valid state
> > > > for the below program. I still couldn't see in my mind how for the below
> > > > program, this is possible - in terms of compiler optimizations or other kinds
> > > > of ordering. Because there is a smp_mb() between the 2 plain writes in P0()
> > > > and P1() did establish that r1 is 1 in the positive case. :-/.  I am surely
> > > > missing something :-)
> > > > 
> > > > ---8<-----------------------
> > > > C Joel-put_pid
> > > > 
> > > > {}
> > > > 
> > > > P0(int *x, int *y)
> > > > {
> > > > 	*x = 1;
> > > > 	smp_mb();
> > > > 	*y = 1;
> > > > }
> > > > 
> > > > P1(int *x, int *y)
> > > > {
> > > > 	int r1;
> > > > 
> > > > 	r1 = READ_ONCE(*y);
> > > > 	if (r1)
> > > > 		WRITE_ONCE(*x, 2);
> > > > }
> > > > 
> > > > exists (1:r1=1 /\ ~x=2)
> > > > 
> > > > ---8<-----------------------
> > > > Output:
> > > > 
> > > > Test Joel-put_pid Allowed
> > > > States 3
> > > > 1:r1=0; x=1;
> > > > 1:r1=1; x=1;	<-- Can't figure out why r1=1 and x != 2 here.
> > > 
> > > I must defer to Alan on this, but my guess is that this is due to
> > > the fact that there is a data race.
> > 
> > Yes, and because the plain-access/data-race patch for the LKMM was
> > intended only to detect data races, not to be aware of all the kinds of
> > ordering that plain accesses can induce.  I said as much at the start
> > of the patch's cover letter and it bears repeating.
> > 
> > In this case it is certainly true that the "*x = 1" write must be
> > complete before the value of *y is changed from 0.  Hence P1's
> > WRITE_ONCE will certainly overwrite the 1 with 2, and the final value
> > of *x will be 2 if r1=1.
> > 
> > But the notion of "visibility" of a write that I put into the LKMM
> > patch only allows for chains of marked accesses.  Since "*y = 1" is a
> > plain access, the model does not recognize that it can enforce the
> > ordering between the two writes to *x.
> > 
> > Also, you must remember, the LKMM's prediction about whether an outcome
> > will or will not occur are meaningless if a data race is present.  
> > Therefore the most fundamental the answer to why the "1:r1=1; x=1;"  
> > line is there is basically what Paul said: It's there because the
> > herd model gets completely messed up by data races.
> 
> Makes sense to me. Thanks for the good work on this.
> 
> FWIW, thought to mention (feel free ignore the suggestion if its
> meaningless): If there is any chance that the outcome can be better
> outputted, like r1=X; x=1; Where X stands for the result of a data race, that
> would be lovely.  I don't know much about herd internals (yet) to say if the
> suggestion makes sense but as a user, it would certainly help reduce
> confusion.

The "Flag data-race" that appeared in the herd output is your friend in
this case.  If you see that in the output, that means that herd detected
a data race, and the states output might or might not be reliable.

							Thanx, Paul
