Date: Mon, 14 Aug 2017 16:50:02 +0100
From: Dave Martin <Dave.Martin@arm.com>
Message-ID: <20170814155002.GV6321@e103592.cambridge.arm.com>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <20170814125411.22604-3-ard.biesheuvel@linaro.org>
 <20170814152950.GT6321@e103592.cambridge.arm.com>
 <CAKv+Gu87G93X36TdAEiMC46Uz_PqXEi_4LSftnUdkQ8HRCxWiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu87G93X36TdAEiMC46Uz_PqXEi_4LSftnUdkQ8HRCxWiA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 02/30] ARM: assembler: introduce adr_l, ldr_l and str_l
 macros
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Russell King <linux@armlinux.org.uk>, Tony Lindgren <tony@atomide.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Thomas Garnier <thgarnie@google.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 04:38:02PM +0100, Ard Biesheuvel wrote:
> On 14 August 2017 at 16:29, Dave Martin <Dave.Martin@arm.com> wrote:
> > On Mon, Aug 14, 2017 at 01:53:43PM +0100, Ard Biesheuvel wrote:
> >> Like arm64, ARM supports position independent code sequences that
> >> produce symbol references with a greater reach than the ordinary
> >> adr/ldr instructions.
> >>
> >> Currently, we use open coded instruction sequences involving literals
> >> and arithmetic operations. Instead, we can use movw/movt pairs on v7
> >> CPUs, circumventing the D-cache entirely. For older CPUs, we can emit
> >> the literal into a subsection, allowing it to be emitted out of line
> >> while retaining the ability to perform arithmetic on label offsets.
> >>
> >> E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:
> >>
> >>        ldr          <reg>, 222f
> >>   111: add          <reg>, <reg>, pc
> >>        .subsection  1
> >>   222: .long        <sym> - (111b + 8)
> >>        .previous
> >>
> >> This is allowed by the assembler because, unlike ordinary sections,
> >> subsections are combined into a single section into the object file,
> >> and so the label references are not true cross-section references that
> >> are visible as relocations. Note that we could even do something like
> >>
> >>        add          <reg>, pc, #(222f - 111f) & ~0xfff
> >>        ldr          <reg>, [<reg>, #(222f - 111f) & 0xfff]
> >>   111: add          <reg>, <reg>, pc
> >>        .subsection  1
> >>   222: .long        <sym> - (111b + 8)
> >>        .previous
> >
> > This is reinventing ldr=
> >
> > I seem to remember ldr= barfing on things that .long happily accepts
> > though, was this the reason?
> >
> 
> Yes. ldr = does not accept expressions involving symbols, only plain
> symbols or expressions that evaluate to constants.
> 
> So something like
> 
> ldr <reg>, =<sym> - <label>
> 
> is rejected while the equivalent
> 
> ldr <reg>, 0f
> 0: .long <sym> - <label>
> 
> does work.

I wouldn't bother trying to rationalise gas' behaviour here.  I think
it's an accident of implementation rather than there being some
fundamental reason for it.

AFAICT gas could quite happily resolve ldr= in exactly the same way as
.long and thus not have this problem.  But we can't rewrite history.

[...]

> >> +     .macro          __adldst_l, op, reg, sym, tmp, c
> >> +     .if             __LINUX_ARM_ARCH__ < 7
> >> +     ldr\c           \tmp, 111f
> >> +     .subsection     1
> >> +     .align          2
> >> +111: .long           \sym - (222f + ARM_PC_BIAS)
> >
> > See above comment about ldr=.
> >
> >> +     .previous
> >> +     .else
> >> +     W(movw\c\())    \tmp, #:lower16:\sym - (222f + ARM_PC_BIAS)
> >> +     W(movt\c\())    \tmp, #:upper16:\sym - (222f + ARM_PC_BIAS)
> >
> > Why W()?
> >
> > There are no narrow forms of these instructions anyway -- if there were
> > then they couldn't accommodate a 16-bit immediate.
> >
> 
> That's a trick, actually, which I failed to add a comment for.
> 
> We use .arm sections in the thumb2 kernel, and using these macros
> there would result in the wrong offset to be used. Adding the .w
> suffix forces an error in the assembler which even results in a fairly
> meaningful error message complaining about using .w in ARM code.

Ewww... I think it'd be best to add a comment explaining that.

There's a fair change someone will trip over this at some point (or
worse, "fix" the assembly errors).

> 
> >> +     .endif
> >> +222:
> >> +     .ifc            \op, add
> >> +     add\c           \reg, \tmp, pc
> >> +     .elseif         CONFIG_THUMB2_KERNEL == 1
> >> +     add             \tmp, \tmp, pc
> >> +     \op\c           \reg, [\tmp]
> >
> > Shame
> >         \op\c           \reg, [pc, \tmp]
> > doesn't work.
> >
> > But it doesn't, apparently.
> >
> 
> No, thumb2 does not allow that

Meh.  Oh well.

[...]

Cheers
---Dave
