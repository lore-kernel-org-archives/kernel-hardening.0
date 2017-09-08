Date: Fri, 8 Sep 2017 11:24:22 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170908172422.rxmhwd2vl6eye2or@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-6-tycho@docker.com>
 <20170908075347.GC4957@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170908075347.GC4957@infradead.org>
Subject: [kernel-hardening] Re: [PATCH v6 05/11] arm64/mm: Add support for XPFO
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 08, 2017 at 12:53:47AM -0700, Christoph Hellwig wrote:
> > +/*
> > + * Lookup the page table entry for a virtual address and return a pointer to
> > + * the entry. Based on x86 tree.
> > + */
> > +static pte_t *lookup_address(unsigned long addr)
> 
> Seems like this should be moved to common arm64 mm code and used by
> kernel_page_present.

Sounds good, I'll include something like the patch below in the next
series.

Unfortunately, adding an implementation of lookup_address seems to be
slightly more complicated than necessary, because of the xen piece. We
have to define lookup_address() with the level parameter, but it's not
obvious to me to name the page levels. So for now I've just left it as
a WARN() if someone supplies it.

It seems like xen still does need this to be defined, because if I
define it without level:

drivers/xen/xenbus/xenbus_client.c: In function ‘xenbus_unmap_ring_vfree_pv’:
drivers/xen/xenbus/xenbus_client.c:760:4: error: too many arguments to function ‘lookup_address’
    lookup_address(addr, &level)).maddr;
    ^~~~~~~~~~~~~~
In file included from ./arch/arm64/include/asm/page.h:37:0,
                 from ./include/linux/mmzone.h:20,
                 from ./include/linux/gfp.h:5,
                 from ./include/linux/mm.h:9,
                 from drivers/xen/xenbus/xenbus_client.c:33:
./arch/arm64/include/asm/pgtable-types.h:67:15: note: declared here
 extern pte_t *lookup_address(unsigned long addr);
               ^~~~~~~~~~~~~~

I've cc-d the xen folks, maybe they can suggest a way to untangle it?
Alternatively, if someone can suggest a good naming scheme for the
page levels, I can just do that.

Cheers,

Tycho


>From 0b3be95873e3e8caa39fa50efc0d06d57fc6eb5e Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@docker.com>
Date: Fri, 8 Sep 2017 10:43:26 -0600
Subject: [PATCH] arm64: add lookup_address()

Similarly to x86, let's add lookup_address() and use it in
kernel_page_present(). We'll use it in the next patch for the
implementation of XPFO as well.

Signed-off-by: Tycho Andersen <tycho@docker.com>
---
 arch/arm64/include/asm/pgtable-types.h |  2 ++
 arch/arm64/mm/pageattr.c               | 47 ++++++++++++++++++++--------------
 include/xen/arm/page.h                 | 10 --------
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
index 345a072b5856..fad3db5a673f 100644
--- a/arch/arm64/include/asm/pgtable-types.h
+++ b/arch/arm64/include/asm/pgtable-types.h
@@ -64,4 +64,6 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 #include <asm-generic/5level-fixup.h>
 #endif
 
+extern pte_t *lookup_address(unsigned long addr, unsigned int *level);
+
 #endif	/* __ASM_PGTABLE_TYPES_H */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index a682a0a2a0fa..437a12485873 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -138,6 +138,32 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_VALID));
 }
 
+pte_t *lookup_address(unsigned long addr, unsigned int *level)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (unlikely(level)) {
+		WARN(1, "level unused on arm64\n");
+		*level = 0;
+	}
+
+	pgd = pgd_offset_k(addr);
+	if (pgd_none(*pgd))
+		return NULL;
+
+	pud = pud_offset(pgd, addr);
+	if (pud_none(*pud))
+		return NULL;
+
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return NULL;
+
+	return pte_offset_kernel(pmd, addr);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
@@ -156,29 +182,12 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
  */
 bool kernel_page_present(struct page *page)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
 	unsigned long addr = (unsigned long)page_address(page);
+	pte_t *pte = lookup_address(addr);
 
-	pgd = pgd_offset_k(addr);
-	if (pgd_none(*pgd))
-		return false;
-
-	pud = pud_offset(pgd, addr);
-	if (pud_none(*pud))
-		return false;
-	if (pud_sect(*pud))
-		return true;
-
-	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (!pte)
 		return false;
-	if (pmd_sect(*pmd))
-		return true;
 
-	pte = pte_offset_kernel(pmd, addr);
 	return pte_valid(*pte);
 }
 #endif /* CONFIG_HIBERNATION */
diff --git a/include/xen/arm/page.h b/include/xen/arm/page.h
index 415dbc6e43fd..6adc2a955340 100644
--- a/include/xen/arm/page.h
+++ b/include/xen/arm/page.h
@@ -84,16 +84,6 @@ static inline xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 	BUG();
 }
 
-/* TODO: this shouldn't be here but it is because the frontend drivers
- * are using it (its rolled in headers) even though we won't hit the code path.
- * So for right now just punt with this.
- */
-static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
-{
-	BUG();
-	return NULL;
-}
-
 extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 				   struct gnttab_map_grant_ref *kmap_ops,
 				   struct page **pages, unsigned int count);
-- 
2.11.0
