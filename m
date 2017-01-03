Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 Jan 2017 14:21:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170103132136.GV3107@twins.programming.kicks-ass.net>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
 <20161230010627.GA9882@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161230010627.GA9882@zzz>
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: Eric Biggers <ebiggers3@gmail.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 29, 2016 at 07:06:27PM -0600, Eric Biggers wrote:
> 
> ... and refcount_inc() compiles to over 100 bytes of instructions on x86_64.
> This is the wrong approach.  We need a low-overhead solution, otherwise no one
> will turn on refcount protection and the feature will be useless.

Its not something that can be turned on or off, refcount_t is
unconditional code. But you raise a good point on the size of the thing.

I count 116 bytes on x86_64. If I disable all the debug crud that
reduces to 45 bytes, and that's because GCC-6 is generating particularly
stupid code (albeit not as stupid as GCC-5 did).

A hand coded one ends up being 29 bytes, of which 6 are the function
pro- and epilogue, so effectively 23 bytes for inline.

Which we can reduce to 22 if instead of using a literal for UINT_MAX we
do: xor %[t], %[t]; dec %[t].

0000000000009ee0 <ponies>:
    9ee0:       55                      push   %rbp
    9ee1:       48 89 e5                mov    %rsp,%rbp
    9ee4:       8b 07                   mov    (%rdi),%eax
    9ee6:       85 c0                   test   %eax,%eax
    9ee8:       74 10                   je     9efa <ponies+0x1a>
    9eea:       89 c2                   mov    %eax,%edx
    9eec:       ff c2                   inc    %edx
    9eee:       73 04                   jae    9ef4 <ponies+0x14>
    9ef0:       31 d2                   xor    %edx,%edx
    9ef2:       ff ca                   dec    %edx
    9ef4:       f0 0f b1 17             lock cmpxchg %edx,(%rdi)
    9ef8:       75 ec                   jne    9ee6 <ponies+0x6>
    9efa:       5d                      pop    %rbp
    9efb:       c3			retq

(caveat: I wrote this on a post-holidays brain without testing)

Also note that call overhead on an x86_64 (big core) is something like
1.5 cycles. And afaik Sparc64 is the architecture with the worst call
overhead, but that already has its atomic functions out of line for
different reasons.

> What exactly is wrong with the current solution in PAX/grsecurity?  Looking at
> the x86 version they have atomic_inc() do 'lock incl' like usual, then use 'jo'
> to, if the counter overflowed, jump to *out-of-line* error handling code, in a
> separate section of the kernel image.   Then it raises a software interrupt, and
> the interrupt handler sets the overflowed counter to INT_MAX and does the needed
> logging and signal raising.

Doing an unconditional INC on INT_MAX gives a temporarily visible
artifact of INT_MAX+1 (or INT_MIN) in the best case.

This is fundamentally not an atomic operation and therefore does not
belong in the atomic_* family, full stop.

Not to mention that the whole wrap/unwrap or checked/unchecked split of
atomic_t is a massive trainwreck. Moving over to refcount_t, which has
simple and well defined semantics forces us to audit and cleanup all the
reference counting crud as it gets converted, this is a good thing.

Yes it takes more time and effort, but the end result is better code.

I understand why PaX/grsecurity chose not to do this, but that doesn't
make it a proper solution for upstream.


Now as to why refcount cannot be implemented using that scheme you
outlined:

	vCPU0			vCPU1

	lock inc %[r]
	jo

	<vcpu preempt-out>

				for lots
					refcount_dec_and_test(&obj->ref)
						/* hooray, we hit 0 */
						kfree(obj);

	<vcpu preempt-in>

	mov $0xFFFFFFFF, %[r] /* OOPS use-after-free */


Is this unlikely, yes, extremely so. Do I want to be the one debugging
this, heck no.
