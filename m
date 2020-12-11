Return-Path: <SRS0=8JCC=FP=lists.openwall.com=kernel-hardening-return-20597-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AA6C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:49:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7ED622248
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7ED622248
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20597-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10104 invoked by uid 550); 11 Dec 2020 18:47:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10027 invoked from network); 11 Dec 2020 18:47:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=eJOu5ULB+j5PKw+BEEvH8i1sRvfR46/XAOq+5l8TcdE=;
        b=RNsVNk9rfWJRgJhnPu8tKl4xZ3XK+P117n64+jfeRxuRU7OckTxdduQUn0rQFZZJVK
         JY0s2ThPlJXNfuesUNy4qQ3uQ6VkP5ASRwViSOZDH9PEzNkXgsJJYnuOturiekfHhAnE
         BMGxOAye9LF6GlUS/cQHLsIHYbhoAlQO47vuBYWgWIh4Ce3sUs1MvtAQWZ5auUzCvg2J
         8UB/8N8jmyDbgRaTOfT2H7pMLqPElQFcrUWQGbre4Su0z5/Uw+grYzDeUrDo5GvOUsKk
         hhusYQkb2Divz4sMPZM0KcULhtVtRw12Nf2ssUpus5luGnVDa71D2rpr2EygAIXCM6As
         niAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eJOu5ULB+j5PKw+BEEvH8i1sRvfR46/XAOq+5l8TcdE=;
        b=Bly+4SICgdAA7eXBp0tuyT1uiFpDB/fovsFIBqb3ovASwYqtoAN2LkGyld3n2TDwLo
         UOxto3ftwom2IKfwnWT0sGFOvo2tq2D6U7JGqGJJ20y5YiYTu8bUUm711Cebqm1GyCQ9
         mlNpV0+HITkxtBxiIlzJyXPJzS4oaRxGOo0ncgM4vktGUn3J36qgcGV02iKnbgYzad5+
         O0Ogb1b5r4/baord3NM1onT2o7D5cdjwOMQFzxY7IOjqDywfx6ouHZEZXaankJBzQVkG
         xa75BwPtOX/ANXicmWbeYBljVff0PZq7Y4r5Yg8qRLkEMUpCdhmFgKGs6gPuQCWlaG3d
         QD/g==
X-Gm-Message-State: AOAM530zzcgzX5WoZz/V83LYPYY1VbqyVW88YKZRPOImGfoo5ZylVUv3
	C1d4GophRPZ5vkzXDba4T6nbX/BTUt+dpOBzbs0=
X-Google-Smtp-Source: ABdhPJz0jKgJuUJrOj0cvusE84eexhNfATvSYqDzbLZYuW/7NEpt0846SG0sYBvcmPaDK3dyaOg+yr9NP20UvvW2JLE=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:902:5997:b029:da:a1cd:3cc2 with
 SMTP id p23-20020a1709025997b02900daa1cd3cc2mr12248005pli.80.1607712425571;
 Fri, 11 Dec 2020 10:47:05 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:32 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 15/16] arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

DYNAMIC_FTRACE_WITH_REGS uses -fpatchable-function-entry, which makes
running recordmcount unnecessary as there are no mcount calls in object
files, and __mcount_loc doesn't need to be generated.

While there's normally no harm in running recordmcount even when it's
not strictly needed, this won't work with LTO as we have LLVM bitcode
instead of ELF objects.

This change selects FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY, which
disables recordmcount when patchable function entries are used instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a6b5b7ef40ae..cf7eaaa0fb2f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -159,6 +159,8 @@ config ARM64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
 		if $(cc-option,-fpatchable-function-entry=2)
+	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
+		if DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
-- 
2.29.2.576.ga3fc446d84-goog

