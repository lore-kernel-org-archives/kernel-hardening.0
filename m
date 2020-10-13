Return-Path: <SRS0=Dk7W=DU=lists.openwall.com=kernel-hardening-return-20186-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B090C433E7
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:34:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 676A6206B5
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RWGnAnvd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 676A6206B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20186-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15736 invoked by uid 550); 13 Oct 2020 00:32:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15637 invoked from network); 13 Oct 2020 00:32:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=i0HfMD/wRChzzw+H0j5SIQI+XYlsyfomuEvjB0A2b7U=;
        b=RWGnAnvd5Lp76tMdFpNH1+zuCs711HvTmjeeqWExWdLO0b+IYvl8hseJy7bQVsA/yQ
         WbWgdjz9odSgS33tA7SyJrG23HtPbcQQ2sqTeDLN0z+XNW/U1+B04f29pxuTIBAo0Bwr
         1kuUI0qew0RRwWEdSqeHxrYPCuM0lKcyAQQHVJyqk0NDK5lndU4kJ0nEntK7Gw/b+6ds
         NINAxQFY1xV9pWKvIAxegfc8BATcwAptMc23jyb2HlWegaJKMJtRw94gvpud1QRadkKB
         gA/bzBYbBksOIuoqgqduz/XaFVcQDSEIQm1NvRkC4MArUYBfjsPwupbm8iuKYDaYWWMx
         dfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i0HfMD/wRChzzw+H0j5SIQI+XYlsyfomuEvjB0A2b7U=;
        b=gwqfGm7VetomM3Iq4USpKNcgX1XAf20JVy+P2GvMFZXE3v0hPKy8ArMEBphp+af2+1
         Am6HoTi9qVtSBBGeBFSaejQ55kOWmerr/wbFwuvDpt3Cr5+jFhuGeR0/YprVlEFRzser
         yuG7/Z9hgs8CnqnlYgubXBWywiS+loYGPGw4Zfi/HJtrBuGPgJuTbcAkqXQIGw8sC/hf
         hrUwQ3ieMA9GKYOgOYAdYgXs2DFH8khFbtFqScK0oI5nhnQje/s/fJOqpJbbwCdnZ9HR
         4Wwnz7zTET1yeM29mI/9JU8ib6wDq4cAskQ2ACVZheGFiOfOKgO5ZK4JrFnGBxTWGSOC
         +M6w==
X-Gm-Message-State: AOAM531BUE2vT4RqaCJy7h6wjnKGYSiSyGGTHhY4Fj0D6dN1RG7krWSv
	DLHSbcPCUr61XNBP/FvHHcXaolY0Oi5S88S/8RU=
X-Google-Smtp-Source: ABdhPJyWpX0TYRebf3Rkf2Yh1c8ADAskEKEgvpC4cZTbopj2J6pmYFQCkigTg2srbz/p2P1Qt1W0jVbIt5KqdOEhaLA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:cc89:: with SMTP id
 l131mr12649555ybf.154.1602549152704; Mon, 12 Oct 2020 17:32:32 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:51 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 13/25] kbuild: lto: merge module sections
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
2.28.0.1011.ga647a8990f-goog

