Return-Path: <SRS0=59jS=6F=lists.openwall.com=kernel-hardening-return-18589-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D80C38A30
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 876042082E
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3eUGHpW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 876042082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18589-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19505 invoked by uid 550); 21 Apr 2020 02:15:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18393 invoked from network); 21 Apr 2020 02:15:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Kugk+73vmOylC3TFtzHwjlOoaJ/Fe5NzWOKKOj4AXU4=;
        b=A3eUGHpWTDDbA9s0u0Pa1U4lp6c8kqvnkNiIgHcmXPbwKyAV8mZGRrvfIBkdRFVvlB
         huFyTMvLXJ5vZ9Pt8UjyM5inCgz9Q+HDgcbwi5pfJZMSUOFpy9/vOLihZhGM91p/itfO
         ikNnJVMxOzJAP+BM9TwXB/moQxWelNuAakb/gTrj/GThpfpNxULF5fX2CohJGwxYkecr
         yKdphVmGKjZMJdMT66biopCYN0NguDCRArqBA6+mk0YgzUv4ofvoKIWWOkKYiueuV+oR
         9cLJI8S/4Fqb6r0EOAvWiwOrpYGQitb5mwprwYNCq2GLK2Uo8aYpmOaRzW3sSs5zaA6L
         4hJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kugk+73vmOylC3TFtzHwjlOoaJ/Fe5NzWOKKOj4AXU4=;
        b=pfeDGS3PpB3BHNysoHgfsaUKofnLvzC+JszBS2i4//UehV8KUdyVbQaW/NZNmK8rbn
         T75RQ4vMrVpwgGMy0jxaZ+aJH4zFMN9Ai1ByBs/Q1+NgraWkOzJK6QWH634l+Igv0ggg
         wf8HqSvU2PgPipVL67z8qnuI2QAkOoQkUsRlb+wMKXtNHq82UCVi/VGctFkkX8GAGkhG
         5w28oKFnZMJbvPv4ZszzG3ZSYSKzxrIOqPKh1fal9oj8ByWhEoscblkTsFO79K/XrJ9j
         zfx26f3WPcl04hQNFnBIOdBMSFtPfXVEIwhPA85S/ji2NNS/2dt2jpn49MLlw7LfAeBc
         /RcA==
X-Gm-Message-State: AGi0PuZm8Nx6R1ShT9CqPKep1Io91VvuwRB86pDBgQiGQLf7P2dtot5t
	0w+aQg/cKspQFzVh7MDK/NmxpDyUWT8yVAZD/kQ=
X-Google-Smtp-Source: APiQypKpJPaEfeFJjVAu8BZJl9c2ck2TseHkcjz9gtcJxEqIok18kV4ag1W5TPC52/m0D+4cjJowWUbTX2JapXzjYsU=
X-Received: by 2002:ab0:15f0:: with SMTP id j45mr10353225uae.16.1587435311960;
 Mon, 20 Apr 2020 19:15:11 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:47 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 06/12] arm64: preserve x18 when CPU is suspended
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
index 197a9ba2d5ea..ed15be0f8103 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -58,6 +58,8 @@
  * cpu_do_suspend - save CPU registers context
  *
  * x0: virtual address of context pointer
+ *
+ * This must be kept in sync with struct cpu_suspend_ctx in <asm/suspend.h>.
  */
 SYM_FUNC_START(cpu_do_suspend)
 	mrs	x2, tpidr_el0
@@ -82,6 +84,11 @@ alternative_endif
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
 
@@ -98,6 +105,13 @@ SYM_FUNC_START(cpu_do_resume)
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
2.26.1.301.g55bc3eb7cb9-goog

