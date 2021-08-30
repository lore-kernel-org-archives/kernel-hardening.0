Return-Path: <SRS0=wiy8=NW=lists.openwall.com=kernel-hardening-return-21354-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55460C43214
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:01:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A7A1F60E98
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A7A1F60E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 6010 invoked by uid 550); 31 Aug 2021 00:00:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5940 invoked from network); 31 Aug 2021 00:00:21 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933705"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933705"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712805"
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
Subject: [RFC PATCH v2 02/19] list: Support list head not in object for list_lru
Date: Mon, 30 Aug 2021 16:59:10 -0700
Message-Id: <20210830235927.6443-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

In future patches, there will be a need to keep track of objects with
list_lru where the list_head is not in the object (will be in struct
page). Since list_lru automatically determines the node id from the
list_head, this will fail when using struct page.

So create a new function in list_lru, list_lru_add_node(), that allows
the node id of the item to be passed in. Otherwise it behaves exactly
like list_lru_add().

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 include/linux/list_lru.h | 13 +++++++++++++
 mm/list_lru.c            | 10 ++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 08e07c19fd13..42c22322058b 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -90,6 +90,19 @@ void memcg_drain_all_list_lrus(int src_idx, struct mem_cgroup *dst_memcg);
  */
 bool list_lru_add(struct list_lru *lru, struct list_head *item);
 
+/**
+ * list_lru_add_node: add an element to the lru list's tail
+ * @list_lru: the lru pointer
+ * @item: the item to be added.
+ * @nid: the node id of the item
+ *
+ * Like list_lru_add, but takes the node id as parameter instead of
+ * calculating it from the list_head passed in.
+ *
+ * Return value: true if the list was updated, false otherwise
+ */
+bool list_lru_add_node(struct list_lru *lru, struct list_head *item, int nid);
+
 /**
  * list_lru_del: delete an element to the lru list
  * @list_lru: the lru pointer
diff --git a/mm/list_lru.c b/mm/list_lru.c
index c1bec58168e1..f35f11ada8a1 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -112,9 +112,8 @@ list_lru_from_kmem(struct list_lru_node *nlru, void *ptr,
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
-bool list_lru_add(struct list_lru *lru, struct list_head *item)
+bool list_lru_add_node(struct list_lru *lru, struct list_head *item, int nid)
 {
-	int nid = page_to_nid(virt_to_page(item));
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct mem_cgroup *memcg;
 	struct list_lru_one *l;
@@ -134,6 +133,13 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item)
 	spin_unlock(&nlru->lock);
 	return false;
 }
+
+bool list_lru_add(struct list_lru *lru, struct list_head *item)
+{
+	int nid = page_to_nid(virt_to_page(item));
+
+	return list_lru_add_node(lru, item, nid);
+}
 EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_del(struct list_lru *lru, struct list_head *item)
-- 
2.17.1

