Return-Path: <SRS0=GV6b=KA=lists.openwall.com=kernel-hardening-return-21229-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA244C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:33:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D4014613CB
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4014613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21229-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13776 invoked by uid 550); 5 May 2021 00:32:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13651 invoked from network); 5 May 2021 00:32:46 -0000
IronPort-SDR: LpkCpfs3h+pOD7xS4Gxumt0nn9xFe/+oVoLZTIwYKC3z0ZynqIe1PbTs4uG57zvrKQzbyNpzUI
 WIzCdMj+cIZw==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="198192798"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="198192798"
IronPort-SDR: Qqa/foM0GySgOOlFhGHAxlMC+r64sCbCcfkREouyUfA0fkoq5KrlRm0fs13S9pF2I66o4T9VQ4
 ApIzAmJWkXrA==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="429490773"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: ira.weiny@intel.com,
	rppt@kernel.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Date: Tue,  4 May 2021 17:30:26 -0700
Message-Id: <20210505003032.489164-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For x86, setting memory permissions on the direct map results in fracturing
large pages. Direct map fracturing can be reduced by locating pages that
will have their permissions set close together.

Create a simple page cache that allocates pages from huge page size
blocks. Don't guarantee that a page will come from a huge page grouping,
instead fallback to non-grouped pages to fulfill the allocation if
needed. Also, register a shrinker such that the system can ask for the
pages back if needed. Since this is only needed when there is a direct
map, compile it out on highmem systems.

Free pages in the cache are kept track of in per-node list inside a
list_lru. NUMA_NO_NODE requests are serviced by checking each per-node
list in a round robin fashion. If pages are requested for a certain node
but the cache is empty for that node, a whole additional huge page size
page is allocated.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/set_memory.h |  14 +++
 arch/x86/mm/pat/set_memory.c      | 151 ++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4352f08bfbb5..b63f09cc282a 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -4,6 +4,9 @@
 
 #include <asm/page.h>
 #include <asm-generic/set_memory.h>
+#include <linux/gfp.h>
+#include <linux/list_lru.h>
+#include <linux/shrinker.h>
 
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
@@ -135,4 +138,15 @@ static inline int clear_mce_nospec(unsigned long pfn)
  */
 #endif
 
+struct grouped_page_cache {
+	struct shrinker shrinker;
+	struct list_lru lru;
+	gfp_t gfp;
+	atomic_t nid_round_robin;
+};
+
+int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp);
+struct page *get_grouped_page(int node, struct grouped_page_cache *gpc);
+void free_grouped_page(struct grouped_page_cache *gpc, struct page *page);
+
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 16f878c26667..6877ef66793b 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2306,6 +2306,157 @@ int __init kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
 	return retval;
 }
 
+#ifndef HIGHMEM
+static struct page *__alloc_page_order(int node, gfp_t gfp_mask, int order)
+{
+	if (node == NUMA_NO_NODE)
+		return alloc_pages(gfp_mask, order);
+
+	return alloc_pages_node(node, gfp_mask, order);
+}
+
+static struct grouped_page_cache *__get_gpc_from_sc(struct shrinker *shrinker)
+{
+	return container_of(shrinker, struct grouped_page_cache, shrinker);
+}
+
+static unsigned long grouped_shrink_count(struct shrinker *shrinker,
+					  struct shrink_control *sc)
+{
+	struct grouped_page_cache *gpc = __get_gpc_from_sc(shrinker);
+	unsigned long page_cnt = list_lru_shrink_count(&gpc->lru, sc);
+
+	return page_cnt ? page_cnt : SHRINK_EMPTY;
+}
+
+static enum lru_status grouped_isolate(struct list_head *item,
+				       struct list_lru_one *list,
+				       spinlock_t *lock, void *cb_arg)
+{
+	struct list_head *dispose = cb_arg;
+
+	list_lru_isolate_move(list, item, dispose);
+
+	return LRU_REMOVED;
+}
+
+static void __dispose_pages(struct grouped_page_cache *gpc, struct list_head *head)
+{
+	struct list_head *cur, *next;
+
+	list_for_each_safe(cur, next, head) {
+		struct page *page = list_entry(head, struct page, lru);
+
+		list_del(cur);
+
+		__free_pages(page, 0);
+	}
+}
+
+static unsigned long grouped_shrink_scan(struct shrinker *shrinker,
+					 struct shrink_control *sc)
+{
+	struct grouped_page_cache *gpc = __get_gpc_from_sc(shrinker);
+	unsigned long isolated;
+	LIST_HEAD(freeable);
+
+	if (!(sc->gfp_mask & gpc->gfp))
+		return SHRINK_STOP;
+
+	isolated = list_lru_shrink_walk(&gpc->lru, sc, grouped_isolate,
+					&freeable);
+	__dispose_pages(gpc, &freeable);
+
+	/* Every item walked gets isolated */
+	sc->nr_scanned += isolated;
+
+	return isolated;
+}
+
+static struct page *__remove_first_page(struct grouped_page_cache *gpc, int node)
+{
+	unsigned int start_nid, i;
+	struct list_head *head;
+
+	if (node != NUMA_NO_NODE) {
+		head = list_lru_get_mru(&gpc->lru, node);
+		if (head)
+			return list_entry(head, struct page, lru);
+		return NULL;
+	}
+
+	/* If NUMA_NO_NODE, search the nodes in round robin for a page */
+	start_nid = (unsigned int)atomic_fetch_inc(&gpc->nid_round_robin) % nr_node_ids;
+	for (i = 0; i < nr_node_ids; i++) {
+		int cur_nid = (start_nid + i) % nr_node_ids;
+
+		head = list_lru_get_mru(&gpc->lru, cur_nid);
+		if (head)
+			return list_entry(head, struct page, lru);
+	}
+
+	return NULL;
+}
+
+/* Get and add some new pages to the cache to be used by VM_GROUP_PAGES */
+static struct page *__replenish_grouped_pages(struct grouped_page_cache *gpc, int node)
+{
+	const unsigned int hpage_cnt = HPAGE_SIZE >> PAGE_SHIFT;
+	struct page *page;
+	int i;
+
+	page = __alloc_page_order(node, gpc->gfp, HUGETLB_PAGE_ORDER);
+	if (!page)
+		return __alloc_page_order(node, gpc->gfp, 0);
+
+	split_page(page, HUGETLB_PAGE_ORDER);
+
+	for (i = 1; i < hpage_cnt; i++)
+		free_grouped_page(gpc, &page[i]);
+
+	return &page[0];
+}
+
+int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp)
+{
+	int err = 0;
+
+	memset(gpc, 0, sizeof(struct grouped_page_cache));
+
+	if (list_lru_init(&gpc->lru))
+		goto out;
+
+	gpc->shrinker.count_objects = grouped_shrink_count;
+	gpc->shrinker.scan_objects = grouped_shrink_scan;
+	gpc->shrinker.seeks = DEFAULT_SEEKS;
+	gpc->shrinker.flags = SHRINKER_NUMA_AWARE;
+
+	err = register_shrinker(&gpc->shrinker);
+	if (err)
+		list_lru_destroy(&gpc->lru);
+
+out:
+	return err;
+}
+
+struct page *get_grouped_page(int node, struct grouped_page_cache *gpc)
+{
+	struct page *page;
+
+	page = __remove_first_page(gpc, node);
+
+	if (page)
+		return page;
+
+	return __replenish_grouped_pages(gpc, node);
+}
+
+void free_grouped_page(struct grouped_page_cache *gpc, struct page *page)
+{
+	INIT_LIST_HEAD(&page->lru);
+	list_lru_add_node(&gpc->lru, &page->lru, page_to_nid(page));
+}
+#endif /* !HIGHMEM */
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
-- 
2.30.2

