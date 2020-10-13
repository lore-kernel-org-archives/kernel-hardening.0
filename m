Return-Path: <SRS0=B95Q=DU=lists.openwall.com=kernel-hardening-return-20176-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97111C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:32:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BDFE621655
	for <kernel-hardening@archiver.kernel.org>; Tue, 13 Oct 2020 00:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qUa1vHHc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDFE621655
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20176-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11480 invoked by uid 550); 13 Oct 2020 00:32:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11329 invoked from network); 13 Oct 2020 00:32:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kVJaNW7eSaj0HFfwrYDw0RQeIfteodxyLLwn3XkvFZA=;
        b=qUa1vHHcZgq+GOQlX2iLACARLoC/9h8vfuF9kwmVqVXA6Ay82zVe3uxoPk7oE9G3a5
         qspmhivovZKsl7zTe/TB3hhhY10WADRHi+k8hnkVHAdhubXLpnUEkMhxCS4DpvzY4fG5
         PHSzJ/adCJ3UEYsP53P7E1DazaOwM3ZH1sxI6dX+vcxypIOCYcQNAdiKAN+VBaDFVnEm
         8IPYRyR+hoO/wI0KaLDF4HCza/Ja8k6r7MrNh/bpFr8Hc/LwI0gzp5Wcj5mZmwtbzUgg
         SiAlpC4qMNr7O/bt2XOuW/rZtWiM/XRlM4/puqQkxdt2vQoQuYb0S+oJ1E4MnJy4FDei
         mUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kVJaNW7eSaj0HFfwrYDw0RQeIfteodxyLLwn3XkvFZA=;
        b=uLNFT908nHJ7+vJtAOruiA3ChfXkgYBCqmJOTmIVELAxomRpzBBBU6ftB2JdAPb+K2
         IxKHlt6eEEOFwsMa2D2IJTM4yZ9DZkxmgd+XaiZxB9lNLzrzrIorvQ8VS8nZswga87li
         CmPTUqLI9F2zuQlwpdojiD702ml11KvEr4oeHkovPvW0/YVu+h0opQJ51VSUaVbva7Vq
         bQ/siqi/ROJqhKRq8PvSLoMWjs+cWtbqpnBSvPpvtaRCvktod3n9NZ40Fzf5cmcCU6wx
         n3wMRj0DyfzGxsBhcPDo4t5ZY1mZOIKQ1p2resBlPZBiQmCKWJ68alyPwNVaSh82MbMe
         R6rw==
X-Gm-Message-State: AOAM532+svNFGPeF83pYIM8KURgA3ayQDBaJRiCWbrawkl7JPFT9mN//
	X9nF1RH/n5hfltzbYPbOIzP5USncKasMWfPgymM=
X-Google-Smtp-Source: ABdhPJxxVxVLXATH28VAjZYJvCMjRNOfP6FG+zwrqzoHwd+tVOzS3ssjn2tzJdDq4rR6gIG7Z06UGW92/5YWikencXY=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5843:: with SMTP id
 de3mr28374099qvb.12.1602549131356; Mon, 12 Oct 2020 17:32:11 -0700 (PDT)
Date: Mon, 12 Oct 2020 17:31:41 -0700
In-Reply-To: <20201013003203.4168817-1-samitolvanen@google.com>
Message-Id: <20201013003203.4168817-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v6 03/25] objtool: Don't autodetect vmlinux.o
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

With LTO, we run objtool on vmlinux.o, but don't want noinstr
validation. This change requires --vmlinux to be passed to objtool
explicitly.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/link-vmlinux.sh       | 2 +-
 tools/objtool/builtin-check.c | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

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
index e92e76f69176..facfc10bc5dc 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -41,7 +41,7 @@ const struct option check_options[] = {
 
 int cmd_check(int argc, const char **argv)
 {
-	const char *objname, *s;
+	const char *objname;
 	struct objtool_file *file;
 	int ret;
 
@@ -52,10 +52,6 @@ int cmd_check(int argc, const char **argv)
 
 	objname = argv[0];
 
-	s = strstr(objname, "vmlinux.o");
-	if (s && !s[9])
-		vmlinux = true;
-
 	file = objtool_open_read(objname);
 	if (!file)
 		return 1;
-- 
2.28.0.1011.ga647a8990f-goog

