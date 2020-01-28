Return-Path: <SRS0=OiMg=3R=lists.openwall.com=kernel-hardening-return-17628-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AE2C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:51:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BA25820CC7
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 18:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDoWJGqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA25820CC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17628-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12042 invoked by uid 550); 28 Jan 2020 18:50:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11965 invoked from network); 28 Jan 2020 18:50:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SyMS6kTKxjGvSfy1yskMuy1o1NPxNd1pRRReN/eh/Yw=;
        b=iDoWJGqwVEP2tHMWm4+bS9TCXvecvsiZmIGPR2wyOSJfmTsLMvUaQm2ursorFU3Ra7
         NuHDNghwRgHXAAk9m9KAPMbK4uTyIcT9xr9wE2QiZ1dUFfX57GqHyiEoehb3XJLjS98N
         YFNOY7pkup2SOO21fY5am9qSl3hqr7M+8fKeSXR1JT8QJuNrKvAgik306CX6uTTelKVO
         jSwC4WXDfkQ4RkIwPUjXYeg4cRSfyvTDlYYopLdqGGEns5H+6Co2aSHsmd2TRUBwb4ST
         Jn0rsT+JOm35IDm2DnWe8BFGBEW8Lny+TWpjqr/yQiw7tMRlFt978M/BMe3aSyd1G4ZY
         ck+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SyMS6kTKxjGvSfy1yskMuy1o1NPxNd1pRRReN/eh/Yw=;
        b=UTuELBNo3701EC1y/CEcJVpPZpAJgw2TlNVbM5RPy2GRHrw3q8SifkQFc8MEJa+IP9
         5CJWc3aCoYQ87MDSL3LJBjYibaoeMJg4Flz27elaV4ZjXf/skNz9ZRX0sAt++xfekmyW
         xDUtCfZMbQOpKfm0KZdHwZAq1LFnwQaxcEryW5vzJB7h7NTZXf8mcSJSyeZ+xCZJTcVW
         b01kBhxXupgwhcfjD3qrZhBrfMrUe+KsswUd0tB+aHXZiCXVlGV1RZe/cWQMLd6oJq6s
         byl767xi7rwYICDZqQFRqDY033sXJNgqgrt4hewMhNshdpVK2Y0BuYALy0/x5xRBMqJz
         RhLQ==
X-Gm-Message-State: APjAAAVpXSpgoB9riKeab3Qn0UX8dhCqw5ibv1FPb/xgVBNWH8YBge6M
	5jpaIezOcw2rYiOYU3Lu5A7GklOcrg/M2HnolGs=
X-Google-Smtp-Source: APXvYqwBDfyzeAgl4Hbq75PkVeA00YwL16x26LdN4T6C4RXjAAHG16RhCosHW83/V2HMDMrDJF1ZlFrzqFIRTexeGxM=
X-Received: by 2002:a0c:eacb:: with SMTP id y11mr24452398qvp.68.1580237396348;
 Tue, 28 Jan 2020 10:49:56 -0800 (PST)
Date: Tue, 28 Jan 2020 10:49:30 -0800
In-Reply-To: <20200128184934.77625-1-samitolvanen@google.com>
Message-Id: <20200128184934.77625-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200128184934.77625-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v7 07/11] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
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
2.25.0.341.g760bfbb309-goog

