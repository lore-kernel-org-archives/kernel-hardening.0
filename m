Return-Path: <SRS0=m+Q2=NW=lists.openwall.com=kernel-hardening-return-21363-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41364C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:02:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86AE660E98
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 86AE660E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7630 invoked by uid 550); 31 Aug 2021 00:00:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7332 invoked from network); 31 Aug 2021 00:00:31 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933722"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933722"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712902"
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
Subject: [RFC PATCH v2 09/19] x86/mm: Support GFP_ATOMIC in alloc_table_node()
Date: Mon, 30 Aug 2021 16:59:17 -0700
Message-Id: <20210830235927.6443-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

For GFP_ATOMIC in alloc_table/_node(), use get_grouped_page_atomic().

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/mm/pgtable.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ef0b4ce95522..e65d69ad6e0c 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -52,7 +52,10 @@ struct page *alloc_table(gfp_t gfp)
 		return table;
 	}
 
-	table = get_grouped_page(numa_node_id(), &gpc_pks);
+	if (gfp & GFP_ATOMIC)
+		table = get_grouped_page_atomic(numa_node_id(), &gpc_pks);
+	else
+		table = get_grouped_page(numa_node_id(), &gpc_pks);
 	if (!table)
 		return NULL;
 	__SetPageTable(table);
-- 
2.17.1

