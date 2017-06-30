MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <9291740E-3BD1-454C-A3EB-46E35F073D0E@linaro.org>
References: <20170630153502.3327030-1-arnd@arndb.de> <9291740E-3BD1-454C-A3EB-46E35F073D0E@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 Jun 2017 17:55:19 +0200
Message-ID: <CAK8P3a1oJjzOh1fRh+0gYDcf27pCTVwwfQcb2DPfx7tmwQE2Qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] ARM: fix randomized task_struct
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 30, 2017 at 5:49 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>> On 30 Jun 2017, at 15:34, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> With the new task struct randomization, we can run into a build
>> failure for certain random seeds:
>>
>> arch/arm/kernel/entry-armv.S: Assembler messages:
>> arch/arm/kernel/entry-armv.S:803: Error: bad immediate value for offset (4096)
>>
>> Only two constants in asm-offset.h are affected, and I'm changing
>> both of them here to work correctly in all configurations.
>>
>> One more macro has the problem, but is currently unused, so this
>> removes it instead of adding complexity.
>>
>> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Fixes: c33d8b12fbbd ("task_struct: Allow randomized layout")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> arch/arm/kernel/entry-armv.S |  5 ++++-
>> arch/arm/mm/proc-macros.S    | 10 ++++------
>> 2 files changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
>> index 9f157e7c51e7..db6d22b23bd8 100644
>> --- a/arch/arm/kernel/entry-armv.S
>> +++ b/arch/arm/kernel/entry-armv.S
>> @@ -797,7 +797,10 @@ ENTRY(__switch_to)
>> #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>>    ldr    r7, [r2, #TI_TASK]
>>    ldr    r8, =__stack_chk_guard
>> -    ldr    r7, [r7, #TSK_STACK_CANARY]
>> +    .if (TSK_STACK_CANARY > PAGE_MASK)
>
> Shouldn't this be ~PAGE_MASK?
>
> I think
>
> .if (TSK_STACK_CANARY & PAGE_MASK) != 0
>
> is better and clearer as well

Right, sorry about that. Russell also pointed out that PAGE_MASK
is not the best constant for this, as the MMU page size is independent
of the definition of the immediate arguments. I'll fix both and resend.

       Arnd
