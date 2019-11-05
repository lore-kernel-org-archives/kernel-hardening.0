Return-Path: <SRS0=LXQn=Y5=lists.openwall.com=kernel-hardening-return-17312-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C554C5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:58:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 291C7206B8
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 23:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QfiPTkyl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 291C7206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17312-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27829 invoked by uid 550); 5 Nov 2019 23:57:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27741 invoked from network); 5 Nov 2019 23:57:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oB4lIvjzdBiHgRAUphuiQVPgI+jp2K5bMoUCGUiH4hk=;
        b=QfiPTkylKak2JP/fA92kLS2kHYHGvI0ROKKMGBuahal4YLtzvGBJN27XjNyiQH8HG6
         yGlyTyrU/unO2GWm0Nv4aMpTNLKbJN+tCvpwionJjZcpDaxtYqxpVnIYWW0enJwD9cGu
         H3LPc6bHWpLSwRsuEbG1JVtUql2ni5CS0AKG2Gtvj/sOGcnFyVzwIGABxUDq4hnShW0d
         YrnkM62CleNkLuir4Rfyub+T9Qd7Ss628T/1ROy/StYjkO1JBGOTm6WgyQ7LRFXQEEsm
         JL468RJSiozD/j2M3Vi+OnMGSwmwEQH4MedG0ZFkg+53Rwgl2MeC2pLijfEUHj7jkGJ/
         9N/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oB4lIvjzdBiHgRAUphuiQVPgI+jp2K5bMoUCGUiH4hk=;
        b=odInNgc3gP0BEo3K+LoCCrIXx9NBXXzLozEHzVLO61gvAESxvDcpRcuVym03+ouXAd
         7XXE1tgHEfzPS8OSQG+gg6C9XwoG63HtmZ0CXzOkMKJ9b2W5eqfhYTFExEeTRo4jwJW+
         ivvjnrop0xBg17H/7zzhRB9LCG6UekQam3snNdep0a6Ck81mttr4xDsFjuYsDIfRt0EN
         ntgROLuKtCnk2f4bAMxCOSgVgp0DTGZ4EcSKZCDs7eMNLXW2STKNT2N+8Hd8xdnMj6wt
         8HwykhQIe/VRlgUp7Nj2ht1k+wroj6rtYbNgvmqe72mT9seph/O9r4I8az+Gzqo9Sk1Q
         t/mg==
X-Gm-Message-State: APjAAAVtfB8yvuqIQXFD6xOpkimaFJk7GbnVPEa+0wwJNBRQFDW9wUwB
	zyoe6g5iaeg3kXoXOG9X5KnxpfZriGMBs2EionU=
X-Google-Smtp-Source: APXvYqzD4X/kPtbk+w3gExO5Bezjz7X/3F/Tl84XtD5Pt1TYYSMyOibW/2GJGTtsQO1axnooT5H2E3H7HeWsFEsu76A=
X-Received: by 2002:ac8:4543:: with SMTP id z3mr20376230qtn.41.1572998208364;
 Tue, 05 Nov 2019 15:56:48 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:06 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 12/14] arm64: vdso: disable Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Shadow stacks are only available in the kernel, so disable SCS
instrumentation for the vDSO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
2.24.0.rc1.363.gb1bccd3e3d-goog

