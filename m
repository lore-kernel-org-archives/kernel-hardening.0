Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160212182527.GG20262@leverpostej>
References: <1455293599-6974-1-git-send-email-jeremy.linton@arm.com>
	<20160212182527.GG20262@leverpostej>
Date: Tue, 16 Feb 2016 10:10:01 -0800
Message-ID: <CAGXu5jLpj=ue49_N+LOYvtZcU3rpFR5=WTG15ySDOWprvRzFUA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: mm: Mark .rodata as RO
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <laura@labbott.name>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 12, 2016 at 10:25 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Feb 12, 2016 at 10:13:19AM -0600, Jeremy Linton wrote:
>> Currently the .rodata section is actually still executable when DEBUG_RODATA
>> is enabled. This changes that so the .rodata is actually read only, no execute.
>>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>

Yikes, good catch. Is anyone running the lkdtm tests that check these things?

Reviewed-by: Kees Cook <keescook@chromium.org>

>> ---
>>  arch/arm64/kernel/vmlinux.lds.S |  5 +++--
>>  arch/arm64/mm/mmu.c             | 14 +++++++++++---
>>  2 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
>> index ab4e436..2e2c053 100644
>> --- a/arch/arm64/kernel/vmlinux.lds.S
>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>> @@ -114,8 +114,9 @@ SECTIONS
>>               *(.got)                 /* Global offset table          */
>>       }
>>
>> -     RO_DATA(PAGE_SIZE)
>> -     EXCEPTION_TABLE(8)
>> +     ALIGN_DEBUG_RO_MIN(0)
>> +     RO_DATA(PAGE_SIZE)              /* everything from this point to */
>> +     EXCEPTION_TABLE(8)              /* _etext will be marked RO NX   */
>>       NOTES
>>
>>       ALIGN_DEBUG_RO_MIN(PAGE_SIZE)
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index ab69a99..a3f4112 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -453,10 +453,18 @@ static void __init map_mem(pgd_t *pgd)
>>  #ifdef CONFIG_DEBUG_RODATA
>>  void mark_rodata_ro(void)
>>  {
>> -     create_mapping_late(__pa(_stext), (unsigned long)_stext,
>> -                             (unsigned long)_etext - (unsigned long)_stext,
>> -                             PAGE_KERNEL_ROX);
>> +     unsigned long section_size;
>>
>> +     section_size = (unsigned long)__start_rodata - (unsigned long)_stext;
>> +     create_mapping_late(__pa(_stext), (unsigned long)_stext,
>> +                         section_size, PAGE_KERNEL_ROX);
>> +     /*
>> +      * mark .rodata as read only. Use _etext rather than __end_rodata to
>> +      * cover NOTES and EXCEPTION_TABLE.
>> +      */
>> +     section_size = (unsigned long)_etext - (unsigned long)__start_rodata;
>> +     create_mapping_late(__pa(__start_rodata), (unsigned long)__start_rodata,
>> +                         section_size, PAGE_KERNEL_RO);
>>  }
>
> As you pointed out in the other thread, we'll also need to update
> map_kernel to use equivalent chunks for .text and .rodata.
>
> I think we can probably make .rodata RO from the outset in map_kernel,
> too.

There's a benefit to marking it late in that .rodata can live in the
same (upcoming) section as .data..ro_after_init, which is marked ro
after mark_rodata_ro() to help constify more things.

> Could you please update mem_init to log .text and .rodata separately?
>
> It looks like some core code makes assumptions about _etext, so I guess
> that has to cover .rodata regardless.
>
> Otherwise, looks good!
>
> Thanks,
> Mark.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
