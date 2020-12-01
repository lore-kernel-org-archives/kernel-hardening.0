Return-Path: <SRS0=gw0n=FF=lists.openwall.com=kernel-hardening-return-20504-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7B4C71156
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 520E92085B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PhIES9mZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 520E92085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20504-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21635 invoked by uid 550); 1 Dec 2020 21:38:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21522 invoked from network); 1 Dec 2020 21:38:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=e77AaMfAoOs/rzHffqgIcODt2AF3tTsGcr7ctg09Fiw=;
        b=PhIES9mZeaV2CcOOl8w4l+2ikBXS+wckgodD2kCIALpUfGhJq/JokBFVnpLyEDHks9
         s8KS77HbtwZgIGJAF1Tgq1CMBOT+U0TGPDCswFllP9/Wb/lsfsDB5gnxFlvnlGfpeufY
         Hy8In8h71u/8sWWwnYUrcWgb/UQdJioTucpyV/6eOUpCpsAT76h4F1u2jVLu4RS0k6r7
         PUe2D5YpmZV4+lsiyaOpuXMkzEX6Xy4dTdjoE4jUNMaeybvIa8H1LPOZHv/Qe2/UnLMt
         PTMAailmADrwZlpd1jeXUYN/0RA5Dv57F0Y3YPHXVxD2ACvJtXUB7QfmCy0vCpyChfJ+
         bQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e77AaMfAoOs/rzHffqgIcODt2AF3tTsGcr7ctg09Fiw=;
        b=k7DgKOvP14aY6rDLhiLRI3cmqMPqFJt5tBCvNC55kvQ1XQYdTzuhF6h1CzAOJiBY3S
         QuxYD1mNIrd7iEAvj6Ck1j9saKyvCOMDWEEL7Nk6RbEJdw39izqhj7zOEZKcHtg/+Xh6
         1iyh9vrqRpontd2wtP3TueaRkwsjEFzLRdJ3rImm7dX040mS9KKsqyJ5EiNVtXtEn02B
         ODwSnzg6jifahgekCIIYEFIunqDTpPZL5JYTdrwbsJxIZLeL9sR4mEInRTMLFrmS2p4R
         r3Vl/9wpIbRiMpve1poaw/0HCSDahjj9wzg+RU3xmVS9QQ9hAFfEMA/YXG130l9FcFZc
         vdUg==
X-Gm-Message-State: AOAM532yJ+QxjUAl6QEkIpTXyk76z16Ep/eC/APtBA+uxSzjrt3omVQM
	dcrAQuZnvawfrM171bGTUnFTBtpLJv0bs9rC0ZY=
X-Google-Smtp-Source: ABdhPJweI4qeGM+e2zDq2SHC9xWM5C+tGpvQFN+igQT76ck/RAf7jjMcn/GQMDX+kf4UQlLCPrmaZJR673f61g+6O7E=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:a9d0:: with SMTP id
 c16mr5348289qvb.5.1606858669593; Tue, 01 Dec 2020 13:37:49 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:07 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 16/16] arm64: allow LTO to be selected
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

Allow CONFIG_LTO_CLANG to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c7f07978f5b6..9d29c48ecd4f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -73,6 +73,8 @@ config ARM64
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
+	select ARCH_SUPPORTS_LTO_CLANG
+	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.29.2.576.ga3fc446d84-goog

