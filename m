Date: Thu, 25 Jan 2018 22:05:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1801252204250.2203@nanos>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org> <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com> <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 25 Jan 2018, Andy Lutomirski wrote:
> On Thu, Jan 25, 2018 at 10:48 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Mon, Jan 22, 2018 at 10:55 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> Honestly, I'd rather get rid of the fast-path entirely. Compared to
> >> all the PTI mess, it's not even noticeable.
> >
> > So I looked at how that would be.
> >
> > Patch attached. Not really "tested", but I'm running the kernel with
> > this patch now, and 'strace' etc works, and honestly, it seems very
> > obvious.
> >
> > Also, code generation for 'do_syscall_64()' does not look horrible. In
> > fact, it doesn't look all that much worse than the fast-path ever did.
> >
> > So the biggest impact of this is the extra register saves
> > (SAVE_EXTRA_REGS) from setting up the full ptregs. And honestly, I
> > hate how that stupid macro still uses "movq reg,off(%rsp)" instead of
> > "pushq %reg".
> >
> > Considering the diffstat:
> >
> >  2 files changed, 2 insertions(+), 121 deletions(-)
> >
> > and how those 100+ lines are nasty assembly code, I do think we should
> > just do it.
> 
> Feel free to Acked-by: Andy Lutomirski <luto@kernel.org> that patch.
> 
> Or I can grab it and send it to -tip.

That would be nice, so we can route it through x86/pti which provides it
for backporting cleanly.

Thanks,

	tglx
