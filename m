Return-Path: <SRS0=CTce=DQ=lists.openwall.com=kernel-hardening-return-20153-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851E6C433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 972992225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0h0mH4w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 972992225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20153-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8094 invoked by uid 550); 9 Oct 2020 16:14:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8009 invoked from network); 9 Oct 2020 16:14:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JHNK5VWD3ddVakk1msJzGMuIHjr7wcpFWGy1F5g4J2Y=;
        b=M0h0mH4wlOZcaJsIi5sQEuaiXKV7B0eKEoaPKg3kbfXsWnZ9dgEuFhvr4GvOUISD/R
         eAtFXUMTPEOVHW+XOblcQS/ISTtHpag/wILGcioqEck1N+9WCscWL7vFacbN6GUuar+k
         4PnFjNWO2auD2wONFsEZeyA0wE6HkoReMLefaUGdvzHpzi2jFdR2nk7TLMGHQ6IGcOSj
         3cIInTMXmsjJLQw59hUKMC6ilpXp3px/V6+ZuAnx5tBy0UDfBXrEN1SKQjcZ2XbWb2iB
         va5v3rnvQOCmgyUdtx7z8zjGiV0r6NCEuQQzlxkUNcl+QUN74zldCyfQQhUYvV8F8BwK
         NdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JHNK5VWD3ddVakk1msJzGMuIHjr7wcpFWGy1F5g4J2Y=;
        b=j3OWCdFcwMsgRAqP98qS8JNQ2yAtyExuAYXsJyt3PmhYCfVqT4LZbIK4mfE7jnG3Et
         mP0Bma3r8EaYBV4SKJjP+CRFBYyNT+jtBHoONsvW3Dvvv5FrHM588Ifv+wYBJe1pczd7
         rMUipKuccIIotd84m/ZL/qtImlWB+wlwey1Zt2UOLPasvMpH7HIZ0u5pA7DLFAaPdXKu
         ctdTLUeRsQbISMRLgDjAexS6kRn/UseszV844IbvfS+db+Ou5F+sDJj3mPBdQ8NcbVvd
         qw8C4vDIJstkysAiqWa94/QxEpC6hRfJF8GmnbeI65/DKzWNNCxxBZRDo4lekElqdb5+
         eXKg==
X-Gm-Message-State: AOAM531JEVkvIVt5qyUGC0AX5Y5HnHJNCYfQF04JXpdl8GLAG+GI9tan
	DFe64KvcCZMFndKe07aio3i1vTdLqwUwVp00opc=
X-Google-Smtp-Source: ABdhPJyNU5RpFXb6oDaPa5kfxyMLH3rqIIuf9in4Eo1ivOzj/QSIy554fzdbu1UoaF9jnvjswSLNZfW1sHDa3cxCuBM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a62:7a53:0:b029:152:5482:8935 with
 SMTP id v80-20020a627a530000b029015254828935mr13281502pfc.31.1602260064759;
 Fri, 09 Oct 2020 09:14:24 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:31 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-23-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 22/29] arm64: vdso: disable LTO
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
2.28.0.1011.ga647a8990f-goog

