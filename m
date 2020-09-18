Return-Path: <SRS0=Vaw0=C3=lists.openwall.com=kernel-hardening-return-19937-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10164C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C16520684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m59NkH3j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C16520684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19937-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22250 invoked by uid 550); 18 Sep 2020 20:15:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22139 invoked from network); 18 Sep 2020 20:15:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6wkvNORTwM39S5uL0TTc53qeLnDmqjDSKMDvKwEqUnA=;
        b=m59NkH3jdBVGi3dXc89rIxXW0NE7GMfjZfL5ODM7hicbW9tRbSExno6sIVoWVPk/b2
         6ew8lrdf0hw7stNFVAv/okktVg/LjpO4I7jNzt6a8VoaOl/pRpNH1xks4v9BW7bxD/Sr
         i6vq8H7yjf2sd8Aini4O9MK38tgJzNMOIkbJl3sG/G/kVyi9tS3kdWyXupCYVuHY/tg6
         KLw2X/vONosgXWGz3RGoeu4MpReDPfkBwBqpqDUmYFeEC91faan+J54tUJcmpgPMtnOY
         BvbaH2KVwWvnm9Y2AQvGn+V2h5meg1oOgj2ERRg9cb5ebYhX4XX5VX8BZKgVsjjWQeQu
         IcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6wkvNORTwM39S5uL0TTc53qeLnDmqjDSKMDvKwEqUnA=;
        b=GKYsi9NCkJ2HG6+CBrMQJ64lurUaXirliAHzOHMOAC7ksA3hZgq8MRQhVrojAtkF7d
         uliBD1Fb0ik2ClfFJJyg862IQ+eTgz/wBuWN0Tzrap+KT4KuWOhoScMnwJ1xc/xq96Tj
         Jp6f/qOBTwZuroH/QaoasyBC8FFsNv3DAOVizyRSn5juaUu6cd4vCLc5S75N31uxpS3B
         LaeI8lsm3Xde12h0sLD5FEqNUgCfGI76rBD+8f2930Tqrc20PVcDguP3Pl/vx3arw2kM
         PlyGCgS1sbaEzQfMpFh53zR4ERRINCfiGa991PicdN0eyVijUZnGhO0D/Xx8lUIk3gKB
         yIuQ==
X-Gm-Message-State: AOAM530KJ2eU4PK3rgToRh9JTJbqgQIU395+6shLT41r92p7QV8fhddH
	dD8u3wacWT/DDjjO63i+VsXalvI3Qx65RkwvBSs=
X-Google-Smtp-Source: ABdhPJyhl0O3HrtpwK2+/eq92loT21+CwrJm1w5RAc9ZKC6o0au3sfzPs9arIL72JQf6OFaC7oO4rGV/iT2i5XrFZMM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:57cc:: with SMTP id
 y12mr19090228qvx.48.1600460129171; Fri, 18 Sep 2020 13:15:29 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:27 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-22-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 21/30] scripts/mod: disable LTO for empty.c
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
2.28.0.681.g6f77f65b4e-goog

