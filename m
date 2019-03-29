Date: Thu, 28 Mar 2019 22:24:38 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190329022438.GA194158@google.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com>
 <CAG48ez2bbSYpNHcC4oucx_AG=5y4K5pZfSOfN3mxGadJGpHuQQ@mail.gmail.com>
 <20190328143738.GA261521@google.com>
 <CAG48ez1-3dLvzQoxxoUzTUq8dc1wwvwPBBxX_X9FWMscWTS-FQ@mail.gmail.com>
 <20190328200052.GA105221@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328200052.GA105221@google.com>
To: Jann Horn <jannh@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 28, 2019 at 04:00:52PM -0400, Joel Fernandes wrote:
> On Thu, Mar 28, 2019 at 04:17:50PM +0100, Jann Horn wrote:
> > Since we're just talking about RCU stuff now, adding Paul McKenney to
> > the thread.
> > 
> > On Thu, Mar 28, 2019 at 3:37 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > On Thu, Mar 28, 2019 at 03:57:44AM +0100, Jann Horn wrote:
> > > > On Thu, Mar 28, 2019 at 3:34 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > > > > On Thu, Mar 28, 2019 at 01:59:45AM +0100, Jann Horn wrote:
> > > > > > On Thu, Mar 28, 2019 at 1:06 AM Kees Cook <keescook@chromium.org> wrote:
> > > > > > > On Wed, Mar 27, 2019 at 7:53 AM Joel Fernandes (Google)
> > > > > > > <joel@joelfernandes.org> wrote:
> > > > > > > >
> > > > > > > > struct pid's count is an atomic_t field used as a refcount. Use
> > > > > > > > refcount_t for it which is basically atomic_t but does additional
> > > > > > > > checking to prevent use-after-free bugs. No change in behavior if
> > > > > > > > CONFIG_REFCOUNT_FULL=n.
> > > > > > > >
> > > > > > > > Cc: keescook@chromium.org
> > > > > > > > Cc: kernel-team@android.com
> > > > > > > > Cc: kernel-hardening@lists.openwall.com
> > > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > > > > [...]
> > > > > > > > diff --git a/kernel/pid.c b/kernel/pid.c
> > > > > > > > index 20881598bdfa..2095c7da644d 100644
> > > > > > > > --- a/kernel/pid.c
> > > > > > > > +++ b/kernel/pid.c
> > > > > > > > @@ -37,7 +37,7 @@
> > > > > > > >  #include <linux/init_task.h>
> > > > > > > >  #include <linux/syscalls.h>
> > > > > > > >  #include <linux/proc_ns.h>
> > > > > > > > -#include <linux/proc_fs.h>
> > > > > > > > +#include <linux/refcount.h>
> > > > > > > >  #include <linux/sched/task.h>
> > > > > > > >  #include <linux/idr.h>
> > > > > > > >
> > > > > > > > @@ -106,8 +106,8 @@ void put_pid(struct pid *pid)
> > > > > > > >                 return;
> > > > > > > >
> > > > > > > >         ns = pid->numbers[pid->level].ns;
> > > > > > > > -       if ((atomic_read(&pid->count) == 1) ||
> > > > > > > > -            atomic_dec_and_test(&pid->count)) {
> > > > > > > > +       if ((refcount_read(&pid->count) == 1) ||
> > > > > > > > +            refcount_dec_and_test(&pid->count)) {
> > > > > > >
> > > > > > > Why is this (and the original code) safe in the face of a race against
> > > > > > > get_pid()? i.e. shouldn't this only use refcount_dec_and_test()? I
> > > > > > > don't see this code pattern anywhere else in the kernel.
> > > > > >
> > > > > > Semantically, it doesn't make a difference whether you do this or
> > > > > > leave out the "refcount_read(&pid->count) == 1". If you read a 1 from
> > > > > > refcount_read(), then you have the only reference to "struct pid", and
> > > > > > therefore you want to free it. If you don't get a 1, you have to
> > > > > > atomically drop a reference, which, if someone else is concurrently
> > > > > > also dropping a reference, may leave you with the last reference (in
> > > > > > the case where refcount_dec_and_test() returns true), in which case
> > > > > > you still have to take care of freeing it.
> > > > >
> > > > > Also, based on Kees comment, I think it appears to me that get_pid and
> > > > > put_pid can race in this way in the original code right?
> > > > >
> > > > > get_pid                 put_pid
> > > > >
> > > > >                         atomic_dec_and_test returns 1
> > > >
> > > > This can't happen. get_pid() can only be called on an existing
> > > > reference. If you are calling get_pid() on an existing reference, and
> > > > someone else is dropping another reference with put_pid(), then when
> > > > both functions start running, the refcount must be at least 2.
> > >
> > > Sigh, you are right. Ok. I was quite tired last night when I wrote this.
> > > Obviously, I should have waited a bit and thought it through.
> > >
> > > Kees can you describe more the race you had in mind?
> > >
> > > > > atomic_inc
> > > > >                         kfree
> > > > >
> > > > > deref pid /* boom */
> > > > > -------------------------------------------------
> > > > >
> > > > > I think get_pid needs to call atomic_inc_not_zero() and put_pid should
> > > > > not test for pid->count == 1 as condition for freeing, but rather just do
> > > > > atomic_dec_and_test. So something like the following diff. (And I see a
> > > > > similar pattern used in drivers/net/mac.c)
> > > >
> > > > get_pid() can only be called when you already have a refcounted
> > > > reference; in other words, when the reference count is at least one.
> > > > The lifetime management of struct pid differs from the lifetime
> > > > management of most other objects in the kernel; the usual patterns
> > > > don't quite apply here.
> > > >
> > > > Look at put_pid(): When the refcount has reached zero, there is no RCU
> > > > grace period (unlike most other objects with RCU-managed lifetimes).
> > > > Instead, free_pid() has an RCU grace period *before* it invokes
> > > > delayed_put_pid() to drop a reference; and free_pid() is also the
> > > > function that removes a PID from the namespace's IDR, and it is used
> > > > by __change_pid() when a task loses its reference on a PID.
> > > >
> > > > In other words: Most refcounted objects with RCU guarantee that the
> > > > object waits for a grace period after its refcount has reached zero;
> > > > and during the grace period, the refcount is zero and you're not
> > > > allowed to increment it again.
> > >
> > > Can you give an example of this "most refcounted objects with RCU" usecase?
> > > I could not find any good examples of such. I want to document this pattern
> > > and possibly submit to Documentation/RCU.
> > 
> > E.g. struct posix_acl is a relatively straightforward example:
> > posix_acl_release() is a wrapper around refcount_dec_and_test(); if
> > the refcount has dropped to zero, the object is released after an RCU
> > grace period using kfree_rcu().
> > get_cached_acl() takes an RCU read lock, does rcu_dereference() [with
> > a missing __rcu annotation, grmbl], and attempts to take a reference
> > with refcount_inc_not_zero().
> 
> Ok I get it now. It is quite a subtle difference in usage, I have noted both
> these usecases in my private notes for my own sanity ;-). I wonder if Paul
> thinks this is too silly to document into Documentation/RCU/, or if I should
> write-up something.
> 
> One thing I wonder is if one usage pattern is faster than the other.
> Certainly in the {get,put}_pid case, it seems nice to be able to do a
> get_pid even though free_pid's grace period has still not completed. Where as
> in the posix_acl case, once the grace period starts then it is no longer
> possible to get a reference as you pointed and its basically game-over for
> that object.

Wow, so I just found that Documentation/RCU/rcuref.txt already beautifully
talks about specifically both these RCU refcounting patterns - in the second
and third example.

I also found some issues with that document, so I will be submitting those
and CC you guys.

thanks!

 - Joel
