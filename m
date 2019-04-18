MIME-Version: 1.0
References: <1462963502-11636-1-git-send-email-hecmargi@upv.es>
 <CAGXu5jLZ-DgTfokLTqUHOUphO4C1FwHgYDLTA1oB9HBHnH-a1Q@mail.gmail.com> <alpine.DEB.2.21.1904181015270.3174@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904181015270.3174@nanos.tec.linutronix.de>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 18 Apr 2019 09:11:15 -0500
Message-ID: <CAGXu5jK+-eVzhxTB418b1BCqFw5oVpdDhmCqE2Gn2_rFTf2E1A@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Disabling read-implies-exec when the stack is executable
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Brian Gerst <brgerst@gmail.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Huaitong Han <huaitong.han@intel.com>, Ismael Ripoll Ripoll <iripoll@upv.es>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jason Gunthorpe <jgg@mellanox.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 3:17 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Thu, 18 Apr 2019, Kees Cook wrote:
> > On Wed, May 11, 2016 at 5:45 AM Hector Marco-Gisbert <hecmargi@upv.es> wrote:
> > *thread necromancy*
> >
> > I'd still like to see this get landed. READ_IMPLIES_EXEC is way too
> > powerful (it impacts, for example, mmap() regions of device driver
> > memory, forcing drivers to not be able to disallow VM_EXEC[1]).
> >
> > The only case it could break is on an AMD K8 (Athlon only, I assume?),
> > which seems unlikely to have a modern kernel run on it. If there is
> > still concern, then we could just test against the NX CPU feature:
> >
> > diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> > index 69c0f892e310..367cd36259a4 100644
> > --- a/arch/x86/include/asm/elf.h
> > +++ b/arch/x86/include/asm/elf.h
> > @@ -280,10 +280,12 @@ extern u32 elf_hwcap2;
> >
> >  /*
> >   * An executable for which elf_read_implies_exec() returns TRUE will
> > - * have the READ_IMPLIES_EXEC personality flag set automatically.
> > + * have the READ_IMPLIES_EXEC personality flag set automatically when
> > + * a CPU did not support NX or is using a 32-bit memory layout.
> >   */
> > -#define elf_read_implies_exec(ex, executable_stack)    \
> > -       (executable_stack != EXSTACK_DISABLE_X)
> > +#define elf_read_implies_exec(ex, executable_stack)            \
> > +       (mmap_is_ia32() || !(__supported_pte_mask & _PAGE_NX) ? \
>
> What's special about ia32? All what matters is whether PAGE_NX is supported
> or not. That has nothing to do with 32/64bit unless I'm missing something
> (as usual).

I think the reasoning was that older toolchains from ia32 wouldn't
provide any permissions marking at all, and this was a signal that it
might need executable heaps as well as stack. So, since ia32 gained NX
along the way, lacking the gnu-stack marking was a reasonable
indicator that the ELF needed this crazy setting to effectively
disable NX for the ELF.

But yes, just looking at the NX feature should cover this.

One thing I'd also like to adjust is the logic about the gnu-stack
existing and requesting an executable stack should apply only to the
stack, and not trigger READ_IMPLIES_EXEC. i.e. if the ELF has
gnu-stack marking of any kind, it should never flag READ_IMPLIES_EXEC.
It would, of course, continue to control the stack perms.

And if this is wrong ... well, we'll find out how and we can more
correctly document this. So how about:

#define elf_read_implies_exec(ex, executable_stack)            \
       (!(__supported_pte_mask & _PAGE_NX) &&  \
        (executable_stack == EXSTACK_DEFAULT))


-- 
Kees Cook
