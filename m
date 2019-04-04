Date: Thu, 4 Apr 2019 16:31:55 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190404203155.GA30488@google.com>
References: <20190404152314.GG14111@linux.ibm.com>
 <Pine.LNX.4.44L0.1904041138070.1288-100000@iolanthe.rowland.org>
 <20190404180842.GB183378@google.com>
 <20190404181946.GJ14111@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404181946.GJ14111@linux.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 04, 2019 at 11:19:46AM -0700, Paul E. McKenney wrote:
[snip]
> > > > > Further, from the herd simulator output (below), according to the "States",
> > > > > r1==1 means P1() AFAICS would have already finished the the read and set the
> > > > > r1 register to 1.  Then I am wondering why it couldn't take the branch to set
> > > > > *x to 2.  According to herd, r1 == 1 AND x == 1 is a perfectly valid state
> > > > > for the below program. I still couldn't see in my mind how for the below
> > > > > program, this is possible - in terms of compiler optimizations or other kinds
> > > > > of ordering. Because there is a smp_mb() between the 2 plain writes in P0()
> > > > > and P1() did establish that r1 is 1 in the positive case. :-/.  I am surely
> > > > > missing something :-)
> > > > > 
> > > > > ---8<-----------------------
> > > > > C Joel-put_pid
> > > > > 
> > > > > {}
> > > > > 
> > > > > P0(int *x, int *y)
> > > > > {
> > > > > 	*x = 1;
> > > > > 	smp_mb();
> > > > > 	*y = 1;
> > > > > }
> > > > > 
> > > > > P1(int *x, int *y)
> > > > > {
> > > > > 	int r1;
> > > > > 
> > > > > 	r1 = READ_ONCE(*y);
> > > > > 	if (r1)
> > > > > 		WRITE_ONCE(*x, 2);
> > > > > }
> > > > > 
> > > > > exists (1:r1=1 /\ ~x=2)
> > > > > 
> > > > > ---8<-----------------------
> > > > > Output:
> > > > > 
> > > > > Test Joel-put_pid Allowed
> > > > > States 3
> > > > > 1:r1=0; x=1;
> > > > > 1:r1=1; x=1;	<-- Can't figure out why r1=1 and x != 2 here.
> > > > 
> > > > I must defer to Alan on this, but my guess is that this is due to
> > > > the fact that there is a data race.
> > > 
> > > Yes, and because the plain-access/data-race patch for the LKMM was
> > > intended only to detect data races, not to be aware of all the kinds of
> > > ordering that plain accesses can induce.  I said as much at the start
> > > of the patch's cover letter and it bears repeating.
> > > 
> > > In this case it is certainly true that the "*x = 1" write must be
> > > complete before the value of *y is changed from 0.  Hence P1's
> > > WRITE_ONCE will certainly overwrite the 1 with 2, and the final value
> > > of *x will be 2 if r1=1.
> > > 
> > > But the notion of "visibility" of a write that I put into the LKMM
> > > patch only allows for chains of marked accesses.  Since "*y = 1" is a
> > > plain access, the model does not recognize that it can enforce the
> > > ordering between the two writes to *x.
> > > 
> > > Also, you must remember, the LKMM's prediction about whether an outcome
> > > will or will not occur are meaningless if a data race is present.  
> > > Therefore the most fundamental the answer to why the "1:r1=1; x=1;"  
> > > line is there is basically what Paul said: It's there because the
> > > herd model gets completely messed up by data races.
> > 
> > Makes sense to me. Thanks for the good work on this.
> > 
> > FWIW, thought to mention (feel free ignore the suggestion if its
> > meaningless): If there is any chance that the outcome can be better
> > outputted, like r1=X; x=1; Where X stands for the result of a data race, that
> > would be lovely.  I don't know much about herd internals (yet) to say if the
> > suggestion makes sense but as a user, it would certainly help reduce
> > confusion.
> 
> The "Flag data-race" that appeared in the herd output is your friend in
> this case.  If you see that in the output, that means that herd detected
> a data race, and the states output might or might not be reliable.

Thanks Paul and Alan, the "Flag data-race" indication sounds good to me. I
will watch out for that :)
 - Joel
