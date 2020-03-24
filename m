Return-Path: <SRS0=Mobk=5J=lists.openwall.com=kernel-hardening-return-18176-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9A2C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:41:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7FFDD20714
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVd4cx+d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FFDD20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18176-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31944 invoked by uid 550); 24 Mar 2020 15:37:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31834 invoked from network); 24 Mar 2020 15:37:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064257;
	bh=JiMaCGA20Xf9Oah3yv0sde3pP3KYH4qj5+3w+Wbfcto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVd4cx+dxJAQ7qFcgpH/vBm98OPGuI81muj23xFNKay798fqF+Oyuv7qdhlj3AL3W
	 djrHKLzyZIKD/ezP9xZrsYdOYErUiqoZSMpSo6Nam4vjZv8u2bIFmAJSgjrvyYN7PW
	 T7mHC8dL0d/CqZvSfNFImHdPgcnawJOeQs3zxDz4=
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
Subject: [RFC PATCH 19/21] list_bl: Extend integrity checking to cover the same cases as 'hlist'
Date: Tue, 24 Mar 2020 15:36:41 +0000
Message-Id: <20200324153643.15527-20-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The list integrity checks for 'hlist_bl' are missing a number of cases
that are covered by other list implementations (e.g. 'hlist'), such as
validating 'next' and 'pprev' pointers when adding and deleting nodes.

Extend the list_bl integrity checks to bring them up to the same level
as for other list implementations.

Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 lib/list_debug.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 9591fa6c9337..3be50b5c8014 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -7,6 +7,7 @@
 
 #include <linux/export.h>
 #include <linux/list.h>
+#include <linux/list_bl.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/rculist.h>
@@ -190,27 +191,58 @@ EXPORT_SYMBOL(__hlist_nulls_del_valid);
 bool __hlist_bl_add_head_valid(struct hlist_bl_node *new,
 			       struct hlist_bl_head *head)
 {
+	struct hlist_bl_node *first = hlist_bl_first(head);
 	unsigned long hlock = (unsigned long)head->first & LIST_BL_LOCKMASK;
 	unsigned long nlock = (unsigned long)new & LIST_BL_LOCKMASK;
 
-	return !(CHECK_DATA_CORRUPTION(nlock,
+	if (CHECK_DATA_CORRUPTION(nlock,
 			"hlist_bl_add_head: node is locked\n") ||
-		 CHECK_DATA_CORRUPTION(hlock != LIST_BL_LOCKMASK,
-			"hlist_bl_add_head: head is unlocked\n"));
+	    CHECK_DATA_CORRUPTION(hlock != LIST_BL_LOCKMASK,
+			"hlist_bl_add_head: head is unlocked\n"))
+		return false;
+
+	if (CHECK_DATA_CORRUPTION(first && first->pprev != &head->first,
+			"hlist_bl_add_head corruption: first->pprev should be &head->first (%px), but was %px (first=%px)",
+			&head->first, first->pprev, first) ||
+	    CHECK_DATA_CORRUPTION(new == first,
+			"hlist_bl_add_head double add: new (%px) == first (%px)",
+			new, first))
+		return false;
+
+	return true;
 }
 EXPORT_SYMBOL(__hlist_bl_add_head_valid);
 
 bool __hlist_bl_del_valid(struct hlist_bl_node *node)
 {
+	struct hlist_bl_node *prev, *next = node->next;
 	unsigned long nlock = (unsigned long)node & LIST_BL_LOCKMASK;
+	unsigned long pnext;
 
-	return !(CHECK_DATA_CORRUPTION(nlock,
-			"hlist_bl_del_valid: node locked") ||
-		 CHECK_DATA_CORRUPTION(node->next == LIST_POISON1,
+	if (CHECK_DATA_CORRUPTION(nlock,
+			"hlist_bl_del corruption: node is locked") ||
+	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
 			"hlist_bl_del corruption, %px->next is LIST_POISON1 (%px)\n",
 			node, LIST_POISON1) ||
-		 CHECK_DATA_CORRUPTION(node->pprev == LIST_POISON2,
+	    CHECK_DATA_CORRUPTION(node->pprev == LIST_POISON2,
 			"hlist_bl_del corruption, %px->pprev is LIST_POISON2 (%px)\n",
-			node, LIST_POISON2));
+			node, LIST_POISON2))
+		return false;
+
+	BUILD_BUG_ON(offsetof(struct hlist_bl_node, next) !=
+		     offsetof(struct hlist_bl_head, first));
+	prev = container_of(node->pprev, struct hlist_bl_node, next);
+	pnext = (unsigned long)prev->next & ~LIST_BL_LOCKMASK;
+	if (CHECK_DATA_CORRUPTION((unsigned long)next & LIST_BL_LOCKMASK,
+			"hlist_bl_del_corruption: node->next is locked") ||
+	    CHECK_DATA_CORRUPTION((struct hlist_bl_node *)pnext != node,
+			"hlist_bl_del corruption: prev->next should be %px, but was %lx\n",
+			node, pnext) ||
+	    CHECK_DATA_CORRUPTION(next && next->pprev != &node->next,
+			"hlist_bl_del corruption: next->pprev should be %px, but was %px\n",
+			&node->next, next->pprev))
+		return false;
+
+	return true;
 }
 EXPORT_SYMBOL(__hlist_bl_del_valid);
-- 
2.20.1

