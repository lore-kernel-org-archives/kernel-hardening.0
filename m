Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 7 Jan 2016 14:25:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160107142541.GC15917@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-4-git-send-email-ard.biesheuvel@linaro.org>
 <20160107135518.GB15917@leverpostej>
 <CAKv+Gu-qdTDwnLajLw_hT6odessdi4Ndbe80CSvY6o1N6HDOmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-qdTDwnLajLw_hT6odessdi4Ndbe80CSvY6o1N6HDOmA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 03/13] arm64: use more granular reservations for
 static page table allocations
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 07, 2016 at 03:02:00PM +0100, Ard Biesheuvel wrote:
> On 7 January 2016 at 14:55, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Dec 30, 2015 at 04:26:02PM +0100, Ard Biesheuvel wrote:
> >> Before introducing new statically allocated page tables and increasing
> >> their alignment in subsequent patches, update the reservation logic
> >> so that only pages that are in actual use end up as reserved with
> >> memblock.
> >
> > Could you add something to the commit message about what this will gain
> > us (i.e. which pages we don't have to reserve)? It's not immediately
> > obvious why we'd have page tables we wouldn't want to reserve.
> >
> 
> OK. In the original series, I also aligned the pgdir section to a log2
> upper bound of its size, but that is not necessary anymore with your
> changes. So the original goal was to avoid reserving the alignment
> padding as well as the pgdirs that end up unused

Ah, I see.

> > From the looks of the next patch we won't have redundant levels of
> > fixmap table for a given configuration, so I guess we're catering for
> > the case the fixmap shares a pgd/pud/pmd entry with the image mapping?
> >
> > Does that happen? If so that would invalidate the assumption I make when
> > copying the fixmap over in [1] (see map_kernel).
> >
> 
> It is a lot less likely to happen now that I moved the kernel to the
> start of the vmalloc area rather than right below PAGE_OFFSET. But in
> general, it seems sensible to only populate entries after confirming
> that they are in fact vacant.

Sure.

> > To handle that either we need some special logic to copy over the
> > relevant bits for the fixmap (as with kasan_copy_shadow), or we need to
> > avoid sharing a pgd entry.
> >
> > Thoughts?
> >
> 
> Yes, I have added that to my v3 version of the vmalloc base move patch here
> 
> https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/commitdiff/0beef2c1a6bfc90cc116a6ba1b24f2ba35e7e5f6

Ah, great!

> but I think 16k/4 levels is the only config affected when the kernel
> is always in the lower half of the vmalloc area. That also implies
> that the fixmap pgd is either always shared, or never, depending on
> the build time config, so I could probably simplify that part
> somewhat.

Ok.

Thanks,
Mark.
