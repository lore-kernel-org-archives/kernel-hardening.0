Return-Path: <SRS0=iocD=YS=lists.openwall.com=kernel-hardening-return-17117-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEECACA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 23CF320867
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H2b3RZCL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23CF320867
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17117-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7617 invoked by uid 550); 25 Oct 2019 09:28:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19738 invoked from network); 24 Oct 2019 22:52:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3L2fKWe0mnTKbOXtDJWS5MdWfgbISjm7SM0mf8jhMMs=;
        b=H2b3RZCLiylwud/YwS8XTUX1Nfxf49CmiNoouPiLQWiwkmkw6s5J3L6a6uOMooc4I/
         if+ccaYBMM2Jc9mBIKeBZr0auWMA7zC6OkjcSJ1FJGr5CKQ2AKFeLXHSWQCh1T+Wk3pm
         nyov8olG1fm/RHMhdTkccA9BSvy00AbYUCyfFQMmdOh2Xuacq9FgBu+HT9CuJQpEIC8Y
         PNTFQVciC8sYwLstWG7sJf0mJ+TuwRuGM9jfM6cjlT4zPYuVFCG5+jqVPAX/8eswE8zf
         bt35nEX73zZkPoG04qT4nAnZvMZgNDYWfIB2eks3sB+AlQloPZxuEBCzajWqBzSccSw9
         NBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3L2fKWe0mnTKbOXtDJWS5MdWfgbISjm7SM0mf8jhMMs=;
        b=YrVT1esykooH1+83xViLbuzgIeCHozUpfbXyjHZx5WP5zzyUDXmHvwzBARZzEhs6k/
         0PfQui00MJKGxVLu7ksYKCOTBRys/RbUE/FIviGZLukiIQrmy5SZjUkRbQnTRf2+T/0X
         zpX93RRfukLhcsMeBA75U0zhD5PmGGsNLwRww7ceEu6v+ngCIrGmFMDIe9RXW+F+Vn8w
         L3WrRtnsbqi8xKzIseOOpD/kI/M4hwXkCe//HsZE0SGcF8l0/0SDtURGQ3+RtEG8TxgX
         JZ2KuzGcM+l+FiJ4biUP+72nnZlNmvwei1R7F68OTeygXddA0cNp2rhDJQUfhSWYsBDh
         Fucw==
X-Gm-Message-State: APjAAAVKl3E8kEzmhdsQRn+D03XVzu7OaSYIcHRNXK9H9tnjAdiYiTgG
	UHs3nvb2pc2gG8t7z8t9Ma8bUJJ56Pk15MehxBc=
X-Google-Smtp-Source: APXvYqy9g1XQvCTpQ3Jxss3Ar1eHiV+3ywS0nmj9a/zcS8ytsRAvfPgmUVmxVtOnVPORgMnA0aWwHbORKOrobXSREds=
X-Received: by 2002:a63:af13:: with SMTP id w19mr469567pge.189.1571957543335;
 Thu, 24 Oct 2019 15:52:23 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:27 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 12/17] arm64: preserve x18 when CPU is suspended
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't lose the current task's shadow stack when the CPU is suspended.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

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
index fdabf40a83c8..0e7c353c9dfd 100644
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
@@ -73,6 +75,9 @@ alternative_endif
 	stp	x8, x9, [x0, #48]
 	stp	x10, x11, [x0, #64]
 	stp	x12, x13, [x0, #80]
+#ifdef CONFIG_SHADOW_CALL_STACK
+	str	x18, [x0, #96]
+#endif
 	ret
 ENDPROC(cpu_do_suspend)
 
@@ -89,6 +94,10 @@ ENTRY(cpu_do_resume)
 	ldp	x9, x10, [x0, #48]
 	ldp	x11, x12, [x0, #64]
 	ldp	x13, x14, [x0, #80]
+#ifdef CONFIG_SHADOW_CALL_STACK
+	ldr	x18, [x0, #96]
+	str	xzr, [x0, #96]
+#endif
 	msr	tpidr_el0, x2
 	msr	tpidrro_el0, x3
 	msr	contextidr_el1, x4
-- 
2.24.0.rc0.303.g954a862665-goog

