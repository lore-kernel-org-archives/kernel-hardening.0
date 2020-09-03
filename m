Return-Path: <SRS0=5cIf=CM=lists.openwall.com=kernel-hardening-return-19727-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96539C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:32:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E4BD420658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ILcqyCFU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4BD420658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19727-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19993 invoked by uid 550); 3 Sep 2020 20:31:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19882 invoked from network); 3 Sep 2020 20:31:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WN8mpXa+HsW9fsZYTOAsBdC0BrDsnoqsIhb4CRQsjoA=;
        b=ILcqyCFUuMNmm3B95VxDju+nky8Uu+qmaPpzDRj3rzSs7wdq56m1nXOOYGQRh5j+ez
         GoI90TA6FVXFOlD755AmSb4/FNzaT0VP8lOAy6uMYZFFLJuqFJVL9bJwWTH9E0GqtOEo
         al6TkePRlfFId/wWeLeyYEgNYfWQP0oNFVpXgW52difahcSd5ZTRotEOB0pRrOx1IZXM
         Cnhj1xtZcbRHwGgTBVkZm/DFy5pa62h5HdpA7rjM4Z4R2IFE8nWpVFD1OTUXwGK6Fy0y
         CR+ahjyBXSSb5EJ1ofWh2xFjBel7zKuiBnOe86gBc07OTZ6uirMoAkpdrWgxZ4RTDhON
         LYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WN8mpXa+HsW9fsZYTOAsBdC0BrDsnoqsIhb4CRQsjoA=;
        b=ra/4icjUxSe53ZQUYygoV5bIgsDZfid/L/yVj7dVZ260nfm+pVPqRps360wkKcHa7O
         4tfQJJLQe1ROBY8ePYmfdNruYidhqudHuKoUJBPWHFsKnVWK+Mh4dJm9oyujjRbdxYWn
         0YTX9kXvWy6CDDPSv1UAbTM+DM9O7Uyeqg1wH+FC/SCJYTtnv5DguE9oRgfNzS1kMWwD
         nLv4qX3dfNlTYz+gXenaty77FOagnUPKvVfFYaz4D5LIUowMALnRMU9wXWMTcBFzrODL
         Rgi6JzR5owdsKPzh2yUJU3PZ4VOlYkC6kBNozRx8OaAu46brcLAiMH7igIx/4M5G+47n
         lk2w==
X-Gm-Message-State: AOAM530UIzZ7sR/RUtLgqYDoroL6OWL25z4ZLjtKyQTO1+ISbhNJoRNq
	l5Di2p15Lv24aZ1GjsP1zLr2818p5Z4NhXqXFIE=
X-Google-Smtp-Source: ABdhPJyGVWrrLe9OiHn6gBlDgaN9mhbz1XtS93UGhLaXNK12eKqdd07FdIpOk9xvfDGTdAf7XwfZllDsHPKhawlMPg4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90a:d512:: with SMTP id
 t18mr1126739pju.106.1599165071359; Thu, 03 Sep 2020 13:31:11 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:33 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 08/28] x86, build: use objtool mcount
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

Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
objtool to generate __mcount_loc sections for dynamic ftrace with
Clang and gcc <5.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7101ac64bb20..6de2e5c0bdba 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -163,6 +163,7 @@ config X86
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-- 
2.28.0.402.g5ffc5be6b7-goog

