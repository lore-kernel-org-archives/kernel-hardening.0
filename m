Return-Path: <SRS0=7PGa=DG=lists.openwall.com=kernel-hardening-return-20045-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D68EC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 610542076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F5fLd2Sv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 610542076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20045-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30683 invoked by uid 550); 29 Sep 2020 21:47:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30529 invoked from network); 29 Sep 2020 21:47:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IM6BeG4IsHqc2HlM1gNMjcO8xaf7Yq/XvaXPBJbuDVo=;
        b=F5fLd2SvpIplzncJLEztecG168LHlQrKNcKbedbFnUU8oPz2VYylmT9Mh1BQwGQWwd
         S0ZS2iRSNCDZBTJiH2iAxeyOVS4P1+Y10BtSKnYCQAn6a+GjpckK3VpZwEkV50DY8ZSy
         3HLQoiSBVf3cPG9keb+CQtet28xkKUxeLTCuy2y7Dp3C3nWOnMUiuc+XwrAW3YxiGWPq
         /2KbafujJwZBb7QLVML/Va4ooU9T1eIfCSgSGwKdUGZ9zKWbuQx17Dqr2BMzsCAl+lkL
         2CXyKcwhMnQZ7Jtse4QiNQ1zu7zDv2w3iAfRblAKfxEK4yCv2tM6mqw1dSGrb7v5pBfo
         dJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IM6BeG4IsHqc2HlM1gNMjcO8xaf7Yq/XvaXPBJbuDVo=;
        b=MXebSQXqF7DuLCleTHRrGGIb3VV2/WbZKvtaJW4Z10+faUjIQeyKpd82307Ixc8Tki
         /DtYV3bKbx92g+cfw0L9Y/rVl3g2EBkSrZq4VVwKFFXmJLcgxPUP+FF6/hQRNchVfyEx
         Tvfwp5BJDxM9zq500ay19Dv+YFlUcA4LHBg9eOn71+e2wo/xFqkY2W8pGxR5rO1r/h7C
         1/RKZC4e9Sh+hn8VuMxF5mdJ8Z7rlw7wmq//2hDBYg+rZf6SpxYB8weR5mnAnoCuZZOx
         pGbtr+KBI9vJZZxc4AmtzJR3MRScHwEJe5Tr8TOC6P+4HiXBY6lv+//r+n7ABeYJxAEq
         6xIA==
X-Gm-Message-State: AOAM533ayPOZD4gRB8yBveQtCwJ9zQvmCkrhUmfw0sJEe3jS2FDzift5
	1wadzexz5splSxIEtL9O1urRLOdvBMIgeZn2WOQ=
X-Google-Smtp-Source: ABdhPJwNKfL9Sa5Ulz2e3Crqy4KfEW60CIVw40VTunkPV2+OV55f90wO4GzRLD40XF/w621iqWtNnOlUAz7CC7ffa0E=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5565:: with SMTP id
 w5mr6385766qvy.24.1601416026659; Tue, 29 Sep 2020 14:47:06 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:17 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 15/29] kbuild: lto: merge module sections
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
2.28.0.709.gb0816b6eb0-goog

