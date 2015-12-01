Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <565CF1E5.2070003@redhat.com>
References: <20151130233819.GA18873@www.outflux.net>
	<565CF1E5.2070003@redhat.com>
Date: Mon, 30 Nov 2015 17:08:23 -0800
Message-ID: <CAGXu5jJUv3EKkFA3J43nVO+v=-K5kgwSqwrVA9hxJGeZ79CkAg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] ARM: mm: flip priority of CONFIG_DEBUG_RODATA
To: Laura Abbott <labbott@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 30, 2015 at 5:03 PM, Laura Abbott <labbott@redhat.com> wrote:
> On 11/30/2015 03:38 PM, Kees Cook wrote:
>>
>> Given the choice between making things NX or making things RO, we want
>> RO first. As such, redefine CONFIG_DEBUG_RODATA to actually do the bulk
>
>
> Can you give a citation for why? The thread that inspired it might be
> a good link.

This was inspired by my examining the existing architecture's
implementations of CONFIG_DEBUG_RODATA after Ingo suggested it be made
a common feature not a build-time config (or at least renamed):
http://www.openwall.com/lists/kernel-hardening/2015/11/30/13

>> of the ROing (and NXing). In the place of the old CONFIG_DEBUG_RODATA,
>> introduce CONFIG_DEBUG_RODATA_ALIGN (after arm64's config that does the
>> same thing) to add the additional section alignment for making rodata
>> explicitly NX. Also adds human readable names to the sections so I
>> could more easily debug my typos, and makes CONFIG_DEBUG_RODATA default
>> "y" for CPU_V7.
>>
>> Results in /sys/kernel/debug/kernel_page_tables for each config state:
>>
>>   # CONFIG_DEBUG_RODATA is not set
>>   # CONFIG_DEBUG_ALIGN_RODATA is not set
>>
>> ---[ Kernel Mapping ]---
>> 0x80000000-0x80900000           9M     RW x  SHD
>> 0x80900000-0xa0000000         503M     RW NX SHD
>>
>>   CONFIG_DEBUG_RODATA=y
>>   CONFIG_DEBUG_ALIGN_RODATA=y
>>
>> ---[ Kernel Mapping ]---
>> 0x80000000-0x80100000           1M     RW NX SHD
>> 0x80100000-0x80700000           6M     ro x  SHD
>> 0x80700000-0x80a00000           3M     ro NX SHD
>> 0x80a00000-0xa0000000         502M     RW NX SHD
>>
>>   CONFIG_DEBUG_RODATA=y
>>   # CONFIG_DEBUG_ALIGN_RODATA is not set
>>
>> ---[ Kernel Mapping ]---
>> 0x80000000-0x80100000           1M     RW NX SHD
>> 0x80100000-0x80a00000           9M     ro x  SHD
>> 0x80a00000-0xa0000000         502M     RW NX SHD
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/arm/kernel/vmlinux.lds.S | 10 +++++-----
>>   arch/arm/mm/Kconfig           | 34 ++++++++++++++++++----------------
>>   arch/arm/mm/init.c            | 18 ++++++++++--------
>>   3 files changed, 33 insertions(+), 29 deletions(-)
>>
>> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
>> index 8b60fde5ce48..a6e395c53a48 100644
>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -8,7 +8,7 @@
>>   #include <asm/thread_info.h>
>>   #include <asm/memory.h>
>>   #include <asm/page.h>
>> -#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +#ifdef CONFIG_DEBUG_RODATA
>>   #include <asm/pgtable.h>
>>   #endif
>>
>> @@ -94,7 +94,7 @@ SECTIONS
>>                 HEAD_TEXT
>>         }
>>
>> -#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +#ifdef CONFIG_DEBUG_RODATA
>>         . = ALIGN(1<<SECTION_SHIFT);
>>   #endif
>>
>> @@ -117,7 +117,7 @@ SECTIONS
>>                         ARM_CPU_KEEP(PROC_INFO)
>>         }
>>
>> -#ifdef CONFIG_DEBUG_RODATA
>> +#ifdef CONFIG_DEBUG_ALIGN_RODATA
>>         . = ALIGN(1<<SECTION_SHIFT);
>>   #endif
>>         RO_DATA(PAGE_SIZE)
>> @@ -153,7 +153,7 @@ SECTIONS
>>         _etext = .;                     /* End of text and rodata section
>> */
>>
>>   #ifndef CONFIG_XIP_KERNEL
>> -# ifdef CONFIG_ARM_KERNMEM_PERMS
>> +# ifdef CONFIG_DEBUG_RODATA
>>         . = ALIGN(1<<SECTION_SHIFT);
>>   # else
>>         . = ALIGN(PAGE_SIZE);
>> @@ -231,7 +231,7 @@ SECTIONS
>>         __data_loc = ALIGN(4);          /* location in binary */
>>         . = PAGE_OFFSET + TEXT_OFFSET;
>>   #else
>> -#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +#ifdef CONFIG_DEBUG_RODATA
>>         . = ALIGN(1<<SECTION_SHIFT);
>>   #else
>>         . = ALIGN(THREAD_SIZE);
>> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
>> index 41218867a9a6..b617084e9520 100644
>> --- a/arch/arm/mm/Kconfig
>> +++ b/arch/arm/mm/Kconfig
>> @@ -1039,24 +1039,26 @@ config ARCH_SUPPORTS_BIG_ENDIAN
>>           This option specifies the architecture can support big endian
>>           operation.
>>
>> -config ARM_KERNMEM_PERMS
>> -       bool "Restrict kernel memory permissions"
>> +config DEBUG_RODATA
>> +       bool "Make kernel text and rodata read-only"
>>         depends on MMU
>> +       default y if CPU_V7
>>         help
>> -         If this is set, kernel memory other than kernel text (and
>> rodata)
>> -         will be made non-executable. The tradeoff is that each region is
>> -         padded to section-size (1MiB) boundaries (because their
>> permissions
>> -         are different and splitting the 1M pages into 4K ones causes TLB
>> -         performance problems), wasting memory.
>> +         If this is set, kernel memory (text, rodata, etc) will be made
>> +         read-only, and non-text kernel memory will be made
>> non-executable.
>> +         The tradeoff is that each region is padded to section-size
>> (1MiB)
>> +         boundaries (because their permissions are different and
>> splitting
>> +         the 1M pages into 4K ones causes TLB performance problems),
>> which
>> +         can waste memory.
>>
>> -config DEBUG_RODATA
>> -       bool "Make kernel text and rodata read-only"
>> -       depends on ARM_KERNMEM_PERMS
>> +config DEBUG_ALIGN_RODATA
>> +       bool "Make rodata strictly non-executable"
>> +       depends on DEBUG_RODATA
>>         default y
>>         help
>> -         If this is set, kernel text and rodata will be made read-only.
>> This
>> -         is to help catch accidental or malicious attempts to change the
>> -         kernel's executable code. Additionally splits rodata from kernel
>> -         text so it can be made explicitly non-executable. This creates
>> -         another section-size padded region, so it can waste more memory
>> -         space while gaining the read-only protections.
>> +         If this is set, rodata will be made explicitly non-executable.
>> This
>> +         provides protection on the rare chance that attackers might find
>> and
>> +         use ROP gadgets that exist in the rodata section. This adds an
>> +         additional section-aligned split of rodata from kernel text so
>> it
>> +         can be made explicitly non-executable. This padding may waste
>> memory
>> +         space to gain this additional protection.
>
>
> I get that you want to make this match arm64 but it's really not intuitive that
> something with ALIGN_RODATA in the name is actually for setting NX. The purpose
> of ALIGN_RODATA was also slightly different on arm64 since the RO/NX will still
> be there, the difference is if the sections are present versus broken down into
> pages.

Well, it seems to have the same effect: without the alignment, a
portion of rodata may remain executable on arm64. Unless I
misunderstand?

-Kees

>
>> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> index 8a63b4cdc0f2..e99f65fbcf2b 100644
>> --- a/arch/arm/mm/init.c
>> +++ b/arch/arm/mm/init.c
>> @@ -568,8 +568,9 @@ void __init mem_init(void)
>>         }
>>   }
>>
>> -#ifdef CONFIG_ARM_KERNMEM_PERMS
>> +#ifdef CONFIG_DEBUG_RODATA
>>   struct section_perm {
>> +       const char *name;
>>         unsigned long start;
>>         unsigned long end;
>>         pmdval_t mask;
>> @@ -580,6 +581,7 @@ struct section_perm {
>>   static struct section_perm nx_perms[] = {
>>         /* Make pages tables, etc before _stext RW (set NX). */
>>         {
>> +               .name   = "pre-text NX",
>>                 .start  = PAGE_OFFSET,
>>                 .end    = (unsigned long)_stext,
>>                 .mask   = ~PMD_SECT_XN,
>> @@ -587,14 +589,16 @@ static struct section_perm nx_perms[] = {
>>         },
>>         /* Make init RW (set NX). */
>>         {
>> +               .name   = "init NX",
>>                 .start  = (unsigned long)__init_begin,
>>                 .end    = (unsigned long)_sdata,
>>                 .mask   = ~PMD_SECT_XN,
>>                 .prot   = PMD_SECT_XN,
>>         },
>> -#ifdef CONFIG_DEBUG_RODATA
>> +#ifdef CONFIG_DEBUG_ALIGN_RODATA
>>         /* Make rodata NX (set RO in ro_perms below). */
>>         {
>> +               .name   = "rodata NX",
>>                 .start  = (unsigned long)__start_rodata,
>>                 .end    = (unsigned long)__init_begin,
>>                 .mask   = ~PMD_SECT_XN,
>> @@ -603,10 +607,10 @@ static struct section_perm nx_perms[] = {
>>   #endif
>>   };
>>
>> -#ifdef CONFIG_DEBUG_RODATA
>>   static struct section_perm ro_perms[] = {
>>         /* Make kernel code and rodata RX (set RO). */
>>         {
>> +               .name   = "text/rodata RO",
>>                 .start  = (unsigned long)_stext,
>>                 .end    = (unsigned long)__init_begin,
>>   #ifdef CONFIG_ARM_LPAE
>> @@ -619,7 +623,6 @@ static struct section_perm ro_perms[] = {
>>   #endif
>>         },
>>   };
>> -#endif
>>
>>   /*
>>    * Updates section permissions only for the current mm (sections are
>> @@ -666,7 +669,8 @@ static inline bool arch_has_strict_perms(void)
>>         for (i = 0; i < ARRAY_SIZE(perms); i++) {                       \
>>                 if (!IS_ALIGNED(perms[i].start, SECTION_SIZE) ||        \
>>                     !IS_ALIGNED(perms[i].end, SECTION_SIZE)) {          \
>> -                       pr_err("BUG: section %lx-%lx not aligned to
>> %lx\n", \
>> +                       pr_err("BUG: %s section %lx-%lx not aligned to
>> %lx\n", \
>> +                               perms[i].name,                          \
>>                                 perms[i].start, perms[i].end,           \
>>                                 SECTION_SIZE);                          \
>>                         continue;                                       \
>> @@ -685,7 +689,6 @@ static inline void fix_kernmem_perms(void)
>>         set_section_perms(nx_perms, prot);
>>   }
>>
>> -#ifdef CONFIG_DEBUG_RODATA
>>   void mark_rodata_ro(void)
>>   {
>>         set_section_perms(ro_perms, prot);
>> @@ -700,11 +703,10 @@ void set_kernel_text_ro(void)
>>   {
>>         set_section_perms(ro_perms, prot);
>>   }
>> -#endif /* CONFIG_DEBUG_RODATA */
>>
>>   #else
>>   static inline void fix_kernmem_perms(void) { }
>> -#endif /* CONFIG_ARM_KERNMEM_PERMS */
>> +#endif /* CONFIG_DEBUG_RODATA */
>>
>>   void free_tcmmem(void)
>>   {
>>
>
> Thanks,
> Laura



-- 
Kees Cook
Chrome OS & Brillo Security
