Return-Path: <SRS0=I9f5=FP=lists.openwall.com=kernel-hardening-return-20586-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E845C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:47:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B999F23F37
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:47:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B999F23F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20586-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5854 invoked by uid 550); 11 Dec 2020 18:46:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5784 invoked from network); 11 Dec 2020 18:46:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6mEKvNeY3wq0rs7jAFLZaZQm6yt6Fm86WJ405HnCM0w=;
        b=F3+ZlsJ4J/cRnUap6emR8N4b+Xouboife2S7UkAulyFopMjE2taVk9b7ehRGq4lP6n
         TWsU42g66xrNtUHSwJP7KHpC9+dzh6DjSzVNB4ihF3HNbGrWLATePQMHxzMsDj13lrQP
         azC/S2KiPkBzTIoYgS+nAssox204PVtPACYv3/zBjhusnbk5UjStmi3SxWetk5Rg2kzv
         z8nqf6A2Nm0mG//A4/l4+LYdtA+F++wU6dqyimvIcOKEyC4WJMPShNvMtY4e0/LfP4ix
         QdZ5G0gBeKAaM4Af5u8Kd8vvAtx6eHRH3G4aF6b+OJSo0XA9zUkdzMJPMR2eih4tOekj
         Yqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6mEKvNeY3wq0rs7jAFLZaZQm6yt6Fm86WJ405HnCM0w=;
        b=dxZFLyTR9h1Qs6zfIerZPzX/CApM0qbGWf2JzdDw7zXXL6aN97LHFdYD1b/8KxB8Ma
         2QKQ7I4lZcgexYa4k3OK6DOt7c/4GrdPZmnYhhcnPVyX3tuPDwD/gx01E1RZTtAZP9H7
         FBkuiQcV9nukrjy9OWA6kU78tCwt9syw8MZpojRBEaX+5UwQ2PMOl74u11D7270TLBU9
         4tmumX5nmmFq+mUyP5ecYDvBbY//U3eJf/HbFIv0JE0EmiL4jnq3+yxPQlIrwgFdqMjR
         t+G0m/fnshVYpMfR31fzkl4hvMIsM13BKsFoPbQroUj08B4kHmKHuWsaFksEnsPwMZc0
         C/kA==
X-Gm-Message-State: AOAM531XHjsN5iLpRIxoFlxGdkteyWVxDGND12VHyPKuv4hD+Gbvafyq
	v/di4xQ4Kgu35b1JxyJxqu4FXKwe9bspCSg8P2U=
X-Google-Smtp-Source: ABdhPJztdLpOmb8z2bOpx13eLpmFbg1IRTYkNtur403j5lUtJlMBrXobhq6mew9nU+bYggfLn4Aj28+KN30Fe9rq1PM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:7d04:: with SMTP id
 y4mr20471824ybc.110.1607712403064; Fri, 11 Dec 2020 10:46:43 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:21 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 04/16] kbuild: lto: limit inlining
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

This change limits function inlining across translation unit boundaries
in order to reduce the binary size with LTO. The -import-instr-limit
flag defines a size limit, as the number of LLVM IR instructions, for
importing functions from other TUs, defaulting to 100.

Based on testing with arm64 defconfig, we found that a limit of 5 is a
reasonable compromise between performance and binary size, reducing the
size of a stripped vmlinux by 11%.

Suggested-by: George Burgess IV <gbiv@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index a07e3909e5d0..84c60f38ee3e 100644
--- a/Makefile
+++ b/Makefile
@@ -901,6 +901,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=hidden
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.29.2.576.ga3fc446d84-goog

