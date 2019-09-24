Return-Path: <SRS0=e8yX=XT=lists.openwall.com=kernel-hardening-return-16912-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4F8C432C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 11:10:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6B01C214D9
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 11:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B01C214D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16912-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20358 invoked by uid 550); 24 Sep 2019 11:09:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7593 invoked from network); 24 Sep 2019 08:21:15 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203330039"
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: kernel-hardening@lists.openwall.com,
	keescook@chromium.org,
	akpm@linux-foundation.org,
	mayhs11saini@gmail.com
Cc: pankaj.laxminarayan.bharadiya@intel.com
Subject: [PATCH 4/5] linux/kernel.h: Remove FIELD_SIZEOF macro
Date: Tue, 24 Sep 2019 13:44:38 +0530
Message-Id: <20190924081439.15219-5-pankaj.laxminarayan.bharadiya@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924081439.15219-1-pankaj.laxminarayan.bharadiya@intel.com>
References: <20190924081439.15219-1-pankaj.laxminarayan.bharadiya@intel.com>

Now we have sizeof_member macro to find the size of a member of a struct.

FIELD_SIZEOF macro is not getting used any more hence remove it.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 include/linux/kernel.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 0b80d8bb3978..064497792c70 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -88,15 +88,6 @@
  */
 #define sizeof_member(T, m) (sizeof(((T *)0)->m))
 
-/**
- * FIELD_SIZEOF - get the size of a struct's field
- * @t: the target struct
- * @f: the target struct's field
- * Return: the size of @f in the struct definition without having a
- * declared instance of @t.
- */
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-
 #define typeof_member(T, m)	typeof(((T*)0)->m)
 
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
-- 
2.17.1

