Date: Thu, 13 Jul 2017 18:55:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170713175543.GA32528@leverpostej>
References: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
 <1499898783-25732-7-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8jey+uPSFoCsjQn9BeGiChZpS=iZ0v9nEWvkwcO1gFYg@mail.gmail.com>
 <20170713104950.GB26194@leverpostej>
 <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713161050.GG26194@leverpostej>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Takahiro Akashi <akashi.takahiro@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 13, 2017 at 05:10:50PM +0100, Mark Rutland wrote:
> On Thu, Jul 13, 2017 at 12:49:48PM +0100, Ard Biesheuvel wrote:
> > On 13 July 2017 at 11:49, Mark Rutland <mark.rutland@arm.com> wrote:
> > > On Thu, Jul 13, 2017 at 07:58:50AM +0100, Ard Biesheuvel wrote:
> > >> On 12 July 2017 at 23:33, Mark Rutland <mark.rutland@arm.com> wrote:

> > Given that the very first stp in kernel_entry will fault if we have
> > less than S_FRAME_SIZE bytes of stack left, I think we should check
> > that we have at least that much space available. 
> 
> I was going to reply saying that I didn't agree, but in writing up
> examples, I mostly convinced myself that this is the right thing to do.
> So I mostly agree!
> 
> This would mean we treat the first impossible-to-handle exception as
> that fatal case, which is similar to x86's double-fault, triggered when
> the HW can't stack the regs. All other cases are just arbitrary faults.
> 
> However, to provide that consistently, we'll need to perform this check
> at every exception boundary, or some of those cases will result in a
> recursive fault first.
> 
> So I think there are three choices:
> 
> 1) In el1_sync, only check SP bounds, and live with the recursive
>    faults.
> 
> 2) in el1_sync, check there's room for the regs, and live with the
>    recursive faults for overflow on other exceptions.
> 
> 3) In all EL1 entry paths, check there's room for the regs.

FWIW, for the moment I've applied (2), as you suggested, to my
arm64/vmap-stack branch, adding an additional:

	sub	x0, x0, #S_FRAME_SIZE

... to the entry path.

I think it's worth trying (3) so that we consistently report these
cases, benchmarks permitting.

It's probably worth putting the fast-path check directly into the
vectors, where we currently only use 1/32 of the instruction slots
available to us.

> As above, I think it's helpful to think of this as something closer to a
> double-fault handler (i.e. aiming to catch when we can't take the
> exception safely), rather than something that's trying to catch logical
> stack overflows.

Does this make sense to you?

I've tried to reword the log output, as below, to give this impression.

[   49.288232] Insufficient stack space to handle exception!
[   49.288245] CPU: 5 PID: 2208 Comm: bash Not tainted 4.12.0-00005-ga781af2 #81
[   49.300680] Hardware name: ARM Juno development board (r1) (DT)
[   49.306549] task: ffff800974955100 task.stack: ffff00000d6f0000
[   49.312426] PC is at recursive_loop+0x10/0x50
[   49.316747] LR is at recursive_loop+0x34/0x50
[   49.321066] pc : [<ffff000008588aa0>] lr : [<ffff000008588ac4>] pstate: 40000145
[   49.328398] sp : ffff00000d6eff30
[   49.331682] x29: ffff00000d6f0350 x28: ffff800974955100 
[   49.336953] x27: ffff000008942000 x26: ffff000008f0d758 
[   49.342223] x25: ffff00000d6f3eb8 x24: ffff00000d6f3eb8 
[   49.347493] x23: ffff000008f0d490 x22: 0000000000000009 
[   49.352764] x21: ffff800974a57000 x20: ffff000008f0d4e0 
[   49.358034] x19: 0000000000000013 x18: 0000ffffe7e2e4f0 
[   49.363304] x17: 0000ffff9c1256a4 x16: ffff0000081f8b88 
[   49.368574] x15: 00002a81b8000000 x14: 00000000fffffff0 
[   49.373845] x13: ffff000008f6278a x12: ffff000008e62818 
[   49.379115] x11: 0000000000000000 x10: 000000000000019e 
[   49.384385] x9 : 0000000000000004 x8 : ffff00000d6f0770 
[   49.389656] x7 : 1313131313131313 x6 : 000000000000019e 
[   49.394925] x5 : 0000000000000000 x4 : 0000000000000000 
[   49.400205] x3 : 0000000000000000 x2 : 0000000000000400 
[   49.405484] x1 : 0000000000000013 x0 : 0000000000000012 
[   49.410764] Task stack: [0xffff00000d6f0000..0xffff00000d6f4000]
[   49.416728] IRQ stack:  [0xffff80097ffb90a0..0xffff80097ffbd0a0]
[   49.422692] ESR: 0x96000047 -- DABT (current EL)
[   49.427277] FAR: 0xffff00000d6eff30
[   49.430742] Kernel panic - not syncing: kernel stack overflow
[   49.436451] CPU: 5 PID: 2208 Comm: bash Not tainted 4.12.0-00005-ga781af2 #81
[   49.443534] Hardware name: ARM Juno development board (r1) (DT)
[   49.449412] Call trace:
[   49.451852] [<ffff0000080885f0>] dump_backtrace+0x0/0x230
[   49.457218] [<ffff0000080888e4>] show_stack+0x14/0x20
[   49.462240] [<ffff00000839be0c>] dump_stack+0x9c/0xc0
[   49.467261] [<ffff000008175218>] panic+0x11c/0x294
[   49.472024] [<ffff000008089184>] handle_bad_stack+0xe4/0xe8
[   49.477561] [<ffff000008588ac4>] recursive_loop+0x34/0x50
[   49.482926] SMP: stopping secondary CPUs
[   49.487145] Kernel Offset: disabled
[   49.490609] Memory Limit: none
[   49.493649] ---[ end Kernel panic - not syncing: kernel stack overflow

... I still need to attack the backtracing to walk across stacks.

Thanks,
Mark.
