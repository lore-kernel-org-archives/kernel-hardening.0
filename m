Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jan 2016 16:26:17 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160113162616.GK23370@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-8-git-send-email-ard.biesheuvel@linaro.org>
 <20160112181336.GF4858@leverpostej>
 <CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
 <20160113135109.GJ23370@leverpostej>
 <CAKv+Gu9ka7EOJq9BsAw9ON2qYiERJYKkzyYG7XYn0uw93fpTgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ka7EOJq9BsAw9ON2qYiERJYKkzyYG7XYn0uw93fpTgg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 07/21] arm64: move kernel image to base of vmalloc area
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 13, 2016 at 04:50:24PM +0100, Ard Biesheuvel wrote:
> On 13 January 2016 at 14:51, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Jan 13, 2016 at 09:39:41AM +0100, Ard Biesheuvel wrote:
> >> But since KASAN always uses the first 1/8 of that VA space, I am going
> >> to rework this so that the non-KASAN constants never depend on the
> >> actual values but only on CONFIG_KASAN
> >
> > Personally I'd prefer that they were obviously defined in terms of each
> > other if possible (as this means that the definitions are obviously
> > consistent by construction).
> >
> > So if it's not too much of a pain to keep them that way it would be
> > nice to do so.
> >
> > [...]
> >
> 
> I am leaning towards adding this to asm/memory.h
> 
> #ifdef CONFIG_KASAN
> #define KASAN_SHADOW_SIZE (UL(1) << (VA_BITS - 3))
> #else
> #define KASAN_SHADOW_SIZE (0)
> #endif
> 
> and remove the #ifdef CONFIG_KASAN block from asm/pgtable.h. Then
> asm/kasan.h, which already includes asm/memory.h, can use it as region
> size, and none of the reshuffling I had to do before is necessary.

FWIW, that looks good to me.

[...]

> >> I do wonder what that means for memblocks that are not multiples of 16
> >> MB, though (below)
> >
> > Indeed.
> >
> > On a related note, something I've been thinking about is PA layout
> > fuzzing using VMs.
> >
> > It sounds like being able to test memory layouts would be useful for
> > cases like the above, and I suspect there are plenty of other edge cases
> > that we aren't yet aware of due to typical physical memory layouts being
> > fairly simple.
> >
> > It doesn't seem to be possible to force a particular physical memory
> > layout (and particular kernel, dtb, etc addresses) for QEMU or KVM
> > tool. I started looking into adding support to KVM tool, but there's a
> > fair amount of refactoring needed first.
> >
> > Another option might be a special EFI application that carves up memory
> > in a deliberate fashion to ensure particular fragmentation cases (e.g. a
> > bank that's SWAPPER_BLOCK_SIZE - PAGE_SIZE in length).
> >
> 
> I use mem= for this, in fact, and boot most of my machines and VMs
> with some value slightly below the actual available DRAM that is not a
> multiple of 2M

Sure. I do some testing with mem= to find some bugs. The problem is that
you can only vary the end address (prior to your patches), and don't get
much variation on the portions in the middle.

It's difficult to test for bugs with not-quite-adjacent regions, or
where particular sizes, alignment, or addresses are important.

For example, having memory that extends right to the end of the
kernel-supported PA range (even with gaps in the middle) is an edge case
we don't currently test. I have a suspicion that KASAN's shadow
lookahead (and allocation to account for this) wouldn't be quite right,
and I want to be able to properly test and verify that.

Thanks,
Mark.
