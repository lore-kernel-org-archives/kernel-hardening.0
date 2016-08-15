Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160815095813.GA1996@svinekod>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
 <20160815094842.GB22320@e104818-lin.cambridge.arm.com> <20160815095813.GA1996@svinekod>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 15 Aug 2016 12:02:33 +0200
Message-ID: <CAKv+Gu99SNzKVccod_2At1vsmHfgO4fnqVYbVJ8Fjdd4k68RXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 15 August 2016 at 11:58, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Aug 15, 2016 at 10:48:42AM +0100, Catalin Marinas wrote:
>> On Sat, Aug 13, 2016 at 11:13:58AM +0200, Ard Biesheuvel wrote:
>> > On 12 August 2016 at 17:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > > This is the first (public) attempt at emulating PAN by disabling
>> > > TTBR0_EL1 accesses on arm64.
>> >
>> > I take it using TCR_EL1.EPD0 is too expensive?
>>
>> It would require full TLB invalidation on entering/exiting the kernel
>> and again for any user access. That's because the architecture allows
>> this bit to be cached in the TLB so without TLBI we wouldn't have any
>> guarantee that the actual PAN was toggled. I'm not sure it's even clear
>> whether a TLBI by ASID or a local one would suffice (likely OK for the
>> latter).
>
> It's worth noting that even ignoring the TLB-caching of TCR_EL1.EPD0, the
> control only affects the behaviour on a TLB miss. Thus to use EPD0 we'd at
> least need TLB invalidation by ASID to remove previously-allocated entries from
> TLBs.
>

... or update the ASID to the reserved ASID in TTBR0_EL1, but leave
the actual TTBR address alone.

This would remove the need for a zero page, and for recording the
original TTBR address in a per-cpu variable.
