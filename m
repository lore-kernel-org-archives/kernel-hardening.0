Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 30 Dec 2016 13:52:13 -0600
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20161230195213.GA9633@zzz>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
 <20161230010627.GA9882@zzz>
 <2236FBA76BA1254E88B949DDB74E612B41C32F34@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C32F34@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 30, 2016 at 01:17:08PM +0000, Reshetova, Elena wrote:
> > 
> > ... and refcount_inc() compiles to over 100 bytes of instructions on x86_64.
> > This is the wrong approach.  We need a low-overhead solution, otherwise no one
> > will turn on refcount protection and the feature will be useless.
> > 
> > What exactly is wrong with the current solution in PAX/grsecurity?  Looking at
> > the x86 version they have atomic_inc() do 'lock incl' like usual, then use 'jo'
> > to, if the counter overflowed, jump to *out-of-line* error handling code, in a
> > separate section of the kernel image.   Then it raises a software interrupt, and
> > the interrupt handler sets the overflowed counter to INT_MAX and does the
> > needed
> > logging and signal raising.
> > 
> > That approach seems very efficient.  It seems the only overhead when someone
> > isn't actually exploiting a refcount bug is the 'jo' instruction, with the
> > branch not taken.  There aren't even any other in-line instructions to waste
> > icache space.
> > I do see they used to use a slightly different approach that did a decrement
> > instead of setting the counter to INT_MAX.  And that was clearly racy because
> > two concurrent increments could circumvent the overflow protection.  But AFAICS
> > their current solution is not racy in any meaningful way, since the setting to
> > INT_MAX means an overflow will be detected again on the next increment, even if
> > there were some concurrent increments in the mean time.  (And if by some stretch
> > of the imagination, it was possible to execute *another* INT_MAX increments
> > before the fixup code had a chance to run, the correct solution would be to
> > simply use 'js' instead of 'jo' to detect overflows.  I'm guessing the only
> > reason they don't do that is because some atomic_t's are used to store negative
> > values...)
> 
> > 
> > So given that there is an existing solution which AFAICS is efficient and
> > achieves the desired protection, why has the proposal turned into a monstrous
> > cmpxchg loop that won't be practical to enable by default?
> 
> I guess we can try to benchmark the whole thing to see what is the overhead.
> Especially now when we have the subsystem parts ready. 
> 
> And if you have been following the story since beginning, we also have PaX/grsecurity
> approach done for linux-next/stable and benchmarks have been previously posted, so
> would be easy to compare if needed. 
> 
> I guess one could in principle think of mixed approach between this one and the one that 
> PaX/grsecurity had: define refcount_t type and API, but use assembly instructions
> behind to speed things up. 

I haven't been following the whole story, sorry.  Are your "PaX/grsecurity
approach" patches based on their latest version, i.e. without the racy
decrement?  Also, with regards to benchmarks, there really are two things that
are important: the performance impact of actually executing all the cmpxchg loop
stuff instead of a simple 'lock incl', and the icache footprint of all the extra
inlined instructions (or the overhead of a function call if that is "solved" by
making refcount_inc() out of line).  The latter is unlikely to be visible in a
microbenchmark but it's still very important.

AFAICS the whole question of refcount_t/atomic_t vs.
atomic_t/atomic_unchecked_t has nothing to do with the details of how the
checked refcount operations are actually implemented.  These things need to be
considered separately.

> 
> > I also think that the "warn when incrementing a 0 refcount" part of the change
> > shouldn't be there.  It's additional overhead that seems tangential to the main
> > goal of the feature which is to protect against refcount overflows, not to
> > protect against random increments in some object which has *already* been freed
> > and potentially exploited.
> 
> Actually having warn for now was useful debugging feature: we got to found out many places which would not work otherwise. 
> 

The point of the feature is exploit mitigation, not refcount debugging.  The
mitigation needs to be practical to turn on in real production systems.  If we
want to have extra debugging features too, fine but that should be a *debugging*
feature not a security feature, controllable by a separate config option, e.g.
CONFIG_DEBUG_REFCOUNT for debugging vs. CONFIG_HARDENED_REFCOUNT for the actual
mitigation.

- Eric
