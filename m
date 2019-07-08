Return-Path: <SRS0=k+nG=VF=lists.openwall.com=kernel-hardening-return-16393-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38ECC606BD
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:51:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3620F2189F
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2019 17:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gWdTavZI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3620F2189F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16393-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28491 invoked by uid 550); 8 Jul 2019 17:49:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28418 invoked from network); 8 Jul 2019 17:49:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jvubPfiCRWcqYJeQKrlvplKJ87mcq6CV3rScnhJCQ5U=;
        b=gWdTavZInEF8s+f73QfuvdZZVflT//tp6s2gup+DG7rzJx++7Zxn4YR8R+P3cCQ3vg
         0XtUyooDHCqvJfLoTxIPl7CFHlSKSceFQO1IeLxzta92vXckW46gHBQduoya2pJJMyio
         nnulEIodWWvqRkpqb1gs8njfVwcB7aV8EdjTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jvubPfiCRWcqYJeQKrlvplKJ87mcq6CV3rScnhJCQ5U=;
        b=frt6eovGOilpWIkxJLwMXjvCWFhgr4uv9Y0IVAJ0OKZ6+N8ciNoQoGIXUmV2OrlQxx
         6VXiFgSBnnVQvwZwOcJ2rPtE6KV2aX1RZWOZLXb4u6Z4pfoIOdFT3Mk44zaDXlxl1vSJ
         fXqfSUipmdvmXBODolKgn4iGkVOS9D6OhRQTGk/If1D4s4LploBwq6l7OjTI3G8cgxwJ
         3v+l5af8xFHSZ+YvQzHA1/zNh9dqFL6Y+GXDaq+TBuz1Qz2QlT6lo93KEtDUbfsRAirt
         OGE9u0LxUuxVDnLBmhX8S7uu/erhqjQv5T8o3CtlEckG2fZ+0W91glnxtKSLqBOsrCWX
         hM8A==
X-Gm-Message-State: APjAAAXkD1fqbNMqe43brecXp3CJ0LZ7SQeKQyCpO7kNxlrGwQh+A2SC
	HX3t2PbPcRKNX6jqVMnIusvNXIlspBg=
X-Google-Smtp-Source: APXvYqx8rkznkGCAzouh1iIQ84Mhjqiwd/g+Pg/qIIPvd4iT14Pzd6lYH1LAJdK/xxZzTbQTVpJPsA==
X-Received: by 2002:a63:2310:: with SMTP id j16mr26308534pgj.238.1562608179726;
        Mon, 08 Jul 2019 10:49:39 -0700 (PDT)
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
Subject: [PATCH v8 09/11] x86/power/64: Adapt assembly for PIE support
Date: Mon,  8 Jul 2019 10:49:02 -0700
Message-Id: <20190708174913.123308-10-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
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
2.22.0.410.gd8fdbe21b5-goog

