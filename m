Return-Path: <SRS0=sj7i=FP=lists.openwall.com=kernel-hardening-return-20595-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F437C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6AB722248
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6AB722248
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20595-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9740 invoked by uid 550); 11 Dec 2020 18:47:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9661 invoked from network); 11 Dec 2020 18:47:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=aPTc8wYkBIIZS9XLhaJqPHrVGew/rHRzWtLqs6SwnEk=;
        b=E+U0sSuZCC6dC6kicRnG1UaOFnx0iJfVyKRNQUtLjfW4hBBe8OQHaAuEWS9h6JwKDx
         nx6Zu83awRxikbvdB79vty/SByEvJivxVql9gf2LMdRTfeqEVv6ipQ1QsF9J7PWYP4ci
         xFn+wn1LX/1iDg9jO4eVqOOQ4FreP1QjK0OhIyps0vVvKsrGxhaOt0uJ7F7usCg/jpLp
         gwWhvDGGPcYg2A/8emqAajS7l0RY+zs0C+//CZq5Gur4DDUAlFbFqzlQpajQdqS8M9Zx
         v1gv/9kwRgkR9BQVqOJaPgZ90khLPqENshOnYY+glZxACDE1KVCQlvqrVGtAtOTfVdje
         HG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aPTc8wYkBIIZS9XLhaJqPHrVGew/rHRzWtLqs6SwnEk=;
        b=aXDJR5FvW5166dzfwBdQ/TwaTfHnnyVA2Lz9Gumyck/W31CA0o5MWR66Y+eVAgATKl
         D6WGOu3Xcn662LG8/xpdbcTcP/mGihEu7FQX3GR9cKwSoVN9HOQ9iokLS9cZ1Ht9clZp
         1XaFdMg1R4uuyKs5P5YGThNYTFez1nTMJgMHfsIMVc9q3791UvHbZvDP70kX77vJZitZ
         qepX3yvNZWqOrJ/ztAO7Ae5MdkttjxKq2nJ3LqxBKhZ7cLJpElyVfkkqA9gydObqiFj5
         NPV/qkdu8BYFMdH/7IZna8K1x8Pf+ECv2Lq3OnVrN4lGnxhFRK25h4ALq0Dv6+4Gfq7L
         2Qsw==
X-Gm-Message-State: AOAM531i/DFfW0LpVo0CVm1yLVjiCAazNYQprB5dniX4hRR0Hzb+Q7Uw
	Xqk/+859Ti+N4CUDe2P9Lbm6FiMwfPDHugtcp98=
X-Google-Smtp-Source: ABdhPJxd+bMesTAWKmvtUqjomdCAHsA1n3+h09FJfVuePnPbd9mL5SpzLXlx8lDAG4fdUSPHIEIQBY9z8nx1PVd0SrU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90a:a24:: with SMTP id
 o33mr10805536pjo.191.1607712421542; Fri, 11 Dec 2020 10:47:01 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:30 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 13/16] drivers/misc/lkdtm: disable LTO for rodata.o
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
2.29.2.576.ga3fc446d84-goog

