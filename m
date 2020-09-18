Return-Path: <SRS0=EDh3=C3=lists.openwall.com=kernel-hardening-return-19930-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6C6C43466
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:17:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C7D620684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pyxY37Ar"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C7D620684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19930-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19476 invoked by uid 550); 18 Sep 2020 20:15:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18354 invoked from network); 18 Sep 2020 20:15:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AuswF6CKDN8dO1xH74r4m5G29uexAro1Nb2/kCMl6ng=;
        b=pyxY37ArYBcWk0pTveeYem7o3r7m0QxYR7o9ddMazv3C4wUXpf2wO5JjRX0hn4D99a
         ZfGgMQ7Y6Q0IcMD2Az+PMWVEf1UQD0bMp5UvODjcuy5A+HFY6tfMzIjH2TOqDSGxfrkm
         bzhUpRLa1APdzJJuc3rFYJAUGU6Q8y3Q93uvmCIMm/1oh0Z+W85oIwCWP5Q55yaYOmbE
         gk8wLX192p13Gd0rr4JArg+R3FEIeSJsV0U3a+yj521FBPN70Pf7378jB++mxf7g6bky
         21wEGkI2GQeXxYFaCDkQXFqja2UN6FX7KM68hCqpPYC8vhf6aqeVZ+IoZbZQITt213Zj
         ebpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AuswF6CKDN8dO1xH74r4m5G29uexAro1Nb2/kCMl6ng=;
        b=O1omMV4vvCJMcJOJ0tSGgM9wxbCSfbJ4T28m2373wqn15DcYurhH8w50vrGbE94s7s
         t8Z1OBIUdbHjrJ+LztfJOb7wMd2iBh/LVjzMQQnqZGj8cStY8EtHBJ/AHB42iVEhfEl5
         012efuqoyTnbTdvW6bZVucei3ODRhRyiU71r552sAI7GtLCPUvEf0Ml6ReXl93ZJWU/d
         F0bnP6EPg5t2PZgC5fP76YzFDnJwUyoV0ZlPCFLQhM42y197p3fbEe8lu5/9wrpYtAoW
         x/mCeKlRjHFYqdknHx3NIZLNn/KW/tthm0fGXLJDo0LrsjCmRf3gh7oAR2kkqP2A4qJY
         CyZA==
X-Gm-Message-State: AOAM532FwpmZ3wP2oX/RTFZgb899fDixsp9rDDWSrilYUgQx0ipU+Mmd
	FS+T/DbKe1Ekd0cS6Ji8gHgeqJi4rmWtjOD+d5I=
X-Google-Smtp-Source: ABdhPJxzZeQUOl2JhbPGv5v7ZLZFcYcdjlAn8PduxMhR73rTNKLtzUhom6BcaktSr/Lr+jGrmaYuXtBeO2vdou5k7ZQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:902:d70e:b029:d1:e626:d12f with
 SMTP id w14-20020a170902d70eb02900d1e626d12fmr17241070ply.74.1600460111357;
 Fri, 18 Sep 2020 13:15:11 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:20 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 14/30] kbuild: lto: limit inlining
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

This change limits function inlining across translation unit boundaries
in order to reduce the binary size with LTO. The -import-instr-limit
flag defines a size limit, as the number of LLVM IR instructions, for
importing functions from other TUs, defaulting to 100.

Based on testing with arm64 defconfig, we found that a limit of 5 is a
reasonable compromise between performance and binary size, reducing the
size of a stripped vmlinux by 11%.

Suggested-by: George Burgess IV <gbiv@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 629d4b18e413..973155c24711 100644
--- a/Makefile
+++ b/Makefile
@@ -912,6 +912,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.28.0.681.g6f77f65b4e-goog

