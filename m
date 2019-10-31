Return-Path: <SRS0=kEn/=YY=lists.openwall.com=kernel-hardening-return-17201-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B859CA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:02:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AEBDA208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwFwWyNM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEBDA208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17201-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9578 invoked by uid 550); 31 Oct 2019 17:01:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16082 invoked from network); 31 Oct 2019 16:47:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J83AV+8pmxy6MQ8Uszleewce6gVoMir4DYxUv0MBtSY=;
        b=JwFwWyNMv/RSq1lmIG7yeu7XzK5N0yGFebd9HD0oWd+L64cVHCjNrLKXvpd31A8m+o
         zacFSlAh7/S3GrsWYw8wOsz2riJzwAmUFphK9R3y/YJdaVSd/jkXF/Q3qSE7wm8QON6m
         8mWRne5R6DOJ3KZmWMsv6rx2Y/vxcHDIQsZfg/5fmf+Zp5HlVd7VP1G5fKtX4FB8a3Bm
         8RVCvD6+cudu/Eg1HxbSqa7xROHq/x3T25smtETOf5KVnSr4x5SBcV1jFg774W893DEo
         G58Q3hgq+5V0/nL/ilZ23sMkgZGieLq55EJ/1/61Mg1lGY8hcPLmSpXvq/AV5DgETbO1
         ZBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J83AV+8pmxy6MQ8Uszleewce6gVoMir4DYxUv0MBtSY=;
        b=t3sQUSqzbU9TMhYbXOHOEBF1E192qlv91aXufUXV8N46aJaXoMJLqm7EpWQs0gytze
         zQgHNQFsDBoN6b+XFHrqjn4TbLRogfp8M+R/OqikUsydKRPrB6Kui95bIqpW7Di2Jg5n
         rW1OQKTWoO7rOed60yklIEK9RRqySa7D9ZT792BVQgV4UQI54Jurp4DxqiGAvXxtE6/Y
         5i8Ojdv47RSo53yKVTK+rZQbY+0sIHNqhthzh+9Zz1uRSuRutI2Bmj332gSq20h0Xsi+
         GS2P5+mkkJ70v9RfjRsAN9n5rPVRqt9ChFXJK/CQj/pK/6XmdoFv3WUUQj1+e+bOTTmD
         HzaA==
X-Gm-Message-State: APjAAAXOwUrgRINVn7VRQ26xKWDLgsUGcFE1i5f3z5vyMXRQHbS+G8Xr
	vn73UQi008Lw5fQmKYDg+2B7MyufzjFIvxhOSK0=
X-Google-Smtp-Source: APXvYqz5tyIdUbH5XenlPdO5u18Bp097Z3l5i1ng81ta9dMEULM4omVmWKyeE1529Bf0daIn3cRdGv4Ho7NXy7c+5zY=
X-Received: by 2002:a63:e056:: with SMTP id n22mr7564302pgj.73.1572540445818;
 Thu, 31 Oct 2019 09:47:25 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:36 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 16/17] arm64: disable SCS for hypervisor code
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Filter out CC_FLAGS_SCS for code that runs at a different exception
level.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kvm/hyp/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ea710f674cb6..17ea3da325e9 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
 UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT	:= n
+
+# remove the SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
-- 
2.24.0.rc0.303.g954a862665-goog

