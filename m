Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 11 Jan 2016 14:18:59 +0100
Message-Id: <1452518355-4606-7-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 06/21] arm64: pgtable: implement static [pte|pmd|pud]_offset variants
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The page table accessors pte_offset(), pud_offset() and pmd_offset()
rely on __va translations, so they can only be used after the linear
mapping has been installed. For the early fixmap and kasan init routines,
whose page tables are allocated statically in the kernel image, these
functions will return bogus values. So implement pmd_offset_kimg() and
pud_offset_kimg(), which can be used instead before any page tables have
been allocated dynamically.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/pgtable.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6129f6755081..7b4e16068c9f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -449,6 +449,9 @@ static inline phys_addr_t pmd_page_paddr(pmd_t pmd)
 
 #define pmd_page(pmd)		pfn_to_page(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
+/* use ONLY for statically allocated translation tables */
+#define pte_offset_kimg(dir,addr)	((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))))
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -492,6 +495,9 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
 
 #define pud_page(pud)		pfn_to_page(__phys_to_pfn(pud_val(pud) & PHYS_MASK))
 
+/* use ONLY for statically allocated translation tables */
+#define pmd_offset_kimg(dir,addr)	((pmd_t *)__phys_to_kimg(pmd_offset_phys((dir), (addr))))
+
 #else
 
 #define pud_page_paddr(pud)	({ BUILD_BUG(); 0; })
@@ -502,6 +508,8 @@ static inline phys_addr_t pud_page_paddr(pud_t pud)
 #define pmd_set_fixmap_offset(pudp, addr)	((pmd_t *)pudp)
 #define pmd_clear_fixmap()
 
+#define pmd_offset_kimg(dir,addr)	((pmd_t *)dir)
+
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
 #if CONFIG_PGTABLE_LEVELS > 3
@@ -540,6 +548,9 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
 
 #define pgd_page(pgd)		pfn_to_page(__phys_to_pfn(pgd_val(pgd) & PHYS_MASK))
 
+/* use ONLY for statically allocated translation tables */
+#define pud_offset_kimg(dir,addr)	((pud_t *)__phys_to_kimg(pud_offset_phys((dir), (addr))))
+
 #else
 
 #define pgd_page_paddr(pgd)	({ BUILD_BUG(); 0;})
@@ -550,6 +561,8 @@ static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
 #define pud_set_fixmap_offset(pgdp, addr)	((pud_t *)pgdp)
 #define pud_clear_fixmap()
 
+#define pud_offset_kimg(dir,addr)	((pud_t *)dir)
+
 #endif  /* CONFIG_PGTABLE_LEVELS > 3 */
 
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
-- 
2.5.0
