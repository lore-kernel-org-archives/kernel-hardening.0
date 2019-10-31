Return-Path: <SRS0=uW52=YY=lists.openwall.com=kernel-hardening-return-17195-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4444FCA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 85E7E208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MFB8Vi7T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85E7E208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17195-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32000 invoked by uid 550); 31 Oct 2019 16:59:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15707 invoked from network); 31 Oct 2019 16:47:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9Ao7uN2sNi3wFwgEShB4rOY2NPtO1ve2nhewvDVkd70=;
        b=MFB8Vi7TeDoI2FwYG6EbbYc+LBTOUEvRqAUAKVWlm/Y9wlKU7ujBC6awj8P8GgNg15
         SHrqse6Eby/JmzTas4YOpEbcYfE5zV02IRVEzTRd+/8pcGMuY5LmXsc1LvTsYyOPQRbj
         rWB9hKuYdsKAq5u+1gwPKMLhd3aFBv9y7s34IJD7qUWZFLaH/dCyw0RXobVGkHrXVve3
         OIoYdwBvTIcedJKnwnczA/JcOUoSjLk5Niw2NS8hRSGXfbcB1RQzOd3+hhaLOuVMzDiz
         eb9NXbVSx5Tc5HE4+fuT64N6mKP3gK4YOR6cATCVdP01/rojf3F/IcVEmTxc2qVknVy3
         MHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9Ao7uN2sNi3wFwgEShB4rOY2NPtO1ve2nhewvDVkd70=;
        b=n9Jaldj6bP92UQnNoqu2yza7yj9x8RssTJSYzLtWtPQt2ebtAlsa7R5kzvgGiYOAQV
         eHMN9LNQ4zM0ryDTjEEDjCzARj7BXtj4OiHvU7lqy7+78/ooqA1uPjMA1zEf0YpZ8bM/
         QRpT5RjjQeKkAWCpCDQrmckZkPzo1lVhFbItgTGiKuFdBrBT7nQS9aRZhjRPlQEOuQzq
         y4igPH0qp1F4idJxdQova1repBQZX2ntzypTcNKMdkV3IOxN80Hhmg338EhxwaC5Ikgs
         uFEJ+F2dSx6tcadW54KW1ghfIOLI/jdNqtjqRggYDpt/yz9UG3bBz5oulSM8UHczeN74
         jzjQ==
X-Gm-Message-State: APjAAAWFsqUAQfFbwfQG/rpJMf8w4kB/NAX7CMRvUZHlaSSltwR5Bs+G
	QsA+hSMbewW8HM5gy49dmw5/++uts8iZy+VP/ZY=
X-Google-Smtp-Source: APXvYqyTGY27y+fXLM2c6y9Il6TlGdGiGRpFxeY59Reh3sr0g68TeqvBad+M0W7yvXKqIy6D21VCf66mb2yA9rq9620=
X-Received: by 2002:a63:d258:: with SMTP id t24mr7711243pgi.289.1572540430252;
 Thu, 31 Oct 2019 09:47:10 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:30 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 10/17] arm64: disable kretprobes with SCS
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

With CONFIG_KRETPROBES, function return addresses are modified to
redirect control flow to kretprobe_trampoline. This is incompatible
with SCS.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
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
2.24.0.rc0.303.g954a862665-goog

