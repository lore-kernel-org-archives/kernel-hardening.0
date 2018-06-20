MIME-Version: 1.0
In-Reply-To: <20180620085755.20045-2-yaojun8558363@gmail.com>
References: <20180620085755.20045-1-yaojun8558363@gmail.com> <20180620085755.20045-2-yaojun8558363@gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 20 Jun 2018 12:09:49 +0200
Message-ID: <CAKv+Gu8_=uTJFDXr0GpGMc=9WZ9tbz305CE6i=qbnqRB=suRVA@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64/mm: move {idmap_pg_dir,tramp_pg_dir,swapper_pg_dir}
 to .rodata section
Content-Type: text/plain; charset="UTF-8"
To: Jun Yao <yaojun8558363@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 20 June 2018 at 10:57, Jun Yao <yaojun8558363@gmail.com> wrote:
> Move {idmap_pg_dir,tramp_pg_dir,swapper_pg_dir} to .rodata
> section. And update the swapper_pg_dir by fixmap.
>

I think we may be able to get away with not mapping idmap_pg_dir and
tramp_pg_dir at all.

As for swapper_pg_dir, it would indeed be nice if we could keep those
mappings read-only most of the time, but I'm not sure how useful this
is if we apply it to the root level only.

> Signed-off-by: Jun Yao <yaojun8558363@gmail.com>
> ---
>  arch/arm64/include/asm/pgalloc.h | 19 +++++++++++++++++++
>  arch/arm64/kernel/vmlinux.lds.S  | 32 ++++++++++++++++++--------------
>  arch/arm64/mm/mmu.c              | 23 +++++++++++++++++++----
>  3 files changed, 56 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
> index 2e05bcd944c8..cc96a7e6957d 100644
> --- a/arch/arm64/include/asm/pgalloc.h
> +++ b/arch/arm64/include/asm/pgalloc.h
> @@ -29,6 +29,10 @@
>  #define PGALLOC_GFP    (GFP_KERNEL | __GFP_ZERO)
>  #define PGD_SIZE       (PTRS_PER_PGD * sizeof(pgd_t))
>
> +#if CONFIG_STRICT_KERNEL_RWX
> +extern spinlock_t pgdir_lock;
> +#endif
> +
>  #if CONFIG_PGTABLE_LEVELS > 2
>
>  static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
> @@ -78,6 +82,21 @@ static inline void __pgd_populate(pgd_t *pgdp, phys_addr_t pudp, pgdval_t prot)
>
>  static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgdp, pud_t *pudp)
>  {
> +#if CONFIG_STRICT_KERNEL_RWX
> +       if (mm == &init_mm) {
> +               pgd_t *pgd;
> +
> +               spin_lock(&pgdir_lock);
> +               pgd = pgd_set_fixmap(__pa_symbol(swapper_pg_dir));
> +
> +               pgd = (pgd_t *)((unsigned long)pgd + pgdp - swapper_pg_dir);
> +               __pgd_populate(pgdp, __pa(pudp), PUD_TYPE_TABLE);
> +

This only works for 4-level paging, but we support 2 and 3 level paging as well.

> +               pgd_clear_fixmap();
> +               spin_unlock(&pgdir_lock);
> +               return;
> +       }
> +#endif
>         __pgd_populate(pgdp, __pa(pudp), PUD_TYPE_TABLE);
>  }
>  #else
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 605d1b60469c..86532c57206a 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -216,21 +216,25 @@ SECTIONS
>         BSS_SECTION(0, 0, 0)
>
>         . = ALIGN(PAGE_SIZE);
> -       idmap_pg_dir = .;
> -       . += IDMAP_DIR_SIZE;
>
> -#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> -       tramp_pg_dir = .;
> -       . += PAGE_SIZE;
> -#endif
> -
> -#ifdef CONFIG_ARM64_SW_TTBR0_PAN
> -       reserved_ttbr0 = .;
> -       . += RESERVED_TTBR0_SIZE;
> -#endif
> -       swapper_pg_dir = .;
> -       . += SWAPPER_DIR_SIZE;
> -       swapper_pg_end = .;
> +       .rodata : {
> +               . = ALIGN(PAGE_SIZE);
> +               idmap_pg_dir = .;
> +               . += IDMAP_DIR_SIZE;
> +
> +               #ifdef CONFIG_UNMAP_KERNEL_AT_EL0

CPP directives should start in the first column

> +               tramp_pg_dir = .;
> +               . += PAGE_SIZE;
> +               #endif
> +
> +               #ifdef CONFIG_ARM64_SW_TTBR0_PAN
> +               reserved_ttbr0 = .;
> +               . += RESERVED_TTBR0_SIZE;
> +               #endif
> +               swapper_pg_dir = .;
> +               . += SWAPPER_DIR_SIZE;
> +               swapper_pg_end = .;
> +       }
>
>         __pecoff_data_size = ABSOLUTE(. - __initdata_begin);
>         _end = .;
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2dbb2c9f1ec1..c1aa85a6ada5 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -66,6 +66,10 @@ static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
>  static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
>
> +#ifdef CONFIG_STRICT_KERNEL_RWX
> +DEFINE_SPINLOCK(pgdir_lock);
> +#endif
> +
>  pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>                               unsigned long size, pgprot_t vma_prot)
>  {
> @@ -417,12 +421,22 @@ static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
>
>  void __init mark_linear_text_alias_ro(void)
>  {
> +       unsigned long size;
> +
>         /*
>          * Remove the write permissions from the linear alias of .text/.rodata
> +        *
> +        * We free some pages in .rodata at paging_init(), which generates a
> +        * hole. And the hole splits .rodata into two pieces.
>          */
> +       size = (unsigned long)swapper_pg_dir + PAGE_SIZE - (unsigned long)_text;
>         update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
> -                           (unsigned long)__init_begin - (unsigned long)_text,
> -                           PAGE_KERNEL_RO);
> +                           size, PAGE_KERNEL_RO);
> +
> +       size = (unsigned long)__init_begin - (unsigned long)swapper_pg_end;
> +       update_mapping_prot(__pa_symbol(swapper_pg_end),
> +                           (unsigned long)lm_alias(swapper_pg_end),
> +                           size, PAGE_KERNEL_RO);

I don't think this is necessary. Even if some pages are freed, it
doesn't harm to keep a read-only alias of them here since the new
owner won't access them via this mapping anyway. So we can keep
.rodata as a single region.

>  }
>
>  static void __init map_mem(pgd_t *pgdp)
> @@ -587,8 +601,9 @@ static void __init map_kernel(pgd_t *pgdp)
>          */
>         map_kernel_segment(pgdp, _text, _etext, text_prot, &vmlinux_text, 0,
>                            VM_NO_GUARD);
> -       map_kernel_segment(pgdp, __start_rodata, __inittext_begin, PAGE_KERNEL,
> -                          &vmlinux_rodata, NO_CONT_MAPPINGS, VM_NO_GUARD);
> +       map_kernel_segment(pgdp, __start_rodata, __inittext_begin,
> +                          PAGE_KERNEL, &vmlinux_rodata,
> +                          NO_CONT_MAPPINGS | NO_BLOCK_MAPPINGS, VM_NO_GUARD);

Given the above, you should be able to drop this as well.

>         map_kernel_segment(pgdp, __inittext_begin, __inittext_end, text_prot,
>                            &vmlinux_inittext, 0, VM_NO_GUARD);
>         map_kernel_segment(pgdp, __initdata_begin, __initdata_end, PAGE_KERNEL,
> --
> 2.17.1
>
