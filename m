Return-Path: <SRS0=FXXy=4H=lists.openwall.com=kernel-hardening-return-17834-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D448FC34031
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3142522B48
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MLtcH1Zl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3142522B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17834-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32671 invoked by uid 550); 19 Feb 2020 00:09:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32583 invoked from network); 19 Feb 2020 00:09:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W8ajq15Euo0CBn6HLEY8Ur3IDCmQBKzronvmXuYJ1Wc=;
        b=MLtcH1ZlIr7PYSYq8+bwS883i63QukomQpLx88iQ8Ty8/42rPP+4KZrwuMCM79Mm8y
         817RusRnQwu/CyF2v0uzoIwvRmOV4u/0FxSEzxKKHWOhb6hWWE/OAneX5bwh66Ly2qtm
         YznnnRzzbN7twHBbdmKiyRvpdhaN1RrK5afuCzULkJ+VvgLPqyD5AlIoiRGARJ6zxb27
         757p2uJ/BnnFVqtnpquh5ngNiJbA6U8ZEhhZeoEzcGA9JIw8t6XH0UWo5IOKMfaQpaYt
         /Cavrovjgq0ziUxvV0b5eM9sr9i7Vkis+NVpWAq01JCZHkKt55tZ+v/e09v1BsMjdgCt
         L+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W8ajq15Euo0CBn6HLEY8Ur3IDCmQBKzronvmXuYJ1Wc=;
        b=VEJ4Z6RuUG1PnqsqPPD6hwey73xsEepEvLIfuCMZ8dixYTL13BCRuYOCD32oiu610m
         j2osxuihy+zDn0UW/RWROeJJKGTOFag23CXXVdvjFyhJCifvJc0YIfwbHJ2R89IkKs80
         xc7mw9Z9FNdqOouW99/ZbiXIBjJ1Ojp9KawDcJujpHXPDK08/zQEujbzx+koqtN8jd2z
         KOQ/S7W6+2rJfwyEmyLCY8DGCeSUTc8LAGlGGBe4XzUrhssJMgAxyDvurXJmmW3qt9mM
         MjJUMfjZPb1R39pjYs5Avak8K6uMY3q+lvvUOA0z3PUAnndnp3aWYpD9/DssSnHzo45Y
         0HMA==
X-Gm-Message-State: APjAAAU/nQmPsNmUmdhcGN6PUhKIUemnxcyI6ETxcWTs6RLfVv51WtVG
	RB7Boyf1Kija1UG1Dsqr2qi5p3kfXnTz8UfNT8g=
X-Google-Smtp-Source: APXvYqxpK1u5TV7lBQJWCp5pVL1urj5uZ/qQ47DJf+mApduaTIPmMgvlpsKCisN08m+BtnDwSnTiPrPaReEndts1HUA=
X-Received: by 2002:a63:d042:: with SMTP id s2mr25008924pgi.66.1582070933662;
 Tue, 18 Feb 2020 16:08:53 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:13 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 08/12] arm64: vdso: disable Shadow Call Stack
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

