Return-Path: <SRS0=FUJ7=CM=lists.openwall.com=kernel-hardening-return-19745-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA3CC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:36:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C086420684
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhsXYaep"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C086420684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19745-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27823 invoked by uid 550); 3 Sep 2020 20:32:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27691 invoked from network); 3 Sep 2020 20:32:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=z1oE9Ahlo6q+kOr1oYLTleDll+XTtOFOU5n4tP72oXo=;
        b=dhsXYaepDU3UMSsdIoiJQCPA2falNwv2qZU1/VdJQ1hXkiAnSpUZqf+Rk3qRL2tZAA
         RATqeMGpf2kMmoAJHONhUjAMV6PegNyYkc3QJaAVEVEcLCjBrBqX09ABdO5+mQ95+DDw
         f25F2G9jXfYk/9EQ2j5jmaiLccx+nM/z6pbas3dlrRF8URH6MyCoC/KP1gno65LWfHKJ
         Q6D2TJQFYwBZAepJLd9Yd28lqGFx1HWGm1ZuFChTdMhn1NuMfjTAvQ+mpiiVULLpvd2L
         Y9xqDVxLlVJb9OyiDxJrlsR9W0TKzMvmJcMqoguuNEejgNuP+L5/S3K+uSCWznAoXPfA
         ElDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z1oE9Ahlo6q+kOr1oYLTleDll+XTtOFOU5n4tP72oXo=;
        b=b5dDNuSliaffO0YEh2ArHp/rWcF8xuhgVCw8QcCeag32M/CyPY0hqUXNyXNqvhKHUx
         TueLREZSjw25MwfJb7skkhcKJswLaXCaUmCJskeOKNmGWvd5lXHHR8+K06P6MmWKwNEe
         xr+dMrSh6uCTNgh+/mUDRsUk/uhuGhkDzGQH9D2d00vd70ns51sNxqWtMZvkhP1rTOuX
         vLY8+Lb+gpLdL92jMTog3Btw9ETRJN12xNWaKmZ4+JLAcFlnYYjrWpPcRYiT73YYLZCR
         MRz6J6OIsoeRDSD2wLzUKzf94Mhf6ZSQqlOHsXRQvd8qXWBq1q9FrPagBeJkqG4R0Mae
         x+NA==
X-Gm-Message-State: AOAM533ZWlkcWNQZXpemjSNZGOGkxhtG189sGoZGvGjuvihYAFSKkg1S
	w9+uFD4AMsLa37B8RRANykC+DVvN/gR5fQ8cwjs=
X-Google-Smtp-Source: ABdhPJyEGMuftj1qYs6R/OZbYPrPPMiyM+BRAtuMsdOJHhZ0hVrBwsv0OgWjQWUGye1drGkS4UUiW2tD7l2OoeX093w=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:d803:: with SMTP id
 h3mr3575787qvj.0.1599165109962; Thu, 03 Sep 2020 13:31:49 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:51 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-27-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 26/28] x86, vdso: disable LTO only for vDSO
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

Remove the undefined DISABLE_LTO flag from the vDSO, and filter out
CC_FLAGS_LTO flags instead where needed. Note that while we could use
Clang's LTO for the 64-bit vDSO, it won't add noticeable benefit for
the small amount of C code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/entry/vdso/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 215376d975a2..9b742f21d2db 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -9,8 +9,6 @@ ARCH_REL_TYPE_ABS := R_X86_64_JUMP_SLOT|R_X86_64_GLOB_DAT|R_X86_64_RELATIVE|
 ARCH_REL_TYPE_ABS += R_386_GLOB_DAT|R_386_JMP_SLOT|R_386_RELATIVE
 include $(srctree)/lib/vdso/Makefile
 
-KBUILD_CFLAGS += $(DISABLE_LTO)
-
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
@@ -92,7 +90,7 @@ ifneq ($(RETPOLINE_VDSO_CFLAGS),)
 endif
 endif
 
-$(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
+$(vobjs): KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO) $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
@@ -150,6 +148,7 @@ KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
 KBUILD_CFLAGS_32 += -fno-stack-protector
 KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
-- 
2.28.0.402.g5ffc5be6b7-goog

