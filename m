Return-Path: <SRS0=8o5+=FP=lists.openwall.com=kernel-hardening-return-20593-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C56C4167B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 42F0C23F37
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42F0C23F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20593-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9378 invoked by uid 550); 11 Dec 2020 18:47:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9287 invoked from network); 11 Dec 2020 18:47:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=sUICI29mkgxH8XDf6qhMCrhn46+Hzc1owynREvsajYA=;
        b=Mt5+qfjfZ+VylSyluHh2VZfop+oBL3rJXxZDwRaX22l0TfpVmfjZWdRRf4EjcTdwNZ
         tI2smkjeD1V9WDfLcVGcM0q3lBKc5wUlQ0PV2xNazny/qeDxBgjfBw3M6ZeazZiiVTRk
         PuilV1bsANPSfYl5rf4CFzgLv9TH7xZEN6ZdlxzmXfi8iZ0NN8yPkHKEhjrDZeO93M3Z
         Is2ezXs/oAG91woA/WjRTGjceaiPw8zQ6gbt9xphaeSWeIK5J0CKds3mJv3qxGB+SGOL
         yPRehVrtvjhUpPjpNJk+E+PHpWf8LAXA2fOr5tqj7a6NYji5/SC+3IO85wAjvRUlfz9n
         9oSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sUICI29mkgxH8XDf6qhMCrhn46+Hzc1owynREvsajYA=;
        b=Qoheqv8qnj1xltfDlSs4S4LH9t2SWtDhg5U8P2NvcEEFmY7T2q/hbbK+V5afSY00+n
         Ibc1Cj7Nomjn/irJbi91eZd5Jem3Fef8eVCMZCDRUQ86V6SgccwZsKfBrJNnkKRMVaJD
         6rrd0Sf6P+dvWC+6Utc8IeKCF6s3VZp3nis8kUE8juvQS07/YE0dwLirVZkKd1zNsDtj
         CnoOzXRMD0m4hBW9kgMOWwXjxpmvwdOD2nuyqAppp30aR/sNtdhSow226qwfPDB05838
         u+63e5ORtC9KDPUFISG8IFl2xVHNh/m7dEwuZ338T11x5ydqI1hgODXQCKKd8t6Yn8L+
         id6g==
X-Gm-Message-State: AOAM533QzARzd+FRJNHaSxYSUbzkNChfQF9Cr09769+r5U9FO/uCO+Fi
	u4v69F9XJDgbIRpx/ejE/QAw3jLSQypMFQ/DAHg=
X-Google-Smtp-Source: ABdhPJyLTnaXTvQFzdGZbemjJUsFLRdMqMxsuXqAqm5rCyQnrHrKDgTVs/Qim5syv8mGMDSyRXsRkeSRJzrM/1+uvUc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:902:8343:b029:da:cf6a:f65c with
 SMTP id z3-20020a1709028343b02900dacf6af65cmr12048006pln.5.1607712417071;
 Fri, 11 Dec 2020 10:46:57 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:28 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 11/16] scripts/mod: disable LTO for empty.c
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
2.29.2.576.ga3fc446d84-goog

