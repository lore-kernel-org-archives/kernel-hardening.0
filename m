Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2016 12:00:49 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20160815110049.GG13262@arm.com>
References: <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
 <20160815094842.GB22320@e104818-lin.cambridge.arm.com>
 <20160815095813.GA1996@svinekod>
 <CAKv+Gu99SNzKVccod_2At1vsmHfgO4fnqVYbVJ8Fjdd4k68RXg@mail.gmail.com>
 <20160815100649.GB1996@svinekod>
 <CAKv+Gu-nrAvdqy9Yb=vP1RysWY+gZqHdiMv6fdDKN4-gBPivDA@mail.gmail.com>
 <20160815103000.GE13262@arm.com>
 <CAKv+Gu_8d7Vf+TzQnqaofNj62L-=qkht4av-6mCYZoWkucz8RA@mail.gmail.com>
 <20160815103721.GF13262@arm.com>
 <CAKv+Gu-5Ckd0_ot-Le=7dL2Wn8E6198vEHPk0-E4VtRUw8c0BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-5Ckd0_ot-Le=7dL2Wn8E6198vEHPk0-E4VtRUw8c0BQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 15, 2016 at 12:43:31PM +0200, Ard Biesheuvel wrote:
> On 15 August 2016 at 12:37, Will Deacon <will.deacon@arm.com> wrote:
> > On Mon, Aug 15, 2016 at 12:31:29PM +0200, Ard Biesheuvel wrote:
> >> On 15 August 2016 at 12:30, Will Deacon <will.deacon@arm.com> wrote:
> >> > On Mon, Aug 15, 2016 at 12:21:00PM +0200, Ard Biesheuvel wrote:
> >> >> As to Will's point, I suppose there is a window where a speculative
> >> >> TLB fill could occur, so I suppose that means updating TTBR0_EL1.ASID
> >> >> first, then TCR_EL1.EPD0, and finally perform the TLBI ASIDE1 on the
> >> >> reserved ASID.
> >> >
> >> > But then what do you gain from the reserved ASID?
> >> >
> >>
> >> To prevent TLB hits against the ASID of the current (disabled)
> >> userland translation
> >
> > Right, but if the sequence you described ensures that, then why not just
> > set TCR_EL1.EPD0 and do TLBI ASIDE1 on the current ASID?
> >
> 
> ... because then you wipe all the cached translations for current
> userland, which I suppose is best avoided. Wiping the reserved ASID
> only discards TLB entries that should not exist in the first place.

True, I guess we'd need to measure that vs. the extra cost of switching
to/from the reserved ASID.

> > I don't see the difference between a TLB entry formed from a speculative
> > fill using the reserved ASID and one formed using a non-reserved ASID --
> > the page table is the same.
> >
> 
> No, but EPD0 does not disable translations, it disable translation
> table walks on TLB misses, so we need to switch ASIDs to prevent user
> space accesses via TLB hits.

Right, only if you don't do the invalidation for the current ASID.

> But, how about we store the reserved ASID in TTBR1_EL1 instead, and
> switch TCR_EL1.A1 and TCR_EL1.EPD0 in a single write? That way, we can
> switch ASIDs and disable table walks atomically (I hope), and we
> wouldn't need to change TTBR0_EL1 at all.

I doubt that would work, unfortunately. Whilst the writes are atomic
from the point-of-view of the TCR, if the fields can be cached in the
TLB logic, then we can't guarantee the atomicity of changes to the
cached state. Nice idea, though!

Will
