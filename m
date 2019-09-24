Return-Path: <SRS0=as8w=XT=lists.openwall.com=kernel-hardening-return-16921-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7232AC432C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 11:14:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C01852146E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Sep 2019 11:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C01852146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16921-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9398 invoked by uid 550); 24 Sep 2019 11:13:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11581 invoked from network); 24 Sep 2019 11:05:18 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="190989183"
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: pankaj.bharadiya@gmail.com,
	andriy.shevchenko@linux.intel.com,
	kernel-hardening@lists.openwall.com,
	keescook@chromium.org,
	akpm@linux-foundation.org,
	mayhs11saini@gmail.com,
	linux-kernel@vger.kernel.org
Cc: pankaj.laxminarayan.bharadiya@intel.com
Subject: [PATCH 1/5] linux/kernel.h: Add sizeof_member macro
Date: Tue, 24 Sep 2019 16:28:35 +0530
Message-Id: <20190924105839.110713-2-pankaj.laxminarayan.bharadiya@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924105839.110713-1-pankaj.laxminarayan.bharadiya@intel.com>
References: <20190924105839.110713-1-pankaj.laxminarayan.bharadiya@intel.com>

At present we have 3 different macros to calculate the size of a
member of a struct:
  - SIZEOF_FIELD
  - FIELD_SIZEOF
  - sizeof_field

To bring uniformity in entire kernel source tree let's add
sizeof_member macro.

Replace all occurrences of above 3 macro's with sizeof_member in
future patches.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 include/linux/kernel.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4fa360a13c1e..0b80d8bb3978 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -79,6 +79,15 @@
  */
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+/**
+ * sizeof_member - get the size of a struct's member
+ * @T: the target struct
+ * @m: the target struct's member
+ * Return: the size of @m in the struct definition without having a
+ * declared instance of @T.
+ */
+#define sizeof_member(T, m) (sizeof(((T *)0)->m))
+
 /**
  * FIELD_SIZEOF - get the size of a struct's field
  * @t: the target struct
-- 
2.17.1

