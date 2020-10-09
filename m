Return-Path: <SRS0=7a/t=DQ=lists.openwall.com=kernel-hardening-return-20144-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F963C43457
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:16:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 84AF02227F
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sEoOB3be"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84AF02227F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20144-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5531 invoked by uid 550); 9 Oct 2020 16:14:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5413 invoked from network); 9 Oct 2020 16:14:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=i0HfMD/wRChzzw+H0j5SIQI+XYlsyfomuEvjB0A2b7U=;
        b=sEoOB3beinnRwWhTbfM8SalF0cypydPh216467a4z4b5/i0LPdWiZ5comfR+CiYfuB
         Eu6WnuwqDQWg3zWFoeOdTsPbYHhw3tNqNZ8MjpSQcdjSRgi7EG1dWI1RykapF9xZWiY2
         le1HF/WqJI6Jl13HF5R6zyktQuEsBMAEVBeei7ZFW9w6SZcy2RVolvTp6Wll1P+Fel+u
         qLJQ4BMU4abl2vfwj62MA6cUp201pkizABLlY7j94v8InIgak3mqGIgyVYCkdDVXzKLs
         jgf681rPIiD2mLYPe4v1fiJI8parpj4mo1rgorOkKlmmsNOrBR5zrp7/pX8UClF3X8DT
         0uzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i0HfMD/wRChzzw+H0j5SIQI+XYlsyfomuEvjB0A2b7U=;
        b=IUiGoSWkIWJJOboMSl/GM0MNtrOCJKPXnbKMfTnOP06kJJdDXhD0a5PUMI9pYsqnTn
         5atjrT95O7GGPa9tUdQ3w3Oi2KabRU5G+IQwjAnjoZGW+RX14waa86wam+tIUclJrfGx
         azT+XY7wSZAUYwNuNGt9j3L+fK+e2j2foboq9+efJmCDQZuZSLGFDNZGhmJZLFyiQWIc
         L3+DkBWjGbOYqaDmDRLX6dvyLCN0IMmAP2B90BZRMtetNtI6TlfvmnUoEiFmbdrtVzq5
         K4rJrNdbGpObLJsqoGch8H7JC4I1PKrJ1FlaYfQGz+ChBXi6zClJGFYXu8LoFZ4BzQ6/
         UU0w==
X-Gm-Message-State: AOAM533uWURRqsNAbzpIPOHAUyy2cP4fSJQJnO4avAchkUR9U50kHF2Z
	6/oiqdjMH92+dIH+M9sQy+RvBSiMsjOwokEsPYQ=
X-Google-Smtp-Source: ABdhPJy/D8/0u+nzbzzf55/nK574QK9COSo5VcbQLJEKAJhBGhwXDRm3vwXt4Hczxebu5BRqeLM/xZZizY5eXSIgq20=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:456c:: with SMTP id
 o12mr14223376qvu.48.1602260047185; Fri, 09 Oct 2020 09:14:07 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:22 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 13/29] kbuild: lto: merge module sections
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

