Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2016 11:52:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160815105205.GD22320@e104818-lin.cambridge.arm.com>
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
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 15, 2016 at 12:43:31PM +0200, Ard Biesheuvel wrote:
> But, how about we store the reserved ASID in TTBR1_EL1 instead, and
> switch TCR_EL1.A1 and TCR_EL1.EPD0 in a single write? That way, we can
> switch ASIDs and disable table walks atomically (I hope), and we
> wouldn't need to change TTBR0_EL1 at all.

I did this before for AArch32 + LPAE (patches on the list sometime last
year I think). But the idea was nak'ed by the ARM architects. The
TCR_EL1.A1 can be cached somewhere in the TLB state machine, so you need
TLBI (IOW, toggling A1 does not guarantee an ASID switch).

-- 
Catalin
