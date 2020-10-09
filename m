Return-Path: <SRS0=BETh=DQ=lists.openwall.com=kernel-hardening-return-20151-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A42C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:17:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94DA12225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icGF2o4B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94DA12225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20151-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7734 invoked by uid 550); 9 Oct 2020 16:14:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7637 invoked from network); 9 Oct 2020 16:14:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IWlwO4V8zfIKj2VoQVJSOpIzEd6XIOwNzizfhzYsm+I=;
        b=icGF2o4BoUC5H7jDfDcqIeIDmztt1DX3EBV4AR9CIZel1UdghtV62q3fzjA81E5ME4
         x9g3yQfuIaLSgx21c6ABnIjUmaI4VqxjY4B5WnUXRoUb92nAtC/XbQPpxdBRAKJqH+qH
         jcvBMX8XEpz4rNBFWhnnnRs6RxEEg7NtFbXbUMhmEcBsm9ep+5oJx3BqoMUfqRJe9eh+
         HQV2rljyVTcunwoXwynW5GLctChORkFUDmM1/j1sk+6+WxF8Dg5/LcVdGd37dGhF+GtO
         M9aoDBKTtmJg2M/huHN2yYE2hfJUvsC+WO6y4SzBmnETs4aTNvX9A0N+1ApFOCsrkyFd
         VCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IWlwO4V8zfIKj2VoQVJSOpIzEd6XIOwNzizfhzYsm+I=;
        b=IIGyOtMxtDkI8DiMRIPfPO9glidGlnzYOpR9ji33FcF6P5n6gsEeS3ETS/+M8hBxJA
         P3nignFWPtItAfddKJFxIHYlgrqi18dOT7CU4LkinIcMKam9IlDidynPgIVFZZWPHkHW
         Aq8PvJizwaU5DxXHP0w3qScorhi/TtJ1ij3RHZMZ7vTsiDGZvJu24cgG952HHaseXQnX
         //y+1DJpsfAdUj7rK7MnO5fvUWpBaNOK53XgoMMIlztOQOgrOTdxHL0SS1wSrJtExkah
         rytPFHTCveCxETSZFNlVf/4nJ8xvhLBYcb3NgRBbElWclm4c0j19UunTn2uXxuCyjwbB
         KtTg==
X-Gm-Message-State: AOAM532fm67+ApXFxlmyyoXNR8sfEMTgRvTu4Ssl/oICUXgY3L65g/Jh
	1PPD83+7L3jHynCQGKGgYul5Tkn+N2mq8/iS7WI=
X-Google-Smtp-Source: ABdhPJxEWHAvyNkdIDlQRKJ2smQRYfbTU12bNHGd7NqYEmxH7inHJ1sIHSNvQnTIBhdfm/bIQe6W23Fz9FB7iOfrFU0=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:43e5:: with SMTP id
 f5mr13905635qvu.12.1602260060762; Fri, 09 Oct 2020 09:14:20 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:29 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-21-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 20/29] efi/libstub: disable LTO
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

With CONFIG_LTO_CLANG, we produce LLVM bitcode instead of ELF object
files. Since LTO is not really needed here and the Makefile assumes we
produce an object file, disable LTO for libstub.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 0c911e391d75..e927876f3a05 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -36,6 +36,8 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
 
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+# disable LTO
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 
 GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
-- 
2.28.0.1011.ga647a8990f-goog

