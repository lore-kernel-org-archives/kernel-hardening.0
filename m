Return-Path: <SRS0=kxBF=5J=lists.openwall.com=kernel-hardening-return-18175-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92CDC2BAEE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:41:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13DF220714
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FC4e4Kub"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13DF220714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18175-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31773 invoked by uid 550); 24 Mar 2020 15:37:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30663 invoked from network); 24 Mar 2020 15:37:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064255;
	bh=ieuN1NJTq+9heb9k5hJc1KkJB7zqBNtgCKe1hqkqObc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC4e4KubugDTpB2dTINNE4ZzmVzWoJ3zBo41BOOCCa60v3W4JTxEUmucW0IieqI4l
	 wZBVBpH6WdYqZJFU8YUpcCq6bjh0Celqc9ggRZW4zOyKk4kEabDDXGKXOAm9utQybw
	 ouCNAWXeOF7ZvMTnDx5Qm+mOiQ5cZ+619xCWIA6k=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 18/21] list_bl: Move integrity checking out of line
Date: Tue, 24 Mar 2020 15:36:40 +0000
Message-Id: <20200324153643.15527-19-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding full integrity checking to 'hlist_bl', move
the checks out of line before they become more bloated. At the same,
swap the argument order for __hlist_bl_add_head_valid() so that it
follows the same convention as __hlist_add_head_valid().

Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_bl.h    | 34 ++++++----------------------------
 include/linux/rculist_bl.h |  2 +-
 lib/list_debug.c           | 28 ++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 0839c4f43e6d..dd74043ebae6 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -33,34 +33,12 @@ struct hlist_bl_node {
 };
 
 #ifdef CONFIG_CHECK_INTEGRITY_LIST
-static inline bool __hlist_bl_add_head_valid(struct hlist_bl_head *h,
-					     struct hlist_bl_node *n)
-{
-	unsigned long hlock = (unsigned long)h->first & LIST_BL_LOCKMASK;
-	unsigned long nlock = (unsigned long)n & LIST_BL_LOCKMASK;
-
-	return !(CHECK_DATA_CORRUPTION(nlock,
-			"hlist_bl_add_head: node is locked\n") ||
-		 CHECK_DATA_CORRUPTION(hlock != LIST_BL_LOCKMASK,
-			"hlist_bl_add_head: head is unlocked\n"));
-}
-
-static inline bool __hlist_bl_del_valid(struct hlist_bl_node *n)
-{
-	unsigned long nlock = (unsigned long)n & LIST_BL_LOCKMASK;
-
-	return !(CHECK_DATA_CORRUPTION(nlock,
-			"hlist_bl_del_valid: node locked") ||
-		 CHECK_DATA_CORRUPTION(n->next == LIST_POISON1,
-			"hlist_bl_del corruption, %px->next is LIST_POISON1 (%px)\n",
-			n, LIST_POISON1) ||
-		 CHECK_DATA_CORRUPTION(n->pprev == LIST_POISON2,
-			"hlist_bl_del corruption, %px->pprev is LIST_POISON2 (%px)\n",
-			n, LIST_POISON2));
-}
+extern bool __hlist_bl_add_head_valid(struct hlist_bl_node *n,
+				      struct hlist_bl_head *h);
+extern bool __hlist_bl_del_valid(struct hlist_bl_node *node);
 #else
-static inline bool __hlist_bl_add_head_valid(struct hlist_bl_head *h,
-					     struct hlist_bl_node *n)
+static inline bool __hlist_bl_add_head_valid(struct hlist_bl_node *n,
+					     struct hlist_bl_head *h)
 {
 	return true;
 }
@@ -103,7 +81,7 @@ static inline void hlist_bl_add_head(struct hlist_bl_node *n,
 {
 	struct hlist_bl_node *first = hlist_bl_first(h);
 
-	if (!__hlist_bl_add_head_valid(h, n))
+	if (!__hlist_bl_add_head_valid(n, h))
 		return;
 
 	n->next = first;
diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
index 553ce3cde104..9356e7283ff0 100644
--- a/include/linux/rculist_bl.h
+++ b/include/linux/rculist_bl.h
@@ -63,7 +63,7 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
 {
 	struct hlist_bl_node *first;
 
-	if (!__hlist_bl_add_head_valid(h, n))
+	if (!__hlist_bl_add_head_valid(n, h))
 		return;
 
 	/* don't need hlist_bl_first_rcu because we're under lock */
diff --git a/lib/list_debug.c b/lib/list_debug.c
index b3560de4accc..9591fa6c9337 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -186,3 +186,31 @@ bool __hlist_nulls_del_valid(struct hlist_nulls_node *node)
 	return true;
 }
 EXPORT_SYMBOL(__hlist_nulls_del_valid);
+
+bool __hlist_bl_add_head_valid(struct hlist_bl_node *new,
+			       struct hlist_bl_head *head)
+{
+	unsigned long hlock = (unsigned long)head->first & LIST_BL_LOCKMASK;
+	unsigned long nlock = (unsigned long)new & LIST_BL_LOCKMASK;
+
+	return !(CHECK_DATA_CORRUPTION(nlock,
+			"hlist_bl_add_head: node is locked\n") ||
+		 CHECK_DATA_CORRUPTION(hlock != LIST_BL_LOCKMASK,
+			"hlist_bl_add_head: head is unlocked\n"));
+}
+EXPORT_SYMBOL(__hlist_bl_add_head_valid);
+
+bool __hlist_bl_del_valid(struct hlist_bl_node *node)
+{
+	unsigned long nlock = (unsigned long)node & LIST_BL_LOCKMASK;
+
+	return !(CHECK_DATA_CORRUPTION(nlock,
+			"hlist_bl_del_valid: node locked") ||
+		 CHECK_DATA_CORRUPTION(node->next == LIST_POISON1,
+			"hlist_bl_del corruption, %px->next is LIST_POISON1 (%px)\n",
+			node, LIST_POISON1) ||
+		 CHECK_DATA_CORRUPTION(node->pprev == LIST_POISON2,
+			"hlist_bl_del corruption, %px->pprev is LIST_POISON2 (%px)\n",
+			node, LIST_POISON2));
+}
+EXPORT_SYMBOL(__hlist_bl_del_valid);
-- 
2.20.1

