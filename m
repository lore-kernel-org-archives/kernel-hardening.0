Return-Path: <SRS0=VFD4=Z4=lists.openwall.com=kernel-hardening-return-17480-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433C8C2D0C1
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:15:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 93373206DB
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 22:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ndn1mcgg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93373206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17480-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20392 invoked by uid 550); 6 Dec 2019 22:14:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20315 invoked from network); 6 Dec 2019 22:14:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l4zxu+Ve1HL3tnwJkQPbvyP6wBLrUpssPL9/jgnN43M=;
        b=Ndn1mcggyHBtKAX2XvpEyO1cvzn5t5Rt5EL74f5oQNI8xON9HZdOIOpGfCHheh4ROb
         ZMN247KbIgaMPUDc6e3RJ7DYNG8PST7u+oWWP+k1N+jSEe2J/d2Hj+oq/JPjyElDDN0s
         1bajoDV+ePEiqhlZBkx0JT+WTHRbNVJ9xUb/RgEkuqCSSWGQ87CELue3gJUsVkVLLj1/
         jMc9JOE96jedSwbK6Jh+owxavogPTbBQc3Lm1+HVnkCfDUu1/SEqZVkaAo5gGN3APpx7
         /ziJCrqylxkp6ltt8RGxlVAjAuQ46tyN3U7+ZPVlmKLcHn2gKg0ggIkQts840wwlTABV
         1Rpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l4zxu+Ve1HL3tnwJkQPbvyP6wBLrUpssPL9/jgnN43M=;
        b=G/DbhBt7LFpkChDtWISIzkauENtJp1xvfq1Qyxse1MunPYN19BBP6AvOpSN+JqN++Y
         eApF79Jsiq+4M72wJCfmgZV3SD8b1KtB/zgmeIADn3HVmZAKoxOu0ZQ/12qjueQXepWy
         EDLKt+xCuGMpc20n/EaQoAUSdidVOIERZgUftEyMzwQfUQaCUp5l7V/qesJPGOv0MQQg
         Tb0mPCMWs+zym4U24fVSNw6MyUKTq+0zD9OwVXI+bvBcR99Xn8/Ozmf/xcKkSqcyxQlc
         Soi5ZiMR1LA24JC11W9gpVGr0z9jIi2fUS+WsaZEitbilwYuu16YoWbGbUJn2A0f3+9J
         Jjhw==
X-Gm-Message-State: APjAAAVarTiqV3BSJOTVZNz74E6n7iW/YyNXJiyKeZ0n8Sgq8/NEU1w4
	vLnMmOxl/5k0BtEJnHBV1FfHzNTYeWWdv4Y+CxM=
X-Google-Smtp-Source: APXvYqxNGRCIoJl/pi6uCzgUEQ/oTKWPk8JXk9O2ag4WW88WJwvi2rvTurqocnD02MdVkQxGa8htdlPNVJwyO2G3YuU=
X-Received: by 2002:a65:4345:: with SMTP id k5mr6095564pgq.252.1575670456528;
 Fri, 06 Dec 2019 14:14:16 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:44 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 08/15] arm64: disable function graph tracing with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
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
infrastructure), for now let's disable the graph tracer when SCS is
enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1b4476ddb83..49e5f94ff4af 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -149,7 +149,7 @@ config ARM64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_ERROR_INJECTION
-	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FUNCTION_GRAPH_TRACER if !SHADOW_CALL_STACK
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
-- 
2.24.0.393.g34dc348eaf-goog

