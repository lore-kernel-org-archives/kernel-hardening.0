Return-Path: <SRS0=vIgM=C3=lists.openwall.com=kernel-hardening-return-19932-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9821C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:17:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC86320684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mPsAHQEX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC86320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19932-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19951 invoked by uid 550); 18 Sep 2020 20:15:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19865 invoked from network); 18 Sep 2020 20:15:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=H5U0Hz5E6z5ldjvQ4xJDZFkCK4qV/McKETGlhtu7sL8=;
        b=mPsAHQEXqvNlGarzu6iBRQPA6ECa8TLJT1//z5ygvSXXqueGgBTsUBMgdhH3MoF60t
         ZhVFIxUiDXEpZ89jhGqvkk+xwepAhB4h8zd+bjJyvbcb5izzUs/Tg/9RldZdUROXbjeI
         BxVX/BdnoiStlDzxH6+NO+6HwWWfNd4qZM0lZORWe65ACPTad8UErkxRWB5rEkhp08DZ
         0KGl75iSGd/JKl1QjNefLbTEyfWqmsoCEu++j8qCHyYi8XPRYhVdpn0nAEZ8fdky4y7y
         S1k0KQu3X95IfiUivguLiKYbpdCh3C48qnuiieKQ7b0xjFzd4Be04GxhMxIhkfZAaqOO
         4wGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H5U0Hz5E6z5ldjvQ4xJDZFkCK4qV/McKETGlhtu7sL8=;
        b=uNNqu+z16CWF3KO9JOPHTfDUR1gd2kt/MtkEiUiOGPiRRTBkOcrpewxt+dfAjffyPn
         ktO7rxiv6vb33E4nFMxs3uIQaMJTF3w0ZSmi2XhLMOZRSBerMVv6nf4qpqkRE8wxiRZc
         AHMTVmm7fjoNOisNXytHxBNKaKYWW4xvJuoKUnLVe6lhrWVoBS46zBUxqSRsCVgmG8Ww
         SwLJVuxWUhSl7BPHBd/IyolL6HoBluV1gyTIm2K+tLGonXkwIhsvtqpontLu5+Wz89E2
         AODhGukfUd8HTyFLp0I3NJ2IM3GRAusUpCLq/wl+weLOoKjaye1JMNrOApQ2l9wh/yaw
         n1rg==
X-Gm-Message-State: AOAM5315bES8UKZjtIZgO/7+RkJ0doKUvQcVC3sRKfWdYgiZCiVZ/REo
	nSWyb3QTYpRBNZBsXMBQvK/7okwyBfeCcMqWBP0=
X-Google-Smtp-Source: ABdhPJw8z6vjGGaGGnrlRrziyohZvVfic1DZGt/qPzbkK2DflW6NVM+pA6gyTB+Ke9wzzcJbF1DtstV10V20omnh/NQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:47cc:: with SMTP id
 p12mr34218336qvw.25.1600460116095; Fri, 18 Sep 2020 13:15:16 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:22 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 16/30] kbuild: lto: remove duplicate dependencies from .mod files
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
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 541dbe791743..b417c697536e 100644
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
2.28.0.681.g6f77f65b4e-goog

