Date: Sat, 30 Mar 2019 11:16:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
In-Reply-To: <20190330023639.GA214473@google.com>
Message-ID: <Pine.LNX.4.44L0.1903301053080.18505-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Joel Fernandes <joel@joelfernandes.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 29 Mar 2019, Joel Fernandes wrote:

> On Thu, Mar 28, 2019 at 10:37:07AM -0700, Paul E. McKenney wrote:
> > On Thu, Mar 28, 2019 at 05:26:42PM +0100, Oleg Nesterov wrote:
> > > On 03/28, Jann Horn wrote:
> > > >
> > > > Since we're just talking about RCU stuff now, adding Paul McKenney to
> > > > the thread.
> > > 
> > > Since you added Paul let me add more confusion to this thread ;)
> > 
> > Woo-hoo!!!  More confusion!  Bring it on!!!  ;-)
> 
> Nice to take part in the confusion fun too!!! ;-)
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
> > As written, there is (in the strict sense) a data race between the load
> > of X in the BUG_ON() and CPU_0's store to X.  In a less strict sense,
> > you could of course argue that this data race is harmless, especially
> > if X is a single byte.  But the more I talk to compiler writers, the
> > less comfortable I become with data races in general.  :-/
> > 
> > So I would also feel better if the "Y = 1" was WRITE_ONCE().
> > 
> > On the other hand, this is a great opportunity to try out Alan Stern's
> > prototype plain-accesses patch to the Linux Kernel Memory Model (LKMM)!
> > 
> > https://lkml.kernel.org/r/Pine.LNX.4.44L0.1903191459270.1593-200000@iolanthe.rowland.org
> > 
> > Also adding Alan on CC.
> > 
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
> > ------------------------------------------------------------------------
> > 
> > Running this through herd with Alan's patch detects the data race
> > and says that the undesired outcome is allowed:
> > 
> > 	$ herd7  -conf linux-kernel.cfg /tmp/OlegNesterov-put_pid.litmus 
> > 	Test OlegNesterov-put_pid Allowed
> > 	States 3
> > 	1:r1=0; x=1;
> > 	1:r1=1; x=1;
> > 	1:r1=1; x=2;
> > 	Ok
> > 	Witnesses
> > 	Positive: 1 Negative: 2
> > 	Flag data-race
> > 	Condition exists (1:r1=1 /\ not (x=2))
> > 	Observation OlegNesterov-put_pid Sometimes 1 2
> > 	Time OlegNesterov-put_pid 0.00
> > 	Hash=a3e0043ad753effa860fea37eeba0a76
> > 
> > Using WRITE_ONCE() for P0()'s store to y still allows this outcome,
> > although it does remove the "Flag data-race".
> > 
> > Using WRITE_ONCE() for both P0()'s store to y and P1()'s store to x
> > gets rid of both the "Flag data-race" and the undesired outcome:
> > 
> > 	$ herd7  -conf linux-kernel.cfg /tmp/OlegNesterov-put_pid-WO-WO.litmus 
> > 	Test OlegNesterov-put_pid-WO-WO Allowed
> > 	States 2
> > 	1:r1=0; x=1;
> > 	1:r1=1; x=2;
> > 	No
> > 	Witnesses
> > 	Positive: 0 Negative: 2
> > 	Condition exists (1:r1=1 /\ not (x=2))
> > 	Observation OlegNesterov-put_pid-WO-WO Never 0 2
> > 	Time OlegNesterov-put_pid-WO-WO 0.01
> > 	Hash=6e1643e3c5e4739b590bde0a8e8a918e
> > 
> > Here is the corresponding litmus test, in case I messed something up:
> > 
> > ------------------------------------------------------------------------
> > C OlegNesterov-put_pid-WO-WO
> > 
> > {}
> > 
> > P0(int *x, int *y)
> > {
> > 	*x = 1;
> > 	smp_mb();
> > 	WRITE_ONCE(*y, 1);
> > }
> > 
> > P1(int *x, int *y)
> > {
> > 	int r1;
> > 
> > 	r1 = READ_ONCE(*y);
> > 	if (r1)
> > 		WRITE_ONCE(*x, 2);
> > }
> > 
> > exists (1:r1=1 /\ ~x=2)
> 
> I ran the above examples too. Its a bit confusing to me why the WRITE_ONCE in
> P0() is required,

If the "WRITE_ONCE(*y, 1)" in P0 were written instead as "*y = 1", it
would race with P1's "READ_ONCE(*y)".

>  and why would the READ_ONCE / WRITE_ONCE in P1() not be
> sufficient to prevent the exists condition. Shouldn't the compiler know that,
> in P0(), it should not reorder the store to y=1 before the x=1 because there
> is an explicit barrier between the 2 stores? Looks me to me like a broken
> compiler :-|. 
> 
> So I would have expected the following litmus to result in Never, but it
> doesn't with Alan's patch:
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
> 		WRITE_ONCE(*x, 2);
> }
> 
> exists (1:r1=1 /\ ~x=2)

You have to realize that in the presence of a data race, all bets are
off.  The memory model will still output a prediction, but there is no
guarantee that the prediction will be correct.

In this case P0's write to y races with P1's READ_ONCE.  Therefore the 
memory model may very will give an incorrect result.

> > ------------------------------------------------------------------------
> > 
> > > If not, then put_pid() needs atomic_read_acquire() as it was proposed in that
> > > discussion.
> > 
> > Good point, let's try with smp_load_acquire() in P1():
> > 
> > 	$ herd7  -conf linux-kernel.cfg /tmp/OlegNesterov-put_pid-WO-sla.litmus 
> > 	Test OlegNesterov-put_pid-WO-sla Allowed
> > 	States 2
> > 	1:r1=0; x=1;
> > 	1:r1=1; x=2;
> > 	No
> > 	Witnesses
> > 	Positive: 0 Negative: 2
> > 	Condition exists (1:r1=1 /\ not (x=2))
> > 	Observation OlegNesterov-put_pid-WO-sla Never 0 2
> > 	Time OlegNesterov-put_pid-WO-sla 0.01
> > 	Hash=4fb0276eabf924793dec1970199db3a6
> > 
> > This also works.  Here is the litmus test:
> > 
> > ------------------------------------------------------------------------
> > C OlegNesterov-put_pid-WO-sla
> > 
> > {}
> > 
> > P0(int *x, int *y)
> > {
> > 	*x = 1;
> > 	smp_mb();
> > 	WRITE_ONCE(*y, 1);
> > }
> > 
> > P1(int *x, int *y)
> > {
> > 	int r1;
> > 
> > 	r1 = smp_load_acquire(y);
> > 	if (r1)
> > 		*x = 2;
> > }
> > 
> > exists (1:r1=1 /\ ~x=2)
> > ------------------------------------------------------------------------
> > 
> > Demoting P0()'s WRITE_ONCE() to a plain write while leaving P1()'s
> > smp_load_acquire() gets us a data race and allows the undesired
> > outcome:
> 
> Yeah, I think this is also what I was confused about above, is why is that
> WRITE_ONCE required in P0() because there's already an smp_mb there. Surely
> I'm missing something. ;-)

A plain write to *y in P0 races with the smp_load_acquire in P1.  
That's all -- it's not very deep or subtle.  Remember, the definition
of a race is two concurrent accesses to the same variable from
different CPUs, where at least one of the accesses is plain and at
least one of them is a write.

I've heard that people on the C++ Standards committee have proposed
that plain writes should not race with marked reads.  That is, when
such concurrent accesses occur the outcome should be an undefined
result for the marked read rather than undefined behavior.  If this
change gets adopted and we put it into the memory model, then your
expectation would be correct.  But as things stand, it isn't.

Alan

> > 	$ herd7  -conf linux-kernel.cfg /tmp/OlegNesterov-put_pid-sla.litmus 
> > 	Test OlegNesterov-put_pid-sla Allowed
> > 	States 3
> > 	1:r1=0; x=1;
> > 	1:r1=1; x=1;
> > 	1:r1=1; x=2;
> > 	Ok
> > 	Witnesses
> > 	Positive: 1 Negative: 2
> > 	Flag data-race
> > 	Condition exists (1:r1=1 /\ not (x=2))
> > 	Observation OlegNesterov-put_pid-sla Sometimes 1 2
> > 	Time OlegNesterov-put_pid-sla 0.01
> > 	Hash=ec6f71f3d9f7cd6e45a874c872e3d946
> > 
> > But what if you are certain that the compiler cannot mess up your use
> > of plain C-language loads and stores?  Then simply tell LKMM that they
> > are READ_ONCE() and WRITE_ONCE(), respectively.  LKMM is admittedly
> > somewhat paranoid, but real C compilers really do tear stores of certain
> > constants on systems (like x86) that have store-immediate instructions,
> > so a bit of paranoia is not misplaced here.  ;-)
> > 
> > Plus please note that this patch to LKMM is prototype and thus subject
> > to change.
> 
> Ah I see. Appreciate if Alan can also CC me on future posting of this since
> I'm quite interested. ;-)
> 
> thanks,
> 
>  - Joel
