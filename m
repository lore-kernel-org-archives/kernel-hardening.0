Return-Path: <SRS0=BUsS=6F=lists.openwall.com=kernel-hardening-return-18591-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6177BC54FCB
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B542E2082E
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lqh/lP7r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B542E2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18591-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19946 invoked by uid 550); 21 Apr 2020 02:15:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19856 invoked from network); 21 Apr 2020 02:15:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MhRn5bu5/kvUh5QzOzRXssMosuq4vthGJuay/ttgTR4=;
        b=Lqh/lP7rPh/rNI0pAGGOPOxjyqNhok1UwLr2vLWD0Yf86f7hnanuLjyGwBzWQZ0KWQ
         adjhQMVagXSOv+hAiNSZhBIWfPo1li8vCHzgaTrsTgbGbcCuhwU8ClDWwy/MAbVy+yHg
         l8kefkpuvonUyJ59cjRiqXX+Uanx+h2rbnnl9u653BbCn+NR54DJuJFS0NBefuFHtWIT
         lpym/WosEzlkC/QEIHKuMb0NkSLOPkiUAyZo7D28AGRidwedpIeP5oIpw/ESTH4LCZkT
         NkLVJcNX/Q4mglETeVx9en79tfKw8n44frdP6yet/Lhi2dlHbLQdxyyqSLgcHBjLnVUO
         IE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MhRn5bu5/kvUh5QzOzRXssMosuq4vthGJuay/ttgTR4=;
        b=FMZM75xLJAnsbxdQXrPf/s5KAfhrSA3AkH4ltFYEgpqEL4IZ7NgnPXKnKfj7djTLcV
         tF7VTUeMqE0KR8eSRoXBDI+epH48UqdErEA//26rkS3SF2qG5QtWLFkdDg17lVgCnEXy
         wfkiLl68p+ZtJYCsr9kh0Jac+/3Sz+HStAuXVQcl5lrX6ldBxXTRvQWYOilZO156Icp/
         vLtNtNYHwPMGwv2/3GKHLIs4bpbseXkM09TPu2iyuNQcVy+Uq0ee7rwowN8nouu4IMqL
         KAaSyfhpImH09qusLMXMjQf5KGvPuTQEqVyPEThKmYCimMhM/OAfaUYxLEXzwoJPAWVY
         yWnw==
X-Gm-Message-State: AGi0Pubp/NGFf/8FPUkR8Yo8OS4gNZEgtEasYTiy6idtgkEwRCQgoUN6
	YY9SFxfq0Ms3jxviu9DORjz2qizviJmd0ZZrom0=
X-Google-Smtp-Source: APiQypL9J2bahRQ34+pQ2Eqpk4jSOHei01Ja/PTphpnst//o5YzkDVHUYrIrIHLrDNmaV4j7WDYWllqGZ9rSI32ZS4A=
X-Received: by 2002:a17:90b:1b05:: with SMTP id nu5mr2791728pjb.110.1587435316700;
 Mon, 20 Apr 2020 19:15:16 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:49 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 08/12] arm64: vdso: disable Shadow Call Stack
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

Shadow stacks are only available in the kernel, so disable SCS
instrumentation for the vDSO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index dd2514bb1511..a87a4f11724e 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -25,7 +25,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 VDSO_LDFLAGS := -Bsymbolic
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
 KBUILD_CFLAGS			+= $(DISABLE_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.26.1.301.g55bc3eb7cb9-goog

