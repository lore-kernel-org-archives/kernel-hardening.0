Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 05 Jan 2017 22:21:31 +0100
MIME-Version: 1.0
Message-ID: <586EB8DB.30827.B1CCC7E@pageexec.freemail.hu>
In-reply-to: <20170103132136.GV3107@twins.programming.kicks-ass.net>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>, <20161230010627.GA9882@zzz>, <20170103132136.GV3107@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an atomic_t like primitive built just for refcounting.
To: Eric Biggers <ebiggers3@gmail.com>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 3 Jan 2017 at 14:21, Peter Zijlstra wrote:

> Its not something that can be turned on or off, refcount_t is
> unconditional code. But you raise a good point on the size of the thing.
> 
> I count 116 bytes on x86_64. If I disable all the debug crud...

...then the whole thing loses its raison d'etre ;). so let's not cheat
and compare apples to apples in the future. this means that your solution
has a very bad size overhead (dozens of insns vs. one, multiplied by a few
thousand uses) and performance overhead (several insns that the processor
cannot parallelize due to register and control dependencies, at least one
mispredicted conditional forward jump, etc) which is simply not acceptable
as it doesn't balance it with any sort of security advantage (see below).

> > What exactly is wrong with the current solution in PAX/grsecurity?  Looking at
> > the x86 version they have atomic_inc() do 'lock incl' like usual, then use 'jo'
> > to, if the counter overflowed, jump to *out-of-line* error handling code, in a
> > separate section of the kernel image.   Then it raises a software interrupt, and
> > the interrupt handler sets the overflowed counter to INT_MAX and does the needed
> > logging and signal raising.
> 
> Doing an unconditional INC on INT_MAX gives a temporarily visible
> artifact of INT_MAX+1 (or INT_MIN) in the best case.
> 
> This is fundamentally not an atomic operation and therefore does not
> belong in the atomic_* family, full stop.

i don't know why people keep repeating this myth but what exactly is not
atomic in the PaX REFCOUNT feature? hint: it's all atomic ops based,
there's no semantic change in there.

what is undesired behaviour (for the security goal, not the underlying
atomic_t API!) is that the undo/saturation logic makes the whole dance
visible to other CPUs on non-LL/SC archs which means that this case needs
special care there to achieve the security goal but there's no breakage in
atomic ops. put another way, if you consider REFCOUNT not atomic somehow
then so is the upstream atomic_t API since it makes INT_MAX+1 visible to
all CPUs just like REFCOUNT does (in fact the whole point of the REFCOUNT
accessors is that they can be better than upstream on LL/SC in this regard).

> Not to mention that the whole wrap/unwrap or checked/unchecked split of
> atomic_t is a massive trainwreck. Moving over to refcount_t, which has
> simple and well defined semantics forces us to audit and cleanup all the
> reference counting crud as it gets converted, this is a good thing.

while a noble goal your approach has two problems: one, it doesn't go
nearly far enough, and two, what it does do currently is anything but
clear (beyond the above discussed implementation problems). let me
elaborate on both.

1. the proper approach should be to separate the low-level implementation
machinery from the higher level APIs exposed to users. the current low-level
API is the atomic_t type and its accessors (including the 64/long variants)
which is directly used by most code and there're few higher level abstractions
on top of it. the proper low-level design should first of all separate the
underlying type into signed/unsigned types as the conversions between the
two make for a clumsy and error prone API to start with (just look at your
own refcount_t API, you're abusing signed/unsigned conversions where one
direction is implementation defined and allows a trap representation, is
your code ready to handle that? not to mention that the C implementations
of atomic_t trigger UB when signed overflow occurs).

second, based on the signed/unsigned atomic API you should build not one
but several abstractions. refcount_t is an obvious candidate (based on the
unsigned low-level machinery) but there's a lot more kinds (IIRC, i counted
something like a dozen different patterns when i last looked at the
exceptional cases for REFCOUNT). this leads to...

2. your current refcount_t API is wrong and i think reflects a misunderstanding
of what reference counts are about in general. in particular, checking for
a 0 refcount value for any purpose other than freeing the underlying object
makes no sense and means that the usage is not a refcount or the user has
a UAF bug to start with (the check in kref_get is also nonsense for this
reason). this is because refcounts protect (account for) references/handles
to an object, not the object itself. this also means that such references
(think pointers in C) can only be created by *copying* an existing one but
they cannot be made up out of thin air.

in theory, each time a reference is copied, the corresponding refcount
must be increased and when the reference goes out of scope, the refcount
must be decremented. when the refcount reaches 0 we know that there're no
references left so the object can be freed. in practice, we optimize the
refcount increments on copies by observing that the lifetimes of certain
reference copies nest in each other (think local variables, non-captured
function parameters, etc) so we can get away by only accounting for the
outermost reference in such a nesting hierarchy of references (and we get
the refcounting bugs when we fail at this arguably premature optimization
and miss a decrement or increment for a reference copy).

now with this introduction tell me what sense does e.g., refcount_add_not_zero
make? any refcount API should never even expose the underlying counter
mechanism since refcounts are about references, not the counter underneath.
that is, a proper refcount API would look like this:

// establishes the initial refcount of 0 (which doesn't mean 'freed object'
// but 'no references, yet')
// it's needed for object construction if the object may come from non-zero
// initialized memory, otherwise ref_get should be used
void ref_reset(objtype *ref);

// returns a copy of the reference if the refcount can be safely
// incremented, NULL otherwise (or crash&burn, etc)
objtype *ref_get(objtype *ref);

// decrements the refcount and free the object if it reached 0
// dtor could be a field of objtype but that'd cost memory (if there are
// more objects than ref_put callers which is the likely case in real life)
// and is an attack surface (kref follows this model too)
void ref_put(objtype *ref, destruct_t *dtor);

conceptually that is all you need to provide for refcount users (note that
there's no leakage of the lower level implementation into the API, e.g., it
can be lockless based on atomic_t or synchronized explicitly, all that is
hidden from the users of the API).

any other need/usage is not a refcount and needs its own API (and analysis
of potential security problems when misused). now to implement this in C
you'll have to break the abstraction in that it'd be an undue burden on
the API implementor to provide the API for each type of reference (in C++
you could use templates) so in practice you'd also expose the immediately
underlying refcount type (a reference to it) in the API and pray that users
will get it right. something like this:

objtype *ref_get(objtype *ref, refcount_t *count);
void ref_put(objtype *ref, refcount_t *count, destruct_t *dtor);

where 'count' would be passed as &ref->refcount_field or you could make
this API macro based instead and stick to the proper API by mandating the
name of the object's refcount field:

#define REF_GET(ref) ({ refcount_inc(&ref->refcount) ? ref : NULL;})
#define REF_PUT(ref, dtor) do { if (refcount_dec(&ref->refcount)) dtor(ref); } while(0)

where refcount_inc would do the increment and overflow check and return
a boolean based on the result and refcount_dec would do the decrement and
return a boolean to trigger object destruction (which has to at least free
the object's memory of course).

> Yes it takes more time and effort, but the end result is better code.

most definitely but that road is a lot longer than some of you seem to
anticipate ;).

> Now as to why refcount cannot be implemented using that scheme you
> outlined:
> 
>  vCPU0			vCPU1
> 
>  lock inc %[r]
>  jo
> 
>  <vcpu preempt-out>
> 
> 				for lots
>					refcount_dec_and_test(&obj->ref)
>						/* hooray, we hit 0 */
>						kfree(obj);
> 
>  <vcpu preempt-in>
> 
>  mov $0xFFFFFFFF, %[r] /* OOPS use-after-free */
> 
> 
> Is this unlikely, yes, extremely so. Do I want to be the one debugging
> this, heck no.

i can't make any sense of your example. which kind of refcount bug is
assumed here? if you have an underflow bug then you can just abuse it at
any refcount value, there's no need to win any race at the saturation
value. if it's an overflow bug (the use case for REFCOUNT) then i don't
understand the refcount_dec_and_test call... note also that in the
example's underflow case you have a UAF regardless of the refcount
protection logic so your debugging woes don't go away just because the
UAF is for the non-refcount fields of the underlying object.

as for the security of the current PaX REFCOUNT feature on x86, if you
wanted to break it you'd have to win that race above 2G times in a row
(saturation is at INT_MAX, not UINT_MAX as your example assumes), that is,
all at once in 2G different tasks. good luck finding a machine that can
spawn that many tasks and then even better luck winning the race in every
single one of them in a row without a single schedule back into any one
of them. and if someone's really worried about this case, preemption (or
interrupts for an even shorter window) can be simply disabled around this
logic which would still result in better code than the proposed refcount_t
implementation.

cheers,
 PaX Team
