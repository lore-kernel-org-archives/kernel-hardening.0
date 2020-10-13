Return-Path: <SRS0=vgeD=DU=lists.openwall.com=kernel-hardening-return-20192-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0AFC433E7
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:35:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D620B206B5
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bb3nDFzI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D620B206B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20192-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19460 invoked by uid 550); 13 Oct 2020 00:33:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18324 invoked from network); 13 Oct 2020 00:32:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KGusc3+RBCNZzwrkW+3708RrOouUa5FTnw8PnBTY3Ig=;
        b=bb3nDFzIx4qOjrAxOJ2W8KlT1MSwi986POJ9cJKOfKNUvRnVD7cY4Jz0mSg7MRPV0m
         lXGeie9Xx5DffV8Za4XM0+PkCWp/NCEYvBCpL7dbWdrPNqfhiC4UEsNhLdH9WWLRAVhu
         rBrRJaB7DNAvuCtUjCRM0HtqGKgpYPqEp2T0+l16BlXpPCOzksZ+AJZoofJNI/IPVJLU
         DGaw9KsaIO4EuTukInDUjt34kVBq5g8dbh3CNbZSE7P38c406JgXNG5VZxPiK/gkKrw+
         oQSbozkgWh9aNk4C9mJf/hcl8a66+ktKY02krWk3JyMwLeJ56+gSghiqZIoBEYDSxY68
         9P+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KGusc3+RBCNZzwrkW+3708RrOouUa5FTnw8PnBTY3Ig=;
        b=UVqR6U2XJEtaNkMC/xJNM0Gpqc4jdgR4dPQDFPQnwMur/qo1xUiSZkzfTaeLdB4rJ1
         jCGIp2Ittu77Uj0zMUlV09aRBpBIONZfwu2U4VJzKP9L79hTZvI9QXdxHb0qkd75wwIg
         HPXZpRw+KTPavg3vm9B7r264xfurN+sVjOyqbWOUBVCp/oBPD4s6spzbLM6d+Jk3ZlHk
         XaXuI57WejcH7Bk3c43xKsgKp9GohKJBbddczpGc2T+Mv4UnGcGDYFxQHPiBfLhgKQIv
         fiJkXURerB4FsBQu51kpaNfK4yh2re65ftvJk2CePcYC8+2HEDI6OygYOVQ7+3APdKB0
         GL4A==
X-Gm-Message-State: AOAM530yxC3sWU3G/GvycsqGKov9F5gFqHwt2Pzh6hkhhGxS/+kWbJUS
	EDDv4puONz4l/mz0CkXZzh79gIecjpYBECuc9NI=
X-Google-Smtp-Source: ABdhPJxn7XFZrqOn+1+G64/SnDmtkk1LEUGGMAzLxs1dl5s59vyoJo/OwiDLBmXb5P310AefkBc1vWcPP0Py9wbvJGA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:2689:: with SMTP id
 m131mr35046414ybm.506.1602549167733; Mon, 12 Oct 2020 17:32:47 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:57 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-20-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 19/25] scripts/mod: disable LTO for empty.c
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With CONFIG_LTO_CLANG, clang generates LLVM IR instead of ELF object
files. As empty.o is used for probing target properties, disable LTO
for it to produce an object file instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/mod/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 78071681d924..c9e38ad937fd 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 OBJECT_FILES_NON_STANDARD := y
+CFLAGS_REMOVE_empty.o += $(CC_FLAGS_LTO)
 
 hostprogs-always-y	+= modpost mk_elfconfig
 always-y		+= empty.o
-- 
2.28.0.1011.ga647a8990f-goog

