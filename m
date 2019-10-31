Return-Path: <SRS0=NL91=YY=lists.openwall.com=kernel-hardening-return-17194-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BD6CA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:00:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E8854208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6nZNOFX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8854208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17194-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31840 invoked by uid 550); 31 Oct 2019 16:59:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15562 invoked from network); 31 Oct 2019 16:47:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K9E/B478ig/3FT/HPhGFdlo0v28kyi4gF0t5BJVte+4=;
        b=Q6nZNOFXJobNQh66SBURqXR9jjgGc7xPtfVgiH00Q94Wq/lt68cuARge++0iJSOHbl
         oW4NMEq+9cHqz9gbyOSyiBZcNrTjy/SOh+b8CYr8g09qvaCHNujmM1eqjZChkaUIta8N
         R1Nytm89Z4g9Csz0lbSdVY2lZ5qMNHUcg9EX/BaicjSL2hYM0k+G3ChifSzc8IJFDYk1
         GpIbxO2R5s2CgPxCiu0JT+4D9XPEJ59tckUnFp1YBhgg19qHemtrJSnWnwdM64fHfqzH
         V51MYQa1MpvdRri6T2bUaJeLk+9cOeQ3PhUqIY7fT381QfU0I53VsE/DJ2wREqjXj4eZ
         2Qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K9E/B478ig/3FT/HPhGFdlo0v28kyi4gF0t5BJVte+4=;
        b=mBTPOmnGiRADNbRTdjkAEVZtZmoMwGijYjan/swfp5SC3yoNceicaWA4zUEkBckUK2
         n5wQlIiAAXM1VFfUn7N9DtAEd17lvxCZzWN9aKSjBCp8R6n83JG6ISA87rRkXyArsz2c
         8EotHx00N8fQyh6koZZaJCgJM6iuLtfzoxpgCBHDHYvWtBcKCwcWX+KZ8CJvwUhySC/L
         A9mupofKS7negpmOnWNy2rOxCazivsjqwB4kwHn+xNTKrrtkYwAskEeuAa+D2F2lllGj
         gAen4JGNIeuRk2vbHWQzBfbDOanRREq/qLof1OmCs61KKsHYe62Bt2yExgeOzZfZ7N6P
         EAhA==
X-Gm-Message-State: APjAAAX04KrUTN737u7PXpnpq8qOtiOR/xolnrcMjeTcBaSU7IiADmDw
	vFR4mJvxWLaTfmy1BlxkM+k4XtRHQDIqH0f9sjE=
X-Google-Smtp-Source: APXvYqzC1qzspsODaXGFhM8lzAz2Kkvitd6Mcb2OnCrnHZg+dDRsPF4zisB/iRaRWzHFab+ubKlzQJYNZnG9GZBONHw=
X-Received: by 2002:a63:e145:: with SMTP id h5mr7826628pgk.447.1572540427770;
 Thu, 31 Oct 2019 09:47:07 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:29 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 09/17] arm64: kprobes: fix kprobes without CONFIG_KRETPROBES
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

This allows CONFIG_KRETPROBES to be disabled without disabling
kprobes entirely.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/probes/kprobes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index c4452827419b..98230ae979ca 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -551,6 +551,7 @@ void __kprobes __used *trampoline_probe_handler(struct pt_regs *regs)
 	return (void *)orig_ret_address;
 }
 
+#ifdef CONFIG_KRETPROBES
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -564,6 +565,7 @@ int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
+#endif
 
 int __init arch_init_kprobes(void)
 {
-- 
2.24.0.rc0.303.g954a862665-goog

