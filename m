Return-Path: <SRS0=v2re=DU=lists.openwall.com=kernel-hardening-return-20187-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09484C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:34:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3561B21655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CfMw3Lf2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3561B21655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20187-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16070 invoked by uid 550); 13 Oct 2020 00:32:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15963 invoked from network); 13 Oct 2020 00:32:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=s6lKkOY6jDvHdKU5rddxnOybuTgb4UG6S62YgATiqsw=;
        b=CfMw3Lf2RqxuH1gK/LplrUVdrli+0+CHSSkm8IVXoxiERluD9UBxqoVgGLYbB0zcGH
         fcd+f/qjElRp1j6Jdey9Bh7NDBDe4hB9i6yurpQFinDV80y/ezy2gjJtTugW6x9+TxXB
         lOD7ufXL8OAxIH+6uzRqxS9SQox8gQ5U7CudTH1hC4sfe/ktNYfAhjsreZIIFTMjFG1C
         RQt8+AhPqYKsAgf3F+x4HsSqm87l4hiDBx+TxXtL+Ap2+aCO42F+hEV40MZGJK2CkBo8
         P4FhwGbSHoh+MmiJ53pkyum1T4qHIVaGpa4LSlzx+7mtM5okXCbjhUku3Y3pd0VFE6Pn
         ksJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s6lKkOY6jDvHdKU5rddxnOybuTgb4UG6S62YgATiqsw=;
        b=nb7iYcSB3s20sJFSsH82nxWiq8Q5EmlJs+m7zPhdYjbv31ckVQorOYCxYeC843KDXR
         kNnXtfUY1IkA++lBr2gDI1Ag1PGk8tCLFDeSYAYhpug30misS0QGEidcYkye9lmPfdfZ
         vlAm2pZJO+qJ6oRTWG1rpr3LiiIIQK9GO6NZQLXPw5wRIGKc43TaYBsl6tUZGLUDaZBb
         +Tq5pwwuxyXkgO38YOuABuvOeNCmzu9pcNmRjrNjvV3GH1jXWOdJ6wIVXBVzLJsXKHxl
         vfYwqVc9r6nH3Lz1sw+yzrlI/vfC/ZquKlBFLDRgJzYXIgPhlwcIHOCZWPeHIum3Jqa1
         DesA==
X-Gm-Message-State: AOAM531xmHpOr1gKVwCpRRAE7YOkR6QCkcO9UlLs5iTB2DBQCJGxR5+u
	SSL00f7FOa0riEvQJ4Fu/RwymRX/selAUfuHO+o=
X-Google-Smtp-Source: ABdhPJyFxyU35wX46NP9k8EgBAnMCUQ4LjUrf9Ha6HBecKs6BME4DjIGIM9k+HTmfXPW/UAyVK3X9uWCjK1Lv7DEg7U=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:aa7:8492:0:b029:155:79b1:437a with
 SMTP id u18-20020aa784920000b029015579b1437amr18970192pfn.26.1602549155518;
 Mon, 12 Oct 2020 17:32:35 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:52 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 14/25] kbuild: lto: remove duplicate dependencies from .mod files
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

