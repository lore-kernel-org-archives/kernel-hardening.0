From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: [RFC PATCH v8 06/14] xpfo: add primitives for mapping underlying memory
Date: Wed, 13 Feb 2019 17:01:29 -0700
Message-Id: <c285cc243176ae5fdd22f316dc8b118c1c153434.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1550088114.git.khalid.aziz@oracle.com>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
To: juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com
Cc: Tycho Andersen <tycho@docker.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, peterz@infradead.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Tycho Andersen <tycho@docker.com>

In some cases (on arm64 DMA and data cache flushes) we may have unmapped
the underlying pages needed for something via XPFO. Here are some
primitives useful for ensuring the underlying memory is mapped/unmapped in
the face of xpfo.

Signed-off-by: Tycho Andersen <tycho@docker.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
---
 include/linux/xpfo.h | 22 ++++++++++++++++++++++
 mm/xpfo.c            | 30 ++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/xpfo.h b/include/linux/xpfo.h
index cba37ffb09b1..1ae05756344d 100644
--- a/include/linux/xpfo.h
+++ b/include/linux/xpfo.h
@@ -38,6 +38,15 @@ void xpfo_free_pages(struct page *page, int order);
 
 bool xpfo_page_is_unmapped(struct page *page);
 
+#define XPFO_NUM_PAGES(addr, size) \
+	(PFN_UP((unsigned long) (addr) + (size)) - \
+		PFN_DOWN((unsigned long) (addr)))
+
+void xpfo_temp_map(const void *addr, size_t size, void **mapping,
+		   size_t mapping_len);
+void xpfo_temp_unmap(const void *addr, size_t size, void **mapping,
+		     size_t mapping_len);
+
 #else /* !CONFIG_XPFO */
 
 static inline void xpfo_kmap(void *kaddr, struct page *page) { }
@@ -47,6 +56,19 @@ static inline void xpfo_free_pages(struct page *page, int order) { }
 
 static inline bool xpfo_page_is_unmapped(struct page *page) { return false; }
 
+#define XPFO_NUM_PAGES(addr, size) 0
+
+static inline void xpfo_temp_map(const void *addr, size_t size, void **mapping,
+				 size_t mapping_len)
+{
+}
+
+static inline void xpfo_temp_unmap(const void *addr, size_t size,
+				   void **mapping, size_t mapping_len)
+{
+}
+
+
 #endif /* CONFIG_XPFO */
 
 #endif /* _LINUX_XPFO_H */
diff --git a/mm/xpfo.c b/mm/xpfo.c
index 67884736bebe..92ca6d1baf06 100644
--- a/mm/xpfo.c
+++ b/mm/xpfo.c
@@ -14,6 +14,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/page_ext.h>
@@ -236,3 +237,32 @@ bool xpfo_page_is_unmapped(struct page *page)
 	return test_bit(XPFO_PAGE_UNMAPPED, &xpfo->flags);
 }
 EXPORT_SYMBOL(xpfo_page_is_unmapped);
+
+void xpfo_temp_map(const void *addr, size_t size, void **mapping,
+		   size_t mapping_len)
+{
+	struct page *page = virt_to_page(addr);
+	int i, num_pages = mapping_len / sizeof(mapping[0]);
+
+	memset(mapping, 0, mapping_len);
+
+	for (i = 0; i < num_pages; i++) {
+		if (page_to_virt(page + i) >= addr + size)
+			break;
+
+		if (xpfo_page_is_unmapped(page + i))
+			mapping[i] = kmap_atomic(page + i);
+	}
+}
+EXPORT_SYMBOL(xpfo_temp_map);
+
+void xpfo_temp_unmap(const void *addr, size_t size, void **mapping,
+		     size_t mapping_len)
+{
+	int i, num_pages = mapping_len / sizeof(mapping[0]);
+
+	for (i = 0; i < num_pages; i++)
+		if (mapping[i])
+			kunmap_atomic(mapping[i]);
+}
+EXPORT_SYMBOL(xpfo_temp_unmap);
-- 
2.17.1
