From: Tycho Andersen <tycho@docker.com>
Date: Wed,  9 Aug 2017 14:07:54 -0600
Message-Id: <20170809200755.11234-10-tycho@docker.com>
In-Reply-To: <20170809200755.11234-1-tycho@docker.com>
References: <20170809200755.11234-1-tycho@docker.com>
Subject: [kernel-hardening] [PATCH v5 09/10] mm: add a user_virt_to_phys symbol
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

We need someting like this for testing XPFO. Since it's architecture
specific, putting it in the test code is slightly awkward, so let's make it
an arch-specific symbol and export it for use in LKDTM.

Signed-off-by: Tycho Andersen <tycho@docker.com>
Tested-by: Marco Benatto <marco.antonio.780@gmail.com>
---
 arch/arm64/mm/xpfo.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/xpfo.c   | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/xpfo.h |  4 ++++
 3 files changed, 112 insertions(+)

diff --git a/arch/arm64/mm/xpfo.c b/arch/arm64/mm/xpfo.c
index c4deb2b720cf..a221799a9242 100644
--- a/arch/arm64/mm/xpfo.c
+++ b/arch/arm64/mm/xpfo.c
@@ -107,3 +107,54 @@ inline void xpfo_dma_map_unmap_area(bool map, const void *addr, size_t size,
 
 	local_irq_restore(flags);
 }
+
+/* Convert a user space virtual address to a physical address.
+ * Shamelessly copied from slow_virt_to_phys() and lookup_address() in
+ * arch/x86/mm/pageattr.c
+ */
+phys_addr_t user_virt_to_phys(unsigned long addr)
+{
+	phys_addr_t phys_addr;
+	unsigned long offset;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(current->mm, addr);
+	if (pgd_none(*pgd))
+		return 0;
+
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d))
+		return 0;
+
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud))
+		return 0;
+
+	if (pud_sect(*pud) || !pud_present(*pud)) {
+		phys_addr = (unsigned long)pud_pfn(*pud) << PAGE_SHIFT;
+		offset = addr & ~PUD_MASK;
+		goto out;
+	}
+
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return 0;
+
+	if (pmd_sect(*pmd) || !pmd_present(*pmd)) {
+		phys_addr = (unsigned long)pmd_pfn(*pmd) << PAGE_SHIFT;
+		offset = addr & ~PMD_MASK;
+		goto out;
+	}
+
+	pte =  pte_offset_kernel(pmd, addr);
+	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
+	offset = addr & ~PAGE_MASK;
+
+out:
+	return (phys_addr_t)(phys_addr | offset);
+}
+EXPORT_SYMBOL(user_virt_to_phys);
diff --git a/arch/x86/mm/xpfo.c b/arch/x86/mm/xpfo.c
index 3635b37f2fc5..a1344f27406c 100644
--- a/arch/x86/mm/xpfo.c
+++ b/arch/x86/mm/xpfo.c
@@ -94,3 +94,60 @@ inline void xpfo_flush_kernel_page(struct page *page, int order)
 
 	flush_tlb_kernel_range(kaddr, kaddr + (1 << order) * size);
 }
+
+/* Convert a user space virtual address to a physical address.
+ * Shamelessly copied from slow_virt_to_phys() and lookup_address() in
+ * arch/x86/mm/pageattr.c
+ */
+phys_addr_t user_virt_to_phys(unsigned long addr)
+{
+	phys_addr_t phys_addr;
+	unsigned long offset;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(current->mm, addr);
+	if (pgd_none(*pgd))
+		return 0;
+
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d))
+		return 0;
+
+	if (p4d_large(*p4d) || !p4d_present(*p4d)) {
+		phys_addr = (unsigned long)p4d_pfn(*p4d) << PAGE_SHIFT;
+		offset = addr & ~P4D_MASK;
+		goto out;
+	}
+
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud))
+		return 0;
+
+	if (pud_large(*pud) || !pud_present(*pud)) {
+		phys_addr = (unsigned long)pud_pfn(*pud) << PAGE_SHIFT;
+		offset = addr & ~PUD_MASK;
+		goto out;
+	}
+
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return 0;
+
+	if (pmd_large(*pmd) || !pmd_present(*pmd)) {
+		phys_addr = (unsigned long)pmd_pfn(*pmd) << PAGE_SHIFT;
+		offset = addr & ~PMD_MASK;
+		goto out;
+	}
+
+	pte =  pte_offset_kernel(pmd, addr);
+	phys_addr = (phys_addr_t)pte_pfn(*pte) << PAGE_SHIFT;
+	offset = addr & ~PAGE_MASK;
+
+out:
+	return (phys_addr_t)(phys_addr | offset);
+}
+EXPORT_SYMBOL(user_virt_to_phys);
diff --git a/include/linux/xpfo.h b/include/linux/xpfo.h
index 6b61f7b820f4..449cd8dbf064 100644
--- a/include/linux/xpfo.h
+++ b/include/linux/xpfo.h
@@ -16,6 +16,8 @@
 
 #ifdef CONFIG_XPFO
 
+#include <linux/types.h>
+
 extern struct page_ext_operations page_xpfo_ops;
 
 void set_kpte(void *kaddr, struct page *page, pgprot_t prot);
@@ -29,6 +31,8 @@ void xpfo_free_pages(struct page *page, int order);
 
 bool xpfo_page_is_unmapped(struct page *page);
 
+extern phys_addr_t user_virt_to_phys(unsigned long addr);
+
 #else /* !CONFIG_XPFO */
 
 static inline void xpfo_kmap(void *kaddr, struct page *page) { }
-- 
2.11.0
