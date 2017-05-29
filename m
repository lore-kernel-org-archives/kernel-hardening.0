Date: Mon, 29 May 2017 14:13:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170529121335.wwt4ijuiabjhtjc3@hirez.programming.kicks-ass.net>
References: <1487590189-18151-1-git-send-email-elena.reshetova@intel.com>
 <20170303162352.b6af1c0c3115b3f5f1e7aed3@linux-foundation.org>
 <CAGXu5jKNChaVdfbM171FYkvY1hUMXG6cp-=WAdXBP0eTOO5RAA@mail.gmail.com>
 <20170529083903.GA17735@infradead.org>
 <87h904xc26.fsf@xmission.com>
 <20170529102442.gerbzxzixllen46q@hirez.programming.kicks-ass.net>
 <87a85wvsxa.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a85wvsxa.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 0/3] ipc subsystem refcounter conversions
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 29, 2017 at 05:49:53AM -0500, Eric W. Biederman wrote:

> > It changes the semantics between inc_not_zero() and inc(). It also
> > complicates the semantics of inc_not_zero(), where currently the failure
> > implies the count is 0 and means no-such-object, you complicate matters
> > by basically returning 'busy'.
> 
> Busy is not a state of a reference count.
> 
> It is true I am suggesting treating something with a saturated reference
> as not available.  If that is what you mean by busy.  But if it's
> reference is zero it is also not available.  So there is no practical
> difference.

There is. Previously when inc_not_zero() failed, you _knew_ it was 0 and
therefore know the object no longer 'exists'.

Similarly, if you know you're serialized against 1->0 you can then
assume it will not fail.

That goes out the window the moment you fail for any other condition.

> > That is a completely new class of failure that is actually hard to deal
> > with, not to mention that it completely destroys refcount_inc_not_zero()
> > being a 'simple' replacement for atomic_inc_not_zero().
> >
> > In case of the current failure, the no-such-object, we can fix that by
> > creating said object. But what to do on 'busy' ? Surely you don't want
> > to create another. You'd have to somehow retrofit something to wait on
> > in every user.
> 
> Using little words.
> 
> A return of true from inc_not_zero means we took a reference.
> A return of false means we did not take a reference.
> 
> The code already handles I took a reference or I did not take a
> reference.

I can well imagine code relying on the fact that failing to take a
reference means 0, see below. And once you start to fail for more
conditions, the actual value you failed on becomes interesting in order
to determine how to deal with it.

> Therefore lying with refcount_t is not helpful.

It is _NOT_ lying. It does as promised, it increments when it is not
zero. The fact that that increment can saturate is irrelevant. A
saturated reference is still a valid reference. Sure it causes a leak,
but who bloody cares, it shouldn't happen in the first place.

> It takes failures
> the code could easily handle and turns them into leaks.

That is the 'feature', we get to have leaks. Also those leaks _should_
not happen. They are a result of 'broken' code. So I don't see how
exposing them to the wider world helps anything but spread the pain of
the failure.

Please explain how the below is not subtly broken by changing
inc_not_zero.

struct obj *__obj_lookup(key)
{
	obj = rcu_based_lookup(key);
	if (refcount_inc_not_zero(&obj->ref))
		return obj;

	return NULL;
}

struct obj *obj_find_acquire(key)
{
	/* fast path, lockless lookup */

	rcu_read_lock()
	obj = __obj_lookup(key);
	rcu_read_unlock();

	if (obj)
		return obj;

	/* slow path, serialize */

	lock(&obj_lock);
	/* we're serialized, if it exists we must get a ref */
	obj = __obj_lookup(key);
	if (obj)
		goto unlock;

	/* allocate a new object and insert it */
	obj = obj_alloc();
	obj_init(obj, key);

unlock:
	unlock(&obj_lock);

	return obj;
}

> At least that is how I have seen reference counts used.  And those
> are definitely the plane obivous semantics.

I very strongly disagree. The one thing this primitive does is change
add/sub to be saturating, *consistently*.

You argue to expose the failure case, leading to more error paths
leading to more complication. I'll argue that nobody wants more error
handling, esp. for something that should not happen to begin with.

> Your changes are definitely not drop in replacements for atomic_t in my
> code.

refcount_t was never meant to be a drop-in replacement for atomic_t.
It is meant to be a fairly painless replacement for reference
counts that were previously implemented using atomic_t.

There is also the fairly common usage count scenario, that does not fit
well with refcount_t. I'm not sure we want to shoehorn that into
refcount_t either, we could create yet another type for that.

And there are of course a lot of less common things we're not wanting to
replace at all. atomic_t isn't broken we don't need to fix it.

I have no idea what you do so I cannot comment further.
