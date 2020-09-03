Return-Path: <SRS0=b52T=CM=lists.openwall.com=kernel-hardening-return-19744-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49353C2D0E3
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:36:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A258920684
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WYxR9JOX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A258920684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19744-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26598 invoked by uid 550); 3 Sep 2020 20:32:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26508 invoked from network); 3 Sep 2020 20:31:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=cZOWhnp892SUnLhqC+1TPlOe8BVqsfDWwTFGwwryYEw=;
        b=WYxR9JOXeqHMLp90nNI8/6ltDzhvsuYjv6d1zFqp8zsjL+qJYufybBNzAbPMTkNNZl
         D7MpSi0LlP6FuYPjz4u35DCi8t432jxAgU18y16gIeH1WYnR8Oge5r65aJHFkr+O6ap5
         7Jb4/kJwsklpayP8Ru/q1xJFOJRx54JFuZjQSOGJapmUtPdOP08d8KZWkeRlM2D1Swzv
         SnITw4E+gwFNoLz9DvBEQEulPAjlW7Re+DfF/dU1eZIdgljsqQSczq8cMfTFPUsSyciF
         mvuZnj+9HqmA+LFzkWAsNTdETxPd/fZaNFdn6zEOPF2B4+IaWN0xMyzjF9d7hiT6GQ2b
         54pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cZOWhnp892SUnLhqC+1TPlOe8BVqsfDWwTFGwwryYEw=;
        b=PTUmwWi1oyCs2/lQjWKWtkhFT+Y7l/8XzaHK/znULwSnHJ0vc3PYy4Xm+y984LaZr/
         83Da74VtDW76Nchi4WUArYmFFcJQeUI3B66flO/MqZ+cOmmTHwQ0CKKcHys2uw2Ny82L
         CCwjmlGAZyGhGlo49OnLt54NKhlv2FGk0InqjcsUvsD/FGarRsBZrzeP/iqVCZU8OT3x
         A1+0N6OYTtOfSlVaYlSZ55FtJgR4ZihI09xBxXDCvjq/4zkZzXnJ3qLI1gAfQq0acflu
         kwaBi3u8h+QQkiq147cQfCY70+TVnsairjyfJHOwc0LBKbz7+Qm7vW8dH1G55xlLzNi/
         2TyQ==
X-Gm-Message-State: AOAM533k+l6G1w/55EXRHPvrWSBmI6qvSXmV3I0w9LCApXJU7e72zzZA
	13u+vegiQ7saMNArtoO76aaCI/DGzm1FnOhnXBM=
X-Google-Smtp-Source: ABdhPJwa626CxZJt6X6ejRxk7e3J2MLsFDDgC11k4AQQkijvXAVNZFdD5YlGgxxeK9SEt/5A/DqexW+VRmPulFH2V5w=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90b:4595:: with SMTP id
 hd21mr720735pjb.0.1599165107467; Thu, 03 Sep 2020 13:31:47 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:50 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-26-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 25/28] arm64: allow LTO_CLANG and THINLTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
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
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d232837cbee..2699fc5d332e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -72,6 +72,8 @@ config ARM64
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
+	select ARCH_SUPPORTS_LTO_CLANG
+	select ARCH_SUPPORTS_THINLTO
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.28.0.402.g5ffc5be6b7-goog

