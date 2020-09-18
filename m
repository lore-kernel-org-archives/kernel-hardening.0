Return-Path: <SRS0=dc6s=C3=lists.openwall.com=kernel-hardening-return-19940-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0750CC43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1081520684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ObhRsoWs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1081520684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19940-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23992 invoked by uid 550); 18 Sep 2020 20:15:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23925 invoked from network); 18 Sep 2020 20:15:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/0ldiyB2nVfkSW+Z4ZqugZ1I2eeQ0sdYMfFHH6J6dWM=;
        b=ObhRsoWs56/ckOGNxhhvSliY51cEtV0g/uMSUnztF/O7z31SMtCH/329m8ibTSKZpG
         fiez3GHcBYfc9o5RBx52gPxMzE2kT7BpfP1ZD4q5GKOuEItaIBhl8DMnx+NNI8ef7ycs
         b8R96aDxgD2UiGsnLon+7daf2qTD2JY7NXxEElaPkmsOHkoKvbT8QFHFiJaUXRtTLxH0
         55yHN4z3tf4xECFWt3X9nwCecG7xNYuYAMLaw4tETvqQQGxC0C2DOdr9nz2poaLSjtvv
         1tZdTBVYTcwfiT3/yI4GgTADGX+HKVoqImsQX1FHpwsSfHwO0fR0fgmBvCx0ByfTr/Ho
         8lWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/0ldiyB2nVfkSW+Z4ZqugZ1I2eeQ0sdYMfFHH6J6dWM=;
        b=TQohQHD2FyAchPtq8EVcnSzuGy1CdRBhi5C/glKcqjN5pOFl6IzdsIen9In1WszpK9
         g39MR4X+2OJgwJWF4LLrcrIOknIg2VeakDZL6euoV2Sv75yvxjU6QIPFoOUTLJm6le0m
         fb41Ct7EKKsYPEPAq0f6aOqXAQSzRIDrgvxH5gY3K3t0N9XEaTFTM3oWAZJqVWxkFJsG
         FCTKTSHhhHaHh3i/NHnNzQyNHnvRDDIeOESDouFVB7bUY6QRLo7T2VTTW3W7H0BgFXmS
         tqfrESnQjIwuhf8RweadRjwdyCt2ZRPjO7MVipo3ZtaCjxUvPOarOTHRjtR3E4pdZiM8
         bQ8A==
X-Gm-Message-State: AOAM531IB6D2PBt+Kqc4k4jMGBzf+PZDPWHdw5z+a6ui7QXE9A3vu8fq
	gX3Z1GPLx9FtLbEUWY3aThXaZADXFM6B1KLL0WU=
X-Google-Smtp-Source: ABdhPJzlCcwfWl9pGOxTGz2mpuA0ZcI0OzyXT/6tCo4MOeFDLBSH0AjygGOTnITZPst0myY84qe7t61m7gd1U0GYQLc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:8b02:: with SMTP id
 q2mr19161266qva.48.1600460136604; Fri, 18 Sep 2020 13:15:36 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:30 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-25-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 24/30] arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
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

Since arm64 does not use -pg in CC_FLAGS_FTRACE with
DYNAMIC_FTRACE_WITH_REGS, skip running recordmcount by
exporting CC_USING_PATCHABLE_FUNCTION_ENTRY.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 4e8bb73359c8..57b875099b17 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -123,6 +123,7 @@ CHECKFLAGS	+= -D__aarch64__
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)
   KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
   CC_FLAGS_FTRACE := -fpatchable-function-entry=2
+  export CC_USING_PATCHABLE_FUNCTION_ENTRY := 1
 endif
 
 # Default value
-- 
2.28.0.681.g6f77f65b4e-goog

