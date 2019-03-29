Date: Thu, 28 Mar 2019 22:34:56 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190329023456.GB194158@google.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com>
 <20190328142619.GA19441@redhat.com>
 <20190328143958.GB261521@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328143958.GB261521@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 28, 2019 at 10:39:58AM -0400, Joel Fernandes wrote:
> On Thu, Mar 28, 2019 at 03:26:19PM +0100, Oleg Nesterov wrote:
> > On 03/27, Joel Fernandes wrote:
> > >
> > > Also, based on Kees comment, I think it appears to me that get_pid and
> > > put_pid can race in this way in the original code right?
> > >
> > > get_pid			put_pid
> > >
> > > 			atomic_dec_and_test returns 1
> > > atomic_inc
> > > 			kfree
> > >
> > > deref pid /* boom */
> > > -------------------------------------------------
> > >
> > > I think get_pid needs to call atomic_inc_not_zero()
> > 
> > No.
> > 
> > get_pid() should only be used if you already have a reference or you do
> > something like
> > 
> > 	rcu_read_lock();
> > 	pid = find_vpid();
> > 	get_pid();
> > 	rcu_read_lock();
> > 
> > in this case we rely on call_rcu(delayed_put_pid) which drops the initial
> > reference.
> > 
> > If put_pid() sees pid->count == 1, then a) nobody else has a reference and
> > b) nobody else can find this pid on rcu-protected lists, so it is safe to
> > free it.
> 
> I agree. Check my reply to Jann, I already replied to him about this. thanks!
> 

Also Oleg, why not just call refcount_dec_and_test like below? If count is 1,
then it will decrement to 0 and return true anyway. Is this because we want
to avoid writes at the cost of more reads? Did I miss something? Thank you.

I don't remember very clearly, but I think Kees also asked about the same thing.

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
