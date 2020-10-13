Return-Path: <SRS0=HUi1=DU=lists.openwall.com=kernel-hardening-return-20193-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 289DDC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:35:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 604AC21655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWr9Y/fq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 604AC21655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20193-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19768 invoked by uid 550); 13 Oct 2020 00:33:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19619 invoked from network); 13 Oct 2020 00:33:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IWlwO4V8zfIKj2VoQVJSOpIzEd6XIOwNzizfhzYsm+I=;
        b=kWr9Y/fqtR1gjXlZbCdcFUO5y9KCbBO6doGSE6eV/R4SdmCC/fG0VIYwLLj+OKBwVo
         t88hxunzWeAhsqD6nX4pMH3NXEN3LQTEHYiul8l16k+sa2iBaYnnGR+mH9hNA4iikAmL
         fqVb25yRhuLsNSg7v5YJjN/fVyXPqCbeWKnvoXYnl9WCtRWuKoabyI01wNyG9w6/b7UM
         4pHEaQubfMyOEQT05Qht8Nh3XzDQC3RyvotMkxtCaBQJVlkntTJDfU68nv0YNejU3LJ8
         DLC87sAOS1Egq4SGIijIlfkUP3DDU2E/gTaUdoloBdFbRBoomS8YvmW0JUlEF9bGUTbb
         DK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IWlwO4V8zfIKj2VoQVJSOpIzEd6XIOwNzizfhzYsm+I=;
        b=fSo2Zkr0NrRJk77R6X+utq27CK50Lkrhq4NhVqedP5ahHg1BO9bcK10+Hyd3GvScXH
         6DgZDgCxW4eDVeojMXo1dB4iNgq5knJuz6Sa4K6oGUxhx/u/Q1keHvFxdBHRIjq82VhT
         y3jQmSm5gVyx6cKdKjcBfmaHYZEmBFw8RW6V5nKGS3pXlGYVR9pKC3ViTRHSpu8+pizE
         vXEOBUHB3HQ3yFSp1QYouNTHZjsfpN4xTWWi4uQ3Zhpvu0xvo3pdaTfn9myhRxjKjqgU
         sOphbGCr+ZaodVaG5sON7l0n9twcGNzlozvC9N/GVMGKxpYdW+/OLUiBFgq7Dg8dNFp4
         8ggA==
X-Gm-Message-State: AOAM530NLJFpq2MfjBRaPEny5H18LuytF18RNB7fz5vVua1g2Progs+m
	SBlyFTiBm7HoztRQmyczKE3HA/wzlzSvI2DHhYQ=
X-Google-Smtp-Source: ABdhPJxmlU/A1sroaipRnUbPqUCXYyj5EeYMFDk9TnoZTSUFb4GItjuig8hO655sUorVd0VW8HG+pUfRKD2TGlP3Uv4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:4f46:: with SMTP id
 eu6mr28230471qvb.9.1602549170292; Mon, 12 Oct 2020 17:32:50 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:58 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-21-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 20/25] efi/libstub: disable LTO
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

