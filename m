Return-Path: <SRS0=jjIL=Z3=lists.openwall.com=kernel-hardening-return-17464-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E25C43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:12:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 972DE206DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="An6EKBfY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 972DE206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17464-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29772 invoked by uid 550); 5 Dec 2019 00:10:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28621 invoked from network); 5 Dec 2019 00:10:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CyqJWPK5gXiDkj7pmzxZFEFTPFB7rpHSJzIvAweXZ1A=;
        b=An6EKBfYvskuNlarkZw8jmwWOHMO23mba1ZDMioIp6NWW+BYGhM0azn1Tj5l0aSL3l
         F84yQ1vmqcaKNJ8NVSbhIx2+fPjAVurVTHG7H+k9UgRIebIWnlVc93mV69v1aWfsM7R9
         PDaE08TiD3RYOGNFDjF8MurzqNd0oyu9Pza+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyqJWPK5gXiDkj7pmzxZFEFTPFB7rpHSJzIvAweXZ1A=;
        b=SdygN9rJkueVaAOghO0jzdG0MAmdDx69PIoalbyd4RmLzRtpSs+XKtmnFR/8y9DANk
         /Oj+m8qcU0Ya0rxjET2B2+a83qEEf16S3GUv00OAthj5L63L/IMylQlPbe+WSlqFQga+
         6UkbnoQgpgorc8hXdI8dye9Z5NzYOW5WUe2rjFh6h1Y+XcX/WfB0WGWGN0aVhJ55kdT2
         wjtyIVG1A/+lotkHleCDx5q4OgtEUmn8Gi48DABfYUPdAhvanMPSB+2VflOjlslvAXHy
         FKUkWabafZhD2O7q5Y5BNSgzaLDaKUNCIHwaA3vKG8k7ID36cWrnklfvGKtrSmHadOQw
         6H/w==
X-Gm-Message-State: APjAAAVckOYZDXgqc+FL/xGbbFCogEfy4v8ZHJ0bqPKNxX9RlCr4+oVi
	Lz76sIREpK+d1LImurpcHN6Gva5M/YM=
X-Google-Smtp-Source: APXvYqyJHl10vg4Yuv8v57HFoPF0TX9oP8AEzxMSwkMkq2tj2R127UTZp0aTC99o/y/3ahYnP/dATA==
X-Received: by 2002:a17:902:9a97:: with SMTP id w23mr6163243plp.79.1575504623796;
        Wed, 04 Dec 2019 16:10:23 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 09/11] x86/power/64: Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:46 -0800
Message-Id: <20191205000957.112719-10-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/power/hibernate_asm_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 7918b8415f13..977b8ae85045 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -23,7 +23,7 @@
 #include <asm/frame.h>
 
 SYM_FUNC_START(swsusp_arch_suspend)
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -116,7 +116,7 @@ SYM_FUNC_START(restore_registers)
 	movq	%rax, %cr4;  # turn PGE back on
 
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	pt_regs_sp(%rax), %rsp
 	movq	pt_regs_bp(%rax), %rbp
 	movq	pt_regs_si(%rax), %rsi
-- 
2.24.0.393.g34dc348eaf-goog

