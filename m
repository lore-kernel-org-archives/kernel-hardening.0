Return-Path: <SRS0=ZgRL=C3=lists.openwall.com=kernel-hardening-return-19939-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877B4C43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B526620684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYDR5W+p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B526620684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19939-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23750 invoked by uid 550); 18 Sep 2020 20:15:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23662 invoked from network); 18 Sep 2020 20:15:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Aq4KaYtXPvsIFu2w9Cb9+vNMYXxmfrCDkI2ZzAJ/U8w=;
        b=YYDR5W+pWvCCMlsLuxLz2kP7xV+uq2FmsovV4iGNvno67WC358C4PSNmTbdGHW6cZy
         Xr2bfek6oOyIlLCqqcmz58AwsnwR59RRO+p9vcpDdt33YhN8IrJ/O6OhGAnZkSzVXUBi
         juaZEaotR1IoDS52HcVfmR1tV9lf6hMZtKDYu+gLSSBc5p2YM9N18q2UMIgXTdzr3uIq
         Fm8Rp3KBn78V9C/U0MxUKT6AZU9wjegUqE9FD6bezlPI8xyTBnsPinaduX3IiPx/NQx9
         CiLebwGjfIl4ZFQ0mM3lJvlbPYemZFWx56rfr5kUCzWThPFDwAshAHrFrPtMZk+I/w6c
         LAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Aq4KaYtXPvsIFu2w9Cb9+vNMYXxmfrCDkI2ZzAJ/U8w=;
        b=iYVXfhwRmoUg3AD8S+qeUmhmgFcB123HuQxeydH/aw1CJ6cvmI8wDUyz/7f4VjcSy1
         sfYZ3a7Cj96iZNkdcGDJSHaoLsBom28JaN+aldI7/NRGIQqpQ6bDSZOqSxSPLfUdUGHC
         5u2Y2lKnYu0jUSARDzjUCbRkEEhWjfFDLgJghVGhoG/yHx+WKUO9BblwmfPlOW+0Df+2
         LVE0+z+JLS+a6awWEgWiTjC/P5vgYHnysCwpxL/oxI7H6jRCMkzZNjhrajmxt5UsJfNX
         RHBa93gn1Ljp0MSbRDUqjxxGup2iUFVMtXJ6UMEtmzg+iOBJxTNmmto2w117tAWHpywa
         MA7w==
X-Gm-Message-State: AOAM531EwPcdhneTljGTIJ1W+pP50vhscFTw8FFfwDipB5KIDA36wQYn
	BiZsURUpQvSL0Y5ZBX456ba6XCqGMCY/EnG5kno=
X-Google-Smtp-Source: ABdhPJzXb8qZ74hw7N+WHo8RG9mWCgQryKG+Dq+aV9VBYLvnlICCRjFkSfcNOp4lq06uZySFvKcVSM3OKhDJkRKVbys=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:4d87:: with SMTP id
 cv7mr19182556qvb.49.1600460134116; Fri, 18 Sep 2020 13:15:34 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:29 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-24-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 23/30] drivers/misc/lkdtm: disable LTO for rodata.o
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

Disable LTO for rodata.o to allow objcopy to be used to
manipulate sections.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index c70b3822013f..dd4c936d4d73 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -13,6 +13,7 @@ lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
+CFLAGS_REMOVE_rodata.o		+= $(CC_FLAGS_LTO)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
-- 
2.28.0.681.g6f77f65b4e-goog

