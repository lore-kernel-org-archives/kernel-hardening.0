Return-Path: <SRS0=CLob=FP=lists.openwall.com=kernel-hardening-return-20596-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736D9C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:49:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BA26523F2A
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:49:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA26523F2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20596-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9871 invoked by uid 550); 11 Dec 2020 18:47:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9831 invoked from network); 11 Dec 2020 18:47:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=D9wH7plBpsyKB7z0MJo6lESfcO9at50jK7OVp+0NdAo=;
        b=o9YQ2WaCNG8K0/fs9UJt8tjJkZt2V+zu8nGyyzGv31aRlZwzdERkcEEzcsjJzK7Khh
         Fk/jL/s8l2hJliwPNQGXJKzeEfZAhZNL3N7YQubgkjL3MBt3ZaOHRNJKHKyKgl7rzP3r
         CbLCHOiTVvpx23P8dNWk0S8pTKQys5/iAUXEqkbZkIdXP67EvijrZ7suaxN5SM1AiGUg
         Czctp/iCgtSTfOnV6MNPNWCT9Gw6yx2WXcKk+pz2gFHpPVleQlFs2WHsbthps4QXwlxm
         5FQuFyoHqaAxpIDOc7NISukhUKz44T2F+pYRZntubJg1eb5X5qyK7NUJ7/Bfmj3XKKx9
         8T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D9wH7plBpsyKB7z0MJo6lESfcO9at50jK7OVp+0NdAo=;
        b=EDuqo/n7It7SdWxZleEXfsmF9QEoW5UE+oGU0aXfn7vezadDP4/3VWuChKRnTjLVW6
         TFgpsbA3x7VyA7+8KeCgeh+L4SJ0ivWSc2sFaXLm6RkvFbQ/XYchjmV5J9qJW2U7rf5c
         +YdLOP2t0nqiFmVBLus3qHF+A5Tz8iqDfTPqP2tvmGeZDhJ4FnVX6wJfUFvfstzUL1SW
         1dRjdju14tJW+idXhEynwUTYbl4tcImo3xgwlcNStEAz7QLULC2SpZaASIGpiwBKbulO
         +2pA1Yo1wWOQp/7NWLFIvFpUeFSWDfTEv1a1jVhbJXkqfE/7ZkVL2nJB+u6SWwcBSkXc
         RUwQ==
X-Gm-Message-State: AOAM531zJnEtIPoYyyEtFbqD6tLs8JWfi1rsaB4BDUC6fLlrfpFnJ0Zx
	b3w/z6k09jNLQEMCNJXwmIu8Gvw8engE7Jmbm6o=
X-Google-Smtp-Source: ABdhPJznzuiVO4idqxJMtdzoCHbXvL/GitFw7UhsVnJ6x3E9oWq6Kdg+IUkD+jO4kIRIFWgi1U7nyXaq6VyburgAblw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:6405:: with SMTP id
 y5mr12176868ybb.328.1607712423523; Fri, 11 Dec 2020 10:47:03 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:31 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 14/16] arm64: vdso: disable LTO
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

Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
point in using link-time optimization for the small amount of C code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index d65f52264aba..50fe49fb4d95 100644
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
2.29.2.576.ga3fc446d84-goog

