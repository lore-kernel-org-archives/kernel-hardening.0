Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160815161318.GH22320@e104818-lin.cambridge.arm.com>
References: <20160815095813.GA1996@svinekod> <CAKv+Gu99SNzKVccod_2At1vsmHfgO4fnqVYbVJ8Fjdd4k68RXg@mail.gmail.com>
 <20160815100649.GB1996@svinekod> <CAKv+Gu-nrAvdqy9Yb=vP1RysWY+gZqHdiMv6fdDKN4-gBPivDA@mail.gmail.com>
 <20160815103000.GE13262@arm.com> <CAKv+Gu_8d7Vf+TzQnqaofNj62L-=qkht4av-6mCYZoWkucz8RA@mail.gmail.com>
 <20160815103721.GF13262@arm.com> <CAKv+Gu-5Ckd0_ot-Le=7dL2Wn8E6198vEHPk0-E4VtRUw8c0BQ@mail.gmail.com>
 <20160815105205.GD22320@e104818-lin.cambridge.arm.com> <CAKv+Gu87t-AnDKvtk699CpEfkEPgB=6DE-8EhBCMMnczemVQ4Q@mail.gmail.com>
 <20160815161318.GH22320@e104818-lin.cambridge.arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 15 Aug 2016 21:04:58 +0200
Message-ID: <CAKv+Gu_eEHnQ1zJojCUwK8E8dyfSGkJPSa8Up-yVPw70PLB4JA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 15 August 2016 at 18:13, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Mon, Aug 15, 2016 at 12:56:58PM +0200, Ard Biesheuvel wrote:
>> On 15 August 2016 at 12:52, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > On Mon, Aug 15, 2016 at 12:43:31PM +0200, Ard Biesheuvel wrote:
>> >> But, how about we store the reserved ASID in TTBR1_EL1 instead, and
>> >> switch TCR_EL1.A1 and TCR_EL1.EPD0 in a single write? That way, we can
>> >> switch ASIDs and disable table walks atomically (I hope), and we
>> >> wouldn't need to change TTBR0_EL1 at all.
>> >
>> > I did this before for AArch32 + LPAE (patches on the list sometime last
>> > year I think). But the idea was nak'ed by the ARM architects. The
>> > TCR_EL1.A1 can be cached somewhere in the TLB state machine, so you need
>> > TLBI (IOW, toggling A1 does not guarantee an ASID switch).
>>
>> But how is TTBR0_EL1 any different? The ARM ARM equally mentions that
>> any of its field can be cached in a TLB, so by that reasoning, setting
>> a new ASID in TTBR0_EL1 would also require TLB maintenance.
>
> Not really because this register is also described as part of the
> context switching operation, so that would be an exception to the
> general rule of requiring TLB invalidation for cached registers.
>

Well, of course, requiring TLB maintenance to change the current ASID
would be silly. But the ASID is obviously cached in each TLB entry
that is generated while the ASID is active, which makes the sentence
'Any of the fields in this register are permitted to be cached in a
TLB.' a bit ambiguous, since it obviously does not mean that a stale
ASID may be cached by the table walker.

> If you keep reading the same paragraph, the ARM ARM becomes more
> subjective ;) and you may come to the conclusion that the reserved ASID
> (not TCR_EL1.A1 though) + TCR_EL1.EDP0 would do the trick but we need
> clarification from the architects rather than my random interpretation:
>
> Section "D4.7.1 General TLB maintenance requirements" states:
>
>   Some System register field descriptions state that the effect of the
>   field is permitted to be cached in a TLB. This means that all TLB
>   entries that might be affected by a change of the field must be
>   invalidated whenever that field is changed
>
> So the above kind of implies that only TLB *entries* that might be
> affected by a change of a control bit need to be invalidated and only
> the effect of such bit is cached (rather than the bit itself). The
> effect of EDP0==1 is that there is no page table walk on a miss, so
> there won't be any new entries cached in the TLB that would
> reflect/cache the effect of EDP0==1. We still need to follow this by a
> switch to the reserved ASID to make sure there are no other TLB entries
> for TTBR0 (and we shouldn't care about the window between EDP0=1 and
> ASID=reserved).
>

Indeed.

> Anyway, the above wouldn't help the code much since we still need to
> preserve/restore/switch the ASID of the current thread (that's unless we
> temporarily store TTBR0_EL1.ASID into the TTBR1_EL1.ASID field).

That is actually not such a bad idea. We could assign both fields at
context switch time, and simply copy it from TTBR1_EL1 to TTBR0_EL1
before doing the user access.

> The
> TCR_EL1.A1 trick would have been nice but explicitly rejected by the
> architects (I guess it's not part of the context switching sequence, so
> the hardware may not notice the A1 bit change).
>

Yeah, that's unfortunate. But I think this feature is important, and
combined with the hardened usercopy feature drastically reduces the
attack surface of the kernel, so I expect it to quickly make its way
into various 'stable' downstream trees. So I would really like to get
to the bottom of this.

-- 
Ard.
