Return-Path: <SRS0=MNC4=YY=lists.openwall.com=kernel-hardening-return-17196-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E04BCA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 764B9208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LiHsXWMw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 764B9208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17196-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32185 invoked by uid 550); 31 Oct 2019 16:59:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15821 invoked from network); 31 Oct 2019 16:47:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B4VLNzxMuvBiHcofU7yya6+NRz/joAG8uuuPQJlxTTo=;
        b=LiHsXWMw7bxtDeGEYRXpMn16nSyLdNS5lx+NSaesHfyJwbpJ9dv/hg1+masT0ktx+u
         GX0uOBJ11DAuMgxht/T5EF39gfFO9xTW1PSK4PEU0jy3aCOEqI3nPxqbXhiO3dkUpjDo
         urzDfwcuWckptE/Ao67JmdtLQrusiSCYPZDDMBcxYj/czYbCp7NNwbd7zcOwa1VvwCwl
         bCLZbQgxKTiU/SHhlKA9CxZwmprb/+rX2Rq8iGPkaL2PUwfngGsbWXLDbVI9z7gs6RBM
         TDT5FjyYB3G7P0cpX1mb1ilVQEka4Aw0h0I4BCIiujvaIlw0NIXAczBNyr3B++VVcB+3
         +Cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B4VLNzxMuvBiHcofU7yya6+NRz/joAG8uuuPQJlxTTo=;
        b=s6rliqYjrmqfcSbZeDPiLYwYtxWzPOiasOqm9OO4HTzumZ1sWO9VC97ktqBfyLBmmb
         1K8ZbDOCIE1qF9Ifm8mB6Ic2YU1TeeZdKC/DzDWS542KqYRjc6lPjQcrToDxAI4gy3sg
         cp89/Lv3Se+Kp3Tn2mzFwFE5v8f0zv8HItl+3PzwL06aseOKCPw/WfJg9Mf0V4ba3DHv
         4+jIqyHSSn6d6Hm2fr6vZgQ7dNA0Cm1snZ9EKNgHbwq89Sb07i2MAeekkKjbtCitiHtf
         iHGX8j7Qq6kcM2adXMFKMEjkFb0pQ5BV4UBwk4XHswAncr/NEqg3XWMwazpayOm4MyZQ
         j0PQ==
X-Gm-Message-State: APjAAAXFGi1je3EP9W/KRBGYItPif3naAWzfnLJBSPOKKHMFy/zKqfii
	TQ6I0faLhxuIzuR/UdM3mJRQkeQLCyU2uSoe2jc=
X-Google-Smtp-Source: APXvYqwoggK1YVUJpQXUwc7FiBvv7A/DJq1W/EwQk4BCJ6LoqoLRq9NRXAmJ6C3gzBh1eCK8VeecRlAeD8DpBndQofs=
X-Received: by 2002:ac8:22c4:: with SMTP id g4mr5716668qta.45.1572540432881;
 Thu, 31 Oct 2019 09:47:12 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:31 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 11/17] arm64: disable function graph tracing with SCS
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
index e7b57a8a5531..42867174920f 100644
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

