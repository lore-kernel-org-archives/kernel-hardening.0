Return-Path: <SRS0=feEu=DG=lists.openwall.com=kernel-hardening-return-20055-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DF3C4727D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA4802076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dHnRNjTA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA4802076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20055-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3427 invoked by uid 550); 29 Sep 2020 21:47:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3333 invoked from network); 29 Sep 2020 21:47:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=bLX+1fjl9Bbya2A+atnzXnNoTgL1KkV514BpMbJv1Zc=;
        b=dHnRNjTAqW8lTXo9nEiIoFV8O295lbJjdVXsY2+bhFdy7wpFakrnWQIyA2hWQKJ3M4
         qosF/0hGR2ZjIUgh4/EdiLJbYrVxeS67XkRnjNPlnLbVTy+d8F6wxkmug8s6v+ICxYB0
         8cZhAa2wGYywn4ncJiN1o05hfIQQIu29UE1DPhT3T+xB0nlx2bsXOREKfZjpz9tsStXA
         TKUHPsS2S0/SL0tZVBJnBcm+28ZXPLK91wFqvg5Vq41bts7sxLDRqP6y8jHc7nr8ZF8Z
         YHZxAEAYGJfpUEU+55I610Jp2K5acEaPPIByvwA2/pL5hkU4Zb9dg+0o8WGjFm54hqYH
         HEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bLX+1fjl9Bbya2A+atnzXnNoTgL1KkV514BpMbJv1Zc=;
        b=LrtgpzK0acoYClgtLRlBApXQd9uylpknXk/DlY+E5dn+K2oQ9SWkSP/U+90yvHODBS
         NRapZuDWjOgIcuxL9cQeXHzZwV4C3AzfD7ii6/rt+bT97ccUOFzJQ6dsWXh7XXcTSPXt
         h5ticuXGfZkh6ue/P6CIJVRCH4sUGS3fmJ6JffgX4kEm5qrGjifQrO5EKq88c/dtR3/N
         pHhXy1oteZ51FKIEACsA1mRnF3un45NN3trQ9nQ1cWnzAxekbdu/hOVfEbs61aas3H+p
         uU69I0FLddTBET3rIQtWifiOvca0H1WfJ/O8EOALosZcbnY6zuydbZoKJLd+PU9ETDc2
         gb0Q==
X-Gm-Message-State: AOAM533pemGw6kj0SEgixCmC69bRlrwca8MxfGRn916j5mGNKdshaq7Q
	m8WNQJkf5gGxve8+14kj1AyWWoQHKAJVC5gi7T4=
X-Google-Smtp-Source: ABdhPJzqDAQNJ4yOOPQKWE0kEqpwkERe1XdkG9z06KHZ8iQel5gcZqcSfblI2RjnM+ksRD+B562jIJhEv9qWCoeYvkk=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:e5cf:: with SMTP id
 u15mr6643416qvm.14.1601416050747; Tue, 29 Sep 2020 14:47:30 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:27 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-26-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 25/29] KVM: arm64: disable LTO for the nVHE directory
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
2.28.0.709.gb0816b6eb0-goog

