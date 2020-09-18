Return-Path: <SRS0=ILR+=C3=lists.openwall.com=kernel-hardening-return-19922-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D56C43466
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:15:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DA08F23718
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vLxQSiTd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA08F23718
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19922-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15496 invoked by uid 550); 18 Sep 2020 20:15:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15367 invoked from network); 18 Sep 2020 20:15:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=SmkRBXA7nybVMgRFHrOcpVUvMfefLOj3bIKZYl6feRQ=;
        b=vLxQSiTdO6kx7x/Kg/wNk4XkNMo14CL+DN6ttIvF2JonRyj1oK9XqFWKvvfgZK4Mmh
         HN+/aMca8Jx8U+3rMZJB+YDPmWFRPK12zeQKwH+WGQeH/c24C/e6itsBsxAeiS+l+vnI
         kvttaEcXAfrUxun0RBcRM5rVl4lLPcUMETTEDtPRsb8ebkJAInD9/COrBs8wZvoDPEh2
         GhGMctwfhnFVytooium0mYCB4O3YSpfb1rIx8elZ0BLfobR4pKcG7h4BhPaZOJp4kRFJ
         lHn12+OcXav8iIixDR/qz7cHvzsM29SRysxUKhyIItLmT8nW1nDSJozvxnVmac7/8ZaS
         rmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SmkRBXA7nybVMgRFHrOcpVUvMfefLOj3bIKZYl6feRQ=;
        b=AJxi80nAXmvJIX4iJMF8ZkbXw/Hjy2w4kbcLGptkKsDl1Scvg33yhc04GkMf9stQgn
         tERLM2mLQSxVZYvcNV6m7ZzYgltkB6ih3eDTt+BwRb9yJJOlHLn0UTz/YfTo3OXrKl1b
         kWiZ7FIW43DpcbIxCm8hZoswNZ/r7Z9c20SK+8ObnW0JjPaTK3B/tdlC8CFxMWRff8T5
         QbxVFzORNNNx8hdGhe+wTG33X3yT9lpZpakfQF/2hDMkbQOj5WWvdcUIFFrDW96omrvh
         p+MDC+G+XFXgAzDK52Ez6CqgV0Bp+uGoWLM/u7vvQf3wh+0GUYrepkA0DD5sMnl65nGk
         Frfg==
X-Gm-Message-State: AOAM532PfBIotq7Vq4h0RK924Fi/Lw7fr82hTPl9nJt8lKk0FMKUO9S+
	GKcmEVrtt/h1+BInr66Xc0S/Xjw3ZRj4cRL5qko=
X-Google-Smtp-Source: ABdhPJxfxPARsXBGl9SON0cI+m+7JzZPmj/JlXCHFsIm1Q/huE0VddyqnW5/FMDpRgWVWHnqCpuDeLjffHea689ZMyc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:bfcf:: with SMTP id
 q15mr21002279ybm.133.1600460092312; Fri, 18 Sep 2020 13:14:52 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:12 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 06/30] objtool: Add a pass for generating __mcount_loc
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Zijlstra <peterz@infradead.org>

Add the --mcount option for generating __mcount_loc sections
needed for dynamic ftrace. Using this pass requires the kernel to
be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
in Makefile.

Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[Sami: rebased to mainline, dropped config changes, fixed to actually use
       --mcount, and wrote a commit message.]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 tools/objtool/builtin-check.c |  3 +-
 tools/objtool/builtin.h       |  2 +-
 tools/objtool/check.c         | 83 +++++++++++++++++++++++++++++++++++
 tools/objtool/check.h         |  1 +
 tools/objtool/objtool.h       |  1 +
 5 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 7a44174967b5..71595cf4946d 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -18,7 +18,7 @@
 #include "builtin.h"
 #include "objtool.h"
 
-bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux;
+bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -35,6 +35,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('s', "stats", &stats, "print statistics"),
 	OPT_BOOLEAN('d', "duplicate", &validate_dup, "duplicate validation for vmlinux.o"),
 	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
+	OPT_BOOLEAN('M', "mcount", &mcount, "generate __mcount_loc"),
 	OPT_END(),
 };
 
diff --git a/tools/objtool/builtin.h b/tools/objtool/builtin.h
index 85c979caa367..94565a72b701 100644
--- a/tools/objtool/builtin.h
+++ b/tools/objtool/builtin.h
@@ -8,7 +8,7 @@
 #include <subcmd/parse-options.h>
 
 extern const struct option check_options[];
-extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux;
+extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
 
 extern int cmd_check(int argc, const char **argv);
 extern int cmd_orc(int argc, const char **argv);
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e034a8f24f46..6e0b478dc065 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -433,6 +433,65 @@ static int add_dead_ends(struct objtool_file *file)
 	return 0;
 }
 
+static int create_mcount_loc_sections(struct objtool_file *file)
+{
+	struct section *sec, *reloc_sec;
+	struct reloc *reloc;
+	unsigned long *loc;
+	struct instruction *insn;
+	int idx;
+
+	sec = find_section_by_name(file->elf, "__mcount_loc");
+	if (sec) {
+		INIT_LIST_HEAD(&file->mcount_loc_list);
+		WARN("file already has __mcount_loc section, skipping");
+		return 0;
+	}
+
+	if (list_empty(&file->mcount_loc_list))
+		return 0;
+
+	idx = 0;
+	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node)
+		idx++;
+
+	sec = elf_create_section(file->elf, "__mcount_loc", sizeof(unsigned long), idx);
+	if (!sec)
+		return -1;
+
+	reloc_sec = elf_create_reloc_section(file->elf, sec, SHT_RELA);
+	if (!reloc_sec)
+		return -1;
+
+	idx = 0;
+	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node) {
+
+		loc = (unsigned long *)sec->data->d_buf + idx;
+		memset(loc, 0, sizeof(unsigned long));
+
+		reloc = malloc(sizeof(*reloc));
+		if (!reloc) {
+			perror("malloc");
+			return -1;
+		}
+		memset(reloc, 0, sizeof(*reloc));
+
+		reloc->sym = insn->sec->sym;
+		reloc->addend = insn->offset;
+		reloc->type = R_X86_64_64;
+		reloc->offset = idx * sizeof(unsigned long);
+		reloc->sec = reloc_sec;
+		elf_add_reloc(file->elf, reloc);
+
+		idx++;
+	}
+
+	if (elf_rebuild_reloc_section(file->elf, reloc_sec))
+		return -1;
+
+	return 0;
+}
+
 /*
  * Warnings shouldn't be reported for ignored functions.
  */
@@ -784,6 +843,22 @@ static int add_call_destinations(struct objtool_file *file)
 			insn->type = INSN_NOP;
 		}
 
+		if (mcount && !strcmp(insn->call_dest->name, "__fentry__")) {
+			if (reloc) {
+				reloc->type = R_NONE;
+				elf_write_reloc(file->elf, reloc);
+			}
+
+			elf_write_insn(file->elf, insn->sec,
+				       insn->offset, insn->len,
+				       arch_nop_insn(insn->len));
+
+			insn->type = INSN_NOP;
+
+			list_add_tail(&insn->mcount_loc_node,
+				      &file->mcount_loc_list);
+		}
+
 		/*
 		 * Whatever stack impact regular CALLs have, should be undone
 		 * by the RETURN of the called function.
@@ -2791,6 +2866,7 @@ int check(const char *_objname, bool orc)
 
 	INIT_LIST_HEAD(&file.insn_list);
 	hash_init(file.insn_hash);
+	INIT_LIST_HEAD(&file.mcount_loc_list);
 	file.c_file = !vmlinux && find_section_by_name(file.elf, ".comment");
 	file.ignore_unreachables = no_unreachable;
 	file.hints = false;
@@ -2838,6 +2914,13 @@ int check(const char *_objname, bool orc)
 		warnings += ret;
 	}
 
+	if (mcount) {
+		ret = create_mcount_loc_sections(&file);
+		if (ret < 0)
+			goto out;
+		warnings += ret;
+	}
+
 	if (orc) {
 		ret = create_orc(&file);
 		if (ret < 0)
diff --git a/tools/objtool/check.h b/tools/objtool/check.h
index 061aa96e15d3..b62afd3d970b 100644
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -22,6 +22,7 @@ struct insn_state {
 struct instruction {
 	struct list_head list;
 	struct hlist_node hash;
+	struct list_head mcount_loc_node;
 	struct section *sec;
 	unsigned long offset;
 	unsigned int len;
diff --git a/tools/objtool/objtool.h b/tools/objtool/objtool.h
index 528028a66816..427806079540 100644
--- a/tools/objtool/objtool.h
+++ b/tools/objtool/objtool.h
@@ -16,6 +16,7 @@ struct objtool_file {
 	struct elf *elf;
 	struct list_head insn_list;
 	DECLARE_HASHTABLE(insn_hash, 20);
+	struct list_head mcount_loc_list;
 	bool ignore_unreachables, c_file, hints, rodata;
 };
 
-- 
2.28.0.681.g6f77f65b4e-goog

