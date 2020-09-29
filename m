Return-Path: <SRS0=2pGj=DG=lists.openwall.com=kernel-hardening-return-20039-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B9AC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:48:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 416BA2076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HdK7XgY2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 416BA2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20039-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28302 invoked by uid 550); 29 Sep 2020 21:47:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28238 invoked from network); 29 Sep 2020 21:47:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Xjrukg6K3IydY/lqqi+bCZNdR5RjdEmABiI8yk+fZMI=;
        b=HdK7XgY20csMFcb+NLyDCXa0Y0BGLZ848JpvtrKXuN4kP13qc7mB9gIo/tOvGsTK0n
         Ji2dtRPOFfuxFcA+duNxDZiijoE33HNw7tWDF5E8m1wqENg9cj6ei3CjwJ0N3MORXBa0
         OiIDsCN2lwWZN36P+HMA0/i6r+hGq8LSRXCmTEW0ezq9gHlvKKSRObpHJBOae/EdWdAU
         32Gd6c/t2yV+iQQ9uWMBg3zEyEcOs6POlcO4VSL93GZziqn82PoJ2cs2fwnaH1D9AfNM
         SAML6VP9UfLTVbfCFJsAI8Lgk3AeE4OjZhWgBqaEtQTo1lOZgisnM8dMNB6pz6Qg5Lay
         cqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Xjrukg6K3IydY/lqqi+bCZNdR5RjdEmABiI8yk+fZMI=;
        b=cY4S1ep0EhqB1vt5rA0ekbJTT2mOXU9am/R+Uubj/fgkKu1uj3Q9vgsgO5ZpQ/UJ2S
         MYzeGGOHMbJNyc6z+qGlIfiquBl61CPW1NoOae/wDWGG3WaOCZkxdC4bDcqsvHGbbDIg
         goQjfkcSzfGqyPvS7GPKhoGypkLeM/NtbcnwR2STt/xtsD1bo3lQc227ts/OTLtc5Qu/
         siqk4OHlZV+yyylRTdogxPF1dsoWzD806VFUOnRY8e6eU0Gx6h+Kd5I4z00wdR1KV19v
         tiQ+hawO/M7WcXNLWnmt3lmEdMaGbpNppbONTIrnw+cu1FLKF0cNBfdC9rbLSjAMimEl
         ftkw==
X-Gm-Message-State: AOAM531lw72xp6zG6IBzutOzP6LreOa/APu9vlJSZa+BfgCjMnObMk5V
	F3RKpbFrn5IdMoVxAoH+X/m0Nqh0/0iGzfuLPbk=
X-Google-Smtp-Source: ABdhPJy7cJ63oyWVE3guhSQ8dpAugUL8BOvZOYiTdX/ZOOHGsEKlj0fM6UJAmLz8cRUfCBdDvDQP4efk1c6ZbLA+m7Q=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:42b3:: with SMTP id
 e19mr6361028qvr.6.1601416011975; Tue, 29 Sep 2020 14:46:51 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:11 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 09/29] arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
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

Select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY to disable
recordmcount when DYNAMIC_FTRACE_WITH_REGS is selected.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d232837cbee..ad522b021f35 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -155,6 +155,8 @@ config ARM64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
 		if $(cc-option,-fpatchable-function-entry=2)
+	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
+		if DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
-- 
2.28.0.709.gb0816b6eb0-goog

