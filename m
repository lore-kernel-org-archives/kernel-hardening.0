Return-Path: <SRS0=FjKE=4N=lists.openwall.com=kernel-hardening-return-17913-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F934C35E04
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B63A82084E
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xi2ZbcU5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B63A82084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17913-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3447 invoked by uid 550); 25 Feb 2020 17:40:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3339 invoked from network); 25 Feb 2020 17:40:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W8ajq15Euo0CBn6HLEY8Ur3IDCmQBKzronvmXuYJ1Wc=;
        b=Xi2ZbcU5w4xAMDBbk+3G0M7WhFEvev3QQQmayIYq12lXrXU0TZY00WT8V3tl6EBeFs
         4YY+WNru1RHx9Rtv7WI7GU9OFbC0kpv1arYQcLbeOtalBIzT9bzfvmjebvYpIQYGN0iz
         ohwXof/jSEC3zwPA+NUbVqZJ7ozto76pl8Tl3GYn7Wj0oBFcPxmvhAMiLDwhWBcd/dtK
         oQCsutUGRHGUPUXm6ZqfV5QbrWXnb7sD4ecMMfiyZisuKFBUhFGQatODjW3Cdm3VhZZA
         ET4mX4w5o/xHxsjJresFyuImLMlTwnQvGNeTqx3ZIqe9K0l8H2+6zMTkYnV/LRZbxSrS
         sfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W8ajq15Euo0CBn6HLEY8Ur3IDCmQBKzronvmXuYJ1Wc=;
        b=NPA0xI+ZEbkTC5Ntwv+e/bQjELzEB88oLX2GkymyoQWGpBCAXzdfuOfeEisE4EBiUx
         Z9bzOPgSBcLQ1jcHtTjk9lmk26NLKfsod7MJE79UAMS/eNfFIGY/bFVXHYyhhiMwe73s
         9mhgWFvSV9prdBEjA3ZttiK5LRbqqsqeku1kJohah2uUxpSsC2Tr2SShAfwFhZCjhnR5
         rIUA6UM0XpX4zR7gj7zcpGLNq+rR8EgWIxOes4g8iv1z2YYx4cYgtBhtnPPCurg1Eh13
         kini2T4tUfY27goHbrezzt3ztnTmhealqqZ7DXzu+kt5J+yWScK3UlboTMP7sNrePSTC
         R+Mw==
X-Gm-Message-State: APjAAAXvYzkR29mrnMoR3awV6SyBr7TiA1uqlAbSvK6DiC67G8SlPvbb
	AWa80e9mvAOkWAtna0CrdH+RDRw6baDR40iJEL0=
X-Google-Smtp-Source: APXvYqwvqENHxbX/ovgpjf0ZVx0mLlUs8H8QzWYeq0EOjlcVEkkcC9/C+tlcnWHubokdElLT2kLplCW3jEbNjcX6X1w=
X-Received: by 2002:a63:3207:: with SMTP id y7mr3943460pgy.344.1582652409047;
 Tue, 25 Feb 2020 09:40:09 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:29 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 08/12] arm64: vdso: disable Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Shadow stacks are only available in the kernel, so disable SCS
instrumentation for the vDSO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index dd2514bb1511..a87a4f11724e 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -25,7 +25,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 VDSO_LDFLAGS := -Bsymbolic
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
 KBUILD_CFLAGS			+= $(DISABLE_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.25.0.265.gbab2e86ba0-goog

