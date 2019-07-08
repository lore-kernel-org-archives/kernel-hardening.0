Return-Path: <SRS0=7vO5=VF=lists.openwall.com=kernel-hardening-return-16387-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D04C606BD
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E0CDE2189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kV0yLxy2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0CDE2189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16387-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27861 invoked by uid 550); 8 Jul 2019 17:49:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27756 invoked from network); 8 Jul 2019 17:49:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHzYtWmSFmeH9NbFwqWKy4UztiT2kxra8C1X8yUmUfM=;
        b=kV0yLxy2kpMjOwguVfayi7phtFRYimSGCn/j1wuyKjll3J3KBdoeR84Ly2P7THz2O6
         1/X14UpK0enZCuSRXpOX9dzeN2DoreXYkCymkk0qGXCxmW+9ryMXHuu+eJ6Spe4Nu+kY
         c02Lz1ShzpKhcdhhBTYM7FKjKh8qL2F0m1R9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHzYtWmSFmeH9NbFwqWKy4UztiT2kxra8C1X8yUmUfM=;
        b=gUcyAFV4HFQ9bgopPOG6xmIwi9ZoW/x7zSEWvAlQWq6bgLn+jQlP+GIq/mIlymoMde
         SwNt4J/6vwvDLtzHk0lPeeiVonmi0g/lojZWSkxdWFb6h0zt7w8gg45xciP229gR4KNb
         J3H8EP8AYFR1n9NoaIdbOiveAiCOucM5VqikZzW84693alyURD3LjoohBomKJ7NxqzfT
         jKbcDV2w/ubhQXszXxM5z2WyLtGyhQXo3CTaZ04sVvqLkj0O9JNKaUJjNFRFlJwkQco2
         twr8KISaElL/R0nMAvRmcBLlaaf6Kq+xvktL6pA+2LmkAQpU/9hKAWR9wZJ6ACnlGylY
         DS2A==
X-Gm-Message-State: APjAAAVtzzQOC20ymE19L8NQOR4P5g7d1j81sCAhx3D8rwjr4VQpumr4
	LwjfBi6dFvY8CLYTWf2n5nvgi6HfaSc=
X-Google-Smtp-Source: APXvYqxcOh2L5ETIH15om1Lngn2WXi3piqkN48igLZFnoxb4cW4xxjqv4e9K/9qm1u+nuEor01c/ng==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr27246758pjq.64.1562608170298;
        Mon, 08 Jul 2019 10:49:30 -0700 (PDT)
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Allison Randal <allison@lohutok.net>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 03/11] x86: relocate_kernel - Adapt assembly for PIE support
Date: Mon,  8 Jul 2019 10:48:56 -0700
Message-Id: <20190708174913.123308-4-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
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
2.22.0.410.gd8fdbe21b5-goog

