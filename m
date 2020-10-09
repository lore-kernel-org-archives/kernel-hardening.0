Return-Path: <SRS0=ChPZ=DQ=lists.openwall.com=kernel-hardening-return-20157-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D273C433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B679E2225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Plxh6rO8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B679E2225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20157-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9727 invoked by uid 550); 9 Oct 2020 16:14:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9640 invoked from network); 9 Oct 2020 16:14:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=eOx9MhffeJ9wDXWdE5ocpTXQ8u7ymKHm7bpeM0Lggio=;
        b=Plxh6rO8fZsaoEQYUiFTv8Gctd0ORGzpZ7B+rZvfUdc7hYRYEfwwGuB/jOOB4N8mRZ
         iAAD+kQylOB8+xnUsPp1FuxiMJFvWDb9+nHFjKZSUxLvWnE/9FbEqxjRwOpDx5ONEslI
         8qXKafYcstPuDgNqimTWoairPVZO2J3rswrWaBPN8Qj/9SVTW+SDOPJ/1LdMPf3bODQ3
         tIT8O2Z6HcQ4IP/C1bLPAj4juZIAgQDUFSX0gtccixqyP1Lwa6S3qb2MSbgtHQfAoxEv
         QRJywRQXLDBTL6z66phNxnXE5ujjd1RTPx5601HvsGfueNCH/Cf7DS82U8ob3oCEPZMJ
         O6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eOx9MhffeJ9wDXWdE5ocpTXQ8u7ymKHm7bpeM0Lggio=;
        b=hzp7HmEcPhmO3Nu9Ip4oUWcSes3IVTUecKGi5vxKck8iz/Y2yGYilbrz7BN4ERhvtg
         33XxGPGg/aTY8oQxvZPZ7/SQMguqalJCdnpZXNcVSsViOnQPO5h7UVXY4Q5CjhujJnjI
         lQzoeLdzQLz4bG+CL3aWzKnU7g2TDuJCeEtZlF28aD8umrnMg5rorE43oEP7hPoQnQo3
         3Bzj4K4UsTP9btJA+ptD7X4veAC0ZYgy0RJfqg3c72agLuXdw8i3wEu+EWoy3bN8CkSI
         MQ8AvSxsZHNDYqv7L5YRplcGAOTnGAXpE4ziAPZ9P3MHc0Q4N1pzPtKgHHlJNbOJCvNC
         ZW2A==
X-Gm-Message-State: AOAM5323WiJxV3CswmPeijfJ93TQl063l4i+zCaGIwQiGqZ6HyMW+yuK
	Ti/R7sWqwAMooLbjUjKUwmDP+MG0PzzTVr8lzb0=
X-Google-Smtp-Source: ABdhPJxyS0XHBxv62ZqOUe+ZCIUsnixCIBFhk+Syvlgu7UF8/267koanykdI+IOKX/T5PRLdfssp5bIj1Kz2wguq10U=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:8209:: with SMTP id
 q9mr19033461ybk.353.1602260072154; Fri, 09 Oct 2020 09:14:32 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:35 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-27-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 26/29] x86/asm: annotate indirect jumps
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Running objtool --vmlinux --duplicate on vmlinux.o produces a few
warnings about indirect jumps with retpoline:

  vmlinux.o: warning: objtool: wakeup_long64()+0x61: indirect jump
  found in RETPOLINE build
  ...

This change adds ANNOTATE_RETPOLINE_SAFE annotations to the jumps
in assembly code to stop the warnings.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/kernel/acpi/wakeup_64.S  | 2 ++
 arch/x86/platform/pvh/head.S      | 2 ++
 arch/x86/power/hibernate_asm_64.S | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index c8daa92f38dc..041e79c4e195 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -7,6 +7,7 @@
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
 #include <asm/frame.h>
+#include <asm/nospec-branch.h>
 
 # Copyright 2003 Pavel Machek <pavel@suse.cz
 
@@ -39,6 +40,7 @@ SYM_FUNC_START(wakeup_long64)
 	movq	saved_rbp, %rbp
 
 	movq	saved_rip, %rax
+	ANNOTATE_RETPOLINE_SAFE
 	jmp	*%rax
 SYM_FUNC_END(wakeup_long64)
 
diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index 43b4d864817e..640b79cc64b8 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -15,6 +15,7 @@
 #include <asm/asm.h>
 #include <asm/boot.h>
 #include <asm/processor-flags.h>
+#include <asm/nospec-branch.h>
 #include <asm/msr.h>
 #include <xen/interface/elfnote.h>
 
@@ -105,6 +106,7 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
 	/* startup_64 expects boot_params in %rsi. */
 	mov $_pa(pvh_bootparams), %rsi
 	mov $_pa(startup_64), %rax
+	ANNOTATE_RETPOLINE_SAFE
 	jmp *%rax
 
 #else /* CONFIG_X86_64 */
diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 7918b8415f13..715509d94fa3 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -21,6 +21,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/processor-flags.h>
 #include <asm/frame.h>
+#include <asm/nospec-branch.h>
 
 SYM_FUNC_START(swsusp_arch_suspend)
 	movq	$saved_context, %rax
@@ -66,6 +67,7 @@ SYM_CODE_START(restore_image)
 
 	/* jump to relocated restore code */
 	movq	relocated_restore_code(%rip), %rcx
+	ANNOTATE_RETPOLINE_SAFE
 	jmpq	*%rcx
 SYM_CODE_END(restore_image)
 
@@ -97,6 +99,7 @@ SYM_CODE_START(core_restore_code)
 
 .Ldone:
 	/* jump to the restore_registers address from the image header */
+	ANNOTATE_RETPOLINE_SAFE
 	jmpq	*%r8
 SYM_CODE_END(core_restore_code)
 
-- 
2.28.0.1011.ga647a8990f-goog

