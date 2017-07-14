Date: Fri, 14 Jul 2017 22:27:18 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170714212717.GB1086@leverpostej>
References: <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej>
 <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej>
 <20170713175543.GA32528@leverpostej>
 <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
 <20170714103258.GA16128@leverpostej>
 <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com>
 <CAKv+Gu96YHXDta7=YdYO4=wtR3mGVdkzAkG6tSzS-vo7toiPXA@mail.gmail.com>
 <20170714140605.GB16687@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714140605.GB16687@leverpostej>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 14, 2017 at 03:06:06PM +0100, Mark Rutland wrote:
> On Fri, Jul 14, 2017 at 01:27:14PM +0100, Ard Biesheuvel wrote:
> > On 14 July 2017 at 11:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > On 14 July 2017 at 11:32, Mark Rutland <mark.rutland@arm.com> wrote:
> > >> On Thu, Jul 13, 2017 at 07:28:48PM +0100, Ard Biesheuvel wrote:
> 
> > >>> OK, so here's a crazy idea: what if we
> > >>> a) carve out a dedicated range in the VMALLOC area for stacks
> > >>> b) for each stack, allocate a naturally aligned window of 2x the stack
> > >>> size, and map the stack inside it, leaving the remaining space
> > >>> unmapped
> 
> > >> The logical ops (TST) and conditional branches (TB(N)Z, CB(N)Z) operate
> > >> on XZR rather than SP, so to do this we need to get the SP value into a
> > >> GPR.
> > >>
> > >> Previously, I assumed this meant we needed to corrupt a GPR (and hence
> > >> stash that GPR in a sysreg), so I started writing code to free sysregs.
> > >>
> > >> However, I now realise I was being thick, since we can stash the GPR
> > >> in the SP:
> > >>
> > >>         sub     sp, sp, x0      // sp = orig_sp - x0
> > >>         add     x0, sp, x0      // x0 = x0 - (orig_sp - x0) == orig_sp
> 
> That comment is off, and should say     x0 = x0 + (orig_sp - x0) == orig_sp
> 
> > >>         sub     x0, x0, #S_FRAME_SIZE
> > >>         tb(nz)  x0, #THREAD_SHIFT, overflow
> > >>         add     x0, x0, #S_FRAME_SIZE
> > >>         sub     x0, sp, x0
> > 
> > You need a neg x0, x0 here I think
> 
> Oh, whoops. I'd mis-simplified things.
> 
> We can avoid that by storing orig_sp + orig_x0 in sp:
> 
> 	add	sp, sp, x0	// sp = orig_sp + orig_x0
> 	sub	x0, sp, x0	// x0 = orig_sp
> 	< check > 
> 	sub	x0, sp, x0	// x0 = orig_x0
> 	sub	sp, sp, x0	// sp = orig_sp
> 
> ... which works in a locally-built kernel where I've aligned all the
> stacks.

FWIW, I've pushed out a somewhat cleaned-up (and slightly broken!)
version of said kernel source to my arm64/vmap-stack-align branch [1].
That's still missing the backtrace handling, IRQ stack alignment is
broken at least on 64K pages, and there's still more cleanup and rework
to do.

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/vmap-stack-align
