Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 3 Jan 2016 14:50:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160103145008.GA1642@svinekod>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
 <11539877.krH4qBJsp9@wuerfel>
 <CAKv+Gu9nFaPES8u6fc7SQ0WFJVgV3O4uM2wNNoVWz8iaajyqTQ@mail.gmail.com>
 <11016384.rorhLcDd8i@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11016384.rorhLcDd8i@wuerfel>
Subject: [kernel-hardening] Re: [RFC PATCH 01/10] arm64: introduce KIMAGE_VADDR as the virtual
 base of the kernel region
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Stuart Yoder <stuart.yoder@freescale.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 28, 2015 at 03:11:25PM +0100, Arnd Bergmann wrote:
> On Monday 28 December 2015 13:07:44 Ard Biesheuvel wrote:
> > On 28 December 2015 at 12:50, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Monday 28 December 2015 12:20:45 Ard Biesheuvel wrote:
> > > How about a different approach that keeps the relocatable kernel, but moves it in
> > > physical memory with the same random offset as the virtual address? That way, both
> > > would be random, and you can keep the simple virt_to_phys() function.
> > >
> > > I suppose the downside of that is that the number of random bits is then limited
> > > by the size of the first memblock, which is smaller than the vmalloc area.
> > >
> > 
> > I don't see a reason to use the same virtual and physical offset
> > (other than the conditional). On arm64, it would be up to the
> > bootloader to decide where to put the Image in physical memory, and it
> > would be up to the kernel to decide whether or not to virtually remap
> > itself.
> 
> I see. If we pull in the bootloader to the discussion, there are a couple
> of related points that are not directly required for your series but that
> we should keep in mind anyway:
> 
> - We need to implement the randomization for each boot loader separately.
>   This is probably easy enough for grub, as it can tap the same random
>   number source that you use here, but a little harder for u-boot (requiring
>   to implement access to hardware rng separately on each platform) and
>   much harder to get done consistently in UEFI for direct kernel loading
>   since there is no common upstream.

In the GRUB case the kernel is loaded as an EFI application -- as far as I am
aware, GRUB for arm64 doesn't know anything about the Linux kernel Image
binary.

When loaded as an EFI application the EFI stub can perform the relocation,
which it already does if the kernel was laoded at an address it cannot execute
from. It looks like Ard's implemented that for v2.

Being (cold) booted from EFI is likely to be the most consistent case as we
have complete control over where the kernel is placed, bar some limitations
imposed by prior EFI applications or EFI itself.

> - once we have a random number in the bootloader, we should also pass that
>   through a DT property. This has been discussed multiple times in the past
>   and I think we had reached consensus already but don't know if we had
>   agreed on a specific DT property that contains the random number seed.

Any links for this? I don't recall spotting this discussion.

Thanks,
Mark.
