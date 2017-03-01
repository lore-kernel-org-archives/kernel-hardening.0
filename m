Date: Wed, 1 Mar 2017 11:30:26 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170301113026.GI21222@n2100.armlinux.org.uk>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-6-git-send-email-keescook@chromium.org>
 <20170301010408.GH21222@n2100.armlinux.org.uk>
 <CAGXu5jKq5NYrgYbcP+5rsVzLDfMRwLX027xDfO9_r90zDhJA-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKq5NYrgYbcP+5rsVzLDfMRwLX027xDfO9_r90zDhJA-w@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [RFC][PATCH 5/8] ARM: Implement __arch_rare_write_map/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

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
> this state? i.e. since this is non-preempt, only touches the needed
> memory, and has the original domain state restored within a few
> instructions, does this avoid the problem? It seems like the chance
> for a speculative prefetch from device memory under these conditions
> should be approaching zero.

"The software that defines a translation table must mark any region of
 memory that is read-sensitive as execute-never, to avoid the possibility
 of a speculative fetch accessing the memory region. For example, it must
 mark any memory region that corresponds to a read-sensitive peripheral
 as Execute-never."

Also see:

commit 247055aa21ffef1c49dd64710d5e94c2aee19b58
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Mon Sep 13 16:03:21 2010 +0100

    ARM: 6384/1: Remove the domain switching on ARMv6k/v7 CPUs

which removed the domain switching I referred to previously.

The way the ARM ARM looks at instruction speculative prefetch is that it
can happen to any location that is not explicitly marked as Execute-never.
(This is because the ARM ARM doesn't define an implementation.)  So, we
have to assume that any location that is not marked XN may be speculatively
prefetched by the processor.

Device memory can be read-sensitive - eg, reading an interrupt status
register can clear the ending interrupt bits.

A speculative prefetch is a read as far as a device is concerned, so
bypassing the XN permission by switching the domain to manager mode has
the effect that the processor can then _legally_ speculatively prefetch
from a device, and if it happens to hit a device that contains a read
sensitive location, the side effects of reading that location will
happen, even though the program did not perform an explicit read.

> Just to make sure I understand: it was only speculative prefetch vs
> icache, right? Would an icache flush restore the correct permissions?

It's not about permissions, it's about the side effects at the device
of a read created by the speculative prefetch.

> I'm just pondering alternatives. Also, is there a maximum distance the
> prefetching spans? i.e. could device memory be guaranteed to be
> vmapped far enough away from kernel memory to avoid prefetches?

The root cause of this problem is the way we lump both vmalloc() and
ioremap() mappings into the same memory space (vmalloc region) without
caring about the domain.

If all device memory was guaranteed to be placed under a different
domain, then this problem would not exist.  In order to achieve that,
there's several ways I can think of doing it:

1) Have separate virtual memory regions for ioremap() and vmalloc()
   We would need to choose an arbitary limit on the size of these
   memory pools, which may not suit everyone.

2) Have vmalloc() grow up as a heap, ioremap() grow down as a stack
   and a dynamic boundary (aligned to 1 or 2MB) between the two, no
   mixing allowed.  This avoids the problem with (1) but still results
   in the required separation.

3) Align vmalloc region allocations to 2MB, but this would be very
   wasteful.

4) Only permit same type (ioremap/vmalloc) of mapping within a 2MB block
   of vmalloc space.  In other words, a primary allocator of 2MB blocks
   and a sub-allocator of page-sized blocks (think of the way our
   page allocator vs slab works.)  Probably going to be subject to
   fragmentation problems.

5) Place all vmalloc() and ioremap() mappings under a separate domain,
   so that all these mappings would be unaffected by the change of
   domain settings (the resulting permissions would never change.)
   In other words, DOMAIN_IO becomes DOMAIN_VMALLOC and is used for all
   mappings in vmalloc space.

The problem with (2) and (5) is teaching pte_alloc_kernel() down to
pmd_populate_kernel() about the differences - currently, this only ever
sets up DOMAIN_KERNEL mappings because there's no way for it to know
what kind of mapping is required.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
