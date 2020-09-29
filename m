Return-Path: <SRS0=abiD=DG=lists.openwall.com=kernel-hardening-return-20044-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AF7C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33FD72076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VsL4ntl5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33FD72076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20044-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30554 invoked by uid 550); 29 Sep 2020 21:47:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30424 invoked from network); 29 Sep 2020 21:47:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3CV3/71SvI9Aae4EB6SuVg1gWevq6V3dKGQQ0SLCSxM=;
        b=VsL4ntl5+hY0sK9YbHIOCU/8xkMTUwfbSaQJDJE3/xjI5F6RvBhZ95rjnSx9qzKP19
         c8dtjWQ9X1ycYC5cQdhz1pOUlwobIqAkhxQS/79ifUywIFe8vgvwUcWjLeboFlrrbcYK
         f+yGk+07cGJpo17CclConQX5GRnPs77eYx1X4Y/VF+Ljh28bTgeQSAfYO28SLdB3x+Y9
         NGL1RCxovqI1uJnDovNqoqdjqzucm59FJTBc3enczCyNqTlCQDgreBEoQ6ZIkYl4frgU
         j3XEkn1c1qgjUZRuJJnggDEhbR6LNJUg+9sOgKjHf5cebOSVhsYP16Et9tjoyV5Q4Nqx
         WMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3CV3/71SvI9Aae4EB6SuVg1gWevq6V3dKGQQ0SLCSxM=;
        b=nGc566vtQz6fHGy9xzlNgOL93DroeJOnlcxDkTA1xuEPtqODrLBwfgtYIM1DHmbaPv
         tk7KEh48uU0Y7oz1cNlb9SuRLzbd1kgeAQYzkUu/BUxayA9q760syjL/HVwWNuP4UwfR
         nSfI/ldAeU3nh9CEnH7D0EdoZbrGmvsEFhgIzF0Zx8kgQRH8sBofuWLbLt02PXetJ2Tc
         POYrDc8g/3FthzsN2t3chw4ReUHwfEcXye+nTVeikIy6j6wvHALpJi8wj3tP3h0SGSE1
         PiJ/DzcRh6jfcpUg5fui75HcZLaI+VSSYeTURxFJ07ISpYTI9/a0tqNBGuSnQmtVEqQ9
         byVQ==
X-Gm-Message-State: AOAM532xjEmM2XuM9kp23L/tTctrhnAgKyuxv6d+kZGw9fPUMOu4I7Rr
	GG/3xtMK58nfl98rEFFeSYPzdRUNCu2Ln/b4/sA=
X-Google-Smtp-Source: ABdhPJw1rbXd3Wm2I/qDL+pij6pWpBrSY8S/UcyV+ktSoutrbImixV21BdVnAU852tswQtkkdWHRxrar/pvIuY7K2Z8=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:58c7:: with SMTP id
 dh7mr6716071qvb.20.1601416024173; Tue, 29 Sep 2020 14:47:04 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:16 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 14/29] kbuild: lto: limit inlining
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
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
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 23cdb475c445..d6510ee99ffc 100644
--- a/Makefile
+++ b/Makefile
@@ -894,6 +894,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.28.0.709.gb0816b6eb0-goog

