Return-Path: <SRS0=w0vS=YZ=lists.openwall.com=kernel-hardening-return-17245-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B4BCA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDC892085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="odv3zPa4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDC892085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17245-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3131 invoked by uid 550); 1 Nov 2019 22:12:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3086 invoked from network); 1 Nov 2019 22:12:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uZ/kQt4EYM2LvpfCusnWoxftHyD2DxgcHTICv7X7dqw=;
        b=odv3zPa4RgQ8s6dsoDxvbsmHF3EENGYKEFkki0g9WgsTtiUy1PWOo4QagxAFwNjlM5
         UaXo+6ESXS0tfN9t/uaTyImKPgoUdkbU5/6mXIU+WDuhuaMZVZlToQjZBZjUeJ+XCKaN
         AZaYtQv4cn3jcrlvgSVPiMAL2aX2o/kWtvg0ZhsbFx5XNHfG27Zn+lw1m2rgEzTuN0Qx
         AhXuI7DUwTtXfZmNooQs1nB+s/Ns/DX1LvGMoiAbd56F3AJ+mJtqGL8w4imrJ9czieHh
         o3BNgiNlRATQnbvYsOjBOz35StnAU9Usdu1hP8mnieHo1tIou+WOWs5WVmR96RMvFpMw
         BkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uZ/kQt4EYM2LvpfCusnWoxftHyD2DxgcHTICv7X7dqw=;
        b=j8Jf3zq+ltZyi8FR4znCOYKhzKwgKrX1YqjJVsFS9TeP0WZA/fMGmOIRNgNuXkIKXH
         jum+uF2hsfdowQQkitMFNAbvkGy/Y0g6uEfWvOrL1EgbDzNSkbP1FEjqQQAXcV21zrmc
         ZVjqFL/ePwrrufpgpZ+WErtWP/xY0WFEEO5KNkIeJH7POuNJj2iEK4NAI4Nl9nUFLb6X
         bAIj6muYsFfPBPkDNH8LJ4aU+ab0RqkX9YrJQfrSnSWHmcrDX274tE2nQh7BSaIggvUW
         5QDrsh7A4xukdltHw1cQqIbN8z6nphyu9dNR9EiEaHwh4RYW3bxbnv9cknc4vMshfaN6
         f0pA==
X-Gm-Message-State: APjAAAUuBhCy9gOlLTZ4l/pMh+3LDEkXJKoRm2j7Vsdl1kAkaFx+QZSI
	66Y1dvuWOl1YNniXNRwjgfjPA/GQc9SdBSAWQr4=
X-Google-Smtp-Source: APXvYqxnvjccMKGZa+EMFNvyVvl4JQq0YHBc8XNC8xBIuIHK+TPnyLwR96cD6M+G58PTtTiYueuKAoyE/cNOXhTJ/L8=
X-Received: by 2002:a63:3203:: with SMTP id y3mr15810585pgy.437.1572646351983;
 Fri, 01 Nov 2019 15:12:31 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:47 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 14/17] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
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
Reviewed-by: Kees Cook <keescook@chromium.org>
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
2.24.0.rc1.363.gb1bccd3e3d-goog

