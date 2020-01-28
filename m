Return-Path: <SRS0=V8HF=3R=lists.openwall.com=kernel-hardening-return-17627-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABB3C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:50:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4E07220CC7
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KS9unC98"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E07220CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17627-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11826 invoked by uid 550); 28 Jan 2020 18:50:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11764 invoked from network); 28 Jan 2020 18:50:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7qZDsX8PGWVYt4iEMt/hEQ+wAm1UsjKf1d+2vHZ6hPI=;
        b=KS9unC98BEN8reSNsSatSdGOyj9rhjRIhLpWA4Oym2iRcIbRcgujukrAJVafuptIVG
         4EooaqgtRT4z7P+gwfQEa6aLMk1SNJwyZKwX2crlZuGyjCIlB019qhZdYW5KDGB7SEtd
         0PuR+pszsgeqyBZrTkpSnRyXr+6t67faREc4ZftAuETIwNEYKpHUPeqa0nonCQaAHyP2
         wD25AjVMJD2kosLIy8FOnX8wGleJoEeAginjYdtC6nC2di6uwR2ExHm37hyKDxKy72du
         p8OwOQ+2vYq84iwfEx6zX7e/LJhw9x1StdJnITGBGfd8VptfiMqFNL8peyNZv1qVoP+e
         +6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7qZDsX8PGWVYt4iEMt/hEQ+wAm1UsjKf1d+2vHZ6hPI=;
        b=bVqc0nB6/AZupA1MWXl1xuUllGyoss5xKgd36Is8u3HJERaNqkR758gCJ8IrReg/Vm
         uPHm+eeGMjHyTdMPN/bUs3HXzrg/kqTi0cecQVlbRiBDpobzAmRuEST1nPIFHsX+YXV1
         xTPB36GFFRWDRZeRuy1Vx2tra1YHrZvuRgc61/1B6klJGf2ngJLEe/jvSH9fNOJl/7nk
         exEtm/gC/vbeCXGzgs4mzpu2+bfSBCUgNJ0A4bO9sPM4h/Ze9BlLZUD/oBCbJZr84Bxg
         KG5+Spx1jWRkoiFjX15z+iyUp6J55t1GtY99j8GwHI94gwY1SrwBhJ9+jUQXLP8LSg/9
         +erw==
X-Gm-Message-State: APjAAAVKiuH3I7uZmOFoa2hO5FeuHMZ7k4spST+0HEO4pgpb/Bq6YJnh
	cWpnCzb4VovpDQeJsfq7G77uLENiBPxNd7hbafc=
X-Google-Smtp-Source: APXvYqz1ANohbb/5vvdBoYWBYp5QONjn2Th3Usy5pRDWtLh7ROCJORzEP/CMHwmepkxfOG/b7sXyq/Vz+8AN5R27oWY=
X-Received: by 2002:a05:6214:965:: with SMTP id do5mr23635758qvb.202.1580237393882;
 Tue, 28 Jan 2020 10:49:53 -0800 (PST)
Date: Tue, 28 Jan 2020 10:49:29 -0800
In-Reply-To: <20200128184934.77625-1-samitolvanen@google.com>
Message-Id: <20200128184934.77625-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200128184934.77625-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v7 06/11] arm64: preserve x18 when CPU is suspended
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
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
Acked-by: Will Deacon <will@kernel.org>
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
index aafed6902411..7d37e3c70ff5 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -56,6 +56,8 @@
  * cpu_do_suspend - save CPU registers context
  *
  * x0: virtual address of context pointer
+ *
+ * This must be kept in sync with struct cpu_suspend_ctx in <asm/suspend.h>.
  */
 SYM_FUNC_START(cpu_do_suspend)
 	mrs	x2, tpidr_el0
@@ -80,6 +82,11 @@ alternative_endif
 	stp	x8, x9, [x0, #48]
 	stp	x10, x11, [x0, #64]
 	stp	x12, x13, [x0, #80]
+	/*
+	 * Save x18 as it may be used as a platform register, e.g. by shadow
+	 * call stack.
+	 */
+	str	x18, [x0, #96]
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -96,6 +103,13 @@ SYM_FUNC_START(cpu_do_resume)
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
2.25.0.341.g760bfbb309-goog

