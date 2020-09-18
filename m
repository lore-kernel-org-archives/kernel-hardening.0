Return-Path: <SRS0=biTk=C3=lists.openwall.com=kernel-hardening-return-19941-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3B7C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 877D020684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lu5o9R8g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 877D020684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19941-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24258 invoked by uid 550); 18 Sep 2020 20:15:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24145 invoked from network); 18 Sep 2020 20:15:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TqIl0XsuMws2W7SAyTGgPlMUxJpmV31lTKH8j5/4FZ8=;
        b=lu5o9R8gm3jqcUgmwu4AY/DoLfD5wt5MOlJd0k40tfngeaf8Nt07Vk6ePP9t8NlEZN
         IVqlDHPcBWhQmmotn4u+3EefhUJi4+cheG5oC6RvYmB7RkBMe7EstPG5yMRAIDKgu2g4
         axLl7OmVkBvP92Q0Qbvl1A+S7pF0924SmotebecxUz5whagk2WPh1iNdxekOtLgSwwwo
         0Ns1oRsUkHTg+U1kphL0FSFJspdH6IcYbg1jpew7/hIrVEFAzVHH8yr+R74J5oNr2P3K
         IdJppxeqyy0BnWW1z/jWEr6bH3y/3VeXHdJFclXUQXKes6i8fQsPsWgt1B/kImbNCuTX
         cjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TqIl0XsuMws2W7SAyTGgPlMUxJpmV31lTKH8j5/4FZ8=;
        b=FdyV8WaYzqD7UwIJI9oMJQ/3WZxq1n3y7tEpbZd19YG7Gg+hLFFkGIPdEVrOtpMmd0
         hTajbjCWnTUENcMhfD8uexVVM+V0XdP49pXWGxkNFTQumeF9oMiC8GgZCMNz33PInhtQ
         qLrgv28DZH/8YOrBH0DY7k95swEdd7+m3qLqbrZEB3oZjTh5a615sgi7Oqo9tDCIdD9n
         FRCFtI4CAoubSDJRvJWvaA3zxFC3qd/MOttEP1CcMBLYFcB7WKxDWCqZHY9k+1XVQtet
         2DlCnbBlMmXsrU/V7rnGpC6JvHkLfDYcqQcmbFS/SHiNQFiXFywghDF5tvVCRLjAV/Lw
         VyaQ==
X-Gm-Message-State: AOAM533nDnENA/kElqRdA/8R+7VYHJtQP188htS9irnFyH+wIwzs1IP2
	28NSMUZniMKJLhOerkpqw7kEgDchF01wxv1ZY9w=
X-Google-Smtp-Source: ABdhPJzM+bDDdhQ1yuvEohGu3NxsCeWWPsxJypy/LfG2x1PLzd9dzX2AyM5yRCrQ0RzzRR4VA988AWIJ4v9Gjkgti5E=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:58e7:: with SMTP id
 di7mr18639207qvb.36.1600460139023; Fri, 18 Sep 2020 13:15:39 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:31 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-26-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 25/30] arm64: vdso: disable LTO
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

Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
point in using link-time optimization for the small about of C code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kernel/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index e836e300440f..aa47070a3ccf 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -30,7 +30,8 @@ ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv	\
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) $(GCC_PLUGINS_CFLAGS)
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) $(GCC_PLUGINS_CFLAGS) \
+				$(CC_FLAGS_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
-- 
2.28.0.681.g6f77f65b4e-goog

