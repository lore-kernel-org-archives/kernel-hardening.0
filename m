MIME-Version: 1.0
In-Reply-To: <CAK8P3a0HeP0ekoZCu9+d-4y0dUz2=-Nn53=fTHPKSJao2NMU5Q@mail.gmail.com>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-5-git-send-email-keescook@chromium.org> <CAK8P3a0beV+ZUUKxzufXtZRszbXvgC3eQO4Rc1+ZYo_nAmcaaA@mail.gmail.com>
 <CAGXu5jJHRC83YSDKVfm4_41k0wgqfG=wpqPQss-ce77SRNkwRA@mail.gmail.com> <CAK8P3a0HeP0ekoZCu9+d-4y0dUz2=-Nn53=fTHPKSJao2NMU5Q@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 30 Jun 2017 07:55:49 +0000
Message-ID: <CAKv+Gu-EWyfB3zbPwT9=bLwR0GDtg5mwKaD0p5AbssjbxU7sMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 04/20] gcc-plugins: Add the randstruct plugin
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 30 June 2017 at 07:35, Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Jun 30, 2017 at 12:53 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Jun 29, 2017 at 3:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Fri, May 26, 2017 at 10:17 PM, Kees Cook <keescook@chromium.org> wrote:
>>> I noticed new build errors that bisected back to this patch, which has
>>> now showed up
>>> in linux-next again:
>>
>> (FWIW this is randstruct not initify, and has been in -next for a
>> couple weeks now.)
>
> I first saw it last week and only now got around to looking any deeper,
> as I had assumed that one of my own patches caused it.
>
>>> /git/arm-soc/arch/arm/kernel/entry-armv.S: Assembler messages:
>>> /git/arm-soc/arch/arm/kernel/entry-armv.S:800: Error: bad immediate
>>> value for offset (4644)
>>> /git/arm-soc/scripts/Makefile.build:403: recipe for target
>>> 'arch/arm/kernel/entry-armv.o' failed
>>> make[3]: *** [arch/arm/kernel/entry-armv.o] Error 1
>>> /git/arm-soc/arch/arm/kernel/entry-armv.S: Assembler messages:
>>> /git/arm-soc/arch/arm/kernel/entry-armv.S:800: Error: bad immediate
>>> value for offset (5584)
>>
>> arch/arm/kernel/entry-armv.S:   ldr     r7, [r7, #TSK_STACK_CANARY]
>> arch/arm/kernel/asm-offsets.c:  DEFINE(TSK_STACK_CANARY,
>> offsetof(struct task_struct, stack_canary));
>>
>> This would imply that stack_canary got randomized to an offset within
>> struct task_struct beyond the "ldr" immediate range (4096). Yay for
>> giant structs.
>>
>> I'm surprised this didn't bisect to "task_struct: Allow randomized layout".
>
> The bisection was a bit tricky, it's very possible that this should have
> been the one to report.
>
>>> /git/arm-soc/scripts/Makefile.build:403: recipe for target
>>> 'arch/arm/kernel/entry-armv.o' failed
>>> make[3]: *** [arch/arm/kernel/entry-armv.o] Error 1
>>> /git/arm-soc/arch/arm/mm/tlb-v4.S: Assembler messages:
>>> /git/arm-soc/arch/arm/mm/tlb-v4.S:35: Error: bad immediate value for
>>> offset (4928)
>>
>> Similar:
>>
>>         act_mm  r3                              @ get current->active_mm
>> ...
>>         .macro  act_mm, rd
>>         ldr     \rd, [\rd, #TSK_ACTIVE_MM]
>> ...
>> kernel/asm-offsets.c:  DEFINE(TSK_ACTIVE_MM,
>> offsetof(struct task_struct, active_mm));
>>
>>> /git/arm-soc/scripts/Makefile.build:403: recipe for target
>>> 'arch/arm/mm/tlb-v4.o' failed
>>> make[3]: *** [arch/arm/mm/tlb-v4.o] Error 1
>>> /git/arm-soc/arch/arm/mm/tlb-v4wbi.S: Assembler messages:
>>> /git/arm-soc/arch/arm/mm/tlb-v4wbi.S:34: Error: bad immediate value
>>> for offset (4928)
>>> /git/arm-soc/scripts/Makefile.build:403: recipe for target
>>> 'arch/arm/mm/tlb-v4wbi.o' failed
>>
>> Same as above.
>>
>>> So far, that's the only thing that goes wrong for me though, and this
>>> is probably
>>> easy to fix.
>>
>> Thanks for letting me know! These haven't shown up in my tests since I
>> haven't gotten "unlucky" in randomizing the task_struct, it seems.
>
> I've only hit it a couple of times a few thousand builds.
>
>> I see a few possible solutions:
>>
>> - ignore it and try your build again with a fresh tree and a new
>> randomization seed ;)
>> - remove "depends on !COMPILE_TEST" from
>> GCC_PLUGIN_RANDSTRUCT_PERFORMANCE, which will leave most stuff near
>> their original locations
>> - add a new annotation __randomize_cacheline which performs the same
>> logic as above, but only for the marked structure
>> - build new logic to keep certain fields (with some special marking)
>> within a given range of their original position
>> - rewrite the ARM code to handle larger immediates
>>
>> The first obviously won't fly. The second just bypasses the problem
>> forcing it to be exposed by other people later. The third is likely
>> easiest to do now, but reduces the effectiveness of randomization for
>> architectures that don't have sensitive immediate values. The fourth
>> sounds not generally useful. The fifth may be unacceptable to arm
>> maintainers due to performance impacts.
>
> I was thinking of the fifth solution, but don't know exactly how to
> do it. If performance is a concern, I guess we could have separate
> implementations for randstruct and traditional builds.
>

Does this not apply to *all* entries in asm-offsets? If so, I don't
see how it is tractable to fix this in the code, unless we add some
instrumentation to asm-offsets to whitelist some huge structs and
error out on new ones. Or perhaps there's really only a handful?

In any case, these particular examples are fairly straightforward,
since there is no need to preserve the register's value.

ldr     r7, [r7, #TSK_STACK_CANARY]

could be replaced with

.if TSK_STACK_CANARAY >= PAGE_SIZE
add r7, r7, #TSK_STACK_CANARY & PAGE_MASK
.endif
ldr r7, [r7, #TSK_STACK_CANARY & ~PAGE_MASK]
