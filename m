Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2016 11:37:21 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20160815103721.GF13262@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
 <20160815094842.GB22320@e104818-lin.cambridge.arm.com>
 <20160815095813.GA1996@svinekod>
 <CAKv+Gu99SNzKVccod_2At1vsmHfgO4fnqVYbVJ8Fjdd4k68RXg@mail.gmail.com>
 <20160815100649.GB1996@svinekod>
 <CAKv+Gu-nrAvdqy9Yb=vP1RysWY+gZqHdiMv6fdDKN4-gBPivDA@mail.gmail.com>
 <20160815103000.GE13262@arm.com>
 <CAKv+Gu_8d7Vf+TzQnqaofNj62L-=qkht4av-6mCYZoWkucz8RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_8d7Vf+TzQnqaofNj62L-=qkht4av-6mCYZoWkucz8RA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 15, 2016 at 12:31:29PM +0200, Ard Biesheuvel wrote:
> On 15 August 2016 at 12:30, Will Deacon <will.deacon@arm.com> wrote:
> > On Mon, Aug 15, 2016 at 12:21:00PM +0200, Ard Biesheuvel wrote:
> >> As to Will's point, I suppose there is a window where a speculative
> >> TLB fill could occur, so I suppose that means updating TTBR0_EL1.ASID
> >> first, then TCR_EL1.EPD0, and finally perform the TLBI ASIDE1 on the
> >> reserved ASID.
> >
> > But then what do you gain from the reserved ASID?
> >
> 
> To prevent TLB hits against the ASID of the current (disabled)
> userland translation

Right, but if the sequence you described ensures that, then why not just
set TCR_EL1.EPD0 and do TLBI ASIDE1 on the current ASID?

I don't see the difference between a TLB entry formed from a speculative
fill using the reserved ASID and one formed using a non-reserved ASID --
the page table is the same.

Will
