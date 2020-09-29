Return-Path: <SRS0=o0mM=DG=lists.openwall.com=kernel-hardening-return-20035-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCE6C47423
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:47:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 72A7720774
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:47:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IBbDoPst"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72A7720774
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20035-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26463 invoked by uid 550); 29 Sep 2020 21:46:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26337 invoked from network); 29 Sep 2020 21:46:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=l2+v7INMYKuznv8xFN02uATUaYPeLt4QVP2a2KYnEdY=;
        b=IBbDoPstUx6PvkrgRiZ41KzIphJCRrEzSeZx7R3BsJc/c2FU1xsagudvCmxJS0b8z2
         SjjbJNbVgzgrgsE4IMeYQoBOkgyNAJsokXmK8DUkwveVuIMwv2vc9kL6j11caQYcNzUq
         0vjsIxHqB8pCA2/K+LOJlqU0rm+b0gi9ZppmGex0Nq6vg3lFfAKr6863jjw2KdNrpjQl
         OE30bcUDioAlTaHnVtbs0RImv7YEk6Zl2qjv9SZgAykRMeNQidEDWQq/427XH29WRmMR
         YCgaWWx4UZCNDu0gcLoZMQgMMVDTjQx98O5L72qcpTB4n7pw1Wyy4oYvBIPd3DNE23kA
         MbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l2+v7INMYKuznv8xFN02uATUaYPeLt4QVP2a2KYnEdY=;
        b=bMcfk18jK8UncZ36buS1yJfUCNxD84gKaTLQkzsWHFQMiBZpjt47xiSmZSbRIh+qnZ
         pxODQuiR5nSAIu8/lXNFn/9Gvh3jKWWicbkG2tHsarRIupxaUW4/0KlngJVOxLRm/BWh
         e8mLTgyEI9WdZZOcGYlVz/YEAvd4oMsXV/pj03Jn0XeH5p6TBwvKBFwVv99r4aiQoQ9X
         fp5y4IFCMet98HGAN+AX/npE3ab6divXRKaBEbV0L3ELEzx6AoqKyueziSi76wREmBH/
         RE64B8VEyP2alQMLqhYCXoykHm0icNSDCzeOHQxYTkg1XXnxbQzV8bij5NF5xGWT8lVJ
         jr6w==
X-Gm-Message-State: AOAM532VUgp3PuIdVGG/4IYxx5heFtmN1ANZA9ByQs22xcNxTcFQk1oT
	qj9bLmp3Z16xttmcGCtIfr3sfjZb6koyJh6t+hc=
X-Google-Smtp-Source: ABdhPJy+h62MhF4FERE0IvCpSLKvcavDzP6aQkays6EhouTsZ6bz+Ey8zRCePHhbZ++PNw0vWZnJFjS/bZTiM4aTEAM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:1767:: with SMTP id
 et7mr6378060qvb.43.1601416002753; Tue, 29 Sep 2020 14:46:42 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:07 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 05/29] objtool: Don't autodetect vmlinux.o
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

With LTO, we run objtool on vmlinux.o, but don't want noinstr
validation. This change requires --vmlinux to be passed to objtool
explicitly.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/link-vmlinux.sh       |  2 +-
 tools/objtool/builtin-check.c | 10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e6e2d9e5ff48..372c3719f94c 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -64,7 +64,7 @@ objtool_link()
 	local objtoolopt;
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
-		objtoolopt="check"
+		objtoolopt="check --vmlinux"
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 71595cf4946d..eaa06eb18690 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -41,18 +41,10 @@ const struct option check_options[] = {
 
 int cmd_check(int argc, const char **argv)
 {
-	const char *objname, *s;
-
 	argc = parse_options(argc, argv, check_options, check_usage, 0);
 
 	if (argc != 1)
 		usage_with_options(check_usage, check_options);
 
-	objname = argv[0];
-
-	s = strstr(objname, "vmlinux.o");
-	if (s && !s[9])
-		vmlinux = true;
-
-	return check(objname, false);
+	return check(argv[0], false);
 }
-- 
2.28.0.709.gb0816b6eb0-goog

