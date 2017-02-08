Date: Wed, 8 Feb 2017 10:12:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170208091250.GT6515@twins.programming.kicks-ass.net>
References: <20170206085739.GH6515@twins.programming.kicks-ass.net>
 <CAGXu5j+VrKBrU7op8wD1Ry4nzR0cN7Vvke8W6_KOzp3wsoEF1g@mail.gmail.com>
 <20170207083405.GV6500@twins.programming.kicks-ass.net>
 <20170207111011.GB28790@leverpostej>
 <20170207123630.GR6515@twins.programming.kicks-ass.net>
 <20170207135020.GA26173@leverpostej>
 <20170207150737.GM25813@worktop.programming.kicks-ass.net>
 <20170207160300.GB26173@leverpostej>
 <20170207173036.GS6515@twins.programming.kicks-ass.net>
 <20170207175542.GC26173@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207175542.GC26173@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures
 through CHECK_DATA_CORRUPTION
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 07, 2017 at 05:55:42PM +0000, Mark Rutland wrote:
> On Tue, Feb 07, 2017 at 06:30:36PM +0100, Peter Zijlstra wrote:
> > On Tue, Feb 07, 2017 at 04:03:01PM +0000, Mark Rutland wrote:
> > > For x86 it's a little painful due to '%' in the register names, but it looks
> > > possible. The below appears to do the mangling correctly (then screams due to
> > > the mangled result being nonexistent).
> > 
> > > asm(
> > > "	.macro	reg_to_offset	r\n"
> > > "	.irp rs,eax,ebx,ecx,edx\n"
> > > "	.ifc \\r, %\\rs\n"
> > > "	__offset_of_\\rs\n"
> > > "	.endif\n"
> > > "	.endr\n"
> > > "	.endm\n"
> > > );
> > > 
> > > #define asm_sym(var)		asm volatile("reg_to_offset %0\n" : : "r" (var))
> > 
> > Oh gawd that's a most gnarly hack.
> 
> :)
> 
> > Do we want to go do that for all archs or somehow cook a generic
> > fallback that ends up doing a full function call or something?
> 
> Given the arch-specific reg->blah mapping is so "fun", I guess a generic
> fallback would be a good start.
> 
> I haven't figured out all the plumbing details. It'd be nice to reuse
> the bug infrastructure so that arches don't have to implement another
> trap and callback pair, but I guess the reg details need to live in
> another data structure.

On x86 have have __ex_table and __bug_table. The former is used for all
sorts of things, including fixing up faults.

Now, our struct exception_table_entry has a third field used to specify
a handler, see commit:

 548acf19234d ("x86/mm: Expand the exception table logic to allow new handling options")

Also, given we trigger things with a known instruction at these sites,
the ->to field is reusable and can be used to encode the register
offset.

Still, if we want to allow a generic implementation that does a function
call, the handler prototype should probably look like:

	void exception_value(unsigned long value);

Which means the arch bits need a trampoline and we also need to encode
that. The best I've come up with is having nr_regs trampolines and
stuffing the trampoline function in the ->handler field and then using
the ->to field to encode the actual handler.

Something like:

#define EX_REG_HANDLER(_reg)					\
bool ex_handler_value_##_reg(const struct exception_table_entry *fixup, \
			    struct pt_regs *regs, int trapnr)	\
{								\
	void (*handler)(unsigned long) =			\
		(void *)((unsigned long)&fixup->to + fixup->to); \
								\
	if (trapnr != X86_TRAP_UD)				\
		return false;					\
								\
	regs->ip += 2; /* size of UD2 instruction */		\
	handler(regs->_reg);					\
	return true;						\
}

EX_REG_HANDLER(bx);
EX_REG_HANDLER(cx);
...
EX_REG_HANDLER(ss);


asm (
" .macro reg_to_handler	r\n"
" .irp rs,bx,cx,...,ss\n"
" .ifc \\r, %\\rs\n"
" ex_handler_value_\\rs\n"
" .endif\n"
" .endr\n"
" .endm\n"
);

#define EXCEPTION_VALUE(val, handler)			\
	asm volatile ("1: ud2"				\
		      _ASM_EXTABLE_HANDLE(1b, handler,	\
				     reg_to_handler %0) \
		      : : "r" (val))


Where the generic version can simply be:

#define EXCEPTION_VALUE(val, handler)	handler((unsigned long)val)


Makes sense?
