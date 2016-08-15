Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2016 11:30:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160815103051.GD1996@svinekod>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
 <20160815094842.GB22320@e104818-lin.cambridge.arm.com>
 <20160815095813.GA1996@svinekod>
 <CAKv+Gu99SNzKVccod_2At1vsmHfgO4fnqVYbVJ8Fjdd4k68RXg@mail.gmail.com>
 <20160815100649.GB1996@svinekod>
 <CAKv+Gu-nrAvdqy9Yb=vP1RysWY+gZqHdiMv6fdDKN4-gBPivDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-nrAvdqy9Yb=vP1RysWY+gZqHdiMv6fdDKN4-gBPivDA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 15, 2016 at 12:21:00PM +0200, Ard Biesheuvel wrote:
> On 15 August 2016 at 12:06, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Mon, Aug 15, 2016 at 12:02:33PM +0200, Ard Biesheuvel wrote:
> >> On 15 August 2016 at 11:58, Mark Rutland <mark.rutland@arm.com> wrote:
> >> > On Mon, Aug 15, 2016 at 10:48:42AM +0100, Catalin Marinas wrote:
> >> >> On Sat, Aug 13, 2016 at 11:13:58AM +0200, Ard Biesheuvel wrote:
> >> >> > On 12 August 2016 at 17:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >> >> > > This is the first (public) attempt at emulating PAN by disabling
> >> >> > > TTBR0_EL1 accesses on arm64.
> >> >> >
> >> >> > I take it using TCR_EL1.EPD0 is too expensive?
> >> >>
> >> >> It would require full TLB invalidation on entering/exiting the kernel
> >> >> and again for any user access. That's because the architecture allows
> >> >> this bit to be cached in the TLB so without TLBI we wouldn't have any
> >> >> guarantee that the actual PAN was toggled. I'm not sure it's even clear
> >> >> whether a TLBI by ASID or a local one would suffice (likely OK for the
> >> >> latter).
> >> >
> >> > It's worth noting that even ignoring the TLB-caching of TCR_EL1.EPD0, the
> >> > control only affects the behaviour on a TLB miss. Thus to use EPD0 we'd at
> >> > least need TLB invalidation by ASID to remove previously-allocated entries from
> >> > TLBs.
> >>
> >> ... or update the ASID to the reserved ASID in TTBR0_EL1, but leave
> >> the actual TTBR address alone.
> >>
> >> This would remove the need for a zero page, and for recording the
> >> original TTBR address in a per-cpu variable.
> >
> > That's a good point, and a better approach.
> >
> > Unfortunately, we're still left with the issue that TCR_EL1.* can be cached in
> > a TLB, as Catalin pointed out. Which at minimum would require a TLBI ASIDE1,
> > and may require something stronger, given the precise rules for TLB-cached
> > fields isn't clear.
> 
> So how exactly would EPDn = 1 be cached in a TLB, given that the bit
> specifically means that TTBRn_ELn is ignored on a TLB *miss*. Doesn't
> that mean 'not covered by a TLB entry'? Or does it mean 'not covered
> by a TLB entry describing a valid translation'?

The ARM ARM uses 'TLB' to mean any internal storage used by the translation,
including internal registers. So it's not necessarily a TLB entry in the usual
sense.

Most of these make more sense if you consider that Stage-2 'TLBs' might cache
this information for the purpose of walking Stage-1 entries. There are other
potential reasons beyond that, though.

> I guess it indeed makes sense to get this clarified ...
> 
> As to Will's point, I suppose there is a window where a speculative
> TLB fill could occur, so I suppose that means updating TTBR0_EL1.ASID
> first, then TCR_EL1.EPD0, and finally perform the TLBI ASIDE1 on the
> reserved ASID.

I thought that too, but this could race with concurrent modification on another
CPU. That other CPU would perform maintenance with the usual ASID, then perhaps
modify/free entries.

There would be a window where the CPU doing the EPD0 + reserved-ASID trick
could have an erroneous view of the page tables, and walk garbage or allocate
conflicting entries.

Perhaps the ASID allocation logic could be modified to avoid that race, though.

Thanks,
Mark.
