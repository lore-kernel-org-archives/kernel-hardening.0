Return-Path: <SRS0=oUsI=4N=lists.openwall.com=kernel-hardening-return-17912-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85988C35E04
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DBD8820658
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B7ASfSbr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBD8820658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17912-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3209 invoked by uid 550); 25 Feb 2020 17:40:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3151 invoked from network); 25 Feb 2020 17:40:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QniVckAJWtqLmmFgAWqtQvDUqGmhiEDDkK5Atd0uI+w=;
        b=B7ASfSbr6PJI1PNYuMw4AeQl2rfrBE18p50aZHmoTWWjcghaevDSqsyUvYLaGuvGEV
         wwBpIUOA2JHt7hx+G+Ornny4GKtz9v4Eypp4NgPZ3xEK3rgMRBRBuNUqNS+ox6ACh+ZC
         6cWbkc8+i4jYfG+umapz9k/Bm3qSztOLHJyMg8JMXVQHlKA9VuWwhJw3cIfwhzFXI03b
         UEh9pcFUZQVWnOG6NbIAR+vAckRKiK94vNJZQ4ldnB79ldCEHyc60gKr6pHwkSc3vVOl
         SlY8HCGuRiNp4u0S5QuDxi4DnFctp1zaF1wh2WUSCaV9cRZWkMvslEfisyUwfEbN9k+G
         Kagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QniVckAJWtqLmmFgAWqtQvDUqGmhiEDDkK5Atd0uI+w=;
        b=qushFcQL+m++luhlbJ++JSuPpCMQ77845oq/8OG2gep3tM1xD5ycOhesJQstKQRS50
         oQFUON9zYnYYcya1eo2dmcAehhL2q6vWsXOxjfvE5cWWtvVrrPS5/WE4T43aYwlOhCAu
         rE2+zROaAccKe/1e53/eqqI+XJ3TF8fA6t1A6CyFhZC+LrI8TCVnKlnoBFaZy4xETbnQ
         4Sq+4g5bySAEaxpDsYJY00IdwzOgPNMryETkHMi5a5Fe6Os9NAcaZgn9gCF4JWVqg2ie
         yuKMVaibxmT5m3nPc1V4w+GROZufh6Dsu7bkeIWI6CxSZ0FRoFsOjYEa0J/wI24jGM2n
         JS6A==
X-Gm-Message-State: APjAAAUB5LLm5t6oz1aNvV2V2QTsBKSEB53xTP3Z+MPIwo9tDv6qzYzM
	ZrKuBMz5+HLgH0ODp4fdpBIOkQI1VpncVkni9Yk=
X-Google-Smtp-Source: APXvYqw22kkM3bH9wLjSIFkgjo4U46Ik1liYbPY7ppLoTBG5p4rEwIGlGJAnCM7FSLJOm8bUadpuV5p12hkwZ3bHzak=
X-Received: by 2002:a63:d244:: with SMTP id t4mr15492036pgi.241.1582652406574;
 Tue, 25 Feb 2020 09:40:06 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:28 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 07/12] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

If we detect a corrupted x18, restore the register before jumping back
to potentially SCS instrumented code. This is safe, because the wrapper
is called with preemption disabled and a separate shadow stack is used
for interrupt handling.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/efi-rt-wrapper.S | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 3fc71106cb2b..6ca6c0dc11a1 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -34,5 +34,14 @@ ENTRY(__efi_rt_asm_wrapper)
 	ldp	x29, x30, [sp], #32
 	b.ne	0f
 	ret
-0:	b	efi_handle_corrupted_x18	// tail call
+0:
+	/*
+	 * With CONFIG_SHADOW_CALL_STACK, the kernel uses x18 to store a
+	 * shadow stack pointer, which we need to restore before returning to
+	 * potentially instrumented code. This is safe because the wrapper is
+	 * called with preemption disabled and a separate shadow stack is used
+	 * for interrupts.
+	 */
+	mov	x18, x2
+	b	efi_handle_corrupted_x18	// tail call
 ENDPROC(__efi_rt_asm_wrapper)
-- 
2.25.0.265.gbab2e86ba0-goog

