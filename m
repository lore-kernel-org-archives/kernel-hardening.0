Return-Path: <SRS0=40sB=DQ=lists.openwall.com=kernel-hardening-return-20159-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F8CC433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4684E2225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RzNTfPVY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4684E2225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20159-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10129 invoked by uid 550); 9 Oct 2020 16:14:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9979 invoked from network); 9 Oct 2020 16:14:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=s78GraQfKANUm9dTCmVzo29Dpzl6ui3oK0KuklmHT+M=;
        b=RzNTfPVYG6SI0avI+P425NcI9i8AuKh/Cl957fx8fHhzs5RqhtvTqjehKiJwWbgXzy
         Ut5C1DcliLqQ7eBHuYD2eARb+htm8HZMRcdjOvp9NNGn4mNvqg0iBQ6KDTzK3SzCI/Ck
         ew2832EE5/Csfrndf18x6wLZPdWlZEhk4iKRPcQGgrfXg3mRAuukQoAwCHLabR1+4M6g
         meKHJ7cZKth80rKvdaInliqwayqLZinRcdmYOes8g6yEPhfbWOeJqmCgiqX18se7Af/K
         ryRm6EO2IXl5IsWLnIm6FiXwA7s8mJObCejAMbR/yt+sefiZYk3GwsKgwR63hHzTDcIK
         szJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s78GraQfKANUm9dTCmVzo29Dpzl6ui3oK0KuklmHT+M=;
        b=BF0sD6BKqDg1uRJ/Cg9knS/r2crrlmWO42KL+z7Br3chW/dFVbDiv40CI+666yehnn
         hzLoEv4Ro/SfFgcB+GCpGypDPl7mJ0TqHamJwvVuxapM3uC/1QvDKWQt6SOoUIIHbnD9
         9tskwoYEMLfM5d5kEshPU3Helw6Hu4avWRN0koa3vdR2c62UBxCgsojM6eGX7VcAimJX
         R6dGbRWxCTVKbh4sXKXf0J/BKt9GryvZ3M618OR0Cd5bRXZWW0fHZqIgNWxCKFcij2eD
         nGT761/Y6Hrl27Mo2Lc+zuNH46Cu93aS0JpSk+j9pWskkkohwMfIwoMAhK6itGTP4BpG
         c/hg==
X-Gm-Message-State: AOAM533N6cbwp37zNj5sAOha8OHirXlAZmCTdQPLpp8QVjLfxDeN1euA
	hYZU8ccvaZNR9WSrrwSohtU8SiH+W96/N17Gq3o=
X-Google-Smtp-Source: ABdhPJwN3bIx6ear1i57RoG4zimPIt9+fBvTb2OARJUm8GO/EtKrElZNowbDc+vg8xMIIlLqC25fSoWhS1nT0X0YRr4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a63:c017:: with SMTP id
 h23mr760549pgg.420.1602260076066; Fri, 09 Oct 2020 09:14:36 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:37 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-29-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 28/29] x86, cpu: disable LTO for cpu.c
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

