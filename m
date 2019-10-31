Return-Path: <SRS0=C3q2=YY=lists.openwall.com=kernel-hardening-return-17187-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3890BCA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 16:59:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 818F72086D
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 16:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ru92iBuu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 818F72086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17187-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26316 invoked by uid 550); 31 Oct 2019 16:58:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13461 invoked from network); 31 Oct 2019 16:47:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NvkEBCuGDFGmxutij1zSuSKxlsUUBaj5IQr0NLQJ5So=;
        b=Ru92iBuuYlPhHAFVLWeOs87kE0FiX1qHnTaOtpzTb/jKviPaXonwKKd+N66yjkRYuK
         cgnBq46YclvPXSguuBJeqzLri7jCCWWG2Dfk0n6Id4jZM2n7hZ/78QAEvq8GFPDPGfUD
         qNtrv8foscV0AHwaybS2313mz3Cil7NrOo8pDuPY6Jd1tSs6WarJ755+eSf/RomcChV4
         7A1jpdn6Ivzs9aO1uXSVTF6S5nlm17BU8Kojsg1aHJT+c27sDLV3569+F5xcQdMXNe/B
         BAiGEf7hztz5GyYBj6nLqE1P0Jc3Ye8dMxEAQ36afKH6zRhZp6NxcrpWbI9k75gVvReY
         hMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NvkEBCuGDFGmxutij1zSuSKxlsUUBaj5IQr0NLQJ5So=;
        b=LvtQusmDBvdrUiN/dGZ200jZAE67YOUeB1MyXlehqKL353j76NtoJ8sraYJrC8gbXd
         cD4TDDJP1lO+3d/GCVu3xhDOPJ7U26Q0KC4+qM31S3hOKLNQMSgCQTn2kIHvSdT8oiMH
         piX91iNNGflQeRyrtyA0D+hoDPNLofwI3s/qnT0GfkU71X8vS+MuQ4S4Z5IQae8LxkuF
         q4sN3LEwjVSztbNJ+2+hah/MmvM8rbEza+dL6z777UyAuetZqDGwp0kRD9e75Y0k5JxP
         edvbzBNz+aihdqzPYsjukKk4RiLBto0oVPtbrqSM7ajr1dnx1kHDzKTyX4vN/kzEQKKC
         e16w==
X-Gm-Message-State: APjAAAUNBwOG5+wHPYhDzEKj/V6aJFgBMbdp4f5sjE03wjN1hl4OXhji
	Xxw0r/L40PZMpC9hQ9xUT3Yvz2lsBvKbSkbycQY=
X-Google-Smtp-Source: APXvYqyQVapc0HQb2zNlrO9ACUIg0p0PZIO3eKHtqDUB9iKBoqT2ZxFgyWPN3wIre99JvuCaIlvEX84YwMN3a1ZjF+Y=
X-Received: by 2002:a63:d809:: with SMTP id b9mr7733622pgh.143.1572540408812;
 Thu, 31 Oct 2019 09:46:48 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:22 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-3-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 02/17] arm64/lib: copy_page: avoid x18 register in
 assembler code
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Register x18 will no longer be used as a caller save register in the
future, so stop using it in the copy_page() code.

Link: https://patchwork.kernel.org/patch/9836869/
Co-developed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[ changed the offset and bias to be explicit ]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/lib/copy_page.S | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index bbb8562396af..290dd3c5266c 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -34,45 +34,45 @@ alternative_else_nop_endif
 	ldp	x14, x15, [x1, #96]
 	ldp	x16, x17, [x1, #112]
 
-	mov	x18, #(PAGE_SIZE - 128)
+	add	x0, x0, #256
 	add	x1, x1, #128
 1:
-	subs	x18, x18, #128
+	tst	x0, #(PAGE_SIZE - 1)
 
 alternative_if ARM64_HAS_NO_HW_PREFETCH
 	prfm	pldl1strm, [x1, #384]
 alternative_else_nop_endif
 
-	stnp	x2, x3, [x0]
+	stnp	x2, x3, [x0, #-256]
 	ldp	x2, x3, [x1]
-	stnp	x4, x5, [x0, #16]
+	stnp	x4, x5, [x0, #16 - 256]
 	ldp	x4, x5, [x1, #16]
-	stnp	x6, x7, [x0, #32]
+	stnp	x6, x7, [x0, #32 - 256]
 	ldp	x6, x7, [x1, #32]
-	stnp	x8, x9, [x0, #48]
+	stnp	x8, x9, [x0, #48 - 256]
 	ldp	x8, x9, [x1, #48]
-	stnp	x10, x11, [x0, #64]
+	stnp	x10, x11, [x0, #64 - 256]
 	ldp	x10, x11, [x1, #64]
-	stnp	x12, x13, [x0, #80]
+	stnp	x12, x13, [x0, #80 - 256]
 	ldp	x12, x13, [x1, #80]
-	stnp	x14, x15, [x0, #96]
+	stnp	x14, x15, [x0, #96 - 256]
 	ldp	x14, x15, [x1, #96]
-	stnp	x16, x17, [x0, #112]
+	stnp	x16, x17, [x0, #112 - 256]
 	ldp	x16, x17, [x1, #112]
 
 	add	x0, x0, #128
 	add	x1, x1, #128
 
-	b.gt	1b
+	b.ne	1b
 
-	stnp	x2, x3, [x0]
-	stnp	x4, x5, [x0, #16]
-	stnp	x6, x7, [x0, #32]
-	stnp	x8, x9, [x0, #48]
-	stnp	x10, x11, [x0, #64]
-	stnp	x12, x13, [x0, #80]
-	stnp	x14, x15, [x0, #96]
-	stnp	x16, x17, [x0, #112]
+	stnp	x2, x3, [x0, #-256]
+	stnp	x4, x5, [x0, #16 - 256]
+	stnp	x6, x7, [x0, #32 - 256]
+	stnp	x8, x9, [x0, #48 - 256]
+	stnp	x10, x11, [x0, #64 - 256]
+	stnp	x12, x13, [x0, #80 - 256]
+	stnp	x14, x15, [x0, #96 - 256]
+	stnp	x16, x17, [x0, #112 - 256]
 
 	ret
 ENDPROC(copy_page)
-- 
2.24.0.rc0.303.g954a862665-goog

