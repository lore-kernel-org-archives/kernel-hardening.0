MIME-Version: 1.0
In-Reply-To: <82ab0116-ac67-c80a-73d5-a812e38eb547@redhat.com>
References: <20171204142709.GA3376@pjb1027-Latitude-E5410> <82ab0116-ac67-c80a-73d5-a812e38eb547@redhat.com>
From: Jinbum Park <jinb.park7@gmail.com>
Date: Wed, 6 Dec 2017 18:17:15 +0900
Message-ID: <CAErMHp_FjUubPABASuHQNQ3LFR=P4O4YOTTrNUcL3B6_UdHurA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH v3 3/3] arm: mm: dump: add checking for
 writable and executable pages
To: Laura Abbott <labbott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Afzal Mohammed <afzal.mohd.ma@gmail.com>, Mark Rutland <mark.rutland@arm.com>, linux@armlinux.org.uk, gregkh@linuxfoundation.org, Kees Cook <keescook@chromium.org>, vladimir.murzin@arm.com, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

2017-12-06 8:51 GMT+09:00 Laura Abbott <labbott@redhat.com>:
> On 12/04/2017 06:27 AM, Jinbum Park wrote:
>>
>> Page mappings with full RWX permissions are a security risk.
>> x86, arm64 has an option to walk the page tables
>> and dump any bad pages.
>>
>> (1404d6f13e47
>> ("arm64: dump: Add checking for writable and exectuable pages"))
>> Add a similar implementation for arm.
>>
>> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
>> ---
>> v3: Reuse pg_level, prot_bits to check ro, nx prot.
>>
>>   arch/arm/Kconfig.debug        | 27 +++++++++++++++++++++++
>>   arch/arm/include/asm/ptdump.h |  8 +++++++
>>   arch/arm/mm/dump.c            | 51
>> +++++++++++++++++++++++++++++++++++++++++++
>>   arch/arm/mm/init.c            |  2 ++
>>   4 files changed, 88 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index e7b94db..78a6470 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -20,6 +20,33 @@ config ARM_PTDUMP_DEBUGFS
>>           kernel.
>>           If in doubt, say "N"
>>   +config DEBUG_WX
>> +       bool "Warn on W+X mappings at boot"
>> +       select ARM_PTDUMP_CORE
>> +       ---help---
>> +               Generate a warning if any W+X mappings are found at boot.
>> +
>> +               This is useful for discovering cases where the kernel is
>> leaving
>> +               W+X mappings after applying NX, as such mappings are a
>> security risk.
>> +
>> +               Look for a message in dmesg output like this:
>> +
>> +                       arm/mm: Checked W+X mappings: passed, no W+X pages
>> found.
>> +
>> +               or like this, if the check failed:
>> +
>> +                       arm/mm: Checked W+X mappings: FAILED, <N> W+X
>> pages found.
>> +
>> +               Note that even if the check fails, your kernel is possibly
>> +               still fine, as W+X mappings are not a security hole in
>> +               themselves, what they do is that they make the
>> exploitation
>> +               of other unfixed kernel bugs easier.
>> +
>> +               There is no runtime or memory usage effect of this option
>> +               once the kernel has booted up - it's a one time check.
>> +
>> +               If in doubt, say "Y".
>> +
>>   # RMK wants arm kernels compiled with frame pointers or stack unwinding.
>>   # If you know what you are doing and are willing to live without stack
>>   # traces, you can get a slightly smaller kernel by setting this option
>> to
>> diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
>> index 3a6c0b7..b6a0162 100644
>> --- a/arch/arm/include/asm/ptdump.h
>> +++ b/arch/arm/include/asm/ptdump.h
>> @@ -43,6 +43,14 @@ static inline int ptdump_debugfs_register(struct
>> ptdump_info *info,
>>   }
>>   #endif /* CONFIG_ARM_PTDUMP_DEBUGFS */
>>   +void ptdump_check_wx(void);
>> +
>>   #endif /* CONFIG_ARM_PTDUMP_CORE */
>>   +#ifdef CONFIG_DEBUG_WX
>> +#define debug_checkwx() ptdump_check_wx()
>> +#else
>> +#define debug_checkwx() do { } while (0)
>> +#endif
>> +
>>   #endif /* __ASM_PTDUMP_H */
>> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
>> index 43a2bee..3e2e6f0 100644
>> --- a/arch/arm/mm/dump.c
>> +++ b/arch/arm/mm/dump.c
>> @@ -52,6 +52,8 @@ struct pg_state {
>>         unsigned long start_address;
>>         unsigned level;
>>         u64 current_prot;
>> +       bool check_wx;
>> +       unsigned long wx_pages;
>>         const char *current_domain;
>>   };
>>   @@ -194,6 +196,8 @@ struct pg_level {
>>         const struct prot_bits *bits;
>>         size_t num;
>>         u64 mask;
>> +       const struct prot_bits *ro_bit;
>> +       const struct prot_bits *nx_bit;
>>   };

It looks better~:)
I'll prepare new version.

>>     static struct pg_level pg_level[] = {
>> @@ -203,9 +207,17 @@ struct pg_level {
>>         }, { /* pmd */
>>                 .bits   = section_bits,
>>                 .num    = ARRAY_SIZE(section_bits),
>> +       #ifdef CONFIG_ARM_LPAE
>> +               .ro_bit = section_bits + 1,
>> +       #else
>> +               .ro_bit = section_bits,
>> +       #endif
>> +               .nx_bit = section_bits + ARRAY_SIZE(section_bits) - 2,
>>         }, { /* pte */
>>                 .bits   = pte_bits,
>>                 .num    = ARRAY_SIZE(pte_bits),
>> +               .ro_bit = pte_bits + 1,
>> +               .nx_bit = pte_bits + 2,
>>         },
>>   };
>>
>
>
> This is better but the addition offset from the array is still
> prone to breakage if we add entries. Maybe something like this
> on top of yours:
>
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index 3e2e6f06e4d9..572cbc4dc247 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -62,6 +62,8 @@ struct prot_bits {
>         u64             val;
>         const char      *set;
>         const char      *clear;
> +       bool            ro_bit;
> +       bool            x_bit;
>  };
>   static const struct prot_bits pte_bits[] = {
> @@ -75,11 +77,13 @@ static const struct prot_bits pte_bits[] = {
>                 .val    = L_PTE_RDONLY,
>                 .set    = "ro",
>                 .clear  = "RW",
> +               .ro_bit = true,
>         }, {
>                 .mask   = L_PTE_XN,
>                 .val    = L_PTE_XN,
>                 .set    = "NX",
>                 .clear  = "x ",
> +               .x_bit = true,
>         }, {
>                 .mask   = L_PTE_SHARED,
>                 .val    = L_PTE_SHARED,
> @@ -143,11 +147,13 @@ static const struct prot_bits section_bits[] = {
>                 .val    = L_PMD_SECT_RDONLY | PMD_SECT_AP2,
>                 .set    = "ro",
>                 .clear  = "RW",
> +               .ro_bit = true,
>  #elif __LINUX_ARM_ARCH__ >= 6
>         {
>                 .mask   = PMD_SECT_APX | PMD_SECT_AP_READ |
> PMD_SECT_AP_WRITE,
>                 .val    = PMD_SECT_APX | PMD_SECT_AP_WRITE,
>                 .set    = "    ro",
> +               .ro_bit = true,
>         }, {
>                 .mask   = PMD_SECT_APX | PMD_SECT_AP_READ |
> PMD_SECT_AP_WRITE,
>                 .val    = PMD_SECT_AP_WRITE,
> @@ -166,6 +172,7 @@ static const struct prot_bits section_bits[] = {
>                 .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
>                 .val    = 0,
>                 .set    = "    ro",
> +               .ro_bit = true,
>         }, {
>                 .mask   = PMD_SECT_AP_READ | PMD_SECT_AP_WRITE,
>                 .val    = PMD_SECT_AP_WRITE,
> @@ -184,6 +191,7 @@ static const struct prot_bits section_bits[] = {
>                 .val    = PMD_SECT_XN,
>                 .set    = "NX",
>                 .clear  = "x ",
> +               .x_bit  = true,
>         }, {
>                 .mask   = PMD_SECT_S,
>                 .val    = PMD_SECT_S,
> @@ -207,17 +215,9 @@ static struct pg_level pg_level[] = {
>         }, { /* pmd */
>                 .bits   = section_bits,
>                 .num    = ARRAY_SIZE(section_bits),
> -       #ifdef CONFIG_ARM_LPAE
> -               .ro_bit = section_bits + 1,
> -       #else
> -               .ro_bit = section_bits,
> -       #endif
> -               .nx_bit = section_bits + ARRAY_SIZE(section_bits) - 2,
>         }, { /* pte */
>                 .bits   = pte_bits,
>                 .num    = ARRAY_SIZE(pte_bits),
> -               .ro_bit = pte_bits + 1,
> -               .nx_bit = pte_bits + 2,
>         },
>  };
>  @@ -410,8 +410,13 @@ static void ptdump_initialize(void)
>         for (i = 0; i < ARRAY_SIZE(pg_level); i++)
>                 if (pg_level[i].bits)
> -                       for (j = 0; j < pg_level[i].num; j++)
> +                       for (j = 0; j < pg_level[i].num; j++) {
>                                 pg_level[i].mask |=
> pg_level[i].bits[j].mask;
> +                               if (pg_level[i].bits[j].ro_bit)
> +                                       pg_level[i].ro_bit =
> &pg_level[i].bits[j];
> +                               if (pg_level[i].bits[j].x_bit)
> +                                       pg_level[i].nx_bit =
> &pg_level[i].bits[j];
> +                       }
>         address_markers[2].start_address = VMALLOC_START;
>  }
>
>
>
>
>>
>> @@ -226,6 +238,23 @@ static void dump_prot(struct pg_state *st, const
>> struct prot_bits *bits, size_t
>>         }
>>   }
>>   +static void note_prot_wx(struct pg_state *st, unsigned long addr)
>> +{
>> +       if (!st->check_wx)
>> +               return;
>> +       if ((st->current_prot & pg_level[st->level].ro_bit->mask) ==
>> +                               pg_level[st->level].ro_bit->val)
>> +               return;
>> +       if ((st->current_prot & pg_level[st->level].nx_bit->mask) ==
>> +                               pg_level[st->level].nx_bit->val)
>> +               return;
>> +
>> +       WARN_ONCE(1, "arm/mm: Found insecure W+X mapping at address
>> %p/%pS\n",
>> +               (void *)st->start_address, (void *)st->start_address);
>> +
>
>
> With the new %p hashing, printing just %p is not useful, so just drop
> it and just have the %pS.

ok, I'll drop the %p.

>
> Thanks,
> Laura
>
