Return-Path: <SRS0=PuQ1=6L=lists.openwall.com=kernel-hardening-return-18640-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07873C54FCB
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:02:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 56448205C9
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 16:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fqLi0Sky"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56448205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18640-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12234 invoked by uid 550); 27 Apr 2020 16:00:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12177 invoked from network); 27 Apr 2020 16:00:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jTb4YPIUPKL1E1OLE2ifNkQg2x2HSYmo0hj4Ci3DZ3A=;
        b=fqLi0SkyPjbXxPX/hPsXZeMNhq35aYqBNJAvT/Xx+BzPh7YlBx6i8WTACzT4FBHIRv
         yB3PamKTCHUBg04d9KVAhujS595QnxeeGH1EBSaBLJkOM7C2p6uhVroooOZkVWSFANBo
         EQq7r79O7lYvn3jVBEw+TI04/17VIVUaDIXO9ddhSuge+F4kykHowiB4XA1PixFt7f06
         knShlLB1Y6N5OLuGmCs4M7eKqc6BblFu2RW9cdCpUqsLmxzOIrCdokmS7rXLST3WR3EJ
         4YBYToSahIZ4xPJWmk/lOEd0e03hxC16yaJ1xBfFhei9FtsLMetBOg+CemUkcnsn0gik
         hibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jTb4YPIUPKL1E1OLE2ifNkQg2x2HSYmo0hj4Ci3DZ3A=;
        b=mzjOOI4qNZ8KDFQLW5EJ3Jt0L9Gc+OxY916GiX9Ki+EyPraSg8+snbC5TgtTHkQpJM
         bnhguJmb15DIsB0sfYsYk/S29Jitw/9ltySu/FzKbYhAO7OvNFK18NfbouUayKIhTsHB
         VYTbUwwgGaeLwJFvOSRzBe2Pu3swvpQrg8Deq10W1vGY5RR7DiTeJl8v8EaHEskfI1K5
         E+zsszobZtnSZU0b4uhB3K2r77zHDjH3ENCkMXC8WWe+o3qra05tAGOkscF7/bkI0Wb1
         05pf9fExPg5SNgUr6qgrKgcHIwT8MXow+wobfvyQVllPTss469k5YMN6ajxl86OgQc5N
         gRbA==
X-Gm-Message-State: AGi0PuZQY/awW5Jhw6e/O+unuMJ0gjuYrNXW7u4h0C1+/8VQM+QIk55/
	IDdQS4pIXEjckzAtyrWG98hPhKoKdzRxC8XZw5U=
X-Google-Smtp-Source: APiQypLDtauRhcKiTQyzgC2LQ3XamOTxT1OCw5Clsp9y71dsXWMyuVGmw4gnWIV3Yp64XvmFFiqiRAvcGkJl+hJ0vkc=
X-Received: by 2002:a05:6214:1513:: with SMTP id e19mr22507959qvy.75.1588003237430;
 Mon, 27 Apr 2020 09:00:37 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:10 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 04/12] scs: disable when function graph tracing is enabled
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
index 334a3d9b19df..45dfca9a98d3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -543,6 +543,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
 config SHADOW_CALL_STACK
 	bool "Clang Shadow Call Stack"
 	depends on CC_IS_CLANG && ARCH_SUPPORTS_SHADOW_CALL_STACK
+	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
 	help
 	  This option enables Clang's Shadow Call Stack, which uses a
 	  shadow stack to protect function return addresses from being
-- 
2.26.2.303.gf8c07b1a785-goog

