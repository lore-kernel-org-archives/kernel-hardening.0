Date: Tue, 9 May 2017 12:44:03 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170509174403.etx64yozb7ctr4ur@treble>
References: <1494271972-140319-1-git-send-email-keescook@chromium.org>
 <1494271972-140319-3-git-send-email-keescook@chromium.org>
 <20170508225308.a6uznrhdm7pgyhcg@treble>
 <CAGXu5j+J=o7hHceQn6pFtCmQcfUtSrtZ9uP8fLo0gkDWNdetAA@mail.gmail.com>
 <20170509015829.iycvxxbyblfgklsg@treble>
 <20170509170812.uyfkvblwofhxpk4e@treble>
 <CAGXu5j+_72Pv6dTZdaYN0N4TZG6G7aB=O+v3fv4xL9jgHHpJkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+_72Pv6dTZdaYN0N4TZG6G7aB=O+v3fv4xL9jgHHpJkA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 2/2] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 09, 2017 at 10:29:16AM -0700, Kees Cook wrote:
> On Tue, May 9, 2017 at 10:08 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > On Mon, May 08, 2017 at 08:58:29PM -0500, Josh Poimboeuf wrote:
> >> On Mon, May 08, 2017 at 04:31:11PM -0700, Kees Cook wrote:
> >> > On Mon, May 8, 2017 at 3:53 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >> > > On Mon, May 08, 2017 at 12:32:52PM -0700, Kees Cook wrote:
> >> > >> +#define REFCOUNT_EXCEPTION                           \
> >> > >> +     "movl $0x7fffffff, %[counter]\n\t"              \
> >> > >> +     "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
> >> > >> +     "0:\n\t"                                        \
> >> > >> +     _ASM_EXTABLE(0b, 0b)
> >> > >
> >> > > Despite the objtool warnings going away, this still uses the exception
> >> > > table in a new way, which will confuse objtool.  I need to do some more
> >> > > thinking about the best way to fix it, either as a change to your patch
> >> > > or a change to objtool.
> >> >
> >> > In that it's not a "true" exception?
> >>
> >> Right.  And also that it doesn't need the "fixup" since it would return
> >> to the same address anyway.
> >
> > How about the following on top of your patch?  It uses #UD (invalid
> > opcode).  Notice it's mostly code deletions :-)
> 
> Hah, I wrote this patch almost exactly last night, but hadn't had a
> chance to send it out. :)
> 
> I ended up defining a new exception handler, which means nothing
> special in the generic trap code. I didn't send it out because it was
> still using a jns instead of js, and I was pondering if I wanted to
> reintroduce the text section jump just to gain the initial benefit of
> forward-branch-not-taken optimization...
> 
> > diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
> > index 6e8bbd7..653a985 100644
> > --- a/arch/x86/include/asm/refcount.h
> > +++ b/arch/x86/include/asm/refcount.h
> > @@ -8,15 +8,16 @@
> >   */
> >  #include <linux/refcount.h>
> >  #include <asm/irq_vectors.h>
> > +#include <asm/bug.h>
> >
> >  #define REFCOUNT_EXCEPTION                             \
> >         "movl $0x7fffffff, %[counter]\n\t"              \
> > -       "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
> > -       "0:\n\t"                                        \
> > -       _ASM_EXTABLE(0b, 0b)
> > +       "1:\t" ASM_UD0 "\n"                             \
> > +       "2:\n\t"                                        \
> > +       _ASM_EXTABLE(1b, 2b)
> 
> I used _ASM_EXTABLE_REFCOUNT(1b, 2b) here, with
> arch/x86/include/asm/asm.h adding:
> 
> +# define _ASM_EXTABLE_REFCOUNT(from, to)                       \
> +       _ASM_EXTABLE_HANDLE(from, to, ex_handler_refcount)
> 
> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > index 0b2dbcc..7de95b7 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -220,8 +220,8 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
> >         if (!user_mode(regs)) {
> >                 if (fixup_exception(regs, trapnr)) {
> >                         if (IS_ENABLED(CONFIG_FAST_REFCOUNT) &&
> > -                           trapnr == X86_REFCOUNT_VECTOR)
> > -                               refcount_error_report(regs, str);
> > +                           trapnr == X86_TRAP_UD)
> > +                               refcount_error_report(regs);
> >
> >                         return 0;
> >                 }
> 
> And then I could leave out this hunk, instead adding this to
> arch/x86/mm/extable.c:
> 
> +bool ex_handler_refcount(const struct exception_table_entry *fixup,
> +                        struct pt_regs *regs, int trapnr)
> +{
> +       regs->ip = ex_fixup_addr(fixup);
> +       refcount_error_report(regs, "overflow");
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(ex_handler_refcount);
> 
> After looking at the assembly output, the "movl" instructions can be
> various sizes, depending on where %[counter] lives, so I'm also
> considering returning to using PaX's "lea", but I'm not sure the
> benefit would be very large.

Good, your patch sounds better than mine :-)

-- 
Josh
