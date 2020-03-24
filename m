Return-Path: <SRS0=Sh76=5J=lists.openwall.com=kernel-hardening-return-18160-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4F7C54EEB
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:37:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF37520788
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooPy8VS1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF37520788
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18160-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24549 invoked by uid 550); 24 Mar 2020 15:37:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24379 invoked from network); 24 Mar 2020 15:37:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064218;
	bh=QY0oPyqlXUd/xyVI4B2QSRbEsJgKQpxLLXC0d7PqKfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooPy8VS1ZB1zf15FBC0Y9g64wzVn6YQ+dSCb44ZRNwzCo3Y3MdaJG47x25mU8c2rV
	 KA4gW51sECJ1dE9b9lujesOi+Vu9RjU7RfxuHIC5wKlLWU3TWAdKfmiaKyAUOI9Tc9
	 Ft68clf/VM0E2M7OrXhDYMW2Zxcmaqp5CMT8m1oo=
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
Subject: [RFC PATCH 03/21] list: Annotate lockless list primitives with data_race()
Date: Tue, 24 Mar 2020 15:36:25 +0000
Message-Id: <20200324153643.15527-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some list predicates can be used locklessly even with the non-RCU list
implementations, since they effectively boil down to a test against
NULL. For example, checking whether or not a list is empty is safe even
in the presence of a concurrent, tearing write to the list head pointer.
Similarly, checking whether or not an hlist node has been hashed is safe
as well.

Annotate these lockless list predicates with data_race() and READ_ONCE()
so that KCSAN and the compiler are aware of what's going on. The writer
side can then avoid having to use WRITE_ONCE() in the non-RCU
implementation.

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list.h       | 10 +++++-----
 include/linux/list_bl.h    |  5 +++--
 include/linux/list_nulls.h |  6 +++---
 include/linux/llist.h      |  2 +-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 4fed5a0f9b77..4d9f5f9ed1a8 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
  */
 static inline int list_empty(const struct list_head *head)
 {
-	return READ_ONCE(head->next) == head;
+	return data_race(READ_ONCE(head->next) == head);
 }
 
 /**
@@ -524,7 +524,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_first_entry_or_null(ptr, type, member) ({ \
 	struct list_head *head__ = (ptr); \
-	struct list_head *pos__ = READ_ONCE(head__->next); \
+	struct list_head *pos__ = data_race(READ_ONCE(head__->next)); \
 	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
 })
 
@@ -772,13 +772,13 @@ static inline void INIT_HLIST_NODE(struct hlist_node *h)
  * hlist_unhashed - Has node been removed from list and reinitialized?
  * @h: Node to be checked
  *
- * Not that not all removal functions will leave a node in unhashed
+ * Note that not all removal functions will leave a node in unhashed
  * state.  For example, hlist_nulls_del_init_rcu() does leave the
  * node in unhashed state, but hlist_nulls_del() does not.
  */
 static inline int hlist_unhashed(const struct hlist_node *h)
 {
-	return !READ_ONCE(h->pprev);
+	return data_race(!READ_ONCE(h->pprev));
 }
 
 /**
@@ -787,7 +787,7 @@ static inline int hlist_unhashed(const struct hlist_node *h)
  */
 static inline int hlist_empty(const struct hlist_head *h)
 {
-	return !READ_ONCE(h->first);
+	return data_race(!READ_ONCE(h->first));
 }
 
 static inline void __hlist_del(struct hlist_node *n)
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ae1b541446c9..1804fdb84dda 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -51,7 +51,7 @@ static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
 
 static inline bool  hlist_bl_unhashed(const struct hlist_bl_node *h)
 {
-	return !h->pprev;
+	return data_race(!READ_ONCE(h->pprev));
 }
 
 static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
@@ -71,7 +71,8 @@ static inline void hlist_bl_set_first(struct hlist_bl_head *h,
 
 static inline bool hlist_bl_empty(const struct hlist_bl_head *h)
 {
-	return !((unsigned long)READ_ONCE(h->first) & ~LIST_BL_LOCKMASK);
+	unsigned long first = data_race((unsigned long)READ_ONCE(h->first));
+	return !(first & ~LIST_BL_LOCKMASK);
 }
 
 static inline void hlist_bl_add_head(struct hlist_bl_node *n,
diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
index 3a9ff01e9a11..fa51a801bf32 100644
--- a/include/linux/list_nulls.h
+++ b/include/linux/list_nulls.h
@@ -60,18 +60,18 @@ static inline unsigned long get_nulls_value(const struct hlist_nulls_node *ptr)
  * hlist_nulls_unhashed - Has node been removed and reinitialized?
  * @h: Node to be checked
  *
- * Not that not all removal functions will leave a node in unhashed state.
+ * Note that not all removal functions will leave a node in unhashed state.
  * For example, hlist_del_init_rcu() leaves the node in unhashed state,
  * but hlist_nulls_del() does not.
  */
 static inline int hlist_nulls_unhashed(const struct hlist_nulls_node *h)
 {
-	return !READ_ONCE(h->pprev);
+	return data_race(!READ_ONCE(h->pprev));
 }
 
 static inline int hlist_nulls_empty(const struct hlist_nulls_head *h)
 {
-	return is_a_nulls(READ_ONCE(h->first));
+	return data_race(is_a_nulls(READ_ONCE(h->first)));
 }
 
 static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
diff --git a/include/linux/llist.h b/include/linux/llist.h
index 2e9c7215882b..c7f042b73899 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -186,7 +186,7 @@ static inline void init_llist_head(struct llist_head *list)
  */
 static inline bool llist_empty(const struct llist_head *head)
 {
-	return READ_ONCE(head->first) == NULL;
+	return data_race(READ_ONCE(head->first) == NULL);
 }
 
 static inline struct llist_node *llist_next(struct llist_node *node)
-- 
2.20.1

