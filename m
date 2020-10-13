Return-Path: <SRS0=aVNJ=DU=lists.openwall.com=kernel-hardening-return-20178-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F113C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:33:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 40BB121655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iWb8IMXO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40BB121655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20178-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11877 invoked by uid 550); 13 Oct 2020 00:32:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11711 invoked from network); 13 Oct 2020 00:32:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=oNoCiComLTOHVg2bP6STufgWA9yaYfJ6ObCLDl+jrho=;
        b=iWb8IMXO138pO3VxQeiLtRHBFKLEZX34wfy/I5tnQOY8tAz+5KN10zF+c5wKc0NGf9
         V81W5t0kz8+T12z9fdWu+sNnGkAeOhHE8X9D+RroweYzMnASv3Hwpkndl/8bioQpHZUz
         mX+LtD994yaPGz2JhGYYCZ77UH77NBl51OSJVt2PNtGh/uJ/Id01J2GrYmku+3i3+EME
         0RSLPnMFIoJMJWfen1rEiGkUdPfD4MN+VkmyC3f7ZHxJqifMISzpW0Ypub7BPOfBxhkE
         v+NEFC6Ds2T1GWHGqFR6HDQWg9+W5tlsLsaS1VukIHrqKwvMN5C/M7+MuFGvKKyjBneT
         I2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oNoCiComLTOHVg2bP6STufgWA9yaYfJ6ObCLDl+jrho=;
        b=uky5cxuMACEkCW1KAaeCcZnVq8m4aFH1rUBYY3DbnjDW+lNIwi81ZFtte9ovqnd+Qu
         t3iQiehVwBphs0TKuPjeDeZaYKvoCPsfSaX3U99OJzLiXDVU27uaPH716CylEsN0K0R0
         tXz/A+8pJSUnGxUIcmtLMbUbiGs3rXullsdkf0g9r/MBEKF2FDu1x+4DhlRwykqscTQz
         xOPsmeg8maWpNJaGwCZB4O0lGueb+vksznsgxM0ZhfLbypRKH35zuAveOatwz9PfbcqZ
         nHzYLHlX31opG9j7sYy4cjbGRm6vPs2/0pvmZ1wbSpgJZFqlHSaPMf8qe6rfA/uI14zl
         uyNg==
X-Gm-Message-State: AOAM533obWiY6o4LdPAx58bv2OhjUp5cSFD2zteW9jdVRZVqMXyFEswk
	1giQZYi2aRBtp6XF5esVZfiRqh8m7GD74jWzlDs=
X-Google-Smtp-Source: ABdhPJwwb1BOagS9KB2HJy67TJEwj+dNfREWLJyGXBWcLbfd0WCh9RIc4B6fwHPAmc6V1LYLv5oY+bdj39+DqlbHxJM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:a4e1:: with SMTP id
 g88mr11556641ybi.267.1602549135037; Mon, 12 Oct 2020 17:32:15 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:43 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 05/25] tracing: add support for objtool mcount
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This change adds build support for using objtool to generate
__mcount_loc sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 Makefile               | 12 ++++++++++--
 kernel/trace/Kconfig   | 13 +++++++++++++
 scripts/Makefile.build |  3 +++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 129001b38357..fda1f8a0b1c7 100644
--- a/Makefile
+++ b/Makefile
@@ -850,6 +850,9 @@ ifdef CONFIG_FTRACE_MCOUNT_USE_CC
     endif
   endif
 endif
+ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
+  CC_FLAGS_USING	+= -DCC_USING_NOP_MCOUNT
+endif
 ifdef CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
   ifdef CONFIG_HAVE_C_RECORDMCOUNT
     BUILD_C_RECORDMCOUNT := y
@@ -1209,11 +1212,16 @@ uapi-asm-generic:
 PHONY += prepare-objtool prepare-resolve_btfids
 prepare-objtool: $(objtool_target)
 ifeq ($(SKIP_STACK_VALIDATION),1)
+objtool-lib-prompt := "please install libelf-dev, libelf-devel or elfutils-libelf-devel"
+ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
+	@echo "error: Cannot generate __mcount_loc for CONFIG_DYNAMIC_FTRACE=y, $(objtool-lib-prompt)" >&2
+	@false
+endif
 ifdef CONFIG_UNWINDER_ORC
-	@echo "error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
+	@echo "error: Cannot generate ORC metadata for CONFIG_UNWINDER_ORC=y, $(objtool-lib-prompt)" >&2
 	@false
 else
-	@echo "warning: Cannot use CONFIG_STACK_VALIDATION=y, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
+	@echo "warning: Cannot use CONFIG_STACK_VALIDATION=y, $(objtool-lib-prompt)" >&2
 endif
 endif
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 927ad004888a..89263210ab26 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -51,6 +51,11 @@ config HAVE_NOP_MCOUNT
 	help
 	  Arch supports the gcc options -pg with -mrecord-mcount and -nop-mcount
 
+config HAVE_OBJTOOL_MCOUNT
+	bool
+	help
+	  Arch supports objtool --mcount
+
 config HAVE_C_RECORDMCOUNT
 	bool
 	help
@@ -605,10 +610,18 @@ config FTRACE_MCOUNT_USE_CC
 	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
 	depends on FTRACE_MCOUNT_RECORD
 
+config FTRACE_MCOUNT_USE_OBJTOOL
+	def_bool y
+	depends on HAVE_OBJTOOL_MCOUNT
+	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
+	depends on !FTRACE_MCOUNT_USE_CC
+	depends on FTRACE_MCOUNT_RECORD
+
 config FTRACE_MCOUNT_USE_RECORDMCOUNT
 	def_bool y
 	depends on !FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
 	depends on !FTRACE_MCOUNT_USE_CC
+	depends on !FTRACE_MCOUNT_USE_OBJTOOL
 	depends on FTRACE_MCOUNT_RECORD
 
 config TRACING_MAP
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a4634aae1506..cd4294435fef 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -228,6 +228,9 @@ endif
 ifdef CONFIG_X86_SMAP
   objtool_args += --uaccess
 endif
+ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
+  objtool_args += --mcount
+endif
 
 # 'OBJECT_FILES_NON_STANDARD := y': skip objtool checking for a directory
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'y': skip objtool checking for a file
-- 
2.28.0.1011.ga647a8990f-goog

