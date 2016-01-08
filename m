Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <568F8C9E.1010608@arm.com>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451489172-17420-13-git-send-email-ard.biesheuvel@linaro.org>
	<568F8C9E.1010608@arm.com>
Date: Fri, 8 Jan 2016 11:25:14 +0100
Message-ID: <CAKv+Gu_-VHrPH90-UUSf+yQWhMomRaq3kFNwwiLTUrHsdHJT+w@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 12/13] arm64: add support for relocatable kernel
To: James Morse <james.morse@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 8 January 2016 at 11:17, James Morse <james.morse@arm.com> wrote:
> Hi Ard!
>
> On 30/12/15 15:26, Ard Biesheuvel wrote:
>> This adds support for runtime relocation of the kernel Image, by
>> building it as a PIE (ET_DYN) executable and applying the dynamic
>> relocations in the early boot code.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>
>> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
>> index 01a33e42ed70..ab582ee58b58 100644
>> --- a/arch/arm64/kernel/head.S
>> +++ b/arch/arm64/kernel/head.S
>> @@ -243,6 +253,16 @@ ENDPROC(stext)
>>  preserve_boot_args:
>>       mov     x21, x0                         // x21=FDT
>>
>> +#ifdef CONFIG_ARM64_RELOCATABLE_KERNEL
>> +     /*
>> +      * Mask off the bits of the random value supplied in x1 so it can serve
>> +      * as a KASLR displacement value which will move the kernel image to a
>> +      * random offset in the lower half of the VMALLOC area.
>> +      */
>> +     mov     x23, #(1 << (VA_BITS - 2)) - 1
>> +     and     x23, x23, x1, lsl #SWAPPER_BLOCK_SHIFT
>> +#endif
>
> I've managed to make this fail to boot by providing a seed that caused
> the kernel to overlap a 1G boundary on a 4K system.
>

Ah, yes. Thanks for spotting that.

> (It looks like your v3 may have the same issue - but I haven't tested it.)
>
>

Yes, it does. It probably makes sense to sacrifice some entropy bits
and simply round up the kaslr offset to a log2 upper bound of the
kernel Image size, rather than hacking up some logic in assembly to
test whether we are crossing a PMD/PUD boundary


>> +
>>       adr_l   x0, boot_args                   // record the contents of
>>       stp     x21, x1, [x0]                   // x0 .. x3 at kernel entry
>>       stp     x2, x3, [x0, #16]
>
>
> Thanks!
>
> James
>
