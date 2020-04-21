Return-Path: <SRS0=jRUv=6F=lists.openwall.com=kernel-hardening-return-18590-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862AAC38A30
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D75F12082E
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTHCdrmF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D75F12082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18590-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19729 invoked by uid 550); 21 Apr 2020 02:15:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19640 invoked from network); 21 Apr 2020 02:15:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ir6AMcU/LNJfVmH7TAbfuSTmLjnaQbzCZFrLbu9sicg=;
        b=QTHCdrmFKIB/Tam+WFnqNp4+O7lTnQjXDzPLeYJW2nLi3p+F4yQ2Y8DZVDTCwVRq6Q
         eg8pdSDyHTrZJWVleCGpiYE0vBCBADyPgfeKL1jvUz5cl/63rDlPkhYZnLXW5EcGpcVc
         pGcRb8ehfFrcc+H5YuR9BWePyIpoc+Vh39Y0pRIm/lqCuz8hiPmNAnaY/unezPdgbiZP
         aHELlMunluzusfymqfmKV5EfIa6lRfT+Z0m5QxDzworuJTMbhuOj3XfNh6JSDitvM/N4
         JBIil9L4mq7qW2pE/kvzNUPF2wkyIiMJhDxbq4fEsxBUku7c0NKWZZiO2wMtwmErocuJ
         aZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ir6AMcU/LNJfVmH7TAbfuSTmLjnaQbzCZFrLbu9sicg=;
        b=okpojU07fZ0udJm91uZ9DL2gpgZDwxEL/a4jFzC06crA9B32sJBYuYEsnulEzrxwkh
         1XPlX3oZacLlAbyqxh+IGJ3e7/y0ozgTX1eEZClwvpir87eea8V/zzVJLW2oREIDxEE8
         J44rroQI+eowoRTVrWqJZEJHlZ69c6myGPtaf9sCzQWeiRwj24eNEuMsfX9FUQOQZ0G2
         6tGvTdoVxNnLsB1ydcUQ7qNm48R464OcjfRB+oVakmCmtlVf4YuKdU3sc11ksX1iX80z
         rp5hyAiMXoQV8Zg1mB5tPhIt9EB822e+HEAR4pv25ERJca23XJyA6BXcpA+jV8GqI3wJ
         wC+A==
X-Gm-Message-State: AGi0PuazVMW5tpEW7UVNN9Ne/Juv8H2dxMYLGejGRLDVufOraDh8Wuei
	j2Qce0rUnc2GMbE/H/01zLmvNEbtIw52Xr3YWz4=
X-Google-Smtp-Source: APiQypKMZMqfx/OcrcbDtzjGTijQl3YSQFjckDxyglhj7d6MnhDSddDwRZznsOSEAJZMqEO9LCcVx9cM4EOpbzh+h/U=
X-Received: by 2002:a65:498f:: with SMTP id r15mr19453163pgs.345.1587435314416;
 Mon, 20 Apr 2020 19:15:14 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:48 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 07/12] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
2.26.1.301.g55bc3eb7cb9-goog

