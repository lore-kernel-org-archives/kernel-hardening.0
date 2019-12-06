Return-Path: <SRS0=M4XE=Z4=lists.openwall.com=kernel-hardening-return-17484-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AE0C43603
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:16:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8E759206DB
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3PF25I8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E759206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17484-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22421 invoked by uid 550); 6 Dec 2019 22:14:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22329 invoked from network); 6 Dec 2019 22:14:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ve3ap/e8LZQd2dbv+oe7rMBjURea5FcvbovcdBkDba8=;
        b=r3PF25I8b9gh7TGG4nyyWOG/IBeyi5leohyetpHGT7HVJVhKrS0Kq4x36qkr37xPQZ
         H4HOZxl0BVJe13eGlGPV1yZKSRRS5AmoOeRlUDllq58XEGXxaFeTrlkb9BrV5kcixQbm
         XbGbrkKiH70yhU3gMykfI079m4y0ZDpdOP7kIIKS/yBz18w4YMZf4Pr4H9aBR21ygtcB
         kY14G1EByPoZ/HSscjak3f91JNKl95S2IyZpSGv5MX3WaPMUnLjTgAsAI0PC749M53m0
         8RfjY0MYNA3UUEnoDTDY3HwUrUHVLuT76W4oleiH3t8Kx7xMLKek/nE2jk+/o2pgp2U5
         oBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ve3ap/e8LZQd2dbv+oe7rMBjURea5FcvbovcdBkDba8=;
        b=IZCveJKj7IoL9vlppiYf0cnr3lZC+6fP1yXBXdvV8MPCqWbdD5UgGHSWPWGqAuVJ2M
         qeUukEtrH9eEEiFt1zYz2hMLEyIyZEb6XRaOD6rKr15iVeTmKp7RA8tspxtKzzQhz9HK
         exXePcTuaq3xWTR25k8sSL8RsjdIvm0zJ4NPYRytBPh+5RmQVxkwHDsoVzkDFF6qeh9g
         W6yJ4J7YUNJnTtZ8P+zazQUEzwMR4QWAt1um/9h34v4kIoEbgxAsr47wLh/Tic0P1VyO
         ZarLGM1jK6vHzyEPpUTPE6Ili+0KJZTDq0zEQD0B26s/G15r4//ZsP0nuRZ2dZqMX3R9
         NcHw==
X-Gm-Message-State: APjAAAWa/b3M9zkDCsvKTNKWxADJ6sDFFtOezBVfnz5cs+MwLKg5Zapn
	N2yZroVedXNtoJhAmN1lJ6yK9Xa3WkQ3n9mO7ds=
X-Google-Smtp-Source: APXvYqwk2eRK+EeshXSfp5tSqqdwzFGqYQg2Gt1CoIRgkLdeR9mCxHtnbRaIQkXosCwRykWO94sSQGC7aLJzBhMw49s=
X-Received: by 2002:a63:220b:: with SMTP id i11mr6011463pgi.50.1575670466460;
 Fri, 06 Dec 2019 14:14:26 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:48 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 12/15] arm64: vdso: disable Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
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
2.24.0.393.g34dc348eaf-goog

