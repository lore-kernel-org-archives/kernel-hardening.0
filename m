Return-Path: <SRS0=xpDW=C3=lists.openwall.com=kernel-hardening-return-19931-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D19C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:17:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BBBDA2311A
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sk1n8gFB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBBDA2311A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19931-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19710 invoked by uid 550); 18 Sep 2020 20:15:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19611 invoked from network); 18 Sep 2020 20:15:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=sDhFGpvlf4HylY15zQIKyDPQxuNLHaPJE4lahmB/U3o=;
        b=sk1n8gFBPt/lpLBQ+GOEZFF5kf8UOnntxOTB32HnkQWAWrSaStYhtRE7qWdbcSLxg4
         Gg9GXRGdMLUsdCB/c8c7q8AGDDfB/5JLmacB5t9QnbyA5wUTdMVAdy75TO8BlVneBzVp
         lSI/Cl7ny5ny1K6+J3oitNwzfaSptJ76VcMWpOgVfjxm3SIpHxo4N7r4B3FBuFcxcDvy
         /qw4ESM9nEFmfuEfRVkLCqb7J/wr+gTYbwx15VUb419uhouvZ7OLiu3JBT/XiuB7nklt
         UMu9qGA0f4VwicJFQUJEGU3naFOTNsTQSVhBYOgrLyZldxhatmDZWt2FeBBqcQGwQmbr
         piUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sDhFGpvlf4HylY15zQIKyDPQxuNLHaPJE4lahmB/U3o=;
        b=lb6+33zdF36SimoPtDDGGeqbRh1NOTcF0K6+TdnySFScX+gp9o6vLSGaLQEWwpccEj
         TX6CyFe2+RU9FMw+YEsG9vD2E44ErHPvc/w4VPYAygkc44v3mewNqPzUSKN96hiTJPSk
         Hed6YrCfZ+kdkEBA/Tzm+vZHRwEgLmoj+LUfcxAkWKCKy4u9lLbEJCxMAjllAFR+531A
         lbBFPK1SJqa1B3Nb2vBERi+SDj441spFLy2theCn4rRfqeQ7Ma+iAE5kcVO8F0YlqIli
         vkT400mrmQLoubSi2fOksA1rcKglxBko3mvpjUQ4JdmT5vpO+HStvOlazvrNYk18uEuv
         oAfg==
X-Gm-Message-State: AOAM530E7tzQiDiQO7MkGitfbg/GGTc0e16YHp7AFaGEOa/1MrvKbIhG
	jAGYg7gWSf6Ei0WdsgA7snMEk1muxjV7f25py2k=
X-Google-Smtp-Source: ABdhPJzcLc2Llf2NYvBudjp2BIXvLbxitZeqdCSBF9rMkMxLi5VdEAKNXht5tAMiNUsnOx/RDEKyI2Da9coZSC3R4XU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:9d04:: with SMTP id
 m4mr18731516qvf.50.1600460113739; Fri, 18 Sep 2020 13:15:13 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:21 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 15/30] kbuild: lto: merge module sections
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

LLD always splits sections with LTO, which increases module sizes. This
change adds linker script rules to merge the split sections in the final
module.

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/module.lds.S | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 69b9b71a6a47..037120173a22 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -25,5 +25,33 @@ SECTIONS {
 	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
 }
 
+#ifdef CONFIG_LTO_CLANG
+/*
+ * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
+ * -ffunction-sections, which increases the size of the final module.
+ * Merge the split sections in the final binary.
+ */
+SECTIONS {
+	__patchable_function_entries : { *(__patchable_function_entries) }
+
+	.bss : {
+		*(.bss .bss.[0-9a-zA-Z_]*)
+		*(.bss..L*)
+	}
+
+	.data : {
+		*(.data .data.[0-9a-zA-Z_]*)
+		*(.data..L*)
+	}
+
+	.rodata : {
+		*(.rodata .rodata.[0-9a-zA-Z_]*)
+		*(.rodata..L*)
+	}
+
+	.text : { *(.text .text.[0-9a-zA-Z_]*) }
+}
+#endif
+
 /* bring in arch-specific sections */
 #include <asm/module.lds.h>
-- 
2.28.0.681.g6f77f65b4e-goog

