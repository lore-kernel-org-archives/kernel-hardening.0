Return-Path: <SRS0=0xEZ=AF=lists.openwall.com=kernel-hardening-return-19121-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98F6C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E940206C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hwKULFJx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E940206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19121-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1273 invoked by uid 550); 24 Jun 2020 20:33:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1168 invoked from network); 24 Jun 2020 20:33:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AKMu7RfRr5zvA7HsB83o+xQyox7udGa4dX0knD98vpQ=;
        b=hwKULFJxGC6lzKBnQLuceB0YfBkygKMN1Y7kZQBIXHCsEuVKl7k53XBbhlEet2kuY6
         c5h57Jm4RTz3npco+GM34bS8OimyDEzCAs5RtXK9amKrkhc3iWeXVSSos5q0no8zlKoC
         g7pLlix/dBDvLN2ZPktXFsba5h3mffSKhoE5+GmDS8Vr6JOxA4ewukdjiiGEPv8wdNVT
         NFihuGuX3xW6/cOtws4+jn8A9DLBsarXxdSvLrg+AB01n3pWOgDMboQG92CgRsUahvu2
         9lqJTUHzdlliTFgZhjxMp/9FS3YVs31mDAc+87qMDsCYIvXwnXEZPUfskY1g7XwXJnjL
         oU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AKMu7RfRr5zvA7HsB83o+xQyox7udGa4dX0knD98vpQ=;
        b=ZCi7qasn1tLiMW2/4Iv5IY0yw+qiZImPcoH/JOONqyBu9TF7T0Vr8PkFzM7W4ASdrU
         SjS89NCmLN3qbay6zi9m6ifOgaGiXQ86IF2y9aNkXra1oAUGvHUwnyZACOsWgAGy8Ygd
         /ky2QIStxXyV1GPmHNLUTKJY1Pvq66j7OqQX25NfO+1vXRE7SFTiqfBjncbyRPpP/guP
         K4PiVbtfHCvdhzAkQpsk1IXuqkXNM6vL4MyBMFpsWDpLF/JT1S0fuwY3OoNQ5dBOTsRI
         UkSIRA9LYqraJMbW79ETl92f69AeQ8UJ2GwDGKHU+kCaZbwW59Tu8YBf90Bfm2HZrxUp
         h0Hg==
X-Gm-Message-State: AOAM533uhJ88CCJpQ/nHDcbYwZx4+8o3WR6SRFPMXcDuB1j5zzxtiTz8
	ZKFHqLJxudRx2cn9Q/UOY/+ciUE2RVvwo28m2HE=
X-Google-Smtp-Source: ABdhPJwsJ60waNyWplHPwTwdw+lH2n4awv5MY2TpgjYhyfFuYQs+mtvKBzjvblN4Mn7p7o+48GiQMs2cNGX9hzUSV7k=
X-Received: by 2002:a25:dcb:: with SMTP id 194mr50401188ybn.226.1593030801479;
 Wed, 24 Jun 2020 13:33:21 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:51 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 13/22] scripts/mod: disable LTO for empty.c
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

With CONFIG_LTO_CLANG, clang generates LLVM IR instead of ELF object
files. As empty.o is used for probing target properties, disable LTO
for it to produce an object file instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/mod/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 296b6a3878b2..b6e3b40c6eeb 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 OBJECT_FILES_NON_STANDARD := y
+CFLAGS_REMOVE_empty.o += $(CC_FLAGS_LTO)
 
 hostprogs	:= modpost mk_elfconfig
 always-y	:= $(hostprogs) empty.o
-- 
2.27.0.212.ge8ba1cc988-goog

