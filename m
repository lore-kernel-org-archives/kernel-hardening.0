Return-Path: <SRS0=3g03=DG=lists.openwall.com=kernel-hardening-return-20056-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2854DC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 46E6D2076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mjtEviXm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46E6D2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20056-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3697 invoked by uid 550); 29 Sep 2020 21:47:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3600 invoked from network); 29 Sep 2020 21:47:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=HR6xYTbNbcDM2Zx8OyOOjD6y5MQ06zsj0pUhq+j+6f0=;
        b=mjtEviXmAKLxRM/LKJDKCHLIap39YYCJi8bXUSknQxexGmScOixPfgLk2saryOKVhr
         MDXdwtc03Qsk8BhzaMB6wWLfJxFsJFr3vbeje5KUt1CCBDcvypxfH4Fd/DWdOskLuiWX
         NuoS4Bfi9pPbelk7+Wps01W1gREOYAgy0hs0foMuoNPzPZHoq/3Nbj/lsE5jTNdKMozj
         B1pDJbVp/H5WbOFBXWVr5QnvhRybtlvviWImhHwfWGzZfBrzqfvE+v/WN27Qnhw99flS
         d+zHsrVrZeZ906dvjvCq1dGlmBlNMTipr0bhZn+88+kegFwV/4iyBn9hGct0i3bRdod1
         YlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HR6xYTbNbcDM2Zx8OyOOjD6y5MQ06zsj0pUhq+j+6f0=;
        b=n2U9ptF9jumMsMEZQSDP+p+7dgDgX4hpw9z4OQLhPiJDIJF3F2zELwiFjnlwIJW9RV
         Fsw4PXLMfgujltzxrNwWhuPTssgB+Y3u1i0ywgXeXxBXxFhaelhROO3RLWs+o8VH7MoD
         i2q73YVRnq0O5/nNUXAO1fBAVDPiTG58L+kyaokeyExubIJaWuwWINFr5joiCKa6LecL
         cuX5Vgdy9nKLxYa8Vcb3QjvBsCwFxCHfg56tH1FpK97dRjXLPkrIu3wnfbqBIpoeDvsP
         q3GBOCzu+BFlFPqlbCvH9PQaDqwsnGcq7SGEoyMgoMPST3ZzzgWIkT64VkrdpubkFb2r
         g46g==
X-Gm-Message-State: AOAM533PrEMqU4ja8A3cfF1QQiosP+eMtnYU/gNgEEBCL19Y5QZw4bUt
	J4SM5xFv8XUSdtFT2BIgH8L33hT9mTFXbqABiN0=
X-Google-Smtp-Source: ABdhPJzU2WBEA+8eGCg04PobSkCT+PMZ1E++tYvTMvMYCJ02D4tu/Rlfu13A0+WZqSX+Koxe9SboRRHBjqEXIi3STU4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:d682:: with SMTP id
 k2mr6249286qvi.27.1601416052963; Tue, 29 Sep 2020 14:47:32 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:28 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-27-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 26/29] arm64: allow LTO_CLANG and THINLTO to be selected
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

Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ad522b021f35..7016d193864f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -72,6 +72,8 @@ config ARM64
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
+	select ARCH_SUPPORTS_LTO_CLANG
+	select ARCH_SUPPORTS_THINLTO
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.28.0.709.gb0816b6eb0-goog

