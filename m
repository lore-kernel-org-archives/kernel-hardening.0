MIME-Version: 1.0
In-Reply-To: <nycvar.YSQ.7.76.1709041431320.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170903120757.14968-25-ard.biesheuvel@linaro.org> <nycvar.YSQ.7.76.1709041431320.8603@knanqh.ubzr>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 4 Sep 2017 20:29:32 +0100
Message-ID: <CAKv+Gu_wjpDwKok1OK1bFai-bfZ39MRbEeKQyP4sQgtfJNGyYg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 24/29] ARM: kernel: implement randomization of the
 kernel load address
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 4 September 2017 at 19:44, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Sun, 3 Sep 2017, Ard Biesheuvel wrote:
>
>> This implements randomization of the placement of the kernel image
>> inside the lowmem region. It is intended to work together with the
>> decompressor to place the kernel at an offset in physical memory
>> that is a multiple of 2 MB, and to take the same offset into account
>> when creating the virtual mapping.
>>
>> This uses runtime relocation of the kernel built as a PIE binary, to
>> fix up all absolute symbol references to refer to their runtime virtual
>> address. The physical-to-virtual mapping remains unchanged.
>>
>> In order to allow the decompressor to hand over to the core kernel
>> without making assumptions that are not guaranteed to hold when
>> invoking the core kernel directly using bootloaders that are not
>> KASLR aware, the KASLR offset is expected to be placed in r3 when
>> entering the kernel 4 bytes past the entry point, skipping the first
>> instruction.
>>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm/Kconfig       |  15 +++
>>  arch/arm/kernel/head.S | 103 ++++++++++++++++++--
>>  2 files changed, 109 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 300add3b8023..fe4a2cd1f15c 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1825,6 +1825,21 @@ config XEN
>>       help
>>         Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
>>
>> +config RANDOMIZE_BASE
>> +     bool "Randomize the address of the kernel image"
>> +     depends on MMU && AUTO_ZRELADDR
>> +     depends on !XIP_KERNEL && !ZBOOT_ROM
>
> This should work even if ZBOOT_ROM is selected. The ZBOOT_ROM option
> allows for the decompressor executing directly from ROM and
> decompressing the kernel anywhere in RAM.
>

In principle, yes. But currently, the code is not entirely XIP clean,
i.e., the kaslr_offset and __efi_boot variables are in .text but
assumed to be writable.

For UEFI, this does not really matter, because that implies !XIP.
However, I agree it would be nice if ZBOOT_ROM could run this code as
well, but it requires a global variable. I will try to make that work.
