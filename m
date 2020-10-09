Return-Path: <SRS0=r072=DQ=lists.openwall.com=kernel-hardening-return-20156-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A07AC433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C10682225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tcYmIPBm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C10682225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20156-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9570 invoked by uid 550); 9 Oct 2020 16:14:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9496 invoked from network); 9 Oct 2020 16:14:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ikrbNi1n+JHv/v6pgNeNHRRr1Bi+YQ52wR6bQ2Iekes=;
        b=tcYmIPBmAJ4LMMF7Goo8MPewpphHHyqOReS8Yzjkp758pdRkXSRJFwYPN4LJhRf5aA
         pN9Uh5BwkuYUqZQemLzTTRXc2IUbCtQKHNjN5mIcJ0Yo/YCauyC18trSfmUSzycFDhkQ
         Mw/NRr5iZqjHUGg7OFZdC6jshO1bqHZmLEAcRj1iPIhFpHCfYo3PJz5q+q/Uk+lDZyQS
         v2YSMSnN1TCWlH3GRIGFB5nX31muKzjkKWdKT2ld17JmgpAwOruVsIlTZw6HcTZPePYd
         us6oLH9w7WGbGMX1ZGw9yoahG1e8nob8rvJYyjTD8MyQlv2UIB6ZpCnVJZSKFxMRhVx5
         0KLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ikrbNi1n+JHv/v6pgNeNHRRr1Bi+YQ52wR6bQ2Iekes=;
        b=sNlPUcz3dlrmDtuK8epginTLAJ6vsAoXom77U7DFh5ioLAnRbCI5XW/hti1uq3CQeg
         5dcMHV5lyh9kJT+kcB7AK9IP7qQ6A8Knc3u1rhmyjq63Ztgo3/8q00KtpKj7LbaYhrM8
         aQNVJMENS08KcR3Ywesk7k8q80CAbQtf6NSyl6Odn84ltQ+lB+3PTXpnJukoeh/DUc0Y
         IhApuJCTj7AJ5DzAf9D+JUSpEfW6eK1Rqxi9JiniRTcY/l0LPJW24Hx+tKmHqBFSlRcI
         CY8vptad0D6lQLmIqcN5gMW+A4CH7rAJpvXN/BrneD8WVoyYKQ97OzI++aUBMlfQKuFj
         DlYA==
X-Gm-Message-State: AOAM530/4hGXWUshsSLPBf8elfnHDxwkV1mTtYj1A800qRMMEi78xJuS
	gweMkXgJv3L+N1AcX4kxI7yhx9tVg3Kg0YybQhc=
X-Google-Smtp-Source: ABdhPJxXVPk5t6WuDRtw2kDT1l/kkKrV5Ux4Ln/BVu0jbM2WltiZb9XyefgV8OgdP7tNsodZl6ZQz6Mkv7JwoOsKQcI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:388d:: with SMTP id
 f135mr18426175yba.54.1602260070433; Fri, 09 Oct 2020 09:14:30 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:34 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-26-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 25/29] arm64: allow LTO_CLANG and THINLTO to be selected
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
2.28.0.1011.ga647a8990f-goog

