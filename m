Date: Wed, 8 Feb 2017 10:43:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170208094313.GI6536@twins.programming.kicks-ass.net>
References: <CAGXu5j+VrKBrU7op8wD1Ry4nzR0cN7Vvke8W6_KOzp3wsoEF1g@mail.gmail.com>
 <20170207083405.GV6500@twins.programming.kicks-ass.net>
 <20170207111011.GB28790@leverpostej>
 <20170207123630.GR6515@twins.programming.kicks-ass.net>
 <20170207135020.GA26173@leverpostej>
 <20170207150737.GM25813@worktop.programming.kicks-ass.net>
 <20170207160300.GB26173@leverpostej>
 <20170207173036.GS6515@twins.programming.kicks-ass.net>
 <20170207175542.GC26173@leverpostej>
 <20170208091250.GT6515@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170208091250.GT6515@twins.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures
 through CHECK_DATA_CORRUPTION
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 08, 2017 at 10:12:50AM +0100, Peter Zijlstra wrote:
> Something like:
> 
> #define EX_REG_HANDLER(_reg)					\
> bool ex_handler_value_##_reg(const struct exception_table_entry *fixup, \
> 			    struct pt_regs *regs, int trapnr)	\
> {								\
> 	void (*handler)(unsigned long) =			\
> 		(void *)((unsigned long)&fixup->to + fixup->to); \
> 								\
> 	if (trapnr != X86_TRAP_UD)				\
> 		return false;					\
> 								\
> 	regs->ip += 2; /* size of UD2 instruction */		\
> 	handler(regs->_reg);					\
> 	return true;						\
> }
> 
> EX_REG_HANDLER(bx);
> EX_REG_HANDLER(cx);
> ...
> EX_REG_HANDLER(ss);
> 
> 
> asm (
> " .macro reg_to_handler	r\n"
> " .irp rs,bx,cx,...,ss\n"
> " .ifc \\r, %\\rs\n"
> " ex_handler_value_\\rs\n"
> " .endif\n"
  " .ifc \\r, %e\\rs\n"
  " ex_handler_value_\\rs\n"
  " .endif\n"
  " .ifc \\r, %r\\rs\n"
  " ex_handler_value_\\rs\n"
  " .endif\n"
> " .endr\n"
> " .endm\n"
> );

to match the 16, 32 and 64 bit names of the same registers. The byte
registers will need additional magic :/


> #define EXCEPTION_VALUE(val, handler)			\
> 	asm volatile ("1: ud2"				\
> 		      _ASM_EXTABLE_HANDLE(1b, handler,	\
> 				     reg_to_handler %0) \
> 		      : : "r" (val))
> 
> 
> Where the generic version can simply be:
> 
> #define EXCEPTION_VALUE(val, handler)	handler((unsigned long)val)
> 
> 
> Makes sense?
