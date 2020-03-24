Return-Path: <SRS0=Sy0+=5J=lists.openwall.com=kernel-hardening-return-18174-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C1BC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:41:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5034B20714
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ySrv9lDo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5034B20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18174-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30215 invoked by uid 550); 24 Mar 2020 15:37:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30136 invoked from network); 24 Mar 2020 15:37:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064247;
	bh=ePC0KcHwaeG27HJefCMue14nRgQlh3QPrh4rpDBAm+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySrv9lDoir/ctvuoDCC59S/NRJYM3saGztZut9HosJtQrud9DmO2rEQYmy4m2Y3Uf
	 8/4lOkxE55lxjrkjgXa/MPyc+LGVBrLqSSxuS/aQ1xgM1o6Jpqe5meS7XeiNPV9her
	 ptPCVWPMtE3vx0DYOli+qNSrP71EXJv5Re6PsHZA=
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
Subject: [RFC PATCH 15/21] list_bl: Use CHECK_DATA_CORRUPTION instead of custom BUG_ON() wrapper
Date: Tue, 24 Mar 2020 15:36:37 +0000
Message-Id: <20200324153643.15527-16-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CHECK_DATA_CORRUPTION() allows detected data corruption to result
consistently in either a BUG() or a WARN() depending on
CONFIG_BUG_ON_DATA_CORRUPTION.

Use CHECK_DATA_CORRUPTION() to report list_bl integrity checking failures,
rather than a custom wrapper around BUG_ON().

Cc: Kees Cook <keescook@chromium.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_bl.h    | 55 +++++++++++++++++++++++++-------------
 include/linux/rculist_bl.h | 17 ++++--------
 2 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 9f8e29142324..f48d8acb15b4 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -24,13 +24,6 @@
 #define LIST_BL_LOCKMASK	0UL
 #endif
 
-#ifdef CONFIG_CHECK_INTEGRITY_LIST
-#define LIST_BL_BUG_ON(x) BUG_ON(x)
-#else
-#define LIST_BL_BUG_ON(x)
-#endif
-
-
 struct hlist_bl_head {
 	struct hlist_bl_node *first;
 };
@@ -38,6 +31,37 @@ struct hlist_bl_head {
 struct hlist_bl_node {
 	struct hlist_bl_node *next, **pprev;
 };
+
+#ifdef CONFIG_CHECK_INTEGRITY_LIST
+static inline bool __hlist_bl_add_head_valid(struct hlist_bl_head *h,
+					     struct hlist_bl_node *n)
+{
+	unsigned long hlock = (unsigned long)h->first & LIST_BL_LOCKMASK;
+	unsigned long nlock = (unsigned long)n & LIST_BL_LOCKMASK;
+
+	return !(CHECK_DATA_CORRUPTION(nlock,
+			"hlist_bl_add_head: node is locked\n") ||
+		 CHECK_DATA_CORRUPTION(hlock != LIST_BL_LOCKMASK,
+			"hlist_bl_add_head: head is unlocked\n"));
+}
+
+static inline bool __hlist_bl_del_valid(struct hlist_bl_node *n)
+{
+	unsigned long nlock = (unsigned long)n & LIST_BL_LOCKMASK;
+	return !CHECK_DATA_CORRUPTION(nlock, "hlist_bl_del_valid: node locked");
+}
+#else
+static inline bool __hlist_bl_add_head_valid(struct hlist_bl_head *h,
+					     struct hlist_bl_node *n)
+{
+	return true;
+}
+static inline bool __hlist_bl_del_valid(struct hlist_bl_node *n)
+{
+	return true;
+}
+#endif
+
 #define INIT_HLIST_BL_HEAD(ptr) \
 	((ptr)->first = NULL)
 
@@ -60,15 +84,6 @@ static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
 		((unsigned long)h->first & ~LIST_BL_LOCKMASK);
 }
 
-static inline void hlist_bl_set_first(struct hlist_bl_head *h,
-					struct hlist_bl_node *n)
-{
-	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
-	LIST_BL_BUG_ON(((unsigned long)h->first & LIST_BL_LOCKMASK) !=
-							LIST_BL_LOCKMASK);
-	h->first = (struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK);
-}
-
 static inline bool hlist_bl_empty(const struct hlist_bl_head *h)
 {
 	unsigned long first = data_race((unsigned long)READ_ONCE(h->first));
@@ -80,11 +95,14 @@ static inline void hlist_bl_add_head(struct hlist_bl_node *n,
 {
 	struct hlist_bl_node *first = hlist_bl_first(h);
 
+	if (!__hlist_bl_add_head_valid(h, n))
+		return;
+
 	n->next = first;
 	if (first)
 		first->pprev = &n->next;
 	n->pprev = &h->first;
-	hlist_bl_set_first(h, n);
+	h->first = (struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK);
 }
 
 static inline void hlist_bl_add_before(struct hlist_bl_node *n,
@@ -118,7 +136,8 @@ static inline void __hlist_bl_del(struct hlist_bl_node *n)
 	struct hlist_bl_node *next = n->next;
 	struct hlist_bl_node **pprev = n->pprev;
 
-	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
+	if (!__hlist_bl_del_valid(n))
+		return;
 
 	/* pprev may be `first`, so be careful not to lose the lock bit */
 	WRITE_ONCE(*pprev,
diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
index 0b952d06eb0b..553ce3cde104 100644
--- a/include/linux/rculist_bl.h
+++ b/include/linux/rculist_bl.h
@@ -8,16 +8,6 @@
 #include <linux/list_bl.h>
 #include <linux/rcupdate.h>
 
-static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
-					struct hlist_bl_node *n)
-{
-	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
-	LIST_BL_BUG_ON(((unsigned long)h->first & LIST_BL_LOCKMASK) !=
-							LIST_BL_LOCKMASK);
-	rcu_assign_pointer(h->first,
-		(struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
-}
-
 static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
 {
 	return (struct hlist_bl_node *)
@@ -73,6 +63,9 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
 {
 	struct hlist_bl_node *first;
 
+	if (!__hlist_bl_add_head_valid(h, n))
+		return;
+
 	/* don't need hlist_bl_first_rcu because we're under lock */
 	first = hlist_bl_first(h);
 
@@ -81,8 +74,8 @@ static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
 		first->pprev = &n->next;
 	n->pprev = &h->first;
 
-	/* need _rcu because we can have concurrent lock free readers */
-	hlist_bl_set_first_rcu(h, n);
+	rcu_assign_pointer(h->first,
+		(struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
 }
 /**
  * hlist_bl_for_each_entry_rcu - iterate over rcu list of given type
-- 
2.20.1

