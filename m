Return-Path: <SRS0=uYLx=AE=lists.openwall.com=kernel-hardening-return-19070-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3B7C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 17:24:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A716B206EB
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 17:24:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A716B206EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19070-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5629 invoked by uid 550); 23 Jun 2020 17:24:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5598 invoked from network); 23 Jun 2020 17:24:36 -0000
IronPort-SDR: aE9nBKQfWt0w+afabyHIoLaIU6mSV4nezVSVFja/sAE7OdpM2ocl625i7BRDeyTCXpuvPg6VKm
 TDuZ77Sx+LmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="141645557"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="141645557"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: JndrGx72DcHh023YhvHtJsYj9b/pnCDv5I0kFROXSqCIXpHRfj6GkaxpyQhWvirWfHZiJbcJq0
 UPbKLAoeaQcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="423080024"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: arjan@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH v3 01/10] objtool: Do not assume order of parent/child functions
Date: Tue, 23 Jun 2020 10:23:18 -0700
Message-Id: <20200623172327.5701-2-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623172327.5701-1-kristen@linux.intel.com>
References: <20200623172327.5701-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a .cold function is examined prior to it's parent, the link
to the parent/child function can be overwritten when the parent
is examined. Only update pfunc and cfunc if they were previously
nil to prevent this from happening.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/objtool/elf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 84225679f96d..f953d3a15612 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -434,7 +434,13 @@ static int read_symbols(struct elf *elf)
 			size_t pnamelen;
 			if (sym->type != STT_FUNC)
 				continue;
-			sym->pfunc = sym->cfunc = sym;
+
+			if (sym->pfunc == NULL)
+				sym->pfunc = sym;
+
+			if (sym->cfunc == NULL)
+				sym->cfunc = sym;
+
 			coldstr = strstr(sym->name, ".cold");
 			if (!coldstr)
 				continue;
-- 
2.20.1

