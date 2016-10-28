Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 11:20:38 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161028102037.GC5806@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-3-git-send-email-colin@cvidal.org>
 <20161027132235.GA30193@leverpostej>
 <1477643595.2263.168.camel@cvidal.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477643595.2263.168.camel@cvidal.org>
Subject: Re: [kernel-hardening] [RFC 2/2] arm: implementation for
 HARDENED_ATOMIC
To: Colin Vidal <colin@cvidal.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 28, 2016 at 10:33:15AM +0200, Colin Vidal wrote:
> On Thu, 2016-10-27 at 14:24 +0100, Mark Rutland wrote:
> > On Tue, Oct 18, 2016 at 04:59:21PM +0200, Colin Vidal wrote:
> > > +#define HARDENED_ATOMIC_INSN "bkpt 0xf103"
> > 
> > Please put the immediate in a #define somewhere.
> 
> I an not sure to get what do you mean here. 0xf103 should be in a
> #define? (as for the A1 encoded version, for sure).

I mean have something like:

#ifdef CONFIG_THUMB2_KERNEL
#define ATOMIC_BKPT_IMM 0xf1
#else
#define ATOMIC_BKPT_IMM	0xf103
#endif

With code having something like:

HARDENED_ATOMIC_INSN "bkpt" #ATOMIC_BKPT_IMM

... or passing that in via an %i template to the asm.

That way, we can also build the encoding for the exception path from the
same immediate. That will keep the two in sync, making the relationship
between the two obvious. e.g. first add something like arm_get_bkpt(imm)
to <asm/insn.h>.

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
> > All this should live close to the assembly using it, to make it possible
> > to follow.
> > 
> > This may also not be the best way of structuring this code. The
> > additional indirection of passing this in at a high level makes it hard
> > to read and potentially fragile. For single instructions it was ok, but
> > I'm not so sure that it's ok for larger sequences like this.
> 
> I agree that is quite difficult to follow, but as Takahiro said, the
> current macro are already complex. Still, I will try to put those
> definitions closer of the code using them (for instance, just before
> the macro expansions?), but I am not sure that would change anything:
> the code using it is broke up in different area of the file anyways.

I'm not sure that's true. IIRC each of the cases above is only used by
one template case, and we could instead fold that into the template.
For example, if we had something like the ALTERNATIVE macros that worked
on some boolean passed in, so you could have:

#define __foo_asm_template(__bool, params ...)			\
	asm(							\
	"insn reg, whatever"					\
	TEMPLATE(__bool, "code_if_bool", "code if_not_bool")	\
	"more insns..."						\
	clobbers_etc)

That way all the code is in one place, and easier to follow, and we can
generate both the instrumented and non-instrumented variants from the
same template.

> Besides, I really would avoid using an extable entry, since the fixup
> address is never used, I am not sure it is mandatory (and it seems
> Takahiro does not using it, too).

>From the grsecurity blog post [1], per the comments in the ARM detection
logic, this is used to continue after warning (and not incrementing) in
the overflow case.

What do we do differently in the overflow case?

> > > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > > index 3a2e678..ce8ee00 100644
> > > --- a/arch/arm/mm/fault.c
> > > +++ b/arch/arm/mm/fault.c
> > > @@ -580,6 +580,21 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
> > >  	const struct fsr_info *inf = ifsr_info + fsr_fs(ifsr);
> > >  	struct siginfo info;
> > >  
> > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > +	if (fsr_fs(ifsr) == FAULT_CODE_DEBUG) {
> > 
> > You'll need to justify why this isn't in the ifsr_info table. It has the
> > same basic shape as the usual set of handlers.
> > 
> > I note that we don't seem to use SW breakpoints at all currently, and I
> > suspect there's a reason for that which we need to consider.
> > 
> > Also, if this *must* live here, please make it a static inline with an
> > empty stub, rather than an ifdef'd block.
> > 
> > > 
> > > +		unsigned long pc = instruction_pointer(regs);
> > > +		unsigned int bkpt;
> > > +
> > > +		if (!probe_kernel_address((const unsigned int *)pc, bkpt) &&
> > > +		    cpu_to_le32(bkpt) == 0xe12f1073) {
> > 
> > This appears to be the A1 encoding from the ARM ARM. What about the T1
> > encoding, i.e. thumb?
> > 
> > Regardless, *please* de-magic the number using a #define.
> > 
> > Also, this should be le32_to_cpu -- in the end we're treating the
> > coverted value as cpu-native. The variable itself should be a __le32.
> 
> I must confess that I am still very confused about the code in fault.c
> (and the ifsr_info table). I will take time to try to understand a
> little bit more that code before submitting a new RFC. Still, it you
> have some pointers/documentations about it, I would be grateful.

Unfortuantely, I'm not aware of any documentation for this code. The
ifsr_info table is just a set of handlers indexed by the ifsr value.

Ignoring the conflict with the HW breakpoint handler, you'd be able to
install this in the FAULT_CODE_DEBUG slot of ifsr_info.

Thanks,
Mark.

[1] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
