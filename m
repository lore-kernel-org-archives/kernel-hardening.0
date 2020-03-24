Return-Path: <SRS0=67l1=5J=lists.openwall.com=kernel-hardening-return-18168-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF086C2BAEE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:39:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 122082073E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:39:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sh+iGzEj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 122082073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18168-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27952 invoked by uid 550); 24 Mar 2020 15:37:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27816 invoked from network); 24 Mar 2020 15:37:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064233;
	bh=hsEWh4lkEZJj8SgPovkPJPa8VD6fGH33UAu8+iJ0v3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh+iGzEj3EFKgcy1Fl5LykZI4hKr6kfQvQMK1zjUj9XrGmYyiVbiPkykjJ8oa7kcv
	 2hyjEQEDZo3ISlrHu8UFUARgGL47vL7/K/5qVrrBL853pxxr3ZjrYkJlSSruOY+cHe
	 Eizev4Onuh72ciaMDl/jVo8Fmg9r5oEA5OiZpPPo=
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
Subject: [RFC PATCH 09/21] list: Remove unnecessary WRITE_ONCE() from hlist_bl_add_before()
Date: Tue, 24 Mar 2020 15:36:31 +0000
Message-Id: <20200324153643.15527-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to use WRITE_ONCE() when inserting into a non-RCU
protected list.

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list_bl.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 1804fdb84dda..c93e7e3aa8fc 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -91,15 +91,15 @@ static inline void hlist_bl_add_before(struct hlist_bl_node *n,
 				       struct hlist_bl_node *next)
 {
 	struct hlist_bl_node **pprev = next->pprev;
+	unsigned long val;
 
 	n->pprev = pprev;
 	n->next = next;
 	next->pprev = &n->next;
 
 	/* pprev may be `first`, so be careful not to lose the lock bit */
-	WRITE_ONCE(*pprev,
-		   (struct hlist_bl_node *)
-			((uintptr_t)n | ((uintptr_t)*pprev & LIST_BL_LOCKMASK)));
+	val = (unsigned long)n | ((unsigned long)*pprev & LIST_BL_LOCKMASK);
+	*pprev = (struct hlist_bl_node *)val;
 }
 
 static inline void hlist_bl_add_behind(struct hlist_bl_node *n,
-- 
2.20.1

