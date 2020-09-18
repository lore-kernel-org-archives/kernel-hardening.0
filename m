Return-Path: <SRS0=gKdn=C3=lists.openwall.com=kernel-hardening-return-19942-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB29C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6320520684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="REd95VnF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6320520684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19942-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24496 invoked by uid 550); 18 Sep 2020 20:15:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24402 invoked from network); 18 Sep 2020 20:15:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=oXJMXy02LqTQDpBkn8PPtjYwJPq4evUojZhZLMc3uvo=;
        b=REd95VnFXwmD3ND7Lapf6wTEKHlyfaSDlXa6A5g8OMe6rD7mXFuEioeTzTVuP+wKYy
         krseyNRuMtJa9ctfWr2TjaEjNcbStkBCBOxYrTttidotv9Qbdv5f70T8rfirifUlhiGO
         fbpwKXewIVSjSWcELClY8rHyvPgkF2XdC/QZF4KVfiVKi0xCd18r7fnei+hqOeW0nZel
         JhxqIwpbgtSIJrJ5e9QQl5CT7x9s7Yh2DeXazsVf3ebafU4M8/COaXTHkTmNbs2X65vv
         uvYLZii0pQgCywSqGr9bhM6Jz3cwSDm+sYfUU2OyMAh4+XaJbe4V1f+DGOyRxBJY+8Ct
         N4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oXJMXy02LqTQDpBkn8PPtjYwJPq4evUojZhZLMc3uvo=;
        b=gIC4DDR805bcnubODdeESWmN8BhrHpPkQNj0ruWPLCNkKyq1qMaeydKCJIUGpIdRHs
         2xyHTSCjWMd9Oko/kAQWtSC7j1msjlYedxclk33yWo83NVVBFBzbswv0MKjD3dutqrmM
         wGe4Q5jQq+l3/0bcEa6aQQQs8AkZMydXgnrtQoy9tDoFw1ww0ZP+wPi1n6TGxIfbqhrn
         ZkyguWQJaiurfetZNY4RqCMbDbpl2rYv4Fed3IrDURWj7aCDDzfJ1WLDUgKvgNGHIaO7
         q7ezGNxuuh9AUl+Rgob9Rq7DMBepExe60HQrOri5KIsDaJ16GC18MAsUg/hHOx14MW8B
         dxIQ==
X-Gm-Message-State: AOAM531HcKPhibwapsgaRN7tEqpRO/V28P4dAmrrMBUIu9NDNXlsENXd
	/Zcp/oP+sdOouLp4t/nGZZaNV6PWSiUp7kabnmw=
X-Google-Smtp-Source: ABdhPJxMyDngZuNnNx1wL9/fMd7ntfJVtVGTW6/hjVnBGEbXwyy4OggBNEJrH2U3qB1vnImsc26NsteebpxVgOTzfOI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:14c4:: with SMTP id
 187mr54928163ybu.449.1600460141424; Fri, 18 Sep 2020 13:15:41 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:32 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-27-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 26/30] KVM: arm64: disable LTO for the nVHE directory
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
2.28.0.681.g6f77f65b4e-goog

