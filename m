Date: Wed, 1 Mar 2017 11:50:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170301115012.GD28874@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-6-git-send-email-keescook@chromium.org>
 <20170301010408.GH21222@n2100.armlinux.org.uk>
 <CAGXu5jKq5NYrgYbcP+5rsVzLDfMRwLX027xDfO9_r90zDhJA-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKq5NYrgYbcP+5rsVzLDfMRwLX027xDfO9_r90zDhJA-w@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC][PATCH 5/8] ARM: Implement __arch_rare_write_map/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Tue, Feb 28, 2017 at 09:41:07PM -0800, Kees Cook wrote:
> On Tue, Feb 28, 2017 at 5:04 PM, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> > On Mon, Feb 27, 2017 at 12:43:03PM -0800, Kees Cook wrote:
> >> Based on grsecurity's ARM pax_{open,close}_kernel() implementation, this
> >> allows HAVE_ARCH_RARE_WRITE to work on ARM.
> >
> > This has the effect that any memory mapped with DOMAIN_KERNEL will
> > loose it's NX status, and may end up being read into the I-cache.
> 
> Arbitrarily so, or only memory accessed/pre-fetched by the CPU when in
> this state? 

While the MMU says the VA is executable, though "while" is difficult to
define, see below.

> i.e. since this is non-preempt, only touches the needed memory, and
> has the original domain state restored within a few instructions, does
> this avoid the problem? It seems like the chance for a speculative
> prefetch from device memory under these conditions should be
> approaching zero.

It's entirely possible for the I-cache to fetch within this window, even
if unlikely.

It is a bug to map devices without NX (on cores that have it), even
instantaneously.

You can't reason about this in terms of number of instructions, since
bits of the CPU can operate asynchronously anyhow. For example, the CPU
might stall immediately after the domain switch, fetching the next
instruction, and in the mean time the I-cache decides to send of
requests for some other arbitrary locations while waiting for a
response.

> > We used to do exactly this to support set_fs(KERNEL_DS) but it was
> > deemed to be way too problematical (for speculative prefetching)
> > to use it on ARMv6+.
> >
> > As vmalloc space ends up with a random mixture of DOMAIN_KERNEL and
> > DOMAIN_IO mappings (due to the order of ioremap() vs vmalloc()), this
> > means DOMAIN_KERNEL can cover devices... which with switching
> > DOMAIN_KERNEL to manager mode result in the NX being removed for
> > device mappings, which (iirc) is unpredictable.
> 
> Just to make sure I understand: it was only speculative prefetch vs
> icache, right? Would an icache flush restore the correct permissions?

The problem is that the fetch itself can be destructive. It can change
the state of a device (see below for an example), or trigger
(asynchronous) errors from the endpoint or interconnect.

No amount of cache maintenance can avoid this.

> I'm just pondering alternatives. Also, is there a maximum distance the
> prefetching spans? i.e. could device memory be guaranteed to be
> vmapped far enough away from kernel memory to avoid prefetches?

There is no practical limitation. The architecture permits a CPU's
I-cache to fetch from any mapping which does not have NX, at any point
in time that mapping is live, for any reason it sees fit.

For example, see commit b6ccb9803e90c16b ("ARM: 7954/1: mm: remove
remaining domain support from ARMv6").

In that case, while executing some kernel code (e.g. the sys_exec()
path), Cortex-A15's instruction fetch would occasionally fetch from the
GIC, ACKing interrupts in the process.

The only solution is to never map devices without NX.

Thanks,
Mark.
