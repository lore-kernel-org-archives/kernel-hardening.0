From: ebiederm@xmission.com (Eric W. Biederman)
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com>
	<20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
	<CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
	<20170529083903.GA17735@infradead.org>
Date: Mon, 29 May 2017 04:11:13 -0500
In-Reply-To: <20170529083903.GA17735@infradead.org> (Christoph Hellwig's
	message of "Mon, 29 May 2017 01:39:04 -0700")
Message-ID: <87h904xc26.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Christoph Hellwig <hch@infradead.org> writes:

> On Sat, May 27, 2017 at 12:58:14PM -0700, Kees Cook wrote:
>> FAST_REFCOUNT=n: use function-based refcount_t with cmpxvhg and
>> full-verification
>> FAST_REFCOUNT=y without arch-specific implementation: use atomic_t
>> with no verification (i.e. no functional change from now)
>> FAST_REFCOUNT=y with arch-specific implementation: use atomic_t with
>> overflow protection
>> 
>> which means FAST_REFCOUNT would need to be default-on so that mm,
>> block, net users will remain happy.
>> 
>> Does that sound reasonable?
>
> I'd rather turn the options around so that the atomic_t or fast
> arch implementations are the defaul.  But either way it needs to
> be configurable.  Once that is done we can spread refcount_t everywhere
> and everyone will be better off, if only for the documentation value
> of the type when they use the atomic_t based implementation.

Agreed on the opposite default as opting into common library
implementations is how we typically handle things in linux.

Kees I I have a concern:

__must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r)
{
        unsigned int new, val = atomic_read(&r->refs);

        do {
                if (!val)
                        return false;

                if (unlikely(val == UINT_MAX))
                        return true;

                new = val + i;
                if (new < val)
                        new = UINT_MAX;

        } while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));

        WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");

        return true;
}

Why in the world do you succeed when you the value saturates????

>From a code perspective that is bizarre.   The code already has to handle
the case when the counter does not increment.

So since we already have to have that code to handle the failure to
increment I think it would make much more sense if the counters did not
only saturate but report failure when the counter can not increment.

Right now I am inclined to NACK refcount_t conversions because their
semantics don't make sense.  Which would seem to make the code less
correct by introducing bizarre corner cases instead of letting the code
use the it's existing handling of the failure to increment or decrement
the counter.

Fixing the return value would move refcount_t into the realm of
something that is desirable because it has bettern semantics and
is more useful just on a day to day correctness point of view.  Even
ignoring the security implications.

I suspect that would also make it easier for refcount_t implementations
to produce efficient code.

Eric
