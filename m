Return-Path: <SRS0=QZeq=DQ=lists.openwall.com=kernel-hardening-return-20155-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C867C433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D0B62225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GrQmnCLF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D0B62225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20155-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9434 invoked by uid 550); 9 Oct 2020 16:14:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9355 invoked from network); 9 Oct 2020 16:14:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zm1uzmyUH/ec78UqO7SuMlzRHKM3BG4k+fqmwwznAmg=;
        b=GrQmnCLFUBaiVCsxG+ZjkTiTKAEhcgJzQFl56MgTLq8OusnCa4bNYdjWzig23zPrnl
         +im7f6+CPpBNHzIFXIJLOZcbW4i0CqLoe8s+12RVeCjtt+HO9D9Fmp+O75+bZf2mDiJ2
         /Sdf7HcvK80M7NGzoz4kRytQKC5iEXY2PGakFdQKhcL+z9fCcZ8Ykqq7GsQcpzIDx15k
         9etE83hAgqhL7En54OpSg8MznvaXv/L4GRvX1UCC+uCk3jv6tzVeSDQl1PLkAX8W1gfk
         LEMSPi1GNobCqjW4dHBWslVgjybeY2q8RDcnHKubTb3w6/WlHs1OcJttkCjOO4Qogko1
         U5qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zm1uzmyUH/ec78UqO7SuMlzRHKM3BG4k+fqmwwznAmg=;
        b=BC+41+ZT/3eGoKHZrxRNhVODZD2e0spI8az+UmRXeYxPPUjSMGyk0XkJJRzRfn83Ro
         t8RZZB1d8RNF234PCj/WN39DRmDR1p0pgJj1NAS2iedKfKP9yx7s4dtFTz3M+X436j+Y
         A10TqrtiT6EhT908LpG/8qc1t8N9DZFdDFs/EASmFvXv2Q41WLFwyiXvg58oLRTy4o7k
         1KQWz9vgjga0Iw9HoSSu9PfqMmZws5YyEWW4byQLBgvr0cmpV7UKya9dorTGJfChJA7h
         AK1z5uXC/Mfnbc8lB8E4hTQJtUWdk3jlxGOlMKp2dWqxGhtE16wVnTrl0j/zuiPzQNrU
         oN4w==
X-Gm-Message-State: AOAM5339j838p4CLbm8XMrvmZQ4IdSk6hC8tM5Px16SmeRoKqrDCj0Cf
	vzcoxcHSzsnQJaNJzqpyaz3DUxwy67fNdvjonTY=
X-Google-Smtp-Source: ABdhPJxS1cYLvTIq9AbU/WliPWkh+GMQ6EsM5q7afR6k6pEppCcn0hGMMeepAaLb0PMYcn/yVr6LGbihlfCH0HkjlAs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a5b:486:: with SMTP id
 n6mr9292236ybp.229.1602260068556; Fri, 09 Oct 2020 09:14:28 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:33 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-25-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 24/29] arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

DYNAMIC_FTRACE_WITH_REGS uses -fpatchable-function-entry, which makes
running recordmcount unnecessary as there are no mcount calls in object
files, and __mcount_loc doesn't need to be generated.

While there's normally no harm in running recordmcount even when it's
not strictly needed, this won't work with LTO as we have LLVM bitcode
instead of ELF objects.

This change selects FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY, which
disables recordmcount when patchable function entries are used instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d232837cbee..ad522b021f35 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -155,6 +155,8 @@ config ARM64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
 		if $(cc-option,-fpatchable-function-entry=2)
+	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
+		if DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
-- 
2.28.0.1011.ga647a8990f-goog

