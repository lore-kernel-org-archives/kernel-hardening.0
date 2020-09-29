Return-Path: <SRS0=O6lu=DG=lists.openwall.com=kernel-hardening-return-20058-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142F8C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:51:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E88D2076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jWS8iUHI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E88D2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20058-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5238 invoked by uid 550); 29 Sep 2020 21:47:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5132 invoked from network); 29 Sep 2020 21:47:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YnFARiKS6UDkwdk7WP0wlvbxlnuyKDZd5kTTgvwZzNo=;
        b=jWS8iUHI1yEZwlx3KeKvcgfGPXNdJ4L5onYlC3CBBL8D7obZFD5GHWOijlDtJb8Ij7
         nRmkWkJefVtEgGfyFLejApsO2VFmeAT9vQpKzbQWErmeV2XzN2V7GUaE7Pe9GHYQRqUr
         Xv61qqqbIr/UD4HQGH+NeCWqUBIaeXjzSEj5haCz3bHxBeyeFilgtE7h3SBO5qI9TeFI
         VNBOjzf+qN4PzKeK/ip+sm+V/3xF7iAcrvnH3Y+OXfQISp+lvRlaGKxv9Vs2X9cKIOs1
         +Egn3AASlwiipmUBXQC2SS1FvIyAuimNGXi91NcEG22l5xpotuSePeSMxIwf0qHe6n0r
         39pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YnFARiKS6UDkwdk7WP0wlvbxlnuyKDZd5kTTgvwZzNo=;
        b=TxIOiglRDlBwnit/dTRuKOEtfPjVKGOwvn274D0sdnVtD3u8FlCqGUTH0coFhs/npM
         V+LS7IHr+eAE+kCEsH9eX23LX5Xu7GMDeGpI5CwpmmCz4571xsN0x0y8kRQ6qQR3X8jE
         WcCniVIWjagn9HRAjTNF40NWzwJB68Q0hPpTAnYqLwMc1vILMc4Wyu+t+kJfHjWJ/Dko
         GOGIGUI8DYcj78/NzrsR/Q2OSWEUIC2T5I4qGOGQCW7xzZVQ9nc8imZt4WjRnqM4M9iK
         l0aRyV3W9Bl7o3vQvYlnNRVwYqQU9wzQAa7Yfk31gZSLE0kdeyNPu+xs9LLzWV90u4bg
         49mg==
X-Gm-Message-State: AOAM532ce9Oox0gtofqzVbTI2MrGFS7QnjovoRrA3EOfrf7tSfaulLzi
	39Mzgu9ycGLAyYOpisHXbv0IZ8PF0Dd2IBjyb44=
X-Google-Smtp-Source: ABdhPJxYhSRNOkwgDRc/l2C7Jl258wmN5ml/1qkiBHZtQEnR2mVC77q0+39UpprEXaMpqtbM+otlfoYoA23IDmqOt+I=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:ae9f:: with SMTP id
 b31mr8477359ybj.437.1601416057863; Tue, 29 Sep 2020 14:47:37 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:30 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-29-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 28/29] x86, cpu: disable LTO for cpu.c
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

Clang incorrectly inlines functions with differing stack protector
attributes, which breaks __restore_processor_state() that relies on
stack protector being disabled. This change disables LTO for cpu.c
to work aroung the bug.

Link: https://bugs.llvm.org/show_bug.cgi?id=47479
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/power/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 6907b523e856..5f711a441623 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -5,5 +5,9 @@ OBJECT_FILES_NON_STANDARD_hibernate_asm_$(BITS).o := y
 # itself be stack-protected
 CFLAGS_cpu.o	:= -fno-stack-protector
 
+# Clang may incorrectly inline functions with stack protector enabled into
+# __restore_processor_state(): https://bugs.llvm.org/show_bug.cgi?id=47479
+CFLAGS_REMOVE_cpu.o := $(CC_FLAGS_LTO)
+
 obj-$(CONFIG_PM_SLEEP)		+= cpu.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o hibernate.o
-- 
2.28.0.709.gb0816b6eb0-goog

