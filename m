Return-Path: <SRS0=HWXR=CM=lists.openwall.com=kernel-hardening-return-19741-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BDAC2D0E1
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:35:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D4E8420678
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foQd1ccG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4E8420678
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19741-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25970 invoked by uid 550); 3 Sep 2020 20:31:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25871 invoked from network); 3 Sep 2020 20:31:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=gZC6Tdrs+v21YOKu6+arkvfjaZ3DhZrnypdcQEca1D0=;
        b=foQd1ccGGkpo+boEYd5oWFvOEqUFsLOsw7HcQjk7CIRbm5LCTNdOl5wa0EML7/VvYr
         hSLaVdQouhjHuUbPo9f+4M/xtC0IJ15IspdRTNtqyRPgMX042InznCYV0QaqUuGWaZhX
         yr7qh5/zqONdjl6THb/gM+tHALShdMZci7V3798taH3nzPLYknSe4WOZdF55ISWlVC3u
         oLyB9I0hC5kzOIAog1H5BSrk+Esklfb706f6Xf7yzVXsjl9ZpU6T7CFpRH7UhCjFZzfF
         BO8x4gbp7vwKwvsRhpfOm93Ook2I3FtazoTsJN46AzCHKk4H0tMI+BnAuZN4NELK8Mrk
         NY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gZC6Tdrs+v21YOKu6+arkvfjaZ3DhZrnypdcQEca1D0=;
        b=o5GRCfNpl/oJHB5if3KRNQaqezNlZpySyRO+ymmhFgd+8JM/+iAb8nBOSy9kf+WhnW
         Zq4Dqmzv8GvM/p2uSV7NaHScUicWjCs+L0rFws3GGFrwBzKqOXYjRKevEH3V6vLu1dVD
         I1FxDnHNcqWKbNlfmA7NW1Qtgr99UaGsoqcsJkdALIENbIRa8T15dmfQzFW55dd/Kjl/
         r67gsPt2rZgeHeeHzesfyqBqI5ZwuhjBLQEeWDI/hdTe6I8xUoT7gBrwnc9gNBIpl/1o
         PGn6HEsd8uBMnjbwAlx/COvsjcLKSazLggHJ/krs7RRY9LP+6S+z1pFhCjPvEeuMfIei
         fU5g==
X-Gm-Message-State: AOAM532SZY+lygd4C6UEhw7dc/j+TOmLFy1gWsH7VymgUXDd+QdBq6cZ
	corQdEUE3YRQe7QgZDKSuzkdLnq5rfb4W6taVr8=
X-Google-Smtp-Source: ABdhPJyXSwgng3rbQFnr3rvYfakxH4HxONln41kDPV0y/dTw4tzhlXUtl0E/eHCkBgnTPRrKKknIT40to5VxsCjgMHM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:d84e:: with SMTP id
 p75mr5687011ybg.94.1599165100560; Thu, 03 Sep 2020 13:31:40 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:47 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-23-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 22/28] arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
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

Since arm64 does not use -pg in CC_FLAGS_FTRACE with
DYNAMIC_FTRACE_WITH_REGS, skip running recordmcount by
exporting CC_USING_PATCHABLE_FUNCTION_ENTRY.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 130569f90c54..eeaf3c2e0971 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -127,6 +127,7 @@ endif
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)
   KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
   CC_FLAGS_FTRACE := -fpatchable-function-entry=2
+  export CC_USING_PATCHABLE_FUNCTION_ENTRY := 1
 endif
 
 # Default value
-- 
2.28.0.402.g5ffc5be6b7-goog

