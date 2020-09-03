Return-Path: <SRS0=ACms=CM=lists.openwall.com=kernel-hardening-return-19733-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1194CC2D0A7
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:33:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5C39520658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f2KZmcgY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C39520658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19733-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22226 invoked by uid 550); 3 Sep 2020 20:31:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22154 invoked from network); 3 Sep 2020 20:31:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=cFYZU8yCmBPQlyxKhbN3fBJPGbsM547TbMqCUcHgNNs=;
        b=f2KZmcgYz5Ysbx7BF62rI5UJWOS12FN6N90Amy8wNR+g9fWhhBQkZa5CaKf0dS8brC
         6Ro6z+jEQSCS3MWX0kosxP4fsqH2/+671H0FR2hgia8WGh2l9J0fRbxn4fS9LBIOcqsn
         cfg+hzRqGFg//tgcGlbiaDXIBOoDoqEGBJdWHQyzr3ofan4aBNcv3L8cSwT1RQT4lXSp
         Mo1JKD3ynQ9gHpI/aTI54CwV746sFqsVOEhvOjmNc4OgLhewoJ13I5Y1xKy5epce9McN
         +zMfVllNIuAdNq+xsrw+qbjhr6JPUJISf6N/sMIEsTKdrYvLhzy1RmEG8RGpVVXx5zt0
         mdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cFYZU8yCmBPQlyxKhbN3fBJPGbsM547TbMqCUcHgNNs=;
        b=d8boDy9yaj8GWONiTq2EiDizzhv21E+vQoiH4Wpw/0wFpZ/slBtr7Fd23KkmfuNfXL
         AU7OethXp0XhEyDV0iCvuD+WkNW10912WTENttd9mG19IbIwYLBdX8ROzeFw254ZLBun
         lfD0bgnBdgguaco8qlj8EDWdJzLKREk6LrVAlR2zO5qzxvBdHwpgEfva2vrlzeEyizr7
         WNyVq8Jzsy+cUn5hZWkKdIf0ch6DnHFmxKKE/drOKHIxQlu9zxfp1ZoZTrWYoYwKjwzl
         LJk7XhpUML7ziLEbqIt+fGeyyQfNBnS2SSnH/PRHMcUyyBEBMXszxxKIEItkE4CM3LMl
         yJNA==
X-Gm-Message-State: AOAM532iA4OPCvirJQbOeQYt3a2CVMJV6AnJAuZbi4HXkxQ9Bms8PCXw
	79Om1g4/Cwhfe1GYz1XDZPILALUfGld4+468WmY=
X-Google-Smtp-Source: ABdhPJyzhYZs0Vph1w8I/Ma5DB61AQsRFG4mGPB5xTJWndGiIvzc18vAFQNXB2O/jZWPV1Ikufh2xpTXWWNkBkMFMaI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:ba8e:: with SMTP id
 x14mr4773039qvf.23.1599165083400; Thu, 03 Sep 2020 13:31:23 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:39 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 14/28] kbuild: lto: remove duplicate dependencies from .mod files
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
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index b8f1f0d65a73..3bb36b4b853c 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -286,7 +286,7 @@ endef
 
 # List module undefined symbols (or empty line if not enabled)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
-cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
+cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
 else
 cmd_undef_syms = echo
 endif
-- 
2.28.0.402.g5ffc5be6b7-goog

