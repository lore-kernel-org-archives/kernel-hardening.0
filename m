Return-Path: <SRS0=ciXL=FF=lists.openwall.com=kernel-hardening-return-20492-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64447C64E7A
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:38:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 70BFC2086A
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQCyqpyw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70BFC2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20492-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15513 invoked by uid 550); 1 Dec 2020 21:37:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15455 invoked from network); 1 Dec 2020 21:37:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vhe2fhhubG0SMFTgpBNX4/KlbzQ2mtF+9llrSjbBo08=;
        b=WQCyqpywTb9sjhDQE0uOd7b+9m6ebi816QKf9yVHZCPLWaGBG+ipLHxcUm8kqWX+KJ
         kfKXPytExTkGVOe4NfXDntXrOaPJsp9DGA/e+Z5eC+AB1fjt5JjOY6moHYKtMdYABXlc
         pqwT9bceah0mNt1zUgNTQJmG7XZ4Nqu08tOaPOFkTunOluNW1v+MiVxaG85YN4/M5u+k
         HXPgLPzYDq4JSCLjbyTdrYr0q8bfH/+KpCl0SDkUgF3lejzLr/TISZQcZo011awEDOER
         hEKx1vs28+FQbBudhpM53qOZF9Lg00bdHxOHtQRU8na1jUSF06Ou0gmHopnqw5/ud94s
         4QmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vhe2fhhubG0SMFTgpBNX4/KlbzQ2mtF+9llrSjbBo08=;
        b=k0qxFsxDH6rE8uAqlfS0tzc3LpxtM/MlDGgX0UgnHlO4NH2DB3wNo5v66ZjdzK0LVB
         KgJ1wAbiDu4aDpdIEt2sfrf45P06E54TupmIBNSBXSZ1jWCTLSDEFRC0obvOBs+rPobV
         W++TxZ9l8QamyV/0rQgsB6Hr88wtEX/E8IS5L8fvNmeKQoMmGwfXSyoMsxXahoiYXSn2
         vxq1VhxGPx87Kt27TrUeD5m/UNFQpi/Hl5NNaugsoChq5OyhzONzUa1suPRsmtxbwGO6
         RbNnfd/zfMwXA+P1BxkXFJjN9xV++I4aFn63fBn819HKnf54mVwoP/QTMmBthxPgrqLT
         pLNw==
X-Gm-Message-State: AOAM5326GaRIA0lNLYbmbFbMIN3NtETVmxsnGkJ+VvaQwJvv7JPBJyQu
	3sU3Tcu7EwKYivEBZCaOJCr8xjlKsMm+pwGawvs=
X-Google-Smtp-Source: ABdhPJzj8ZnKlwOa7MfJuQkhiVpth6ScVKMd4AIpnLjVPcTB19+WZbXrany4DQG3oU9eJ5gCXDSYO/sX5i8KB6YTJcA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:468a:: with SMTP id
 t132mr5364497yba.312.1606858639932; Tue, 01 Dec 2020 13:37:19 -0800 (PST)
Date: Tue,  1 Dec 2020 13:36:55 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 04/16] kbuild: lto: limit inlining
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
index 222ae96d179d..ac836907d8b1 100644
--- a/Makefile
+++ b/Makefile
@@ -899,6 +899,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.29.2.576.ga3fc446d84-goog

