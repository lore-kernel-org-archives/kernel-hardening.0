Return-Path: <SRS0=+gez=6A=lists.openwall.com=kernel-hardening-return-18536-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95205C352BE
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:14:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E396A20771
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CpB297mh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E396A20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18536-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1872 invoked by uid 550); 16 Apr 2020 16:13:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1806 invoked from network); 16 Apr 2020 16:13:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MhRn5bu5/kvUh5QzOzRXssMosuq4vthGJuay/ttgTR4=;
        b=CpB297mheaErr6yv8xzZk9C8e3OlyZuurSZ4iPlqnxBL1rdN7DVreXtQ6hHd7Wghk3
         A5W9OQc4/k6ybv0BMxLVLn8OvbS40EACfZw8xiC3B9iqMWTZ/G+4Y/YX3/JNpQMeDGS3
         ay0rPEcWXkE7+/beHpj+T7HGAeju4SLB85FtaqnWCnPyeZYfmL7ROzgbfHdDeuyse6Mw
         X10A0ECz0Imqt1Wo4UmMjqK65aL12fZ5Eglv5O0xEJh6LVssqIx/QWQa3QbH0ppYnbu+
         0maH/v5qWpKrIiGAPfF4cw/U7QIU4ulRW3FrsdGzWeLWUmoK0Amlfi7T20CvdzF4vk8N
         JCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MhRn5bu5/kvUh5QzOzRXssMosuq4vthGJuay/ttgTR4=;
        b=uCfZ+vD634nq0BY9ho0sQC+yXWCYpfSyfegV2i++5ORhy5olWpyftNwB3A5Umh+wKY
         kwkUIfoHpY5guZFgCfG+WiZf8y5g9OxTx4j4TXzN1OwnB9x76NQvjPHt7ve35/VT874d
         AeqLRLAdgnt28+EFyP/9JvC5eHZCBj2330eRco+sarXq4bpQUGpULBgH6NbRMhaj/vOQ
         bGc5003kLQKzS3raJ9VcxZEX7H5q37r66g4eI3s0PUV+CmZCIR1/afEVm343eraXzeto
         uq+cf2l4FWo64uyRSToG+ED0ybG55ZmZPY/P3SuKE0cnfqM0Pm5CgfjPWy8do/m288Eu
         yMrA==
X-Gm-Message-State: AGi0PuZjusz3sTMTNXPkoiDaPotsPVBdLGHB04y6D8lVlRLxEQGPAx3m
	s/n7noRkN9f2S8vgUkGYYbs8nQf9lW6uqtxrF/c=
X-Google-Smtp-Source: APiQypL0T1GFOmyxncLIjxwWs5XI51QswoFv2KQDHvzuxs+kU6I+8aUYgz8VLRqT+kH3Do9DXOfw/WbQdUM/RpiZ80k=
X-Received: by 2002:a17:90a:f407:: with SMTP id ch7mr6146496pjb.72.1587053588956;
 Thu, 16 Apr 2020 09:13:08 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:41 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 08/12] arm64: vdso: disable Shadow Call Stack
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

