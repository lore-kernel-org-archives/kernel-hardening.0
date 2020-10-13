Return-Path: <SRS0=HTI0=DU=lists.openwall.com=kernel-hardening-return-20198-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54330C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:36:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7151621655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H1F377i8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7151621655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20198-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21965 invoked by uid 550); 13 Oct 2020 00:33:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21814 invoked from network); 13 Oct 2020 00:33:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NB4DqWz6+fIfMXcokXEeMggmgfFph8OJ/Hk6TSxy9cU=;
        b=H1F377i8eGQAU/5A0yi1yr0c33hGgdU8XEV9saDmRDeYR0tkVsNxEXUclpv1KfQaU0
         /n56cozTapbGtfIzzZr2zkFu0QiAzdA/2U4pijKUqmCNtwJLZOHMOhyYpo/RVj3+a9up
         uw03RRjDJUEA07AI3ycjej51uqULrxQxMDVvJUyMWGW9h09GHasuDmPYx3/m4etV9s4F
         /8ifejQyz9wBUEc+H89uj/k7/XI3IN0cqCEm+8nY+wRoA6LNkaf8a9R7Z2OdYi/ddy5V
         vh/iycwgiqqL8SNRUxcnX4VZEMdDFUCQ+T9Ak4gRDlRzIex36WiXpUQpVsXw+Sm3BVXa
         op1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NB4DqWz6+fIfMXcokXEeMggmgfFph8OJ/Hk6TSxy9cU=;
        b=Zmcm1aew1rFwK/u8WFGbbqSUkMz1+Oeg6YXkT3NWFBjkDt+gPB6ZiogRIaE4TZBGYH
         a/0ioePkLe5KlafZMqXQcA7DREcPxih0Dar6Y9PJUj6z8UrTmENXvBUiA9e4XC3ZEGdH
         RRdqOl7Y3WnTeNhvGRZecZ3SSAV5yyuL/XTNO84JmYw9neBhC8JWTusPr5IYpPH1+hPM
         NmDdtnLojkSjRURs0XbdivRGe9/DEq6234SSZ+F6MPfvAs2acSsrU9gJ7UmzuB/vzSod
         EvO5RLkPLMfCXl0XykUjoWf1HWea5jJ/lF7RM0ijJYhTT/oVIz1pUj6qD1kH5EAep4JZ
         nnRg==
X-Gm-Message-State: AOAM530xuHgsm3mYNtc7aEQedDwQ9zxZmPmrfsTSgIT8QKMINCigxZsz
	ckzWs5bQQWk1PQ/u52/mEAM7PScsQp2xsuLPIbQ=
X-Google-Smtp-Source: ABdhPJwqkp+cAjUgpQ/a4zy6+yRRoWJAx7zl3+DhKe/ksIEW9MuPzDjzs69jj4tiiYYaOThbc4htLgXeM88lIlTIveg=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:59cf:: with SMTP id
 el15mr14045430qvb.17.1602549181397; Mon, 12 Oct 2020 17:33:01 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:32:03 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-26-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 25/25] x86, build: allow LTO_CLANG and THINLTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
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
index 6d67646153bc..c579d7000b67 100644
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
index 154259f18b8b..774a7debb27c 100644
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
2.28.0.1011.ga647a8990f-goog

