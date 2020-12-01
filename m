Return-Path: <SRS0=9bDq=FF=lists.openwall.com=kernel-hardening-return-20499-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C505C64E7B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9ED7B2085B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 21:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oZ+MM9v/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ED7B2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20499-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18342 invoked by uid 550); 1 Dec 2020 21:37:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18234 invoked from network); 1 Dec 2020 21:37:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=sUICI29mkgxH8XDf6qhMCrhn46+Hzc1owynREvsajYA=;
        b=oZ+MM9v/NqF/Ggik7eWdIKvvWz1hAClVJ55m2ya/8pnBTT4o/65pegfy91/nHJxuWW
         ng2vF4fEe4Kj1Wfo4enCljLrXc2mZuGKhe/N5E7LtdgFcAC58htdoc+UkHFNsGz4aAO6
         TYAhpoNLG2sGulec3iEXV0wmrbA+e+YsFU8sNFgOxk4nqaFp778EB7curP1ohGdIJjsj
         jH7zCxSQUvDQVtB7+IQqbxbFDnA6gYb/Jb2c4ZAC83nAvZnZSoqo2Wh/6Eso5Pv41c0O
         eamKVAZq1cPjmGaxAjBPryDgnplTnhHhjw0xN8W2cnY2EG+4MSMt3K5GchHtvIv5V7pm
         oWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sUICI29mkgxH8XDf6qhMCrhn46+Hzc1owynREvsajYA=;
        b=L4QZrSsqkaUNlJK4NtvYGZZ9WVD4txChIRDUin6cCoDwA4RNuTnhhDoEp6r9OWJmbG
         7KQ4/obVvnoKPJwohW0HvfMKMnxgDAX//MOiYFtPXrfwJ0JEAyZQjCU5JWQ5iUd9nxtB
         UFILP014dkRL/fw3jo9Gd8RfncTNHZq0A77Y8FGxippuytMx5aU/OjzwqVxfCHaDx/LP
         vEPGucHxkGSUGuG3pinnbAC7JAPy/BlwJ7S15laVF0qQXpCVCwlixdXeOI6hy24g3tZ8
         fiv/6TGnK7246ek8GpMK6z4nKQ5Nbh7UQBIzR9ED+SFPHSLS4aPLvMfO2MCWMzhZaJv1
         Zs+w==
X-Gm-Message-State: AOAM530ZQYOP0oIf3HxscsNqM1e0Xp+zwA66hB8xgm8bdlhqpx/vKuqz
	rBLSc0mIHWMzxcdnxWXrcIfLEhWrGGlnD2C/0XM=
X-Google-Smtp-Source: ABdhPJz1Mu2iPraONhTPw2Ye1e/CkH6U6l9Tg0xaIlFIbJtK0qFhhhtu0340/zvjR8Y2IkVG3dJHFOz9M5J3EVMgNhI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:38c1:: with SMTP id
 f184mr5273120yba.41.1606858657749; Tue, 01 Dec 2020 13:37:37 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:02 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 11/16] scripts/mod: disable LTO for empty.c
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

