MIME-Version: 1.0
In-Reply-To: <20181106215450.GB31487@brain-police>
References: <20181106214404.2497-1-ard.biesheuvel@linaro.org>
 <20181106214404.2497-3-ard.biesheuvel@linaro.org> <20181106215450.GB31487@brain-police>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 7 Nov 2018 08:51:27 +0100
Message-ID: <CAKv+Gu_-xeux7Q5Sm6HSiV4TvjcKy8C9_tnAGkeReT9-SMEdPg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] arm64: mm: apply r/o permissions of VM areas to
 its linear alias as well
Content-Type: text/plain; charset="UTF-8"
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 November 2018 at 22:54, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Nov 06, 2018 at 10:44:04PM +0100, Ard Biesheuvel wrote:
>> On arm64, we use block mappings and contiguous hints to map the linear
>> region, to minimize the TLB footprint. However, this means that the
>> entire region is mapped using read/write permissions, and so the linear
>> aliases of pages belonging to read-only mappings (executable or otherwise)
>> in the vmalloc region could potentially be abused to modify things like
>> module code, bpf JIT code or read-only data.
>>
>> So let's fix this, by extending the set_memory_ro/rw routines to take
>> the linear alias into account. The consequence of enabling this is
>> that we can no longer use block mappings or contiguous hints, so in
>> cases where the TLB footprint of the linear region is a bottleneck,
>> performance may be affected.
>>
>> Therefore, allow this feature to be runtime disabled, by setting
>> rola=off on the kernel command line. Also, allow the default value
>> to be set via a Kconfig option.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/Kconfig                   | 14 +++++++++
>>  arch/arm64/include/asm/mmu_context.h |  2 ++
>>  arch/arm64/mm/mmu.c                  |  2 +-
>>  arch/arm64/mm/pageattr.c             | 30 ++++++++++++++++----
>>  4 files changed, 42 insertions(+), 6 deletions(-)
>
> Nice -- this is looking pretty good!
>

Thanks

>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 787d7850e064..d000c379b670 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -958,6 +958,20 @@ config ARM64_SSBD
>>
>>         If unsure, say Y.
>>
>> +config ROLA_DEFAULT_ENABLED
>
> Any reason not to piggyback on rodata as you suggested before?
>

I had managed to convince myself that this is problematic due to the
fact that rodata= is parsed twice, with early_param() in the arm64
code and with __setup() in generic code, and both use strtobool()
which will return an error on 'full'.

However, that does not actually appear to matter, although it is
slightly nasty to rely on that.

>> +     bool "Apply read-only permissions of VM areas also to its linear alias"
>
> This reads strangely as it mixes plural ("VM areas") with singular "its
> linear alias".
>

Will fix

>> +     default y
>> +     help
>> +       Apply read-only attributes of VM areas to the linear alias of
>> +       the backing pages as well. This prevents code or read/only data
>
> typo: read/only
>

Will fix'

>> +       from being modified (inadvertently or intentionally) via another
>> +       mapping of the same memory page. This can be turned off at runtime
>> +       by passing rola=off (and turned on with rola=on if this option is
>> +       set to 'n')
>> +
>> +       This requires the linear region to be mapped down to pages,
>> +       which may adversely affect performance in some cases.
>
>
>>  menuconfig ARMV8_DEPRECATED
>>       bool "Emulate deprecated/obsolete ARMv8 instructions"
>>       depends on COMPAT
>> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
>> index 1e58bf58c22b..df39a07fe5f0 100644
>> --- a/arch/arm64/include/asm/mmu_context.h
>> +++ b/arch/arm64/include/asm/mmu_context.h
>> @@ -35,6 +35,8 @@
>>  #include <asm/sysreg.h>
>>  #include <asm/tlbflush.h>
>>
>> +extern bool rola_enabled;
>> +
>>  static inline void contextidr_thread_switch(struct task_struct *next)
>>  {
>>       if (!IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR))
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index d1d6601b385d..79fd3bf102fa 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -451,7 +451,7 @@ static void __init map_mem(pgd_t *pgdp)
>>       struct memblock_region *reg;
>>       int flags = 0;
>>
>> -     if (debug_pagealloc_enabled())
>> +     if (rola_enabled || debug_pagealloc_enabled())
>>               flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>>
>>       /*
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index f8cf5bc1d1f8..1dddb69e6f1c 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -25,6 +25,13 @@ struct page_change_data {
>>       pgprot_t clear_mask;
>>  };
>>
>> +bool rola_enabled __ro_after_init = IS_ENABLED(CONFIG_ROLA_DEFAULT_ENABLED);
>> +static int __init parse_rola(char *arg)
>> +{
>> +     return strtobool(arg, &rola_enabled);
>> +}
>> +early_param("rola", parse_rola);
>> +
>>  static int change_page_range(pte_t *ptep, pgtable_t token, unsigned long addr,
>>                       void *data)
>>  {
>> @@ -58,12 +65,14 @@ static int __change_memory_common(unsigned long start, unsigned long size,
>>  }
>>
>>  static int change_memory_common(unsigned long addr, int numpages,
>> -                             pgprot_t set_mask, pgprot_t clear_mask)
>> +                             pgprot_t set_mask, pgprot_t clear_mask,
>> +                             bool remap_alias)
>
> Can we drop the remap_alias parameter an infer the behaviour based on
> whether we're messing with PTE_RDONLY? I find APIs with bool parameters
> really hard to read at the callsite.
>

I can easily infer it from set_mask == __pgprot(PTE_RDONLY) ||
clear_mask == __pgprot(PTE_RDONLY) so that should be doable yes.
