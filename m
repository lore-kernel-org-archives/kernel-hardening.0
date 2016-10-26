Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477470016.2263.87.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Wed, 26 Oct 2016 10:20:16 +0200
In-Reply-To: <20161026072423.GB19531@linaro.org>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
	 <1476802761-24340-3-git-send-email-colin@cvidal.org>
	 <20161025091807.GX19531@linaro.org> <1477407767.2263.22.camel@cvidal.org>
	 <20161026072423.GB19531@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 2/2] arm: implementation for HARDENED_ATOMIC
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Takahiro,

> > > > +#define ATOMIC_OP_RETURN(op, c_op, asm_op)	                        \
> > > > +	__ATOMIC_OP_RETURN(op, _wrap, c_op, asm_op, , )			\
> > > > +	__ATOMIC_OP_RETURN(op, , c_op, asm_op##s,			\
> > > > +			   __OVERFLOW_POST_RETURN, __OVERFLOW_EXTABLE)
> > > > +
> > > 
> > > This definition will create atomic_add_return_wrap_relaxed(),
> > > but should the name be atomic_add_return_relaxed_wrap()?
> > > 
> > > (I don't know we need _wrap version of _relaxed functions.
> > > See Elena's atomic-long.h.)
> > > 
> > > Thanks,
> > > -Takahiro AKASHI
> > 
> > Hi Takahiro,
> > 
> > as far I understand, the name should be atomic_add_return_wrap_relaxed
> > since atomic_add_return_wrap is created by __atomic_op_fence (in order
> > to put memory barrier around the call to
> > atomic_add_return_wrap_relaxed) in include/linux/atomic.h.
> 
> # I know that this is not a "technical" issue.

Oh ok, sorry, I misunderstood and I was confused.

> 
> My point is that _wrap would be the last suffix of the names of all
> the functions including _relaxed variants for consistency.
> 
> Say, Elena's atomic-long.h defines:
> ===8<===
> #define ATOMIC_LONG_ADD_SUB_OP(op, mo, suffix)                          \
> static inline long                                                      \
> atomic_long_##op##_return##mo##suffix(long i, atomic_long##suffix##_t *l)\
> {                                                                       \
>         ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
>                                                                         \
>         return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(i, v);\
> }
> ATOMIC_LONG_ADD_SUB_OP(add,,)
> ATOMIC_LONG_ADD_SUB_OP(add, _relaxed,)
>   ...
> #ifdef CONFIG_HARDENED_ATOMIC
> ATOMIC_LONG_ADD_SUB_OP(add,,_wrap)
>   ...
> ===>8===
> 
> It would naturally lead to "atomic_long_add_relaxed_wrap" although
> this function is not actually defined here.
> 

I understand your point, and the need of consistency. "_wrap" is
appended to any "user" function of the atomic system, and it is
mandatory to have a consistant name for it, I fully agree.

However, in the internal implementation of atomic, "_relaxed" is
appended to any function that will be bounded by memory barriers.
Therefore, a name like "atomic_add_return_wrap_relaxed" makes it easy
to see that this function will be embedded in another one. On the other
hand "atomic_add_return_relaxed_wrap" is less clear, since it suggest
that is a "user" function. I would involve a kind on inconsistency on
the naming of relaxed functions.

That said, I really don't know which is the "best" naming... :-)

Thanks!

Colin
