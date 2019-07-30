Return-Path: <SRS0=DEJx=V3=lists.openwall.com=kernel-hardening-return-16650-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67D5C433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 216712064A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F2smkGoK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 216712064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16650-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28491 invoked by uid 550); 30 Jul 2019 19:13:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28415 invoked from network); 30 Jul 2019 19:13:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9kWf22Rclzq8G5FoRJbzmMz7xyL94toIUGR9urAcRyA=;
        b=F2smkGoK8KcptIdvV2SjQfrL6PlXipy7JjEVMHgzprpHrwcKNVKa93zl9Fymh8BUlh
         fpA3d71j1qBWHNgMomuekNiCQ8MlumiE/acWNOlnavR9gnndo7YWMyqkKvctTUhMJcWm
         5nm1cizH8+WJfF2ZVgUHYpKcxa3wRzq+Z8spk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9kWf22Rclzq8G5FoRJbzmMz7xyL94toIUGR9urAcRyA=;
        b=Fl60l8Xq8TEECKWon504kA95TlpO45RUeGCTWJ1qCZc/G3+Rahded8gY+2nmw00LST
         k7oq95rqDmULEXNawB2K/gTUyqP7sftWPOyBUsQb+OIXco9Pl9bWVpCkqxt1UV4gfe1Q
         ppadr8YZimXKjuwj3mRsm0QQTMZSA4ecnrQrKIgKKWpP17sKvF561kT9QKQbylaOPZCq
         ZxC9J1/Qer4N9Rp7+GgIZ+6LBnRrUmfVlXf13YQLtvVIhC7ALONKbKBCv2342duS+ZTf
         B7seJS2+RLgcP0UkjYnE2Q8cJXbsI2ohOVNxCCoL+8c/NYqVdKP5Fzii7hdyVoQiusN3
         eByQ==
X-Gm-Message-State: APjAAAVxyfpXNyxzlrVe/A7fphr+VPvAsWRX7BhSiyH+Y2eAvg4GWCmu
	CSCIFkVmtEuDXahFO0IY/l+g7vFBTF8=
X-Google-Smtp-Source: APXvYqzr6BK0Xn2ozWdzr0KbSdWi9wDSK/YZN9WyQ63sDSm1hYENlMW/XPd2uWlP9oB/IStB2Eg/AA==
X-Received: by 2002:a63:784c:: with SMTP id t73mr113500712pgc.268.1564514000500;
        Tue, 30 Jul 2019 12:13:20 -0700 (PDT)
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
Subject: [PATCH v9 07/11] x86/acpi: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:51 -0700
Message-Id: <20190730191303.206365-8-thgarnie@chromium.org>
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
 arch/x86/kernel/acpi/wakeup_64.S | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index b0715c3ac18d..3ec6c1b74ad4 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -15,7 +15,7 @@
 	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
 	 */
 ENTRY(wakeup_long64)
-	movq	saved_magic, %rax
+	movq	saved_magic(%rip), %rax
 	movq	$0x123456789abcdef0, %rdx
 	cmpq	%rdx, %rax
 	jne	bogus_64_magic
@@ -26,14 +26,14 @@ ENTRY(wakeup_long64)
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
 ENDPROC(wakeup_long64)
 
@@ -46,7 +46,7 @@ ENTRY(do_suspend_lowlevel)
 	xorl	%eax, %eax
 	call	save_processor_state
 
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -65,13 +65,14 @@ ENTRY(do_suspend_lowlevel)
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
@@ -83,7 +84,7 @@ ENTRY(do_suspend_lowlevel)
 	.align 4
 .Lresume_point:
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	saved_context_cr4(%rax), %rbx
 	movq	%rbx, %cr4
 	movq	saved_context_cr3(%rax), %rbx
-- 
2.22.0.770.g0f2c4a37fd-goog

