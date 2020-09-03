Return-Path: <SRS0=m5v6=CM=lists.openwall.com=kernel-hardening-return-19739-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2870DC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:35:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7B57520658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:35:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="npSffdai"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B57520658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19739-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25622 invoked by uid 550); 3 Sep 2020 20:31:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24491 invoked from network); 3 Sep 2020 20:31:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=iN3GbBjTX25viV6xW68a9oo3MkQJYWkKKPfs1TkAluY=;
        b=npSffdaieWFucXHDLr4mY6XgP2tHJEoOTVV6csT96vPOxvouZbo+xOm04baMS0+EN+
         ILt6v3wDsnQiQY1Dfffcie0xZpTFWaLYK6BzUM04xdyHxieJIvNOg6LNdFOj/3y0mBnH
         Jte3FAnXYcPxQddxr87OOvJEZ6dUuX9sLqI5aXpeyk3Ki59e1OAR1zKEEXG4Ifc9lR1Z
         LmZi20QOngtk5w17q0wIZkw3ahIXVLzoXpdRB96sntn1liwbbCydI+aZqLJTRszyPkgg
         aLXX8AB5Ds1j4EtaGcnjmp8w24YNv7D+M1DcDJJ9VXF0l9BS/QNTX03Rsdsi7XuPq2av
         wZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iN3GbBjTX25viV6xW68a9oo3MkQJYWkKKPfs1TkAluY=;
        b=TjR+V0xE+XfaVN5AZSnMAhwK6ZDPPEHJ8V9PXBYVchUB2aJ0O2FofWlZkweN7V4Xx6
         FLJAwYWTOZqWGGxXfIj/l3rG6ArAq6CTkaJRZAS0s5Bs+5s9B60p933UtPyPlE9iVocM
         C40FlGJWKO3vEMcRbC7bXc/ybq57p8Sh/jCQ9ThGSRGqugIXVAVbZ7ky/Mld3KulVFQ5
         DFxORrqBy8sglPO7fZlyePpiF0eF6BaXaP7Ye3qtkW4FoabAKylANUm2gc/jcUrA2voN
         QVcofO12ZKVU8iDfKV+5dKG+jSsw7QXXaX4zqWMStV1EU03lI+aIsSAaCnoil8mDjjj/
         B9Rg==
X-Gm-Message-State: AOAM530wgUY4zEZvjwX6vxpLztm92TDYE9O8TSCKC0qd6BFCEAMhd2gQ
	b8DrO6FSAsTpD8N88HsK9lu9agKwBLdfioSwZM4=
X-Google-Smtp-Source: ABdhPJyiG0zEVlMgXVpb6Zi8eshehY9Qj0OKZzrDehRr0ot1IUkMHErjz4cB8zqJtzXVoh7q4DtUcBhjwy1qLdSHusA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:1455:: with SMTP id
 82mr5771395ybu.274.1599165096721; Thu, 03 Sep 2020 13:31:36 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:45 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-21-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 20/28] efi/libstub: disable LTO
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

With CONFIG_LTO_CLANG, we produce LLVM bitcode instead of ELF object
files. Since LTO is not really needed here and the Makefile assumes we
produce an object file, disable LTO for libstub.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 drivers/firmware/efi/libstub/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 296b18fbd7a2..0ea5aa52c7fa 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -35,6 +35,8 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
 
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+# disable LTO
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 
 GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
-- 
2.28.0.402.g5ffc5be6b7-goog

