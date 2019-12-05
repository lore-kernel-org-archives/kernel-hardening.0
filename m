Return-Path: <SRS0=ALnr=Z3=lists.openwall.com=kernel-hardening-return-17457-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95896C43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:10:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E78F8206DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GC95mQV5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E78F8206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17457-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27807 invoked by uid 550); 5 Dec 2019 00:10:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27697 invoked from network); 5 Dec 2019 00:10:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3o0S53BeNnZfZd99UaFa744uBy1bdSUJelyk4yNxHs=;
        b=GC95mQV5lCJoxcnVgn7296LK/LZBl3LEgiS0w9Qsv+v/6fbsEouw6kOnJdXsFNqaIi
         ffnEamkViwozMeBKfXxdLm0oEVeqCoZhAOCOuTTXnq8ARzgED4nTN2Lg02dSegV3KT2s
         0M9m5OFAtgEpGoe6zM5fLdwUOKXdYd2RGeaW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3o0S53BeNnZfZd99UaFa744uBy1bdSUJelyk4yNxHs=;
        b=i+H40ceTCOkQEH9qL7HCcu1aUdTbrXZL1zNQPp1TtuxGozvECZuKeVVMXUGJkuLRnE
         P8ZlWU5nylyu8EwRaw8J29fZp8qzTdbqWzRxyi6hGd83OxdDReiUnBkFyT4pwxJbplqZ
         d5EEIhTKk0tg2F8YgIuCT9yPsPN1gYs95sQGtunIv+RYtnNarP8OXn5B9pHnrk8LgMNb
         NHGy+4EjZ8n0Xphjbcl9E7FQYZrjKZbPrrDHqfyc9RXZTM6x2WKYxmgiYVRbsosgXxSP
         tjBckxX/hxjYTnyz772MoozLoRi6Kchk0mc/3AFaV1OCCovYrIGzKBbrpdwwG5YHK1ri
         +ujQ==
X-Gm-Message-State: APjAAAW//V9VeKns8LELPJmI0tRrq1RA25thld4ByGBH6oEftkL6SU8X
	NAGUhN/PzmJ0KAO0xVLAVlYLfNxAWCE=
X-Google-Smtp-Source: APXvYqxZa14mrTVNWUdtWyPFCBpCEtH1XqTiMCdfNPGTL0gp3E35ktiDS7ypx6yJ/1yVmjm1S0Bzdw==
X-Received: by 2002:a62:6381:: with SMTP id x123mr6145520pfb.75.1575504612382;
        Wed, 04 Dec 2019 16:10:12 -0800 (PST)
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
	Peter Zijlstra <peterz@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 02/11] x86: Add macro to get symbol address for PIE support
Date: Wed,  4 Dec 2019 16:09:39 -0800
Message-Id: <20191205000957.112719-3-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new _ASM_MOVABS macro to fetch a symbol address. Replace
"_ASM_MOV $<symbol>, %dst" code construct that are not compatible with
PIE.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index cd339b88d5d4..644bdbf149ee 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -32,6 +32,7 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
-- 
2.24.0.393.g34dc348eaf-goog

