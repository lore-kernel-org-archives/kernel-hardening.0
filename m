Return-Path: <SRS0=UmLf=DG=lists.openwall.com=kernel-hardening-return-20051-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03056C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E7A032076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gdAEDDvL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7A032076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20051-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1453 invoked by uid 550); 29 Sep 2020 21:47:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1331 invoked from network); 29 Sep 2020 21:47:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=M/tCJ87SKQnbyhBQptnFDCNgoy9D1scy1+3ph9ahS3g=;
        b=gdAEDDvLlL0msAdcbIE0elhCADhQmKL9S16dzNU1NewfqdOooSY9iFqACy8+PZ7gHu
         RjJqXHtJjRJu9BoQC0Z+qcoslnaCbYOM5YVwAUiEbJv8oMPbNKei4NbKX8/eYf1TjsBX
         LuD//MCUmK3U7ZJ2uod6D1w8OHvoyhKJylEziLAmUyzobSpYb93PY4CL1x+jJuLiN+Df
         TJvELp9Gtnh21l2Y6CWFhRqKGqHS7xc78jprEFcrRoojdnbVtKont9eEkY55sgaj+pEf
         r+rlpDV8ZtQQ3iUVmb9timiu1KOz8XTe/0fr94WEPlFW4uof3ENuM7MDtO9p1BgJUAsl
         mKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M/tCJ87SKQnbyhBQptnFDCNgoy9D1scy1+3ph9ahS3g=;
        b=Y05ASAn/JY5wAAQlxJlDarVu1UcaNmgAxeZT6pbHEL0EG65/hJ/M2ZIA3AlPBJsmeQ
         4t2Qf7n4dyPNjQWLSDqaOzaTwdPNOO5BxbymXtDw4X+nEdurrbpFwKMmeDisMqdnyTny
         eQtNIbEgtgKdvkh5SZnu340mgCRbZzbscU3DLd7kmgc764jSpI6MPQPf3KXUQsiLA0FD
         KQRdJUdN9M6h1Otl4SB1CU41A1bhkhwffiwDyz6U19WfFFrn2ySMtEmd9+O2Y5XfqAB/
         Ay049Xi8BwdrfDjQrMnjknI/RWUEdQRMsEP5JBd7a4xviKYhvIcAn/lsIBPxKk3sHMtf
         Wu/A==
X-Gm-Message-State: AOAM532uYJLJpKpyW923v8R/XeozNyFGxNEPmGABaEaPmmA1zZ/uQPLZ
	d505sDMJPGWlVYzO//ko36WFKztdiWhdUgjl6Ls=
X-Google-Smtp-Source: ABdhPJwIclf1YZILYpRHL9aLGjIyClVObMTVmWZ7pfwr9sU8b01qvKeenw3eQ8lUfzBJlACcTh5VbLCas1CqVTaKm1c=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:58c7:: with SMTP id
 dh7mr6716936qvb.20.1601416041280; Tue, 29 Sep 2020 14:47:21 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:23 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 21/29] scripts/mod: disable LTO for empty.c
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
2.28.0.709.gb0816b6eb0-goog

