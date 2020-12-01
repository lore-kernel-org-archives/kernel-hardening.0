Return-Path: <SRS0=aAPI=FF=lists.openwall.com=kernel-hardening-return-20503-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA215C8302D
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0724320870
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lDxihdeJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0724320870
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20503-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20329 invoked by uid 550); 1 Dec 2020 21:37:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20192 invoked from network); 1 Dec 2020 21:37:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IAko/M6Zt1aSlSrXq3lDXb64GB1qle9I29x8xbslmiM=;
        b=lDxihdeJWmA2e6zRs4TGwE13O3VOmpH1sdyN7CY6HZcKARE8DZM0oCaAv6PGzLBfOm
         /ZsEq2PPIQPCS7MFloSyMFj7kgAkVbls55naobKLn/H//1ss0itsdOqec9UmTUefWOkZ
         OevqTXLVnJWnu1+9lA+fUkD3ZpM/Bc/Cp+H1CtYxrDQiJ2zLyi7mQrSw2Tg1RcvR5Pvc
         MD3SFVwZjAlr2nZrrAuw1JZnaw4C+tIlbEJxCUwAQygLAddc8jWwS1H6U4ZPPTd1zOuh
         GskRIIGrCvhTFuMt7A9YPnLuQPcn84b4pMM7zxhzZZSJJBkFobXmIeaBIWWVW35FDAmE
         F+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IAko/M6Zt1aSlSrXq3lDXb64GB1qle9I29x8xbslmiM=;
        b=Ary1p1fnxpDjgCVAuaf5I6UVOhQMd1az1yIg+9Lop5dcMO1s05PiS8iIhk3+CUFtRv
         grR0DRiK+Uc3i9OyyEsX8fnqxXexobwLfRcYjNxMySRS3zRm1DkDfWjcJjFZ0NmUKEaz
         xTLzr4Q3HTgHnbVXYTiGWdUF4aYmYJQcDOfTq6ekvx9f6AvOWC0znIFzYgSwe0LbdZ2G
         1gBEzGYQjYSCBSSu+ERYcMbY7hQbfHkYcBqLFs1oktsWoZVO4ABqxTSkWut8x67CSgx5
         wKMv/JHwKV/a88FsLD6weBIAVA1f+wW6IXBM7p/S5kDfr10H+u4Xh+SNT0LFTub+JeKA
         2Y4g==
X-Gm-Message-State: AOAM5323GMLMUprqf44sf2bH871Hgt7B4axrtEbrGnIcZcUFU9EObu/Z
	tWUHrjj7TUyxnhkf8hbVsxRnY3wisjUWuiuXG4w=
X-Google-Smtp-Source: ABdhPJyD/SxDjfpLtYpnbWVyCumboZuxaJdYA+0/Z6lOz73HHAOHqcYxLyKCh9v/FKkBiugIvNe82fBMfluge4BLrG0=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a5b:846:: with SMTP id
 v6mr6465998ybq.436.1606858667278; Tue, 01 Dec 2020 13:37:47 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:06 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 15/16] arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
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
index 1515f6f153a0..c7f07978f5b6 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -158,6 +158,8 @@ config ARM64
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

