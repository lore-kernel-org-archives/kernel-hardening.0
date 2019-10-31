Return-Path: <SRS0=3yQH=YY=lists.openwall.com=kernel-hardening-return-17199-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EFFCA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 913EA208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kjwr8ND7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 913EA208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17199-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1643 invoked by uid 550); 31 Oct 2019 16:59:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15989 invoked from network); 31 Oct 2019 16:47:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+uiLq+iUoKYbKnLFQDjwDIIzqGudQy8o1UFEOkmkrHU=;
        b=kjwr8ND7m1cv4iSNuEZOGhNW0Jvsmvr2aFrQFvCwGpKkkbxdVb8El383SJnvJL4kdI
         iUDB/VVToctJt6509RMF+oFsBcmbyjOjvFn9KZDRf7pUssUIl1plh0aaN7R1AxB1fYrG
         hVxnJ8tSwgg+2SqSgKWSR+qrYYrzF4/c+dAi5buVvIC0R4crMHKtWJhzr9H5KMHgiHKt
         Yi8bhEI9jYa9tcUZiNkBfQ5fzHUOBy9Tpz2CR4BwPRaTdxRCiczEcBH+q/e/DZVOR+5O
         j3GZxAU0PHjXfHImzbELWB2v0FfyOuNABYuHhuZD/+DaNds085oMgYh3IsgJGrFnX19+
         vt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+uiLq+iUoKYbKnLFQDjwDIIzqGudQy8o1UFEOkmkrHU=;
        b=qNIj5AlgsubUhOyK1Kvrv7Y5EqAkC6zfb0s6QwxhDDZeTgmuVTkvxseqNZM1GrjcdW
         +eVqwGttXWQS1O8U9Mvosz90HZRRqaEusJyfQabpt3648PFjPiq9RJOhzT9mh+BQD0Cs
         2rpElBfqhFzFy2iUyzhF3Qwn7DAeiK9AZUYuoHUqcsjMufuJIxKHpZIZuPvODV0dET07
         4Q7pyYuUGcaA6/4JpYFn9JMA0IYDZnkvbQY3jZsM3CR36BeKrdiF0LwMIC6Wq7CKivCf
         PxMyyqnz4KeU6f5zx2hXb8DmzriPTe33/4x093yl6l07sdtPdlKykRrifsz6kxFS/R30
         p4pQ==
X-Gm-Message-State: APjAAAWALxpkjac8mM2fP7eMjQXXJXazlc+e9L869W8N2FyxpSxidGoN
	uPSfCXyw8eyzwRUDQ26HAT9y/czBO/wTFE9uFmY=
X-Google-Smtp-Source: APXvYqzlFxyF121CIe85RASYbsEhGryD+IkK99FgQ3Ziz6Hy8dGPnJj8WzzVEyeNtwDP9s/uUld1eg/MwcrX7ost1fA=
X-Received: by 2002:a63:64c4:: with SMTP id y187mr1758578pgb.150.1572540440772;
 Thu, 31 Oct 2019 09:47:20 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:34 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 14/17] arm64: efi: restore x18 if it was corrupted
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

If we detect a corrupted x18 and SCS is enabled, restore the register
before jumping back to instrumented code. This is safe, because the
wrapper is called with preemption disabled and a separate shadow stack
is used for interrupt handling.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/efi-rt-wrapper.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 3fc71106cb2b..945744f16086 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -34,5 +34,10 @@ ENTRY(__efi_rt_asm_wrapper)
 	ldp	x29, x30, [sp], #32
 	b.ne	0f
 	ret
-0:	b	efi_handle_corrupted_x18	// tail call
+0:
+#ifdef CONFIG_SHADOW_CALL_STACK
+	/* Restore x18 before returning to instrumented code. */
+	mov	x18, x2
+#endif
+	b	efi_handle_corrupted_x18	// tail call
 ENDPROC(__efi_rt_asm_wrapper)
-- 
2.24.0.rc0.303.g954a862665-goog

