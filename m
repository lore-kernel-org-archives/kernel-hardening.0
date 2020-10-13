Return-Path: <SRS0=X/wd=DU=lists.openwall.com=kernel-hardening-return-20196-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41F6C433E7
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:36:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CF76721655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q8OgoYWJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF76721655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20196-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21539 invoked by uid 550); 13 Oct 2020 00:33:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20422 invoked from network); 13 Oct 2020 00:33:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=hXDRuVDCt6QcdhcOoOZPfzkgSyHjAxTz3vM4hOZGaOg=;
        b=Q8OgoYWJ38A1DTeEf63Hk3c3hYYH4ZF0z/4PTOL57lC91oiRnkf9gd9B9qku6Q1r6u
         wJpqEn6EAi4UteX1DyN2q/JvaTTtpy84jR6VL0m2JhAl1RoRGIYWTX9l1lTaDfwxSMKw
         LefJJwRakxdtpPQ08/FQAf92Wa1ozzQh8P2RP2YZPMgSGdz7KcYbVYFd9TUmBqArokGv
         +ldWe6u3YKRcL8TPbph9eLO/Rzlrbtj3yh/gdxcr/CPwfeRwl+euqw8SSVnfC+RC6cR4
         StF7LmGsoqGTDk0I/EG14+cMInf9+wTZSixivfF3ZGh1ldNUWQxtZk/Jwl6sRHt0BJIe
         TMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hXDRuVDCt6QcdhcOoOZPfzkgSyHjAxTz3vM4hOZGaOg=;
        b=kxvEGM40iOcnJ0CJ8vO3WoYlTdnuDl74u0IkicRsC8pgwDvKHagnHBmE9wcjeD6hWH
         iBuqBfCK1ANPiZE762t2YfwI62T3eoipN4oAZrcFBOVrObWAR5lj9LGcHKy9w+ThSwWj
         zhKgyYCdmCp6f66R631KLJkkzDuJPj3dkiijZSQtSrFFvvhnpDBvFGWnHBcUn4O2SgaY
         7yHrK3sociQr0wq/NOfX7X/xYSWF/uqM1Dhr186/rM7+VoACE5yaQlf4iIwkRZy+9iAT
         uDDcylQ7NG4kHepU7WowOVIGp5bugpVoQMrLjDTHxnpog/HoHS9Y3CKxsLk22i7llzn3
         BF+g==
X-Gm-Message-State: AOAM533jNvtF7hk0nLRpOqlqqKmOvGeP8UwkcA7y8oZUKzE6US4mizlb
	omQe0FESpuwXapcPEY0GcIVC3NGdXXVrQEsORB0=
X-Google-Smtp-Source: ABdhPJwbnvZ4QCf51zdpzXBwYixY461mQNfzv2AaPBdgQJxvN6CQhpCGMZEflp7FPw1Aa3EKTn0uJBFEhoLOmniOABo=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:842:: with SMTP id
 63mr33820736ybi.311.1602549177444; Mon, 12 Oct 2020 17:32:57 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:32:01 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-24-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 23/25] x86, vdso: disable LTO only for vDSO
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

Disable LTO for the vDSO. Note that while we could use Clang's LTO
for the 64-bit vDSO, it won't add noticeable benefit for the small
amount of C code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/entry/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index ecc27018ae13..9b742f21d2db 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -90,7 +90,7 @@ ifneq ($(RETPOLINE_VDSO_CFLAGS),)
 endif
 endif
 
-$(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
+$(vobjs): KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO) $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
@@ -148,6 +148,7 @@ KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
 KBUILD_CFLAGS_32 += -fno-stack-protector
 KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
-- 
2.28.0.1011.ga647a8990f-goog

