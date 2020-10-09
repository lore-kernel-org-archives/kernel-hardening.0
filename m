Return-Path: <SRS0=csc7=DQ=lists.openwall.com=kernel-hardening-return-20160-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AC6C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 098592225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AhkHxYzR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 098592225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20160-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10210 invoked by uid 550); 9 Oct 2020 16:14:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10131 invoked from network); 9 Oct 2020 16:14:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NB4DqWz6+fIfMXcokXEeMggmgfFph8OJ/Hk6TSxy9cU=;
        b=AhkHxYzRBPj/XJc+I+tSr0RiU0OcKXhG858USQ2XCMZuaxZyiy+g6jLac1sKgPZkmQ
         IpfxzQBVHjJbu7XyXKnwuU3h2iDU3Qo9Q9riCIuYsiJStNj7+zP6DobDo6JUsTt/uU5X
         sS/Ud4WqyktJlMHCohe00S3oN1qQnvtTIGMf5PjJ/AebsJSm5HJAmbK3jI1/r22MsS8j
         aBycGq29qN3837fJuinfVGidbF61PWBOcwM8avPXijIUbf320rf5bPez6o8eyG4GJcqo
         8GrTNB9eNsr7XmafE+UUkeoqI72v1L7GOJR8z8Dl93xKDV5FHpCenkhAfBV/XfH7Ojhe
         Qy+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NB4DqWz6+fIfMXcokXEeMggmgfFph8OJ/Hk6TSxy9cU=;
        b=FrmYNiqwhQSS87WK5/zuovE1xDSTGMXHToBgYyUsWkXB5ORXRnL3vKvJtivN1CWZLK
         7OqJH/VxyrqexM97ydFJulwym37/3JTaI8V+pnnzGIoTzDW+i6fhOd/3OV60dRX0hwea
         3S7FxlqmYbxhDcAPCvenas0Lv/WeYP12ROy9GbrHIuryd+QwKSohyZFE3aMOOFIX0amZ
         xWbrVH8UXIWCnbasbE4jtoIkjvWX3+5TJe/vgRbNQ+/ZNsNZgVh3G00JxpSv38p3cJ/l
         dFonAd3CNBfJJxpuI5EFgTN/2klvRA4x7YoxprQjH04e7DcLo2T2TajxhNJ4L44UvFFU
         J6Tg==
X-Gm-Message-State: AOAM533vKVnuPAERUo+rO+PcyFy183tM3kEyPff1vXqCtcTSLoGiHG36
	NMJYt6hIR7ZLqggyOD91oGxKlspjgnIr9/9sNrg=
X-Google-Smtp-Source: ABdhPJxaJS43CCLL31/jkDf8wz6tkxfGqxkaqI+Vp1g2cuChf4yD2OTPN2MaVCPnWOi9s9tnyrnkwRjGNGy9G2wlsVE=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:df91:: with SMTP id
 w139mr1273962ybg.13.1602260078214; Fri, 09 Oct 2020 09:14:38 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:38 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-30-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 29/29] x86, build: allow LTO_CLANG and THINLTO to be selected
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

