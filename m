Date: Fri, 20 Jan 2017 14:10:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170120131012.GQ6485@twins.programming.kicks-ass.net>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <20161230010627.GA9882@zzz>
 <20170103132136.GV3107@twins.programming.kicks-ass.net>
 <586EB8DB.30827.B1CCC7E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <586EB8DB.30827.B1CCC7E@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: PaX Team <pageexec@freemail.hu>
Cc: Eric Biggers <ebiggers3@gmail.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 05, 2017 at 10:21:31PM +0100, PaX Team wrote:
> On 3 Jan 2017 at 14:21, Peter Zijlstra wrote:
> 
> > Its not something that can be turned on or off, refcount_t is
> > unconditional code. But you raise a good point on the size of the thing.
> > 
> > I count 116 bytes on x86_64. If I disable all the debug crud...
> 
> ...then the whole thing loses its raison d'etre ;).

It does not, without the WARN() stuff it is still saturating and
avoiding use-after-free. If we fix WARN to not suck on x86 by for
example extending the "ud2" bugtable, it would not blow up the textsize
so much.

> > This is fundamentally not an atomic operation and therefore does not
> > belong in the atomic_* family, full stop.
> 
> i don't know why people keep repeating this myth but what exactly is not
> atomic in the PaX REFCOUNT feature? hint: it's all atomic ops based,
> there's no semantic change in there.
> 
> what is undesired behaviour (for the security goal, not the underlying
> atomic_t API!) is that the undo/saturation logic makes the whole dance
> visible to other CPUs

And therefore its not atomic. If intermediate state is observable its
not atomic. That's not a myth, that's the very definition of what atomic
is.

> > Not to mention that the whole wrap/unwrap or checked/unchecked split of
> > atomic_t is a massive trainwreck. Moving over to refcount_t, which has
> > simple and well defined semantics forces us to audit and cleanup all the
> > reference counting crud as it gets converted, this is a good thing.
> 
> while a noble goal your approach has two problems: one, it doesn't go
> nearly far enough, and two, what it does do currently is anything but
> clear (beyond the above discussed implementation problems). let me
> elaborate on both.
> 
> 1. the proper approach should be to separate the low-level implementation
> machinery from the higher level APIs exposed to users. the current low-level
> API is the atomic_t type and its accessors (including the 64/long variants)
> which is directly used by most code and there're few higher level abstractions
> on top of it. the proper low-level design should first of all separate the
> underlying type into signed/unsigned types as the conversions between the
> two make for a clumsy and error prone API to start with (just look at your
> own refcount_t API, you're abusing signed/unsigned conversions where one
> direction is implementation defined and allows a trap representation, is
> your code ready to handle that? not to mention that the C implementations
> of atomic_t trigger UB when signed overflow occurs).

Thing is, the Linux kernel isn't written in C as per the spec, it a C
dialect or C like language. By using -fno-strict-overflow and assuming
2s complement there is no UB.

(and I strongly believe removing UB from a language is a good thing)

> 2. your current refcount_t API is wrong and i think reflects a misunderstanding
> of what reference counts are about in general. in particular, checking for
> a 0 refcount value for any purpose other than freeing the underlying object
> makes no sense and means that the usage is not a refcount or the user has
> a UAF bug to start with (the check in kref_get is also nonsense for this
> reason).

_That_ UAF bug is the exact reason the WARN is there. People write buggy
code, warning them wherever possible is a good thing.

> this is because refcounts protect (account for) references/handles
> to an object, not the object itself. this also means that such references
> (think pointers in C) can only be created by *copying* an existing one but
> they cannot be made up out of thin air.

Which is exactly why get() on 0 is wrong and _should_ warn. I think
we very much agree on what a refcount is.

> now with this introduction tell me what sense does e.g., refcount_add_not_zero
> make? any refcount API should never even expose the underlying counter
> mechanism since refcounts are about references, not the counter underneath.
> that is, a proper refcount API would look like this:

Without language support (and there are a few proposals for both C and
C++) we're stuck with manual refcounts.

> // establishes the initial refcount of 0 (which doesn't mean 'freed object'
> // but 'no references, yet')
> // it's needed for object construction if the object may come from non-zero
> // initialized memory, otherwise ref_get should be used
> void ref_reset(objtype *ref);

Here we violently disagree. I pose that initialization should be !0,
after all, the act of creating the objects means you have a reference to
it.

In Bjarne's owner vs non-owner pointer types proposal, new<>() returns an
owner pointer, ie. refcount == 1.

The corollary is that then 0 becomes special to mean 'no concurrency' /
'dead'.

> // returns a copy of the reference if the refcount can be safely
> // incremented, NULL otherwise (or crash&burn, etc)
> objtype *ref_get(objtype *ref);

Without initializing to !0, I pose there is no way to tell if you can
safely increment. The current thing does WARN, Kees would like crash and
burn, but that's details.

> // decrements the refcount and free the object if it reached 0
> // dtor could be a field of objtype but that'd cost memory (if there are
> // more objects than ref_put callers which is the likely case in real life)
> // and is an attack surface (kref follows this model too)
> void ref_put(objtype *ref, destruct_t *dtor);
> 
> conceptually that is all you need to provide for refcount users (note that
> there's no leakage of the lower level implementation into the API, e.g., it
> can be lockless based on atomic_t or synchronized explicitly, all that is
> hidden from the users of the API).
> 
> any other need/usage is not a refcount and needs its own API (and analysis
> of potential security problems when misused).

Here again we have to disagree. RCU/lockless lookups create a
difference in semantics on get(). Where normally, in the serialized
case, get() on 0 is an immediate UAF, the lockless case needs to
explicitly deal with that.

So we get:

	get_serialized() -- must never observe 0 and will return the
			    same pointer.
	get_lockless() -- can observe 0 and we must check the return
	                  value.

Since most people do not write lockless code, we default to the first
for the regular inc/get and provide inc_not_zero() for the latter one.

With your proposed interface we'd have to write:

	my_ptr = ref_get(ptr);
	WARN_ON(!my_ptr);

All over the place in order to provide the same warning to people,
because ref_get() could not include the WARN because of the lockless
case.

Providing this warn for people writing code is I feel important. Its a
small and fairly simple check that avoids/catches mistakes as they're
made.

Then there's the whole dec_and_lock class, which isn't really
fundamental, but more a nice optimization where we can avoid taking the
lock in the common case.

As to the whole add/sub, I would rather not have that either.

> now to implement this in C
> you'll have to break the abstraction in that it'd be an undue burden on
> the API implementor to provide the API for each type of reference (in C++
> you could use templates) so in practice you'd also expose the immediately
> underlying refcount type (a reference to it) in the API and pray that users
> will get it right. something like this:
> 
> objtype *ref_get(objtype *ref, refcount_t *count);
> void ref_put(objtype *ref, refcount_t *count, destruct_t *dtor);
> 
> where 'count' would be passed as &ref->refcount_field or you could make
> this API macro based instead and stick to the proper API by mandating the
> name of the object's refcount field:
> 
> #define REF_GET(ref) ({ refcount_inc(&ref->refcount) ? ref : NULL;})
> #define REF_PUT(ref, dtor) do { if (refcount_dec(&ref->refcount)) dtor(ref); } while(0)

Since, as you say 'pray that users will get it right' I'm not convinced
of this particular form over any other. But its trivial to provide a
wrapper like that if people feel strongly about it.

> > Yes it takes more time and effort, but the end result is better code.
> 
> most definitely but that road is a lot longer than some of you seem to
> anticipate ;).

Oh, I've been at this long enough to know that :-)

> i can't make any sense of your example.

Yeah, got my brain in a twist, it didn't make sense.
