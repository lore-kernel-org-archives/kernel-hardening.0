From: "PaX Team" <pageexec@freemail.hu>
Date: Sun, 09 Apr 2017 14:47:20 +0200
MIME-Version: 1.0
Message-ID: <58EA2D58.17782.6ADE22BD@pageexec.freemail.hu>
In-reply-to: <CALCETrXd9MgAk2p72UMbOOoL2W1fP0UT_pc2bfG8r0t=qJotwg@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <58E7EF70.30766.621C4F44@pageexec.freemail.hu>, <CALCETrXd9MgAk2p72UMbOOoL2W1fP0UT_pc2bfG8r0t=qJotwg@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@kernel.org>
Cc: Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 Apr 2017 at 21:58, Andy Lutomirski wrote:

> On Fri, Apr 7, 2017 at 12:58 PM, PaX Team <pageexec@freemail.hu> wrote:
> > On 7 Apr 2017 at 9:14, Andy Lutomirski wrote:
> >> Then someone who cares about performance can benchmark the CR0.WP
> >> approach against it and try to argue that it's a good idea.  This
> >> benchmark should wait until I'm done with my PCID work, because PCID
> >> is going to make use_mm() a whole heck of a lot faster.
> >
> > in my measurements switching PCID is hovers around 230 cycles for snb-ivb
> > and 200-220 for hsw-skl whereas cr0 writes are around 230-240 cycles. there's
> > of course a whole lot more impact for switching address spaces so it'll never
> > be fast enough to beat cr0.wp.
> >
> 
> If I'm reading this right, you're saying that a non-flushing CR3 write
> is about the same cost as a CR0.WP write.  If so, then why should CR0
> be preferred over the (arch-neutral) CR3 approach?

cr3 (page table switching) isn't arch neutral at all ;). you probably meant
the higher level primitives except they're not enough to implement the scheme
as discussed before since the enter/exit paths are very much arch dependent.

on x86 the cost of the pax_open/close_kernel primitives comes from the cr0
writes and nothing else, use_mm suffers not only from the cr3 writes but
also locking/atomic ops and cr4 writes on its path and the inevitable TLB
entry costs. and if cpu vendors cared enough, they could make toggling cr0.wp
a fast path in the microcode and reduce its overhead by an order of magnitude.

>  And why would switching address spaces obviously be much slower? 
> There'll be a very small number of TLB fills needed for the actual
> protected access. 

you'll be duplicating TLB entries in the alternative PCID for both code
and data, where they will accumulate (=take room away from the normal PCID
and expose unwanted memory for access) unless you also flush them when
switching back (which then will cost even more cycles). also i'm not sure
that processors implement all the 12 PCID bits so depending on how many PCIDs
you plan to use, you could be causing even more unnecessary TLB replacements.
