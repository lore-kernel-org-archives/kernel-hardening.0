Return-Path: <SRS0=5Qg3=6A=lists.openwall.com=kernel-hardening-return-18532-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DB3C2BB55
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:13:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 84C0620771
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLB6uGgi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84C0620771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18532-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1099 invoked by uid 550); 16 Apr 2020 16:13:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32764 invoked from network); 16 Apr 2020 16:13:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v+FpjDALSMEE3YToTyyoSh5dhgN0urRtPwHsB1+RBqo=;
        b=LLB6uGgi081g4dKc+3D/4hphc5jFZuDn5l3K/Cxtfcs3/rhIPXgTzCDJ4HjatU2B34
         JY4fNmY4l5JYswvESy2IHRhqnwuSzzW+BBMx2qv9Y+i4mCamy8HON5fMlGYrckrZs0zi
         zqYykbeZ1nK8/8teogXlHD/G+fEHWxaLjwONYJdsxpHLsGV/uV6CPYJuDeVcg/JjeiqB
         SSqMbSaUnpkdFmw7gIR6KIznWHRwY5meJ2DEzQesEEI4NungE9nWx22c6EzLC3ly+4jk
         MftpYNrj0up2ZWOvkRRAr9cuASUwgpZg2ADv9LJBOB+WmvPbpOHT0hNO3fPOr3IaSvnm
         7NdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v+FpjDALSMEE3YToTyyoSh5dhgN0urRtPwHsB1+RBqo=;
        b=JNjHDB0l1JucuoD57TgTOgaB6CzhzX1TBhIVOCiREMSFV1k8FpjaVk0Xbhfe4Rlpg3
         A3AfxOZ2vsfcrD6BqjjrOm0rxtIax2NZllonl1hOBp5iPoqCOGe5Og9otgGH2ev/h88P
         f/yIsqaI9EajxHtl5nBS3OJVB4A1GQB8xKEmyVLRxYWrRq9//wlJN8Ooci3MYFBUYTAI
         3tb3Z6/xN+gRDPHMS8uKtCirhnYSemGNmKPNY5azFbu8+Xjk3qcYkeEngh6d7JT4w8OF
         ORyf8na9i3mH5aBJ6bllKOafjnVFZJEJ1BAtmoXsaX1+BhIndE/bytDWgPyD5FxM6RFl
         I7dg==
X-Gm-Message-State: AGi0PubvigWzDoj/4Q4rJ1z3OTGItejsC94MEutYG0eAMh5v6PowLzO5
	k4oSejr5p0XXGJ76ZPVvXMbanNltNQhAA4Pqr5o=
X-Google-Smtp-Source: APiQypJFs2LuRTbNsCDtN/g/2Dzd+U0S8ccpzr5nO2MdW7DPIurrW0+QxGuzgOdLZ6sO3fXFhdLkcQx/1PSGVXyeSjg=
X-Received: by 2002:a17:90a:8989:: with SMTP id v9mr6124346pjn.119.1587053579583;
 Thu, 16 Apr 2020 09:12:59 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:37 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 04/12] scs: disable when function graph tracing is enabled
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
2.26.1.301.g55bc3eb7cb9-goog

