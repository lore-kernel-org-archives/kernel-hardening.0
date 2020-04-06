Return-Path: <SRS0=Mrkx=5W=lists.openwall.com=kernel-hardening-return-18438-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE470C2BA80
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:43:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 39D4324995
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H7r9/K1P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39D4324995
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18438-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26461 invoked by uid 550); 6 Apr 2020 16:42:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26392 invoked from network); 6 Apr 2020 16:42:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4apKHH+0KXGOaGE6jTeN52LWOcENawq8hrV28HQBrcA=;
        b=H7r9/K1Pb2jZ/QTf4eps8FXgNOwBjIplJ83GvJcB7p53k1kwhM1xPQxZLkgvAaK02n
         beraESPrDeb3MtB6jvklmi+/vUcZS4mHBB1OCRD//Yx8vijzVcAIERr2dp1g0QDMqGEH
         /HT1yD1mZDPSkJulcCDMMrG5W512OIw+DI+B5TIlQrfESZv1YUtu4bFOI7koPSLqre4V
         1GvXHs5lxJf7sNgG/FH6hL3WB2A8MbOLzhIcXcIuTXJy/+sRweQg+5SqJEi4k7ntmLnb
         VpUd6/DJobY+aRGS+iUjHZ3if6GvDWbplbrX5is0cinNOSMDE2y/gYC1eTqNbsHLdzRj
         P8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4apKHH+0KXGOaGE6jTeN52LWOcENawq8hrV28HQBrcA=;
        b=SySP/e/gvOd2n9UbOV0bZ2MhKlPle3XSXqwBMamb1Ck1imHOSLazlM2NokYPagTZBA
         rc//20oXQsMMzmek4X4ys63GJ/Q/G75AXiWGCofOTAGMFEIYc5/FK2EQVoV7JopPdaoI
         /RkiJ6lMKwk/uSHeZ1lkVeUKyUeMJxhZmI+kRLx0FfGnVrHEBjnwRQ5u0RqybfbdLtvw
         8uGVgVzM5jkC2BU/26PETJDccr8+aw+lFJrzwVjTtpLrBT4Uha5j889AT5ArEX9J61NK
         5k0uCPCa0jIB2LDzYUF5+Af1bAxhjH4bKdYOcqTrKVVIfSeDiuIygioFRJBYxPyk53QW
         UpeA==
X-Gm-Message-State: AGi0PuZzDWdor9dNzRTBz656YJk22/6oIcBA2Io1yKgKUBki2Ta2B1As
	bXdgofcVXILV9lzACR22sD+jU+/rOCfP4iZrESw=
X-Google-Smtp-Source: APiQypK5eLQJG4otrid1fZuEbwfLIfGLtaeCQl5ykKUwyTbJ+T2+3uqzOPYi+Sh8FFR75wCHX7LWfP4FZsjp9J54Zb4=
X-Received: by 2002:a63:9043:: with SMTP id a64mr22525247pge.308.1586191316557;
 Mon, 06 Apr 2020 09:41:56 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:17 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 08/12] arm64: vdso: disable Shadow Call Stack
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
2.26.0.292.g33ef6b2f38-goog

