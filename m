Date: Mon, 10 Apr 2017 11:29:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170410102938.GB13899@leverpostej>
References: <1490811363-93944-5-git-send-email-keescook@chromium.org>
 <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
 <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com>
 <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com>
 <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
 <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos>
 <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
 <20170407144526.zxgvpnxt6n7twhqw@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407144526.zxgvpnxt6n7twhqw@hirez.programming.kicks-ass.net>
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement
 __arch_rare_write_begin/unmap()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 07, 2017 at 04:45:26PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 07, 2017 at 12:51:15PM +0200, Mathias Krause wrote:
> > Why that? It allows fast and CPU local modifications of r/o memory.
> > OTOH, an approach that needs to fiddle with page table entries
> > requires global synchronization to keep the individual TLB states in
> > sync. Hmm.. Not that fast, I'd say.
> 
> The fixmaps used for kmap_atomic are per-cpu, no global sync required.

That might be fine for x86, but for some architectures fixmap slots and
kmap_atomic mappings happen to be visible to other CPUs even if they're
not required to be.

Using an mm solves that for all, though.

Thanks,
Mark.
