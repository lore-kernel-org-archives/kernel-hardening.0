Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <57622865.2070701@nextfour.com>
References: <cover.1466036668.git.luto@kernel.org> <3f0299bde58d0161c1dad75e0b7f93f074a6cd12.1466036668.git.luto@kernel.org>
 <57622865.2070701@nextfour.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Jun 2016 22:33:52 -0700
Message-ID: <CALCETrVPMD5KYwqL-1j8hyezJ+GvskeFizfOEh4cUXw0dT3CHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 12/13] x86/mm/64: Enable vmapped stacks
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brian Gerst <brgerst@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Jun 15, 2016 9:32 PM, "Mika Penttil=C3=A4" <mika.penttila@nextfour.com> =
wrote:
>
> Hi,
>

> > diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> > index 5643fd0b1a7d..fbf036ae72ac 100644
> > --- a/arch/x86/mm/tlb.c
> > +++ b/arch/x86/mm/tlb.c
> > @@ -77,10 +77,25 @@ void switch_mm_irqs_off(struct mm_struct *prev, str=
uct mm_struct *next,
> >       unsigned cpu =3D smp_processor_id();
> >
> >       if (likely(prev !=3D next)) {
> > +             if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> > +                     /*
> > +                      * If our current stack is in vmalloc space and i=
sn't
> > +                      * mapped in the new pgd, we'll double-fault.  Fo=
rcibly
> > +                      * map it.
> > +                      */
> > +                     unsigned int stack_pgd_index =3D
> > +                             pgd_index(current_stack_pointer());
>
>
> stack pointer is still the previous task's, current_stack_pointer() retur=
ns that, not
> next task's which was intention I guess. Things may happen to work if on =
same pgd, but at least the
> boot cpu init_task_struct is special.

This is intentional.  When switching processes, we first switch the mm
and then switch the task.  We need to make sure that the prev stack is
mapped in the new mm or we'll double-fault and die after switching the
mm which still trying to execute on the old stack.

The change to switch_to makes sure that the new stack is mapped.

--Andy
