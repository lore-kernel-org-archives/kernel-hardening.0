Return-Path: <SRS0=58WB=FF=lists.openwall.com=kernel-hardening-return-20501-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D87BC83014
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A04DE20870
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vXHUajvU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A04DE20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20501-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19838 invoked by uid 550); 1 Dec 2020 21:37:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19728 invoked from network); 1 Dec 2020 21:37:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=aPTc8wYkBIIZS9XLhaJqPHrVGew/rHRzWtLqs6SwnEk=;
        b=vXHUajvUgn40LQCYOvZPKvqCWjM82atINdDHUGd5EhIZaxvZWNECR6Puf1wV/Xm1fz
         RZFUluVJoen54/2OkeSIKDLooJAqo6nO6jmid/KnIY+pQsB0jUK1FLQCjzUfvDCGjqfW
         5DsweDMH7mPM+webX4KoPPbT06j0wd8ib/BAqCtFcLiXN9fRxFfzVzezsrV61oCpnhyb
         7uduG6UItD7EnvVpEffELx2wbLPqlD3Oqd6UlZIDNGhgDg+wEFbzFvokQCivtnRsGs7N
         92Et/EOjPux1Tii1bL3i8/gTtmbaMJpflMTGhVRAPssOG6ib3nwdVtng5zkY0hoNy4H7
         BGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aPTc8wYkBIIZS9XLhaJqPHrVGew/rHRzWtLqs6SwnEk=;
        b=BR8vrqbQsinDP2PSskcjURsTqlfucL9geHDHaIE2dP3nidRpcsER4wen0YMNauBGBd
         BVd7kUa77ra2nFAhm1CJVSvlxvqPx05vZXmdDfYs+B/hX/dEJKAMgQk+5EkyA2LfiaPo
         mfBEhqiF2Fa4odLc1Ea+w6XOYIzKCR8ppPNMTfPdG84+ERsMfpCS9V2p1UZZdTccKDZT
         IpIFVUtVaGgwXHw1kkL4C2ciVRi+Bqg56WKcvQucaGavNM7o1xcKNBrLCTtmLH+go5YL
         QBiiXRYSE3FSNFn3kaD3zG+tklMQABLy07kkKHfeZxPnwFyIqwbKf/3szXCfxKN+7Z6R
         Nd7g==
X-Gm-Message-State: AOAM531IaCYUHSw/hpAfNFgtn1KV26v+fKM0CJiXka9xvUfbg3m7S9BY
	8EW/ea4n/jTun9XQBIgGwbET61ex4IIicNRM194=
X-Google-Smtp-Source: ABdhPJx2UMQKvzPc9YbjuAcaOdZsXhK7RlcIM2M9pkfdRpnDBi+U9k28DqELenlSlo2tvxUYIND8c9jWK0Acmjv4ppQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5685:: with SMTP id
 bc5mr5091015qvb.48.1606858662372; Tue, 01 Dec 2020 13:37:42 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:04 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 13/16] drivers/misc/lkdtm: disable LTO for rodata.o
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable LTO for rodata.o to allow objcopy to be used to
manipulate sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index c70b3822013f..dd4c936d4d73 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,6 +13,7 @@ lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
+CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-- 
2.29.2.576.ga3fc446d84-goog

