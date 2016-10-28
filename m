Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477643595.2263.168.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Fri, 28 Oct 2016 10:33:15 +0200
In-Reply-To: <20161027132235.GA30193@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
	 <1476802761-24340-3-git-send-email-colin@cvidal.org>
	 <20161027132235.GA30193@leverpostej>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC 2/2] arm: implementation for
 HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On Thu, 2016-10-27 at 14:24 +0100, Mark Rutland wrote:
> Hi,
> 
> On Tue, Oct 18, 2016 at 04:59:21PM +0200, Colin Vidal wrote:
> > 
> > This adds arm-specific code in order to support HARDENED_ATOMIC
> > feature. When overflow is detected in atomic_t, atomic64_t or
> > atomic_long_t, an exception is raised and call
> > hardened_atomic_overflow.
> 
> I have some comments below, but for real review this needs to go via the
> linux-arm-kernel list.

Thanks a lot for that! Yep, I will CC linux-arm-kernel, linux-kernel
and maintainers of atomic/arm for the next RFC.

I take info account your remarks for the next RFC, but I have some
questions for some of them bellow.

> > 
> > diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> > index 66d0e21..fdaee17 100644
> > --- a/arch/arm/include/asm/atomic.h
> > +++ b/arch/arm/include/asm/atomic.h
> > @@ -17,18 +17,52 @@
> >  #include <linux/irqflags.h>
> >  #include <asm/barrier.h>
> >  #include <asm/cmpxchg.h>
> > +#include <linux/bug.h>
> >  
> >  #define ATOMIC_INIT(i)	{ (i) }
> >  
> >  #ifdef __KERNEL__
> >  
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +#define HARDENED_ATOMIC_INSN "bkpt 0xf103"
> 
> Please put the immediate in a #define somewhere.

I an not sure to get what do you mean here. 0xf103 should be in a
#define? (as for the A1 encoded version, for sure).

> 
> What about thumb2 kernels?
> 
> > 
> > +#define _ASM_EXTABLE(from, to)			\
> > +	".pushsection __ex_table,\"a\"\n"	\
> > +	".align 3\n"				\
> > +	".long "#from","#to"\n"			\
> > +	".popsection"
> > +#define __OVERFLOW_POST				\
> > +	"bvc 3f\n"				\
> > +	"2: "HARDENED_ATOMIC_INSN"\n"		\
> > +	"3:\n"
> > +#define __OVERFLOW_POST_RETURN			\
> > +	"bvc 3f\n"				\
> > +	"mov %0,%1\n"				\
> > +	"2: "HARDENED_ATOMIC_INSN"\n"		\
> > +	"3:\n"
> > +#define __OVERFLOW_EXTABLE			\
> > +	"4:\n"					\
> > +	_ASM_EXTABLE(2b, 4b)
> > +#else
> > +#define __OVERFLOW_POST
> > +#define __OVERFLOW_POST_RETURN
> > +#define __OVERFLOW_EXTABLE
> > +#endif
> > +
> All this should live close to the assembly using it, to make it possible
> to follow.
> 
> This may also not be the best way of structuring this code. The
> additional indirection of passing this in at a high level makes it hard
> to read and potentially fragile. For single instructions it was ok, but
> I'm not so sure that it's ok for larger sequences like this.
> 

I agree that is quite difficult to follow, but as Takahiro said, the
current macro are already complex. Still, I will try to put those
definitions closer of the code using them (for instance, just before
the macro expansions?), but I am not sure that would change anything:
the code using it is broke up in different area of the file anyways.

Besides, I really would avoid using an extable entry, since the fixup
address is never used, I am not sure it is mandatory (and it seems
Takahiro does not using it, too).

> > 
> > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > index 3a2e678..ce8ee00 100644
> > --- a/arch/arm/mm/fault.c
> > +++ b/arch/arm/mm/fault.c
> > @@ -580,6 +580,21 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
> >  	const struct fsr_info *inf = ifsr_info + fsr_fs(ifsr);
> >  	struct siginfo info;
> >  
> > +#ifdef CONFIG_HARDENED_ATOMIC
> > +	if (fsr_fs(ifsr) == FAULT_CODE_DEBUG) {
> 
> You'll need to justify why this isn't in the ifsr_info table. It has the
> same basic shape as the usual set of handlers.
> 
> I note that we don't seem to use SW breakpoints at all currently, and I
> suspect there's a reason for that which we need to consider.
> 
> Also, if this *must* live here, please make it a static inline with an
> empty stub, rather than an ifdef'd block.
> 
> > 
> > +		unsigned long pc = instruction_pointer(regs);
> > +		unsigned int bkpt;
> > +
> > +		if (!probe_kernel_address((const unsigned int *)pc, bkpt) &&
> > +		    cpu_to_le32(bkpt) == 0xe12f1073) {
> 
> This appears to be the A1 encoding from the ARM ARM. What about the T1
> encoding, i.e. thumb?
> 
> Regardless, *please* de-magic the number using a #define.
> 
> Also, this should be le32_to_cpu -- in the end we're treating the
> coverted value as cpu-native. The variable itself should be a __le32.
> 

I must confess that I am still very confused about the code in fault.c
(and the ifsr_info table). I will take time to try to understand a
little bit more that code before submitting a new RFC. Still, it you
have some pointers/documentations about it, I would be grateful.

Thanks!

Colin
