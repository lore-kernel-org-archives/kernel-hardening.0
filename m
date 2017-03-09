From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 21:52:04 +0100
Message-Id: <1489092729-16871-7-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v6 06/11] arm64/mmu: align alloc_init_pte prototype with pmd/pud versions
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Align the function prototype of alloc_init_pte() with its pmd and pud
counterparts by replacing the pfn parameter with the equivalent physical
address.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 75e21c33caff..bb9179084217 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -107,7 +107,7 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 }
 
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, unsigned long pfn,
+				  unsigned long end, phys_addr_t phys,
 				  pgprot_t prot,
 				  phys_addr_t (*pgtable_alloc)(void))
 {
@@ -128,8 +128,7 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	do {
 		pte_t old_pte = *pte;
 
-		set_pte(pte, pfn_pte(pfn, prot));
-		pfn++;
+		set_pte(pte, pfn_pte(__phys_to_pfn(phys), prot));
 
 		/*
 		 * After the PTE entry has been populated once, we
@@ -137,6 +136,7 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 		 */
 		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte), pte_val(*pte)));
 
+		phys += PAGE_SIZE;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	pte_clear_fixmap();
@@ -182,7 +182,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      pmd_val(*pmd)));
 		} else {
-			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
+			alloc_init_pte(pmd, addr, next, phys,
 				       prot, pgtable_alloc);
 
 			BUG_ON(pmd_val(old_pmd) != 0 &&
-- 
2.7.4
