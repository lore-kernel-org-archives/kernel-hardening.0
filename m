Return-Path: <SRS0=gErJ=YZ=lists.openwall.com=kernel-hardening-return-17243-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C044CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E54102085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJRBiSEs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E54102085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17243-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1552 invoked by uid 550); 1 Nov 2019 22:12:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1482 invoked from network); 1 Nov 2019 22:12:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xr3X122JfUZTOJ9HNPiJpW+Iyor6r4hGY/b4sjNxJZA=;
        b=iJRBiSEsCdhJICeToYTjV6/+ZJ3W2xifgYKJfjcL131hC2BB0cUCRbkywESPVzBlrI
         8VlR5cC+N7pMsU5+x22Aw5ne1YAMEzfVAV/3q/b7V7ZoG9tAVIz0AEgVSuh4hW3Zbj6L
         8aT4Az4vTNPYUadKRN4vE4k+cTQ9+QjgE+sNFrGD+oYFu80MiqRx6LYVU3nA2t8rpdAu
         rt0Xtr9hynaTlZ4tY88Emujp4zPpcari/k/MzTq60ei+HHRB6JOsgOHkUmAALjYf3xWu
         4VQzOKmPKCT2h1o9LllZnsSb98KxsZJ03JbNAV7PqwK8Ovk06fBR7TYZNq1DCfB0qZBz
         hFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xr3X122JfUZTOJ9HNPiJpW+Iyor6r4hGY/b4sjNxJZA=;
        b=psGwTNJYEPfDEVuCkiFXAahV0q3VGp9iWfSAyp2+CGPUci6PUpQ/l9EuulUBmVhnSA
         HVhUzZMyIL0YeVJ0NxPy3OB8qCxLYP4pcfsZHfDzatzkQ/h1pcxF4o3Vb0XjwiAlITBy
         HfQlD4MK0vWNjDlWc+RJi3rpF/4eXOC6b+RUaFVYqRqL3Uj0n4flYas+CMYTWDdfnYeN
         QV8HV3ZY41eeY1fanL1OPKpdbQbgp7tjkaNutJJv8qaRo6nvNiz0riLbR/S3y6jGRJ4A
         KRiJla1hIRUwH5w0egcWmwpNt5nnoH3qwOkTBZNcMu8NQG5+MeyUjcmfUZ0FNAqpYTvY
         LY8w==
X-Gm-Message-State: APjAAAWoyfFk+kPuA4nT2EVwlSjdr378QmIHUTbJeDtnc6Gw5YGLbwjL
	f73Z6zzNw7kvcH6K9ra9sPxIPqbtkg8SYy9i0zg=
X-Google-Smtp-Source: APXvYqyCFSFt+5MiVYAedclgUa3YVl6NHt+7PUMsEM4gdNt4exvKeZ9B7bS1m6sTTxVqCs+LwHo1QQUcaSTSyZAlU8w=
X-Received: by 2002:a65:47cd:: with SMTP id f13mr15511166pgs.356.1572646346250;
 Fri, 01 Nov 2019 15:12:26 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:45 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 12/17] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
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
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2c0238ce0551..ef76101201b2 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
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
2.24.0.rc1.363.gb1bccd3e3d-goog

