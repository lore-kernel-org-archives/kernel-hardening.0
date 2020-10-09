Return-Path: <SRS0=RIfp=DQ=lists.openwall.com=kernel-hardening-return-20154-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1940CC433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 42D4B2225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hLqKbNF2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42D4B2225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20154-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9281 invoked by uid 550); 9 Oct 2020 16:14:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8175 invoked from network); 9 Oct 2020 16:14:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Et6zTjz3rLwF/ItBI285hLUQ1f4GO0wd9iXT0eGoats=;
        b=hLqKbNF2l/HYOLCmWO8LMR1Uka12gSYz+AhlYm3DhRPL1fLs1dqzgWcxHxLzH/tZup
         gPnuymUDkXuAc3XIouGPBl/8T1D9Bq3u8jG17jrp2vSb0X7xbVT7014aW5js5Evi+PN3
         kKq8Au1B/gTOGttR3rccDlmrr+eH/zq2d6aYrZsLtb2MQbJ36nj/aUKfg72cXmKRuCd1
         7W0h22twgcbXNdk0LlNmNDt5u3BwGoQ5OGeQI2TU/FzlveqBrl5YUYIEveqDRG1UMD5e
         GdFmF67K9M+DZq777bIKNPeg4Db6qpIFUOK6o+EmyYf4xc69CphrXuFUAoqVvoIG7cn6
         VIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Et6zTjz3rLwF/ItBI285hLUQ1f4GO0wd9iXT0eGoats=;
        b=jlMq/TtZoHpiJWhDasOJHeYo7h9+deJqaG5BirVyP77JxcFITraEcdQ8zd/PNt+Wgw
         WPOp0eiPHHtJm+YlwczPTuy8ivbo03ixWZpEhmUQdgo6rrLmsqaQWwxP+OLv/yFnrf2X
         1fYdvmvdNtl7ZbBS89MZpH3D59VAknDxfp8mX7b3fgzYy7kAg8TCbf7ZEiJ8GFlecORq
         /4yKls4XxfcJgjX7H6W/WhzSbk8ERb6gjnoZTC7jWA7HqPDR+2S8omOnnLdowd3WIpWb
         eI5vxHz7lu98Dp/GbwdY0vCU43QZE4e/9uuUsksZ0Mt7e9lKSbaYLHMrPXpGeY4rpOSQ
         6DLA==
X-Gm-Message-State: AOAM532uSi1f8H3LCJhwByvuHbRgdi+tVgT+STXsYXbF0TB1imPNCsaH
	I0syZFYWz+plRrIyqeJfV3LnOLSK9Rmkors+pBU=
X-Google-Smtp-Source: ABdhPJx3xuV21n1yE2Lye3nQEPP50bMJ0EgQCylMeDfKaqKItuqqn+slZ4N1DGo94IMuiaWaihoXxmQJwU6XAlrqwU0=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:544a:: with SMTP id
 h10mr13840738qvt.35.1602260066836; Fri, 09 Oct 2020 09:14:26 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:32 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-24-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 23/29] KVM: arm64: disable LTO for the nVHE directory
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

We use objcopy to manipulate ELF binaries for the nVHE code,
which fails with LTO as the compiler produces LLVM bitcode
instead. Disable LTO for this code to allow objcopy to be used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index aef76487edc2..c903c8f31280 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -45,9 +45,9 @@ quiet_cmd_hypcopy = HYPCOPY $@
 		   --rename-section=.text=.hyp.text			\
 		   $< $@
 
-# Remove ftrace and Shadow Call Stack CFLAGS.
+# Remove ftrace, LTO, and Shadow Call Stack CFLAGS.
 # This is equivalent to the 'notrace' and '__noscs' annotations.
-KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_LTO) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.28.0.1011.ga647a8990f-goog

