Return-Path: <SRS0=uX80=YS=lists.openwall.com=kernel-hardening-return-17120-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BA9CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDC9420867
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sf2++rx6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDC9420867
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17120-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8056 invoked by uid 550); 25 Oct 2019 09:28:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19847 invoked from network); 24 Oct 2019 22:52:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K9E/B478ig/3FT/HPhGFdlo0v28kyi4gF0t5BJVte+4=;
        b=Sf2++rx6Q2f/i1fpiY1IH5BzPv/ntmDtPfAYAcJd6USBAJAOz9sAjWsxe+ZQUTmcnx
         TMNKhZ9IeyI6W5I8YOZc8fXZ3u7T3/BLv8RDrQNIon+Exd84mb+I8CDhoR0YeS078Znp
         iX0O0MXuFJ/BEJRR6bcFehBfigS7d/r0z9CxwLPRboIP4QhEcU+ca/u/4Xa4bj0S26uy
         ghCd/C77mcUctZEMYZqeRUwOe0hyC5c8SFUlYqcW/iOIJ4/mnlU1ytp206qaDtb1qyhG
         6rlkjs5YcBzM11A8IPnUQbN5y1qAQgVU/1FJ7AsSP5RvjVSpldSCmL3izOFewNOkwTDQ
         bLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K9E/B478ig/3FT/HPhGFdlo0v28kyi4gF0t5BJVte+4=;
        b=AIYD62fPRKyBE5JYDGT+0je+HYOzNNpTZ+SGVkoQpAoCB1ZPuIA3ldIMC0C16HLCpi
         vtqiSybK6AQLw2NAoK4G6R0RpZumqjKqQAs9yCSyybfUd6RWW3SYXGu0YISrXOQ31XzA
         D5Ar9/7gKvm1YauR+bxe5e47Pox4mllG2Wp6uoYxjV4LkZxQYD59xdcd527iL81cEiUJ
         kfApQmPyLTB2buwPCpWzoDpNt9pCXszlNvdTsZG9dBjZ/ICieUkhw0eyUvq8z0MosOMS
         EPJ5opMZYYt3laxAH7nE2DLSZUiMANTn3t5PY7hxqr42Wrkm7K6f5M675PN7l83eu4mO
         uArA==
X-Gm-Message-State: APjAAAUvksicpO9jkDNTtnnF62mqz6RAztktadTQdJAOkI3ldNnEWUUW
	mHTYvjztRRzCPD4uN+8sntIUPtE8Wdci/LzQarM=
X-Google-Smtp-Source: APXvYqwUVXHwobZjxnBDuN5eJ28nFXqkiy4fKRpIDKsINI+3xWarkHRyuPSmd2/SRLrM/YyI5fpTK4tzGG+Eou/B428=
X-Received: by 2002:a63:1f4e:: with SMTP id q14mr536510pgm.144.1571957551921;
 Thu, 24 Oct 2019 15:52:31 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:30 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 15/17] arm64: kprobes: fix kprobes without CONFIG_KRETPROBES
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

