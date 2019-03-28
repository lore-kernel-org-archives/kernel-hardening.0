Date: Wed, 27 Mar 2019 22:34:32 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190328023432.GA93275@google.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 28, 2019 at 01:59:45AM +0100, Jann Horn wrote:
> On Thu, Mar 28, 2019 at 1:06 AM Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Mar 27, 2019 at 7:53 AM Joel Fernandes (Google)
> > <joel@joelfernandes.org> wrote:
> > >
> > > struct pid's count is an atomic_t field used as a refcount. Use
> > > refcount_t for it which is basically atomic_t but does additional
> > > checking to prevent use-after-free bugs. No change in behavior if
> > > CONFIG_REFCOUNT_FULL=n.
> > >
> > > Cc: keescook@chromium.org
> > > Cc: kernel-team@android.com
> > > Cc: kernel-hardening@lists.openwall.com
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > [...]
> > > diff --git a/kernel/pid.c b/kernel/pid.c
> > > index 20881598bdfa..2095c7da644d 100644
> > > --- a/kernel/pid.c
> > > +++ b/kernel/pid.c
> > > @@ -37,7 +37,7 @@
> > >  #include <linux/init_task.h>
> > >  #include <linux/syscalls.h>
> > >  #include <linux/proc_ns.h>
> > > -#include <linux/proc_fs.h>
> > > +#include <linux/refcount.h>
> > >  #include <linux/sched/task.h>
> > >  #include <linux/idr.h>
> > >
> > > @@ -106,8 +106,8 @@ void put_pid(struct pid *pid)
> > >                 return;
> > >
> > >         ns = pid->numbers[pid->level].ns;
> > > -       if ((atomic_read(&pid->count) == 1) ||
> > > -            atomic_dec_and_test(&pid->count)) {
> > > +       if ((refcount_read(&pid->count) == 1) ||
> > > +            refcount_dec_and_test(&pid->count)) {
> >
> > Why is this (and the original code) safe in the face of a race against
> > get_pid()? i.e. shouldn't this only use refcount_dec_and_test()? I
> > don't see this code pattern anywhere else in the kernel.
> 
> Semantically, it doesn't make a difference whether you do this or
> leave out the "refcount_read(&pid->count) == 1". If you read a 1 from
> refcount_read(), then you have the only reference to "struct pid", and
> therefore you want to free it. If you don't get a 1, you have to
> atomically drop a reference, which, if someone else is concurrently
> also dropping a reference, may leave you with the last reference (in
> the case where refcount_dec_and_test() returns true), in which case
> you still have to take care of freeing it.

Also, based on Kees comment, I think it appears to me that get_pid and
put_pid can race in this way in the original code right?

get_pid			put_pid

			atomic_dec_and_test returns 1
atomic_inc
			kfree

deref pid /* boom */
-------------------------------------------------

I think get_pid needs to call atomic_inc_not_zero() and put_pid should
not test for pid->count == 1 as condition for freeing, but rather just do
atomic_dec_and_test. So something like the following diff. (And I see a
similar pattern used in drivers/net/mac.c)

Is the above scenario valid? I didn't see any locking around get_pid or
pud_pid to avoid such a race.

---8<-----------------------

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 8cb86d377ff5..3d79834e3180 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -69,8 +69,8 @@ extern struct pid init_struct_pid;
 
 static inline struct pid *get_pid(struct pid *pid)
 {
-	if (pid)
-		refcount_inc(&pid->count);
+	if (!pid || !refcount_inc_not_zero(&pid->count))
+		return NULL;
 	return pid;
 }
 
diff --git a/kernel/pid.c b/kernel/pid.c
index 2095c7da644d..89c4849fab5d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -106,8 +106,7 @@ void put_pid(struct pid *pid)
 		return;
 
 	ns = pid->numbers[pid->level].ns;
-	if ((refcount_read(&pid->count) == 1) ||
-	     refcount_dec_and_test(&pid->count)) {
+	if (refcount_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
 	}
