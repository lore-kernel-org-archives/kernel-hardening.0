Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 26 Oct 2016 16:24:24 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161026072423.GB19531@linaro.org>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-3-git-send-email-colin@cvidal.org>
 <20161025091807.GX19531@linaro.org>
 <1477407767.2263.22.camel@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477407767.2263.22.camel@cvidal.org>
Subject: [kernel-hardening] Re: [RFC 2/2] arm: implementation for HARDENED_ATOMIC
To: Colin Vidal <colin@cvidal.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 25, 2016 at 05:02:47PM +0200, Colin Vidal wrote:
> On Tue, 2016-10-25 at 18:18 +0900, AKASHI Takahiro wrote:
> > On Tue, Oct 18, 2016 at 04:59:21PM +0200, Colin Vidal wrote:
> > > 
> > > This adds arm-specific code in order to support HARDENED_ATOMIC
> > > feature. When overflow is detected in atomic_t, atomic64_t or
> > > atomic_long_t, an exception is raised and call
> > > hardened_atomic_overflow.
> > > 
> > > Signed-off-by: Colin Vidal <colin@cvidal.org>
> > > ---
> > >  arch/arm/Kconfig              |   1 +
> > >  arch/arm/include/asm/atomic.h | 434 +++++++++++++++++++++++++++++-------------
> > >  arch/arm/mm/fault.c           |  15 ++
> > >  3 files changed, 320 insertions(+), 130 deletions(-)
> > > 
> > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > index b5d529f..fcf4a64 100644
> > > --- a/arch/arm/Kconfig
> > > +++ b/arch/arm/Kconfig
> > > @@ -36,6 +36,7 @@ config ARM
> > >  	select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
> > >  	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
> > >  	select HAVE_ARCH_HARDENED_USERCOPY
> > > +	select HAVE_ARCH_HARDENED_ATOMIC
> > >  	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
> > >  	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
> > >  	select HAVE_ARCH_MMAP_RND_BITS if MMU
> > > diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> > > index 66d0e21..fdaee17 100644
> > > --- a/arch/arm/include/asm/atomic.h
> > > +++ b/arch/arm/include/asm/atomic.h
> > > @@ -17,18 +17,52 @@
> > >  #include <linux/irqflags.h>
> > >  #include <asm/barrier.h>
> > >  #include <asm/cmpxchg.h>
> > > +#include <linux/bug.h>
> > >  
> > >  #define ATOMIC_INIT(i)	{ (i) }
> > >  
> > >  #ifdef __KERNEL__
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +#define HARDENED_ATOMIC_INSN "bkpt 0xf103"
> > > +#define _ASM_EXTABLE(from, to)			\
> > > +	".pushsection __ex_table,\"a\"\n"	\
> > > +	".align 3\n"				\
> > > +	".long "#from","#to"\n"			\
> > > +	".popsection"
> > > +#define __OVERFLOW_POST				\
> > > +	"bvc 3f\n"				\
> > > +	"2: "HARDENED_ATOMIC_INSN"\n"		\
> > > +	"3:\n"
> > > +#define __OVERFLOW_POST_RETURN			\
> > > +	"bvc 3f\n"				\
> > > +	"mov %0,%1\n"				\
> > > +	"2: "HARDENED_ATOMIC_INSN"\n"		\
> > > +	"3:\n"
> > > +#define __OVERFLOW_EXTABLE			\
> > > +	"4:\n"					\
> > > +	_ASM_EXTABLE(2b, 4b)
> > > +#else
> > > +#define __OVERFLOW_POST
> > > +#define __OVERFLOW_POST_RETURN
> > > +#define __OVERFLOW_EXTABLE
> > > +#endif
> > > +
> > >  /*
> > >   * On ARM, ordinary assignment (str instruction) doesn't clear the local
> > >   * strex/ldrex monitor on some implementations. The reason we can use it for
> > >   * atomic_set() is the clrex or dummy strex done on every exception return.
> > >   */
> > >  #define atomic_read(v)	READ_ONCE((v)->counter)
> > > +static inline int atomic_read_wrap(const atomic_wrap_t *v)
> > > +{
> > > +	return atomic_read(v);
> > > +}
> > >  #define atomic_set(v,i)	WRITE_ONCE(((v)->counter), (i))
> > > +static inline void atomic_set_wrap(atomic_wrap_t *v, int i)
> > > +{
> > > +	atomic_set(v, i);
> > > +}
> > >  
> > >  #if __LINUX_ARM_ARCH__ >= 6
> > >  
> > > @@ -38,38 +72,46 @@
> > >   * to ensure that the update happens.
> > >   */
> > >  
> > > -#define ATOMIC_OP(op, c_op, asm_op)					\
> > > -static inline void atomic_##op(int i, atomic_t *v)			\
> > > +#define __ATOMIC_OP(op, suffix, c_op, asm_op, post_op, extable)		\
> > > +static inline void atomic_##op##suffix(int i, atomic##suffix##_t *v)	\
> > >  {									\
> > >  	unsigned long tmp;						\
> > >  	int result;							\
> > >  									\
> > >  	prefetchw(&v->counter);						\
> > > -	__asm__ __volatile__("@ atomic_" #op "\n"			\
> > > +	__asm__ __volatile__("@ atomic_" #op #suffix "\n"		\
> > >  "1:	ldrex	%0, [%3]\n"						\
> > >  "	" #asm_op "	%0, %0, %4\n"					\
> > > +        post_op                 					\
> > >  "	strex	%1, %0, [%3]\n"						\
> > >  "	teq	%1, #0\n"						\
> > > -"	bne	1b"							\
> > > +"	bne	1b\n"							\
> > > +        extable                 					\
> > >  	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
> > >  	: "r" (&v->counter), "Ir" (i)					\
> > >  	: "cc");							\
> > >  }									\
> > >  
> > > -#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
> > > -static inline int atomic_##op##_return_relaxed(int i, atomic_t *v)	\
> > > +#define ATOMIC_OP(op, c_op, asm_op)		                        \
> > > +	__ATOMIC_OP(op, _wrap, c_op, asm_op, , )			\
> > > +	__ATOMIC_OP(op, , c_op, asm_op##s, __OVERFLOW_POST, __OVERFLOW_EXTABLE)
> > > +
> > > +#define __ATOMIC_OP_RETURN(op, suffix, c_op, asm_op, post_op, extable)	\
> > > +static inline int atomic_##op##_return##suffix##_relaxed(int i, atomic##suffix##_t *v) \
> > >  {									\
> > >  	unsigned long tmp;						\
> > >  	int result;							\
> > >  									\
> > >  	prefetchw(&v->counter);						\
> > >  									\
> > > -	__asm__ __volatile__("@ atomic_" #op "_return\n"		\
> > > +	__asm__ __volatile__("@ atomic_" #op "_return" #suffix "\n"	\
> > >  "1:	ldrex	%0, [%3]\n"						\
> > >  "	" #asm_op "	%0, %0, %4\n"					\
> > > +        post_op                 					\
> > >  "	strex	%1, %0, [%3]\n"						\
> > >  "	teq	%1, #0\n"						\
> > > -"	bne	1b"							\
> > > +"	bne	1b\n"							\
> > > +        extable                 					\
> > >  	: "=&r" (result), "=&r" (tmp), "+Qo" (v->counter)		\
> > >  	: "r" (&v->counter), "Ir" (i)					\
> > >  	: "cc");							\
> > > @@ -77,6 +119,11 @@ static inline int atomic_##op##_return_relaxed(int i, atomic_t *v)	\
> > >  	return result;							\
> > >  }
> > >  
> > > +#define ATOMIC_OP_RETURN(op, c_op, asm_op)	                        \
> > > +	__ATOMIC_OP_RETURN(op, _wrap, c_op, asm_op, , )			\
> > > +	__ATOMIC_OP_RETURN(op, , c_op, asm_op##s,			\
> > > +			   __OVERFLOW_POST_RETURN, __OVERFLOW_EXTABLE)
> > > +
> > 
> > This definition will create atomic_add_return_wrap_relaxed(),
> > but should the name be atomic_add_return_relaxed_wrap()?
> > 
> > (I don't know we need _wrap version of _relaxed functions.
> > See Elena's atomic-long.h.)
> > 
> > Thanks,
> > -Takahiro AKASHI
> 
> Hi Takahiro,
> 
> as far I understand, the name should be atomic_add_return_wrap_relaxed
> since atomic_add_return_wrap is created by __atomic_op_fence (in order
> to put memory barrier around the call to
> atomic_add_return_wrap_relaxed) in include/linux/atomic.h.

# I know that this is not a "technical" issue.

My point is that _wrap would be the last suffix of the names of all
the functions including _relaxed variants for consistency.

Say, Elena's atomic-long.h defines:
===8<===
#define ATOMIC_LONG_ADD_SUB_OP(op, mo, suffix)                          \
static inline long                                                      \
atomic_long_##op##_return##mo##suffix(long i, atomic_long##suffix##_t *l)\
{                                                                       \
        ATOMIC_LONG_PFX(suffix##_t) *v = (ATOMIC_LONG_PFX(suffix##_t) *)l;\
                                                                        \
        return (long)ATOMIC_LONG_PFX(_##op##_return##mo##suffix)(i, v);\
}
ATOMIC_LONG_ADD_SUB_OP(add,,)
ATOMIC_LONG_ADD_SUB_OP(add, _relaxed,)
  ...
#ifdef CONFIG_HARDENED_ATOMIC
ATOMIC_LONG_ADD_SUB_OP(add,,_wrap)
  ...
===>8===

It would naturally lead to "atomic_long_add_relaxed_wrap" although
this function is not actually defined here.

> Am I wrong?

No, I'm not saying that you are wrong. It's a matter of the naming scheme.
We need some consensus.

Thanks,
-Takahiro AKASHI

> Thanks!
> 
> Colin
