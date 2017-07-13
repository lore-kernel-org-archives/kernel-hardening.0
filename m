Date: Thu, 13 Jul 2017 15:11:43 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170713141142.GE3966@e103592.cambridge.arm.com>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
 <20170712144424.19528-8-ard.biesheuvel@linaro.org>
 <20170713104116.GD3966@e103592.cambridge.arm.com>
 <CAKv+Gu8gFSSYV5-11bZOMnQGMcvx0gSDnTpibciEPMv_3HpAUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8gFSSYV5-11bZOMnQGMcvx0gSDnTpibciEPMv_3HpAUA@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 07/10] arm64: kernel: switch to register x18 as a
 task struct pointer
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 13, 2017 at 01:27:50PM +0100, Ard Biesheuvel wrote:
> On 13 July 2017 at 11:41, Dave Martin <Dave.Martin@arm.com> wrote:
> > On Wed, Jul 12, 2017 at 03:44:20PM +0100, Ard Biesheuvel wrote:
> >> In order to free up sp_el0, which we will need to deal with faulting
> >> stack accesses when using virtually mapped stacks, switch to register
> >> x18 as the task struct register. This is permitted by the AAPCS64 ABI,
> >> and simplifies many references to 'current', given that they no longer
> >> involve a MSR instruction to access SP_EL0.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > [...]
> >
> >> diff --git a/arch/arm64/include/asm/current.h b/arch/arm64/include/asm/current.h
> >> index f6580d4afb0e..b4e3acff699c 100644
> >> --- a/arch/arm64/include/asm/current.h
> >> +++ b/arch/arm64/include/asm/current.h
> >> @@ -13,11 +13,9 @@ struct task_struct;
> >>   */
> >>  static __always_inline struct task_struct *get_current(void)
> >>  {
> >> -     unsigned long sp_el0;
> >> +     register unsigned long tsk asm ("x18");
> >>
> >> -     asm ("mrs %0, sp_el0" : "=r" (sp_el0));
> >> -
> >> -     return (struct task_struct *)sp_el0;
> >> +     return (struct task_struct *)tsk;
> >
> > Nit:
> >
> > You're explicitly returning an uninitialised variable here: the asm
> > annotation doesn't change the fact that tsk lifetime is that of the
> > function.   Sufficiently aggressive GCC can probably optimise the whole
> > thing (and any caller) away as undefined behaviour.
> >
> > The GCC docs say
> >
> > "The only supported use for [specifying registers for local variables]
> > is to specify registers for input and output operands when calling
> > Extended 'asm'".
> >
> 
> Ah ok, so it needs to live outside of the function, just like
> current_stack_pointer.
> 
> >
> > As an alternative, you could make tsk a global register variable.  I
> > don't know whether it should be volatile or not in that case --
> > probably not, since it's constant for a given thread.
> >
> > Alternatively, the following should work:
> >
> >         unsigned long ret;
> >
> >         asm ("mrs %0, x18" : "=r" (ret));
> >
> >         return ret;
> >
> > (with -ffixed-x18, naturally).
> >
> 
> Indeed (assuming you meant mov not mrs)

Yes (oops).

Cheers
---Dave
