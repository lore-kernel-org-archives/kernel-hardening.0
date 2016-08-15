Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 15 Aug 2016 10:48:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160815094842.GB22320@e104818-lin.cambridge.arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9hz_=GSRYgW3RueVhUA8F3HaM5DC_8Jkbx1JHF3x5mKg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] arm64: Privileged Access Never
 using TTBR0_EL1 switching
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, James Morse <james.morse@arm.com>, Julien Grall <julien.grall@arm.com>, Will Deacon <will.deacon@arm.com>, Kees Cook <keescook@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Aug 13, 2016 at 11:13:58AM +0200, Ard Biesheuvel wrote:
> On 12 August 2016 at 17:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > This is the first (public) attempt at emulating PAN by disabling
> > TTBR0_EL1 accesses on arm64.
> 
> I take it using TCR_EL1.EPD0 is too expensive?

It would require full TLB invalidation on entering/exiting the kernel
and again for any user access. That's because the architecture allows
this bit to be cached in the TLB so without TLBI we wouldn't have any
guarantee that the actual PAN was toggled. I'm not sure it's even clear
whether a TLBI by ASID or a local one would suffice (likely OK for the
latter).

While I don't have numbers currently, it would be hard to test on the
multitude of partner ARMv8 implementations, especially since that's not
something people would expect to optimise the hardware for.

-- 
Catalin
