Return-Path: <SRS0=BuzA=DA=lists.openwall.com=kernel-hardening-return-19981-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC445C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 17:41:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B09820665
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 17:41:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B09820665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19981-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16189 invoked by uid 550); 23 Sep 2020 17:41:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16123 invoked from network); 23 Sep 2020 17:41:37 -0000
IronPort-SDR: dtNsfSLAghKj315EVodv8OCbNWGsxOU3Z9HK0uqkqFqGDxuQPb/FAxx2pGNoWljiF8dZnxocop
 ZuRt2f2o9XaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158372520"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="158372520"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: GZk1FRtVMnmSVB61ksssWSFNFU+xjc7kddUpaUMFeMzOTmuJTaNnLCO4Kbb4lhQ2TY/3WZNv/0
 FyFrdXKqoIKw==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="309993326"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: arjan@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	live-patching@vger.kernel.org
Subject: [PATCH v5 10/10] livepatch: only match unique symbols when using fgkaslr
Date: Wed, 23 Sep 2020 10:39:04 -0700
Message-Id: <20200923173905.11219-11-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200923173905.11219-1-kristen@linux.intel.com>
References: <20200923173905.11219-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If any type of function granular randomization is enabled, the sympos
algorithm will fail, as it will be impossible to resolve symbols when
there are duplicates using the previous symbol position.

Override the value of sympos to always be zero if fgkaslr is enabled for
either the core kernel or modules, forcing the algorithm
to require that only unique symbols are allowed to be patched.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 kernel/livepatch/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f76fdb925532..da08e40f2da2 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -170,6 +170,17 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 		kallsyms_on_each_symbol(klp_find_callback, &args);
 	mutex_unlock(&module_mutex);
 
+	/*
+	 * If any type of function granular randomization is enabled, it
+	 * will be impossible to resolve symbols when there are duplicates
+	 * using the previous symbol position (i.e. sympos != 0). Override
+	 * the value of sympos to always be zero in this case. This will
+	 * force the algorithm to require that only unique symbols are
+	 * allowed to be patched.
+	 */
+	if (IS_ENABLED(CONFIG_FG_KASLR) || IS_ENABLED(CONFIG_MODULE_FG_KASLR))
+		sympos = 0;
+
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
 	 * otherwise ensure the symbol position count matches sympos.
-- 
2.20.1

