Return-Path: <SRS0=duED=NW=lists.openwall.com=kernel-hardening-return-21358-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D69C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:01:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2496560E98
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2496560E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7339 invoked by uid 550); 31 Aug 2021 00:00:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6126 invoked from network); 31 Aug 2021 00:00:26 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933709"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933709"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712816"
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
Subject: [RFC PATCH v2 04/19] mm: Explicitly zero page table lock ptr
Date: Mon, 30 Aug 2021 16:59:12 -0700
Message-Id: <20210830235927.6443-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

In ptlock_init() there is a VM_BUG_ON_PAGE() check on the page table lock
pointer. Explicitly zero the lock in ptlock_free() so a page table lock
can be re-initialized without triggering the BUG_ON().

It appears this doesn't normally trigger because the private field
shares the same space in struct page as ptl and page tables always
return to the buddy allocator before being re-initialized as new page
tables. When the page returns to the buddy allocator, private gets
used to store the page order, so it inadvertently clears ptl as well.
In future patches, pages will get re-initialized as page tables without
returning to the buddy allocator so this is needed.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 mm/memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index 25fc46e87214..e6d630463c7f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5465,5 +5465,6 @@ bool ptlock_alloc(struct page *page)
 void ptlock_free(struct page *page)
 {
 	kmem_cache_free(page_ptl_cachep, page->ptl);
+	page->ptl = 0;
 }
 #endif
-- 
2.17.1

