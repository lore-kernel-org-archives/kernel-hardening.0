From: ebiederm@xmission.com (Eric W. Biederman)
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com>
	<20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
	<CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
	<20170529083903.GA17735@infradead.org> <87h904xc26.fsf@xmission.com>
	<20170529102442.gerbzxzixllen46q@hirez.programming.kicks-ass.net>
	<87a85wvsxa.fsf@xmission.com>
Date: Mon, 29 May 2017 06:30:58 -0500
In-Reply-To: <87a85wvsxa.fsf@xmission.com> (Eric W. Biederman's message of
	"Mon, 29 May 2017 05:49:53 -0500")
Message-ID: <87o9ubvr0t.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

ebiederm@xmission.com (Eric W. Biederman) writes:

> Peter Zijlstra <peterz@infradead.org> writes:
>
>> On Mon, May 29, 2017 at 04:11:13AM -0500, Eric W. Biederman wrote:
>>
>>> Kees I I have a concern:
>>> 
>>> __must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r)
>>> {
>>>         unsigned int new, val = atomic_read(&r->refs);
>>> 
>>>         do {
>>>                 if (!val)
>>>                         return false;
>>> 
>>>                 if (unlikely(val == UINT_MAX))
>>>                         return true;
>>> 
>>>                 new = val + i;
>>>                 if (new < val)
>>>                         new = UINT_MAX;
>>> 
>>>         } while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
>>> 
>>>         WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
>>> 
>>>         return true;
>>> }
>>> 
>>> Why in the world do you succeed when you the value saturates????
>>
>> Why not? On saturation the object will leak and returning a reference to
>> it is always good.
>>
>>> From a code perspective that is bizarre.   The code already has to handle
>>> the case when the counter does not increment.
>>
>> I don't see it as bizarre, we turned an overflow/use-after-free into a
>> leak. That's the primary mechanism here.
>>
>> As long as we have a reference to a leaked object, we might as well use
>> it, its not going anywhere.
>>
>>> Fixing the return value would move refcount_t into the realm of
>>> something that is desirable because it has bettern semantics and
>>> is more useful just on a day to day correctness point of view.  Even
>>> ignoring the security implications.
>>
>> It changes the semantics between inc_not_zero() and inc(). It also
>> complicates the semantics of inc_not_zero(), where currently the failure
>> implies the count is 0 and means no-such-object, you complicate matters
>> by basically returning 'busy'.
>
> Busy is not a state of a reference count.
>
> It is true I am suggesting treating something with a saturated reference
> as not available.  If that is what you mean by busy.  But if it's
> reference is zero it is also not available.  So there is no practical
> difference.
>
>> That is a completely new class of failure that is actually hard to deal
>> with, not to mention that it completely destroys refcount_inc_not_zero()
>> being a 'simple' replacement for atomic_inc_not_zero().
>>
>> In case of the current failure, the no-such-object, we can fix that by
>> creating said object. But what to do on 'busy' ? Surely you don't want
>> to create another. You'd have to somehow retrofit something to wait on
>> in every user.
>
> Using little words.
>
> A return of true from inc_not_zero means we took a reference.
> A return of false means we did not take a reference.
>
> The code already handles I took a reference or I did not take a
> reference.
>
> Therefore lying with refcount_t is not helpful.  It takes failures
> the code could easily handle and turns them into leaks.
>
> At least that is how I have seen reference counts used.  And those
> are definitely the plane obivous semantics.
>
> Your changes are definitely not drop in replacements for atomic_t in my
> code.

To clarify.

If my code uses atomic_inc it does not expect a failure of any sort
and saturate semantics are a fine replacement.

If my code uses atomic_inc_not_zero it knows how to handle a failure
to take a reference count.  Making hiding the failure really bizarre.

A must check function that hides a case I can handle and requires
checking in a case where my code is built not to check is a drop in
replacement for neither.

So anyone who is proposing a refcount_t change as a drop in replacement
for any code I maintain I will nack on sight because refcount_t is not
currently a no-brain drop in replacement.

Eric
