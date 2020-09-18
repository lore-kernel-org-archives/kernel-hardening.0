Return-Path: <SRS0=DxHg=C3=lists.openwall.com=kernel-hardening-return-19944-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43549C43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48C672074B
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OCV4Zse7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48C672074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19944-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25953 invoked by uid 550); 18 Sep 2020 20:15:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25866 invoked from network); 18 Sep 2020 20:15:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=EemRcLRZpf4yhUCeConvvCXzQf4ZIu8nUiUP+DipgvE=;
        b=OCV4Zse7oPgDcT96RPBXKapnnI9L/7OK6JFTGp6JDIVB8reBmtTJ8x+TgIHV1bQNT1
         yODGYby9kVyQ8p61SLU/yg6HA3AOyBDoEQN4GCtsWbyfUxYsi9LakuSQeiu8C00FOlZC
         nXQlthrKXhecqdBCG42wjEu4ZA8UwNU7ri1WD8DdF01m27taT1VRMqPpDB7d1xzavjQ8
         MAseVvLfwDnKz7Gcqkbl036OnUwQ4zBvKuexGNe7hy44z1WPbLj+0871OLhE9gceGoVn
         2klPRgv3y+JB0+4x23CmEway5+Cp0Bo479FvHgqkdJAIc2SvpuGCJORrGOpziKgZ24iA
         XC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EemRcLRZpf4yhUCeConvvCXzQf4ZIu8nUiUP+DipgvE=;
        b=O/MUWnhgETKLWiO+lt1sO+BvhmpmceCfjTnP1axEbVYM/iOpoaOJ5ipKhpw6KeF3UE
         G7fJLFsGizNiVhRX8iE5zc/1nHy1DlnZ5tA+m5RJIImV0ub28DFQ3IgHyiTc6+99MQQa
         g0g041zmYN+yiL4P0F+fmjwlIs2cvuvr+plEoRGSROjKPgy/5W6Dl7slxlKix1vp7+eI
         /8puXgN0SfchrKvk7Pp3e4KglxMZG3YjM2+Y35kIr9NIPaexbnwBRRZUpKhJgPgAbTxC
         a6sPii0M1FYR1W5LszAbPY9IIQ/+VHg5LNI0EUjcC7jgxEKr2GO0WHgbueTDR+rcsLbL
         agBg==
X-Gm-Message-State: AOAM530Ec5Roy4TJAqwX4IU/Qcsxio00/dglIrK24c9yGg4B/pjbD6zf
	v0CkVec1ShP1rRCBhqp6hqwZbE3nvzmr77ICdo4=
X-Google-Smtp-Source: ABdhPJy7xp/LOuFwPpGGCHEVYRylz0MppKOo/jERMBhhbHtsIbQOQ34wy2DpN2K3SkM1Tla+jQrOeY2Z0njz9hLTvIY=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:4891:: with SMTP id
 bv17mr34873677qvb.20.1600460146163; Fri, 18 Sep 2020 13:15:46 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:34 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-29-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 28/30] x86, vdso: disable LTO only for vDSO
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
2.28.0.681.g6f77f65b4e-goog

