Return-Path: <SRS0=nXi4=V3=lists.openwall.com=kernel-hardening-return-16652-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15089C0650F
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:15:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5DFC72064A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hk0Bac0a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DFC72064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16652-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28611 invoked by uid 550); 30 Jul 2019 19:13:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28556 invoked from network); 30 Jul 2019 19:13:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCFi9VKfA/regOH6ME0h7V2OJPrhlZ4OE3HFuZl/Mr4=;
        b=hk0Bac0aiWQasaW/82OqlXyeS+zRRbeGWMF9iYoYCCjmyk5hKfhbErMAfoM104i7Br
         TdpwZFEl9pU+frxz1cazoSP6L1BNAC+8jncLJVwuFEsDynqzb3OP7vNis0EU/ikkPW8m
         /LeN2upB3IFugt/kUzhj6IfHluZI3rXDFFkRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCFi9VKfA/regOH6ME0h7V2OJPrhlZ4OE3HFuZl/Mr4=;
        b=oo5Ltfg+7HJL2pSc54dulT8YTyo5Ikmbe8sNR2xs0GilclheBKax2nkMCuWIdmKUQM
         i4zxjCaeoncxR9RoCX7OM6LHiIauwIQuIcvtM5fRsKFNDYk6AjV2TMDZ0cdNHLsXWhD9
         etwq+9QpLEAQSTyVEKThXfTrWkhO4rACpMsGGdrfU3Axoa+cAY0qM8Mc97ELj6M9lSWX
         q7/RJDM6qfItEVPrHVMShN1t8HP3PxizM7k/eVj6lzfPspNy7Jn1DFvVK3BvvB8bF1NT
         353YBp6F8iM5dBdZQbLWIElw80VnUPxQmaEeqtLd96HrqldtZwqCmMHM6fv2Dv/Q3cY0
         +Lgg==
X-Gm-Message-State: APjAAAXOLtdxnXT1DXRpQKfEGzuGEvfuQr9lNXVl4D/g7cld3lRMSETk
	9i1tWpLHmq7zPZxYqvxNoyiIioZFmA4=
X-Google-Smtp-Source: APXvYqyTpbQ7f3xITrwKbyFWcIPqfOysYAwjkN9vIf84u+eLPDg/LwjNFZLDtMcMgZUrWQ+iiuxmZg==
X-Received: by 2002:a65:57ca:: with SMTP id q10mr113599135pgr.52.1564514003446;
        Tue, 30 Jul 2019 12:13:23 -0700 (PDT)
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
Subject: [PATCH v9 09/11] x86/power/64: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:53 -0700
Message-Id: <20190730191303.206365-10-thgarnie@chromium.org>
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
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/power/hibernate_asm_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index a4d5eb0a7ece..796cd19d575b 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -23,7 +23,7 @@
 #include <asm/frame.h>
 
 ENTRY(swsusp_arch_suspend)
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -114,7 +114,7 @@ ENTRY(restore_registers)
 	movq	%rax, %cr4;  # turn PGE back on
 
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	pt_regs_sp(%rax), %rsp
 	movq	pt_regs_bp(%rax), %rbp
 	movq	pt_regs_si(%rax), %rsi
-- 
2.22.0.770.g0f2c4a37fd-goog

