Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-8-git-send-email-ard.biesheuvel@linaro.org>
	<20160112181336.GF4858@leverpostej>
	<CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
Date: Wed, 13 Jan 2016 10:58:55 +0100
Message-ID: <CAKv+Gu86oVvGb75S2x-44ct4sdQt4zT-3HbPqMJo_X+Cm3EPVQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 07/21] arm64: move kernel image to base of vmalloc area
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 January 2016 at 09:39, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 12 January 2016 at 19:14, Mark Rutland <mark.rutland@arm.com> wrote:
>> On Mon, Jan 11, 2016 at 02:19:00PM +0100, Ard Biesheuvel wrote:
>>> This moves the module area to right before the vmalloc area, and
>>> moves the kernel image to the base of the vmalloc area. This is
>>> an intermediate step towards implementing kASLR, where the kernel
>>> image can be located anywhere in the vmalloc area.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>>  arch/arm64/include/asm/kasan.h          | 20 ++++---
>>>  arch/arm64/include/asm/kernel-pgtable.h |  5 +-
>>>  arch/arm64/include/asm/memory.h         | 18 ++++--
>>>  arch/arm64/include/asm/pgtable.h        |  7 ---
>>>  arch/arm64/kernel/setup.c               | 12 ++++
>>>  arch/arm64/mm/dump.c                    | 12 ++--
>>>  arch/arm64/mm/init.c                    | 20 +++----
>>>  arch/arm64/mm/kasan_init.c              | 21 +++++--
>>>  arch/arm64/mm/mmu.c                     | 62 ++++++++++++++------
>>>  9 files changed, 118 insertions(+), 59 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
>>> index de0d21211c34..2c583dbf4746 100644
>>> --- a/arch/arm64/include/asm/kasan.h
>>> +++ b/arch/arm64/include/asm/kasan.h
>>> @@ -1,20 +1,16 @@
>>>  #ifndef __ASM_KASAN_H
>>>  #define __ASM_KASAN_H
>>>
>>> -#ifndef __ASSEMBLY__
>>> -
>>>  #ifdef CONFIG_KASAN
>>>
>>>  #include <linux/linkage.h>
>>> -#include <asm/memory.h>
>>> -#include <asm/pgtable-types.h>
>>>
>>>  /*
>>>   * KASAN_SHADOW_START: beginning of the kernel virtual addresses.
>>>   * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/8 of kernel virtual addresses.
>>>   */
>>> -#define KASAN_SHADOW_START      (VA_START)
>>> -#define KASAN_SHADOW_END        (KASAN_SHADOW_START + (1UL << (VA_BITS - 3)))
>>> +#define KASAN_SHADOW_START   (VA_START)
>>> +#define KASAN_SHADOW_END     (KASAN_SHADOW_START + (_AC(1, UL) << (VA_BITS - 3)))
>>>
>>>  /*
>>>   * This value is used to map an address to the corresponding shadow
>>> @@ -26,16 +22,22 @@
>>>   * should satisfy the following equation:
>>>   *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END - (1ULL << 61)
>>>   */
>>> -#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << (64 - 3)))
>>> +#define KASAN_SHADOW_OFFSET  (KASAN_SHADOW_END - (_AC(1, ULL) << (64 - 3)))
>>> +
>>
>> I couldn't immediately spot where KASAN_SHADOW_* were used in assembly.
>> I guess there's some other definition built atop of them that I've
>> missed.
>>
>> Where should I be looking?
>>
>
> Well, the problem is that KIMAGE_VADDR will be defined in terms of
> KASAN_SHADOW_END if KASAN is enabled. But since KASAN always uses the
> first 1/8 of that VA space, I am going to rework this so that the
> non-KASAN constants never depend on the actual values but only on
> CONFIG_KASAN
>
>>> +#ifndef __ASSEMBLY__
>>> +#include <asm/pgtable-types.h>
>>>
>>>  void kasan_init(void);
>>>  void kasan_copy_shadow(pgd_t *pgdir);
>>>  asmlinkage void kasan_early_init(void);
>>> +#endif
>>>
>>>  #else
>>> +
>>> +#ifndef __ASSEMBLY__
>>>  static inline void kasan_init(void) { }
>>>  static inline void kasan_copy_shadow(pgd_t *pgdir) { }
>>>  #endif
>>>
>>> -#endif
>>> -#endif
>>> +#endif /* CONFIG_KASAN */
>>> +#endif /* __ASM_KASAN_H */
>>> diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
>>> index a459714ee29e..daa8a7b9917a 100644
>>> --- a/arch/arm64/include/asm/kernel-pgtable.h
>>> +++ b/arch/arm64/include/asm/kernel-pgtable.h
>>> @@ -70,8 +70,9 @@
>>>  /*
>>>   * Initial memory map attributes.
>>>   */
>>> -#define SWAPPER_PTE_FLAGS    (PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
>>> -#define SWAPPER_PMD_FLAGS    (PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
>>> +#define SWAPPER_PTE_FLAGS    (PTE_TYPE_PAGE | PTE_AF | PTE_SHARED | PTE_UXN)
>>> +#define SWAPPER_PMD_FLAGS    (PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S | \
>>> +                              PMD_SECT_UXN)
>>
>> This will only affect the tables created in head.S. Before we start
>> userspace we'll have switched over to a new set of tables using
>> PAGE_KERNEL (including UXN).
>>
>> Given that, this doesn't look necessary for the vmalloc area changes. Am
>> I missing something?
>>
>
> No, this was carried over from an older version of the series, when
> the kernel mapping, after having been moved below PAGE_OFFSET, would
> not be overridden by the memblock based linear mapping routines, and
> so would missing the UXN bit. But with your changes, this can indeed
> be dropped.
>
>>>  #if ARM64_SWAPPER_USES_SECTION_MAPS
>>>  #define SWAPPER_MM_MMUFLAGS  (PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS)
>>> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
>>> index bea9631b34a8..e45d3141ad98 100644
>>> --- a/arch/arm64/include/asm/memory.h
>>> +++ b/arch/arm64/include/asm/memory.h
>>> @@ -51,14 +51,24 @@
>>>  #define VA_BITS                      (CONFIG_ARM64_VA_BITS)
>>>  #define VA_START             (UL(0xffffffffffffffff) << VA_BITS)
>>>  #define PAGE_OFFSET          (UL(0xffffffffffffffff) << (VA_BITS - 1))
>>> -#define KIMAGE_VADDR         (PAGE_OFFSET)
>>> -#define MODULES_END          (KIMAGE_VADDR)
>>> -#define MODULES_VADDR                (MODULES_END - SZ_64M)
>>> -#define PCI_IO_END           (MODULES_VADDR - SZ_2M)
>>> +#define PCI_IO_END           (PAGE_OFFSET - SZ_2M)
>>>  #define PCI_IO_START         (PCI_IO_END - PCI_IO_SIZE)
>>>  #define FIXADDR_TOP          (PCI_IO_START - SZ_2M)
>>>  #define TASK_SIZE_64         (UL(1) << VA_BITS)
>>>
>>> +#ifndef CONFIG_KASAN
>>> +#define MODULES_VADDR                (VA_START)
>>> +#else
>>> +#include <asm/kasan.h>
>>> +#define MODULES_VADDR                (KASAN_SHADOW_END)
>>> +#endif
>>> +
>>> +#define MODULES_VSIZE                (SZ_64M)
>>> +#define MODULES_END          (MODULES_VADDR + MODULES_VSIZE)
>>> +
>>> +#define KIMAGE_VADDR         (MODULES_END)
>>> +#define VMALLOC_START                (MODULES_END)
>>> +
>>>  #ifdef CONFIG_COMPAT
>>>  #define TASK_SIZE_32         UL(0x100000000)
>>>  #define TASK_SIZE            (test_thread_flag(TIF_32BIT) ? \
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 7b4e16068c9f..a910a44d7ab3 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -42,13 +42,6 @@
>>>   */
>>>  #define VMEMMAP_SIZE         ALIGN((1UL << (VA_BITS - PAGE_SHIFT)) * sizeof(struct page), PUD_SIZE)
>>>
>>> -#ifndef CONFIG_KASAN
>>> -#define VMALLOC_START                (VA_START)
>>> -#else
>>> -#include <asm/kasan.h>
>>> -#define VMALLOC_START                (KASAN_SHADOW_END + SZ_64K)
>>> -#endif
>>> -
>>>  #define VMALLOC_END          (PAGE_OFFSET - PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
>>
>> It's a shame VMALLOC_START and VMALLOC_END are now in different headers.
>> It would be nice if we could keep them together.
>>
>> As VMEMMAP_SIZE depends on sizeof(struct page), it's not just a simple
>> move. We could either place that in the !__ASSEMBLY__ portion of
>> memory.h, or we could add S_PAGE to asm-offsets.
>>
>> If that's too painful now, we can leave that for subsequent cleanup;
>> there's other stuff in that area I'd like to unify at some point (e.g.
>> the mem_init and dump.c section boundary descriptions).
>>
>
> No, I think I can probably do a bit better than this. I will address it in v4
>
>>>
>>>  #define vmemmap                      ((struct page *)(VMALLOC_END + SZ_64K))
>>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>>> index cfed56f0ad26..c67ba4453ec6 100644
>>> --- a/arch/arm64/kernel/setup.c
>>> +++ b/arch/arm64/kernel/setup.c
>>> @@ -53,6 +53,7 @@
>>>  #include <asm/cpufeature.h>
>>>  #include <asm/cpu_ops.h>
>>>  #include <asm/kasan.h>
>>> +#include <asm/kernel-pgtable.h>
>>>  #include <asm/sections.h>
>>>  #include <asm/setup.h>
>>>  #include <asm/smp_plat.h>
>>> @@ -291,6 +292,17 @@ u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
>>>
>>>  void __init setup_arch(char **cmdline_p)
>>>  {
>>> +     static struct vm_struct vmlinux_vm;
>>> +
>>> +     vmlinux_vm.addr         = (void *)KIMAGE_VADDR;
>>> +     vmlinux_vm.size         = round_up((u64)_end - KIMAGE_VADDR,
>>> +                                        SWAPPER_BLOCK_SIZE);
>>
>> With the fine grained tables we should only need to round up to
>> PAGE_SIZE (though _end is implicitly page-aligned anyway). Given that,
>> is the SWAPPER_BLOCK_SIZE rounding necessary?
>>
>
> No, probably not.
>
>>> +     vmlinux_vm.phys_addr    = __pa(KIMAGE_VADDR);
>>> +     vmlinux_vm.flags        = VM_MAP;
>>
>> I was going to say we should set VM_KASAN also per its description in
>> include/vmalloc.h, though per its uses its not clear if it will ever
>> matter.
>>
>
> No, we shouldn't. Even if we are never going to unmap this vma,
> setting the flag will result in the shadow area being freed using
> vfree(), while it was not allocated via vmalloc() so that is likely to
> cause trouble.
>
>>> +     vmlinux_vm.caller       = setup_arch;
>>> +
>>> +     vm_area_add_early(&vmlinux_vm);
>>
>> Do we need to register the kernel VA range quite this early, or could we
>> do this around paging_init/map_kernel time?
>>
>
> No. Locally, I moved it into map_kernel_chunk, so that we have
> separate areas for _text, _init and _data, and we can unmap the _init
> entirely rather than only stripping the exec bit. I haven't quite
> figured out how to get rid of the vma area, but perhaps it make sense
> to keep it reserved, so that modules don't end up there later (which
> is possible with the module region randomization I have implemented
> for v4) since I don't know how well things like kallsyms etc cope with
> that.
>
>>> +
>>>       pr_info("Boot CPU: AArch64 Processor [%08x]\n", read_cpuid_id());
>>>
>>>       sprintf(init_utsname()->machine, ELF_PLATFORM);
>>> diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
>>> index 5a22a119a74c..e83ffb00560c 100644
>>> --- a/arch/arm64/mm/dump.c
>>> +++ b/arch/arm64/mm/dump.c
>>> @@ -35,7 +35,9 @@ struct addr_marker {
>>>  };
>>>
>>>  enum address_markers_idx {
>>> -     VMALLOC_START_NR = 0,
>>> +     MODULES_START_NR = 0,
>>> +     MODULES_END_NR,
>>> +     VMALLOC_START_NR,
>>>       VMALLOC_END_NR,
>>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>>       VMEMMAP_START_NR,
>>> @@ -45,12 +47,12 @@ enum address_markers_idx {
>>>       FIXADDR_END_NR,
>>>       PCI_START_NR,
>>>       PCI_END_NR,
>>> -     MODULES_START_NR,
>>> -     MODUELS_END_NR,
>>>       KERNEL_SPACE_NR,
>>>  };
>>>
>>>  static struct addr_marker address_markers[] = {
>>> +     { MODULES_VADDR,        "Modules start" },
>>> +     { MODULES_END,          "Modules end" },
>>>       { VMALLOC_START,        "vmalloc() Area" },
>>>       { VMALLOC_END,          "vmalloc() End" },
>>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>> @@ -61,9 +63,7 @@ static struct addr_marker address_markers[] = {
>>>       { FIXADDR_TOP,          "Fixmap end" },
>>>       { PCI_IO_START,         "PCI I/O start" },
>>>       { PCI_IO_END,           "PCI I/O end" },
>>> -     { MODULES_VADDR,        "Modules start" },
>>> -     { MODULES_END,          "Modules end" },
>>> -     { PAGE_OFFSET,          "Kernel Mapping" },
>>> +     { PAGE_OFFSET,          "Linear Mapping" },
>>>       { -1,                   NULL },
>>>  };
>>>
>>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>>> index f3b061e67bfe..baa923bda651 100644
>>> --- a/arch/arm64/mm/init.c
>>> +++ b/arch/arm64/mm/init.c
>>> @@ -302,22 +302,26 @@ void __init mem_init(void)
>>>  #ifdef CONFIG_KASAN
>>>                 "    kasan   : 0x%16lx - 0x%16lx   (%6ld GB)\n"
>>>  #endif
>>> +               "    modules : 0x%16lx - 0x%16lx   (%6ld MB)\n"
>>>                 "    vmalloc : 0x%16lx - 0x%16lx   (%6ld GB)\n"
>>> +               "      .init : 0x%p" " - 0x%p" "   (%6ld KB)\n"
>>> +               "      .text : 0x%p" " - 0x%p" "   (%6ld KB)\n"
>>> +               "      .data : 0x%p" " - 0x%p" "   (%6ld KB)\n"
>>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>>                 "    vmemmap : 0x%16lx - 0x%16lx   (%6ld GB maximum)\n"
>>>                 "              0x%16lx - 0x%16lx   (%6ld MB actual)\n"
>>>  #endif
>>>                 "    fixed   : 0x%16lx - 0x%16lx   (%6ld KB)\n"
>>>                 "    PCI I/O : 0x%16lx - 0x%16lx   (%6ld MB)\n"
>>> -               "    modules : 0x%16lx - 0x%16lx   (%6ld MB)\n"
>>> -               "    memory  : 0x%16lx - 0x%16lx   (%6ld MB)\n"
>>> -               "      .init : 0x%p" " - 0x%p" "   (%6ld KB)\n"
>>> -               "      .text : 0x%p" " - 0x%p" "   (%6ld KB)\n"
>>> -               "      .data : 0x%p" " - 0x%p" "   (%6ld KB)\n",
>>> +               "    memory  : 0x%16lx - 0x%16lx   (%6ld MB)\n",
>>>  #ifdef CONFIG_KASAN
>>>                 MLG(KASAN_SHADOW_START, KASAN_SHADOW_END),
>>>  #endif
>>> +               MLM(MODULES_VADDR, MODULES_END),
>>>                 MLG(VMALLOC_START, VMALLOC_END),
>>> +               MLK_ROUNDUP(__init_begin, __init_end),
>>> +               MLK_ROUNDUP(_text, _etext),
>>> +               MLK_ROUNDUP(_sdata, _edata),
>>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>>                 MLG((unsigned long)vmemmap,
>>>                     (unsigned long)vmemmap + VMEMMAP_SIZE),
>>> @@ -326,11 +330,7 @@ void __init mem_init(void)
>>>  #endif
>>>                 MLK(FIXADDR_START, FIXADDR_TOP),
>>>                 MLM(PCI_IO_START, PCI_IO_END),
>>> -               MLM(MODULES_VADDR, MODULES_END),
>>> -               MLM(PAGE_OFFSET, (unsigned long)high_memory),
>>> -               MLK_ROUNDUP(__init_begin, __init_end),
>>> -               MLK_ROUNDUP(_text, _etext),
>>> -               MLK_ROUNDUP(_sdata, _edata));
>>> +               MLM(PAGE_OFFSET, (unsigned long)high_memory));
>>>
>>>  #undef MLK
>>>  #undef MLM
>>> diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
>>> index 0ca411fc5ea3..acdd1ac166ec 100644
>>> --- a/arch/arm64/mm/kasan_init.c
>>> +++ b/arch/arm64/mm/kasan_init.c
>>> @@ -17,9 +17,11 @@
>>>  #include <linux/start_kernel.h>
>>>
>>>  #include <asm/mmu_context.h>
>>> +#include <asm/kernel-pgtable.h>
>>>  #include <asm/page.h>
>>>  #include <asm/pgalloc.h>
>>>  #include <asm/pgtable.h>
>>> +#include <asm/sections.h>
>>>  #include <asm/tlbflush.h>
>>>
>>>  static pgd_t tmp_pg_dir[PTRS_PER_PGD] __initdata __aligned(PGD_SIZE);
>>> @@ -33,7 +35,7 @@ static void __init kasan_early_pte_populate(pmd_t *pmd, unsigned long addr,
>>>       if (pmd_none(*pmd))
>>>               pmd_populate_kernel(&init_mm, pmd, kasan_zero_pte);
>>>
>>> -     pte = pte_offset_kernel(pmd, addr);
>>> +     pte = pte_offset_kimg(pmd, addr);
>>>       do {
>>>               next = addr + PAGE_SIZE;
>>>               set_pte(pte, pfn_pte(virt_to_pfn(kasan_zero_page),
>>> @@ -51,7 +53,7 @@ static void __init kasan_early_pmd_populate(pud_t *pud,
>>>       if (pud_none(*pud))
>>>               pud_populate(&init_mm, pud, kasan_zero_pmd);
>>>
>>> -     pmd = pmd_offset(pud, addr);
>>> +     pmd = pmd_offset_kimg(pud, addr);
>>>       do {
>>>               next = pmd_addr_end(addr, end);
>>>               kasan_early_pte_populate(pmd, addr, next);
>>> @@ -68,7 +70,7 @@ static void __init kasan_early_pud_populate(pgd_t *pgd,
>>>       if (pgd_none(*pgd))
>>>               pgd_populate(&init_mm, pgd, kasan_zero_pud);
>>>
>>> -     pud = pud_offset(pgd, addr);
>>> +     pud = pud_offset_kimg(pgd, addr);
>>>       do {
>>>               next = pud_addr_end(addr, end);
>>>               kasan_early_pmd_populate(pud, addr, next);
>>> @@ -126,8 +128,14 @@ static void __init clear_pgds(unsigned long start,
>>>
>>>  void __init kasan_init(void)
>>>  {
>>> +     u64 kimg_shadow_start, kimg_shadow_end;
>>>       struct memblock_region *reg;
>>>
>>> +     kimg_shadow_start = round_down((u64)kasan_mem_to_shadow(_text),
>>> +                                    SWAPPER_BLOCK_SIZE);
>>> +     kimg_shadow_end = round_up((u64)kasan_mem_to_shadow(_end),
>>> +                                SWAPPER_BLOCK_SIZE);
>>
>> This rounding looks suspect to me, given it's applied to the shadow
>> addresses rather than the kimage addresses. That's roughly equivalent to
>> kasan_mem_to_shadow(round_up(_end, 8 * SWAPPER_BLOCK_SIZE).
>>
>> I don't think we need any rounding for the kimage addresses. The image
>> end is page-granular (and the fine-grained mapping will reflect that).
>> Any accesses between _end and roud_up(_end, SWAPPER_BLOCK_SIZE) would be
>> bugs (and would most likely fault) regardless of KASAN.
>>
>> Or am I just being thick here?
>>
>
> Well, the problem here is that vmemmap_populate() is used as a
> surrogate vmalloc() since that is not available yet, and
> vmemmap_populate() allocates in SWAPPER_BLOCK_SIZE granularity.
> If I remove the rounding, I get false positive kasan errors which I
> have not quite diagnosed yet, but are probably due to the fact that
> the rounding performed by vmemmap_populate() goes in the wrong
> direction.
>
> I do wonder what that means for memblocks that are not multiples of 16
> MB, though (below)
>
>>> +
>>>       /*
>>>        * We are going to perform proper setup of shadow memory.
>>>        * At first we should unmap early shadow (clear_pgds() call bellow).
>>> @@ -141,8 +149,13 @@ void __init kasan_init(void)
>>>
>>>       clear_pgds(KASAN_SHADOW_START, KASAN_SHADOW_END);
>>>
>>> +     vmemmap_populate(kimg_shadow_start, kimg_shadow_end,
>>> +                      pfn_to_nid(virt_to_pfn(kimg_shadow_start)));
>>
>> That virt_to_pfn doesn't look right -- kimg_shadow_start is neither a
>> linear address nor an image address. As pfn_to_nid is hard-coded to 0
>> for !NUMA this happens to be ok for us for the moment.
>>
>> I think we should follow the x86 KASAN code and use NUMA_NO_NODE for
>> this for now.
>>
>
> Ack
>
>>> +
>>>       kasan_populate_zero_shadow((void *)KASAN_SHADOW_START,
>>> -                     kasan_mem_to_shadow((void *)MODULES_VADDR));
>>> +                                (void *)kimg_shadow_start);
>>> +     kasan_populate_zero_shadow((void *)kimg_shadow_end,
>>> +                                kasan_mem_to_shadow((void *)PAGE_OFFSET));
>>>
>>>       for_each_memblock(memory, reg) {
>>>               void *start = (void *)__phys_to_virt(reg->base);
>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index 75b5f0dc3bdc..0b28f1469f9b 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -53,6 +53,10 @@ u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
>>>  unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
>>>  EXPORT_SYMBOL(empty_zero_page);
>>>
>>> +static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
>>> +static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
>>> +static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
>>> +
>>>  pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>>>                             unsigned long size, pgprot_t vma_prot)
>>>  {
>>> @@ -349,14 +353,14 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>>>  {
>>>
>>>       unsigned long kernel_start = __pa(_stext);
>>> -     unsigned long kernel_end = __pa(_end);
>>> +     unsigned long kernel_end = __pa(_etext);
>>>
>>>       /*
>>> -      * The kernel itself is mapped at page granularity. Map all other
>>> -      * memory, making sure we don't overwrite the existing kernel mappings.
>>> +      * Take care not to create a writable alias for the
>>> +      * read-only text and rodata sections of the kernel image.
>>>        */
>>>
>>> -     /* No overlap with the kernel. */
>>> +     /* No overlap with the kernel text */
>>>       if (end < kernel_start || start >= kernel_end) {
>>>               __create_pgd_mapping(pgd, start, __phys_to_virt(start),
>>>                                    end - start, PAGE_KERNEL,
>>> @@ -365,7 +369,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>>>       }
>>>
>>>       /*
>>> -      * This block overlaps the kernel mapping. Map the portion(s) which
>>> +      * This block overlaps the kernel text mapping. Map the portion(s) which
>>>        * don't overlap.
>>>        */
>>>       if (start < kernel_start)
>>> @@ -438,12 +442,29 @@ static void __init map_kernel(pgd_t *pgd)
>>>       map_kernel_chunk(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC);
>>>       map_kernel_chunk(pgd, _data, _end, PAGE_KERNEL);
>>>
>>> -     /*
>>> -      * The fixmap falls in a separate pgd to the kernel, and doesn't live
>>> -      * in the carveout for the swapper_pg_dir. We can simply re-use the
>>> -      * existing dir for the fixmap.
>>> -      */
>>> -     set_pgd(pgd_offset_raw(pgd, FIXADDR_START), *pgd_offset_k(FIXADDR_START));
>>> +     if (pgd_index(FIXADDR_START) != pgd_index((u64)_end)) {
>>
>> To match the style of early_fixmap_init, and given we already mapped the
>> kernel image, this could be:
>>
>>         if (pgd_none(pgd_offset_raw(pgd, FIXADDR_START))) {
>>
>> Which also serves as a run-time check that the pgd entry really was
>> clear.
>>
>
> Yes, that looks better. I will steal that :-)
>

OK, that doesn't work. pgd_none() is hardcoded to 'false' when running
with fewer than 4 pgtable levels, and so we always hit the BUG() here.


>> Other than that, this looks good to me!
>>
>
> Thanks!
>
>>> +             /*
>>> +              * The fixmap falls in a separate pgd to the kernel, and doesn't
>>> +              * live in the carveout for the swapper_pg_dir. We can simply
>>> +              * re-use the existing dir for the fixmap.
>>> +              */
>>> +             set_pgd(pgd_offset_raw(pgd, FIXADDR_START),
>>> +                     *pgd_offset_k(FIXADDR_START));
>>> +     } else if (CONFIG_PGTABLE_LEVELS > 3) {
>>> +             /*
>>> +              * The fixmap shares its top level pgd entry with the kernel
>>> +              * mapping. This can really only occur when we are running
>>> +              * with 16k/4 levels, so we can simply reuse the pud level
>>> +              * entry instead.
>>> +              */
>>> +             BUG_ON(!IS_ENABLED(CONFIG_ARM64_16K_PAGES));
>>> +
>>> +             set_pud(pud_set_fixmap_offset(pgd, FIXADDR_START),
>>> +                     __pud(__pa(bm_pmd) | PUD_TYPE_TABLE));
>>> +             pud_clear_fixmap();
>>> +     } else {
>>> +             BUG();
>>> +     }
>>>
>>>       kasan_copy_shadow(pgd);
>>>  }
>>> @@ -569,10 +590,6 @@ void vmemmap_free(unsigned long start, unsigned long end)
>>>  }
>>>  #endif       /* CONFIG_SPARSEMEM_VMEMMAP */
>>>
>>> -static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
>>> -static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
>>> -static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
>>> -
>>>  static inline pud_t * fixmap_pud(unsigned long addr)
>>>  {
>>>       return (CONFIG_PGTABLE_LEVELS > 3) ? &bm_pud[pud_index(addr)]
>>> @@ -598,8 +615,19 @@ void __init early_fixmap_init(void)
>>>       unsigned long addr = FIXADDR_START;
>>>
>>>       pgd = pgd_offset_k(addr);
>>> -     pgd_populate(&init_mm, pgd, bm_pud);
>>> -     pud = fixmap_pud(addr);
>>> +     if (CONFIG_PGTABLE_LEVELS > 3 && !pgd_none(*pgd)) {
>>> +             /*
>>> +              * We only end up here if the kernel mapping and the fixmap
>>> +              * share the top level pgd entry, which should only happen on
>>> +              * 16k/4 levels configurations.
>>> +              */
>>> +             BUG_ON(!IS_ENABLED(CONFIG_ARM64_16K_PAGES));
>>> +             pud = pud_offset_kimg(pgd, addr);
>>> +             memblock_free(__pa(bm_pud), sizeof(bm_pud));
>>> +     } else {
>>> +             pgd_populate(&init_mm, pgd, bm_pud);
>>> +             pud = fixmap_pud(addr);
>>> +     }
>>>       pud_populate(&init_mm, pud, bm_pmd);
>>>       pmd = fixmap_pmd(addr);
>>>       pmd_populate_kernel(&init_mm, pmd, bm_pte);
>>> --
>>> 2.5.0
>>>
