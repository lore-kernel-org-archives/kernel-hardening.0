Return-Path: <SRS0=uzRS=6F=lists.openwall.com=kernel-hardening-return-18588-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAB9C38A30
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F4D12082E
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 02:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kAQ83Kje"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F4D12082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18588-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18218 invoked by uid 550); 21 Apr 2020 02:15:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18136 invoked from network); 21 Apr 2020 02:15:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jhbZSy8N7pmIKGLCoqfuWjSb1n91/ddT1S0YkqMO/sE=;
        b=kAQ83KjeKeymPxC8tFl9LqSOU09wryYOH3Ut5Fp4QtEqnkFBqwDOtM03kprDG/MYPB
         33Qtrj9LQFkGfgRCPCzwJjXpwrT0xmeHSdgRANOUBywF6AxQjg0dKXVmnr0qSWtz50Oa
         bl6qbQyPLNSvkLhEhv06EXy0JtnPBS5QDsma3dbrpedM0dagK+Aiza6GlknaLT2doark
         A4f3m3SHS8DuK6cZNIyUA6UW9ibFykjSJfV8R5iVG2Qz33IqVpOrx5YHGsY9lc6LoHU+
         hVBFXM0Zwuqzbb8qvTwTgmmU/ReSXVtmuKGFUe3ewBrMDv3cClvqp6ELYlJQekoGEWrC
         3irw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jhbZSy8N7pmIKGLCoqfuWjSb1n91/ddT1S0YkqMO/sE=;
        b=qzTy0ggZ1rkWobx4bs+yS2l2iXxAKYruM2aTRy8DQr9ktlhzLgXIJgbSqaboueObIv
         f38fgE/rCLXODw7qCi2SwVijtHEQEGHgbtJLXbW5cEwsyLLkCGpTOGcO5KgQ6E2ikode
         +zm7uuQ2iJAIeFwLCCxksLuNSKlFX46Vcrj9xywo67B3y29pMwVi1dMzSi76zot7mxVt
         5nexn1kVV7l45O8JZhelqtC25gV2GraaC6/89pfp6nrt8Jpl2167OS43O4LQhzBhVI1C
         7UNdN3CiRezy1h+v2LWuN6o6XE7NGoT54XO5tr2D7Ph2iSQ9FpiEFGR7NG8L1uG6uIXK
         nl7A==
X-Gm-Message-State: AGi0Pubac/DdqC/KyFcXRZ8/3tyXr3+OLb29hPGLtAoZnl836aFkgFfl
	B79LHTB8woVRHJ9ZK00wTET4aSk6UwqUMi2WmBk=
X-Google-Smtp-Source: APiQypJeQ51GKYTLWGJ6SQJrs5z0xMQPs0pUmxT6pjND+5RZ1ua5OrG31eM4WHd76TQ1S9eC6oZk5PYVIh7OMeESRco=
X-Received: by 2002:a63:751:: with SMTP id 78mr5125628pgh.259.1587435309529;
 Mon, 20 Apr 2020 19:15:09 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:46 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 05/12] arm64: reserve x18 from general allocation with SCS
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

Reserve the x18 register from general allocation when SCS is enabled,
because the compiler uses the register to store the current task's
shadow stack pointer. Note that all external kernel modules must also be
compiled with -ffixed-x18 if the kernel has SCS enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 85e4149cc5d5..409a6c1be8cc 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -81,6 +81,10 @@ endif
 
 KBUILD_CFLAGS += $(branch-prot-flags-y)
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.26.1.301.g55bc3eb7cb9-goog

