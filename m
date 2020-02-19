Return-Path: <SRS0=o8M1=4H=lists.openwall.com=kernel-hardening-return-17833-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24CDC34031
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1CDA622B48
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qufzpGjE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CDA622B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17833-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32409 invoked by uid 550); 19 Feb 2020 00:09:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32316 invoked from network); 19 Feb 2020 00:09:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QniVckAJWtqLmmFgAWqtQvDUqGmhiEDDkK5Atd0uI+w=;
        b=qufzpGjEppDMWPImhTuGEdGT5fSrkUOCFRhcyjZobkamDvVW8lKE7S9n8IfeI9kMjN
         GjSsbQERqiJCrQWg5+yur9ZmpwI3842rBfYePp5EboZsGV0A9NX4KJSaHBYX9WS8TV/B
         YxOPfKJb3HR14olUqNzIghumWLSF9JfupKrwhtKGLhHcH+iy/cZLakuxTBBKr3BSQC+Q
         l/d2gtUBVVI2+sDEnrXi83zlWZ5bO/OYVixaPN92nFcUWQ3ZPH+WoaCJq/ch+3VstHjI
         DDMR+HT+E10IhOJZsyS+YJ4gi2CPv7gIBX5icVylNk3GYCOKGpIchxJrvY+jCKqp3YLe
         pYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QniVckAJWtqLmmFgAWqtQvDUqGmhiEDDkK5Atd0uI+w=;
        b=c93dUL279+s4dhZOOvQvqXyIaTz19/LdehOOPs3pqj3KMEVu5xT46dNOUZquX6d5Xv
         eomYoiWdpZSsS5yiPbiFc1RFWDP3bec9yzviXHWobuk5n2yhsa41CSVEVkwzS83bMBW2
         c89GOPqRNDZsdAw9de9xbbirjexYWohmX0rxQNMrxVLLKdcFRTCI5MpoOncMO/fj55xk
         0NUtcjJ7bp/QCd5SCCuTvanBhnIgrWmVmqDl2wYRhANXLze9/2SxbSSrL+Q3zHSAzmm3
         9F8K42aw8iyK/k9rjD9HSroNj2x+Hqbdz4RIton3dGh71UVXe5VvQWcUDOpamWGhD9SJ
         pYBQ==
X-Gm-Message-State: APjAAAU4zO8N6Lrn0WPvvhl5IJGnn7tKTcHfMP+8DTWeK+pJHjSYiqlw
	nrF/vIzuk0N/aOs1WvzPRfjoqxAWi8/RTk0jF4I=
X-Google-Smtp-Source: APXvYqwciBBhLealMEWoo9KoEMacGgV/WZH2VTZ4SCan5a+9yYr+272BEeKH1BEVWPC4FCthWzaq/J27w407jXSF4NM=
X-Received: by 2002:a63:bc02:: with SMTP id q2mr24517139pge.174.1582070930907;
 Tue, 18 Feb 2020 16:08:50 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:12 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 07/12] arm64: efi: restore x18 if it was corrupted
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

