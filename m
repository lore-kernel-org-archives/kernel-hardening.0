Return-Path: <SRS0=gIYQ=4N=lists.openwall.com=kernel-hardening-return-17909-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A284C35E01
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8D87B2084E
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rcZDangc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D87B2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17909-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1416 invoked by uid 550); 25 Feb 2020 17:40:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1349 invoked from network); 25 Feb 2020 17:40:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=euAiLk7SvDA/PnGZzpLLTI9flOv+YzdznFtW1y3XFgk=;
        b=rcZDangcxdPLQ8c/UeSJooK9TmmcaDC40GzTyXoR+zBGLCamuGVic+lOltfCliyqYp
         Qy8x3/XWiF5TB8IYJLOgBrOoaX/kfXC+FQpjknL3PmAvzLsHKIG8DFoA74qXXIQXcNUZ
         0OPMc9Q6heNg+Um6Kgciy/F5zEx8rAtsKgU3ZM7obRhY5/2A+Kk5A2CEjGk/5z4KifOG
         9Z6jS9mj4n9vzgOcBl5JrDZVyk1nzFBi2cDuhhMmE7njtr4mtFSRw2VEqaau0AxfNwT+
         T7LcR9LbC/GlbWKawMf7nnsCnVxQ4M+uxzYY1Vt1qL5/aWpfYaqxMkUArMyYV5gLmZTm
         3Obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=euAiLk7SvDA/PnGZzpLLTI9flOv+YzdznFtW1y3XFgk=;
        b=SY9RSftACSsaSq8iPrzPexHI697ESQnj8U1bnFv50kGHAf23wQDL0Smoe21T7rppFG
         mdzCrE7JOrClaHOMK/Gk+mFUuTvxfFD5lYRM0b53oKCziLewLazhovJi0UyXaPjf4RF3
         3gJyyN+gfEQbAWFk6P2s0HrGNb61xy8yqYFw8wh8N7/VRcNLKQkdK4fk1SZ1MemS0wBm
         ZORy9gTLApDVGcI5meXfi/6gdRN6QhYPpaf1fKppBSuwwN2JhyrkMG9/Iv1TYz3uXtPe
         x86TjVi31l3CWUmproAulM7BFj73BPuYwUDv3G0pU61aW0yYFJEoHZBcGN5IHOEVDGu2
         SO7A==
X-Gm-Message-State: APjAAAXm8lUTY3RdYkimwpxZ7z9ZY+IR3PvN8rc+0cuT8duThkGR9X7p
	6+Ati0NKeLtvQ0PeF5DQ0KyWUaA4IhFL8a0Sbg4=
X-Google-Smtp-Source: APXvYqxlqJxQl5BI1MzivwW+BHpAHu+yoCC0b4OSIv8tWhwsj+eyaqOdONKRweH1H/aDrmbR0wf2esPZBfRljhjv3g8=
X-Received: by 2002:ac8:3aa6:: with SMTP id x35mr39983775qte.38.1582652397221;
 Tue, 25 Feb 2020 09:39:57 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:25 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 04/12] scs: disable when function graph tracing is enabled
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

The graph tracer hooks returns by modifying frame records on the
(regular) stack, but with SCS the return address is taken from the
shadow stack, and the value in the frame record has no effect. As we
don't currently have a mechanism to determine the corresponding slot
on the shadow stack (and to pass this through the ftrace
infrastructure), for now let's disable SCS when the graph tracer is
enabled.

With SCS the return address is taken from the shadow stack and the
value in the frame record has no effect. The mcount based graph tracer
hooks returns by modifying frame records on the (regular) stack, and
thus is not compatible. The patchable-function-entry graph tracer
used for DYNAMIC_FTRACE_WITH_REGS modifies the LR before it is saved
to the shadow stack, and is compatible.

Modifying the mcount based graph tracer to work with SCS would require
a mechanism to determine the corresponding slot on the shadow stack
(and to pass this through the ftrace infrastructure), and we expect
that everyone will eventually move to the patchable-function-entry
based graph tracer anyway, so for now let's disable SCS when the
mcount-based graph tracer is enabled.

SCS and patchable-function-entry are both supported from LLVM 10.x.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index a67fa78c92e7..d53ade0950a5 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -535,6 +535,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
 
 config SHADOW_CALL_STACK
 	bool "Clang Shadow Call Stack"
+	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	help
 	  This option enables Clang's Shadow Call Stack, which uses a
-- 
2.25.0.265.gbab2e86ba0-goog

