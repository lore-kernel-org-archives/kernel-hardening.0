Return-Path: <SRS0=aqvl=DU=lists.openwall.com=kernel-hardening-return-20179-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E29C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:33:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 64AE421655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IdXB04m+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64AE421655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20179-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12081 invoked by uid 550); 13 Oct 2020 00:32:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11982 invoked from network); 13 Oct 2020 00:32:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xL7tn5bk8rd7QhzERnW5XDCxrWNQLuaGbP7lLdALs6Y=;
        b=IdXB04m+VIhq9Ywfk+Q6SdQxAtxltKDIhWNIfo+jhdLwgrlbdcpJkCD1dg60k4KicG
         1IgqLYFzJP4YEVrqWrx9pldSCsrIUIQZ+WBgBNy02BbQgKQE7dyYmjEiSSvKFbyI2xXj
         TV/V2tWK25kaN3vgAN5S+M0sENDBoc3aH1FQDGeTof6qqw+rbjH3bLU8q4fusukkB6D6
         mAux60p4YIG3jSjYIx2pWv96v7XCJ9hy4Ka8a16xDIx9CMpYSDwuHtmOn9Zpz0sBYoxo
         n76+DpbDHdACleamKfcxERH+Pqgb3G4b5AAOxxW5ydqXddcuIHi5FDSPpeBjiqI6FIaq
         F5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xL7tn5bk8rd7QhzERnW5XDCxrWNQLuaGbP7lLdALs6Y=;
        b=Fkdh3VI10Ho1sNEugBA/6r8lBfyazxJPwMlRGqEVFPBIWXalh7RZdOPbNYXej23Boj
         /hQkKubItDD86umsQoCdRiSdbqRbZ4FQYYwWoWKnOyo+Lo6CS3oEd0tZumtKApNCrYBG
         x3onJlALKnHyE2g/pQ/tb3zNrx1HYPf59dz0CZzUkMrRr0HYptT+UCPYI1WBFXRr6IPa
         kj7HGYz+2Ljap0cnsaMV5KGoTqh9I/eLLhpmdZkjn6qtC5kCL1hj5MK6UV8eINlE4gJK
         tZlD1+Zaedy/BrKCwTd7kLPXcdJ0n4pN+aPI/5Y751Eg8R9+e4GBMvDHv5HfKZ8h3zLy
         cEkg==
X-Gm-Message-State: AOAM532xEjdT1otfvDaxz7qX9iZn0fVJc4o2usfZY3BLKsWXpC+0xTsG
	YsKkhN6nxr4Qm9kF6kd1t4i5WKBcxYRPC4mD/aA=
X-Google-Smtp-Source: ABdhPJzmHD4XCersd5eY8ZPVkbKw3ea3PfM0fSiP3AGN8FM08tkamilxzFI74ZhTfsYbcW37PW4YYLWgNBpJiUusVu4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:aa7:9a87:0:b029:156:5806:b478 with
 SMTP id w7-20020aa79a870000b02901565806b478mr3079925pfi.8.1602549137181; Mon,
 12 Oct 2020 17:32:17 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:44 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 06/25] x86, build: use objtool mcount
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
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
index 5e832fd520b5..6d67646153bc 100644
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
2.28.0.1011.ga647a8990f-goog

