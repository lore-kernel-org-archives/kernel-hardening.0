Return-Path: <SRS0=rXb7=YZ=lists.openwall.com=kernel-hardening-return-17241-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDACCA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5876D2085B
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WX+ZlyX9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5876D2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17241-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1102 invoked by uid 550); 1 Nov 2019 22:12:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32725 invoked from network); 1 Nov 2019 22:12:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TmDnfQN5KSEC3g/578TQjZ7QNjxfyUPcu+BQjF9Yuvo=;
        b=WX+ZlyX9au7TTis+HDd7Dbd6apXsSxGT4BjPuLcLwhq8XdU1hWXuu+jMmXXpmqn/ly
         JnciDuOZ2YKOinrTMYHNYjglGY6CBM9JRa6UwI5ny+82cASaJNLEYq03XkrGGMRD/45C
         080BYykDqPbpaWcEFlq6ukx4uUgLPbDYn8rQoXBjaKsPYUg8U6UVKNYt0gsSY+aCZh6t
         sDQ/hg4YUpFcnNlIJocP1LkLyLwN/E6CPVe3fwUCeFBsqzz656n40juIl8qkmBDC5VxV
         leO2fOlOj+kIu6XcB0vIjnzmxkmxh31gkv9F3DRvB4cNzr9altIj/aQ4Xeb30TvjIhYS
         CEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TmDnfQN5KSEC3g/578TQjZ7QNjxfyUPcu+BQjF9Yuvo=;
        b=hAOuPvgzqLmhoB06w2gZkRlfQUadfci/VAn29VbmMOLofVF5+4QdbrTJaVvP0BuTJ6
         GennkD1kUB7qgqdWKwni/CV45Gs54XGKN1MVWTI3ay2uQ3CWl014bli5fsVO3Z1QZDWE
         +84W//HYTE7EmrG61UOIG8TZQlhllDvNsB3azXyVvG2HTYyhb1XlVE+r4w/ee7vytmDW
         m+gh1OX7z01QiOgr8NiN5jsvC0b97I+WKTRkyr5XdWMquXEQtezJLQIhqdsVMIARxL3+
         tELF5U+auWH8BnWNeQ9ztvnpFONuYoKvzhfv4WfJyBsKvilw++gUsFxi+43Eo+/QgI0Y
         r52A==
X-Gm-Message-State: APjAAAUzd55ZOht7Jy8X13F0dvib4ndtupSzy6ZXIPGItIM8OZIFxLQX
	el6vpBR5xz5RcD3xXxcgrLJuAzCy3DYrZx55GTA=
X-Google-Smtp-Source: APXvYqzVngOFcUfwiWQ8eDwuiV8sr1oY1W9Y7iX+20vU9uQZSIlJayld9jxLG7yCiTZmX5C4MT0to41bsvZhb6iCe1E=
X-Received: by 2002:a63:364d:: with SMTP id d74mr15884929pga.408.1572646341266;
 Fri, 01 Nov 2019 15:12:21 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:43 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 10/17] arm64: disable kretprobes with SCS
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

With CONFIG_KRETPROBES, function return addresses are modified to
redirect control flow to kretprobe_trampoline. This is incompatible
with SCS.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3f047afb982c..e7b57a8a5531 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -165,7 +165,7 @@ config ARM64
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
-	select HAVE_KRETPROBES
+	select HAVE_KRETPROBES if !SHADOW_CALL_STACK
 	select HAVE_GENERIC_VDSO
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

