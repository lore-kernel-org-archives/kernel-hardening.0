Return-Path: <SRS0=AV8i=YS=lists.openwall.com=kernel-hardening-return-17119-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAD3CA9EBD
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 57B1A20867
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TyshMG/W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57B1A20867
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17119-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7869 invoked by uid 550); 25 Oct 2019 09:28:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19818 invoked from network); 24 Oct 2019 22:52:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hi8Cu8vAZVRE/aapAAyha6S0ojR+GJofj/wY0IAnOZ0=;
        b=TyshMG/WpQRZO3yfd1Jd7A98WjzJgZlz5cgBusE72nESHGI4zkJTacl+id0OgkmE7h
         AxB+37xlQQGbvIrPLJi6GGLKffKR50gyLvpF58DcjcVhAty/qStODXS2I8KW40lpQKKM
         9wmdN/xJ2SVmeGa9TxRYExC5/DHlRCQ172Z/37iBv0lPikJlYqyLfQHNi9002+g83EcF
         QnIjvisbAv9L9w1EDMmGJaW060fxbyUE3ijTJ/94kINWjZTBB+Ox25zv9w+isMZbiwl1
         KW/zlOW4yuPxJVvvypFUcVHmJ7bcxVD/QaQo/xACVHNXgM04mDK3oI8qkDfcIz4+KeCX
         PBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hi8Cu8vAZVRE/aapAAyha6S0ojR+GJofj/wY0IAnOZ0=;
        b=CaMql9DD4SF/pzCsBVWQHqay0Op0QaLwmz4XbMbUrUS4b+9u2h1RmyJ5Ay1nTR84M3
         7qFvbQ1nYHm07Tu/tvUCapDzPx9GNlb1j5PLgeWTDlLLFnuceNZdCw0AnUY6RPyRyhYl
         7RpTE5vX64dt9FimBj51G+zOT9eXk89Ui0uTXnbovWsuqQGkKj4H9RDY5sJtd5iiUCFj
         eUOxzhSG9b+Wi+pfHBmZQX5iLTmY9OUmwQmB+UWEwj8aaUgWLSnzx/Cc52kMcoZpGtZJ
         wM24727/KN6+blnsWYN1OI5RlKtU183O97/LBulfD0VyVeXcZdsPWN7Qh6Tw8RvXbU3I
         m8/w==
X-Gm-Message-State: APjAAAXGP2a7u1egd8Mg1moKaCOITOV8Gctw9AougPweSJEOXZPc1YSD
	ZyN183lqvgTDY3qdPIa1yj3CYaNotXwKzLD0Bg4=
X-Google-Smtp-Source: APXvYqzPFNEl9K3cGuhwxqWJUP7eMbcPYG43NyYUFqf8p2L94x9ufyqifykLbDRReVEDkpgIxS1uIAG4CEwVu64w5Yg=
X-Received: by 2002:a63:e156:: with SMTP id h22mr510399pgk.266.1571957549407;
 Thu, 24 Oct 2019 15:52:29 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:29 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 14/17] arm64: vdso: disable Shadow Call Stack
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

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
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
2.24.0.rc0.303.g954a862665-goog

