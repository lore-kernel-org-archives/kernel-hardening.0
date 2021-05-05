Return-Path: <SRS0=JLJZ=KA=lists.openwall.com=kernel-hardening-return-21227-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAE2C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:33:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E5E8A613CB
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 00:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5E8A613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21227-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13716 invoked by uid 550); 5 May 2021 00:32:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13461 invoked from network); 5 May 2021 00:32:42 -0000
IronPort-SDR: e8WU+TGARfi7IqhR0kdhZYIFs3BNN9Ll+ElkMaNmL12auwEfWx/O2mplHa64Ioynif8uKoQryS
 oPd7UE0qOTKA==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="262052476"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="262052476"
IronPort-SDR: ip0J5D3qBZcnDAFgdM7HQHdxWI8/FjbpAGZI0G2d4bIwRZLNN6s4O1irKqEf+BRPr25p+FQq1v
 G9Ah1barEj0Q==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="429490787"
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
Subject: [PATCH RFC 4/9] mm: Explicitly zero page table lock ptr
Date: Tue,  4 May 2021 17:30:27 -0700
Message-Id: <20210505003032.489164-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 5efa07fb6cdc..130f8c1e380a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5225,5 +5225,6 @@ bool ptlock_alloc(struct page *page)
 void ptlock_free(struct page *page)
 {
 	kmem_cache_free(page_ptl_cachep, page->ptl);
+	page->ptl = 0;
 }
 #endif
-- 
2.30.2

