Return-Path: <SRS0=Jjps=YS=lists.openwall.com=kernel-hardening-return-17114-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AFECA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:28:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 03C5520867
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h7CmDroH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03C5520867
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17114-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5442 invoked by uid 550); 25 Oct 2019 09:27:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19618 invoked from network); 24 Oct 2019 22:52:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mYL9Vajfp90RBhmOr5x+royOTK5ijTSQrnKKnKdSwP8=;
        b=h7CmDroHNc2GUxa+g8sWKLD1CcV9gP1uFZesaZzVHnU2a/VBAGDrWFnqCRU+m5Vbxp
         eaGC73Zpw9RZWybSnsktpUOkuEDcpbZIwlHpDgN79dPEQKA6imXqfphOHV6fZIX1vhay
         UCpiNG3JtiEVtrMytjk/nHqhnqy0gmdjuwm2NOkx0ncwhVH/+Zpkk8+VEcnFqvyBPvs2
         m5wks6dUtk7GMFS4ou0w6XEB2b6UOzqqnC4RoG6rt3wfmnkP2N6JtRALXiO9ySr4Fq8U
         CorUFaTzeYq9F1zwhAtdXHWC+48gHjKj20BQ918yQIZSbJoZWQzd8WGDJiFqjX+ZtINR
         p1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mYL9Vajfp90RBhmOr5x+royOTK5ijTSQrnKKnKdSwP8=;
        b=QzsVJvFXiOr774g2zlTMBC+GgZYwLyCMfbzaFgSvUxAv5D/wLCxKiy2hu/glm4JmdU
         G2TyBqeyW4hv8ZJwWPINzycYjaKYMwtxk0pOWUbJ8nqcq6Q+Ref/FXDi8Z03y6pE/U0E
         pRSSI2U6jCPH8ah9MKL81kYOSF7Wy9QPWcsGaL6qyP4QsDXfMT3O3kXDxivpv5gB0G0c
         DkL+awoP5carCV++cQ/LAguzMwnBaIVmk8HXlAOr+78Vm7slCCm9kv72lBm79xyhhZnl
         eKpWas239AEagJ6R6DygCCE2VcqKdlKh7p78bBIEcTNHwxOWGBj/HKGYU/fPqdkxJkei
         RUCQ==
X-Gm-Message-State: APjAAAWwo4vopZi0ShJIP+vywd5tLZ107Dv/g9Xbm3CErdKIYbW2fkGO
	G6BJP1Y5fQNITtWcxH1AD75mgEy4OwQCbQbxsTo=
X-Google-Smtp-Source: APXvYqyjPZYDLgJTlGq99OGbhTAPtQvVAb9tamVCQRwQTsZBBJQIlLhZeafbs0GYaiDEFKiGX8NWZ+1DbuMz+1REocU=
X-Received: by 2002:ae9:e885:: with SMTP id a127mr114159qkg.427.1571957529972;
 Thu, 24 Oct 2019 15:52:09 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:24 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 09/17] arm64: disable function graph tracing with SCS
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

With CONFIG_FUNCTION_GRAPH_TRACER, function return addresses are
modified in ftrace_graph_caller and prepare_ftrace_return to redirect
control flow to ftrace_return_to_handler. This is incompatible with
SCS.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3f047afb982c..8cda176dad9a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -148,7 +148,7 @@ config ARM64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_ERROR_INJECTION
-	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FUNCTION_GRAPH_TRACER if !SHADOW_CALL_STACK
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
-- 
2.24.0.rc0.303.g954a862665-goog

