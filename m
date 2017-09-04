MIME-Version: 1.0
In-Reply-To: <nycvar.YSQ.7.76.1709041427300.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170903120757.14968-24-ard.biesheuvel@linaro.org> <nycvar.YSQ.7.76.1709041427300.8603@knanqh.ubzr>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 4 Sep 2017 20:26:34 +0100
Message-ID: <CAKv+Gu-JjDXUBGtXEdYSyn5qhzCVq3mTc9-zfhBto=c5gbPEXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 23/29] ARM: kernel: refer to swapper_pg_dir via its symbol
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 4 September 2017 at 19:30, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Sun, 3 Sep 2017, Ard Biesheuvel wrote:
>
>> The location of swapper_pg_dir is relative to the kernel, not to
>> PAGE_OFFSET or PHYS_OFFSET. So define the symbol relative to the
>> start of the kernel image, and refer to it via its name.
>
> Could it cause a section access mismatch if defined in the __HEAD
> section?
>

No, I never saw any mismatch warnings building this code, and I don't
think .head.text is treated as an __init section.

> Otherwise
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
>

Thanks

>>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm/kernel/head.S | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
>> index 5d685e86148c..71bc0d037bc9 100644
>> --- a/arch/arm/kernel/head.S
>> +++ b/arch/arm/kernel/head.S
>> @@ -48,14 +48,6 @@
>>  #define PMD_ORDER    2
>>  #endif
>>
>> -     .globl  swapper_pg_dir
>> -     .equ    swapper_pg_dir, KERNEL_RAM_VADDR - PG_DIR_SIZE
>> -
>> -     .macro  pgtbl, rd, phys
>> -     add     \rd, \phys, #TEXT_OFFSET
>> -     sub     \rd, \rd, #PG_DIR_SIZE
>> -     .endm
>> -
>>  /*
>>   * Kernel startup entry point.
>>   * ---------------------------
>> @@ -77,6 +69,9 @@
>>       .arm
>>
>>       __HEAD
>> +     .globl  swapper_pg_dir
>> +     .equ    swapper_pg_dir, . - PG_DIR_SIZE
>> +
>>  ENTRY(stext)
>>   ARM_BE8(setend      be )                    @ ensure we are in BE8 mode
>>
>> @@ -172,7 +167,7 @@ ENDPROC(stext)
>>   *  r4 = physical page table address
>>   */
>>  __create_page_tables:
>> -     pgtbl   r4, r8                          @ page table address
>> +     adr_l   r4, swapper_pg_dir              @ page table address
>>
>>       /*
>>        * Clear the swapper page table
>> --
>> 2.11.0
>>
>>
