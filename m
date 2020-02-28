Return-Path: <SRS0=RlWV=4Q=lists.openwall.com=kernel-hardening-return-17998-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14376C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:02:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 62DF22087F
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="K56MuzoH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62DF22087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17998-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22245 invoked by uid 550); 28 Feb 2020 00:01:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22160 invoked from network); 28 Feb 2020 00:01:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J9YtfCHL5s52dZTQkxs/+RndppOjr/z9RSlKj3vVFK4=;
        b=K56MuzoHmJUhOwYAvoCivoJ3u+vvHwEXYBXxV/vaNqkwrMWvn6gZRUNGCDOMEWNWxq
         sZ+TLzbq8VZvxFT/X6aSYuuccKjRlkbPYenzAHHaZxxWuXBdnkU665sEaogmT61k4o7h
         JOsNBpxmKp7ISBaWRhouukTSaZ5dtB2hELDJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J9YtfCHL5s52dZTQkxs/+RndppOjr/z9RSlKj3vVFK4=;
        b=g9df0bbGdWCiHWUGGkmzbDr6p4FebLjv1qjiyF4G8CE49gGepdyzeagsojPvO+hXS7
         nkuH3zIemRCclKLuIHjaFLOLADnYwrZXKMrbf79bE+Xpvymzmt33TIiBmsXuGu8GdOnr
         alzfH7UAu+hdzVw8+XCfnClFLS7L3/xp4goosDSspZlOWlJwGqoP7lYvL6YZbMqFRxxw
         2wJGCw9MR9MHFrTIJr48T1GSQBlYMtO2u73DWigKklT9H6f5Sdif6csNVgx/5YgOTxg6
         JQZ/lYNWRYLhJ+efCpqiDdUGhcbGMOARrSR1NbdnGZLzhGaj0McrdtZ6tOp+xP+euD6h
         ZwCw==
X-Gm-Message-State: APjAAAUzOtxJXpp0H7nXh2b9RESt1dQ02rhtGf6MIfG+7ufxiRMtaHdH
	0Q746/5T8LImL5zPqDtSbI5BY4IT9PQ=
X-Google-Smtp-Source: APXvYqw3AgR5lreXOHV0mcPtons4OK9hEvjDW+aai6cRQfG4L95jHGQf/AsHHClO7ZoWLJCOWZ81ZQ==
X-Received: by 2002:aa7:9891:: with SMTP id r17mr1587416pfl.205.1582848082152;
        Thu, 27 Feb 2020 16:01:22 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 07/11] x86/acpi: Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:52 -0800
Message-Id: <20200228000105.165012-8-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/acpi/wakeup_64.S | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index c8daa92f38dc..8e221285d9f1 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -15,7 +15,7 @@
 	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
 	 */
 SYM_FUNC_START(wakeup_long64)
-	movq	saved_magic, %rax
+	movq	saved_magic(%rip), %rax
 	movq	$0x123456789abcdef0, %rdx
 	cmpq	%rdx, %rax
 	je	2f
@@ -31,14 +31,14 @@ SYM_FUNC_START(wakeup_long64)
 	movw	%ax, %es
 	movw	%ax, %fs
 	movw	%ax, %gs
-	movq	saved_rsp, %rsp
+	movq	saved_rsp(%rip), %rsp
 
-	movq	saved_rbx, %rbx
-	movq	saved_rdi, %rdi
-	movq	saved_rsi, %rsi
-	movq	saved_rbp, %rbp
+	movq	saved_rbx(%rip), %rbx
+	movq	saved_rdi(%rip), %rdi
+	movq	saved_rsi(%rip), %rsi
+	movq	saved_rbp(%rip), %rbp
 
-	movq	saved_rip, %rax
+	movq	saved_rip(%rip), %rax
 	jmp	*%rax
 SYM_FUNC_END(wakeup_long64)
 
@@ -48,7 +48,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	xorl	%eax, %eax
 	call	save_processor_state
 
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -67,13 +67,14 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	pushfq
 	popq	pt_regs_flags(%rax)
 
-	movq	$.Lresume_point, saved_rip(%rip)
+	leaq	.Lresume_point(%rip), %rax
+	movq	%rax, saved_rip(%rip)
 
-	movq	%rsp, saved_rsp
-	movq	%rbp, saved_rbp
-	movq	%rbx, saved_rbx
-	movq	%rdi, saved_rdi
-	movq	%rsi, saved_rsi
+	movq	%rsp, saved_rsp(%rip)
+	movq	%rbp, saved_rbp(%rip)
+	movq	%rbx, saved_rbx(%rip)
+	movq	%rdi, saved_rdi(%rip)
+	movq	%rsi, saved_rsi(%rip)
 
 	addq	$8, %rsp
 	movl	$3, %edi
@@ -85,7 +86,7 @@ SYM_FUNC_START(do_suspend_lowlevel)
 	.align 4
 .Lresume_point:
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	saved_context_cr4(%rax), %rbx
 	movq	%rbx, %cr4
 	movq	saved_context_cr3(%rax), %rbx
-- 
2.25.1.481.gfbce0eb801-goog

