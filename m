Return-Path: <SRS0=X8NT=DG=lists.openwall.com=kernel-hardening-return-20054-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D503DC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E311A2076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jeIjKmg7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E311A2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20054-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3156 invoked by uid 550); 29 Sep 2020 21:47:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2012 invoked from network); 29 Sep 2020 21:47:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=DIPWfuOfjnS0FLqqhnzrIZ4jlncEeE+o+vZP3RuRCL0=;
        b=jeIjKmg7IRS+l/ui8Q+LF8nOaIvlsjsr5dJcnvSqyimVjw+fgPn/vAjJUtO4XmZBa6
         Xd0TPg2PXsxw8JWRlXMof9WtQxCvHX0ajUKKZHY+h9ZrQj/vHt4kd3uCJRU76eVTlT3l
         qvq/mdBiAQCfz0NkdrERe4By8JjkFVxXJhBvXJYakKcsE9Q3uXpA4c2ihpOBil6Arsgm
         /XRIkE6YivpM0yPirN/ctrfV5AzOopT2G8KpjaFwIzwdIty+tJ9NNd0YLGlPN6mpQHOt
         PZmo5ltSZAvrWwfyVtCxNb3oLaXN5GzVBEfApucjE1oqsSv0iOxejixTaxe7xLdJuwWh
         mCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DIPWfuOfjnS0FLqqhnzrIZ4jlncEeE+o+vZP3RuRCL0=;
        b=gyXC+wUTMXGeMQLXkr2dfG3n6aChQ3ePKEuIT9AjQa93s94bH3etQvk/7fMkWdydlY
         uWnzGFnX7vLbvU7wcS5WDGoJy4+ZpT4mNSTzXS5RotXZIvUeECA8cd3n8O/bAWgtbEYI
         hw34qWqO16/lWo8p3xNadlzxClMSpTgaGJrvJxib93xyOU0jNLnW7FouFir4iQy7XsqT
         GdDa/LC+PopZ2fYEQPu8ddvPX4RNjHQxMbt/QhISrbCPcFaE0V7oQimAM+OLAKEmtLFB
         uGisCM2dK/9Vn4CfxEenPw5a4QGiIe5ZnflG4KPJ1NunUDXHjX4OCPnYrSNehNR2IiX9
         9vVg==
X-Gm-Message-State: AOAM532OkxSEiMwiRrw+EOquRbGEH/kWPuOR8yihCeEFcxr1M3+jgjjm
	FBH7FzPsYxgXp7Y0gqA15hsFFrPP/N6CORvV8TU=
X-Google-Smtp-Source: ABdhPJxh9cX/NQWJyeaf5NLdRHxlNrjwWH6kgp9BcYdpdAAl3zdkTlK7VGeQKrVU7UdbXnmP9NjmecTJ1e08yzk/vjU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:b308:: with SMTP id
 s8mr6728794qve.16.1601416048309; Tue, 29 Sep 2020 14:47:28 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:26 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-25-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 24/29] arm64: vdso: disable LTO
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
2.28.0.709.gb0816b6eb0-goog

