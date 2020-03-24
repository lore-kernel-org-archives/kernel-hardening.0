Return-Path: <SRS0=9A4D=5J=lists.openwall.com=kernel-hardening-return-18173-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C32C54EEB
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:40:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A21820789
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qs5aP9nl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A21820789
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18173-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29869 invoked by uid 550); 24 Mar 2020 15:37:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29752 invoked from network); 24 Mar 2020 15:37:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064243;
	bh=IuBp/xaFr7ZgC7YM6R2iieq975HLH8RBRdBRFZApg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qs5aP9nlEw42QteOwo5uHGgWaCB9jXQ+POKR/d5+1ybu9PSL4TbUOBhTqDTALLGm+
	 zk2IaxLeINs+m4fwCpIxAI0jpcdDX9udzRb/aAr3L3Owlzm2ln11r8qHBGIkMB0RjB
	 HOLvPVeAOIdvDyDcFqSQpVTf7Nxa4Gk2tMAUsXHI=
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
Subject: [RFC PATCH 13/21] list: Add integrity checking to hlist_nulls implementation
Date: Tue, 24 Mar 2020 15:36:35 +0000
Message-Id: <20200324153643.15527-14-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the 'hlist_nulls' implementation so that it can optionally
perform integrity checking in a similar fashion to the standard 'list'
code when CONFIG_CHECK_INTEGRITY_LIST=y.

On architectures without a trap value for ILLEGAL_POINTER_VALUE (i.e.
all 32-bit architectures), explicit pointer/poison checks can help to
mitigate UAF vulnerabilities such as the one exploited by "pingpongroot"
(CVE-2015-3636).

Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_nulls.h | 23 +++++++++++++++++++
 lib/list_debug.c           | 47 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index 48f33ae16381..379e097e92b0 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -35,6 +35,23 @@ struct hlist_nulls_node {
 	({ typeof(ptr) ____ptr = (ptr); \
 	   !is_a_nulls(____ptr) ? hlist_nulls_entry(____ptr, type, member) : NULL; \
 	})
+
+#ifdef CONFIG_CHECK_INTEGRITY_LIST
+extern bool __hlist_nulls_add_head_valid(struct hlist_nulls_node *new,
+					 struct hlist_nulls_head *head);
+extern bool __hlist_nulls_del_valid(struct hlist_nulls_node *node);
+#else
+static inline bool __hlist_nulls_add_head_valid(struct hlist_nulls_node *new,
+						struct hlist_nulls_head *head)
+{
+	return true;
+}
+static inline bool __hlist_nulls_del_valid(struct hlist_nulls_node *node)
+{
+	return true;
+}
+#endif
+
 /**
  * ptr_is_a_nulls - Test if a ptr is a nulls
  * @ptr: ptr to be tested
@@ -79,6 +96,9 @@ static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
 {
 	struct hlist_nulls_node *first = h->first;
 
+	if (!__hlist_nulls_add_head_valid(n, h))
+		return;
+
 	n->next = first;
 	n->pprev = &h->first;
 	h->first = n;
@@ -91,6 +111,9 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
 	struct hlist_nulls_node *next = n->next;
 	struct hlist_nulls_node **pprev = n->pprev;
 
+	if (!__hlist_nulls_del_valid(n))
+		return;
+
 	WRITE_ONCE(*pprev, next);
 	if (!is_a_nulls(next))
 		WRITE_ONCE(next->pprev, pprev);
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 03234ebd18c9..b3560de4accc 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -10,6 +10,7 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/rculist.h>
+#include <linux/rculist_nulls.h>
 
 /*
  * Check that the data structures for the list manipulations are reasonably
@@ -139,3 +140,49 @@ bool __hlist_del_valid(struct hlist_node *node)
 	return true;
 }
 EXPORT_SYMBOL(__hlist_del_valid);
+
+bool __hlist_nulls_add_head_valid(struct hlist_nulls_node *new,
+				  struct hlist_nulls_head *head)
+{
+	struct hlist_nulls_node *first = head->first;
+
+	if (CHECK_DATA_CORRUPTION(!is_a_nulls(first) &&
+				  first->pprev != &head->first,
+			"hlist_nulls_add_head corruption: first->pprev should be &head->first (%px), but was %px (first=%px)",
+			&head->first, first->pprev, first) ||
+	    CHECK_DATA_CORRUPTION(new == first,
+			"hlist_nulls_add_head double add: new (%px) == first (%px)",
+			new, first))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL(__hlist_nulls_add_head_valid);
+
+bool __hlist_nulls_del_valid(struct hlist_nulls_node *node)
+{
+	struct hlist_nulls_node *prev, *next = node->next;
+
+	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+			"hlist_nulls_del corruption: %px->next is LIST_POISON1 (%px)\n",
+			node, LIST_POISON1) ||
+	    CHECK_DATA_CORRUPTION(node->pprev == LIST_POISON2,
+			"hlist_nulls_del corruption: %px->pprev is LIST_POISON2 (%px)\n",
+			node, LIST_POISON2))
+		return false;
+
+	BUILD_BUG_ON(offsetof(struct hlist_nulls_node, next) !=
+		     offsetof(struct hlist_nulls_head, first));
+	prev = container_of(node->pprev, struct hlist_nulls_node, next);
+	if (CHECK_DATA_CORRUPTION(prev->next != node,
+			"hlist_nulls_del corruption: prev->next should be %px, but was %px\n",
+			node, prev->next) ||
+	    CHECK_DATA_CORRUPTION(!is_a_nulls(next) &&
+				  next->pprev != &node->next,
+			"hlist_nulls_del corruption: next->pprev should be %px, but was %px\n",
+			&node->next, next->pprev))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL(__hlist_nulls_del_valid);
-- 
2.20.1

