Return-Path: <SRS0=5/Vu=AF=lists.openwall.com=kernel-hardening-return-19123-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800E9C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D8D9420578
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D5jMBEz7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8D9420578
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19123-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1625 invoked by uid 550); 24 Jun 2020 20:33:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1538 invoked from network); 24 Jun 2020 20:33:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wwQ0FnciQOJFFrw9pZwNR1174M1Ii6KWK+Cwx1DZR0E=;
        b=D5jMBEz7Lm5U+UfoGelxUyQqWOYc6Z+dLXzaDR1SoyT3D0mSDtKUxokHJAk6ca9TzV
         4mueVog2jOcmVS+jVjlFOcthTwG/yiHbkE9KBrSSXn5wKv43C8TlR+Cgbt0KoNrOQO9O
         owGlgSWarEMzSBvxtlWzfcQXQKNdv2ZE3V35XOQO9JLobrLz8Yl2Oqg2ofnVQSUcX7cV
         WTnphEXJJam/USPXIaROhEV6UnjgXvvwGpug+fLsCxrQtPsDK3qYgboxAvYEWoFvxtr6
         m6eXCYH8PEMH1MvefhDCIQOQ3Zw+2VmFPtKpPIPHPwUqkF/2Zm2/4J+lIul1mO034S+9
         DBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wwQ0FnciQOJFFrw9pZwNR1174M1Ii6KWK+Cwx1DZR0E=;
        b=kyizcFva3gU2SXhLB+mmXwlkwt72ex2NOlbKk1EwGeTvVxZDCNyZ2ReJ+0leP3paZn
         ytgOkIuJX03srY5C4C3mWtHOs8MSanIVOslbBXuZ+8tU73fb/tN0qrqvhvvJEnL+Ia+S
         fvvtVOsPgH4sw7skbZRyGHQaiU2uY7hFJr4XgJnjJ9UgtH09szHLsJmtXGnsGYvG7MRV
         K/gdgHiJVmwBMoI+/gf+1gCuZx5XRkjvvPL3hzqco71gpaLafhEidwiwuR9cUXYw7A43
         zPfmYXfXRG9n1DUliFBhcYgNt7LTkk8kRDI4JDCXHL/iP13hnWriCsIeYBeGPdtPs/Qu
         QkLw==
X-Gm-Message-State: AOAM531qRFKGKkdUqhL8UrREyauYSxLvXxbfBEPR59ZHN2XU6ftSm5Q2
	XuLAK4o0Z95d6UqApyNgsNJX7QudPC0scZBJaik=
X-Google-Smtp-Source: ABdhPJxdY2l3AI8wfRrd83iTVnOoqT0z2xypmyGa8SBbcpKlWTHBGxwu1psE5fER0U56oerLL9wNd1erMNW/Ru+uB28=
X-Received: by 2002:ad4:4cc1:: with SMTP id i1mr3207160qvz.249.1593030805093;
 Wed, 24 Jun 2020 13:33:25 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:53 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 15/22] drivers/misc/lkdtm: disable LTO for rodata.o
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
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
2.27.0.212.ge8ba1cc988-goog

