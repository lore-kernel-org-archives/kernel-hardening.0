Return-Path: <SRS0=GitN=KA=lists.openwall.com=kernel-hardening-return-21235-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43941C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:34:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 80E68613CB
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:34:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80E68613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21235-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13978 invoked by uid 550); 5 May 2021 00:32:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13732 invoked from network); 5 May 2021 00:32:47 -0000
IronPort-SDR: Rk46Kd+AF41cPF1qLpzUPA4+pg3nmELEeLFdCj+RDwZ+b7RGcKm8p6HalgqHTOC6GzkwcOgLjp
 HSZjQw8SDyYA==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="262052480"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="262052480"
IronPort-SDR: Sf+CtbfZdKtb+zNFY2nfkwYozuxaRBjEJydeFa6PYwqzirf3nIfEyhVZCqj7kiI2s4qnKfYwFX
 SbTMvYIpQM4Q==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="429490816"
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
Subject: [PATCH RFC 7/9] x86/mm/cpa: Add perm callbacks to grouped pages
Date: Tue,  4 May 2021 17:30:30 -0700
Message-Id: <20210505003032.489164-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Future patches will need to set permissions on pages in the cache, so
add some callbacks that let gouped page cache callers provide a callback
the component can call when replenishing the cache or free-ing pages via
the shrinker.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/set_memory.h |  8 +++++++-
 arch/x86/mm/pat/set_memory.c      | 26 +++++++++++++++++++++++---
 arch/x86/mm/pgtable.c             |  3 ++-
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index a2bab1626fdd..b370a20681db 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -139,14 +139,20 @@ static inline int clear_mce_nospec(unsigned long pfn)
  */
 #endif
 
+typedef int (*gpc_callback)(struct page*, unsigned int);
+
 struct grouped_page_cache {
 	struct shrinker shrinker;
 	struct list_lru lru;
 	gfp_t gfp;
+	gpc_callback pre_add_to_cache;
+	gpc_callback pre_shrink_free;
 	atomic_t nid_round_robin;
 };
 
-int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp);
+int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp,
+			    gpc_callback pre_add_to_cache,
+			    gpc_callback pre_shrink_free);
 struct page *get_grouped_page(int node, struct grouped_page_cache *gpc);
 void free_grouped_page(struct grouped_page_cache *gpc, struct page *page);
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 29e61afb4a94..6387499c855d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2356,6 +2356,9 @@ static void __dispose_pages(struct grouped_page_cache *gpc, struct list_head *he
 
 		list_del(cur);
 
+		if (gpc->pre_shrink_free)
+			gpc->pre_shrink_free(page, 1);
+
 		__free_pages(page, 0);
 	}
 }
@@ -2413,18 +2416,33 @@ static struct page *__replenish_grouped_pages(struct grouped_page_cache *gpc, in
 	int i;
 
 	page = __alloc_page_order(node, gpc->gfp, HUGETLB_PAGE_ORDER);
-	if (!page)
-		return __alloc_page_order(node, gpc->gfp, 0);
+	if (!page) {
+		page = __alloc_page_order(node, gpc->gfp, 0);
+		if (gpc->pre_add_to_cache)
+			gpc->pre_add_to_cache(page, 1);
+		return page;
+	}
 
 	split_page(page, HUGETLB_PAGE_ORDER);
 
+	/* If fail to prepare to be added, try to clean up and free */
+	if (gpc->pre_add_to_cache && gpc->pre_add_to_cache(page, hpage_cnt)) {
+		if (gpc->pre_shrink_free)
+			gpc->pre_shrink_free(page, hpage_cnt);
+		for (i = 0; i < hpage_cnt; i++)
+			__free_pages(&page[i], 0);
+		return NULL;
+	}
+
 	for (i = 1; i < hpage_cnt; i++)
 		free_grouped_page(gpc, &page[i]);
 
 	return &page[0];
 }
 
-int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp)
+int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp,
+			    gpc_callback pre_add_to_cache,
+			    gpc_callback pre_shrink_free)
 {
 	int err = 0;
 
@@ -2442,6 +2460,8 @@ int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp)
 	if (err)
 		list_lru_destroy(&gpc->lru);
 
+	gpc->pre_add_to_cache = pre_add_to_cache;
+	gpc->pre_shrink_free = pre_shrink_free;
 out:
 	return err;
 }
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 7ccd031d2384..bcef1f458b75 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -926,7 +926,8 @@ int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 #ifdef CONFIG_PKS_PG_TABLES
 static int __init pks_page_init(void)
 {
-	pks_page_en = !init_grouped_page_cache(&gpc_pks, GFP_KERNEL | PGTABLE_HIGHMEM);
+	pks_page_en = !init_grouped_page_cache(&gpc_pks, GFP_KERNEL | PGTABLE_HIGHMEM,
+					       NULL, NULL);
 
 out:
 	return !pks_page_en;
-- 
2.30.2

