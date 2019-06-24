MIME-Version: 1.0
References: <20190624184534.209896-1-joel@joelfernandes.org> <20190624185214.GA211230@google.com>
In-Reply-To: <20190624185214.GA211230@google.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 24 Jun 2019 21:10:15 +0200
Message-ID: <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
Content-Type: text/plain; charset="UTF-8"
To: Joel Fernandes <joel@joelfernandes.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Elena Reshetova <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michal Hocko <mhocko@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 24, 2019 at 8:52 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> On Mon, Jun 24, 2019 at 02:45:34PM -0400, Joel Fernandes (Google) wrote:
> > struct pid's count is an atomic_t field used as a refcount. Use
> > refcount_t for it which is basically atomic_t but does additional
> > checking to prevent use-after-free bugs.
> >
> > For memory ordering, the only change is with the following:
> >  -    if ((atomic_read(&pid->count) == 1) ||
> >  -         atomic_dec_and_test(&pid->count)) {
> >  +    if (refcount_dec_and_test(&pid->count)) {
> >               kmem_cache_free(ns->pid_cachep, pid);
> >
> > Here the change is from:
> > Fully ordered --> RELEASE + ACQUIRE (as per refcount-vs-atomic.rst)
> > This ACQUIRE should take care of making sure the free happens after the
> > refcount_dec_and_test().
> >
> > The above hunk also removes atomic_read() since it is not needed for the
> > code to work and it is unclear how beneficial it is. The removal lets
> > refcount_dec_and_test() check for cases where get_pid() happened before
> > the object was freed.
[...]
> I had a question about refcount_inc().
>
> As per Documentation/core-api/refcount-vs-atomic.rst , it says:
>
> A control dependency (on success) for refcounters guarantees that
> if a reference for an object was successfully obtained (reference
> counter increment or addition happened, function returned true),
> then further stores are ordered against this operation.
>
> However, in refcount_inc() I don't see any memory barriers (in the case where
> CONFIG_REFCOUNT_FULL=n). Is the documentation wrong?

That part of the documentation only talks about cases where you have a
control dependency on the return value of the refcount operation. But
refcount_inc() does not return a value, so this isn't relevant for
refcount_inc().

Also, AFAIU, the control dependency mentioned in the documentation has
to exist *in the caller* - it's just pointing out that if you write
code like the following, you have a control dependency between the
refcount operation and the write:

    if (refcount_inc_not_zero(&obj->refcount)) {
      WRITE_ONCE(obj->x, y);
    }

For more information on the details of this stuff, try reading the
section "CONTROL DEPENDENCIES" of Documentation/memory-barriers.txt.
