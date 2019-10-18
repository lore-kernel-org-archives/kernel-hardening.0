Return-Path: <SRS0=82W5=YL=lists.openwall.com=kernel-hardening-return-17029-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D8ACA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:15:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 373E121D7C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cCT9hs91"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 373E121D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17029-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19630 invoked by uid 550); 18 Oct 2019 16:14:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9988 invoked from network); 18 Oct 2019 16:11:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xX5gUTsoboVAmCrU5x0kxTyEAN1I1znyOrkoj+71V3E=;
        b=cCT9hs91spgek13wGsP9y0ttC9ve4IQ6YalGlMpwduvwu42Woqshf/GsDukku4Rd7z
         LzngBaQqis4pXbheJCLuLc/BuznaLuuhhZ0eQYxuqnnHcZIUFUvXDs57h723E1aVsqCN
         hDJ9NJVmzOzxHezv4iMvDqkeOoKw8JtHeSXKma4kAFNaEABY3mU6axzTP9w4Lq+UPCd3
         3Ot78e0aaFfEd1x8s4TQXDNAkM6/+cID/LMqGDex4NuLmCmij2J8d1teYJAiH7hir7mz
         bJcHXcpZNWl2UPJrt20n+Cj5d8KKW3//pqk3cC5O9Pz9D8EOb1EO2oSOjKTQQUWNt+am
         FQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xX5gUTsoboVAmCrU5x0kxTyEAN1I1znyOrkoj+71V3E=;
        b=lH1aWRxrNhQhuIgZGn1xm1djBr2oWJiD6kLpSvRLPj5DSLeeUEVdHdo/NII/FqJlbv
         Q/C/QtcI0bXmu8HWHtM7i7EDOtCb4t9yEqdnRYzD5gtxBVKCTfv/LSiGOl6HpKeFalbe
         tj7d9amLOcK4Ni8iE9SkHvu747mN/F6G5oBXGvE/EIZqi//oLqtaqoNnbs8tu96BbJKm
         r4wZYiuwr9LWeNg7zRXxDHwF657u7jmB9zKO+D97cfHbBIstp9YngSVZCDidDY9YlF7W
         v/Iqtyt92HK+JGrt5ZkeMSOWKkeNKzCyWWx5lpvIeWvtc4m6l2QcqYq2J1vjt0JXl5+R
         K+fw==
X-Gm-Message-State: APjAAAUTPHqsIMWqnD2Bp47k6KCceqIooisD6fETdM9W+zg+iZ1P0OmF
	HntFzoF9kEpgeAOrA5mhH8/8sEtoNVzwqYW9Cmg=
X-Google-Smtp-Source: APXvYqxwiguloHdhaLpo4FBp0WjObBKG43Zxu/Qf9Jmum2rfBGkEmvxrlieIAShHEtrTW/4mJFtXISqp4bSzlzbpPKY=
X-Received: by 2002:a63:e148:: with SMTP id h8mr10684150pgk.297.1571415072880;
 Fri, 18 Oct 2019 09:11:12 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:24 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 09/18] trace: disable function graph tracing with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With CONFIG_FUNCTION_GRAPH_TRACER, function return addresses are
modified in ftrace_graph_caller and prepare_ftrace_return to redirect
control flow to ftrace_return_to_handler. This is incompatible with
return address protection.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 kernel/trace/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e08527f50d2a..b7e5e3bfa0f4 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -161,6 +161,7 @@ config FUNCTION_GRAPH_TRACER
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
 	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
+	depends on ROP_PROTECTION_NONE
 	default y
 	help
 	  Enable the kernel to trace a function at both its return
-- 
2.23.0.866.gb869b98d4c-goog

