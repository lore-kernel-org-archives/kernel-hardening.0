Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 12:36:01 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170104203601.GB21696@gmail.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
 <20161230010627.GA9882@zzz>
 <20170103132136.GV3107@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170103132136.GV3107@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 03, 2017 at 02:21:36PM +0100, Peter Zijlstra wrote:
> On Thu, Dec 29, 2016 at 07:06:27PM -0600, Eric Biggers wrote:
> > 
> > ... and refcount_inc() compiles to over 100 bytes of instructions on x86_64.
> > This is the wrong approach.  We need a low-overhead solution, otherwise no one
> > will turn on refcount protection and the feature will be useless.
> 
> Its not something that can be turned on or off, refcount_t is
> unconditional code. But you raise a good point on the size of the thing.
...
> Doing an unconditional INC on INT_MAX gives a temporarily visible
> artifact of INT_MAX+1 (or INT_MIN) in the best case.
> 
> This is fundamentally not an atomic operation and therefore does not
> belong in the atomic_* family, full stop.

Again I feel this is going down the wrong track.  The point of the PaX feature
this is based on is to offer protection against *exploits* involving abuse of
refcount leak bugs.  If the overflow logic triggers then there is a kernel *bug*
and the rules have already been broken.  The question of whether the exploit
mitigation is "atomic" is not important unless it allows the mitigation to be
circumvented.

And yes this should be a config option just like other hardening options like
CONFIG_HARDENED_USERCOPY.  Making it unconditional only makes it harder to get
merged and hurts users who, for whatever reason, don't want/need extra
protections against kernel exploits.  This is especially true if an
implementation with significant performance and code size overhead is chosen.

> Now as to why refcount cannot be implemented using that scheme you
> outlined:
> 
> 	vCPU0			vCPU1
> 
> 	lock inc %[r]
> 	jo
> 
> 	<vcpu preempt-out>
> 
> 				for lots
> 					refcount_dec_and_test(&obj->ref)
> 						/* hooray, we hit 0 */
> 						kfree(obj);
> 
> 	<vcpu preempt-in>
> 
> 	mov $0xFFFFFFFF, %[r] /* OOPS use-after-free */

This scenario doesn't make sense.  If there's no bug that causes extra refcount
decrements, then it would be impossible to generate the INT_MAX+1 decrements
needed to free the object.  Or if there *is* a bug that causes extra refcount
decrements, then it could already be abused at any time in any of the proposed
solutions to trivially cause a use-after-free.

Eric
