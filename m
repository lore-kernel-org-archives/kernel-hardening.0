Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 29 Dec 2016 19:06:27 -0600
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20161230010627.GA9882@zzz>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482994571-18687-7-git-send-email-elena.reshetova@intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 06/19] Provide refcount_t, an
 atomic_t like primitive built just for refcounting.
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 29, 2016 at 08:55:58AM +0200, Elena Reshetova wrote:
> +
> +static inline __must_check
> +bool refcount_add_not_zero(unsigned int i, refcount_t *r)
> +{
> +       unsigned int old, new, val = atomic_read(&r->refs);
> +
> +       for (;;) {
> +               if (!val)
> +                       return false;
> +
> +               if (unlikely(val == UINT_MAX))
> +                       return true;
> +
> +               new = val + i;
> +               if (new < val)
> +                       new = UINT_MAX;
> +               old = atomic_cmpxchg_relaxed(&r->refs, val, new);
> +               if (old == val)
> +                       break;
> +
> +               val = old;
> +       }
> +
> +       WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
> +
> +       return true;
> +}
> +
> +/*
> + * Similar to atomic_inc_not_zero(), will saturate at UINT_MAX and WARN.
> + *
> + * Provides no memory ordering, it is assumed the caller has guaranteed the
> + * object memory to be stable (RCU, etc.). It does provide a control dependency
> + * and thereby orders future stores. See the comment on top.
> + */
> +static inline __must_check
> +bool refcount_inc_not_zero(refcount_t *r)
> +{
> +       return refcount_add_not_zero(1, r);
> +}
> +
> +/*
> + * Similar to atomic_inc(), will saturate at UINT_MAX and WARN.
> + *
> + * Provides no memory ordering, it is assumed the caller already has a
> + * reference on the object, will WARN when this is not so.
> + */
> +static inline void refcount_inc(refcount_t *r)
> +{
> +       WARN(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
> +}
> +

... and refcount_inc() compiles to over 100 bytes of instructions on x86_64.
This is the wrong approach.  We need a low-overhead solution, otherwise no one
will turn on refcount protection and the feature will be useless.

What exactly is wrong with the current solution in PAX/grsecurity?  Looking at
the x86 version they have atomic_inc() do 'lock incl' like usual, then use 'jo'
to, if the counter overflowed, jump to *out-of-line* error handling code, in a
separate section of the kernel image.   Then it raises a software interrupt, and
the interrupt handler sets the overflowed counter to INT_MAX and does the needed
logging and signal raising.

That approach seems very efficient.  It seems the only overhead when someone
isn't actually exploiting a refcount bug is the 'jo' instruction, with the
branch not taken.  There aren't even any other in-line instructions to waste
icache space.

I do see they used to use a slightly different approach that did a decrement
instead of setting the counter to INT_MAX.  And that was clearly racy because
two concurrent increments could circumvent the overflow protection.  But AFAICS
their current solution is not racy in any meaningful way, since the setting to
INT_MAX means an overflow will be detected again on the next increment, even if
there were some concurrent increments in the mean time.  (And if by some stretch
of the imagination, it was possible to execute *another* INT_MAX increments
before the fixup code had a chance to run, the correct solution would be to
simply use 'js' instead of 'jo' to detect overflows.  I'm guessing the only
reason they don't do that is because some atomic_t's are used to store negative
values...)

So given that there is an existing solution which AFAICS is efficient and
achieves the desired protection, why has the proposal turned into a monstrous
cmpxchg loop that won't be practical to enable by default?

I also think that the "warn when incrementing a 0 refcount" part of the change
shouldn't be there.  It's additional overhead that seems tangential to the main
goal of the feature which is to protect against refcount overflows, not to
protect against random increments in some object which has *already* been freed
and potentially exploited.

- Eric
