Return-Path: <SRS0=srFn=U3=lists.openwall.com=kernel-hardening-return-16319-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F37C4321A
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Jun 2019 11:56:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3F2A82086D
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Jun 2019 11:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F2A82086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16319-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19466 invoked by uid 550); 28 Jun 2019 11:55:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18380 invoked from network); 28 Jun 2019 11:55:58 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,427,1557212400"; 
   d="scan'208";a="314115039"
From: Nitin Gote <nitin.r.gote@intel.com>
To: keescook@chromium.org,
	jannh@google.com
Cc: kernel-hardening@lists.openwall.com,
	Nitin Gote <nitin.r.gote@intel.com>
Subject: [PATCH] checkpatch: Added warnings in favor of strscpy().
Date: Fri, 28 Jun 2019 17:25:48 +0530
Message-Id: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
X-Mailer: git-send-email 2.7.4

Added warnings in checkpatch.pl script to :

1. Deprecate strcpy() in favor of strscpy().
2. Deprecate strlcpy() in favor of strscpy().
3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 342c7c7..bb0fa11 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -595,6 +595,9 @@ our %deprecated_apis = (
 	"rcu_barrier_sched"			=> "rcu_barrier",
 	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
 	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
+	"strcpy"				=> "strscpy",
+	"strlcpy"				=> "strscpy",
+	"strncpy"				=> "strscpy or strscpy_pad",
 );

 #Create a search pattern for all these strings to speed up a loop below
--
2.7.4

