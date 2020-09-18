Return-Path: <SRS0=kaYh=C3=lists.openwall.com=kernel-hardening-return-19945-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7492CC43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8758520684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVxfXnF4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8758520684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19945-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26306 invoked by uid 550); 18 Sep 2020 20:16:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26203 invoked from network); 18 Sep 2020 20:16:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=FDO+ZF09uotnTu6WM5EnkpUkRKmQDNuzRpzleKkQ7Yo=;
        b=TVxfXnF4QbOPDMOs+zqprMl2MzHgkD6GHCP7JmlPrBoZmOkVnQx/H8w57iWBE6jaYf
         6+KkRK3tQNrNeiix7gFvoYRY8m013PG2qHvBhB7usMFzmH6as/mPJIJ0i1xJYkR6xOcN
         NBHnEyx+G51AeSvmq8253zxiLfvPoAtayITYFw57JnKIYoHuBvQlTEjn3JLNIpdkKk/R
         wAJfJUuh6er8cS8DBKpDt+WcOB99abRnmwdIFbnaz0FqbKU/UIqZu02x2Ix+ynYt2cU+
         uk5Y9gomclggvJtQ/OeFZIMHKEYveSFAxG5tPl5ZC3h8ga6eKx8TJpzeEBbhGIGPyZ1F
         9rHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FDO+ZF09uotnTu6WM5EnkpUkRKmQDNuzRpzleKkQ7Yo=;
        b=EUr8u2fZ/NsW2N8TlsbZVE9mve4nf1b9OmF2e6eoun7NsHRdL1lLZUHeOtGh+XHz2a
         d+2bb+dGSyKQSG4KO7ofwJVLIsVX93jlrxM8vNaU2a6ndvvT7HuTqNrgYcZXxW9n4Lm+
         P8M0PbrC37o0vf84at67z6nz+G0mvMTSedirIih9dng2FDz+tsHCB9f8NyhWfrk9W2MI
         viO8+a24CBaoC5dbEUXq8nKVb83mDK4VpdJuAU4mkgvhifMX8yx6ww6FwiEmbkm+wL4P
         ynM5298jegOOKP2ix+kGbs5c9s2fs3sWJpIwYaFEHlkSW4xeGzffcxIDexQgDSqwTJeN
         80Lg==
X-Gm-Message-State: AOAM531M/SnWGhVWcl1sS4xYRK8d5xPHuCuAprmCyn/fPDEjk2P1RdEz
	HL/ewDtBHzskVh+nInZQbR33edp9JD7cNQyPFdM=
X-Google-Smtp-Source: ABdhPJze5jMIoa5F5/UqpO3D/iFpSGC3f1kIVz5ZhEpSgtL6QfaALCSDHhqVkIqGdPsyHGP7v5lpZGVr0MzGMD5vThc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5653:: with SMTP id
 bl19mr34387705qvb.7.1600460148677; Fri, 18 Sep 2020 13:15:48 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:35 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-30-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 29/30] x86, cpu: disable LTO for cpu.c
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
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
2.28.0.681.g6f77f65b4e-goog

