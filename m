Return-Path: <SRS0=jg1o=DU=lists.openwall.com=kernel-hardening-return-20197-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6345C433E7
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:36:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 017A821655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:36:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UStis3hb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 017A821655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20197-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21793 invoked by uid 550); 13 Oct 2020 00:33:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21676 invoked from network); 13 Oct 2020 00:33:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=s78GraQfKANUm9dTCmVzo29Dpzl6ui3oK0KuklmHT+M=;
        b=UStis3hbnwPX4GBdlrEziRJNAuXpozGmmfM1jjzsAsE8VSqd0cbY6odMaz39IA0Ojw
         whXL6/eJ7EeqBedFDwaT3w5Q+1TV0rdJwA3Y3y9puXLwfjf7F0qnCIboZUysC1WDMVid
         4Nj43Y1l6hIv3BvqtYvKlA+3y+Qx5yGdBGC7iek7d9zIgRpsjTFpfGg7cM3b7K4jNPc3
         C+tUthfv3AI4pSRMqj3k+jNvTZwQ0NPU9oBd39SNZPMR7BGOFp7+kKDm9ZAbYc3IAGak
         ZWMXtsvozkuOgmM9rpB2qjGh1x8II7JaobE2C/HaxwERoWZW6ZWfuMc4skxi/3WZYGIY
         484A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s78GraQfKANUm9dTCmVzo29Dpzl6ui3oK0KuklmHT+M=;
        b=CPFkBK5/mcSvhHBcazZAjM2jJl2c7ynXdTZ6+/K2XIO3NiX/8HDGlkfNzpQ24aCQVz
         XcMWmCKUHdMlIVcd2Fobfs0dKvasz7j/90v2h53qAw/Ef0YOUQeFr4KZL6fMwrpi7zq1
         P3xw7RNUopCNebftLCecscLFY0TegJalbmUU3HOnmKjWl+nmyOeLBxo1lJbOXY7Tlqms
         D4XA9a5IqdaSz4xI4LcK9Jf9eTJJJYVCBuXVg5bXr9ump2UofwajIwl6c7c9H+mrv0+A
         wlkUAjbbGFDMXMe1ddYVBcVHmTFF0sURa586TgMrR8RTEVyoO6KKoc9qtiKT135fbqZe
         jVrw==
X-Gm-Message-State: AOAM531TBNEOz0tkiY+a+yxYRS3QtcS4sek5AuUk39wrAnhD1Rsi1njf
	9DmCBApO8oWJX2fSwSZ1lt+MvUt4gFbPmMhC68U=
X-Google-Smtp-Source: ABdhPJys+9GAtwDLSAFaJoF/SaTJzh0YT4ITojDPzI8BvdeCNUSIWeGX02fenqn9RcJYa4C5XTo/mbLq+dmrOimZhu8=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:902:b40a:b029:d4:e1c7:db59 with
 SMTP id x10-20020a170902b40ab02900d4e1c7db59mr157311plr.85.1602549179447;
 Mon, 12 Oct 2020 17:32:59 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:32:02 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-25-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 24/25] x86, cpu: disable LTO for cpu.c
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

Clang incorrectly inlines functions with differing stack protector
attributes, which breaks __restore_processor_state() that relies on
stack protector being disabled. This change disables LTO for cpu.c
to work aroung the bug.

Link: https://bugs.llvm.org/show_bug.cgi?id=47479
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/power/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 6907b523e856..5f711a441623 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -5,5 +5,9 @@ OBJECT_FILES_NON_STANDARD_hibernate_asm_$(BITS).o := y
 # itself be stack-protected
 CFLAGS_cpu.o	:= -fno-stack-protector
 
+# Clang may incorrectly inline functions with stack protector enabled into
+# __restore_processor_state(): https://bugs.llvm.org/show_bug.cgi?id=47479
+CFLAGS_REMOVE_cpu.o := $(CC_FLAGS_LTO)
+
 obj-$(CONFIG_PM_SLEEP)		+= cpu.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o hibernate.o
-- 
2.28.0.1011.ga647a8990f-goog

