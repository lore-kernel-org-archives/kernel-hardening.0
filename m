Return-Path: <SRS0=mBCK=AF=lists.openwall.com=kernel-hardening-return-19114-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A243C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5CC102080C
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ri578dhL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CC102080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19114-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30674 invoked by uid 550); 24 Jun 2020 20:33:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30583 invoked from network); 24 Jun 2020 20:33:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7CIu5VjUyqeUAWF5g9yThD8i7PrniBSkPgVIeHI/Dgw=;
        b=ri578dhLvQe03PuVkYI/KosO3BmuE994j1VVuunF6mqXcSxoUchnm+hnogX96YG7Yx
         yI/MHeu9q9kVZVlnIIydNSi+r5iCLXjTZcnO6Uxh+hmUL4ed/4KhiHZWp/xtvwTh9cIK
         SomuMXc3FlUpv/wxq+AMmks9S70kXGIVSq6hdIig9pY/BRVFkIkq59gCCp2yYhdgtpZ+
         TZxSgxiOsR9AcdF9rr0muiREjAZMfpam4EUBzlvonJ5mc1omg9Z9rzCkOz4lybvX42iW
         cfZVoIgjekwd1lX3DuJT3IjQ4IeC9YVCNgBTDnUF1CG7cfbw3hlLKLyVFbznVgBNgaOl
         aGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7CIu5VjUyqeUAWF5g9yThD8i7PrniBSkPgVIeHI/Dgw=;
        b=NuZ6AZWqyEhFk/fU5QzUbnEEyG8h0XlsOukAKTlTn5tOpwiwAD2xcREXTIaqNzi79H
         n7PYSvo3/O0VVo2r56hKGej8PSqjUsuKqbczGsdOn8c87IUhNOkiy2Vgkrfo5lcjXa6A
         Ck0IQFFA8YCMfTjJX9D4HcWEedDlo6C4GbJrtGiVyJ/RqfNHXSFeeuWdfH93aFKrp8B6
         ZoOaq6lNcIaXYArTNDGg0bzD7zrfZrVEHOK8/MwhScLflHMXhHM9h9cloBZ+QzeJVLcR
         HMx1l548C2Y7hnskH2xwXbW1ur0e9LkMQxHZPXgWDGSUtpXkbq3jWNkA9EcfuwnPBnrp
         WfFw==
X-Gm-Message-State: AOAM530/A9rfBDCZZywTSmx6XNKWCkbkNrg7DnUPy/lykp4PzqsaJCvI
	inDMGFKLcELMzZFVyJcWLtDP5+5vFVcYEzFiShY=
X-Google-Smtp-Source: ABdhPJwCkKca/LbhSSbnwwC5SMdz9q9IjLlaNhvBawmgAX2Ds09jajOGxxF388XJGbRiV3n2n5vnK/squwZiJ1CODnM=
X-Received: by 2002:ad4:47b2:: with SMTP id a18mr33619619qvz.121.1593030789019;
 Wed, 24 Jun 2020 13:33:09 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:44 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 06/22] kbuild: lto: limit inlining
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, George Burgess IV <gbiv@google.com>
Content-Type: text/plain; charset="UTF-8"

This change limits function inlining across translation unit
boundaries in order to reduce the binary size with LTO.

The -import-instr-limit flag defines a size limit, as the number
of LLVM IR instructions, for importing functions from other TUs.
The default value is 100, and decreasing it to 5 reduces the size
of a stripped arm64 defconfig vmlinux by 11%.

Suggested-by: George Burgess IV <gbiv@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 3a7e5e5c17b9..ee66513a5b66 100644
--- a/Makefile
+++ b/Makefile
@@ -894,6 +894,10 @@ else
 CC_FLAGS_LTO_CLANG := -flto
 endif
 CC_FLAGS_LTO_CLANG += -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+LD_FLAGS_LTO_CLANG := -mllvm -import-instr-limit=5
+KBUILD_LDFLAGS += $(LD_FLAGS_LTO_CLANG)
 endif
 
 ifdef CONFIG_LTO
-- 
2.27.0.212.ge8ba1cc988-goog

