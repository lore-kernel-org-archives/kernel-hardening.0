Return-Path: <SRS0=9wDL=AF=lists.openwall.com=kernel-hardening-return-19130-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8197C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:36:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 084D92080C
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qDi1kJQp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 084D92080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19130-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3924 invoked by uid 550); 24 Jun 2020 20:33:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3823 invoked from network); 24 Jun 2020 20:33:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tvg1Fbryi0kMABLSJZV+2LlG9cMfXZohRvKr2b10/ew=;
        b=qDi1kJQp6Ay8PowzBhvgcAgfJKyEY22DJ3SehuRqjn/jA9tuCP3XgBFwyavVII/8H8
         +qDUOb2y6OKXwsbI5cxksI3QZk1MHXAA03OHDhdjTbrRcF9EMaP1PLIUJPhY0/usboE5
         WysdzKDHLGBWRBK078rHZqlAErXt2qVt2sq358db2q+vTaEhfb2Ztz8s+Npc56SUR/GU
         zam+aC0Fi9TXcLLkm/vCwtmB9CZFKkHlUgIzUuWu5eMrmtKdAXKTOQSgFxHw8mPgwD7i
         VrVAm6xkIce/iluM0BjvQMvc/W7Io0XF/CLOQ/Xz7mhbTAKzZSonAVtghl5cbcwT3k0W
         qRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tvg1Fbryi0kMABLSJZV+2LlG9cMfXZohRvKr2b10/ew=;
        b=t7RyxVawZXM1ppyYlvuVA1/ex/HSPilZ+TTV+uUpvoRMVt5rH9Is01rW1LHelEdyPf
         xNz+8hao3amplisFuYJj30vC9YKjsS2PAm2F7BzqGkcbdFre8YN0IX7cC1Z9IHJ3btEw
         4fPt26cziGLerfswW+GVYoKx8tFYFFzs8tSLE2jyTOwv2wQAreQTh/U40PC4cK1PiFmp
         zaQUgHXZ5Qr4YKaGeXCGm1dH+9iyWIZablJETjXtBb4zLdFEKES7rpFSFxB9WFi7rzZ6
         guUw583S9MgCa/jpQX+N0DAtXSkW6mNFs7q3IgYLeJNw/XYL8DgL+7xQQflCTsqVLj+L
         aS5Q==
X-Gm-Message-State: AOAM531b1RvFH5+RMAyDzUyr4Qkd/LHUlZH+EZW1on9wQDOQpFSU3qeF
	HSCjn09j5yKAMPHLlh0IdCHUtl62Aa7ZbwX/4AQ=
X-Google-Smtp-Source: ABdhPJyl5JOyQAzphL8fSerF19PzJDrN7smlmqxmskm8wB3636prwAzfuisg2Ek7D9XrgzzDEO8QBVxE0nwET9TpJnI=
X-Received: by 2002:a05:6214:846:: with SMTP id dg6mr31350632qvb.210.1593030818021;
 Wed, 24 Jun 2020 13:33:38 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:32:00 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-23-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 22/22] x86, build: allow LTO_CLANG and THINLTO to be selected
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

Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/Kconfig  | 2 ++
 arch/x86/Makefile | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a0cc524882d..df335b1f9c31 100644
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
index 00e378de8bc0..a1abc1e081ad 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -188,6 +188,11 @@ ifdef CONFIG_X86_64
 KBUILD_LDFLAGS += $(call ld-option, -z max-page-size=0x200000)
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
2.27.0.212.ge8ba1cc988-goog

