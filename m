MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAGXu5jJq-1Tkfzkh_Na9dGVVi=hARz5yDX68MZoN_KPiNBX5LQ@mail.gmail.com>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-5-git-send-email-keescook@chromium.org> <CAK8P3a0beV+ZUUKxzufXtZRszbXvgC3eQO4Rc1+ZYo_nAmcaaA@mail.gmail.com>
 <CAGXu5jJHRC83YSDKVfm4_41k0wgqfG=wpqPQss-ce77SRNkwRA@mail.gmail.com>
 <CAK8P3a0HeP0ekoZCu9+d-4y0dUz2=-Nn53=fTHPKSJao2NMU5Q@mail.gmail.com>
 <CAKv+Gu-EWyfB3zbPwT9=bLwR0GDtg5mwKaD0p5AbssjbxU7sMA@mail.gmail.com>
 <CAK8P3a076DEDpzRgTRBNLWan-KZyD0LkauWpuO8RFCf-9i1mhA@mail.gmail.com> <CAGXu5jJq-1Tkfzkh_Na9dGVVi=hARz5yDX68MZoN_KPiNBX5LQ@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 Jun 2017 17:22:19 +0200
Message-ID: <CAK8P3a19oEYSE7_woSa_S5MaHQE+TLXRKw3PdezSv4hY4g0ncQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 04/20] gcc-plugins: Add the randstruct plugin
To: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 30, 2017 at 4:41 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jun 30, 2017 at 1:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Jun 30, 2017 at 9:55 AM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>> On 30 June 2017 at 07:35, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Fri, Jun 30, 2017 at 12:53 AM, Kees Cook <keescook@chromium.org> wrote:
>>>>> The first obviously won't fly. The second just bypasses the problem
>>>>> forcing it to be exposed by other people later. The third is likely
>>>>> easiest to do now, but reduces the effectiveness of randomization for
>>>>> architectures that don't have sensitive immediate values. The fourth
>>>>> sounds not generally useful. The fifth may be unacceptable to arm
>>>>> maintainers due to performance impacts.
>>>>
>>>> I was thinking of the fifth solution, but don't know exactly how to
>>>> do it. If performance is a concern, I guess we could have separate
>>>> implementations for randstruct and traditional builds.
>>>>
>>>
>>> Does this not apply to *all* entries in asm-offsets? If so, I don't
>>> see how it is tractable to fix this in the code, unless we add some
>>> instrumentation to asm-offsets to whitelist some huge structs and
>>> error out on new ones. Or perhaps there's really only a handful?
>>
>> I think the other structs are all small enough:
>>
>> * thread_info is at most 720 bytes (including crunch+vfp3, which
>>   you wouldn't find in one combined kernel) and not randomized
>>   at the moment
>> * pt_regs is 72 bytes and I don't see how that would be randomized
>> * machine_desc would be a candidate for randomizing, but is only
>>   108 bytes
>> * proc_info_list is 52 bytes and not currently randomized
>> * vm_area_struct is randomized but only 96 bytes.
>> * task_struct is clearly large enough, but we only use TSK_ACTIVE_MM
>>   and TSK_STACK_CANARY, both can be fixed with your trick.
>
> Yup, that matches what I found. task_struct is the only truly giant struct.
>
>>> In any case, these particular examples are fairly straightforward,
>>> since there is no need to preserve the register's value.
>>>
>>> ldr     r7, [r7, #TSK_STACK_CANARY]
>>>
>>> could be replaced with
>>>
>>> .if TSK_STACK_CANARAY >= PAGE_SIZE
>>> add r7, r7, #TSK_STACK_CANARY & PAGE_MASK
>>> .endif
>>> ldr r7, [r7, #TSK_STACK_CANARY & ~PAGE_MASK]
>>
>> Nice!
>
> Oh, very cool. This'll make it only an asm change in the case where
> it's required for randstruct. Perfect. I'll send a patch and carry it
> in the randstruct tree.
>
> (In looking at this, it seems tsk_mm is unused in mm/proc-macros.S, so
> I'll remove that code unless someone sees something I don't.)

Ah, I missed that. This is what I have committed locally
(sorry, doesn't apply because gmail). Note that I had to
compare against PAGE_MASK here rather than PAGE_SIZE,
which contains a 'ul' postfix that the assembler doesn't like.

I'll send another copy to the list separately later today,
once my randconfig builds complete (there have been some
other regressions in the last few days, this one seems fine now).

       Arnd

commit 3b6308404cd40edcff9f5e2aacd3cff9b67d660c
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Jun 30 13:50:23 2017 +0200

    ARM: fix randomized task_struct

    With the new task struct randomization, we can run into a build
    failure for certain random seeds:

    arch/arm/kernel/entry-armv.S: Assembler messages:
    arch/arm/kernel/entry-armv.S:803: Error: bad immediate value for
offset (4096)

    Only two constants in asm-offset.h are affected, and I'm changing
    both of them here to work correctly in all configurations.

    Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
    Fixes: c33d8b12fbbd ("task_struct: Allow randomized layout")
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 9f157e7c51e7..db6d22b23bd8 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -797,7 +797,10 @@ ENTRY(__switch_to)
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
        ldr     r7, [r2, #TI_TASK]
        ldr     r8, =__stack_chk_guard
-       ldr     r7, [r7, #TSK_STACK_CANARY]
+       .if (TSK_STACK_CANARY > PAGE_MASK)
+       add     r7, r7, #TSK_STACK_CANARY & PAGE_MASK
+       .endif
+       ldr     r7, [r7, #TSK_STACK_CANARY & ~PAGE_MASK]
 #endif
 #ifdef CONFIG_CPU_USE_DOMAINS
        mcr     p15, 0, r6, c3, c0, 0           @ Set domain register
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 0d40c285bd86..c7bd8fcf16a7 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -37,7 +37,10 @@
        bic     \rd, sp, #8128
        bic     \rd, \rd, #63
        ldr     \rd, [\rd, #TI_TASK]
-       ldr     \rd, [\rd, #TSK_ACTIVE_MM]
+       .if (TSK_ACTIVE_MM > PAGE_MASK)
+       add     \rd, \rd, #TSK_ACTIVE_MM & PAGE_MASK
+       .endif
+       ldr     \rd, [\rd, #TSK_ACTIVE_MM & ~PAGE_MASK]
        .endm

 /*
