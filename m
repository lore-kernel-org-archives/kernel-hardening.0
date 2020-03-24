Return-Path: <SRS0=w1sa=5J=lists.openwall.com=kernel-hardening-return-18164-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E003AC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:38:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DD7C720714
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ys7Ayynm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD7C720714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18164-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26350 invoked by uid 550); 24 Mar 2020 15:37:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26253 invoked from network); 24 Mar 2020 15:37:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064238;
	bh=rRxomFuzqpc0/xpLIhH3/5sfh0TjOrvjFASDLuXyvfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys7AyynmnUcgYKVmvnXr0OrxatQGZU8Eoitd65gNYV06+F4P7l8gxir+or+WPTyLm
	 T9uwVr0wElWEae6T7tGPaXQoAwi6Nby7+vbJGodgldfMQqWk+LZoMoaTSGpuYEeQer
	 dqxgIvImpT8n+kCFkXqxrZeWgyhmLt/dwMGqjzwg=
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
Subject: [RFC PATCH 11/21] list: Add integrity checking to hlist implementation
Date: Tue, 24 Mar 2020 15:36:33 +0000
Message-Id: <20200324153643.15527-12-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the 'hlist' implementation so that it can optionally perform
integrity checking in a similar fashion to the standard 'list' code
when CONFIG_CHECK_INTEGRITY_LIST=y.

Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list.h    | 41 ++++++++++++++++++++-
 include/linux/rculist.h | 80 ++++++++++++++++++++++-------------------
 lib/list_debug.c        | 79 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 162 insertions(+), 38 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 2bef081afa69..96ede36a5614 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -41,6 +41,13 @@ extern bool __list_add_valid(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next);
 extern bool __list_del_entry_valid(struct list_head *entry);
+extern bool __hlist_add_before_valid(struct hlist_node *new,
+				     struct hlist_node *next);
+extern bool __hlist_add_behind_valid(struct hlist_node *new,
+				     struct hlist_node *prev);
+extern bool __hlist_add_head_valid(struct hlist_node *new,
+				   struct hlist_head *head);
+extern bool __hlist_del_valid(struct hlist_node *node);
 #else
 static inline bool __list_add_valid(struct list_head *new,
 				struct list_head *prev,
@@ -52,6 +59,25 @@ static inline bool __list_del_entry_valid(struct list_head *entry)
 {
 	return true;
 }
+static inline bool __hlist_add_before_valid(struct hlist_node *new,
+					    struct hlist_node *next)
+{
+	return true;
+}
+static inline bool __hlist_add_behind_valid(struct hlist_node *new,
+					    struct hlist_node *prev)
+{
+	return true;
+}
+static inline bool __hlist_add_head_valid(struct hlist_node *new,
+					  struct hlist_head *head)
+{
+	return true;
+}
+static inline bool __hlist_del_valid(struct hlist_node *node)
+{
+	return true;
+}
 #endif
 
 /*
@@ -796,6 +822,9 @@ static inline void __hlist_del(struct hlist_node *n)
 	struct hlist_node *next = n->next;
 	struct hlist_node **pprev = n->pprev;
 
+	if (!__hlist_del_valid(n))
+		return;
+
 	WRITE_ONCE(*pprev, next);
 	if (next)
 		WRITE_ONCE(next->pprev, pprev);
@@ -840,6 +869,10 @@ static inline void hlist_del_init(struct hlist_node *n)
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
+
+	if (!__hlist_add_head_valid(n, h))
+		return;
+
 	n->next = first;
 	if (first)
 		first->pprev = &n->next;
@@ -855,6 +888,9 @@ static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 static inline void hlist_add_before(struct hlist_node *n,
 				    struct hlist_node *next)
 {
+	if (!__hlist_add_before_valid(n, next))
+		return;
+
 	n->pprev = next->pprev;
 	n->next = next;
 	next->pprev = &n->next;
@@ -862,13 +898,16 @@ static inline void hlist_add_before(struct hlist_node *n,
 }
 
 /**
- * hlist_add_behing - add a new entry after the one specified
+ * hlist_add_behind - add a new entry after the one specified
  * @n: new entry to be added
  * @prev: hlist node to add it after, which must be non-NULL
  */
 static inline void hlist_add_behind(struct hlist_node *n,
 				    struct hlist_node *prev)
 {
+	if (!__hlist_add_behind_valid(n, prev))
+		return;
+
 	n->next = prev->next;
 	prev->next = n;
 	n->pprev = &prev->next;
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 9f313e4999fe..6f3eb7758fd8 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -537,6 +537,9 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 {
 	struct hlist_node *first = h->first;
 
+	if (!__hlist_add_head_valid(n, h))
+		return;
+
 	n->next = first;
 	WRITE_ONCE(n->pprev, &h->first);
 	rcu_assign_pointer(hlist_first_rcu(h), n);
@@ -544,43 +547,6 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 		WRITE_ONCE(first->pprev, &n->next);
 }
 
-/**
- * hlist_add_tail_rcu
- * @n: the element to add to the hash list.
- * @h: the list to add to.
- *
- * Description:
- * Adds the specified element to the specified hlist,
- * while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.  Regardless of the type of CPU, the
- * list-traversal primitive must be guarded by rcu_read_lock().
- */
-static inline void hlist_add_tail_rcu(struct hlist_node *n,
-				      struct hlist_head *h)
-{
-	struct hlist_node *i, *last = NULL;
-
-	/* Note: write side code, so rcu accessors are not needed. */
-	for (i = h->first; i; i = i->next)
-		last = i;
-
-	if (last) {
-		n->next = last->next;
-		WRITE_ONCE(n->pprev, &last->next);
-		rcu_assign_pointer(hlist_next_rcu(last), n);
-	} else {
-		hlist_add_head_rcu(n, h);
-	}
-}
-
 /**
  * hlist_add_before_rcu
  * @n: the new element to add to the hash list.
@@ -602,6 +568,9 @@ static inline void hlist_add_tail_rcu(struct hlist_node *n,
 static inline void hlist_add_before_rcu(struct hlist_node *n,
 					struct hlist_node *next)
 {
+	if (!__hlist_add_before_valid(n, next))
+		return;
+
 	WRITE_ONCE(n->pprev, next->pprev);
 	n->next = next;
 	rcu_assign_pointer(hlist_pprev_rcu(n), n);
@@ -629,6 +598,9 @@ static inline void hlist_add_before_rcu(struct hlist_node *n,
 static inline void hlist_add_behind_rcu(struct hlist_node *n,
 					struct hlist_node *prev)
 {
+	if (!__hlist_add_behind_valid(n, prev))
+		return;
+
 	n->next = prev->next;
 	WRITE_ONCE(n->pprev, &prev->next);
 	rcu_assign_pointer(hlist_next_rcu(prev), n);
@@ -636,6 +608,40 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
 		WRITE_ONCE(n->next->pprev, &n->next);
 }
 
+/**
+ * hlist_add_tail_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_add_tail_rcu(struct hlist_node *n,
+				      struct hlist_head *h)
+{
+	struct hlist_node *i, *last = NULL;
+
+	/* Note: write side code, so rcu accessors are not needed. */
+	for (i = h->first; i; i = i->next)
+		last = i;
+
+	if (last)
+		hlist_add_behind_rcu(n, last);
+	else
+		hlist_add_head_rcu(n, h);
+}
+
 #define __hlist_for_each_rcu(pos, head)				\
 	for (pos = rcu_dereference(hlist_first_rcu(head));	\
 	     pos;						\
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 57bf685af2ef..03234ebd18c9 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -60,3 +60,82 @@ bool __list_del_entry_valid(struct list_head *entry)
 
 }
 EXPORT_SYMBOL(__list_del_entry_valid);
+
+static bool __hlist_add_valid(struct hlist_node *new, struct hlist_node *prev,
+			      struct hlist_node *next)
+{
+	if (CHECK_DATA_CORRUPTION(next && next->pprev != &prev->next,
+			"hlist_add corruption: next->pprev should be &prev->next (%px), but was %px (next=%px)\n",
+			&prev->next, next->pprev, next) ||
+	    CHECK_DATA_CORRUPTION(prev->next != next,
+			"hlist_add corruption: prev->next should be next (%px), but was %px (prev=%px)\n",
+			next, prev->next, prev) ||
+	    CHECK_DATA_CORRUPTION(new == prev || new == next,
+			"hlist_add double add: new=%px, prev=%px, next=%px\n",
+			new, prev, next))
+		return false;
+
+	return true;
+}
+
+bool __hlist_add_before_valid(struct hlist_node *new, struct hlist_node *next)
+{
+	struct hlist_node *prev;
+
+	prev = container_of(next->pprev, struct hlist_node, next);
+	return __hlist_add_valid(new, prev, next);
+}
+EXPORT_SYMBOL(__hlist_add_before_valid);
+
+bool __hlist_add_behind_valid(struct hlist_node *new, struct hlist_node *prev)
+{
+	return __hlist_add_valid(new, prev, prev->next);
+}
+EXPORT_SYMBOL(__hlist_add_behind_valid);
+
+bool __hlist_add_head_valid(struct hlist_node *new, struct hlist_head *head)
+{
+	struct hlist_node *first = head->first;
+
+	if (CHECK_DATA_CORRUPTION(first && first->pprev != &head->first,
+			"hlist_add_head corruption: first->pprev should be &head->first (%px), but was %px (first=%px)",
+			&head->first, first->pprev, first) ||
+	    CHECK_DATA_CORRUPTION(new == first,
+			"hlist_add_head double add: new (%px) == first (%px)",
+			new, first))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL(__hlist_add_head_valid);
+
+bool __hlist_del_valid(struct hlist_node *node)
+{
+	struct hlist_node *prev, *next = node->next;
+
+	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+			"hlist_del corruption: %px->next is LIST_POISON1 (%px)\n",
+			node, LIST_POISON1) ||
+	    CHECK_DATA_CORRUPTION(node->pprev == LIST_POISON2,
+			"hlist_del corruption: %px->pprev is LIST_POISON2 (%px)\n",
+			node, LIST_POISON2))
+		return false;
+
+	/*
+	 * If we want to validate the previous node's forward linkage,
+	 * then we must be able to treat the head like a normal node.
+	 */
+	BUILD_BUG_ON(offsetof(struct hlist_node, next) !=
+		     offsetof(struct hlist_head, first));
+	prev = container_of(node->pprev, struct hlist_node, next);
+	if (CHECK_DATA_CORRUPTION(prev->next != node,
+			"hlist_del corruption: prev->next should be %px, but was %px\n",
+			node, prev->next) ||
+	    CHECK_DATA_CORRUPTION(next && next->pprev != &node->next,
+			"hlist_del corruption: next->pprev should be %px, but was %px\n",
+			&node->next, next->pprev))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL(__hlist_del_valid);
-- 
2.20.1

