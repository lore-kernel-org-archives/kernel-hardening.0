From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [RFC PATCH v8 04/14] swiotlb: Map the buffer if it was unmapped by XPFO
Date: Wed, 13 Feb 2019 17:01:27 -0700
Message-Id: <b595ffb3231dfef3c6b6c896a8e1cba0e838978c.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
To: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Juerg Haefliger <juerg.haefliger@canonical.com>

v6: * guard against lookup_xpfo() returning NULL

CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Signed-off-by: Tycho Andersen <tycho@docker.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/xpfo.h |  4 ++++
 kernel/dma/swiotlb.c |  3 ++-
 mm/xpfo.c            | 15 +++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/xpfo.h b/include/linux/xpfo.h
index b15234745fb4..cba37ffb09b1 100644
--- a/include/linux/xpfo.h
+++ b/include/linux/xpfo.h
@@ -36,6 +36,8 @@ void xpfo_kunmap(void *kaddr, struct page *page);
 void xpfo_alloc_pages(struct page *page, int order, gfp_t gfp);
 void xpfo_free_pages(struct page *page, int order);
 
+bool xpfo_page_is_unmapped(struct page *page);
+
 #else /* !CONFIG_XPFO */
 
 static inline void xpfo_kmap(void *kaddr, struct page *page) { }
@@ -43,6 +45,8 @@ static inline void xpfo_kunmap(void *kaddr, struct page *page) { }
 static inline void xpfo_alloc_pages(struct page *page, int order, gfp_t gfp) { }
 static inline void xpfo_free_pages(struct page *page, int order) { }
 
+static inline bool xpfo_page_is_unmapped(struct page *page) { return false; }
+
 #endif /* CONFIG_XPFO */
 
 #endif /* _LINUX_XPFO_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 045930e32c0e..820a54b57491 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -396,8 +396,9 @@ static void swiotlb_bounce(phys_addr_t orig_addr, phys_addr_t tlb_addr,
 {
 	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	struct page *page = pfn_to_page(pfn);
 
-	if (PageHighMem(pfn_to_page(pfn))) {
+	if (PageHighMem(page) || xpfo_page_is_unmapped(page)) {
 		/* The buffer does not have a mapping.  Map it in and copy */
 		unsigned int offset = orig_addr & ~PAGE_MASK;
 		char *buffer;
diff --git a/mm/xpfo.c b/mm/xpfo.c
index 24b33d3c20cb..67884736bebe 100644
--- a/mm/xpfo.c
+++ b/mm/xpfo.c
@@ -221,3 +221,18 @@ void xpfo_kunmap(void *kaddr, struct page *page)
 	spin_unlock(&xpfo->maplock);
 }
 EXPORT_SYMBOL(xpfo_kunmap);
+
+bool xpfo_page_is_unmapped(struct page *page)
+{
+	struct xpfo *xpfo;
+
+	if (!static_branch_unlikely(&xpfo_inited))
+		return false;
+
+	xpfo = lookup_xpfo(page);
+	if (unlikely(!xpfo) && !xpfo->inited)
+		return false;
+
+	return test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
+}
+EXPORT_SYMBOL(xpfo_page_is_unmapped);
-- 
2.17.1
