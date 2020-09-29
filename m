Return-Path: <SRS0=52ly=DG=lists.openwall.com=kernel-hardening-return-20038-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4DEC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:48:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3654D20789
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZTQa+nx+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3654D20789
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20038-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28075 invoked by uid 550); 29 Sep 2020 21:47:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27964 invoked from network); 29 Sep 2020 21:47:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wzTjCzGg3xaEC7ll/kCd4uRGsOqMFFvk2QDCKEKZJPs=;
        b=ZTQa+nx+ie2V6Hl+EgZ3b9a4nWf6aHDxI2ozXvg7twHaKP6+FN6wo15J3NYUHL6MZy
         J4Dd+alK6yoV9vbFjsbkRKSroxIwAfTac5LcIIobI37oTx5CMMXDG5PaPNUMt11LwL8e
         qaWpUR1BPcieUI39Ur38/bJEEGCMg2IEQV7e2ugbrGtg++DfsB4wweV1KXsP1t+8DXDm
         JeGZ4Z7BrxXuG2djrCReKQukEvOz+cyKSm1LRUENFyizVwreuzCNtUFRYYSNx4ge/Lh7
         V+phKEE5IsRMyJIFN5ljmvpZV5Qkvt76Ais9ZtPypytr0PvQL98a/0aQ5/yCoymbWkrC
         MGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wzTjCzGg3xaEC7ll/kCd4uRGsOqMFFvk2QDCKEKZJPs=;
        b=EAFmVmHPrqMZxbMPwRUiwEqcHPvgv7ts1VmKmv8Ad09wgpQUYJRei1vsEYyDGs6h28
         Ayrygb7yaN6kInYW+PUQ2JEL9VjqQvvusF5qVxtczcGWhrSFg5droIR+PJhN8a42DRrd
         Gob+u7W862Jky38jsJk5TMiO2XMCUrRgsd6dj+XF0/fQEyIHsdr7n6TEVEPPhd+SyObY
         Rgq+RleoB28ZAKv7M0BcPdQMMlhILLWPw5U9+oO815cK79mwsgtyfn6Vobm+3qi8g6fa
         OQG7DlKRqOcE/7oG/6lJ9o0L7WWczSO6IxkVvPdpie+56iGQ0WZqKLMfO7Hgz8ivOK6u
         nLQQ==
X-Gm-Message-State: AOAM5317DsMoNHmOJwRGfwZKf7aeN4iH6qCNh1zOO0jZo/otCl3M9eN/
	2ObGqu4W6u1YSTnJwiK31xLQANZmsIOcaAXQF6U=
X-Google-Smtp-Source: ABdhPJz2ypRSC9mllfNnIhgyfpZXn6C3IOzuDT16CdCuKPyuF6U9OOcO8z3rZ0bOQ0QtPSPEFo5uPG0gQq+yj7Gtb6I=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:58e3:: with SMTP id
 di3mr6759116qvb.54.1601416009709; Tue, 29 Sep 2020 14:46:49 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:10 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 08/29] x86, build: use objtool mcount
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
index 7101ac64bb20..6de2e5c0bdba 100644
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
2.28.0.709.gb0816b6eb0-goog

