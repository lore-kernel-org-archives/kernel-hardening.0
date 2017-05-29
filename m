Date: Mon, 29 May 2017 12:24:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170529102442.gerbzxzixllen46q@hirez.programming.kicks-ass.net>
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com>
 <20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
 <CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
 <20170529083903.GA17735@infradead.org>
 <87h904xc26.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h904xc26.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 29, 2017 at 04:11:13AM -0500, Eric W. Biederman wrote:

> Kees I I have a concern:
> 
> __must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r)
> {
>         unsigned int new, val = atomic_read(&r->refs);
> 
>         do {
>                 if (!val)
>                         return false;
> 
>                 if (unlikely(val == UINT_MAX))
>                         return true;
> 
>                 new = val + i;
>                 if (new < val)
>                         new = UINT_MAX;
> 
>         } while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
> 
>         WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
> 
>         return true;
> }
> 
> Why in the world do you succeed when you the value saturates????

Why not? On saturation the object will leak and returning a reference to
it is always good.

> From a code perspective that is bizarre.   The code already has to handle
> the case when the counter does not increment.

I don't see it as bizarre, we turned an overflow/use-after-free into a
leak. That's the primary mechanism here.

As long as we have a reference to a leaked object, we might as well use
it, its not going anywhere.

> Fixing the return value would move refcount_t into the realm of
> something that is desirable because it has bettern semantics and
> is more useful just on a day to day correctness point of view.  Even
> ignoring the security implications.

It changes the semantics between inc_not_zero() and inc(). It also
complicates the semantics of inc_not_zero(), where currently the failure
implies the count is 0 and means no-such-object, you complicate matters
by basically returning 'busy'.

That is a completely new class of failure that is actually hard to deal
with, not to mention that it completely destroys refcount_inc_not_zero()
being a 'simple' replacement for atomic_inc_not_zero().

In case of the current failure, the no-such-object, we can fix that by
creating said object. But what to do on 'busy' ? Surely you don't want
to create another. You'd have to somehow retrofit something to wait on
in every user.
