Return-Path: <SRS0=TlPZ=V3=lists.openwall.com=kernel-hardening-return-16649-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E122C433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7D92C20693
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m0iQTXUN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D92C20693
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16649-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28444 invoked by uid 550); 30 Jul 2019 19:13:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28380 invoked from network); 30 Jul 2019 19:13:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qa0vdqU/e4QPHFVnoNOrEozPMumAGtkoZQ9IP0jYnkg=;
        b=m0iQTXUNy9Ivxk8S8rx6UuqUrCNk/lmb9ABT6tX720KuMWsD28POJqIHBW6/ecVDNQ
         1wbWq2OFtsCV/gCMaCWhi/N9ivwFCLXmf8NoCB80kLVtvh5oGNjC8TdkekyoWfngXYpv
         g4yOAr38UwABJuJh4u7l9MRi4cavnGZbRi9Oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qa0vdqU/e4QPHFVnoNOrEozPMumAGtkoZQ9IP0jYnkg=;
        b=FXbcu3BZNRl6gYWYsaxwgddr2VwA6Yho2bFXQzmzyi8i84ygTU/+vyKkZENYV9BtVi
         ejjN+xRHm7bCo8zgZbnmaqN7c2nJJkRRlQirBFSpx2NiYiy7Wwpj8KgeHh+z5U/wB/vf
         GJU54ohurtxUadJaoaD2dW5TXpJE41iXhUYEIDSzFQ81Tj5/pw0b8rsFgYwhXPN94Kgi
         ECI+Ytc1wetNDkIJU34hNpYWlQa1YFmmSJIzvwGAGx8WcZoXrZ8pVwxb9kzOjMpLPSei
         zNGOy0KtzFuAauaK5s+9QCjep0fsXV5AHV7AW/Pyk/SpJ8Cx3CSzmVwK2JAWm14ZO6CO
         543w==
X-Gm-Message-State: APjAAAW8EPsWd72xKmgNieDlZFdUv6GQNrkN1M39uwvrYt84yzNH+Nkv
	q9pOw8gowwBo6eHw0RjVLAVM9bozQwE=
X-Google-Smtp-Source: APXvYqw4FhQAyLlzTXXeXnWi4AdlBXSr5qODFDIUZbZ8fdBVPq/Zyh+2sg3WQmjXFcNGWYaH8U26QA==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr56057575pjq.64.1564513999646;
        Tue, 30 Jul 2019 12:13:19 -0700 (PDT)
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
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <len.brown@intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 06/11] x86/CPU: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:50 -0700
Message-Id: <20190730191303.206365-7-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/processor.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6e0a3b43d027..bf333d62889e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -713,11 +713,13 @@ static inline void sync_core(void)
 		"pushfq\n\t"
 		"mov %%cs, %0\n\t"
 		"pushq %q0\n\t"
-		"pushq $1f\n\t"
+		"leaq 1f(%%rip), %q0\n\t"
+		"pushq %q0\n\t"
 		"iretq\n\t"
 		UNWIND_HINT_RESTORE
 		"1:"
-		: "=&r" (tmp), ASM_CALL_CONSTRAINT : : "cc", "memory");
+		: "=&r" (tmp), ASM_CALL_CONSTRAINT
+		: : "cc", "memory");
 #endif
 }
 
-- 
2.22.0.770.g0f2c4a37fd-goog

