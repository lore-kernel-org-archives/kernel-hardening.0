Return-Path: <SRS0=w/3+=CM=lists.openwall.com=kernel-hardening-return-19740-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D71FC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:35:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 836AF20658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:35:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufRzOZtY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 836AF20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19740-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25790 invoked by uid 550); 3 Sep 2020 20:31:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25696 invoked from network); 3 Sep 2020 20:31:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3q7TZ5J5xqKWdUS4X8SiQHdlDi3K3u69bSPkIoNlqR8=;
        b=ufRzOZtYYauSzvxZUBKz1JVbuUwKqmAJdSrdtsdAtyClxzQSdbUMjMfIMupNHjnLGB
         WO4ZqGFWI4GoHdfXhHBAF+P/jv072mNJPl0sQzhOhWjmxcDeq8t/wGGp/8OanND4USfj
         LhikjLiJG9jAk0+cvkHoOwClvc4d+s/6mEvmHU+7r2wfgvpCQERcCjQH7zsDH2517Ogk
         GD3ZV/LG3aSx/OdpXy0Szz6VTm1uw47NfsFGVYKWXK4IlQH2y+9jyGDbrxKpkAqRVQ6l
         TgM50rxrgjBcqFMaRVrmvkVprT/6WaCjwoJLbBtb5rXpbpl2VQ2HuV9qu5Jf7aVs2fRs
         o+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3q7TZ5J5xqKWdUS4X8SiQHdlDi3K3u69bSPkIoNlqR8=;
        b=WsNsQmYDrlFEQJYBfOajDw5zLHFBz3iZm35pVWfUpgbuM8rElOL75e40zfuzAxUoUV
         HkyxJINCUfaU1ugkQAiih12t9mP2tA2ErpcOejMJ2Sygub+MGdAHd3zsr1CQKPW64+PT
         05uFX7dpbDSYukS+HtO02bZ3ql3Uxuv1dhMFUjsQJVvEKo/Ca+eZDjmraTuyBXa532vP
         v9gxbE10KxVGDkfB+FKY0lScK5gbBp28IvhvMNy19L2raFfFB1Ekg42ohkuhQ9hP3R57
         C2VI1yNBrxApSxzbHOVeErGUShlloEbJxRb3IHpvacnqKRnVhKZKwcSV4fuFV6S8G8u1
         FTGA==
X-Gm-Message-State: AOAM531yDI6PfwGv7bv6Gsl8kJposkSiNs4FLBiiebmYjr/UKg64KWLR
	l5M2ynDTNvXSuglTE9xgZZA0RScN4rWOVVAZgoc=
X-Google-Smtp-Source: ABdhPJzSHh4NCUcdQaWfXuHL4xXV+3Gzu7YAUpxYnKR7xzXHL7k1OIFuYPArBmNIqbbqiPyK+SQbqhBjAf2rbEmrgrI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:6555:: with SMTP id
 z82mr6003281ybb.472.1599165098726; Thu, 03 Sep 2020 13:31:38 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:46 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 21/28] drivers/misc/lkdtm: disable LTO for rodata.o
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
2.28.0.402.g5ffc5be6b7-goog

