Return-Path: <SRS0=ux0A=DQ=lists.openwall.com=kernel-hardening-return-20158-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06AA5C433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1EAB82225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Of/McM9M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EAB82225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20158-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9887 invoked by uid 550); 9 Oct 2020 16:14:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9797 invoked from network); 9 Oct 2020 16:14:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=hXDRuVDCt6QcdhcOoOZPfzkgSyHjAxTz3vM4hOZGaOg=;
        b=Of/McM9MKCVt3xMTzgE2jLFxrK6HLM9gHntYJNTcjy9ApZaKHz0NdjwbrXXqJ0KeXL
         QILhcYMJykX0DmdfDMEtd1i9+jSTop+Teol7A0HSxWBP/JcipzZjeYHbk2YDLsmk1NQ5
         G2UUcHyxFMpvulEN8vXHpV9R6Nt0Bh4/MBsRvGu0XRXB7N2md6vLGW5FRJ7LZH5lBvgB
         pDYYRrNjX76WD2872VTFDZDZcdeeeYnq5VF5RlcVhEUVYIDLvVOw1Myce0txxTVpNib1
         ITGnOYce1pEF2cgi2zX7oPIqItMYk/+MigcROat7aHTJYH0uDLF+ZV1tegP02Tx/IS94
         4skA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hXDRuVDCt6QcdhcOoOZPfzkgSyHjAxTz3vM4hOZGaOg=;
        b=GXHQs0OJA7DdS6aGCoNfjveYD89zyidZofgWC+9pgH1/QXIi4x/7TgJb+TxKs4q8+O
         yNeNNxHzOg9znLMtBaTUhLhKyQQSv1BgEArt1ctFYv7UONBZ37CRmYYfuilWaxKaB3cI
         /uSTMQcR50tOtYMS2Xe44TJtDgUJTKT5gk5uStoYYMgRUr1DUihiXSTeMamE3XOubGVD
         sVQcqUUHd1WwAMyjNqvsMKB6x75VyddjVJSA3PS48vkHmDCl3sjeZvwEZdwR5pGwQGjJ
         jSB9f6xjBZemL0MkC1xip5BqdCoozfV8Zn1TwDElFQf6PqHvALU1G+TcVICFWyZkoiVI
         v+YQ==
X-Gm-Message-State: AOAM530wu97BPRZIyUrbVCPFDm1KCkxzc4N06jVfYBgy3/l5YUv5ZZLF
	W2ft8APLUqHTM66G7IvUghpkdz+X4OtrF3Bzoog=
X-Google-Smtp-Source: ABdhPJyBk60af/C9C5g9kK9znnQdELrD7eCQBW2IcTXEuF7Dn8nzTsEw+V/y+nNCQlumSGoUUFgDmGGBfFH5vdLVxvs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a62:c701:0:b029:142:2501:39e4 with
 SMTP id w1-20020a62c7010000b0290142250139e4mr13194002pfg.51.1602260074046;
 Fri, 09 Oct 2020 09:14:34 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:36 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-28-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 27/29] x86, vdso: disable LTO only for vDSO
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

