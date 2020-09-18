Return-Path: <SRS0=MDE0=C3=lists.openwall.com=kernel-hardening-return-19925-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A775C43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:16:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A46622074B
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYUGHI1s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46622074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19925-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16273 invoked by uid 550); 18 Sep 2020 20:15:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16113 invoked from network); 18 Sep 2020 20:15:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=I0YLtwhWjc07CuFqeB5q66ZrbEvcoZ20B6+f9QGQIyM=;
        b=jYUGHI1s8CrS/sSNFTlA7rmGo0aE0IxsOvco8+3mbGmxJ9XXGBu6oJrmFB8WRKT0qU
         zy//LwT+zYYBdAukM8OYIDIlT0g/nSfyiohg2buo5UUTX5oxMiibN0IAZdFZeUFX43do
         J75Ez99j+amuAzoOHQ0FFpTbHxdaoahEQ7mXskyDoQ20jhkMYFi95nSwiM3fgkSylPUu
         CgNcTGMuPTBF1DZs6+MnIXUHE0THEx4HxmF1Qc5rm1DW1zfnCq0VNXbuVkgxBrHhGtkl
         Jtq5TVNiA8w8V4hj/3o5nuATv73gM7CpTJhyuPWJPzpN9VmwWFkxnAAGfCAkUKsGwXZb
         /0Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=I0YLtwhWjc07CuFqeB5q66ZrbEvcoZ20B6+f9QGQIyM=;
        b=opZWVyDrsbMn59SO5C1s6Ic8NUQwcAE9h25sDxJYA/eobsOpBy/cNnp6EOripFMVWt
         OqBKGpnEFjAOMic9/WUw7lcswyWcGbaPK8R8JHkw7vL51xa8sCOGWQzp/+oQovFW+5cm
         uEZUCBmZUkzIhL5jvTnSjI40GfkbWi0+hmDjUV0mmbmFJdSYUSzekFBI46nv1G1KFvC7
         /ZA9nTahCiE3KbM9fPil4rKKmeKAix4BSZvxkinIhKqnzPoSb6ARG77hwJsQQKKFt20E
         3MrACYILpPydJtZOYM6CdW0bvQeB74OMrZ2EC356boYRx7H4enxKjtS4S8hHCeLpODFN
         OrWQ==
X-Gm-Message-State: AOAM530M9c1oabpLFinK9zqqlHXYkQKLKBqS967OHdxjYlRQc+n2X/lN
	Dj1Qp3qvqyFj6YrFFLH7ZUA/CvuW2CUfpuU0s40=
X-Google-Smtp-Source: ABdhPJz8YsEPOq657LzaNLkjWdjXppy9+ITNLo8GCqthbQa6sHwPiOQhQjOantZ7VXaLO7lFT1ulWYm9Ne5qkWpjkw4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5a0e:: with SMTP id
 ei14mr20723233qvb.15.1600460099899; Fri, 18 Sep 2020 13:14:59 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:15 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 09/30] x86, build: use objtool mcount
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
objtool to generate __mcount_loc sections for dynamic ftrace with
Clang and gcc <5 (later versions of gcc use -mrecord-mcount).

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7101ac64bb20..6de2e5c0bdba 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -163,6 +163,7 @@ config X86
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CONTEXT_TRACKING		if X86_64
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-- 
2.28.0.681.g6f77f65b4e-goog

