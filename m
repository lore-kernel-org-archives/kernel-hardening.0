Return-Path: <SRS0=pHgq=EY=lists.openwall.com=kernel-hardening-return-20421-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8628EC56201
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:10:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B7A12054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wyirgobu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B7A12054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20421-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7495 invoked by uid 550); 18 Nov 2020 22:08:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7421 invoked from network); 18 Nov 2020 22:08:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Nlv9TtNsD8fyGZu3R87XXmbB0Bi+xxOBLxznH5wjST8=;
        b=WyirgobuLaISXur5OETz3eZnFCLE1kF2NBpqHWeIkDujjqI4PTHmgyyXAb1sNUuHVN
         Megmr6usGQTpCjvxunY6g475SVXL5PIUg4xn4wNAXU/O3G5axjtfvi1UZNaKLuLRYzl+
         H7vQeuVy+SxuGDx4D44bti70PiBfA/Fc3fj5gR5ZBA0IAjFSuTDfAo6x8m+qBTUa+FN4
         nVGzOamtnPS4n9xOnes8ikNN+95nJ8r8jDlDMPEu/u6I87rrC0kQZtn7FOesX7zgskpv
         7cU1bdPWutzDBqXdefcq61dRpBvIzgZAnfJAtbylX8NSGb4UV73Xo8c5A2fqUr0JVzRi
         d1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Nlv9TtNsD8fyGZu3R87XXmbB0Bi+xxOBLxznH5wjST8=;
        b=KcxQPRVcG+WUW5awSwl4NQiEDPv2MJuf6L9fB22X8Ew0NmzSVNeqQuM9aIVujQkVHb
         7cdEz+pudevJ3clsCZzGOv9FtLLJRGG3dubGj4xV1RI2gIDECnC8GAjd4eMl42AMFmAV
         VGszNsoSmvPyo+NkBn/aanOT0IwaFq8yy4IIoIBNYYk+m/rDji2nmiS9N5s0+HmwKVsd
         WrSody41jrC6HNuz6EyFOY0dn5zyrfrM7qmwh82fBshH5GgVO5bNQmjTjPqfhnKNOXp4
         jx07CLAawMEmT3AzsCcT/cZaN6mSroVBVH+m5l/aiEqNlca31lFK2bsBUcKAzbDrpU7L
         LIYw==
X-Gm-Message-State: AOAM531p7ARHAuWyh5pWFKrpR6r/6QDm5RAurERdb2p9jw87fXbhaRKB
	Aom2/+wWyuFvWNt9w/sr9e2iTbzcumwkukjCwvY=
X-Google-Smtp-Source: ABdhPJzn6vg0M5iTYPWjSWDRpSi/wGi1RShBZ+9f1oY4yzr2uEIppawRZrpye0kyCUINDWBYJ3z6tcMBnMS/ieVkr8o=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:b65b:: with SMTP id
 q27mr6722891qvf.8.1605737287989; Wed, 18 Nov 2020 14:08:07 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:29 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 15/17] KVM: arm64: disable LTO for the nVHE directory
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
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
index ddde15fe85f2..4ceed7682287 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -51,9 +51,9 @@ $(obj)/kvm_nvhe.o: $(obj)/kvm_nvhe.tmp.o FORCE
 quiet_cmd_hypcopy = HYPCOPY $@
       cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
 
-# Remove ftrace and Shadow Call Stack CFLAGS.
+# Remove ftrace, LTO, and Shadow Call Stack CFLAGS.
 # This is equivalent to the 'notrace' and '__noscs' annotations.
-KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_LTO) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.29.2.299.gdc1121823c-goog

