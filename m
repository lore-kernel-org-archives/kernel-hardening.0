Return-Path: <SRS0=taVu=Z4=lists.openwall.com=kernel-hardening-return-17482-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EF8C43603
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:15:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 195BF206DB
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XpQfC+Me"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 195BF206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17482-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21950 invoked by uid 550); 6 Dec 2019 22:14:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21822 invoked from network); 6 Dec 2019 22:14:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q0VCePxuQrqw4BBZGnamleajd+Jt3fiHSwLdib7c23k=;
        b=XpQfC+MeF/x/58JAAU0Gq9P6sK3UThDbiX4tokqcmE5W2JlFjupWk3t7S6fJEl7bmQ
         uG77IKQKNCjwNeXL5gKTK4hYsXwcw3IEb3xYsQMThtapSpkH/6n8NZA1P7BK9GoJvjlv
         gjsgrx6f2M8YtuUoFz6xW2/sVs3avmftC2FD9rLUg7uPIxxu1nky1tI+067SAycFIIZv
         I5Ox0b34VKtUQTfOqlCtC7ANi+wPbCIGo5s06hQc0p9ToPPN7U2DDRK+8/gr5u99Ip8U
         6665xOHYKE53S80IzppbeI1PtBJzI2Bw2DR42y5FZrTsuJwM4wsLA+y323NiZkNZTWXF
         YfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q0VCePxuQrqw4BBZGnamleajd+Jt3fiHSwLdib7c23k=;
        b=qhSNYxkp18j8se52fscUQVGj4vsDoF8jWeE5Ap9tjn7EJ773OC+9DAtWi1SJzlgxl2
         tnnmWIQfAi963YIuUqYrnS5qcl8DJ0R0eFcvZ3Oy8NyL6sFFetnim6lAyQxQGgCvZbSE
         ssr11kpxDh4T6U4n48Ct6Fppthgbh9oEFAvuBoUIuKXqBdegha3ze+NaOfrB+ZuZKuHI
         g56iQQ4OVLHJ1Jd0OHy0J3+vvro3rfZjx8onymyHxSvhYHs6lK/8RPHX3cGqEHrwTM1n
         bqsMuGCZuI6hjHdgUC+nvlWi8H2hwYRNzD7qYxUbX3v3DBPnnqweSwoqStMWT6mUCfCN
         nu6w==
X-Gm-Message-State: APjAAAVSOVb6cCO0rhiJhdEadDrxX4KwTEIOwojLfvEqHo7+VFHNyNuh
	UNeAgpEf6417oVDIfXYl+NepHX4c5EJqdKvkp+s=
X-Google-Smtp-Source: APXvYqxcGyciG3MMD7PbQn8IKkK3yA7MJ/fwU2YEUvmtPTk2dDChHbcnuIxBvmADPyGDroBjAeLdoXj34UKB4SrRjVg=
X-Received: by 2002:a63:d543:: with SMTP id v3mr5881958pgi.285.1575670461425;
 Fri, 06 Dec 2019 14:14:21 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:46 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 10/15] arm64: preserve x18 when CPU is suspended
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't lose the current task's shadow stack when the CPU is suspended.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/suspend.h |  2 +-
 arch/arm64/mm/proc.S             | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index 8939c87c4dce..0cde2f473971 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 12
+#define NR_CTX_REGS 13
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index fdabf40a83c8..5c8219c55948 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -49,6 +49,8 @@
  * cpu_do_suspend - save CPU registers context
  *
  * x0: virtual address of context pointer
+ *
+ * This must be kept in sync with struct cpu_suspend_ctx in <asm/suspend.h>.
  */
 ENTRY(cpu_do_suspend)
 	mrs	x2, tpidr_el0
@@ -73,6 +75,11 @@ alternative_endif
 	stp	x8, x9, [x0, #48]
 	stp	x10, x11, [x0, #64]
 	stp	x12, x13, [x0, #80]
+	/*
+	 * Save x18 as it may be used as a platform register, e.g. by shadow
+	 * call stack.
+	 */
+	str	x18, [x0, #96]
 	ret
 ENDPROC(cpu_do_suspend)
 
@@ -89,6 +96,13 @@ ENTRY(cpu_do_resume)
 	ldp	x9, x10, [x0, #48]
 	ldp	x11, x12, [x0, #64]
 	ldp	x13, x14, [x0, #80]
+	/*
+	 * Restore x18, as it may be used as a platform register, and clear
+	 * the buffer to minimize the risk of exposure when used for shadow
+	 * call stack.
+	 */
+	ldr	x18, [x0, #96]
+	str	xzr, [x0, #96]
 	msr	tpidr_el0, x2
 	msr	tpidrro_el0, x3
 	msr	contextidr_el1, x4
-- 
2.24.0.393.g34dc348eaf-goog

