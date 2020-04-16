Return-Path: <SRS0=KBnP=6A=lists.openwall.com=kernel-hardening-return-18535-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C768FC2BB85
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:14:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2647A22243
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PfLQtJvA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2647A22243
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18535-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1697 invoked by uid 550); 16 Apr 2020 16:13:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1597 invoked from network); 16 Apr 2020 16:13:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ir6AMcU/LNJfVmH7TAbfuSTmLjnaQbzCZFrLbu9sicg=;
        b=PfLQtJvAzz5yI91olwSgmzdmwgdtJxdSpUwDBUqAfM/Qj4X8PTnr8pe6M1E9q+SxMQ
         9DuGyRyHutXrki59bdmwIERRsNZo12qtXtT7YTGaQUvErlBRD5mI0A9o3BWgwYogesFw
         pJQazMuF7VSg8nXXNbbuwnalk1A8GI2siOE+gzAVLDi5SEfj4qBjBhPGSFAFigx0XT27
         2J6qu4mUgNZPuqq+yi7V5b3R7FRrHRFEL+uzZRZfJJCkuZ3Y9YcoQ6IkCgna/0CQ22Jg
         qGjnRtJiwEZAIC0v5v+CcPVf8e5pwqpO5XgzgToKbUlUPQ54YIcNjAxSzrtDUK8hBIAD
         0GIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ir6AMcU/LNJfVmH7TAbfuSTmLjnaQbzCZFrLbu9sicg=;
        b=hXHIQAE36k3p+xnyS2bs5cQXUD3HopZCyoH/FobvRGcSTaX1wYhiZ3RTqX+0vQiyn4
         5yNs8a2VuAsKXrR1zoyLP8jqa1mL9BmgnUHanZaPqb3t4ob3KMb36XS0wCBHX7I9Ezc5
         hN4ISzdZbEJdZOWLp3czQTFS+fudDkApgwqyYqYgpER/ejJTMjo+kXeUM6Uzi+3OznZ5
         OvwCL21uQPcqDxd94XQJ8j1HK8M2ZCqF7sv3GCECcO6EChcakLdyKjY/k3n5pI032hBq
         x2t9feptM1OB1RbcpresrSQrq9KcMGcO6l/+4zuZZCNBvaVcxVIg7rUDp4B6MSzJDEu6
         T18A==
X-Gm-Message-State: AGi0PuZk9knng60Sd7oIMd0GS9MkdkoHHHA8Ym+6OmER/tsz/fqDQPBQ
	HUVfrUrGCXyHgDXuh3kcBqcPtkYmYRtz/u9P7Ns=
X-Google-Smtp-Source: APiQypLtd8ftrhqgq/6RnJ5qnFSnfzNaIUqdmQcwCsxZfxvN3FzC3GYwf1kFiAS1IaIXQEFXlhjHe+bl82oElgHqTYg=
X-Received: by 2002:a17:90a:cc10:: with SMTP id b16mr5944791pju.29.1587053586616;
 Thu, 16 Apr 2020 09:13:06 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:40 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 07/12] arm64: efi: restore x18 if it was corrupted
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

