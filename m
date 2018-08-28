Date: Tue, 28 Aug 2018 10:21:26 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/7] x86: stop calling fixup_exception() from
 kprobe_fault_handler()
Message-Id: <20180828102126.2cd006bc5c5893422761fc6b@kernel.org>
In-Reply-To: <CAG48ez0=-nDmQVQiJtD_6ingdWWVJE+y+5_oWQrggQ9Eqg-UKQ@mail.gmail.com>
References: <20180827185631.163506-1-jannh@google.com>
	<20180827185631.163506-4-jannh@google.com>
	<CALCETrUeRA63Vt_LBOGmUHc_M9gc3J7+ewK6j+sB8P=9ijk7ag@mail.gmail.com>
	<CAG48ez0=-nDmQVQiJtD_6ingdWWVJE+y+5_oWQrggQ9Eqg-UKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, mhiramat@kernel.org, naveen.n.rao@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, tony.luck@intel.com, Borislav Petkov <bp@alien8.de>, kernel list <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-edac@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 27 Aug 2018 21:22:19 +0200
Jann Horn <jannh@google.com> wrote:

> On Mon, Aug 27, 2018 at 9:02 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Mon, Aug 27, 2018 at 11:56 AM, Jann Horn <jannh@google.com> wrote:
> > > This removes the call into exception fixup that was added in
> > > commit c28f896634f2 ("[PATCH] kprobes: fix broken fault handling for
> > > x86_64").
> > >
> > > On X86, kprobe_fault_handler() is called from two places:
> > > do_general_protection() (for #GP) and kprobes_fault() (for #PF).
> > > In both paths, the fixup_exception() call in the kprobe fault handler is
> > > redundant.
> > >
> > > For #GP, fixup_exception() is called immediately before
> > > kprobe_fault_handler() is invoked - if someone wanted to fix up our #GP,
> > > they've already done so, no need to try again. (This assumes that the
> > > kprobe's fault handler isn't going to do something crazy like changing RIP
> > > so that it suddenly points to an instruction that does userspace access.)
> >
> > This needs review by someone who understands kprobes better than I do.
> > What happens if someone puts a kprobe on a uaccess instruction and the
> > uaccess subsequently faults?
> 
> Ugh, good point. I'll admit to not having thought about that properly.
> 
> I think that's the "if (unlikely(regs->ip == (unsigned
> long)cur->ainsn.insn))" branch in kprobe_fault_handler(), which I'm
> not touching.

Correct, probing on uaccess is handled by that block.
So this fixup_exception() is just for safeness.
As Jann said, no_context() handles it correctly, we don't need it.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> 
> For #PF, both without and with my patch, stuff should get fixed up by
> the normal pagefault handler, since the fixup happens after the kprobe
> handler has fiddled with the exception state.
> 
> For #GP, we're already past the fixup call, and I think both without
> and with my patch, nothing will catch it - so I think that's a bug,
> but I don't think it's one I'm introducing.
> 
> > > For #PF on a kernel address from kernel space, after the kprobe fault
> > > handler has run, we'll go into no_context(), which calls fixup_exception().
> > >
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > ---
> > >  arch/x86/kernel/kprobes/core.c | 7 -------
> > >  1 file changed, 7 deletions(-)
> > >
> > > diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> > > index 467ac22691b0..7315ac202aad 100644
> > > --- a/arch/x86/kernel/kprobes/core.c
> > > +++ b/arch/x86/kernel/kprobes/core.c
> > > @@ -1021,13 +1021,6 @@ int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
> > >                 if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
> > >                         return 1;
> > >
> > > -               /*
> > > -                * In case the user-specified fault handler returned
> > > -                * zero, try to fix up.
> > > -                */
> > > -               if (fixup_exception(regs, trapnr))
> > > -                       return 1;
> > > -
> > >                 /* fixup routine could not handle it. */
> > >         }
> > >
> > > --
> > > 2.19.0.rc0.228.g281dcd1b4d0-goog
> > >


-- 
Masami Hiramatsu <mhiramat@kernel.org>
