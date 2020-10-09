Return-Path: <SRS0=VmV8=DQ=lists.openwall.com=kernel-hardening-return-20145-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD05C433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:16:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3257622261
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pMlxmld3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3257622261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20145-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5665 invoked by uid 550); 9 Oct 2020 16:14:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5556 invoked from network); 9 Oct 2020 16:14:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=s6lKkOY6jDvHdKU5rddxnOybuTgb4UG6S62YgATiqsw=;
        b=pMlxmld3pCeN4EpXaJz0+y9pU3tNLKwKdw/i9b8CDTyxgJE8DiSfW29Yqq7JBGxWIB
         FizISS0KYQroQZpoFLdIyyXd3nJXztABchxusIHIWy/a5hTlIHu+GvXT0Dak2hzrkUjJ
         WdDihkdOX7Ym7zuj99eoOSHPUk9jyMbUiHTUVR+LB37RzS0xzmdJSExSzfdwPOTpRQqs
         Hko41qQefXDStXJ0wnIio/QOEBPHRUJpHfbdMUnPtDf8nIFrJGJsMuFTr7Ijuy+Rnr8w
         5Kje5MABXGYr93PTUo2dudN83/OT7+B9FnRT3xVgpuwDBOzLWU7bGc3luRAI6rm+jvP4
         I/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s6lKkOY6jDvHdKU5rddxnOybuTgb4UG6S62YgATiqsw=;
        b=hn5i4hMobel45UEs1UN5sAymomBrnxE1A5RDDylZPN7N8H64JeVdKdrqZvqpm17/gy
         A5ZVvYBY56JAgGo0rxycTKjF8xiG+X3z/S8INN7+/yFFg4ftE794a0KPXDED7gurJqEf
         5i+2cq4RqypFFbC7qRkV2yiBZjVs6M0Bs4UTYRfoUVIQ3KXllBNsAad5RClXOzXCUZFF
         5CTItEYAdqJZ+ki/CDiRwZwWYJfh97+KPM0oZRqzpnqFQ73mmKVUXTtLQr4x7HtfNNj3
         kXpQGBb1xQh00bs0EAR20P+hHrjOlxD2HhtIsWMNcEkTVACAjnrIUjNdsZET3/yPgXbK
         92zA==
X-Gm-Message-State: AOAM532y1ueDykTkdY74Fhcs7AUTvm5hgMb6Uwm/YBf5PUCHCdVNYqDT
	AXD1lEw29VWI2EHRxgPTZqZiVAar0s/xYm+N6A8=
X-Google-Smtp-Source: ABdhPJwtu7GyWiP77sMt8wQ3XooLL+aqopqPfkXu+lzFDvHaNiLmrCamv63yyVSFJX0judiLUpHLdy/ZvBz6DQjk6sY=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:52c6:: with SMTP id
 p6mr12101699qvs.38.1602260049095; Fri, 09 Oct 2020 09:14:09 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:23 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 14/29] kbuild: lto: remove duplicate dependencies from .mod files
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
index ab0ddf4884fd..96d6c9e18901 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -266,7 +266,7 @@ endef
 
 # List module undefined symbols (or empty line if not enabled)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
-cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
+cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
 else
 cmd_undef_syms = echo
 endif
-- 
2.28.0.1011.ga647a8990f-goog

