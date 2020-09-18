Return-Path: <SRS0=/ETX=C3=lists.openwall.com=kernel-hardening-return-19946-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6C1C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:20:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F13FF20684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BCRPev+r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F13FF20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19946-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26547 invoked by uid 550); 18 Sep 2020 20:16:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26447 invoked from network); 18 Sep 2020 20:16:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=o2DL67IOGBCnkKLJVmvx6mUhLGuExASqR4QZ4OZyxOY=;
        b=BCRPev+rE/eCdhTRad14OxKPRC759YffFhBrw/j99zRl+XMk2SeRH2Ro57Q+fpYAoY
         41dQCr5nRdN1nuAqPl79eRYF7Et/K4hrYua59TnFUm5Qft7hifOftA32AELoX+E867b9
         2jVvQFpvTUQ2M35PWVTe002iSNw0bKhWwMU3J5xh89MftQHJTF8aTjqfy5S8odXPfmkR
         B2V75MstoeJ9GqBepGfubW5/qhE+jhI/WYG/r7dM4O293zVEla547bOEPQpSKmz7YdJU
         wGZC1Jet9cEIKlifpza3a2tLHND8kbzGrtrT3REGXctWnfeV7IsjeRGJP72+hJcsyY8w
         zCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o2DL67IOGBCnkKLJVmvx6mUhLGuExASqR4QZ4OZyxOY=;
        b=YR3ktjxeqRIn2Qj1+N4QKd5nkcgW6IAykNXHnmrlGyCu0+X0KyPVZaaC0P3tIQ10hA
         y7gr9RR4mpBFkL3IdrV+ZF2BaWgMDuIHcD1i3hhRLl9NlMdPF6wfUOCyfqubSYUWPBxj
         /kDCy5UJQNA1sk0OgTQBJIXntUVEApUsONis6Zdpb/MhiogeaXF513YmG/N9+5Dq38MD
         iJ0uLQWWXONt2mKxOj/G1pVNBrtMo8Ii56CKd6Bugu3Vy3+TBnJCqqkBsUBR8pHth6vN
         Gy8t3/eKj/uzspjNYsxmmd+dLQ9GEedsIHmgfJGfiwA5lgaP3iRT9B9qQzPnNA4ueNGg
         4esQ==
X-Gm-Message-State: AOAM531Jkpcy7oi+4CDgTPuXcDcmm+uLS/0Bh5Dnx9IYErJI+e9TPih7
	DiUKXnhbsGaxwYsWFSbgex1tqHj+R4GcP9ytA30=
X-Google-Smtp-Source: ABdhPJwrzpZNvpYit1QmzfPWE8TC9Luw0JQEd0AJRVJCA8aClr3KtmTNrVIGHe8CNeT/kpakU/IVCxd5qz42yc0kkDA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:887:: with SMTP id
 129mr35650576ybi.513.1600460151944; Fri, 18 Sep 2020 13:15:51 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:36 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-31-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 30/30] x86, build: allow LTO_CLANG and THINLTO to be selected
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

Pass code model and stack alignment to the linker as these are
not stored in LLVM bitcode, and allow both CONFIG_LTO_CLANG and
CONFIG_THINLTO to be selected.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig  | 2 ++
 arch/x86/Makefile | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6de2e5c0bdba..0a49008c2363 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -92,6 +92,8 @@ config X86
 	select ARCH_SUPPORTS_ACPI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
+	select ARCH_SUPPORTS_LTO_CLANG		if X86_64
+	select ARCH_SUPPORTS_THINLTO		if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 4346ffb2e39f..49e3b8674eb5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -173,6 +173,11 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 	KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif
 
+ifdef CONFIG_LTO_CLANG
+KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
+		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+endif
+
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
 #
-- 
2.28.0.681.g6f77f65b4e-goog

