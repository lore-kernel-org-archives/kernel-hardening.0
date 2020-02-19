Return-Path: <SRS0=JjUe=4H=lists.openwall.com=kernel-hardening-return-17831-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EC5C3404C
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 07D2E22B48
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YBtomVXu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07D2E22B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17831-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31773 invoked by uid 550); 19 Feb 2020 00:08:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30688 invoked from network); 19 Feb 2020 00:08:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jVKqEF9zEsFZTQz5E/s7PAlXyZsbPgu1MND2Fom4HAc=;
        b=YBtomVXuPE9YKWIcFgIRjcpY7OwDiCsLehztaXeVLAlEBdRDN03lZks7iNSYV/g7SR
         YxwyOOS2qE1ncX0EtkhevaGgA4eK4/d1kVR8Hg7OyAFSsLcG+8dnY5snFDfpsTQCIxxk
         Y1QycxeImvPDBmdy/cdMsuRQ2xS8Byv29lIb2/F1iUiQ5v3EISXk2V2SZMi7+fb/+sgz
         yIlIllB9gAQECO2n6q3OXLzyGO6GXq0pDWI7W3azU/OOkDwoEA2BZeS9Am6cgqPFhcwW
         o5TiUUKtIpgyX4x2xGMPYUpfPZtDjUB8KEwnztoM4IaZg/X+0h3EF1cv4rd2sQGo8WFP
         UaHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jVKqEF9zEsFZTQz5E/s7PAlXyZsbPgu1MND2Fom4HAc=;
        b=mgG23/axH+8mWUZpZTrd71LYEVnQipfeGb2Th3lPgk8T6Lh9m6m916QFfpXqqlTaLZ
         n205wpBNNsIE21yxdcotkPulVq1PvLdmfZCCZfOAhreInr341aPWctlQ7olRvbYtHn8S
         UtQMb/z6CGwf1y3BRJkLMnYTcW969KrvzCe5vbJjVUbRWdlsDG9GF63KZnV34yB4e4yt
         nMexiI2Cwy/RBGBpCe5BOhorBwhkmeESIRvbC5GXLngDUaTPywMmSLInPckTZZ4dcZMz
         aw5q6JayiqFgkXpwMuwx2zOpDOefqnUqPbZCEd40qeD2tL1YJRw3bY095nhD/XeI4jsE
         M/JA==
X-Gm-Message-State: APjAAAWtImacxqPjzYIaEJrr389prZ2yXJFO64+3uKcnvWknFmkwvTcA
	2a6taNhmeD2HCr/592ba6/3u4fg/Z3QsWmbNEpU=
X-Google-Smtp-Source: APXvYqwoqUB80JmAoZThMz7yQ2pLfU65+z1jN6RLHc1bXGITJSutpnUGpHwwmYx4HZQIhCgNm8jd0wWugPtH2DIPEJs=
X-Received: by 2002:a81:57ce:: with SMTP id l197mr19086954ywb.235.1582070924606;
 Tue, 18 Feb 2020 16:08:44 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:10 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 05/12] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Reserve the x18 register from general allocation when SCS is enabled,
because the compiler uses the register to store the current task's
shadow stack pointer. Note that all external kernel modules must also be
compiled with -ffixed-x18 if the kernel has SCS enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index dca1a97751ab..ab26b448faa9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.25.0.265.gbab2e86ba0-goog

