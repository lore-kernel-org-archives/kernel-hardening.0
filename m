Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <568D4256.5030700@arm.com>
Date: Wed, 06 Jan 2016 16:35:34 +0000
From: James Morse <james.morse@arm.com>
MIME-Version: 1.0
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org> <1451489172-17420-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1451489172-17420-5-git-send-email-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 04/13] arm64: decouple early fixmap init from linear
 mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard!

On 30/12/15 15:26, Ard Biesheuvel wrote:
> Since the early fixmap page tables are populated using pages that are
> part of the static footprint of the kernel, they are covered by the
> initial kernel mapping, and we can refer to them without using __va/__pa
> translations, which are tied to the linear mapping.
> 
> Instead, let's introduce __phys_to_kimg, which will be tied to the kernel
> virtual mapping, regardless of whether or not it intersects with the linear
> mapping. This will allow us to move the kernel out of the linear mapping in
> a subsequent patch.
> 

I gave your arm64-kaslr-v2 branch a go on juno r1, currently with
ARM64_RELOCATABLE_KERNEL=n, to find it didn't boot.

git bisect pointed to this patch. From the debugger it looks like
rubbish is ending up the page tables after early_fixmap_init(), printing
bits of bm_pmd and friends shows these aren't zeroed.

I think this is because the section(".pgdir") is dragging these outside
the __bss_start/__bss_stop range that is zeroed in head.S:__mmap_switched().

The following inelegant patch fixes this problem for me:
----------------------------%<----------------------------
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a78fc5a882da..15fc9712ddc1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -559,6 +559,7 @@ void __init early_fixmap_init(void)
        if (pgd_none(*pgd)) {
                static pud_t bm_pud[PTRS_PER_PUD] __pgdir;

+               memset(bm_pud, 0, sizeof(bm_pud));
                pgd_populate(&init_mm, pgd, bm_pud);
                memblock_reserve(__pa(bm_pud), sizeof(bm_pud));
        }
@@ -570,6 +571,7 @@ void __init early_fixmap_init(void)
        if (pud_none(*pud)) {
                static pmd_t bm_pmd[PTRS_PER_PMD] __pgdir;

+               memset(bm_pmd, 0, sizeof(bm_pmd));
                pud_populate(&init_mm, pud, bm_pmd);
                memblock_reserve(__pa(bm_pmd), sizeof(bm_pmd));
        }
@@ -580,6 +582,7 @@ void __init early_fixmap_init(void)
        if (pmd_none(*pmd)) {
                static pte_t bm_pte[PTRS_PER_PTE] __pgdir;

+               memset(bm_pte, 0, sizeof(bm_pte));
                pmd_populate_kernel(&init_mm, pmd, bm_pte);
                memblock_reserve(__pa(bm_pte), sizeof(bm_pte));
        }
----------------------------%<----------------------------

I'm sure there is a better way!


Thanks,

James
