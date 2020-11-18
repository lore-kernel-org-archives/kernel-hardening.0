Return-Path: <SRS0=eue1=EY=lists.openwall.com=kernel-hardening-return-20410-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE23DC5519F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:08:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 078E32054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OOlRBBd1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 078E32054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20410-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1881 invoked by uid 550); 18 Nov 2020 22:07:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1805 invoked from network); 18 Nov 2020 22:07:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=OmvLBVHrXYJgk90zzJ7qPiL6Oqy/f8wdr2oL1+M7ruk=;
        b=OOlRBBd15lFDmzj+eQqhl6JOtOXoAglrgb4iMn+oJHxK0ENZkBjJjpLRPk8q5A7SFY
         ZxOzbIi6eI8fOpXWY6S1PtuFb9wg3TX+Bl/FrS4kXMHRbAe+z1Spr6ZgEqWyaJ5aKKGh
         CYZOPt70DGmhjLkIIlNFkUn5wAZcqd9p24/TP07dxXRKEgV6/xSmfaZiGowvpnrChr3h
         oRO+CqR4Ru8/QzOnLXn22YARn7ZtJna8chF9gED7FTMLvJ5bG1fnbkKMtM2vVSGmCzM9
         01mn+DFFeos8A/Ej3OQuxmZxuUaqeCTk5sVd6ATqwCmTjVTPWyZ/EVXTwx/DNAKAAf5i
         Lm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OmvLBVHrXYJgk90zzJ7qPiL6Oqy/f8wdr2oL1+M7ruk=;
        b=KXBOFwFL1dzHvzitm30UGWm9v14O7Vy1ZCRLZjP6Sxl7T+cBopU4Jr7r1UCCwfBMZ9
         wzOu5g3x14T6WLpV4+u0shvkDJPvTcftv+R0y94xMq08t803yCF5+7C/+mVcfyozr41K
         A9esoQwQvVDb8d0YngWvRWFWfnSa8v59vJPJuh1B90vcEamLkAW4J3/hj1Q5tHeXd7d7
         mLEQGisQ8g0DGPNKlHZHUZexGkFtnaGWxBT2gt1+8dVzxec1+kyMlxocw1AbMq7rWH90
         ynC6MJER5LNT6LHE4nNWBnCNu1N3m3xCqZOlvbdNtVXJPAelKnPA3M7sdRjf6+Tz+umO
         WlMg==
X-Gm-Message-State: AOAM530pQVb/V2E4sxq98olMr4zlRkVIKfErACius4GXxyNrsDC1gsC5
	DAliY9nviAlz8+K7ZYGBQGWvYg0b3Y9U6KCpkZo=
X-Google-Smtp-Source: ABdhPJzDNOiTYuvtSCpROfZDlglre2puYkkaLcBNYl9GE1qztV2AAXOG3khM8OqSsFXToIMyXQUc4gcbg+Ue1s/szjs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a63:550d:: with SMTP id
 j13mr10510189pgb.365.1605737261156; Wed, 18 Nov 2020 14:07:41 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:18 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 04/17] kbuild: lto: limit inlining
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
index f27c0da5d05a..bee378f9fd50 100644
--- a/Makefile
+++ b/Makefile
@@ -901,6 +901,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.29.2.299.gdc1121823c-goog

