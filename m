Return-Path: <SRS0=r/Y1=YZ=lists.openwall.com=kernel-hardening-return-17240-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6915FCA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B0E50217D9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oC92Xyk4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0E50217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17240-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32617 invoked by uid 550); 1 Nov 2019 22:12:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32521 invoked from network); 1 Nov 2019 22:12:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YuceP/m4Sv7I7vrWsOPJ1pSb3CxvhwOwQ1OQoGSTS4o=;
        b=oC92Xyk4xx4OFjCywUW0xRGLKJPopJyks6H3DIWfvMcqM41QRHY8A6HpLSO2oO1inw
         7nVZsYb0ejRziH+5dLCL9D9wKeQQKeMEb1VUrkYc1cMPvyFcm3It+tNXG+Hwcj7gshxb
         6nHSjR+gi4hodQFSJLJDhZIR1+Kzve8eUQ6q7dVUcbIISZ2N2+mSkGwMJQvydH28gjMd
         oRMh4SmcetuL5E9614gPeg7eJPENTgrxaRMgcD0aWe9YQNHjd9wnZeZVxQ0kRl59z7of
         8623sjz/SPs/pQv7SS4ugqqYKNBb1daNI8KHgf/+dBsRhEhkLc4Q35KQzw9rmfiSpNPD
         e0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YuceP/m4Sv7I7vrWsOPJ1pSb3CxvhwOwQ1OQoGSTS4o=;
        b=IVmXyRZ7kK5J/IXjnGGt36v8WJ2OHxC/noRlCmXbG8wWmxtxhIUm5naFsa7i65UaLn
         AgEEzj4ZSht8z0LNUzsYsnmNnnEMeHbfMaYyN3ThIz1Qy0KSvNxciM0gyLJHZIlYyHhT
         vKqK9bOpxLCdbMW76Uxif06G1L7yS3b8paN3BJDYil/v14RJdtXY02zcrAgtq17/gtjk
         sozqufEPEeicVT5hAtw0mHvHoOHTTdQExdvs7xOb4bOdAHpt4lvqkXBs65Qd/kizzcAy
         LaYpuxSJc0FN6ZSYP94uEL3kzs+nEL/aEE/uaoLX0FiFK2LXfcqInwQZVn2fF2YjnwKE
         909w==
X-Gm-Message-State: APjAAAVE8zdwyoYea9kXk0+1Nrrlcs4/COpREm+T+PDabbEkhdhXpwmI
	y5jAsHB5SBdyGEMAC26BlDd8y7dOCZPQUkEehx0=
X-Google-Smtp-Source: APXvYqyESI1nj79EQYAfPNp7QT9azRRC93peb8wyxMPp245spxyPTFrWPJ4dhblj2gZ8cJDr8g3hFVKQrrU1shqGWxs=
X-Received: by 2002:a63:2b8e:: with SMTP id r136mr2674046pgr.103.1572646338730;
 Fri, 01 Nov 2019 15:12:18 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:42 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 09/17] arm64: kprobes: fix kprobes without CONFIG_KRETPROBES
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

This allows CONFIG_KRETPROBES to be disabled without disabling
kprobes entirely.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
2.24.0.rc1.363.gb1bccd3e3d-goog

