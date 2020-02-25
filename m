Return-Path: <SRS0=6hQ4=4N=lists.openwall.com=kernel-hardening-return-17911-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487BDC35E0C
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9E3EC20658
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2cjymvo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E3EC20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17911-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1978 invoked by uid 550); 25 Feb 2020 17:40:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1910 invoked from network); 25 Feb 2020 17:40:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tR8HWR8eyR6LK2Q8Pau54PB7Q0F7v08515rGGzIGLyo=;
        b=t2cjymvoAu3LNnY2V+9fr1UqF1UTZQ7oaKDZV95hsccbo+Wem9ObhjTRot2oxcbV5s
         JfHwf3EV7LvbpaOCXbv6b6KpquhcRc0DyfxTbmG8xfI0XgwDdCaXq1SsCwfJFidfJNH0
         /1lyLaxQdfo98V3WIDBrRZyBcNTKLXgCD4k/O7fm5khTgVNWgLamopl3Y0pvahPUzGES
         f28q5lH+lgtKGXo6iAptbVXigkwOR4L5+NG1VNse0XvPI6kiA+OwQCXooeRip2W1h5N+
         n5U5kzyS0lZfpanYDv8d/3XVs1lgSeb9v4a97K9YEiQO+OqzbCqn5MKxr0OMervjTlWG
         lsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tR8HWR8eyR6LK2Q8Pau54PB7Q0F7v08515rGGzIGLyo=;
        b=k5rQqj0IjMo/4ltWMVFRIyXMlF+yro1+fkAzbCvdt/uipHUD33VpCYP/9os0fNQtO8
         e0NY6bqrxD68VFkteVt7x9KJD3+AWXFSTX7LT1We/5LvOEo6ssBnW/Bdt4kdv5pXb2aE
         Rk6Oxigcu0kFO2L20W28ubbeVl7BIQ9+55KuJp9fw9sDF8bm1spCJ437htdj0BC3o9AA
         H4A08XFhnjgJWH5+lHkSHnd/oBzPP5xEWkkqaS4R6Fz/8IDnWyaQCcz/lDaKvP1P+SEo
         nBTC1eNvb5PpC4GwFy49ByhrvfVVxq2b82yiNwQucuE8JpIVfN27v85eLsl5lFcvO3Ql
         IdIQ==
X-Gm-Message-State: APjAAAVmaMkI6xnLQ7aXNRRVo6WhhTZCrXwUBM/sKg/eUQYnikodkzOp
	6CFn87lLtl3/KEi4hOUz39JN75zwPjAeFgHv3k0=
X-Google-Smtp-Source: APXvYqzUk4s2BxWsI4JfB/KPQ9dbRtIv21dR3HjtRTMHFyoCRyFREYlh9Gc57x5jkFPGsRhM08FL9vGs5N7u7TLsbsw=
X-Received: by 2002:a63:691:: with SMTP id 139mr62220302pgg.325.1582652403730;
 Tue, 25 Feb 2020 09:40:03 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:27 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 06/12] arm64: preserve x18 when CPU is suspended
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
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
2.25.0.265.gbab2e86ba0-goog

