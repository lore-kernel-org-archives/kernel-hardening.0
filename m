Return-Path: <SRS0=rN0q=DU=lists.openwall.com=kernel-hardening-return-20183-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EE7C433E7
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:33:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4CF01206B5
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJ5mCWL1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CF01206B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20183-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14044 invoked by uid 550); 13 Oct 2020 00:32:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13909 invoked from network); 13 Oct 2020 00:32:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=8bp3PQ/7kK50N/SyZEDvRd1Vp9NoLqhW+sLCA5D6N8E=;
        b=UJ5mCWL1fFmQ+PxULb9p87s0nqFxM+BepZ4cTj/3K/9Rl3+R69U63Qoo7kbjpQJmLF
         fe6htCxpHb5pvdMiMW7w4jfVTIc0MjpjYYrgO7qtJrxEcZluiiuQ4CilOc6suei2x16J
         ZyAV+xCVkwBYu4Ypv3PNkoRqnUEeD3oVuV25mZ/ZMBu+EeLJ8WEFNae5g2/awFDSCZgp
         hbWfhNOdCEgE4Orq6FyUsLEX8fGkRh/PRZNh5ngDsRLmToIgltIDpU1+UVeeaBKUU/SH
         2G0ccI3U01Zj6y5PdlF4BC4DIc7g6ih08EXhvn4pV3U8TiwtHluquziLm/T5nfcBgQ/A
         E3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8bp3PQ/7kK50N/SyZEDvRd1Vp9NoLqhW+sLCA5D6N8E=;
        b=AD0sG9Mhv8+Es5Q299ummiPP+GW0V670H0er4AncpDhqUa0awPQdtmhf6WeKxewHaM
         A885236F87DXAF6ALsoITfrpbyLBXWZFNWiN7R1XgbXo8TcLKo6YjdzhrOqw97mN6SfH
         tad8aqOgJBH5j5bliY+r5doInH2xXixa0y/CfdM8BDWz/bkzLzuiwzk5sbP+pxkYbLPa
         EE7aRxUa+cYGBMTQlvYr0Tl8xN5qU5MBxzkWAO05iYJhZpmkAvbZstAn3UZDaF/fLZKu
         K0bWhwMwQWmq6PDl5SCm7a8B7JQwnkPcAFcsAd5qzcDNv2olddL+W0Rh0Q4O4Ad1YczB
         ylKg==
X-Gm-Message-State: AOAM533io2wn12RuAw1NlzCffHkuury/Z8Wa0ml9v69cKV3bxvFW+qYK
	+PM75e2nAcjSNO/EzyElad4X5bNuxfO5zQCTL98=
X-Google-Smtp-Source: ABdhPJyaKJlnl73Nam7qP2rlTKBQqyq7hNelqtAXX2QbINkl92Xg8gdjjbAPMWIDS85cwQxWAerS5XsHH4+zdwdv4nw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:5f4f:: with SMTP id
 h15mr34686955ybm.407.1602549145672; Mon, 12 Oct 2020 17:32:25 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:48 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 10/25] objtool: Split noinstr validation from --vmlinux
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

This change adds a --noinstr flag to objtool to allow us to specify
that we're processing vmlinux.o without also enabling noinstr
validation. This is needed to avoid false positives with LTO when we
run objtool on vmlinux.o without CONFIG_DEBUG_ENTRY.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/link-vmlinux.sh       | 2 +-
 tools/objtool/builtin-check.c | 3 ++-
 tools/objtool/builtin.h       | 2 +-
 tools/objtool/check.c         | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 1a48ef525f46..5ace1dc43993 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -92,7 +92,7 @@ objtool_link()
 	local objtoolopt;
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
-		objtoolopt="check --vmlinux"
+		objtoolopt="check --vmlinux --noinstr"
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index facfc10bc5dc..b84cdc72b51f 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -18,7 +18,7 @@
 #include "builtin.h"
 #include "objtool.h"
 
-bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
+bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount, noinstr;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -34,6 +34,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('a', "uaccess", &uaccess, "enable uaccess checking"),
 	OPT_BOOLEAN('s', "stats", &stats, "print statistics"),
 	OPT_BOOLEAN('d', "duplicate", &validate_dup, "duplicate validation for vmlinux.o"),
+	OPT_BOOLEAN('n', "noinstr", &noinstr, "noinstr validation for vmlinux.o"),
 	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
 	OPT_BOOLEAN('M', "mcount", &mcount, "generate __mcount_loc"),
 	OPT_END(),
diff --git a/tools/objtool/builtin.h b/tools/objtool/builtin.h
index 94565a72b701..2502bb27de17 100644
--- a/tools/objtool/builtin.h
+++ b/tools/objtool/builtin.h
@@ -8,7 +8,7 @@
 #include <subcmd/parse-options.h>
 
 extern const struct option check_options[];
-extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
+extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount, noinstr;
 
 extern int cmd_check(int argc, const char **argv);
 extern int cmd_orc(int argc, const char **argv);
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c39c4d2b432a..c216dd4d662c 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -244,7 +244,7 @@ static void init_insn_state(struct insn_state *state, struct section *sec)
 	 * not correctly determine insn->call_dest->sec (external symbols do
 	 * not have a section).
 	 */
-	if (vmlinux && sec)
+	if (vmlinux && noinstr && sec)
 		state->noinstr = sec->noinstr;
 }
 
-- 
2.28.0.1011.ga647a8990f-goog

