Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jan 2016 13:51:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160113135109.GJ23370@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-8-git-send-email-ard.biesheuvel@linaro.org>
 <20160112181336.GF4858@leverpostej>
 <CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 07/21] arm64: move kernel image to base of vmalloc area
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 13, 2016 at 09:39:41AM +0100, Ard Biesheuvel wrote:
> On 12 January 2016 at 19:14, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Mon, Jan 11, 2016 at 02:19:00PM +0100, Ard Biesheuvel wrote:
> >> This moves the module area to right before the vmalloc area, and
> >> moves the kernel image to the base of the vmalloc area. This is
> >> an intermediate step towards implementing kASLR, where the kernel
> >> image can be located anywhere in the vmalloc area.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> ---
> >>  arch/arm64/include/asm/kasan.h          | 20 ++++---
> >>  arch/arm64/include/asm/kernel-pgtable.h |  5 +-
> >>  arch/arm64/include/asm/memory.h         | 18 ++++--
> >>  arch/arm64/include/asm/pgtable.h        |  7 ---
> >>  arch/arm64/kernel/setup.c               | 12 ++++
> >>  arch/arm64/mm/dump.c                    | 12 ++--
> >>  arch/arm64/mm/init.c                    | 20 +++----
> >>  arch/arm64/mm/kasan_init.c              | 21 +++++--
> >>  arch/arm64/mm/mmu.c                     | 62 ++++++++++++++------
> >>  9 files changed, 118 insertions(+), 59 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
> >> index de0d21211c34..2c583dbf4746 100644
> >> --- a/arch/arm64/include/asm/kasan.h
> >> +++ b/arch/arm64/include/asm/kasan.h
> >> @@ -1,20 +1,16 @@
> >>  #ifndef __ASM_KASAN_H
> >>  #define __ASM_KASAN_H
> >>
> >> -#ifndef __ASSEMBLY__
> >> -
> >>  #ifdef CONFIG_KASAN
> >>
> >>  #include <linux/linkage.h>
> >> -#include <asm/memory.h>
> >> -#include <asm/pgtable-types.h>
> >>
> >>  /*
> >>   * KASAN_SHADOW_START: beginning of the kernel virtual addresses.
> >>   * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/8 of kernel virtual addresses.
> >>   */
> >> -#define KASAN_SHADOW_START      (VA_START)
> >> -#define KASAN_SHADOW_END        (KASAN_SHADOW_START + (1UL << (VA_BITS - 3)))
> >> +#define KASAN_SHADOW_START   (VA_START)
> >> +#define KASAN_SHADOW_END     (KASAN_SHADOW_START + (_AC(1, UL) << (VA_BITS - 3)))
> >>
> >>  /*
> >>   * This value is used to map an address to the corresponding shadow
> >> @@ -26,16 +22,22 @@
> >>   * should satisfy the following equation:
> >>   *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END - (1ULL << 61)
> >>   */
> >> -#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << (64 - 3)))
> >> +#define KASAN_SHADOW_OFFSET  (KASAN_SHADOW_END - (_AC(1, ULL) << (64 - 3)))
> >> +
> >
> > I couldn't immediately spot where KASAN_SHADOW_* were used in assembly.
> > I guess there's some other definition built atop of them that I've
> > missed.
> >
> > Where should I be looking?
> >
> 
> Well, the problem is that KIMAGE_VADDR will be defined in terms of
> KASAN_SHADOW_END if KASAN is enabled.

Ah. I'd somehow managed to overlook that. Thanks for pointing that out!

> But since KASAN always uses the first 1/8 of that VA space, I am going
> to rework this so that the non-KASAN constants never depend on the
> actual values but only on CONFIG_KASAN

Personally I'd prefer that they were obviously defined in terms of each
other if possible (as this means that the definitions are obviously
consistent by construction).

So if it's not too much of a pain to keep them that way it would be
nice to do so.

[...]

> >> +     vmlinux_vm.flags        = VM_MAP;
> >
> > I was going to say we should set VM_KASAN also per its description in
> > include/vmalloc.h, though per its uses its not clear if it will ever
> > matter.
> >
> 
> No, we shouldn't. Even if we are never going to unmap this vma,
> setting the flag will result in the shadow area being freed using
> vfree(), while it was not allocated via vmalloc() so that is likely to
> cause trouble.

Ok.

> >> +     vm_area_add_early(&vmlinux_vm);
> >
> > Do we need to register the kernel VA range quite this early, or could we
> > do this around paging_init/map_kernel time?
> >
> 
> No. Locally, I moved it into map_kernel_chunk, so that we have
> separate areas for _text, _init and _data, and we can unmap the _init
> entirely rather than only stripping the exec bit. I haven't quite
> figured out how to get rid of the vma area, but perhaps it make sense
> to keep it reserved, so that modules don't end up there later (which
> is possible with the module region randomization I have implemented
> for v4) since I don't know how well things like kallsyms etc cope with
> that.

Keeping that reserved sounds reasonable to me.

[...]

> >>  void __init kasan_init(void)
> >>  {
> >> +     u64 kimg_shadow_start, kimg_shadow_end;
> >>       struct memblock_region *reg;
> >>
> >> +     kimg_shadow_start = round_down((u64)kasan_mem_to_shadow(_text),
> >> +                                    SWAPPER_BLOCK_SIZE);
> >> +     kimg_shadow_end = round_up((u64)kasan_mem_to_shadow(_end),
> >> +                                SWAPPER_BLOCK_SIZE);
> >
> > This rounding looks suspect to me, given it's applied to the shadow
> > addresses rather than the kimage addresses. That's roughly equivalent to
> > kasan_mem_to_shadow(round_up(_end, 8 * SWAPPER_BLOCK_SIZE).
> >
> > I don't think we need any rounding for the kimage addresses. The image
> > end is page-granular (and the fine-grained mapping will reflect that).
> > Any accesses between _end and roud_up(_end, SWAPPER_BLOCK_SIZE) would be
> > bugs (and would most likely fault) regardless of KASAN.
> >
> > Or am I just being thick here?
> >
> 
> Well, the problem here is that vmemmap_populate() is used as a
> surrogate vmalloc() since that is not available yet, and
> vmemmap_populate() allocates in SWAPPER_BLOCK_SIZE granularity.
> If I remove the rounding, I get false positive kasan errors which I
> have not quite diagnosed yet, but are probably due to the fact that
> the rounding performed by vmemmap_populate() goes in the wrong
> direction.

Ah. :(

I'll also take a peek.

> I do wonder what that means for memblocks that are not multiples of 16
> MB, though (below)

Indeed.

On a related note, something I've been thinking about is PA layout
fuzzing using VMs.

It sounds like being able to test memory layouts would be useful for
cases like the above, and I suspect there are plenty of other edge cases
that we aren't yet aware of due to typical physical memory layouts being
fairly simple.

It doesn't seem to be possible to force a particular physical memory
layout (and particular kernel, dtb, etc addresses) for QEMU or KVM
tool. I started looking into adding support to KVM tool, but there's a
fair amount of refactoring needed first.

Another option might be a special EFI application that carves up memory
in a deliberate fashion to ensure particular fragmentation cases (e.g. a
bank that's SWAPPER_BLOCK_SIZE - PAGE_SIZE in length).

Thanks,
Mark.
