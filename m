Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 20 Jan 2017 11:35:28 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170120103528.GA31295@kroah.com>
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
Cc: Eric Biggers <ebiggers3@gmail.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

Sorry I missed responding to this earlier, my fault.

I'm just going to comment on one big part here, as I was the one who
created the kref api, and has watched it mutate over the years...

On Thu, Jan 05, 2017 at 10:21:31PM +0100, PaX Team wrote:
> 2. your current refcount_t API is wrong and i think reflects a misunderstanding
> of what reference counts are about in general. in particular, checking for
> a 0 refcount value for any purpose other than freeing the underlying object
> makes no sense and means that the usage is not a refcount or the user has
> a UAF bug to start with (the check in kref_get is also nonsense for this
> reason). this is because refcounts protect (account for) references/handles
> to an object, not the object itself. this also means that such references
> (think pointers in C) can only be created by *copying* an existing one but
> they cannot be made up out of thin air.

I agree in principle here, and that's how the original kref api worked.
But then the nasty real-world got in the way here and people started
using it :)

> in theory, each time a reference is copied, the corresponding refcount
> must be increased and when the reference goes out of scope, the refcount
> must be decremented. when the refcount reaches 0 we know that there're no
> references left so the object can be freed. in practice, we optimize the
> refcount increments on copies by observing that the lifetimes of certain
> reference copies nest in each other (think local variables, non-captured
> function parameters, etc) so we can get away by only accounting for the
> outermost reference in such a nesting hierarchy of references (and we get
> the refcounting bugs when we fail at this arguably premature optimization
> and miss a decrement or increment for a reference copy).

Yes, in theory, I totally agree with you.  That _should_ be the only way
a refcount works.  And that's how kref worked for a few years, until
real-world got in the way...

> now with this introduction tell me what sense does e.g., refcount_add_not_zero
> make? any refcount API should never even expose the underlying counter
> mechanism since refcounts are about references, not the counter underneath.
> that is, a proper refcount API would look like this:

I agree, but if you look at the places where that is used, there are
good reasons for it.  Unfortunatly some types of object lifecycles don't
fit into the "once it hits zero it needs to be removed" as some other
type of "object cleanup" model comes into play where things are removed
later on.  Once an object's reference hits zero it means, for that
object, that no _more_ references can be grabbed, because it is "dead"
or something like that.

I've tried to argue otherwise, but almost every time I ended up agreeing
with the usage in the end.  That's not to say that there isn't room in
the current kernel to fix up a few of these usages (I'm suspicious about
the nvme usage, as those people are notorious for doing horrid things to
an api just because they can...)

> // establishes the initial refcount of 0 (which doesn't mean 'freed object'
> // but 'no references, yet')
> // it's needed for object construction if the object may come from non-zero
> // initialized memory, otherwise ref_get should be used
> void ref_reset(objtype *ref);

kref_init() in today's kernel.  I agree it is needed, but not that you
should be able to call kref_get without ever calling it first.  It's
best to always init things in my opinion.

> // returns a copy of the reference if the refcount can be safely
> // incremented, NULL otherwise (or crash&burn, etc)
> objtype *ref_get(objtype *ref);

kref_get().

> // decrements the refcount and free the object if it reached 0
> // dtor could be a field of objtype but that'd cost memory (if there are
> // more objects than ref_put callers which is the likely case in real life)
> // and is an attack surface (kref follows this model too)
> void ref_put(objtype *ref, destruct_t *dtor);

kref_put().

Or kref_put_mutex() as it's nice to be able to keep the lock within the
api to prevent it being forced to be kept outside of it (which in your
example, is required, which forces us to audit things better.)

> conceptually that is all you need to provide for refcount users (note that
> there's no leakage of the lower level implementation into the API, e.g., it
> can be lockless based on atomic_t or synchronized explicitly, all that is
> hidden from the users of the API).

I agree in theory, but then the real-world got in the way and showed
that there are other usages that need more than just this.  Which is why
the kref api has grown over the years to accomidate them.

To wave things away and say "you are doing it all wrong" is dangerous.
I know I did just that in my youth, but experience has taught me that
sometimes I am wrong, and that apis need to be extended to fit other,
valid, usage models.

In short, the wonderful quote, "In theory, theory and practice are the
same. In practice, they are not." applies here as well.  I've had it
happen to me too many times to count over the years :)

Moving to a refcount_t api is good, and a solid thing to do, it allows
us to start catching the places where atomic_t is being used incorrectly,
fix them up to use a reference count properly, and move on to the next
issue at hand.

You all can argue if the current refcount api is "performant" or not
enough, which is great, as it can then be fixed up in one single place
and made more "secure" by catching reference count overflows or not.

thanks,

greg k-h
