Return-Path: <SRS0=34nV=5W=lists.openwall.com=kernel-hardening-return-18434-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9A5C2BA17
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:42:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D03924976
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Et7gqyUD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D03924976
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18434-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24280 invoked by uid 550); 6 Apr 2020 16:41:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24186 invoked from network); 6 Apr 2020 16:41:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9QG25IWAvZkbAzL22nhTW74bT1ay/PnpyS4BHMHWGZk=;
        b=Et7gqyUD+/vBdaTxuXGtUp/T61DuoxfIWoFaBtN3Pan+9c6mJeAvmtTBqFUxV+t/h4
         LN0HQT9+KjSaqn7Mixerv+7k7S7BD4mkDsLs/o8wZMIjVa09HJA7KFSGB/TtuXU7FvlL
         6uPHdyBl7z3cK9g1xF6YKJ4HL90gk6SiklDTGe+TeqWBho/vNNZIxuxtDhoiNjjP56EE
         VSD6bCJZy8gm1psKtCCT8FCp/6jDu2WpsQ5TdwxuxinTh/gByzaJiThF8xLLt1HhDfgN
         opEo0Vvbom6U7ovVNJ2IYajd7Ohq17yrtIacfoTmqzq2KcnP242dGSb7nqvNQr4W2sOL
         fQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9QG25IWAvZkbAzL22nhTW74bT1ay/PnpyS4BHMHWGZk=;
        b=MVn4+36ZaoOOY4VAueOcJ6ZHTjy0RpQrqATWdw/Z6fpgMCYTRVMSwbOLoWd7Pe/A1t
         IH1UJhD+q/JMVzU5fw3gejCV5HqfJAbiEHlqgGvVO712FOO2v+oc/TQYvKj1511IIrye
         EQXlTLc2eGYtYJwrKMF7l9BqbDRLj9SZ1jNdfbWUPXYtW6W9aiffvJJrkhEDqUlsFUHg
         HPoSsFFoDDfS1aGTXGYQWIgi5q7SP/U2DKzMc6FA7OEBzA6ShwMh3AOEJqm9SQPmFcVP
         mDGZCBGDhD+B+12s+o1c5Kb9uq88v2oEtOqABeeJdoARL+XMUYKAmQHzBftl0irndOM+
         oMtw==
X-Gm-Message-State: AGi0Pub5atvLngpeIql8PcW3lmiJDqPbCGBVKFdD4DOTPit3VwaW/vrv
	y36NtNSZYN0Hq2yzYbqBdZ4ecy4ZD8Q0toQEyh4=
X-Google-Smtp-Source: APiQypKOUCwdutCrbx5jsB7oXvfPBtLmcNStpAuGEoVRC2rwC/xHSN2ipZVV7C3tJFoLyJ5tV7qmBNnr17/luexyr1s=
X-Received: by 2002:a17:90a:1b4f:: with SMTP id q73mr169352pjq.188.1586191301528;
 Mon, 06 Apr 2020 09:41:41 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:13 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 04/12] scs: disable when function graph tracing is enabled
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
index 691a552c2cc3..c53cb9025ad2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -542,6 +542,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
 
 config SHADOW_CALL_STACK
 	bool "Clang Shadow Call Stack"
+	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	help
 	  This option enables Clang's Shadow Call Stack, which uses a
-- 
2.26.0.292.g33ef6b2f38-goog

