Return-Path: <SRS0=WB5S=EY=lists.openwall.com=kernel-hardening-return-20412-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FADEC83019
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:08:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2FC23246EE
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tgB3HeaM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FC23246EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20412-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3330 invoked by uid 550); 18 Nov 2020 22:07:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3226 invoked from network); 18 Nov 2020 22:07:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=tITgh0Ssflf3KIdl9iLTasR/nuysgEKXGj2aGzu0djg=;
        b=tgB3HeaMLte4FwdwEskpNo3M1G5NMSWdaU3NGnSytOclNILrFVdkD4YBIH/89JtDHP
         XW414KEtYQqChtXVzZCo6FESh8Tttug6ipG4Xwymb06bhNxw7eh44JTB82tQMjdgKeKe
         mvE5QooVVjUOl15f8Ufkoo4CuDQMkoEAowvId9Xo6ILJqfJzsuuAiniFNxOTXgItR15s
         eH6Dk79v+bV/G/7k27PzU2M0pCmQclWaJYIJjA3ojY/R+Z8tO+3QxQrtlIwXnz5RyeCM
         j8ggYjzxLirUlC9AaKsU1v+JkHXIBzxtLSTtx1qvPQUhEgNQSe/pESJS3QjFV5EMv/+O
         IZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tITgh0Ssflf3KIdl9iLTasR/nuysgEKXGj2aGzu0djg=;
        b=XzfZs0U3lAcponWdSSDuKB6mpVrf9ndRJzSDnmgqJxEBOE/PkhuWfQ2SGafGYzCCXw
         DsdwUFLk8j5/9WrF4tP8UB2GflTaBtmv2W5FJaDazg37ocCTQbU/YuM2ZDdnsKcAr+uD
         8ACtXsiMeC9NDXbac3/uQlQ0WYX3KzmIgL7HH8BiYpD9u/NgWkFRA60P0nM6jrEbqhhL
         fXhXVwS6tqlNz4WaDCMtcFXMcLkaOQ7cNOnAo6rjslJavLSFzLG2Ox2vfeqHfu6B4a5V
         +EA3zRHSQMgjfMHK7JywtsGhPLMSh7w0xCw/T85QW7qfd2d4LOCfFmoUt2dagnH+cVQZ
         wRPw==
X-Gm-Message-State: AOAM533W29xE2Elv5dwjvo6Pvv7a4QobHmlwMr2N+BLdu0iDol5PcKF3
	MVbzVsUg6J2830Ua4vWByMDeifsZjNzJ9Vp98Zo=
X-Google-Smtp-Source: ABdhPJyru6u4Sy3c6z545hXKz2Lse9yOurfwR7Sqj4soym8ldc5jriOTeAoDW2j8p87AYgdDtayu2H1jxl4fDBYzugo=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a5b:c0e:: with SMTP id
 f14mr12957716ybq.83.1605737265629; Wed, 18 Nov 2020 14:07:45 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:20 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 06/17] kbuild: lto: remove duplicate dependencies from .mod files
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

With LTO, llvm-nm prints out symbols for each archive member
separately, which results in a lot of duplicate dependencies in the
.mod file when CONFIG_TRIM_UNUSED_SYMS is enabled. When a module
consists of several compilation units, the output can exceed the
default xargs command size limit and split the dependency list to
multiple lines, which results in used symbols getting trimmed.

This change removes duplicate dependencies, which will reduce the
probability of this happening and makes .mod files smaller and
easier to read.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index eae2f5386a03..f80ada58271d 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -281,7 +281,7 @@ endef
 
 # List module undefined symbols (or empty line if not enabled)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
-cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
+cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
 else
 cmd_undef_syms = echo
 endif
-- 
2.29.2.299.gdc1121823c-goog

