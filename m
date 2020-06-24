Return-Path: <SRS0=F5D+=AF=lists.openwall.com=kernel-hardening-return-19126-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF86C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 71AA6206C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UWquwQhX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71AA6206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19126-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3217 invoked by uid 550); 24 Jun 2020 20:33:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3135 invoked from network); 24 Jun 2020 20:33:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tPGFlpm4UBb0TochKjxo1pWDKJKPOqpdcyA67hsa/L0=;
        b=UWquwQhXAU0FVu4xLvS68q0H5KMxmC2ClvghZJMO4mnRx07EpAl76zEcZBzo4oeEr0
         7QXs8i2/+8O4w4SxtWsY3wN7GwxBdmr8ei0LaPar71G/kQf7fHaujWILvZ2kj0I3OQnr
         XU2/mlOZsNQvQSHPQNf0o+Qm3V8oiEUyLdtK1wUmyBN7hxR5xoSfaX9vD6ylX1d8MUtg
         8oc06ZHQnmcIQFLeYAyeQNfJHs0QNV6Vk/mbPBcPZcsZ2TSgTBf3waXZc3e781NAKP/5
         u74kiQ+ly65wZm433U8lBfaxNpuvW2v+K3io3UW/wCh82HySe+7ylz3czOz1zaRbngJk
         H88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tPGFlpm4UBb0TochKjxo1pWDKJKPOqpdcyA67hsa/L0=;
        b=amzdAkvVwAKVR6eZGaYRVuiV0zQT4d899DULv3+Xt/KsWxCk1dtEE73Xq7t3m5l/jN
         BZPWm/R0qpym0poLUBRBJvr+ijgJgxnZadZeevCNipu2ZUwFMWckW4USY5ET1jaBVkMT
         PG2B9lnLu8H25uOr0KX0QOXgQ/EIRfqz9vkey+2ZX+YKA+uU2ozXIZR/2+zqnsV3oj7E
         fGWRUJKfo7r6YTyAXO+jWx4tkZiGQ35cwLpObyiWyF1K8UnF6WQz/esWAUsWTfBr8Hoj
         0v6hoHCCS+ZRLsLTEd4/y+Ep/w7bob78u7t5XodVMdVquNbBiqr57/KB95o0G5U95fH0
         rE4g==
X-Gm-Message-State: AOAM532P23QapOG+Tj/9GDk95HEVz7J3bK2zKKgKOrig7lPtWR60bF/1
	Envz2IIXmXlowbLTxlCviDX0+nzm2f/10gWyPlM=
X-Google-Smtp-Source: ABdhPJwOmVj5AVipomAFkeyuweymmty039I+YIpShmyF/4KLduyGozlOwEpdaQAyz+L93rzFTlrhSA4YsbqHyVAyM6Y=
X-Received: by 2002:a0c:8482:: with SMTP id m2mr33607693qva.65.1593030810891;
 Wed, 24 Jun 2020 13:33:30 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:56 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-19-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 18/22] arm64: allow LTO_CLANG and THINLTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a4a094bedcb2..e1961653964d 100644
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
2.27.0.212.ge8ba1cc988-goog

