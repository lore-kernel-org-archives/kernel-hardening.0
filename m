Return-Path: <SRS0=xseB=DQ=lists.openwall.com=kernel-hardening-return-20137-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A096C4363D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:15:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4543E2225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OqvMiRbT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4543E2225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20137-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3297 invoked by uid 550); 9 Oct 2020 16:14:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3209 invoked from network); 9 Oct 2020 16:14:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xL7tn5bk8rd7QhzERnW5XDCxrWNQLuaGbP7lLdALs6Y=;
        b=OqvMiRbTLr7vQGkxZV+PzeN6OVnsvLKpKhipsC6rP2jdI7Y08eG9SJBUZ2mgdSJMkz
         x9QYY+hyJILnVTzv1B5ofQttFgWo7nBVjEgzundXt0DKJFBiSX7gz99ELfNKZbc2BUdu
         GQMlCWP+SMb3Czho/JwY5yFAdN3ZemagwBRj9FsPu58e2Af0yK9l4pesMcwC48QrH+Tx
         dQRg1+j/gMRSCddCjO1H4ILpvwOtSODFimUgDlcNLZ9DVwxxTNXijF18Aa3WiggyxUrV
         V/7JINREru8rAbs/3tG8GRSCPMpt5bAArAPyPhPEspa0qrdfHyj8Ao7YvCGIThXpmbGh
         raVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xL7tn5bk8rd7QhzERnW5XDCxrWNQLuaGbP7lLdALs6Y=;
        b=M963i4t2aE39Nng7s892bvsJPziNA0l76pQcQYhIrOICoHweS5WBThjyoFtSFIQwDC
         H2s/UjES7zliqurqTGa3MijYNZKIqNS16J8y3CUedbhO6vVhDbYE+iAuMTRTYnm60ASn
         kHd60QTGMxvKOcmHog+gytiGe4ZqCSL5kxyrYH5JIrpHg/BsFVHU7mnwlhaLq29JCNbm
         qTvo3V1RL7QyenYeLggyi88NWARwC1yLGOFYQPqhYqKc/TlJznEHUnwloBRm+D5E7pY9
         UkeNMYWl1aOS/jBdhrglbgwq+lhsmae7g3YvIL3u3Sc/A5PHUUl90Kdz+Pf48RPOej/T
         VChg==
X-Gm-Message-State: AOAM530fNxV5g/7lAVmHcvcN1o4UsIhDvi6W3px77phvOXrQvQk2UKhJ
	e2bE0QrHOPbeLgbChtgpmr/nBU5upe14om4DSbg=
X-Google-Smtp-Source: ABdhPJzJNs9VefAdVXIx8sE3q7uXvK82feETKtZCmngvw33KH61VeZxl20uF5X/PWOLcLy230cxOgVWyuUcI+4L/D/I=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5747:: with SMTP id
 q7mr1648297qvx.0.1602260033580; Fri, 09 Oct 2020 09:13:53 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:15 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 06/29] x86, build: use objtool mcount
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

