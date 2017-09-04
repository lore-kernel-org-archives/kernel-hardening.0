MIME-Version: 1.0
In-Reply-To: <nycvar.YSQ.7.76.1709041409530.8603@knanqh.ubzr>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170903120757.14968-20-ard.biesheuvel@linaro.org> <nycvar.YSQ.7.76.1709041409530.8603@knanqh.ubzr>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 4 Sep 2017 20:10:00 +0100
Message-ID: <CAKv+Gu8TSBAz5vykf6iseYeGOaKYNYay-YMRH0_dKAg8JbTiiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 19/29] ARM: kernel: make vmlinux buildable as a PIE executable
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 4 September 2017 at 19:11, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Sun, 3 Sep 2017, Ard Biesheuvel wrote:
>
>> Update the build flags and linker script to allow vmlinux to be built
>> as a PIE  binary, which retains relocation information about absolute
>> symbol references so that they can be fixed up at runtime. This will
>> be used for implementing KASLR,
>>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm/Kconfig                 |  4 ++++
>>  arch/arm/Makefile                |  5 +++++
>>  arch/arm/include/asm/assembler.h |  2 +-
>>  arch/arm/kernel/vmlinux.lds.S    |  9 +++++++++
>>  include/linux/hidden.h           | 20 ++++++++++++++++++++
>>  scripts/module-common.lds        |  1 +
>>  6 files changed, 40 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 61a0cb15067e..300add3b8023 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -2085,6 +2085,10 @@ config DMI
>>         firmware need to be enabled. This would require the DMI subsystem
>>         to be enabled much earlier than we do on ARM, which is non-trivial.
>>
>> +config RELOCATABLE
>> +     bool
>> +     select HAVE_ARCH_PREL32_RELOCATIONS
>> +
>
> You should probably make it depend on !XIP_KERNEL.
>

Indeed.

> Other than that
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
>

Thanks.
