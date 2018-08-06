MIME-Version: 1.0
In-Reply-To: <CAGXu5j+Tddmp_VgyvwTd+StEGtx=oGofeY+KpLD4OuPw+2=S2Q@mail.gmail.com>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
 <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com> <CAKv+Gu9X1CDpy+XvrmbSdjBjMb45eBW7JVsvsK_JQdUt2Dbvgw@mail.gmail.com>
 <b0c974a2-4e81-7855-7d4e-22834c5d8997@arm.com> <CAKv+Gu_ZzDbWwHVwOuoheXeN-ta_FjOT4Aj15=r56QZVTUK0FA@mail.gmail.com>
 <CAKv+Gu_wGk2Gdzd6WuOMZqz1tKHAWHL7pWm2Szyt0DZwPTCmOw@mail.gmail.com>
 <31443e6a-56b4-c4fb-82b1-b8eb5d7eebe1@arm.com> <CAGXu5jLj=KP038d-c+xzCx=Oogn1prH__oryQjNZZwNaAHaAAw@mail.gmail.com>
 <CAKv+Gu-9M0yO-rSXiREs11feEro0mJFcNN3Wkp_LSOGrKKd5dg@mail.gmail.com> <CAGXu5j+Tddmp_VgyvwTd+StEGtx=oGofeY+KpLD4OuPw+2=S2Q@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 6 Aug 2018 21:54:32 +0200
Message-ID: <CAKv+Gu-5ERHvqgXHR626QzKCZJPc0Cp5Ktv+gwucep5ZGvu9Vw@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>, Julien Thierry <julien.thierry@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 August 2018 at 21:50, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Aug 6, 2018 at 12:35 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 6 August 2018 at 20:49, Kees Cook <keescook@chromium.org> wrote:
>>> On Mon, Aug 6, 2018 at 10:45 AM, Robin Murphy <robin.murphy@arm.com> wrote:
>>>> I guess what I'm getting at is that if the protection mechanism is "always
>>>> return with SP outside TTBR1", there seems little point in going through the
>>>> motions if SP in TTBR0 could still be valid and allow an attack to succeed
>>>> anyway; this is basically just me working through a justification for saying
>>>> the proposed scheme needs "depends on ARM64_PAN || ARM64_SW_TTBR0_PAN",
>>>> making it that much uglier for v8.0 CPUs...
>>>
>>> I think anyone with v8.0 CPUs interested in this mitigation would also
>>> very much want PAN emulation. If a "depends on" isn't desired, what
>>> about "imply" in the Kconfig?
>>>
>>
>> Yes, but actually, using bit #0 is maybe a better alternative in any
>> case. You can never dereference SP with bit #0 set, regardless of
>> whether the address points to user or kernel space, and my concern
>> about reloading sp from x29 doesn't really make sense, given that x29
>> is always assigned from sp right after pushing x29 and x30 in the
>> function prologue, and sp only gets restored from x29 in the epilogue
>> when there is a stack frame to begin with, in which case we add #1 to
>> sp again before returning from the function.
>
> Fair enough! :)
>
>> The other code gets a lot cleaner as well.
>>
>> So for the return we'll have
>>
>>   ldp     x29, x30, [sp], #nn
>>>>add     sp, sp, #0x1
>>   ret
>>
>> and for the function call
>>
>>   bl      <foo>
>>>>mov      x30, sp
>>>>bic     sp, x30, #1
>>
>> The restore sequence in entry.s:96 (which has no spare registers) gets
>> much simpler as well:
>>
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -95,6 +95,15 @@ alternative_else_nop_endif
>>          */
>>         add     sp, sp, x0      // sp' = sp + x0
>>         sub     x0, sp, x0      // x0' = sp' - x0 = (sp + x0) - x0 = sp
>> +#ifdef CONFIG_ARM64_ROP_SHIELD
>> +       tbnz    x0, #0, 1f
>> +       .subsection     1
>> +1:     sub     x0, x0, #1
>> +       sub     sp, sp, #1
>> +       b       2f
>> +       .previous
>> +2:
>> +#endif
>>         tbnz    x0, #THREAD_SHIFT, 0f
>>         sub     x0, sp, x0      // x0'' = sp' - x0' = (sp + x0) - sp = x0
>>         sub     sp, sp, x0      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
>
> I get slightly concerned about "add" vs "clear bit", but I don't see a
> real way to chain a lot of "add"s to get to avoid the unaligned
> access. Is "or" less efficient than "add"?
>

Yes. The stack pointer is special on arm64, and can only be used with
a limited set of ALU instructions. So orring #1 would involve 'mov
<reg>, sp ; orr sp, <reg>, #1' like in the 'bic' case above, which
requires a scratch register as well.
