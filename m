Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Jun 2016 09:27:37 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
References: <cover.1466036668.git.luto@kernel.org>
 <20160616060538.GA3923@osiris>
 <CALCETrVD6aLzvgHxTji0mm5Fzkqq_h-bxWqF1bv+7z33UrgYgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVD6aLzvgHxTji0mm5Fzkqq_h-bxWqF1bv+7z33UrgYgA@mail.gmail.com>
Message-Id: <20160617072737.GA3960@osiris>
Subject: [kernel-hardening] Re: [PATCH 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 08:58:07PM -0700, Andy Lutomirski wrote:
> On Wed, Jun 15, 2016 at 11:05 PM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> > On Wed, Jun 15, 2016 at 05:28:22PM -0700, Andy Lutomirski wrote:
> >> Since the dawn of time, a kernel stack overflow has been a real PITA
> >> to debug, has caused nondeterministic crashes some time after the
> >> actual overflow, and has generally been easy to exploit for root.
> >>
> >> With this series, arches can enable HAVE_ARCH_VMAP_STACK.  Arches
> >> that enable it (just x86 for now) get virtually mapped stacks with
> >> guard pages.  This causes reliable faults when the stack overflows.
> >>
> >> If the arch implements it well, we get a nice OOPS on stack overflow
> >> (as opposed to panicing directly or otherwise exploding badly).  On
> >> x86, the OOPS is nice, has a usable call trace, and the overflowing
> >> task is killed cleanly.
> >
> > Do you have numbers which reflect the performance impact of this change?
> >
> 
> It seems to add ~1.5µs per thread creation/join pair, which is around
> 15% overhead.  I *think* the major cost is that vmalloc calls
> alloc_kmem_pages_node once per page rather than using a higher-order
> block if available.
> 
> Anyway, if anyone wants this to become faster, I think the way to do
> it would be to ask some friendly mm folks to see if they can speed up
> vmalloc.  I don't really want to dig in to the guts of the page
> allocator.  My instinct would be to add a new interface
> (GFP_SMALLER_OK?) to ask the page allocator for a high-order
> allocation such that, if a high-order block is not immediately
> available (on the freelist) then it should fall back to a smaller
> allocation rather than working hard to get a high-order allocation.
> Then vmalloc could use this, and vfree could free pages in blocks
> corresponding to whatever orders it got the pages in, thus avoiding
> the need to merge all the pages back together.
> 
> There's another speedup available: actually reuse allocations.  We
> could keep a very small freelist of vmap_areas with their associated
> pages so we could reuse them.  (We can't efficiently reuse a vmap_area
> without its backing pages because we need to flush the TLB in the
> middle if we do that.)

That's rather expensive. Just for the records: on s390 we use gcc's
architecture specific compile options (kernel: CONFIG_STACK_GUARD)

 -mstack-guard=stack-guard
 -mstack-size=stack-size

These generate two additional instructions at the beginning of each
function prologue and verify that the stack size left won't be below a
specified number of bytes. If so it would execute an illegal instruction.

A disassembly looks like this (r15 is the stackpointer):

0000000000000670 <setup_arch>:
     670:       eb 6f f0 48 00 24       stmg    %r6,%r15,72(%r15)
     676:       c0 d0 00 00 00 00       larl    %r13,676 <setup_arch+0x6>
     67c:       a7 f1 3f 80             tmll    %r15,16256  <--- test if enough space left
     680:       b9 04 00 ef             lgr     %r14,%r15
     684:       a7 84 00 01             je      686 <setup_arch+0x16> <--- branch to illegal op
     688:       e3 f0 ff 90 ff 71       lay     %r15,-112(%r15)

The branch jumps actually into the branch instruction itself since the 0001
part of the "je" instruction is an illegal instruction.

This catches at least wild stack overflows because of two many functions
being called.

Of course it doesn't catch wild accesses outside the stack because e.g. the
index into an array on the stack is wrong.

The runtime overhead is within noise ratio, therefore we have this always
enabled.
