Return-Path: <SRS0=FM9d=YS=lists.openwall.com=kernel-hardening-return-17118-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44887CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8ADB320867
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uLf+lw77"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ADB320867
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17118-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7701 invoked by uid 550); 25 Oct 2019 09:28:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19779 invoked from network); 24 Oct 2019 22:52:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+uiLq+iUoKYbKnLFQDjwDIIzqGudQy8o1UFEOkmkrHU=;
        b=uLf+lw77gVEoxfyZjVffG8N9AkGSFT6SZ7rKTY6igTbvtmj5tkgs6S87yKXapR9kBD
         NfJzX9FsM1QPF/BRZh7tuTNd9Bft+wBmoGpSgAiFGgU/eFojwHMx3hY/jiQo5OXG88H+
         n+2/sETYJSjx1UwcF1JDwNNf9o+ndIsqNQGNcfRmpV1CBEoxTmXgI879l/WxjZMkcbmb
         kFXbiNvmWzULL9yr6G9yxYiRMJuYM6XDRrKUuDcJ0X91UFc9CGS/3Wg/GkwQsbD/KzdG
         KcYEc9VsXZBk/vRUd/5xFUU2jMu6PAXVjvl8vJIQVZYzQ1oFFfyD8naEYVJQbR65Robs
         mdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+uiLq+iUoKYbKnLFQDjwDIIzqGudQy8o1UFEOkmkrHU=;
        b=nVJBpniI/KDSjO05IWZYPZQ4mwl+n2w0QBk330vK8b+gQ0UL0qQ+aPeLaxMqEMnZ0e
         EWYlDuVeQ2d467QrZklEsy/LX+ugY6CcdQNpvj/bLJt2ITmZeKlIcYYyep6Uoz53pIKp
         e8wdhRTDNuSxZt1/zhzJY1y85WbR9tfC6r1hHhkY8mDjuLhEaUffa9p4yYg4W31TPIdo
         K1kEGqA+uQJtK6tdC/eikkwTQ5Y9uJduPciAZca6yzRazWbKOE7og7Nh53F8noXsQH5D
         8ZYet38iLrdpXi1XIS0zrDnKV/Hz+Kq7TR8WWrFVnE7qB3je0tt5pKyYpnYsSZI4xGuF
         YwQw==
X-Gm-Message-State: APjAAAVNephd0bO+6MiCH6e78wdYyNjkp76sVdPfK2YtyuGgeKHDRyF8
	pbaATjZTtz2ck+HkCQyRoxm4ZoC3Wv1bLEKgm5U=
X-Google-Smtp-Source: APXvYqzRSdeSSRgGBGnoZCPWuY69NwMrQK4NIj2mmmt3agCQs8uemlrog/B126rrh1wmew1IPRee+I1rJJkV4cdOR3k=
X-Received: by 2002:a9f:2271:: with SMTP id 104mr36427uad.127.1571957546730;
 Thu, 24 Oct 2019 15:52:26 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:28 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 13/17] arm64: efi: restore x18 if it was corrupted
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

