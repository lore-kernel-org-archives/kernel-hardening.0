Return-Path: <SRS0=bYfw=CM=lists.openwall.com=kernel-hardening-return-19731-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E78C2D0A6
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:33:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6C268208C7
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:33:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d3WTta76"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C268208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19731-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21810 invoked by uid 550); 3 Sep 2020 20:31:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21724 invoked from network); 3 Sep 2020 20:31:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=v4aEDtr6bLZLPmR/ra6D5NVXgPqHTR+q2+p+53rP8YU=;
        b=d3WTta769MJh+Bo0VzFx1dIubRn1F3/0OsgdvpRIABs/0F8aoQ0QxN6GC6ogiN8YAt
         1n2fy7ycG6neE8i4JP6mcoL5+gOWppxCnH2U8kbhGmk3Ke0U/7qP7lute7a6H0uDoYhQ
         dWVIqp9Xjw2Q1WEklB8eqrGPTTy0VYDaAb7Vj5vkDxGtzwmgFWOj15UwJBAbJ05tl1sN
         Q4rZl0DzGVRAuAw5PJyrACjWBxr1NbGCE0oN5TR+pUi+Dq3TH5paoF63RYX5l7QEOrpB
         +a+BflxQgXchm/xsTBNIInkXUZW2NMgvFiHC7w8tScjlytwkaK3yal7TbaDvFzX+VZKt
         2LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v4aEDtr6bLZLPmR/ra6D5NVXgPqHTR+q2+p+53rP8YU=;
        b=ZDrmgiPyijVA+h2G/75YxbkiGqOAKV69CwpsmOLqpzJ0s/N3uXiAFKsWtZsrdwaaxd
         Ixcckl5aTLV0qPLH4ctUWpgG1OPbRzbUJjxJNp6gMMZRQskYwuh7HkvhcEwG5J9hzifo
         V879hW4Yur9ugaAKcTFEWUgNmRaEC/lWmCZe+I1btUeXVmx4CdOLu2KSk7gp6VsJe6Qo
         QBRiLtdOS4zkWidhKNVLG0GBB+cFtWOHgyzU91DfcC3cxGb8y0wPUPCnvRIi8PIrrFeL
         my9Gm9mLfpBodR4HrBysMqb72GB9u040E0ethzIXc2WVmju2w4mbvPipPPR3xVpwv0Yj
         nEuA==
X-Gm-Message-State: AOAM532FCJSSh/4LaTnjRZQi69MRs6+HJF0IbrBBjzZ5AI0rMtAdpDLP
	IXmeWJSoirpy3wsyPvTm489PNnpaTxLV/W2P+R0=
X-Google-Smtp-Source: ABdhPJxLcteMiXx6yxIAtF7C6LDsd43v+S+v/BljrbTvv0EuuMtNnvGzhvJa2qGTBh5Tw0uOlOWuvZqeImKd2fr7SwI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:a366:: with SMTP id
 d93mr5081717ybi.415.1599165079173; Thu, 03 Sep 2020 13:31:19 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:37 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 12/28] kbuild: lto: limit inlining
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

This change limits function inlining across translation unit boundaries
in order to reduce the binary size with LTO. The -import-instr-limit
flag defines a size limit, as the number of LLVM IR instructions, for
importing functions from other TUs, defaulting to 100.

Based on testing with arm64 defconfig, we found that a limit of 5 is a
reasonable compromise between performance and binary size, reducing the
size of a stripped vmlinux by 11%.

Suggested-by: George Burgess IV <gbiv@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 2752be67b460..c69e07bd506a 100644
--- a/Makefile
+++ b/Makefile
@@ -917,6 +917,10 @@ else
 CC_FLAGS_LTO_CLANG := -flto
 endif
 CC_FLAGS_LTO_CLANG += -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+LD_FLAGS_LTO_CLANG := -mllvm -import-instr-limit=5
+KBUILD_LDFLAGS += $(LD_FLAGS_LTO_CLANG)
 endif
 
 ifdef CONFIG_LTO
-- 
2.28.0.402.g5ffc5be6b7-goog

