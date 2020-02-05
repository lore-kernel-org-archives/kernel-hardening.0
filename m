Return-Path: <SRS0=MBYs=3Z=lists.openwall.com=kernel-hardening-return-17673-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6573C35247
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:40:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2CEF5214AF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CEF5214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17673-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9749 invoked by uid 550); 5 Feb 2020 22:39:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9592 invoked from network); 5 Feb 2020 22:39:51 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092441"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 03/11] x86/boot: Allow a "silent" kaslr random byte fetch
Date: Wed,  5 Feb 2020 14:39:42 -0800
Message-Id: <20200205223950.1212394-4-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

Under earlyprintk, each RNG call produces a debug report line. When
shuffling hundreds of functions, this is not useful information (each
line is identical and tells us nothing new). Instead, allow for a NULL
"purpose" to suppress the debug reporting.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/lib/kaslr.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index a53665116458..2b3eb8c948a3 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -56,11 +56,14 @@ unsigned long kaslr_get_random_long(const char *purpose)
 	unsigned long raw, random = get_boot_seed();
 	bool use_i8254 = true;
 
-	debug_putstr(purpose);
-	debug_putstr(" KASLR using");
+	if (purpose) {
+		debug_putstr(purpose);
+		debug_putstr(" KASLR using");
+	}
 
 	if (has_cpuflag(X86_FEATURE_RDRAND)) {
-		debug_putstr(" RDRAND");
+		if (purpose)
+			debug_putstr(" RDRAND");
 		if (rdrand_long(&raw)) {
 			random ^= raw;
 			use_i8254 = false;
@@ -68,7 +71,8 @@ unsigned long kaslr_get_random_long(const char *purpose)
 	}
 
 	if (has_cpuflag(X86_FEATURE_TSC)) {
-		debug_putstr(" RDTSC");
+		if (purpose)
+			debug_putstr(" RDTSC");
 		raw = rdtsc();
 
 		random ^= raw;
@@ -76,7 +80,8 @@ unsigned long kaslr_get_random_long(const char *purpose)
 	}
 
 	if (use_i8254) {
-		debug_putstr(" i8254");
+		if (purpose)
+			debug_putstr(" i8254");
 		random ^= i8254();
 	}
 
@@ -86,7 +91,8 @@ unsigned long kaslr_get_random_long(const char *purpose)
 	    : "a" (random), "rm" (mix_const));
 	random += raw;
 
-	debug_putstr("...\n");
+	if (purpose)
+		debug_putstr("...\n");
 
 	return random;
 }
-- 
2.24.1

