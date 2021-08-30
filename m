Return-Path: <SRS0=zltt=NW=lists.openwall.com=kernel-hardening-return-21355-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71944C4320A
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:01:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C222760698
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C222760698
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 6077 invoked by uid 550); 31 Aug 2021 00:00:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5970 invoked from network); 31 Aug 2021 00:00:22 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933703"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933703"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712796"
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
Subject: [RFC PATCH v2 01/19] list: Support getting most recent element in list_lru
Date: Mon, 30 Aug 2021 16:59:09 -0700
Message-Id: <20210830235927.6443-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

In future patches, some functionality will use list_lru that also needs
to keep track of the most recently used element on a node. Since this
information is already contained within list_lru, add a function to get
it so that an additional list is not needed in the caller.

Do not support memcg aware list_lru's since it is not needed by the
intended caller.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 include/linux/list_lru.h | 13 +++++++++++++
 mm/list_lru.c            | 28 ++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 1b5fceb565df..08e07c19fd13 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -103,6 +103,19 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item);
  */
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
+/**
+ * list_lru_get_mru: gets and removes the tail from one of the node lists
+ * @list_lru: the lru pointer
+ * @nid: the node id
+ *
+ * This function removes the most recently added item from one of the node
+ * id specified. This function should not be used if the list_lru is memcg
+ * aware.
+ *
+ * Return value: The element removed
+ */
+struct list_head *list_lru_get_mru(struct list_lru *lru, int nid);
+
 /**
  * list_lru_count_one: return the number of objects currently held by @lru
  * @lru: the lru pointer.
diff --git a/mm/list_lru.c b/mm/list_lru.c
index cd58790d0fb3..c1bec58168e1 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -156,6 +156,34 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item)
 }
 EXPORT_SYMBOL_GPL(list_lru_del);
 
+struct list_head *list_lru_get_mru(struct list_lru *lru, int nid)
+{
+	struct list_lru_node *nlru = &lru->node[nid];
+	struct list_lru_one *l = &nlru->lru;
+	struct list_head *ret;
+
+	/* This function does not attempt to search through the memcg lists */
+	if (list_lru_memcg_aware(lru)) {
+		WARN_ONCE(1, "list_lru: %s not supported on memcg aware list_lrus", __func__);
+		return NULL;
+	}
+
+	spin_lock(&nlru->lock);
+	if (list_empty(&l->list)) {
+		ret = NULL;
+	} else {
+		/* Get tail */
+		ret = l->list.prev;
+		list_del_init(ret);
+
+		l->nr_items--;
+		nlru->nr_items--;
+	}
+	spin_unlock(&nlru->lock);
+
+	return ret;
+}
+
 void list_lru_isolate(struct list_lru_one *list, struct list_head *item)
 {
 	list_del_init(item);
-- 
2.17.1

