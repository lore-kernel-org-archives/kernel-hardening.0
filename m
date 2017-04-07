Date: Fri, 7 Apr 2017 15:14:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1704071426300.1716@nanos>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org> <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com> <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com> <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com> <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com> <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos> <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement
 __arch_rare_write_begin/unmap()
To: Mathias Krause <minipli@googlemail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 7 Apr 2017, Mathias Krause wrote:
> On 7 April 2017 at 11:46, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Whether protected by preempt_disable or local_irq_disable, to make that
> > work it needs CR0 handling in the exception entry/exit at the lowest
> > level. And that's just a nightmare maintainence wise as it's prone to be
> > broken over time.
> 
> It seems to be working fine for more than a decade now in PaX. So it
> can't be such a big maintenance nightmare ;)

I really do not care whether PaX wants to chase and verify that over and
over. I certainly don't want to take the chance to leak CR0.WP ever and I
very much care about extra stuff to check in the entry/exit path.

> The "proper solution" seems to be much slower compared to just
> toggling CR0.WP (which is costly in itself, already) because of the
> TLB invalidation / synchronisation involved.

Why the heck should we care about rare writes being performant?

> > It's valid (at least on x86) to have a shadow map with the same page
> > attributes but write enabled. That does not require any fixups of CR0 and
> > just works.
> 
> "Just works", sure -- but it's not as tightly focused as the PaX
> solution which is CPU local, while your proposed solution is globally
> visible.

Making the world and some more writeable hardly qualifies as tightly
focussed. Making the mapping concept CPU local is not rocket science
either. The question is whethers it's worth the trouble.

Thanks,

	tglx
