MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486747005-15973-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org> <1486747005-15973-3-git-send-email-ard.biesheuvel@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 10 Feb 2017 10:45:37 -0800
Message-ID: <CAGXu5jLNyvpyF3a7vrOpf9HAn_UL66_bdkKFyK8zGmw-RdhHfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 2/4] arm64: alternatives: apply boot time fixups via the
 linear mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laura Abbott <labbott@fedoraproject.org>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, andre.przywara@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 9:16 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> One important rule of thumb when designing a secure software system is
> that memory should never be writable and executable at the same time.
> We mostly adhere to this rule in the kernel, except at boot time, when
> regions may be mapped RWX until after we are done applying alternatives
> or making other one-off changes.
>
> For the alternative patching, we can improve the situation by applying
> the fixups via the linear mapping, which is never mapped with executable
> permissions. So map the linear alias of .text with RW- permissions
> initially, and remove the write permissions as soon as alternative
> patching has completed.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/mmu.h    |  1 +
>  arch/arm64/kernel/alternative.c |  6 ++---
>  arch/arm64/kernel/smp.c         |  1 +
>  arch/arm64/mm/mmu.c             | 25 ++++++++++++++++----
>  4 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index 47619411f0ff..5468c834b072 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -37,5 +37,6 @@ extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>                                unsigned long virt, phys_addr_t size,
>                                pgprot_t prot, bool page_mappings_only);
>  extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
> +extern void mark_linear_text_alias_ro(void);
>
>  #endif
> diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
> index 06d650f61da7..eacdbcc45630 100644
> --- a/arch/arm64/kernel/alternative.c
> +++ b/arch/arm64/kernel/alternative.c
> @@ -122,7 +122,7 @@ static void __apply_alternatives(void *alt_region)
>
>                 pr_info_once("patching kernel code\n");
>
> -               origptr = ALT_ORIG_PTR(alt);
> +               origptr = lm_alias(ALT_ORIG_PTR(alt));
>                 replptr = ALT_REPL_PTR(alt);
>                 nr_inst = alt->alt_len / sizeof(insn);
>
> @@ -131,8 +131,8 @@ static void __apply_alternatives(void *alt_region)
>                         *(origptr + i) = cpu_to_le32(insn);
>                 }
>
> -               flush_icache_range((uintptr_t)origptr,
> -                                  (uintptr_t)(origptr + nr_inst));
> +               flush_icache_range((uintptr_t)ALT_ORIG_PTR(alt),
> +                                  (uintptr_t)(ALT_ORIG_PTR(alt) + nr_inst));
>         }
>  }
>
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index a8ec5da530af..d6307e311a10 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -432,6 +432,7 @@ void __init smp_cpus_done(unsigned int max_cpus)
>         setup_cpu_features();
>         hyp_mode_check();
>         apply_alternatives_all();
> +       mark_linear_text_alias_ro();
>  }
>
>  void __init smp_prepare_boot_cpu(void)
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2131521ddc24..f4b045d1cc53 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -395,16 +395,31 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
>                                      debug_pagealloc_enabled());
>
>         /*
> -        * Map the linear alias of the [_text, __init_begin) interval as
> -        * read-only/non-executable. This makes the contents of the
> -        * region accessible to subsystems such as hibernate, but
> -        * protects it from inadvertent modification or execution.
> +        * Map the linear alias of the [_text, __init_begin) interval
> +        * as non-executable now, and remove the write permission in
> +        * mark_linear_text_alias_ro() below (which will be called after
> +        * alternative patching has completed). This makes the contents
> +        * of the region accessible to subsystems such as hibernate,
> +        * but protects it from inadvertent modification or execution.
>          */
>         __create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
> -                            kernel_end - kernel_start, PAGE_KERNEL_RO,
> +                            kernel_end - kernel_start, PAGE_KERNEL,
>                              early_pgtable_alloc, debug_pagealloc_enabled());
>  }
>
> +void mark_linear_text_alias_ro(void)
> +{
> +       /*
> +        * Remove the write permissions from the linear alias of .text/.rodata
> +        */
> +       create_mapping_late(__pa_symbol(_text), (unsigned long)lm_alias(_text),
> +                           (unsigned long)__init_begin - (unsigned long)_text,
> +                           PAGE_KERNEL_RO);
> +
> +       /* flush the TLBs after updating live kernel mappings */
> +       flush_tlb_all();
> +}

Oh, dur, sorry, I missed this the first time through. Nevermind! Looks
like linear will be RO, kernel will be ROX at runtime, and during
boot, kernel will be ROX, and linear will be RW. Nice!

-Kees

> +
>  static void __init map_mem(pgd_t *pgd)
>  {
>         struct memblock_region *reg;
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
