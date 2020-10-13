Return-Path: <SRS0=fMEU=DU=lists.openwall.com=kernel-hardening-return-20194-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D05C433E7
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:35:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D021A21655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XNjBIDIN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D021A21655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20194-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20002 invoked by uid 550); 13 Oct 2020 00:33:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19900 invoked from network); 13 Oct 2020 00:33:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=BiHYmAAiH626N89XqxkZXfyE7gUyoYuU5gV65m3nGjQ=;
        b=XNjBIDINKT2pRuTcs85XqtGqpKKB5NK63w4IySiOIysYaLEiPBkXTqBpHa9k0rcANP
         Mq8luu8tR+/vZGjuz5FWZqlrWlbhD1dsrCW8kjpnk6Of8lm3Uq7bjBxMFSPhYIwpNkRs
         wzxAjEDJS3JTBUI9Rc9q6CxPrCEE1D+TblGGgUcWZ9InruHmMULIEq8MSFdie4O9SeCJ
         CDrDZvBBKT7r3ExX0KMrO5Td8OLZ31CYqJR7Va6pe/bqAPf2uWlcxTyzqGmJpNzT0KMv
         wQ0Tg2BqZiU27oj8+ptgF/4aA8HHcfJ5uqYDxVmwrvDxTkUyV923+xAgmlUuAFczliXV
         NdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BiHYmAAiH626N89XqxkZXfyE7gUyoYuU5gV65m3nGjQ=;
        b=ALmqAGm8KClu0dFISzIJtyT6epH3DlxcOuTMvyPDbLn1SJUXTvUBVFPMVJwDyy8ES9
         N88fxbTLaKLNdP6VP/bFrECUlPt39r3Pv9OntNEicXA9IjqLsZoMEUVxRp8bKDN3W7Sp
         xdrP4TwGeaujq9vuTwZX48IeHT2qeUEmUfPlfhJDJHYQ99dxB+BXDdm4Q0y3g6goMW+N
         vnmEhm7DR8RNiHNmp1rUGtxvTkA9pebhHIQG48vyZ9XfQ9qbjlyER3+IUZsmN1W2VYok
         1PBTf71J0xBaYsCLV4GjeumiWJ3wR5n1QPoSznsXfklvtZXEr0oKIrIS/jRmS0UjX1Ou
         6/hA==
X-Gm-Message-State: AOAM532X7XgJiddhSby0ph24iTrdyL08joEmnmZRYOVudZr7H6fUkZcb
	mBmR27NtzEpQ81zDolNKPufGjx6gk1xLDpV/dkQ=
X-Google-Smtp-Source: ABdhPJw5yrP7SHcc7TWSGYuiAJWigblY6T4KARgQjUPREPTC4jVDZK0jmnjuyAbsgm5fKdwKwlLo7kamaFSoW1+wZMw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5747:: with SMTP id
 q7mr15646088qvx.0.1602549172707; Mon, 12 Oct 2020 17:32:52 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:59 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 21/25] drivers/misc/lkdtm: disable LTO for rodata.o
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

Disable LTO for rodata.o to allow objcopy to be used to
manipulate sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index c70b3822013f..dd4c936d4d73 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,6 +13,7 @@ lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
+CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-- 
2.28.0.1011.ga647a8990f-goog

