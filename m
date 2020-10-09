Return-Path: <SRS0=Nl+2=DQ=lists.openwall.com=kernel-hardening-return-20150-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A28C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:17:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D57F2222F
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T3uphKT5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D57F2222F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20150-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7559 invoked by uid 550); 9 Oct 2020 16:14:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7463 invoked from network); 9 Oct 2020 16:14:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KGusc3+RBCNZzwrkW+3708RrOouUa5FTnw8PnBTY3Ig=;
        b=T3uphKT5yiHzmre9bkTK6EvjVmGfnhT7ZFFnV4sLcrb7aMVmDOpxZyPoKPeEcaNKtw
         bLwWcg0u4RVu56DBE1l/EFAJo/HHanmlaklCdVV/xwdWBpRNFhzn+X3/LxWAUfbhp/U/
         GNlO7yw6b8BkEnALpByL0X9MzDTLW7NBXjJemt4oO0kn7GZ7tQAc2izO8jd84Mn+pfZ9
         Q8VycjN+4DsNFujjU1a5crzy/UM0hIFVYyz+EvyZkDNQQ+Ssi6Zd8LRvcNgb7ixFU1dN
         ctSt5By/Q4V+U/wi5Rp7dpEjeliEfwZMggEzSUoN5urCLveVN2ERv75kNnLo9GLtwhM6
         5wTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KGusc3+RBCNZzwrkW+3708RrOouUa5FTnw8PnBTY3Ig=;
        b=CZXrujIMKr/sttl2cxIGFJ10zx/F8FfU59Ln0JnhVgGJ6JwFAMtbnIS3EJymPqrYpf
         XCLk2hy6FZmy0vk9pSPREJhNHW0AuyRw4yG1rtMUSaKvJfllHDCfnug1RDqFhb2xK+uP
         vbUOvCB2Ah9lOrW9XP++LtNgUdKM9ltFThM5R350J6JDjnQRhTIdi+NHEaalbLuF/s1+
         HCYfdbacKbXk3C76K4QvD50Xy07z8xgOyYw15Ng370433q4zyO8E2Tp01+d1G7Dhm04f
         vrcXu97unMwgqi5h1upeTgelhPPsUDOMqHMIfW9dAwPLkGamS4EY7Wlw02Rbo6ESqHQY
         zwUg==
X-Gm-Message-State: AOAM532xdZn9g6ZVaMMZRCDyUdCLbOuVv2OhlJnNsffATadu2+DvoNKI
	8RDx2VHEKagJXTaMCfIb2YycYbTCLJOphs9oPuU=
X-Google-Smtp-Source: ABdhPJyXF5PEn5u0UASyOtBGN61NWqU4GwvxlOzGlhXJZtvZt0XNABboerQ6XEYrKTpOJFOpPCSvjnoA42FIJ7VzrPg=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:cd05:: with SMTP id
 d5mr18037401ybf.212.1602260058814; Fri, 09 Oct 2020 09:14:18 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:28 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-20-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 19/29] scripts/mod: disable LTO for empty.c
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

With CONFIG_LTO_CLANG, clang generates LLVM IR instead of ELF object
files. As empty.o is used for probing target properties, disable LTO
for it to produce an object file instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/mod/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 78071681d924..c9e38ad937fd 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 OBJECT_FILES_NON_STANDARD := y
+CFLAGS_REMOVE_empty.o += $(CC_FLAGS_LTO)
 
 hostprogs-always-y	+= modpost mk_elfconfig
 always-y		+= empty.o
-- 
2.28.0.1011.ga647a8990f-goog

