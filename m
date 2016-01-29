Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160129182657.GI20099@e104818-lin.cambridge.arm.com>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
	<20160129182657.GI20099@e104818-lin.cambridge.arm.com>
Date: Fri, 29 Jan 2016 19:49:19 +0100
Message-ID: <CAKv+Gu_ANOm_skhVVBwK-1+yVP614FWeCo87aGN7iFjmUj95Ug@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 00/22] arm64: implement support for KASLR
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Stuart Yoder <stuart.yoder@freescale.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

giOn 29 January 2016 at 19:26, Catalin Marinas <catalin.marinas@arm.com> wrote:
> Hi Ard,
>
> On Tue, Jan 26, 2016 at 06:10:27PM +0100, Ard Biesheuvel wrote:
>> Code can be found here:
>> git://git.linaro.org/people/ard.biesheuvel/linux-arm.git arm64-kaslr-v4a
>> https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/shortlog/refs/heads/arm64-kaslr-v4a
>
> The overall series looks fine but I'd like more time to review the KASLR
> part together with the module PLT stuff.
>
> So could you please split this series in 2-3 parts for easy merging
> (possibly without the KASLR part, it depends on how the review goes)?

Sure

> It
> looks like a mix of features in random order like huge-vmap, relative
> extable, kernel memory layout changes, kernel load address, PIE and
> KASLR. So something like:
>
> 1. relative extable

This has been picked up by akpm in the mean time

> 2. huge-vmap

This is a single patch which is completely independent. I don't expect
it to conflict when applied in isolation.

> 3. kernel memory layout changes (moving kernel to the base of vmalloc
> range)
> 4. allow kernel loading at different phys offsets
> 5. module PLTs, relocations, PIE, relative kallsyms, KASLR

Relative kallsyms has also been picked up by akpm

> 6. efi_get_random_bytes
>
> 1-4 can be in the same branch but I currently find it hard to
> cherry-pick the non-PIE/non-KASLR patches without conflicts.
>

I think 3 logically coherent series that apply in sequence is
feasible. I will look into this on Monday

-- 
Ard.
