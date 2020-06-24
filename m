Return-Path: <SRS0=rUyx=AF=lists.openwall.com=kernel-hardening-return-19125-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F23C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 788F32080C
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZIaPVfK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 788F32080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19125-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2000 invoked by uid 550); 24 Jun 2020 20:33:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1913 invoked from network); 24 Jun 2020 20:33:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0gnBAHJLx9lqO/s+HwJkcFCIJr1VhaUKeKhoSxpNVYo=;
        b=BZIaPVfK4mM5FaEgiOXOWzMHkzLTbGkEfiJOtrAEFVfi2gebzUCHiY5apTLMtfHkTM
         l75+dKXwrfuQQVQD2stOWlndadQB1Zc6NUYn/q6QeMRTQnSqWTMGKUHewmR4G35OHvGp
         b5/SiArvL0S+A3ZHxVqs+VYlHjtrFUCuNx8i9CZCiQNeqcMm9dSVbAn39gIUe0DUghnD
         /f5TKe7Xx1FfkMjgZr3OsJkbEjKTvqcrDihZLf9/s8waWGOostMsdN7liEE23xBIKS3z
         6Rz9E3efblWhUua9EUcgFt56u58fIXV0W2fm5zALG7kNoivW4ApgaZxGRBArCosaw+co
         NR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0gnBAHJLx9lqO/s+HwJkcFCIJr1VhaUKeKhoSxpNVYo=;
        b=EZuh4TR4bndvmJPDz9Wy+pnQBFtTw31g0MEkube4zFtLELvf3XXZHwDAvLeAlua6y5
         MVAOgvKJt6tXRVBo2eA09stgDm/7Gkhe392/WmPaEqNeYyI5Z9cGHuiLa0tlIZrGCLfp
         q/Y8QqxSdjpWjg2gHBlgS37m5jI/7hg4HQazXk2hrKHn08viPyqsBf4dYiffxtoiXYvt
         eDN4D1C5cXw3QZZn/yz5OKLp2mFyr72Q2LvMOZ673Gy1M3iIp7apC5IU5le+/4fToOR/
         jqMg6Okc3INBhZSdcp6iuQE4V/ICz2efO6zXJHhzY1z12Rb7SYdIcUi4EjuRHUZWtKbJ
         bDNw==
X-Gm-Message-State: AOAM532EsFD3tLwlxkBZ/H+BF1irIYBAdRl2nbCAx0X0qniQVUb62ALF
	g1hlnT1R/vE4mBbHCo7z9xekRe8JMvVMTTweOmM=
X-Google-Smtp-Source: ABdhPJxTPJmHGzX5Q2m0yR96w4zaIPYDqCpLQon4kItXV3AD16e4+1m+5QFH8jaic4yItHA3V16FC+0hhVHCKPD3doc=
X-Received: by 2002:a0c:ec4b:: with SMTP id n11mr33232031qvq.103.1593030808901;
 Wed, 24 Jun 2020 13:33:28 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:55 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-18-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 17/22] arm64: vdso: disable LTO
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Filter out CC_FLAGS_LTO for the vDSO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/vdso/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 556d424c6f52..cfad4c296ca1 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -29,8 +29,8 @@ ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv \
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
-KBUILD_CFLAGS			+= $(DISABLE_LTO)
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
+				$(CC_FLAGS_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
-- 
2.27.0.212.ge8ba1cc988-goog

