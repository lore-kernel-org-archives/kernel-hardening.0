Return-Path: <SRS0=OpWs=YS=lists.openwall.com=kernel-hardening-return-17107-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53620CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:27:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D5BE20867
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aAbpXLe/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D5BE20867
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17107-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32215 invoked by uid 550); 25 Oct 2019 09:27:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18317 invoked from network); 24 Oct 2019 22:51:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NgbC4P1sZEmAi9I2/zNK/CWQSp6FGySYAm217ZB/f+0=;
        b=aAbpXLe/RbgLbT8xZhWHdVHT5dVobTWZ2zeaJn26sqghxbPOn1hyEluoVbihGwnJVX
         2sTJh9psYEdbVqtTsQnDUiirU3rSIN2iObeBn0VoMtmhqDTjev0XrK4xkkn10yZ+Q0CQ
         qQieedL1ZoyV5sNvwfuRyibtlPJYdWaoMENqlRJtjyounO1D3aNGbT5HttKX7bqJFlrS
         u+E2xmyNlChGcwv1fOgwCviR53T0OUqe0dx8eBZY2CQMQV6Rlav8ylsfWoWPViV/AVq/
         Ld3MbQPgWXnLnAh/uLGK9oGnldzg5EGbJFlCuxu9E3FIX7DkvE5hrzoYe3FszpdHZXsU
         /Fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NgbC4P1sZEmAi9I2/zNK/CWQSp6FGySYAm217ZB/f+0=;
        b=Wri8Wkes6bbqbW0cZaa1yvXiifHs42+WeEGSyz/mhvIjA5WGdGaoUqHWNcNkBKyBaI
         WlIGL1kOufIrudSOQhX0Iw7pk5QOQgQyI9Ollj3BYcbqp488PW8MP4dze4u0zdXKeWgS
         kBDzWX4hAc1HyRx8UBLP4lYtM5LST+OhuhDpWXr5tB/bhVRPrsbjDtnHY9dc79uOIisC
         1SFd/6Wp7je6pJcbRwggMNL7/8jNZRQp0V38K7cHKoN5NyknaoZUA7+pPflfsGQAAoQa
         p7xAgiCQEsfPsT45aaMACUZuWqUS+1FLDvBhvGshvEuNE50hTEY2SWNC8xJ4prEUgGxS
         e5XQ==
X-Gm-Message-State: APjAAAUnZ0wMxH66hwuROACyJplvtVs2PMQf1JNn9hEiJZ9ushySe7p+
	qNi2NHTJlsUFfo8+r4/sF1lN99gV09CBqqDoT/4=
X-Google-Smtp-Source: APXvYqzw5xus5EvdHEIjmfQfA9wYtkvgKtcSQO5+TX3Njkn9NrtKNZdJ55itK1BRfXGS16EOOSbRdd4kdMnueWHGf1c=
X-Received: by 2002:a63:4104:: with SMTP id o4mr484324pga.169.1571957501557;
 Thu, 24 Oct 2019 15:51:41 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:17 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-3-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 02/17] arm64/lib: copy_page: avoid x18 register in
 assembler code
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Register x18 will no longer be used as a caller save register in the
future, so stop using it in the copy_page() code.

Link: https://patchwork.kernel.org/patch/9836869/
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/lib/copy_page.S | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index bbb8562396af..8b562264c165 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -34,45 +34,45 @@ alternative_else_nop_endif
 	ldp	x14, x15, [x1, #96]
 	ldp	x16, x17, [x1, #112]
 
-	mov	x18, #(PAGE_SIZE - 128)
+	add	x0, x0, #256
 	add	x1, x1, #128
 1:
-	subs	x18, x18, #128
+	tst	x0, #(PAGE_SIZE - 1)
 
 alternative_if ARM64_HAS_NO_HW_PREFETCH
 	prfm	pldl1strm, [x1, #384]
 alternative_else_nop_endif
 
-	stnp	x2, x3, [x0]
+	stnp	x2, x3, [x0, #-256]
 	ldp	x2, x3, [x1]
-	stnp	x4, x5, [x0, #16]
+	stnp	x4, x5, [x0, #-240]
 	ldp	x4, x5, [x1, #16]
-	stnp	x6, x7, [x0, #32]
+	stnp	x6, x7, [x0, #-224]
 	ldp	x6, x7, [x1, #32]
-	stnp	x8, x9, [x0, #48]
+	stnp	x8, x9, [x0, #-208]
 	ldp	x8, x9, [x1, #48]
-	stnp	x10, x11, [x0, #64]
+	stnp	x10, x11, [x0, #-192]
 	ldp	x10, x11, [x1, #64]
-	stnp	x12, x13, [x0, #80]
+	stnp	x12, x13, [x0, #-176]
 	ldp	x12, x13, [x1, #80]
-	stnp	x14, x15, [x0, #96]
+	stnp	x14, x15, [x0, #-160]
 	ldp	x14, x15, [x1, #96]
-	stnp	x16, x17, [x0, #112]
+	stnp	x16, x17, [x0, #-144]
 	ldp	x16, x17, [x1, #112]
 
 	add	x0, x0, #128
 	add	x1, x1, #128
 
-	b.gt	1b
+	b.ne	1b
 
-	stnp	x2, x3, [x0]
-	stnp	x4, x5, [x0, #16]
-	stnp	x6, x7, [x0, #32]
-	stnp	x8, x9, [x0, #48]
-	stnp	x10, x11, [x0, #64]
-	stnp	x12, x13, [x0, #80]
-	stnp	x14, x15, [x0, #96]
-	stnp	x16, x17, [x0, #112]
+	stnp	x2, x3, [x0, #-256]
+	stnp	x4, x5, [x0, #-240]
+	stnp	x6, x7, [x0, #-224]
+	stnp	x8, x9, [x0, #-208]
+	stnp	x10, x11, [x0, #-192]
+	stnp	x12, x13, [x0, #-176]
+	stnp	x14, x15, [x0, #-160]
+	stnp	x16, x17, [x0, #-144]
 
 	ret
 ENDPROC(copy_page)
-- 
2.24.0.rc0.303.g954a862665-goog

