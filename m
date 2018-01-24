From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Wed, 24 Jan 2018 19:56:28 +0200
Message-ID: <20180124175631.22925-4-igor.stoppa@huawei.com>
In-Reply-To: <20180124175631.22925-1-igor.stoppa@huawei.com>
References: <20180124175631.22925-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH 3/6] struct page: add field for vm_struct
To: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org
Cc: cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

When a page is used for virtual memory, it is often necessary to obtian
a handler to the corresponding vm_struct, which refers to the virtually
continuous area generated when invoking vmalloc.

The struct page has a "mapping" field, which can be re-used, to store a
pointer to the parent area. This will avoid more expensive searches.

As example, the function find_vm_area is reimplemented, to take advantage
of the newly introduced field.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
---
 include/linux/mm_types.h |  1 +
 mm/vmalloc.c             | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index fd1af6b..c3a4825 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -84,6 +84,7 @@ struct page {
 		void *s_mem;			/* slab first object */
 		atomic_t compound_mapcount;	/* first tail page */
 		/* page_deferred_list().next	 -- second tail page */
+		struct vm_struct *area;
 	};
 
 	/* Second double word */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6739420..44c5dfc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1466,13 +1466,16 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
  */
 struct vm_struct *find_vm_area(const void *addr)
 {
-	struct vmap_area *va;
+	struct page *page;
 
-	va = find_vmap_area((unsigned long)addr);
-	if (va && va->flags & VM_VM_AREA)
-		return va->vm;
+	if (unlikely(!is_vmalloc_addr(addr)))
+		return NULL;
 
-	return NULL;
+	page = vmalloc_to_page(addr);
+	if (unlikely(!page))
+		return NULL;
+
+	return page->area;
 }
 
 /**
@@ -1536,6 +1539,7 @@ static void __vunmap(const void *addr, int deallocate_pages)
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
+			page->area = NULL;
 			__free_pages(page, 0);
 		}
 
@@ -1744,6 +1748,7 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			const void *caller)
 {
 	struct vm_struct *area;
+	unsigned int page_counter;
 	void *addr;
 	unsigned long real_size = size;
 
@@ -1769,6 +1774,9 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 
 	kmemleak_vmalloc(area, size, gfp_mask);
 
+	for (page_counter = 0; page_counter < area->nr_pages; page_counter++)
+		area->pages[page_counter]->area = area;
+
 	return addr;
 
 fail:
-- 
2.9.3
