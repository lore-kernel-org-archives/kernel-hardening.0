Return-Path: <SRS0=pP7r=5J=lists.openwall.com=kernel-hardening-return-18167-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AEBC54FD0
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:39:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED2EC20789
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrgxtSjO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED2EC20789
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18167-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27772 invoked by uid 550); 24 Mar 2020 15:37:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26573 invoked from network); 24 Mar 2020 15:37:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064230;
	bh=kCyXQDXBIacIOUUlvhRJP7/5AucaMFFeuDD1X4ZYGzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrgxtSjO4ZBVgDGYO3uktGvMiyQriu3pRSakNzRBQWUfKNtpnF7oU0G8scgd12GVg
	 A3FpQschv588Hn7cxGwCHRRLAkzViGpNxQzO0scK0UflIVu19AJaokpPr3RpHjk5aH
	 ArP86APbCECHDZzC7+xj2K9YPxpHKirHDN8CeVkc=
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
Subject: [RFC PATCH 08/21] Revert "list: Use WRITE_ONCE() when initializing list_head structures"
Date: Tue, 24 Mar 2020 15:36:30 +0000
Message-Id: <20200324153643.15527-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 2f073848c3cc8aff2655ab7c46d8c0de90cf4e50.

There is no need to use WRITE_ONCE() to initialise a non-RCU 'list_head'.

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index c7331c259792..b86a3f9465d4 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -32,7 +32,7 @@
  */
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
-	WRITE_ONCE(list->next, list);
+	list->next = list;
 	list->prev = list;
 }
 
-- 
2.20.1

