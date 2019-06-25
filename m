Date: Tue, 25 Jun 2019 09:34:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
Message-ID: <20190625073407.GP3436@hirez.programming.kicks-ass.net>
References: <20190624184534.209896-1-joel@joelfernandes.org>
 <20190624185214.GA211230@google.com>
 <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>, kernel list <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@infradead.org>, Will Deacon <will.deacon@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Elena Reshetova <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michal Hocko <mhocko@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 24, 2019 at 09:10:15PM +0200, Jann Horn wrote:
> That part of the documentation only talks about cases where you have a
> control dependency on the return value of the refcount operation. But
> refcount_inc() does not return a value, so this isn't relevant for
> refcount_inc().
> 
> Also, AFAIU, the control dependency mentioned in the documentation has
> to exist *in the caller* - it's just pointing out that if you write
> code like the following, you have a control dependency between the
> refcount operation and the write:
> 
>     if (refcount_inc_not_zero(&obj->refcount)) {
>       WRITE_ONCE(obj->x, y);
>     }
> 
> For more information on the details of this stuff, try reading the
> section "CONTROL DEPENDENCIES" of Documentation/memory-barriers.txt.

IIRC the argument went as follows:

 - if you use refcount_inc(), you've already got a stable object and
   have ACQUIRED it otherwise, typically through locking.

 - if you use refcount_inc_not_zero(), you have a semi stable object
   (RCU), but you still need to ensure any changes to the object happen
   after acquiring a reference, and this is where the control dependency
   comes in as Jann already explained.

Specifically, it would be bad to allow STOREs to happen before we know
the refcount isn't 0, as that would be a UaF.

Also see the comment in lib/refcount.c.
