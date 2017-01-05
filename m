Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 5 Jan 2017 11:44:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170105104419.GF3093@worktop>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
 <20161230010627.GA9882@zzz>
 <20170103132136.GV3107@twins.programming.kicks-ass.net>
 <20170104203601.GB21696@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104203601.GB21696@gmail.com>
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: Eric Biggers <ebiggers3@gmail.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 04, 2017 at 12:36:01PM -0800, Eric Biggers wrote:
> On Tue, Jan 03, 2017 at 02:21:36PM +0100, Peter Zijlstra wrote:
> > On Thu, Dec 29, 2016 at 07:06:27PM -0600, Eric Biggers wrote:
> > > 
> > > ... and refcount_inc() compiles to over 100 bytes of instructions on x86_64.
> > > This is the wrong approach.  We need a low-overhead solution, otherwise no one
> > > will turn on refcount protection and the feature will be useless.
> > 
> > Its not something that can be turned on or off, refcount_t is
> > unconditional code. But you raise a good point on the size of the thing.
> ...
> > Doing an unconditional INC on INT_MAX gives a temporarily visible
> > artifact of INT_MAX+1 (or INT_MIN) in the best case.
> > 
> > This is fundamentally not an atomic operation and therefore does not
> > belong in the atomic_* family, full stop.
> 
> Again I feel this is going down the wrong track.  The point of the PaX feature
> this is based on is to offer protection against *exploits* involving abuse of
> refcount leak bugs.  If the overflow logic triggers then there is a kernel *bug*
> and the rules have already been broken.  The question of whether the exploit
> mitigation is "atomic" is not important unless it allows the mitigation to be
> circumvented.

It matters for where you put it. It cannot be part of atomic_t if it is
intrinsically not atomic.

Not to mention that the whole checked/unchecked split doesn't make sense
for atomic_t since the concept only applies to a subset of the
operations, and for those are only desired for a subset of applications;
notably the reference count case.

The proposed refcount_t aims to address the exact exploit scenario you
mention, but does so from a separate type with well defined semantics.

Our current effort has mostly been aimed at exploring the space and
defining the semantics and API that make sense. For example the refcount
type should not have functions that can subvert the protection or create
malformed stuff, ie. it should be internally consistent.

Note that the saturation semantics are an effective mitigation of the
described use-after-free exploit into a resource leak denial-of-service;
although Kees wants to later add an instant panic option, which would
create a more immediate DoS scenario.

> And yes this should be a config option just like other hardening options like
> CONFIG_HARDENED_USERCOPY.  Making it unconditional only makes it harder to get
> merged and hurts users who, for whatever reason, don't want/need extra
> protections against kernel exploits.  This is especially true if an
> implementation with significant performance and code size overhead is chosen.

Maybe.. and while I agree that whatever GCC generates from the generic
implementation currently available is quite horrible, I'm not convinced
a hand coded equivalent is an actual problem. The cmpxchg loop only
really suffers in performance when the variable is contended, and when a
refcount is contended enough for this to show up, your code has issues
anyway. That leaves size, and lets first show that that ends up being a
real problem.

Premature optimization etc..

> This scenario doesn't make sense.  If there's no bug that causes extra refcount
> decrements, then it would be impossible to generate the INT_MAX+1 decrements
> needed to free the object.  Or if there *is* a bug that causes extra refcount
> decrements, then it could already be abused at any time in any of the proposed
> solutions to trivially cause a use-after-free.

Right you are, so much for thinking straight :-) I still feel deeply
uncomfortable with the nonatomic nature of the thing, I'll have to think
a bit more on this thing.

Also note that such a scheme does not make sense for LL/SC
architectures.

In any case, if it can be proven to be equivalent, we can always change
the x86 implementation later.
