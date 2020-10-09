Return-Path: <SRS0=RVej=DQ=lists.openwall.com=kernel-hardening-return-20152-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6930C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EC9E52225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWaosZKl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC9E52225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20152-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7899 invoked by uid 550); 9 Oct 2020 16:14:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7837 invoked from network); 9 Oct 2020 16:14:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=BiHYmAAiH626N89XqxkZXfyE7gUyoYuU5gV65m3nGjQ=;
        b=kWaosZKlpyaPhHKVgAB5jaN7Z/L5GLVvlb4+fdv2ch+ej3HpYqzh6uZcdm3+Tvoykg
         6omGVQqiCVxWzoz/gV2RtiawIlWAzwAOAuDWw0klxLvDAp9C8MllbAFa/+mLP6BcvQ6Q
         1JGIssCdJM4GgwAf9G0Zx3c0le6touIF258LA0TedygIS2yHumz44INySxDCNXx7yHIK
         60P3ikRwg9bDNGtZtGkEoyU1tNL/E5ndf++JFwH856D/hSDeXzqinxxFRqXy0QAm3BSb
         k4Ywf7UqYk+GgIXWciDnanYQ1EPbCUEpP8hpqyk2cG836ip23OzwDZz83/Buo4laq19m
         uH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BiHYmAAiH626N89XqxkZXfyE7gUyoYuU5gV65m3nGjQ=;
        b=OfIZtBCuOryIbtX+iX3+2IsKswzohZlpQLW80dWH8f/gMqkL2cC2nK8DQj8S0lb9E5
         He1DW3pB66fYpUI/ClrLlyYfSONFN/bctxatQElcGALtn5YPF7ews4JkYNBZX+3EPQsl
         eFN0VHMnewL5WSyc22aAhPoUidikvpUCfYmETnaC/Q/eJSkQVJHCFBkYcz2c62jyYDI+
         +Us/N6mzr2WhvAP7r4H5iEJeDS5IBVr8vBpFdUlc3lvHdT3dLudrpSp5og798aP/Se8/
         iFJ25MFmizIRC8s3U6x2iEEQ/Q8i3gkDnqyMhDGHkjQk9/f8JZbGhRiB4wdWkQG+xCaQ
         ltoA==
X-Gm-Message-State: AOAM530SW93AawXr6zM1XD1yT5LBucTzZZf6cjGTWS14ZF49+ArSwKWM
	u4RNPAjhLeqHR9kzdT5Yb42utsUfq2ftEDYFrBc=
X-Google-Smtp-Source: ABdhPJyHPiE5GePYAvaEya8u/0CvrCAAGbNDB2zBtM4hELH+YYZewJMzkdHOHE7lBNk0pBM71xtMSBAsdjBdBJfED8o=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90a:7c0c:: with SMTP id
 v12mr5366318pjf.71.1602260062781; Fri, 09 Oct 2020 09:14:22 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:30 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 21/29] drivers/misc/lkdtm: disable LTO for rodata.o
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
2.28.0.1011.ga647a8990f-goog

