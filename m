Return-Path: <SRS0=DpE3=AF=lists.openwall.com=kernel-hardening-return-19127-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429B4C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:36:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 96DE1206C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdroIDfh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96DE1206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19127-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3405 invoked by uid 550); 24 Jun 2020 20:33:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3306 invoked from network); 24 Jun 2020 20:33:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A7cPf0bNRtzZYfE1vc1rDopHSIr0k7cT2ZUm+OLZjv0=;
        b=QdroIDfhWPMl7iB8nPdG8F9r+Jm4224Qh0WRTBS1efFhFRpvTdOpw1Wqlz8qn+FYQH
         CFYve9pYyAVcIOznwtpq4QOlb+uiIUyfq16PYsXpTvWntxsZXcxPZ5lIUBkOt4NXo1Sm
         PFaSdzav1KtGvpCE5Ob7mVSvukaW8AVYgaIRlUr52jjyj1zFJ6R084rNzCDR/va5Iujh
         UoakKiURAbGW8xR0S2+Nw0cEeLy4uPMRYJtFclzKSks+5zyjfrBf44Qy3NgDTq9URhoR
         JWQuukFmtbdz9DrqDBlQZj0VkdPwnrqlxkdn89XzL10tIPUOY5/Zz6v6QbMuu+nDt0wT
         e8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A7cPf0bNRtzZYfE1vc1rDopHSIr0k7cT2ZUm+OLZjv0=;
        b=UJqF3nN2O4QqGfVt9ZvpMNpDee765qEWDUUA1nJR4sMVtDGxsJ3Uzkm2QUnTFoq+mF
         2MSFzvFzTEXANSMM9agkO/ya+roS4lHxHEPO+PTzGyD4xqJMwPEv8wvbwyOP4o5ycPiu
         vgU3VMv5239KBjshg2BLjmrUfg0zYEqiJEtor/46cM0P+aAp5mP0cJv0Rm9I748P5g6P
         QOHEbw8Q5i/SQuotrwRCVEO2ZBP5jqDsnfshXSbWb9JAQogOUuP5rsujsW63NTMA00ix
         1LoxMo/v9Lk5QNLvyEoP82hTNIXuzKNOBJMGjVotggukU7FC4nWp1YUL+yMzdoQTGGF5
         xdrw==
X-Gm-Message-State: AOAM530KAObyi8BEJt1fhF3Tb7Dykc82vdkAEQm2kdKQ+HmgdenmSE7D
	1ZEHe4JDZYsZH0NRw0hSZJ8G19/+4GtTeJ0KwCA=
X-Google-Smtp-Source: ABdhPJzex3csdM9Cm9Zm5kqXnJN1Q6l9vC80id+c8eDzSpyHr7eNMt7lOs0z0JRAKDBh+QA/j3WYj56ZTQDnUtqmFPY=
X-Received: by 2002:a0c:fcca:: with SMTP id i10mr21455652qvq.150.1593030812853;
 Wed, 24 Jun 2020 13:33:32 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:57 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-20-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 19/22] x86, vdso: disable LTO only for vDSO
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the undefined DISABLE_LTO flag from the vDSO, and filter out
CC_FLAGS_LTO flags instead where needed.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/entry/vdso/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 04e65f0698f6..67f60662830a 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -9,8 +9,6 @@ ARCH_REL_TYPE_ABS := R_X86_64_JUMP_SLOT|R_X86_64_GLOB_DAT|R_X86_64_RELATIVE|
 ARCH_REL_TYPE_ABS += R_386_GLOB_DAT|R_386_JMP_SLOT|R_386_RELATIVE
 include $(srctree)/lib/vdso/Makefile
 
-KBUILD_CFLAGS += $(DISABLE_LTO)
-
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
@@ -92,7 +90,7 @@ ifneq ($(RETPOLINE_VDSO_CFLAGS),)
 endif
 endif
 
-$(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
+$(vobjs): KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO) $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
@@ -150,6 +148,7 @@ KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS_32))
+KBUILD_CFLAGS_32 := $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
 KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector)
 KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
-- 
2.27.0.212.ge8ba1cc988-goog

