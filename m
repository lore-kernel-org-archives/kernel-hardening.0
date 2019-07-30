Return-Path: <SRS0=zo5Q=V3=lists.openwall.com=kernel-hardening-return-16646-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F6BC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E73B120693
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OjB3x2X1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E73B120693
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16646-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28283 invoked by uid 550); 30 Jul 2019 19:13:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28099 invoked from network); 30 Jul 2019 19:13:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0NzhAJDW6f6zv48MhA58X21t6ZEAVN81pjWGMonLUQ=;
        b=OjB3x2X1IjXnZyRT0y4ci0Z+ZmocMVw3jXB+231CIxuQ+Vi+vnoHGPII6xu43tIQCC
         izbGp42+Tr1lJM8CDyrUkPzRGeM0gleYKorJYw2ygKdUkeHux+isppWd00bdLc2rwBsV
         7BjDP8/gm1rSJVMA09kWAibgoOJb+bvzAzmtA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0NzhAJDW6f6zv48MhA58X21t6ZEAVN81pjWGMonLUQ=;
        b=BiUDFtQE3Pp3HkY9IlFlXUh6ybWKfe0bsWwG/u4o0ZsOjdCGm/TukdTBzPl0psbRjm
         GJXlF4ulstsJGpirpaWPKKCeIpnW3h1PwhzfmtrKSrZYmwLf0lZ/YBxM8x/+gntlL1EP
         BLYfVuXxvP390Ylz+Xd84/zVfz+ggRebTL5M4JPm7m/OEqRdFRG94UaV9KLqA6qDydCB
         9nUUPnCYynfxemIQSRNuOtq91ZpEo7Xm8Xpj1t4AhVfZMT8hrOxNQsdaoy1IBi3XQ2/1
         rY0ZWF3azbt55XRhjoQiChKWk2IX5MhkGB5Y4tfZADbrA1ldFF+1xHFMxmG9rHR8vJFf
         WIsA==
X-Gm-Message-State: APjAAAVJ5Wb5gCCoqOIEprvMk7tgVPn89blVl0Gf7LB6DymXUv+I6FSH
	gx11O9eB42vZ6kSb5W4+v4CSFquORMo=
X-Google-Smtp-Source: APXvYqwsIu5EjDisGZPc1G7mJNiIJ7XnbgYepkvqZhs11fZLulhf+xJkltnPFGWfc108tM55QvLPhQ==
X-Received: by 2002:a17:902:2ae7:: with SMTP id j94mr116539349plb.270.1564513994552;
        Tue, 30 Jul 2019 12:13:14 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Allison Randal <allison@lohutok.net>,
	Alexios Zavras <alexios.zavras@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 03/11] x86: relocate_kernel - Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:47 -0700
Message-Id: <20190730191303.206365-4-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only absolute references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/relocate_kernel_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index c51ccff5cd01..c72889b09840 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -206,7 +206,7 @@ identity_mapped:
 	movq	%rax, %cr3
 	lea	PAGE_SIZE(%r8), %rsp
 	call	swap_pages
-	movq	$virtual_mapped, %rax
+	movabsq	$virtual_mapped, %rax
 	pushq	%rax
 	ret
 
-- 
2.22.0.770.g0f2c4a37fd-goog

