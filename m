Return-Path: <SRS0=XjeQ=NW=lists.openwall.com=kernel-hardening-return-21351-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6E1C4320E
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:00:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 797D960E98
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:00:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 797D960E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5854 invoked by uid 550); 31 Aug 2021 00:00:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5810 invoked from network); 31 Aug 2021 00:00:17 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933720"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933720"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712885"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	keescook@chromium.org,
	shakeelb@google.com,
	vbabka@suse.cz,
	rppt@kernel.org
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 08/19] x86/mm/cpa: Add get_grouped_page_atomic()
Date: Mon, 30 Aug 2021 16:59:16 -0700
Message-Id: <20210830235927.6443-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

For PKS tables, some page table allocations are made with GFP_ATOMIC,
which up to now has not been supported.

Grouped pages may often have pages in the cache, which can be retrieved
without sleeping, however if the cache is empty, it will need try to
replenish from the normal page allocator. Just passing GFP_ATOMIC in
addition to the configure GFP is not ideal because it may try to grab a
whole huge page size page which will stress the atomic reserves.

So instead create new logic that will only try to allocate a single page
and convert it.

Expose this atomic logic in a new function get_grouped_page_atomic(),
instead of allowing a flag to be passed in. This is so it doesn't look
like any GFP flag can get passed in and result in behavior like normal
allocations.

In the case of PKS tables conversion of the page allocated atomically,
set_memory() calls cannot usually be made in atomic context because
pages may need to be allocated, but PKS tables has its own reserve of
direct map tables so pages can be converted to PKS protected in atomic
context.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/set_memory.h |  1 +
 arch/x86/mm/pat/set_memory.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index eaac7e3e08bf..e0516651698a 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -153,6 +153,7 @@ int init_grouped_page_cache(struct grouped_page_cache *gpc, gfp_t gfp,
 			    gpc_callback pre_add_to_cache,
 			    gpc_callback pre_shrink_free);
 struct page *get_grouped_page(int node, struct grouped_page_cache *gpc);
+struct page *get_grouped_page_atomic(int node, struct grouped_page_cache *gpc);
 void free_grouped_page(struct grouped_page_cache *gpc, struct page *page);
 
 #endif /* _ASM_X86_SET_MEMORY_H */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 72a465e37648..c51792a797cb 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2496,6 +2496,32 @@ struct page *get_grouped_page(int node, struct grouped_page_cache *gpc)
 	return __replenish_grouped_pages(gpc, node);
 }
 
+struct page *get_grouped_page_atomic(int node, struct grouped_page_cache *gpc)
+{
+	struct page *page;
+
+	if (in_interrupt()) {
+		pr_warn_once("grouped pages: Cannot allocate grouped page in interrupt");
+		return NULL;
+	}
+
+	/* First see if there are any grouped pages already in the cache */
+	page = __remove_first_page(gpc, node);
+
+	/*
+	 * If there wasn't one in the cache, allocate only a single page to not
+	 * stress the reserves.
+	 */
+	if (!page)
+		page = __alloc_page_order(node, gpc->gfp | GFP_ATOMIC, 0);
+
+	/* Convert the single page if configured for this cache */
+	if (!page || __try_convert(gpc, page, 1))
+		return NULL;
+
+	return page;
+}
+
 void free_grouped_page(struct grouped_page_cache *gpc, struct page *page)
 {
 	INIT_LIST_HEAD(&page->lru);
-- 
2.17.1

